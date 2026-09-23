<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

include_once('model/connect.php');
include_once('model/assessment_delivery.php');

header('Content-Type: application/json; charset=utf-8');
mysqli_set_charset($conn, 'utf8mb4');

$assessmentId = (int)($_POST['assessment_id'] ?? 0);
$questionId = (int)($_POST['question_id'] ?? 0);
$questionNumber = (int)($_POST['question_num'] ?? 0);

try {
    if ($assessmentId <= 0) {
        throw new InvalidArgumentException('Missing or invalid question parameters.');
    }

    $context = assessment_delivery_require_student($conn, $assessmentId);

    // Supports a cached copy of the former JavaScript during a rolling deployment.
    if ($questionId <= 0 && $questionNumber > 0) {
        $questionIds = assessment_delivery_question_ids($conn, $context);
        $questionId = (int)($questionIds[$questionNumber - 1] ?? 0);
    }

    if ($questionId <= 0) {
        throw new InvalidArgumentException('Missing or invalid question parameters.');
    }

    $question = assessment_delivery_find_question($conn, $context, $questionId);

    if (!$question) {
        http_response_code(404);
        echo json_encode(['success' => false, 'message' => 'Question not found.']);
        exit;
    }

    echo json_encode($question, JSON_UNESCAPED_UNICODE);
} catch (Throwable $error) {
    $statusCode = in_array((int)$error->getCode(), [403, 404], true) ? (int)$error->getCode() : 422;
    http_response_code($statusCode);
    echo json_encode(['success' => false, 'message' => $error->getMessage()]);
}
