<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

include_once('model/connect.php');
include_once('model/assessment_delivery.php');

header('Content-Type: application/json; charset=utf-8');

$assessmentId = (int)($_POST['assessment_id'] ?? 0);
$answers = json_decode((string)($_POST['answers'] ?? ''), true);
$flaggedQuestions = json_decode((string)($_POST['flagged'] ?? '[]'), true);

try {
    if ($assessmentId <= 0 || !is_array($answers) || !is_array($flaggedQuestions)) {
        throw new InvalidArgumentException('Invalid assessment progress.');
    }

    $context = assessment_delivery_require_student($conn, $assessmentId);
    $answersJson = json_encode($answers, JSON_THROW_ON_ERROR);
    $flaggedJson = json_encode(array_values($flaggedQuestions), JSON_THROW_ON_ERROR);

    $conn->begin_transaction();

    // The attempt row is the source used by resume; update it immediately after every answer.
    $attemptStmt = $conn->prepare(
        "UPDATE assessment_attempts
         SET answers = ?, flagged_questions = ?, last_activity = NOW()
         WHERE id = ? AND status = 'in_progress'"
    );
    $attemptStmt->bind_param('ssi', $answersJson, $flaggedJson, $context['attempt_id']);
    $attemptStmt->execute();
    $attemptStmt->close();

    // Keep the legacy progress table synchronized for existing reports and recovery tools.
    $progressStmt = $conn->prepare(
        "INSERT INTO assessment_progress
            (assessment_id, student_id, answers, flagged, created_at, last_updated)
         VALUES (?, ?, ?, ?, NOW(), NOW())
         ON DUPLICATE KEY UPDATE
            answers = VALUES(answers),
            flagged = VALUES(flagged),
            last_updated = NOW()"
    );
    $progressStmt->bind_param(
        'iiss',
        $assessmentId,
        $context['student_id'],
        $answersJson,
        $flaggedJson
    );
    $progressStmt->execute();
    $progressStmt->close();

    $conn->commit();
    echo json_encode(['success' => true]);
} catch (Throwable $error) {
    try {
        $conn->rollback();
    } catch (Throwable $ignored) {
    }

    $statusCode = (int)$error->getCode() === 403 ? 403 : 422;
    http_response_code($statusCode);
    error_log('[assessment_progress] ' . $error);
    echo json_encode(['success' => false, 'message' => $error->getMessage()]);
}
