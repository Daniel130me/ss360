<?php
date_default_timezone_set('Africa/Lagos');
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

include_once('model/connect.php');
include_once('model/assessment_delivery.php');

header('Content-Type: application/json; charset=utf-8');

$assessmentId = (int)($_POST['assessment_id'] ?? 0);

try {
    if ($assessmentId <= 0) {
        throw new InvalidArgumentException('Invalid assessment.');
    }

    $context = assessment_delivery_require_student($conn, $assessmentId);
    $stmt = $conn->prepare(
        "SELECT time_remaining, last_question, answers, flagged_questions
         FROM assessment_attempts
         WHERE id = ? AND status = 'in_progress'
         LIMIT 1"
    );
    $stmt->bind_param('i', $context['attempt_id']);
    $stmt->execute();
    $attempt = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    if (!$attempt) {
        throw new RuntimeException('No active assessment attempt was found.', 403);
    }

    echo json_encode([
        'success' => true,
        'time_remaining' => max(0, (int)$attempt['time_remaining']),
        'last_question' => max(1, (int)$attempt['last_question']),
        'answers' => $attempt['answers'] ?: '{}',
        'flagged_questions' => $attempt['flagged_questions'] ?: '[]',
    ]);
} catch (Throwable $error) {
    $statusCode = (int)$error->getCode() === 403 ? 403 : 422;
    http_response_code($statusCode);
    echo json_encode(['success' => false, 'message' => $error->getMessage()]);
}
