<?php
session_start();
  date_default_timezone_set('Africa/Lagos');
// echo date("h:ia");
// exit;
include_once("model/connect.php");
include_once("model/mailer.php");
// echo $_SESSION['url'];
// exit;
// $error_message = 'Payment verification failed: ';
// // Send failure email
// $school_info = array('school_name' => $_SESSION['school_name']);
// // send_payment_notification($_SESSION['email'], $_SESSION['payment_data'], $school_info, 'failed');
// header('Location: mem/my_payment?id='.$_SESSION['school_id'].'&status=error&message=' . urlencode($error_message));
// exit;
$tx_ref = $_GET['tx_ref'];
// Verify the transaction with Flutterwave
    $curl = curl_init();
    curl_setopt_array($curl, array(
        CURLOPT_URL => "https://api.flutterwave.com/v3/transactions/verify_by_reference?tx_ref=" . $tx_ref,
        // CURLOPT_URL => "https://api.flutterwave.com/v3/transactions/{$transaction_id}/verify",
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HTTPHEADER => array(
            // "Authorization: Bearer FLWSECK_TEST-c21604c00607679fb2d4d9bcfcac7206-X",
            "Authorization: Bearer FLWSECK-eba62886bca9c2c1eacb794348514afc-195163f8f78vt-X",
            "Content-Type: application/json"
        ),
    ));

    $response = curl_exec($curl);
    $err = curl_error($curl);
    curl_close($curl);

    if ($err) {
        $error_message = 'Payment failed: ' . $err;
        // $error_message = 'Payment verification failed: ' . $err;
        // Send failure email
        $school_info = array('school_name' => $_SESSION['school_name']);
        // send_payment_notification($_SESSION['email'], $_SESSION['payment_data'], $school_info, 'failed');
        header('Location: '.$_SESSION['url'].'/my_payment?id='.$_SESSION['school_id'].'&status=error&message=' . urlencode($error_message));
        exit;
    }

    $response = json_decode($response);
    if ($response->status === 'success' && $response->data->status === 'successful') {
        // Get payment details from response and session
        $amount = $response->data->amount;
        $email = $response->data->customer->email;
        $phone = $response->data->customer->phone_number;
        $name = $response->data->customer->name;
        $payment_date = date('Y-m-d H:i:s', strtotime($response->data->created_at));
        
        // Get additional data from session
        $payment_data = $_SESSION['payment_data'];
        $school_id = $payment_data['school_id'];
        $session_id = $payment_data['session_id'];
        $term_id = $payment_data['term_id'];
        $student_number = $payment_data['student_number'];
        $payment_purpose = 'subscription';
        $amount_per_student = 500;
        $payment_status = 'successful';

        // Prepare payment data for database and email
        $payment_details = array(
            'tx_ref' => $tx_ref,
            'amount' => $amount,
            'email' => $email,
            'phone' => $phone,
            'payment_date' => $payment_date,
            'session_id' => $session_id,
            'term_id' => $term_id,
            'student_number' => $student_number
        );

        // Save payment details to the database
        $query = "INSERT INTO payments (
            transaction_id, tx_ref, amount, email, phone, name, payment_date,
            school_id, session_id, term_id, student_number, payment_purpose,
            amount_per_student, payment_status
        ) VALUES (
            '$transaction_id', '$tx_ref', '$amount', '$email', '$phone', '$name', '$payment_date',
            '$school_id', '$session_id', '$term_id', '$student_number', '$payment_purpose',
            '$amount_per_student', '$payment_status'
        )";
        
        if (mysqli_query($conn, $query)) {
            // Send success email
            $school_info = array('school_name' => $_SESSION['school_name']);
            // send_payment_notification($email, $payment_details, $school_info, 'successful');

            // Clear payment session data
            unset($_SESSION['payment_data']);
            $message = "Payment successful! Transaction Reference: $tx_ref";
            header('Location: '.$_SESSION['url'].'/my_payment?id='.$_SESSION['school_id'].'&status=success&message=' . urlencode($message));
        } else {
            $message = "Payment was successful but failed to save. Please contact support with reference: $tx_ref";
            // Send failure email
            $school_info = array('school_name' => $_SESSION['school_name']);
            // send_payment_notification($email, $payment_details, $school_info, 'failed');
            header('Location: '.$_SESSION['url'].'/my_payment?id='.$_SESSION['school_id'].'&status=error&message=' . urlencode($message));
        }
    } else {
        $message = "Payment verification failed. Please contact support with reference: $tx_ref";
        // Send failure email
        $school_info = array('school_name' => $_SESSION['school_name']);
        // send_payment_notification($_SESSION['email'], $_SESSION['payment_data'], $school_info, 'failed');
        header('Location: '.$_SESSION['url'].'/my_payment?id='.$_SESSION['school_id'].'&status=error&message=' . urlencode($message));
    }


// if (isset($_GET['status']) && $_GET['status'] === 'successful') {
//     $transaction_id = $_GET['transaction_id'];
//     $tx_ref = $_GET['tx_ref'];

//     // Verify payment data exists in session
//     if (!isset($_SESSION['payment_data']) || $_SESSION['payment_data']['tx_ref'] !== $tx_ref) {
//         header('Location: '.$_SESSION['url'].'/my_payment?id='.$_SESSION['school_id'].'&status=error&message=' . urlencode('Invalid payment session'));
//         exit;
//     }


// } else {
//     // Send failure email for cancelled/failed payments
//     if (isset($_SESSION['payment_data'])) {
//         $school_info = array('school_name' => $_SESSION['school_name']);
//         // send_payment_notification($_SESSION['email'], $_SESSION['payment_data'], $school_info, 'failed');
//     }
//     header('Location: '.$_SESSION['url'].'/my_payment?id='.$_SESSION['school_id'].'&status=error&message=' . urlencode('Payment failed or was cancelled'));
// }

function getSessionName($session_id) {
    switch($session_id) {
        case 1: return '2023/2024';
        case 2: return '2024/2025';
        case 3: return '2025/2026';
        default: return '';
    }
}

function getTermName($term_id) {
    switch($term_id) {
        case 1: return 'First Term';
        case 2: return 'Second Term';
        case 3: return 'Third Term';
        default: return '';
    }
}
?>