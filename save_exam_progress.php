<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

include_once('model/connect.php');
include_once('model/assessment_delivery.php');

header('Content-Type: application/json; charset=utf-8');

$assessmentId = (int)($_POST['assessment_id'] ?? 0);
$timeRemaining = max(0, (int)($_POST['time_remaining'] ?? 0));
$lastQuestion = max(1, (int)($_POST['last_question'] ?? 1));
$answers = json_decode((string)($_POST['answers'] ?? ''), true);
$flaggedQuestions = json_decode((string)($_POST['flagged_questions'] ?? '[]'), true);

try {
    if ($assessmentId <= 0 || !is_array($answers) || !is_array($flaggedQuestions)) {
        throw new InvalidArgumentException('Invalid assessment progress.');
    }

    $context = assessment_delivery_require_student($conn, $assessmentId);
    $answersJson = json_encode($answers, JSON_THROW_ON_ERROR);
    $flaggedJson = json_encode(array_values($flaggedQuestions), JSON_THROW_ON_ERROR);

    $stmt = $conn->prepare(
        "UPDATE assessment_attempts
         SET time_remaining = ?, last_question = ?, answers = ?,
             flagged_questions = ?, last_activity = NOW()
         WHERE id = ? AND status = 'in_progress'"
    );
    $stmt->bind_param(
        'iissi',
        $timeRemaining,
        $lastQuestion,
        $answersJson,
        $flaggedJson,
        $context['attempt_id']
    );
    $stmt->execute();
    $stmt->close();

    echo json_encode(['success' => true]);
} catch (Throwable $error) {
    $statusCode = (int)$error->getCode() === 403 ? 403 : 422;
    http_response_code($statusCode);
    error_log('[assessment_timer_progress] ' . $error);
    echo json_encode(['success' => false, 'message' => $error->getMessage()]);
}
