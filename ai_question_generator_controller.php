<?php
session_start();
if (!isset($_SESSION['userid'])) {
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized']);
    exit();
}
include_once("model/connect.php");
include_once("model/ai_usage.php");
include_once("model/ai_client.php");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
    exit();
}

$userid = $_SESSION['userid'];
$action = $_POST['action'] ?? '';

function ai_convert_latex_to_math_spans(&$parsed)
{
    array_walk_recursive($parsed, function (&$value) {
        if (!is_string($value)) {
            return;
        }

        $value = preg_replace_callback('/(?:\\\\\[|\\\\\()(.*?)(?:\\\\\]|\\\\\))/s', function($m) {
            $latex = trim($m[1]);
            $latex = str_replace('\\', '\\\\', $latex);
            $latex = str_replace('"', '\\"', $latex);
            return '<span contenteditable="false" class="math-editor-rendered" data-latex="' . $latex . '"></span>';
        }, $value);

        $value = preg_replace_callback('/(?<!\\\\)\$\$(.*?)(?<!\\\\)\$\$|(?<!\\\\)\$(.*?)(?<!\\\\)\$/s', function($m) {
            $latex = trim(!empty($m[1]) ? $m[1] : $m[2]);
            $latex = str_replace('\\', '\\\\', $latex);
            $latex = str_replace('"', '\\"', $latex);
            return '<span contenteditable="false" class="math-editor-rendered" data-latex="' . $latex . '"></span>';
        }, $value);
    });
}

    // Shared AI quota: assessment question generation and student assistant chats use the same daily row.
    
    // Action: Fetch Current Usage (On Modal Open)
    if ($action === 'get_usage_count') {
        $usage = ss360_ai_usage_get($conn, $userid);

        echo json_encode([
            'status' => 'success',
            'usage' => $usage['used'],
            'limit' => $usage['limit'],
            'remaining' => $usage['remaining'],
        ]);
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

        $usage = ss360_ai_usage_can_consume($conn, $userid, $num_questions);
        if (!$usage['allowed']) {
            echo json_encode([
                'status' => 'error',
                'message' => 'Daily AI limit reached. You have ' . $usage['remaining'] . ' use(s) left today, but this request needs ' . $num_questions . '.',
                'usage' => $usage['used'],
                'limit' => $usage['limit'],
                'remaining' => $usage['remaining'],
            ]);
            exit();
        }

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

    $ai_result = ss360_ai_chat_json($conn, [
        ['role' => 'system', 'content' => $system_prompt],
        ['role' => 'user', 'content' => $user_prompt],
    ], 0.7, [
        'response_format_json' => true,
        'recover_failed_generation' => false,
    ]);

    if ($ai_result['status'] === 'success') {
        $parsed = $ai_result['data'];
        
        ai_convert_latex_to_math_spans($parsed);

        if ($parsed === null) {
            echo json_encode(['status' => 'error', 'message' => 'Failed to parse AI response. Invalid JSON.']);
        } else {
            $success_data = null;
            if (isset($parsed['questions']) && is_array($parsed['questions'])) {
                $success_data = $parsed['questions'];
            } else if (is_array($parsed)) {
                $success_data = $parsed;
            } 
            
            if ($success_data !== null) {
                // Count every generated question as one shared AI usage.
                $usage_units = max(1, count($success_data));
                $new_usage = ss360_ai_usage_record_success($conn, $userid, $usage_units);

                echo json_encode([
                    'status' => 'success',
                    'data' => $success_data,
                    'usage' => $new_usage['used'],
                    'limit' => $new_usage['limit'],
                    'remaining' => $new_usage['remaining'],
                ]);
            } else {
                echo json_encode(['status' => 'error', 'message' => 'AI response was parsed but missing expected questions array.']);
            }
        }
    } else {
        echo json_encode([
            'status' => 'error',
            'message' => 'AI providers failed to generate questions. Please try again.',
            'debug_message' => $ai_result['message'] ?? 'Unknown AI gateway error.',
            'debug' => $ai_result['debug'] ?? null,
        ]);
    }
    } else if ($action === 'regenerate_question') {
        $context = trim((string)($_POST['context'] ?? ''));
        $difficulty = $_POST['difficulty'] ?? 'Medium';

        if ($context === '') {
            echo json_encode(['status' => 'error', 'message' => 'Rewrite context is required.']);
            exit();
        }

        if (!in_array($difficulty, ['Easy', 'Medium', 'Hard'], true)) {
            $difficulty = 'Medium';
        }

        $usage = ss360_ai_usage_can_consume($conn, $userid, 1);
        if (!$usage['allowed']) {
            echo json_encode([
                'status' => 'error',
                'message' => 'Daily AI limit reached. You have ' . $usage['remaining'] . ' use(s) left today.',
                'usage' => $usage['used'],
                'limit' => $usage['limit'],
                'remaining' => $usage['remaining'],
            ]);
            exit();
        }

        $system_prompt = "You are an expert teacher rewriting one multiple-choice assessment question.
Return only valid JSON with this exact shape:
{
  \"question\": \"Question text\",
  \"options\": [
    {\"text\": \"Option text\", \"is_correct\": true},
    {\"text\": \"Option text\", \"is_correct\": false},
    {\"text\": \"Option text\", \"is_correct\": false},
    {\"text\": \"Option text\", \"is_correct\": false}
  ]
}
Rules:
- Generate exactly one question.
- Generate exactly four options.
- Exactly one option must be correct.
- Respect the teacher's rewrite context and requested difficulty.
- Preserve useful formatting where needed.
- If you use math, use standard LaTeX inside \$...\$ or \$\$...\$\$.
- Do not include explanations, markdown fences, or extra text.";

        $user_prompt = "Rewrite/regenerate this assessment question at a \"$difficulty\" level using the teacher's context below.\n\nTeacher context:\n$context";

        $ai_result = ss360_ai_chat_json($conn, [
            ['role' => 'system', 'content' => $system_prompt],
            ['role' => 'user', 'content' => $user_prompt],
        ], 0.7, [
            'response_format_json' => true,
            'recover_failed_generation' => false,
        ]);

        if ($ai_result['status'] !== 'success') {
            echo json_encode([
                'status' => 'error',
                'message' => 'AI providers failed to regenerate the question. Please try again.',
                'debug_message' => $ai_result['message'] ?? 'Unknown AI gateway error.',
            ]);
            exit();
        }

        $parsed = $ai_result['data'];
        if (isset($parsed['questions'][0]) && is_array($parsed['questions'][0])) {
            $parsed = $parsed['questions'][0];
        }

        ai_convert_latex_to_math_spans($parsed);

        $options = $parsed['options'] ?? [];
        $correct_count = 0;
        foreach ($options as $option) {
            if (!empty($option['is_correct']) || (!empty($option['answer']) && (int)$option['answer'] === 1)) {
                $correct_count++;
            }
        }

        if (empty($parsed['question']) || !is_array($options) || count($options) !== 4 || $correct_count !== 1) {
            echo json_encode(['status' => 'error', 'message' => 'AI response did not contain one valid question with exactly four options and one correct answer.']);
            exit();
        }

        $new_usage = ss360_ai_usage_record_success($conn, $userid, 1);
        echo json_encode([
            'status' => 'success',
            'data' => $parsed,
            'usage' => $new_usage['used'],
            'limit' => $new_usage['limit'],
            'remaining' => $new_usage['remaining'],
        ]);
    } else {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request']);
}
