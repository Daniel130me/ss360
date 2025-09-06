<?php
session_start();
include_once("model/connect.php");

if (!isset($_SESSION['userid']) || $_SESSION['user_type'] !== 'student') {
    if(isset($_SESSION['viewed_instructions'][$assessment_id])) {
        unset($_SESSION['viewed_instructions'][$assessment_id]);
    }
    die(json_encode(['success' => false, 'message' => 'Unauthorized']));
}

$assessment_id = isset($_POST['assessment_id']) ? (int)$_POST['assessment_id'] : 0;
$status = isset($_POST['status']) ? $_POST['status'] : '';
$student_id = $_SESSION['userid'];

if (!in_array($status, ['completed', 'expired'])) {
    if(isset($_SESSION['viewed_instructions'][$assessment_id])) {
        unset($_SESSION['viewed_instructions'][$assessment_id]);
    }
    unset($_SESSION['viewed_instructions'][$assessment_id]);
    die(json_encode(['success' => false, 'message' => 'Invalid status']));
}

$sql = "UPDATE assessment_attempts 
        SET status = '$status', 
            completed_at = NOW() 
        WHERE assessment_id = '$assessment_id' 
        AND student_id = '$student_id' 
        AND status = 'in_progress'";

$result = mysqli_query($conn, $sql);

echo json_encode(['success' => (bool)$result]);
