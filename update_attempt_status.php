<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

include_once('model/connect.php');

header('Content-Type: application/json; charset=utf-8');

$assessmentId = (int)($_POST['assessment_id'] ?? 0);
$status = (string)($_POST['status'] ?? '');

try {
    $studentId = (int)($_SESSION['userid'] ?? 0);
    $schoolId = (int)($_SESSION['school_id'] ?? 0);
    if (($_SESSION['user_type'] ?? '') !== 'student' || $assessmentId <= 0
        || $studentId <= 0 || $schoolId <= 0 || !in_array($status, ['completed', 'expired'], true)) {
        throw new InvalidArgumentException('Invalid attempt status.');
    }

    $stmt = $conn->prepare(
        "SELECT aa.status
         FROM assessment_attempts aa
         INNER JOIN assessment a ON a.id = aa.assessment_id AND a.school_id = ?
         WHERE aa.assessment_id = ? AND aa.student_id = ?
         ORDER BY aa.id DESC LIMIT 1"
    );
    $stmt->bind_param('iii', $schoolId, $assessmentId, $studentId);
    $stmt->execute();
    $attempt = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    // Submission is now atomic in submit_assessment.php. This compatibility endpoint
    // lets an older cached script confirm completion without changing attempt state.
    if ($attempt && $attempt['status'] === 'completed') {
        unset($_SESSION['viewed_instructions'][$assessmentId]);
        echo json_encode(['success' => true, 'status' => 'completed']);
    } else {
        http_response_code(409);
        echo json_encode(['success' => false, 'message' => 'Submit the assessment to complete this attempt.']);
    }
} catch (Throwable $error) {
    $statusCode = (int)$error->getCode() === 403 ? 403 : 422;
    http_response_code($statusCode);
    echo json_encode(['success' => false, 'message' => $error->getMessage()]);
}
