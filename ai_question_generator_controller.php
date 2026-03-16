<?php
session_start();
if (!isset($_SESSION['userid'])) {
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized']);
    exit();
}
include_once("model/connect.php");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
    exit();
}

$userid = $_SESSION['userid'];
$action = $_POST['action'] ?? '';

// Create the usage table if it doesn't exist (fail-safe creation)
    $create_table_sql = "CREATE TABLE IF NOT EXISTS ai_usage_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        usage_date DATE NOT NULL,
        generation_count INT DEFAULT 1,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    )";
    mysqli_query($conn, $create_table_sql);

    // Rate Limiting Logic: Max 5 generations per user per day
    $today = date('Y-m-d');
    
    // Action: Fetch Current Usage (On Modal Open)
    if ($action === 'get_usage_count') {
        $check_stmt = $conn->prepare("SELECT generation_count FROM ai_usage_logs WHERE user_id = ? AND usage_date = ?");
        $check_stmt->bind_param("is", $userid, $today);
        $check_stmt->execute();
        $res = $check_stmt->get_result();
        
        $current_usage = 0;
        if ($row = $res->fetch_assoc()) {
            $current_usage = $row['generation_count'];
        }
        
        echo json_encode(['status' => 'success', 'usage' => $current_usage, 'limit' => 5]);
        exit();
    }
    
    // Action: Generate Questions
    if ($action === 'generate_questions') {
        $topic = $_POST['topic'] ?? '';
        $difficulty = $_POST['difficulty'] ?? 'Medium';
        $num_questions = intval($_POST['num_questions'] ?? 3);

        if (empty($topic)) {
            echo json_encode(['status' => 'error', 'message' => 'Topic is required']);
            exit();
        }
        
        if ($num_questions < 1 || $num_questions > 5) {
            $num_questions = 3;
        }

        // Check today's usage for this user before calling API
        $check_stmt = $conn->prepare("SELECT generation_count FROM ai_usage_logs WHERE user_id = ? AND usage_date = ?");
        $check_stmt->bind_param("is", $userid, $today);
        $check_stmt->execute();
        $res = $check_stmt->get_result();
        
        $current_usage = 0;
        if ($row = $res->fetch_assoc()) {
            $current_usage = $row['generation_count'];
        }
        
        if ($current_usage >= 5) {
            echo json_encode(['status' => 'error', 'message' => 'Daily limit reached. You can only generate questions with AI 5 times per day.']);
            exit();
        }

    $groq_api_key = "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";
    $model = "qwen/qwen3-32b"; 

    $system_prompt = "You are an expert teacher. Generate multiple choice questions.
You must return your response as a valid JSON object with a single key 'questions' which is an array of questions.
Each question object in the array must have:
- 'question': The question text string.
- 'options': An array of exactly 4 objects.
Each option object must have:
- 'text': The option text string.
- 'is_correct': boolean (exactly one option must be true, the others false).

If you use math, simply use standard LaTeX syntax inside \$ (inline) or \$\$ (block) identifiers.
Provide NO OTHER TEXT, NO EXPLANATIONS, AND NO INTRODUCTIONS. Output ONLY valid JSON.";

    $user_prompt = "Generate $num_questions multiple-choice question(s) on the topic: \"$topic\" at a \"$difficulty\" level.";

    $data = [
        "model" => $model,
        "messages" => [
            [
                "role" => "system",
                "content" => $system_prompt
            ],
            [
                "role" => "user",
                "content" => $user_prompt
            ]
        ],
        "temperature" => 0.7,
        "response_format" => ["type" => "json_object"]
    ];

    $ch = curl_init("https://api.groq.com/openai/v1/chat/completions");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
    curl_setopt($ch, CURLOPT_HTTPHEADER, [
        "Content-Type: application/json",
        "Authorization: Bearer " . $groq_api_key
    ]);

    $response = curl_exec($ch);
    
    if (curl_errno($ch)) {
        echo json_encode(['status' => 'error', 'message' => 'cURL Error: ' . curl_error($ch)]);
        curl_close($ch);
        exit();
    }
    
    $http_status = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);

    if ($http_status >= 400) {
        $err = json_decode($response, true);
        $msg = isset($err['error']['message']) ? $err['error']['message'] : 'API provider error';
        if (empty($msg) && !empty($response)) {
             $msg = substr($response, 0, 100) . '...';
        }
        echo json_encode(['status' => 'error', 'message' => "Groq returned an error: $msg"]);
        exit();
    }

    $result = json_decode($response, true);
    
    if (isset($result['choices'][0]['message']['content'])) {
        $json_content = trim($result['choices'][0]['message']['content']);
        
        // Enhanced cleanup to forcefully extract JSON if the AI includes conversational padding
        $json_content = trim($json_content);
        
        // 1. Remove markdown formatting if present
        if (preg_match('/```(?:json)?\s*(.*?)\s*```/s', $json_content, $matches)) {
            $json_content = trim($matches[1]);
        }
        
        // 2. Fallback: try to extract just the JSON part between `{` and `}` (or `[` and `]`)
        if (strpos($json_content, '{') !== false && strpos($json_content, '}') !== false) {
            $json_content = substr($json_content, strpos($json_content, '{'), strrpos($json_content, '}') - strpos($json_content, '{') + 1);
        } elseif (strpos($json_content, '[') !== false && strpos($json_content, ']') !== false) {
            $json_content = substr($json_content, strpos($json_content, '['), strrpos($json_content, ']') - strpos($json_content, '[') + 1);
        }

        // --- NEW: Heuristic Regex Fallback for AI ignoring MathQuill formatting instructions ---
        // If the AI outputs \$ math \$ or $$ math $$, or \\[ math \\], we manually convert it to the required MathQuill string.
        // We use regex to find these patterns and replace them globally before parsing JSON. Note we have to manually double-escape the backslashes 
        // in the generated injected string since it is going to be parsed by json_decode.
        
        // 1. Replace bracket matches: \[ math \] or \( math \)
        $json_content = preg_replace_callback('/(?:\\\\\[|\\\\\()(.*?)(?:\\\\\]|\\\\\))/s', function($m) {
            $latex = trim($m[1]);
            // Escape any existing backslashes in the latex for JSON safety
            $latex = str_replace('\\', '\\\\', $latex);
            // Also escape " if it somehow exists
            $latex = str_replace('"', '\\"', $latex);
            return '<span contenteditable=\"false\" class=\"math-editor-rendered\" data-latex=\"' . $latex . '\"></span>';
        }, $json_content);

        // 2. Replace dollar matches: $$ math $$ or $ math $
        $json_content = preg_replace_callback('/(?<!\\\\)\$\$(.*?)(?<!\\\\)\$\$|(?<!\\\\)\$(.*?)(?<!\\\\)\$/s', function($m) {
            $latex = trim(!empty($m[1]) ? $m[1] : $m[2]);
            // Escape any existing backslashes in the latex for JSON safety
            $latex = str_replace('\\', '\\\\', $latex);
            // Also escape " if it somehow exists
            $latex = str_replace('"', '\\"', $latex);
            return '<span contenteditable=\"false\" class=\"math-editor-rendered\" data-latex=\"' . $latex . '\"></span>';
        }, $json_content);
        // ----------------------------------------------------------------------------------------

        $parsed = json_decode($json_content, true);
        
        // Try to fix common trailing comma errors if json_decode fails
        if ($parsed === null && json_last_error() !== JSON_ERROR_NONE) {
            $json_content = preg_replace('/,\s*([\]}])/m', '$1', $json_content);
            $parsed = json_decode($json_content, true);
        }

        if ($parsed === null) {
            // Include the raw snippet for debugging in the message
            $snippet = htmlspecialchars(substr($json_content, 0, 150));
            echo json_encode(['status' => 'error', 'message' => "Failed to parse AI response. Invalid JSON. Raw output snippet: $snippet..."]);
        } else {
            $success_data = null;
            if (isset($parsed['questions']) && is_array($parsed['questions'])) {
                $success_data = $parsed['questions'];
            } else if (is_array($parsed)) {
                $success_data = $parsed;
            } 
            
            if ($success_data !== null) {
                // Log successful usage
                $new_usage = $current_usage + 1;
                if ($current_usage == 0) {
                    $log_stmt = $conn->prepare("INSERT INTO ai_usage_logs (user_id, usage_date, generation_count) VALUES (?, ?, ?)");
                    $log_stmt->bind_param("isi", $userid, $today, $new_usage);
                    $log_stmt->execute();
                } else {
                    $log_stmt = $conn->prepare("UPDATE ai_usage_logs SET generation_count = ? WHERE user_id = ? AND usage_date = ?");
                    $log_stmt->bind_param("iis", $new_usage, $userid, $today);
                    $log_stmt->execute();
                }

                echo json_encode(['status' => 'success', 'data' => $success_data, 'usage' => $new_usage]);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'AI response was parsed but missing expected questions array.']);
            }
        }
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Invalid response from AI provider.']);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request']);
}
