<?php
session_start();
include_once("../model/connect.php");
include_once("../model/functions.php");
date_default_timezone_set('Africa/Lagos');

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
        $status = (isset($_SESSION['onboarding']) && $_SESSION['onboarding'] === true) ? '1' : '0';

        if (!does_it_exist("firstname", "staff", "phone='$phone' OR email='$email'")) {
            // Start Transaction
            mysqli_begin_transaction($conn);

            try {
                $hashPassword = password_hash($password, PASSWORD_ARGON2I);
                $path = "../uploads/";
                $valid_ext = array("jpg", "png", "jpeg");
                $final_img = "avatar.png";

                if (isset($_FILES['photo']['name']) && $_FILES['photo']['name'] != '') {
                    $img_name = $_FILES['photo']['name'];
                    $tmp = $_FILES['photo']['tmp_name'];
                    $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
                    $final_img = rand(10000, 1000000) . 'staff' . $img_name;
                    if (in_array($ext, $valid_ext)) {
                        if (!move_uploaded_file($tmp, $path . $final_img)) {
                            throw new Exception("Failed to upload staff photo.");
                        }
                    } else {
                        throw new Exception("Invalid file format for photo.");
                    }
                }

                $query = "INSERT INTO staff (status,photo,firstname,lastname,middlename,phone,email,passw,staff_type,gender,school_id,datecreated,address,city,state,country) 
                          VALUES('$status','$final_img','$fname','$lname','$middlename','$phone','$email','$hashPassword','$staff_type','$gender','$school_id','$date','$address','$city','$state','$country')";

                if (!mysqli_query($conn, $query)) {
                    throw new Exception("Failed to register staff: " . mysqli_error($conn));
                }

                $new_staff_id = mysqli_insert_id($conn);

                if (isset($_POST['register_type'])) {
                    $update_created = mysqli_query($conn, "UPDATE staff SET createdby='$new_staff_id' WHERE id='$new_staff_id'");
                    if (!$update_created) {
                        throw new Exception("Failed to update staff creator: " . mysqli_error($conn));
                    }
                    
                    mysqli_commit($conn);
                    echo json_encode(array('status' => '1', 'location' => '../login'));
                    exit;
                }

                // Complete onboarding settings within the same transaction
                onboard_settings($phone, $email, $staff_type, $new_staff_id);

                // Commit everything
                mysqli_commit($conn);
                echo json_encode(array('status' => '1', 'location' => "../{$_SESSION['url']}/"));

            } catch (Exception $e) {
                // Rollback on any failure
                mysqli_rollback($conn);
                echo json_encode(array('status' => '0', 'err' => $e->getMessage()));
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
        $term_id = 1;
        $amount = 1000;
        $url = rand(10000, 99999);

        // select last session id from session table
        $select_session = mysqli_query($conn, "SELECT MAX(id) as last_session_id FROM sessions");
        if ($row = mysqli_fetch_array($select_session)) {
            $session_id = $row['last_session_id'];
        }

        if (!does_it_exist("school_name", "school", "school_name='$name' OR address='$address'")) {
            // Start Transaction
            mysqli_begin_transaction($conn);

            try {
                $path = "../uploads/";
                $valid_ext = array("jpg", "png", "jpeg");
                $final_logo_name = 'logo-placeholder.jpg';

                if ($_FILES['logo']['name'] != '') {
                    $img_name = $_FILES['logo']['name'];
                    $tmp = $_FILES['logo']['tmp_name'];
                    $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
                    $final_logo_name = rand(100, 1000000) . 'school' . $img_name;

                    if (in_array($ext, $valid_ext)) {
                        if (!move_uploaded_file($tmp, $path . $final_logo_name)) {
                            throw new Exception("Failed to upload logo.");
                        }
                    } else {
                        throw new Exception("Invalid file format for logo.");
                    }
                }

                $insert_query = "INSERT INTO school(url,amount,term_id,session_id,school_name,address,city,state,country,logo,datecreated) 
                                 VALUES('$url','$amount','$term_id','$session_id','$name','$address','$city','$state','$country','$final_logo_name','$date')";

                if (!mysqli_query($conn, $insert_query)) {
                    throw new Exception(mysqli_error($conn));
                }

                $school_id = mysqli_insert_id($conn);

                // Set session variables
                $_SESSION['school_id'] = $school_id;
                $_SESSION['onboarding'] = true;
                $_SESSION['url'] = $url;
                $_SESSION['session_id'] = $session_id;
                $_SESSION['term_id'] = $term_id;
                $_SESSION['school_name'] = $name;
                $_SESSION['logo'] = $final_logo_name;

                // Commit Transaction
                mysqli_commit($conn);

                echo json_encode(array('status' => '1', 'location' => 'staff'));
            } catch (Exception $e) {
                // Rollback Transaction on error
                mysqli_rollback($conn);
                echo json_encode(array('status' => '0', 'err' => $e->getMessage()));
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
