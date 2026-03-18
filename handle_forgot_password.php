<?php
session_start();
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require 'PHPMailer/src/Exception.php';
require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/SMTP.php';
include_once("model/connect.php");

header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    if (!isset($_POST['email']) || empty(trim($_POST['email']))) {
        echo json_encode(['status' => 'error', 'message' => 'Email address is required.']);
        exit;
    }

    $email = filter_var($_POST['email'], FILTER_SANITIZE_EMAIL);

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        echo json_encode(['status' => 'error', 'message' => 'Invalid email format.']);
        exit;
    }

    // Define user types and search them
    $user_tables = ['staff', 'student', 'parent'];
    $user_type = '';
    $user_id = null;

    foreach ($user_tables as $table) {
        try {
            $stmt = $conn->prepare("SELECT id FROM `$table` WHERE email = ?");
            if ($stmt === false) {
                throw new Exception("Prepare failed: " . $conn->error);
            }
            $stmt->bind_param("s", $email);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($result->num_rows > 0) {
                $user_type = $table;
                $user_id = $result->fetch_assoc()['id'];
                $stmt->close();
                break; // Exit loop once user is found
            }
            $stmt->close();
        } catch (Exception $e) {
            // Log error and continue to next table
            error_log("Database query failed for table `$table`: " . $e->getMessage());
            continue;
        }
    }

    if (!$user_id) {
        echo json_encode(['status' => 'error', 'message' => 'Email address not found.']);
        exit;
    }

    // Generate OTP
    // Use cryptographically secure random number generator
    $otp = random_int(100000, 999999);
    $otp_expiry = date("Y-m-d H:i:s", strtotime("+15 minutes"));

    // Store OTP in the database
    $update_stmt = $conn->prepare("UPDATE `$user_type` SET otp = ?, otp_expiry = ? WHERE id = ?");
    $update_stmt->bind_param("ssi", $otp, $otp_expiry, $user_id);
    
    if (!$update_stmt->execute()) {
        echo json_encode(['status' => 'error', 'message' => 'Failed to save OTP. Please try again.']);
        exit;
    }

    // Send OTP via email using PHPMailer
    $mail = new PHPMailer(true);
    try {
            $debugOutput = ''; // Initialize debug output capture
            // Load SMTP configuration
            $smtp_config = require 'smtp_config.php';

            // Enable verbose debug output for troubleshooting (set to 0 in production)
            $mail->SMTPDebug = \PHPMailer\PHPMailer\SMTP::DEBUG_SERVER;
            // Custom debug output handler to capture output
            $mail->Debugoutput = function($str, $level) use (&$debugOutput) {
                $debugOutput .= trim($str) . "\n";
            };

            //Server settings
            $mail->isSMTP();
            $mail->Host       = $smtp_config['host'];
            $mail->SMTPAuth   = true;
            $mail->Username   = $smtp_config['username'];
            $mail->Password   = $smtp_config['password'];
            $mail->SMTPSecure = $smtp_config['secure'];
            $mail->Port       = $smtp_config['port'];

            // Increase timeout for slow networks
            $mail->Timeout = 30; // seconds

            // Helpful options for debugging self-signed certs; remove or set verify_peer => true in production
            $mail->SMTPOptions = [
                'ssl' => [
                    'verify_peer' => false,
                    'verify_peer_name' => false,
                    'allow_self_signed' => true,
                ],
            ];

            //Recipients
            $mail->setFrom($smtp_config['from_email'], $smtp_config['from_name']);
            $mail->addAddress($email);

            //Content
            $mail->isHTML(true);
            $mail->Subject = 'Your Password Reset OTP';
            $mail->Body    = "Your One-Time Password (OTP) for password reset is: <b>$otp</b>. It is valid for 15 minutes.";

            $mail->send();
            $_SESSION['reset_email'] = $email; // Store email in session for next steps
            echo json_encode(['status' => 'success', 'message' => 'OTP sent successfully.']);
        } catch (Exception $e) {
            // Log detailed internal info to server logs for debugging (not sent to client)
            error_log("PHPMailer Exception: " . $e->getMessage());
            error_log("PHPMailer ErrorInfo: " . $mail->ErrorInfo);
            error_log("SMTP Debug Output:\n" . $debugOutput);

            // Return a helpful but non-sensitive JSON response to the client
            echo json_encode([
                'status' => 'error',
                'message' => 'We could not send the email. Please try again later.',
                'debug_info' => $mail->ErrorInfo ?: $e->getMessage(),
                'smtp_debug_output' => $debugOutput
            ]);
        }
    }

    ?>