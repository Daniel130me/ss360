<?php
date_default_timezone_set('Africa/Lagos'); // Set the timezone to Lagos
// echo date("Y:m:d H-i-s");
session_start();
include_once("model/connect.php");

header('Content-Type: application/json');

$assessment_id = $_POST['assessment_id'];
$student_id = $_SESSION['userid'];

// Check for existing attempt
$sql = "SELECT * FROM assessment_attempts 
        WHERE assessment_id = ? 
        AND student_id = ? 
        AND status = 'in_progress'";

$stmt = mysqli_prepare($conn, $sql);
mysqli_stmt_bind_param($stmt, "ii", $assessment_id, $student_id);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

if ($attempt = mysqli_fetch_assoc($result)) {
    // Check if attempt has expired due to inactivity (30 minutes)
    $last_activity = strtotime($attempt['last_activity']);
  
    $rdate = $last_activity+(7*60*60);
  
    if ($rdate >= 0) {
        
        if (time() -  $rdate > 1800) {
            // echo (time() - $rdate);
            mysqli_query($conn, "UPDATE assessment_attempts 
                          SET status = 'expired' 
                          WHERE id = {$attempt['id']}");
            echo json_encode([
                'success' => false,
                'message' => 'Attempt expired due to inactivity'
            ]);
            exit;
        }
    }

    echo json_encode([
        'success' => true,
        'time_remaining' => $attempt['time_remaining'],
        'last_question' => $attempt['last_question'],
        'answers' => $attempt['answers'],
        'flagged_questions' => $attempt['flagged_questions']
    ]);
} else {
    // Create new attempt
    $assessment_sql = "SELECT duration FROM assessment WHERE id = ?";
    $stmt = mysqli_prepare($conn, $assessment_sql);
    mysqli_stmt_bind_param($stmt, "i", $assessment_id);
    mysqli_stmt_execute($stmt);
    $assessment = mysqli_fetch_assoc(mysqli_stmt_get_result($stmt));

    $duration_seconds = $assessment['duration'] * 60;

    mysqli_query($conn, "INSERT INTO assessment_attempts 
                       (assessment_id, student_id, start_time, time_remaining, last_activity) 
                       VALUES ($assessment_id, $student_id, NOW(), $duration_seconds, NOW())");

    echo json_encode([
        'success' => true,
        'time_remaining' => $duration_seconds,
        'last_question' => 1,
        'answers' => '{}',
        'flagged_questions' => '[]'
    ]);
}
