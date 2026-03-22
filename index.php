<?php
date_default_timezone_set('Africa/Lagos');
session_start();
error_reporting(E_ALL);

// Build the current URL dynamically
$currentUrl = (isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] === 'on' ? "https" : "http");
$currentUrl .= "://" . $_SERVER['HTTP_HOST'] . $_SERVER['REQUEST_URI'];

// Parse the URL
$parsedUrl = parse_url($currentUrl);
$host = $parsedUrl['host'];
if ($host == "localhost") {
    $par = 1;
    $_SESSION['env'] = 'dev';
} else {
    $par = 0;
    $_SESSION['env'] = 'prod';
}



$url = $_SERVER["REQUEST_URI"];
$parameter = explode("/", $url);

include_once("model/connect.php");
// echo "meee";
// exit;
// if($parameter[2]) {
//     include('waiting.php');
// }
// function check() {

// }
// $_SESSION['']
$school_short = $parameter[1 + $par];

if ($school_short != $_SESSION['url'] or !isset($_SESSION['url'])) {
    $check = mysqli_query($conn, "SELECT url,session_id, phone1 FROM school WHERE url='$school_short'");
    // echo "takn page";
    // exit;
    // session_destroy();
    if (mysqli_num_rows($check) < 1) {
        include('404.php');
        // header("Location: 404");
        exit;
    }
}
// $_SESSION['session_id'] = $school_short;
$_SESSION['url'] = $school_short;
// exit;z
if (isset($_GET['id'])) {
    $new_url = explode("?", $parameter[2 + $par]);
    if ($new_url[0] == 'view_student_result') {
        include('view_student_result.php');
        exit;
    }
    $new_url = explode("?", $parameter[2 + $par]);
    if ($new_url[0] == 'register_staff_self') {
        include('register_staff_self.php');
        exit;
    }
    if ($new_url[0] == 'assessment_instructions') {
        include('assessment_instructions.php');
        exit;
    }
    if ($new_url[0] == 'assessment_results') {
        include('assessment_results.php');
        exit;
    }
    if ($new_url[0] == 'assessment_result') {
        include('assessment_result.php');
        exit;
    }
    if ($new_url[0] == 'assessment_status') {
        include('assessment_status.php');
        exit;
    }
    if ($new_url[0] == 'take_assessment') {
        // echo "assessment";
        include('take_assessment.php');
        exit;
    }
    if ($new_url[0] == 'assessment') {
        // echo "assessment";
        include('single_assessment.php');
        exit;
    }
    if ($new_url[0] == 'students') {
        include('display_student_profile.php');
        exit;
    }
    if ($new_url[0] == 'waiting') {
        include('waiting.php');
        exit;
    }
    if ($new_url[0] == 'my_payment') {
        include('my_payment.php');
        exit;
    }
    $new_url = explode("?", $parameter[2 + $par]);
    if ($new_url[0] == 'report') {
        include('report_student.php');
        exit;
    }
}
// echo $parameter[2];
// exit;
if ($parameter[2 + $par] == 'onboard') {
    include("onboard/" . $parameter[3 + $par] . ".php");
    exit;
}
// $pages = array("staff_attendance","assignments","results","analytics","assessment_result","take_assessment","student_portal","student_portal_profile","create_assessment","assessment","analytics","scan_qr","my_payment", "payment_success", "time_table", "lesson_note", "attendance","register_staff_self", "onboard", "404", "comment", "communication", "parent_portal", "waiting", "attendance", "registermyself", "dashboard", "change_password", "change_password_parent", "profile", "parent_profile", 'class', "staff", "employee", "each_user", "reports", "post_scores", "view_scores", "settings", "login", "students", "subjects", "logout");
$pages = array("verify_otp", "reset_password", "enter_otp", "forgot_password", "graduates", "comment_ai", "student_class_notes", "payments", "assignments", "results", "analytics", "assessment_result", "take_assessment", "student_portal", "student_portal_profile", "create_assessment", "assessment", "scan_qr", "scan_staff_qr", "my_payment", "payment_success", "time_table", "lesson_note", "attendance", "staff_attendance", "onboard", "404", "comment", "communication", "parent_portal", "waiting", "attendance", "register_staff_self", "dashboard", "change_password", "change_password_parent", "profile", "parent_profile", 'class', "staff", "employee", "each_user", "reports", "post_scores", "view_scores", "settings", "login", "students", "subjects", "logout");
if (in_array($parameter[2 + $par], $pages)) {
    include($parameter[2 + $par] . ".php");
    exit;
}
if ($parameter[2 + $par] == "") {
    include("login.php");
    exit;
}
