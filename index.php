<?php
// set timezone
date_default_timezone_set('Africa/Lagos');
include_once("model/connect.php");
session_start();
// echo "ll";
// exit;
error_reporting(0);
$url = $_SERVER["REQUEST_URI"];
$parameter = explode("/", $url);
// print_r($parameter);
// exit;
// if($parameter[2]) {
//     include('waiting.php');
// }
// function check() {


$_SESSION['base_url'] = 'http://localhost/ss360/';
$school_short = $parameter[2];
// echo $school_short;


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

// Check for remembered login
// if (!isset($_SESSION['userid']) && isset($_COOKIE['remember_user']) && isset($_COOKIE['remember_token']) && isset($_COOKIE['user_type'])) {
//     $user_id = $_COOKIE['remember_user'];
//     $token = $_COOKIE['remember_token'];
//     $user_type = $_COOKIE['user_type'];

//     // Verify token based on user type
//     if ($user_type === 'staff') {
//         $query = mysqli_query($conn, "SELECT * FROM staff WHERE id='$user_id'");
//         if ($row = mysqli_fetch_array($query)) {
//             if (password_verify($token, $row['remember_token'])) {
//                 // Auto login successful - set session variables
//                 $_SESSION["login"] = true;
//                 $_SESSION['userid'] = $row['id'];
//                 $_SESSION['firstname'] = $row['firstname'];
//                 // ... set other session variables ...
//             }
//         }
//     } else if ($user_type === 'parent') {
//         $query = mysqli_query($conn, "SELECT * FROM parent WHERE id='$user_id'");
//         if ($row = mysqli_fetch_array($query)) {
//             if (password_verify($token, $row['remember_token'])) {
//                 // Auto login successful - set session variables
//                 $_SESSION["login"] = true;
//                 $_SESSION['userid'] = $row['id'];
//                 $_SESSION['firstname'] = $row['firstname'];
//                 // ... set other session variables ...
//             }
//         }
//     }

//     // If verification failed, clear cookies
//     if (!isset($_SESSION['userid'])) {
//         setcookie('remember_user', '', time() - 3600, '/');
//         setcookie('remember_token', '', time() - 3600, '/');
//         setcookie('user_type', '', time() - 3600, '/');
//     }
// }

if ($parameter[3] == "") {
    // echo "word";
    include("login.php");
    exit;
}
if (isset($_GET['id'])) {
    $new_url = explode("?", $parameter[3]);
    // print_r($new_url);
    // exit;   
    if ($new_url[0] == 'students') {
        include('display_student_profile.php');
        exit;
    }
    if ($new_url[0] == 'view_student_result') {
        include('view_student_result.php');
        exit;
    }
    if ($new_url[0] == 'view_student_result') {
        include('view_student_result.php');
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

// echo $parameter[4];
// exit;
// if($parameter[3])
if ($parameter[3] == 'onboard') {
    include("onboard/$parameter[4].php");
    exit;
}
// echo $parameter[3];
$pages = array("verify_otp","reset_password","enter_otp","forgot_password","graduates","comment_ai","student_class_notes", "billings", "assignments", "results", "analytics", "assessment_result", "take_assessment", "student_portal", "student_portal_profile", "create_assessment", "assessment", "scan_qr", "scan_staff_qr","payments", "my_payment", "payment_success", "time_table", "lesson_note", "attendance", "staff_attendance", "onboard", "404", "comment", "communication", "parent_portal", "waiting", "attendance", "register_staff_self", "dashboard", "change_password", "change_password_parent", "profile", "parent_profile", 'class', "staff", "employee", "each_user", "reports", "post_scores", "view_scores", "settings", "login", "students", "subjects", "logout");

if (in_array($parameter[3], $pages)) {
    include($parameter[3] . ".php");
    exit;
}
?>
</body>

</html>