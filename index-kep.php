<?php
include_once("model/connect.php");
session_start();
error_reporting(0);
$url = $_SERVER["REQUEST_URI"];
$parameter = explode("/", $url);
// print_r($parameter);
// exit;
// if($parameter[2]) {
    //     include('waiting.php');
    // }
    // function check() {
        
    // }
    $_SESSION['base_url'] = 'http://localhost/ss360/';
    $school_short = $parameter[1];


// Check if session URL is not set
if (!isset($_SESSION['url'])) {
    // Verify school URL from database
    $check = mysqli_query($conn, "SELECT url,session_id FROM school WHERE url='$school_short'");
    if (mysqli_num_rows($check) < 1) {
        include('404.php'); // the url typed is not in the database
        // include("login.php");
        exit;
    }
} elseif ($school_short != $_SESSION['url']) { //if the url is set and the session url is not equal to the url
    session_destroy();
    include('404.php');
    exit;
}

// $_SESSION['url'] = $school_short;
$_SESSION['url'] = $school_short;


if ($parameter[2] == "") {
    include("login.php");
    exit;
}
if (isset($_GET['id'])) {
    $new_url = explode("?", $parameter[2]);
    // print_r($new_url);
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
    $new_url = explode("?", $parameter[3]);
    if ($new_url[0] == 'report') {
        include('report_student.php');
        exit;
    }
}


if ($parameter[1] == 'onboard') {
    include("onboard/$parameter[3].php");
    exit;
}
$pages = array("scan_qr","my_payment", "payment_success", "time_table", "lesson_note", "attendance", "onboard", "404", "comment", "communication", "parent_portal", "waiting", "attendance", "register_staff_self", "dashboard", "change_password", "change_password_parent", "profile", "parent_profile", 'class', "staff", "employee", "each_user", "reports", "post_scores", "view_scores", "settings", "login", "students", "subjects", "logout");
if (in_array($parameter[2], $pages)) {
    // echo "ll";
    include($parameter[2] . ".php");
    exit;
}
