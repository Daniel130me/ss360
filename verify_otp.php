<?php
session_start();
include_once("model/connect");

// If the email isn't in the session, or OTP is not submitted, redirect back.
if (!isset($_SESSION['reset_email']) || !isset($_POST['otp'])) {
    header("Location: forgot_password");
    exit();
}

$email = $_SESSION['reset_email'];
$otp_submitted = trim($_POST['otp']);

if (empty($otp_submitted)) {
    $_SESSION['error_message'] = "Please enter the OTP.";
    header("Location: enter_otp");
    exit();
}

// Find user and verify OTP
$user_type = '';
$user_id = null;
$user_found = false;

$user_tables = ['staff', 'student', 'parent'];

foreach ($user_tables as $table) {
    $stmt = $conn->prepare("SELECT id, otp, otp_expiry FROM `$table` WHERE email = ?");
    if ($stmt === false) {
        error_log("Prepare failed for table `$table`: " . $conn->error);
        continue;
    }
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();
        $user_type = $table;
        $user_id = $user['id'];
        $user_found = true;
        $stmt->close();
        break;
    }
    $stmt->close();
}

if (!$user_found) {
    $_SESSION['error_message'] = "An unexpected error occurred. Please try again.";
    unset($_SESSION['reset_email']);
    header("Location: forgot_password");
    exit();
}

// Verify OTP and its expiry
$current_time = date("Y-m-d H:i:s");

if ($user['otp'] !== $otp_submitted) {
    $_SESSION['error_message'] = "Invalid OTP. Please try again.";
    header("Location: enter_otp");
    exit();
}

if ($current_time > $user['otp_expiry']) {
    $_SESSION['error_message'] = "OTP has expired. Please request a new one.";
    unset($_SESSION['reset_email']);
    header("Location: forgot_password");
    exit();
}

// OTP is correct and not expired. Set a session flag for the next step.
$_SESSION['otp_verified'] = true;

// Clear the OTP from the database
$update_stmt = $conn->prepare("UPDATE `$user_type` SET otp = NULL, otp_expiry = NULL WHERE id = ?");
$update_stmt->bind_param("i", $user_id);
$update_stmt->execute();

header("Location: reset_password");
exit();
?>