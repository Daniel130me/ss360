<?php
session_start();
include_once("model/connect.php");

header('Content-Type: application/json');

$assessment_id = $_POST['assessment_id'];
$student_id = $_SESSION['userid'];
$time_remaining = $_POST['time_remaining'];
$last_question = $_POST['last_question'];
$answers = $_POST['answers'];
$flagged_questions = $_POST['flagged_questions'];

$sql = "UPDATE assessment_attempts 
        SET time_remaining = ?,
            last_question = ?,
            answers = ?,
            flagged_questions = ?,
            last_activity = NOW()
        WHERE assessment_id = ? 
        AND student_id = ? 
        AND status = 'in_progress'";

$stmt = mysqli_prepare($conn, $sql);
mysqli_stmt_bind_param($stmt, "iissii", 
    $time_remaining, 
    $last_question, 
    $answers, 
    $flagged_questions, 
    $assessment_id, 
    $student_id
);

$success = mysqli_stmt_execute($stmt);
echo json_encode(['success' => $success]);
