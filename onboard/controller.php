<?php
session_start();
include_once("../model/connect.php");
include_once("../model/functions.php");
$date = date("Y-m-d H:i:s");
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'];
    // if ($action == 'reg_staff') {
    //     // exit;
    //     $fname = test_input($_POST['firstname']);
    //     $lname = test_input($_POST['lastname']);
    //     $phone = test_input($_POST['phone']);
    //     $gender = test_input($_POST['gender']);
    //     $password = test_input($_POST['password']);
    //     $staff_type = test_input($_POST['staff_type']);
    //     $school_id = test_input($_POST['school_id']);   
    //     $email = test_input($_POST['email']);
    //     if (!does_it_exist("firstname", "staff", "phone='$phone' OR email='$email'")) {
    //         $hashPassword = password_hash($password, PASSWORD_ARGON2I);
    //         $path = "../uploads/";
    //         $valid_ext = array("jpg", "png", "jpeg");
    //         if ($_FILES['photo']['name'] == '') {
    //             $final_img = "avatar.png";
    //             $query = "INSERT INTO staff (status,photo,firstname,lastname,phone,email,passw,staff_type,gender,school_id,datecreated) 
    //             VALUES('0','$final_img','$fname','$lname','$phone','$email','$hashPassword','$staff_type','$gender','$school_id','$date')"; 
    //     } else {
    //             $img_name = $_FILES['photo']['name'];
    //             $tmp = $_FILES['photo']['tmp_name'];
    //             $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
    //             $final_img = rand(10000, 1000000) . 'staff' . $img_name;
    //             if (in_array($ext, $valid_ext)) {
    //                 $path = $path . $final_img;
    //                 if (move_uploaded_file($tmp, $path)) {
    //                     $query = "INSERT INTO staff (status,photo,firstname,lastname,phone,email,passw,staff_type,gender,school_id, datecreated) 
    //                     VALUES('0','$final_img','$fname','$lname','$phone','$email','$hashPassword','$staff_type','$gender','$school_id','$date')";
    //                 }
    //             }
    //         }
    //         $insert = mysqli_query($conn, $query);
    //         if ($insert) {
    //             if(isset($_POST['register_type'])) {
    //                 $select = mysqli_query($conn, "SELECT id FROM staff WHERE phone='$phone' AND email='$email'");
    //                 if ($row = mysqli_fetch_array($select)) {
    //                     // $_SESSION['userid'] = $row['id'];
    //                     // $_SESSION['phone'] = $phone;
    //                     // $_SESSION['email'] = $email;
    //                     // $_SESSION['staff_type'] = $staff_type;
    //                     mysqli_query($conn, "UPDATE staff SET createdby='{$row['id']}' WHERE id='{$row['id']}'");
    //                     echo json_encode(array('status' => '1', 'location' => '../login'));
    //                     exit;
    //                 }
    //             }
    //             onboard_settings($phone, $email, $staff_type);
    //         } else {
    //             echo mysqli_error($conn);
    //         }
    //     } else {
    //         echo json_encode(array('status' => '0', 'err' => 'Staff Already Registered'));
    //     }
    // }
 if ($action == 'reg_staff') {
        // exit;
        $fname = test_input($_POST['firstname']);
        $lname = test_input($_POST['lastname']);
        $phone = test_input($_POST['phone']);
        $gender = test_input($_POST['gender']);
        $address = test_input($_POST['address']);
        $city = test_input($_POST['city']);
        $state = test_input($_POST['state']);
        $country = test_input($_POST['country']);
        $middlename = test_input($_POST['middlename']);
        $password = test_input($_POST['password']);
        $staff_type = test_input($_POST['staff_type']);
        $school_id = test_input($_POST['school_id']);   
        $email = test_input($_POST['email']);
        if (!does_it_exist("firstname", "staff", "phone='$phone' OR email='$email'")) {
            $hashPassword = password_hash($password, PASSWORD_ARGON2I);
            $path = "../uploads/";
            $valid_ext = array("jpg", "png", "jpeg");
            if ($_FILES['photo']['name'] == '') {
                $final_img = "avatar.png";
                $query = "INSERT INTO staff (status,photo,firstname,lastname,middlename,phone,email,passw,staff_type,gender,school_id,datecreated,address,city,state,country) 
                VALUES('0','$final_img','$fname','$lname','$middlename','$phone','$email','$hashPassword','$staff_type','$gender','$school_id','$date','$address','$city','$state','$country')"; 
        } else {
                $img_name = $_FILES['photo']['name'];
                $tmp = $_FILES['photo']['tmp_name'];
                $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
                $final_img = rand(10000, 1000000) . 'staff' . $img_name;
                if (in_array($ext, $valid_ext)) {
                    $path = $path . $final_img;
                    if (move_uploaded_file($tmp, $path)) {
                        $query = "INSERT INTO staff (status,photo,firstname,lastname,middlename,phone,email,passw,staff_type,gender,school_id,datecreated,address,city,state,country) 
                        VALUES('0','$final_img','$fname','$lname','$middlename','$phone','$email','$hashPassword','$staff_type','$gender','$school_id','$date','$address','$city','$state','$country')";
                    }
                }
            }
            $insert = mysqli_query($conn, $query);
            if ($insert) {
                if(isset($_POST['register_type'])) {
                    $select = mysqli_query($conn, "SELECT id FROM staff WHERE phone='$phone' AND email='$email'");
                    if ($row = mysqli_fetch_array($select)) {
                        // $_SESSION['userid'] = $row['id'];
                        // $_SESSION['phone'] = $phone;
                        // $_SESSION['email'] = $email;
                        // $_SESSION['staff_type'] = $staff_type;
                        mysqli_query($conn, "UPDATE staff SET createdby='{$row['id']}' WHERE id='{$row['id']}'");
                        echo json_encode(array('status' => '1', 'location' => '../login'));
                        exit;
                    }
                }
                onboard_settings($phone, $email, $staff_type);
            } else {
                echo mysqli_error($conn);
            }
        } else {
            echo json_encode(array('status' => '0', 'err' => 'Staff Already Registered'));
        }
    }
    if ($action == 'reg_school') {
        $name = test_input($_POST['name']);
        $address = test_input($_POST['address']);
        $city = test_input($_POST['city']);
        $state = test_input($_POST['state']);
        $country = test_input($_POST['country']);
        $logo = $_FILES['logo']['name'];
        if (!does_it_exist("school_name", "school", "school_name='$name' OR address='$address'")) {
            $path = "../uploads/";
            $valid_ext = array("jpg", "png", "jpeg");
            if ($_FILES['logo']['name'] == '') {
                $img_name = 'logo-placeholder.jpg';
                $insert = mysqli_query($conn, "INSERT INTO school(school_name,address,city,state,country,logo,datecreated) 
                VALUES('$name','$address','$city','$state','$country','$img_name','$date')");
            } else {
                $img_name = $_FILES['logo']['name'];
                $tmp = $_FILES['logo']['tmp_name'];
                $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
                $final_img = rand(100, 1000000) . 'school' . $img_name;
                if (in_array($ext, $valid_ext)) {
                    $path = $path . $final_img;
                    if (move_uploaded_file($tmp, $path)) {

                        $insert = mysqli_query($conn, "INSERT INTO school(school_name,address,city,state,country,logo,datecreated) 
                    VALUES('$name','$address','$city','$state','$country','$final_img','$date')");
                    }
                }
            }
            if ($insert) {
                $select = mysqli_query($conn, "SELECT id,school_name,logo FROM school WHERE school_name='$name' AND address='$address' AND city='$city'");
                if ($row = mysqli_fetch_array($select)) {
                    $school_id  = $row['id'];
                    $_SESSION['school_id']  = $row['id'];
                    // $userid = $_SESSION['userid'];
                    // $phone = $_SESSION['phone'];
                    // $email = $_SESSION['email'];
                    $_SESSION['school_name'] = $row['school_name'];
                    $_SESSION['logo'] = $row['logo'];
                    echo json_encode(array('status' => '1', 'location' => 'staff'));
                }
            } else {
                echo mysqli_error($conn);
            }
        } else {
            echo json_encode(array('status' => '0', 'err' => 'School Already Registered'));
        }
    }

    if ($action == 'reg_subjects') {
        $post = json_encode($_POST);
        $result = json_encode(array('status' => '0', 'location' => 'subject'));

        foreach ($_POST as $key => $value) {
            if ($value !== 'reg_subjects') {
                $subject = test_input($value);
                $query = "INSERT INTO subject (subject) VALUES('$subject')";
                $insert = mysqli_query($conn, $query);
                if ($insert) {
                    $result = json_encode(array('status' => '1', 'location' => '../post_scores'));
                }
            }
        }
        echo $result;
    }
}
