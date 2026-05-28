<?php
session_start();
header('Content-Type: application/json');

if (!isset($_SESSION['userid'])) {
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized']);
    exit;
}

include_once("model/connect.php");
include_once("model/ai_usage.php");
include_once("model/student_ai_context.php");
include_once("model/ai_client.php");

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
    exit;
}

function ss360_ai_clean_text($value, $limit = 1000)
{
    $value = trim(strip_tags((string)$value));
    $value = str_replace(["\\r\\n", "\\n", "\\r"], "\n", $value);
    if (strlen($value) > $limit) {
        $value = substr($value, 0, $limit);
    }
    return $value;
}

function ss360_get_short_history($history_json)
{
    $history = json_decode((string)$history_json, true);
    if (!is_array($history)) {
        return [];
    }

    $history = array_slice($history, -6);
    $clean = [];
    foreach ($history as $item) {
        $role = ($item['role'] ?? '') === 'assistant' ? 'assistant' : 'user';
        $content = ss360_ai_clean_text($item['content'] ?? '', 700);
        if ($content !== '') {
            $clean[] = ['role' => $role, 'content' => $content];
        }
    }
    return $clean;
}

function ss360_student_ai_cache_key($school_id, $student_id, $class_id, $session_id, $term_id)
{
    return implode(':', [
        (int)$school_id,
        (int)$student_id,
        (int)$class_id,
        (int)$session_id,
        preg_replace('/[^a-zA-Z0-9_-]/', '', (string)$term_id),
    ]);
}

function ss360_get_cached_student_ai_context($conn, $school_id, $student_id, $class_id, $session_id, $term_id)
{
    $cache_key = ss360_student_ai_cache_key($school_id, $student_id, $class_id, $session_id, $term_id);
    $cache_ttl = 600;

    if (!isset($_SESSION['student_ai_context_cache']) || !is_array($_SESSION['student_ai_context_cache'])) {
        $_SESSION['student_ai_context_cache'] = [];
    }

    $cached = $_SESSION['student_ai_context_cache'][$cache_key] ?? null;
    if (is_array($cached) && isset($cached['created_at'], $cached['context']) && (time() - (int)$cached['created_at']) <= $cache_ttl) {
        return ['status' => 'success', 'context' => $cached['context'], 'cache' => 'hit'];
    }

    $context_result = ss360_build_student_ai_context_base($conn, $school_id, $student_id, $class_id, $session_id, $term_id);
    if ($context_result['status'] !== 'success') {
        return $context_result;
    }

    $_SESSION['student_ai_context_cache'][$cache_key] = [
        'created_at' => time(),
        'context' => $context_result['context'],
    ];

    if (count($_SESSION['student_ai_context_cache']) > 8) {
        uasort($_SESSION['student_ai_context_cache'], function ($a, $b) {
            return ($a['created_at'] ?? 0) <=> ($b['created_at'] ?? 0);
        });
        $_SESSION['student_ai_context_cache'] = array_slice($_SESSION['student_ai_context_cache'], -8, null, true);
    }

    return ['status' => 'success', 'context' => $context_result['context'], 'cache' => 'miss'];
}

$action = $_POST['action'] ?? '';
if ($action === 'get_usage_count') {
    $usage = ss360_ai_usage_get($conn, intval($_SESSION['userid']));
    echo json_encode([
        'status' => 'success',
        'usage' => $usage['used'],
        'limit' => $usage['limit'],
        'remaining' => $usage['remaining'],
    ]);
    exit;
}

if ($action !== 'chat') {
    echo json_encode(['status' => 'error', 'message' => 'Invalid action']);
    exit;
}

$student_id = intval($_POST['student_id'] ?? 0);
$class_id = intval($_POST['class_id'] ?? 0);
$session_id = intval($_POST['session_id'] ?? 0);
$term_id = ss360_ai_clean_text($_POST['term_id'] ?? 'summary', 20);
$message = ss360_ai_clean_text($_POST['message'] ?? '', 1200);
$school_id = intval($_SESSION['school_id']);
$user_id = intval($_SESSION['userid']);

if ($student_id <= 0 || $class_id <= 0 || $session_id <= 0 || $message === '') {
    echo json_encode(['status' => 'error', 'message' => 'Student, class, session, and message are required.']);
    exit;
}

