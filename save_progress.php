<?php
session_start();
include_once("model/connect.php");

header('Content-Type: application/json');

if (!isset($_POST['assessment_id']) || !isset($_POST['answers'])) {
    echo json_encode(['success' => false, 'message' => 'Missing parameters']);
    exit;
}

$assessment_id = (int)$_POST['assessment_id'];
$student_id = $_SESSION['userid'];
$answers = json_decode($_POST['answers'], true);
$flagged = isset($_POST['flagged']) ? json_decode($_POST['flagged'], true) : [];

// Check if progress exists
$check_sql = "SELECT id FROM assessment_progress 
              WHERE assessment_id = ? AND student_id = ?";
$stmt = mysqli_prepare($conn, $check_sql);
mysqli_stmt_bind_param($stmt, "ii", $assessment_id, $student_id);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

if (mysqli_num_rows($result) > 0) {
    // Update existing progress
    $sql = "UPDATE assessment_progress SET 
            answers = ?,
            flagged = ?,
            last_updated = NOW()
            WHERE assessment_id = ? AND student_id = ?";
} else {
    // Insert new progress
    $sql = "INSERT INTO assessment_progress 
            (assessment_id, student_id, answers, flagged, created_at, last_updated)
            VALUES (?, ?, ?, ?, NOW(), NOW())";
}

$stmt = mysqli_prepare($conn, $sql);
$answers_json = json_encode($answers);
$flagged_json = json_encode($flagged);

if (mysqli_num_rows($result) > 0) {
    mysqli_stmt_bind_param($stmt, "ssii", $answers_json, $flagged_json, $assessment_id, $student_id);
} else {
    mysqli_stmt_bind_param($stmt, "iiss", $assessment_id, $student_id, $answers_json, $flagged_json);
}
// update last activity
$update_sql = "UPDATE assessment_attempts 
                   SET last_activity = NOW() 
                   WHERE assessment_id = ? AND student_id = ?";
$stmt = mysqli_prepare($conn, $update_sql);
mysqli_stmt_bind_param($stmt, "ii", $assessment_id, $student_id);
mysqli_stmt_execute($stmt);


$success = mysqli_stmt_execute($stmt);
echo json_encode(['success' => $success]);
