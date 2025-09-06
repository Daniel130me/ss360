<?php
session_start();
include_once "model/connect.php";
// include 'model/functions.php';
// // echo $amount_to_pay = get_school_amount();
// echo "lk";
// exit;
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get form data
    $school_id = $_POST['school_id'];
    $school_name = $_POST['school_name'];
    $email = $_POST['email'];
    $phone = $_POST['phone'] ?: '';
    $session_id = $_POST['session_id'];
    $term_id = $_POST['term_id'];
    $student_number = $_POST['student_number'];
    $subamount = $student_number * $_SESSION['sub_amount']; // Calculate amount based on number of students
    $tax = $subamount * 0.075;
    $amount = $subamount + $tax;
    $payment_purpose = 'subscription';
    $amount_per_student = $_SESSION['sub_amount'];

    // Generate unique transaction reference
    $tx_ref = "SS360_" . uniqid();

    // Flutterwave API integration
    $curl = curl_init();
    curl_setopt_array($curl, array(
        CURLOPT_URL => "https://api.flutterwave.com/v3/payments",
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => "",
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 30,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => "POST",
        CURLOPT_POSTFIELDS => json_encode([
            'tx_ref' => $tx_ref,
            'amount' => $amount,
            'currency' => 'NGN',
            'redirect_url' => "https://schoolsuite360.com/payment_success.php",
            'payment_options' => 'card,banktransfer',
            'customer' => [
                'email' => $email,
                'phonenumber' => $phone,
                'name' => $school_name
            ],
            'customizations' => [
                'title' => 'SchoolSuite360 School Subscription',
                'description' => "Payment for $student_number students - " . get_session_name($session_id) . " " . get_term_name($term_id),
                'logo' => 'https://schoolsuite360.com/company_logo.png'
            ],
            'meta' => [
                'school_id' => $school_id,
                'session_id' => $session_id,
                'term_id' => $term_id,
                'student_number' => $student_number,
                'payment_purpose' => $payment_purpose,
                'amount_per_student' => $amount_per_student
            ]
        ]),
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
        echo json_encode(['status' => 'error', 'message' => 'Payment initialization failed: ' . $err]);
    } else {
        $response = json_decode($response);
        if ($response->status == 'success') {
            // Store payment initiation in session for verification
            $_SESSION['payment_data'] = [
                'tx_ref' => $tx_ref,
                'amount' => $amount,
                'session_id' => $session_id,
                'term_id' => $term_id,
                'student_number' => $student_number,
                'school_id' => $school_id
            ];
            echo json_encode(['status' => 'success', 'payment_link' => $response->data->link]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Payment initialization failed']);
        }
    }
}

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