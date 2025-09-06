<?php
require_once 'connect.php';
require_once __DIR__ . '/../PHPMailer/src/Exception.php';
require_once __DIR__ . '/../PHPMailer/src/PHPMailer.php';
require_once __DIR__ . '/../PHPMailer/src/SMTP.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\SMTP;
use PHPMailer\PHPMailer\Exception;

function get_session_name($session_id) {
    switch($session_id) {
        case 1: return '2023/2024';
        case 2: return '2024/2025';
        case 3: return '2025/2026';
        default: return '';
    }
}

function get_term_name($term_id) {
    switch($term_id) {
        case 1: return 'First Term';
        case 2: return 'Second Term';
        case 3: return 'Third Term';
        default: return '';
    }
}
// echo "Hello";
// // exit;
// $payment_data = array(
//     'tx_ref' => 'SS360-2023-01-01-12-00-00-0001',
//     'amount' => 2000,
//     'email' => 'kosokodaniel@gmail.com',
//     'phone' => '08012345678',
//     'payment_date' => '2023-01-01 12:00:00',
//     'session_id' => 1,
//     'term_id' => 1,
//     'student_number' => 10,
// );
// send_payment_notification('joebrainme1@gmail.com', $payment_data, ['school_name' => 'School Name'], 'successful');

function send_payment_notification($to_email, $payment_data, $school_info, $status) {
    $mail = new PHPMailer(true);

    try {
        // Server settings
        $mail->isSMTP();
        $mail->Host = 'mail.schoolsuite360.com';
        $mail->SMTPAuth = true;
        $mail->Username = 'billing@schoolsuite360.com';
        $mail->Password = 'G.s.o.m.';
        $mail->SMTPSecure = PHPMailer::ENCRYPTION_SMTPS;
        $mail->Port = 465;

        // Recipients
        $mail->setFrom('billing@schoolsuite360.com', 'SchoolSuite360 Billing');
        $mail->addAddress($to_email);

        // Content
        $mail->isHTML(true);
        $mail->Subject = $status === 'successful' ? 'Payment Successful - SchoolSuite360' : 'Payment Failed - SchoolSuite360';

        // Build email body
        $body = '
        <!DOCTYPE html>
        <html>
        <head>
            <style>
                body { font-family: Arial, sans-serif; line-height: 1.6; }
                .container { max-width: 600px; margin: 0 auto; padding: 20px; }
                .header { text-align: center; padding: 20px; }
                .header img { max-width: 200px; }
                .content { background: #f9f9f9; padding: 20px; border-radius: 5px; }
                .footer { text-align: center; margin-top: 20px; font-size: 12px; color: #666; }
                .status-success { color: #28a745; }
                .status-failed { color: #dc3545; }
                .details { margin: 20px 0; }
                .details table { width: 100%; }
                .details td { padding: 5px 10px; }
            </style>
        </head>
        <body>
            <div class="container">
                <div class="header">
                    <img src="https://schoolsuite360.com/ss360email.png" alt="SchoolSuite360 Logo">
                </div>
                <div class="content">
                    <h2 class="status-'.($status === 'successful' ? 'success">Payment Successful' : 'failed">Payment Failed').'</h2>
                    <p>Dear '.$school_info['school_name'].',</p>
                    '.($status === 'successful' ? 
                    '<p>Your payment has been successfully processed. Here are the details:</p>' : 
                    '<p>Unfortunately, your payment could not be processed. Here are the details:</p>').'
                    
                    <div class="details">
                        <table>
                            <tr><td><strong>Transaction Reference:</strong></td><td>'.$payment_data['tx_ref'].'</td></tr>
                            <tr><td><strong>Amount:</strong></td><td>₦'.number_format($payment_data['amount'], 2).'</td></tr>
                            <tr><td><strong>Academic Session:</strong></td><td>'.get_session_name($payment_data['session_id']).'</td></tr>
                            <tr><td><strong>Term:</strong></td><td>'.get_term_name($payment_data['term_id']).'</td></tr>
                            <tr><td><strong>Number of Students:</strong></td><td>'.$payment_data['student_number'].'</td></tr>
                            <tr><td><strong>Date:</strong></td><td>'.date('d M Y H:i', strtotime($payment_data['payment_date'])).'</td></tr>
                        </table>
                    </div>
                    
                    '.($status === 'successful' ? 
                    '<p>Thank you for your payment. Your subscription has been activated.</p>' : 
                    '<p>Please try again or contact our support team if you continue to experience issues.</p>').'
                </div>
                <div class="footer">
                    <p>This is an automated email from SchoolSuite360. Please do not reply to this email.</p>
                    <p>For support, contact us at support@schoolsuite360.com</p>
                </div>
            </div>
        </body>
        </html>';

        $mail->Body = $body;
        $mail->AltBody = strip_tags(str_replace(['<br>', '</p>'], ["\n", "\n\n"], $body));
echo $body;
        $mail->send();
        return true;
    } catch (Exception $e) {
        error_log("Email sending failed: " . $mail->ErrorInfo);
        return false;
    }
}