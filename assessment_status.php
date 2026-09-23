<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}
if (($_SESSION['user_type'] ?? '') !== 'student' || !isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");

$assessment_id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
$message_type = in_array($_GET['type'] ?? '', ['completed', 'expired', 'unauthorized'], true)
    ? $_GET['type']
    : '';
$student_id = (int)$_SESSION['userid'];
$school_id = (int)($_SESSION['school_id'] ?? 0);

// Scope the page to the authenticated student's school and assigned class.
$assessmentStmt = $conn->prepare(
    "SELECT a.id, a.assessment_type, s.subject
     FROM assessment a
     JOIN subjects s ON a.subject_id = s.id
     JOIN students st ON st.id = ? AND st.school_id = a.school_id
     WHERE a.id = ? AND a.school_id = ?
       AND FIND_IN_SET(st.class_id, REPLACE(a.class_ids, ' ', ''))
     LIMIT 1"
);
$assessmentStmt->bind_param('iii', $student_id, $assessment_id, $school_id);
$assessmentStmt->execute();
$assessment = $assessmentStmt->get_result()->fetch_assoc();
$assessmentStmt->close();
if (!$assessment) {
    http_response_code(404);
    exit('Assessment not found.');
}

// Get student's result/attempt status
$statusStmt = $conn->prepare(
    "SELECT r.*, a.start_time, a.status AS attempt_status
               FROM assessment_attempts a
               LEFT JOIN assessment_results r 
                    ON r.assessment_id = a.assessment_id 
                    AND r.student_id = a.student_id
               WHERE a.assessment_id = ? AND a.student_id = ?
               ORDER BY a.id DESC LIMIT 1"
);
$statusStmt->bind_param('ii', $assessment_id, $student_id);
$statusStmt->execute();
$status = $statusStmt->get_result()->fetch_assoc() ?: [];
$statusStmt->close();
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Assessment Status</title>
    <link rel="stylesheet" href="../dist/css/adminlte.min.css">
    <style>
        .status-card {
            max-width: 600px;
            margin: 50px auto;
            text-align: center;
        }
    </style>
</head>

<body class="hold-transition">
    <div class="container d-flex align-items-center justify-content-center text-center flex-column" style="height: 90vh;">
        <?php if ($message_type === 'completed'):
            if (isset($_SESSION['viewed_instructions'][$assessment_id])) {
                unset($_SESSION['viewed_instructions'][$assessment_id]);
            }
        ?>
            <i class="fas fa-check-circle text-success" style="font-size: 48px;"></i>
            <h1 class="font-weight-bold mt-3">Assessment Completed!</h1>
            <p>You have successfully completed the <?= htmlspecialchars($assessment['subject']) ?> assessment.</p>
            <!-- <p>Score: <= $status['score'] ?>/<= $status['total_questions'] ?> (<= $status['percentage_score'] ?>%)</p> -->
            <?php if (!empty($status['submitted_at'])): ?>
                <p>Submitted on: <?= date('F j, Y g:i A', strtotime($status['submitted_at'])) ?></p>
            <?php endif; ?>

        <?php elseif ($message_type === 'expired'):
            if (isset($_SESSION['viewed_instructions'][$assessment_id])) {
                unset($_SESSION['viewed_instructions'][$assessment_id]);
            }
        ?>
            <i class="fas fa-clock text-warning" style="font-size: 48px;"></i>
            <h1 class="font-weight-bold mt-3">Assessment Time Expired</h1>
            <p>The time allocated for this assessment has ended.</p>

        <?php elseif ($message_type === 'unauthorized'):
            if (isset($_SESSION['viewed_instructions'][$assessment_id])) {
                unset($_SESSION['viewed_instructions'][$assessment_id]);
            }
        ?>
            <i class="fas fa-exclamation-triangle text-danger" style="font-size: 48px;"></i>
            <h1 class="font-weight-bold mt-3">Unauthorized Access</h1>
            <p>You are not authorized to take this assessment.</p>

        <?php endif; ?>
        <?php if ($assessment['assessment_type'] == '1'): ?>
            <div class="mt-4">
                <a href="student_portal" class="btn btn-primary">Return to Portal</a>
            </div>
        <?php endif; ?>
        <a href="logout" class="btn btn-danger mt-4">Logout</a>
    </div>
</body>

</html>