$usage_check = ss360_ai_usage_can_consume($conn, $user_id, 1);
if (!$usage_check['allowed']) {
    echo json_encode([
        'status' => 'error',
        'message' => 'Daily AI limit reached. Please try again tomorrow',
        'usage' => $usage_check['used'],
        'limit' => $usage_check['limit'],
        'remaining' => $usage_check['remaining'],
    ]);
    exit;
}

$context_result = ss360_get_cached_student_ai_context($conn, $school_id, $student_id, $class_id, $session_id, $term_id);
if ($context_result['status'] !== 'success') {
    echo json_encode($context_result);
    exit;
}
$context_result['context'] = ss360_filter_context_for_question($context_result['context'], $message);

$history = ss360_get_short_history($_POST['history'] ?? '[]');

$system_prompt = "You are SS360 AI Assistant, an evidence-based academic performance partner for teachers and school administrators.
Use only the provided objective score and online assessment context.
Do not use or request attendance, teacher comments, principal comments, behaviour, psychomotor skills, parent details, or private contact details.
Do not invent data. If evidence is missing, say so briefly.
Be conversational, practical, and suggestive.
Format reply for readability with short paragraphs and simple bullet lists.
Use section labels such as \"Quick summary\", \"Strengths\", \"Concerns\", and \"Recommended next steps\" when useful.
Use Markdown-style bold only for important subject names or section labels.
Return ONLY valid JSON. The first non-whitespace character must be { and the last must be }.
Do not write Markdown outside the JSON object. Put the full staff-facing Markdown text inside the reply string.
Use escaped newlines inside JSON strings when you need paragraphs or bullet lists.
Return exactly this JSON shape:
{
  \"reply\": \"staff-facing response\",
  \"suggested_prompts\": [\"short next question\", \"short next question\", \"short next question\"],
  \"insights\": {
    \"strengths\": [],
    \"weaknesses\": [],
    \"trends\": [],
    \"recommendations\": []
  }
}";

$messages = [
    ['role' => 'system', 'content' => $system_prompt],
    ['role' => 'user', 'content' => 'Student analysis context JSON: ' . json_encode($context_result['context'])],
];

foreach ($history as $item) {
    $messages[] = $item;
}

$messages[] = ['role' => 'user', 'content' => $message];

$ai_result = ss360_ai_chat_json($conn, $messages, 0.35, [
    'response_format_json' => true,
    'recover_failed_generation' => true,
]);
if ($ai_result['status'] !== 'success') {
    echo json_encode([
        'status' => 'temporary_error',
        'message' => 'We cannot process this request at this time. Please try again in a few minutes.',
        'debug_message' => $ai_result['message'] ?? 'Unknown AI provider error.',
        'debug' => [
            'http_status' => $ai_result['http_status'] ?? null,
            'provider_debug' => $ai_result['debug'] ?? null,
        ],
        'suggested_prompts' => [
            'Summarize this student performance',
            'What are the strongest subjects?',
            'Where is the student declining?',
            'Suggest intervention steps',
        ],
    ]);
    exit;
}

$data = $ai_result['data'];
$reply = ss360_ai_clean_text($data['reply'] ?? '', 6000);
if ($reply === '') {
    $reply = 'I could not generate a useful response from the available score evidence. Try asking about strengths, weak subjects, or term trends.';
}

$suggested = $data['suggested_prompts'] ?? [];
if (!is_array($suggested) || empty($suggested)) {
    $suggested = [
        'What are the strongest subjects?',
        'Where is the student declining?',
        'Suggest practical intervention steps',
    ];
}
$suggested = array_slice(array_values(array_map(function ($item) {
    return ss360_ai_clean_text($item, 90);
}, $suggested)), 0, 4);

$usage = ss360_ai_usage_record_success($conn, $user_id, 1);

echo json_encode([
    'status' => 'success',
    'reply' => $reply,
    'suggested_prompts' => $suggested,
    'insights' => is_array($data['insights'] ?? null) ? $data['insights'] : [],
    'usage' => [
        'count' => $usage['used'],
        'limit' => $usage['limit'],
        'remaining' => $usage['remaining'],
    ],
]);
