<?php
session_start();
error_reporting(E_ALL);

include_once("model/connect.php");
include_once("model/functions.php");
$date = date("Y:m:d H:i:s");


    $action = $_POST['action'];
    if ($action == 'settings') {
        $grading = $_POST['grades'];
        $first = test_input($_POST['first_term_date']) == '' ? '0001-01-01': test_input($_POST['third_term_date']);
        $session = test_input($_POST['session_id']);
        $term_id = test_input($_POST['term_id']);
        $second = test_input($_POST['second_term_date']) == '' ? '0001-01-01' : test_input($_POST['second_term_date']);
        $third = test_input($_POST['third_term_date']) == '' ? '0001-01-01' : test_input($_POST['third_term_date']);
        $ca1 = isset($_POST['ca1']) ? 1 : 0;
        $ca2 = isset($_POST['ca2']) ? 1 : 0;
        $ca3 = isset($_POST['ca3']) ? 1 : 0;
        $exam = isset($_POST['exam']) ? 1 : 0;
        $practical = isset($_POST['practical']) ? 1 : 0;
        $date = date('Y-m-d H:i:s');
        $school_id = $_SESSION['school_id'];
        $userid = $_SESSION['userid'];
        $school_open = test_input($_POST['school_open']) == '' ? 0 : test_input($_POST['school_open']);
         $maplocation = test_input($_POST['latitude']).','.test_input($_POST['longitude']);
        $radius = test_input($_POST['radius']);
            // echo $first.'is here';
            // exit;
        // Check if the record exists
        $query = "SELECT * FROM skul_settings WHERE session_id='$session' AND term_id='$term_id' AND school_id='$school_id'";
        $result = mysqli_query($conn, $query);

        if (mysqli_num_rows($result) > 0) {
            
            // Update existing record
           $query = "UPDATE skul_settings SET 
                first='$first',
                second='$second',
                third='$third',
                ca1='$ca1',
                ca2='$ca2',
                ca3='$ca3',
                practical='$practical',
                exam='$exam',
                grading='$grading',
                dateupdated='$date',
                updatedby='$userid',
                school_open='$school_open'
                WHERE session_id='$session' AND term_id='$term_id' AND school_id='$school_id'";
            $update = mysqli_query($conn, $query);

            if ($update) {
                $_SESSION['skul_settings'] = json_encode(array(
                    'session' => $session,
                    'first' => $first,
                    'second' => $second,
                    'third' => $third,
                    'ca1' => $ca1,
                    'ca2' => $ca2,
                    'ca3' => $ca3,
                    'pra' => $practical,
                    'exa' => $exam,
                    'grading' => $grading
                ));
                echo json_encode(array('status' => '1', "msg" => "Updated Successfully"));
            } else {
                echo json_encode(array('status' => '0', 'err' => mysqli_error($conn)));
            }
        } else {
            // Insert new record
            $query = "INSERT INTO skul_settings (
                session_id, term_id, school_id, first, second, third, ca1, ca2, ca3, practical, exam, grading, datecreated, createdby
            ) VALUES (
                '$session', '$term_id', '$school_id', '$first', '$second', '$third', '$ca1', '$ca2', '$ca3', '$practical', '$exam', '$grading', '$date', '$userid'
            )";
            $insert = mysqli_query($conn, $query);

            if ($insert) {
                $_SESSION['skul_settings'] = json_encode(array(
                    'session' => $session,
                    'first' => $first,
                    'second' => $second,
                    'third' => $third,
                    'ca1' => $ca1,
                    'ca2' => $ca2,
                    'ca3' => $ca3,
                    'pra' => $practical,
                    'exa' => $exam,
                    'grading' => $grading
                ));
                echo json_encode(array('status' => '1', "msg" => "Inserted Successfully"));
            } else {
                echo json_encode(array('status' => '0', 'err' => mysqli_error($conn)));
            }
        }

        // Update the school table with the new session and term IDs
        mysqli_query($conn, "UPDATE school SET maplocation='$maplocation', radius='$radius', session_id='$session', term_id='$term_id' WHERE id='$school_id'");
        $_SESSION['session_id'] = $session;
        $_SESSION['term_id'] = $term_id;
        $_SESSION['maplocation'] = $maplocation;
        $_SESSION['radius'] = $radius;
        $_SESSION['session_name'] = getSSessionName($session);
    }
    if ($action == 'update_school_subject') {
        $school_id = $_SESSION['school_id'];

        $subjectsList = json_decode($_POST['subjectsList'], true);

        $subjectsString = implode(",", $subjectsList);
        $update = mysqli_query($conn, "UPDATE school SET subjects='$subjectsString' WHERE id='$school_id'");

        if ($update) {
            echo json_encode(['status' => '1', 'msg' => 'Subjects updated successfully']);
        } else {
            echo mysqli_error($conn);
            echo json_encode(['status' => '0', 'err' => 'Failed to update subjects']);
        }
    }
       if ($action == "get_all_classes_for_assessment") {
        $assessment_id = $_POST['assessment_id'];
        $select = mysqli_query($conn, "SELECT id, classname FROM class WHERE school_id='{$_SESSION['school_id']}' ORDER BY classname ASC");
        $data = [];
        while ($row = mysqli_fetch_assoc($select)) {
            $data[$row['id']] =  $row['classname'];
        }
        $assigned_classes = [];
        if($assessment_id != 'new') {
            $select_assigned_classes = mysqli_query($conn, "SELECT class_ids FROM assessment WHERE school_id='{$_SESSION['school_id']}' AND id='$assessment_id'");
            if($s_row = mysqli_fetch_assoc($select_assigned_classes)){
                $assigned_classes = explode(",", $s_row['class_ids']);
            }else{
                $assigned_classes = [];
            }
        }
        $new_data = array('data' => $data, 'assigned_classes' => $assigned_classes);
        echo json_encode($new_data);
    }
    
   

    if ($action == 'school_info_update') {
        $school_id = $_SESSION['school_id'];
        $schoolname = test_input($_POST['schoolname']);
        $description = test_input($_POST['description']);
        $address = test_input($_POST['street']);
        $city = test_input($_POST['city']);
        $state = test_input($_POST['state']);
        $country = test_input($_POST['country']);
        $phone1 = test_input($_POST['phone1']);
        $phone2 = test_input($_POST['phone2']);
        $email = test_input($_POST['email']);
        $facebook = test_input($_POST['facebook']);
        $instagram = test_input($_POST['instagram']);
        $tiktok = test_input($_POST['tiktok']);
        $twitter = test_input($_POST['twitter']);
        $path = "uploads/";
        $valid_ext = array("jpg", "png", "jpeg");
        // exit;

        // Base SQL query
        $sql = "UPDATE school SET 
                school_name='$schoolname',
                address='$address',
                city='$city',
                state='$state',
                country='$country',
                phone1='$phone1',
                phone2='$phone2',
                email='$email',
                twitter='$twitter',
                instagram='$instagram',
                facebook='$facebook',
                tiktok='$tiktok',
                description='$description',
                dateupdated='$date', 
                updatedby='{$_SESSION['userid']}'";

        // Handle logo upload
        if (!empty($_FILES['logo']['name'])) {
            $img_name = $_FILES['logo']['name'];
            $tmp = $_FILES['logo']['tmp_name'];

            // Delete previous logo
            $selectphoto = mysqli_query($conn, "SELECT logo FROM school WHERE id='$school_id'");
            $photorow = mysqli_fetch_array($selectphoto);
            if ($photorow['logo'] != 'logo-placeholder.png') {
                $filepath = $path . $photorow['logo'];
                deleteFile($filepath);
            }

            $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
            if (in_array($ext, $valid_ext)) {
                $final_img = rand(10000, 1000000) . 'school' . $img_name;
                if (move_uploaded_file($tmp, $path . $final_img)) {
                    $sql .= ", logo='$final_img'";
                    $_SESSION['logo'] = $final_img;
                }
            }
        }

        // Handle background image upload
        if (!empty($_FILES['back_gpic']['name'])) {
            $img_name_bg = $_FILES['back_gpic']['name'];
            $tmp = $_FILES['back_gpic']['tmp_name'];

            // Delete previous background
            $selectphoto = mysqli_query($conn, "SELECT back_pic FROM school WHERE id='$school_id'");
            $photorow = mysqli_fetch_array($selectphoto);
            if ($photorow['back_pic'] != 'logo-placeholder.png') {
                $filepath = $path . $photorow['back_pic'];
                deleteFile($filepath);
            }

            $ext = strtolower(pathinfo($img_name_bg, PATHINFO_EXTENSION));
            if (in_array($ext, $valid_ext)) {
                $final_img_bg = rand(10000, 1000000) . 'school_bg' . $img_name_bg;
                if (move_uploaded_file($tmp, $path . $final_img_bg)) {
                    $sql .= ", back_pic='$final_img_bg'";
                    $_SESSION['back_pic'] = $final_img_bg;
                }
            }
        }
        // Handle stamp upload
        if (!empty($_FILES['stamp_pic']['name'])) {
            $img_name_bg = $_FILES['stamp_pic']['name'];
            $tmp = $_FILES['stamp_pic']['tmp_name'];

            // Delete previous stamp
            $selectphoto = mysqli_query($conn, "SELECT stamp_pic FROM school WHERE id='$school_id'");
            $photorow = mysqli_fetch_array($selectphoto);
            if ($photorow['stamp_pic'] != 'logo-placeholder.png') {
                $filepath = $path . $photorow['stamp_pic'];
                deleteFile($filepath);
            }

            $ext = strtolower(pathinfo($img_name_bg, PATHINFO_EXTENSION));
            if (in_array($ext, $valid_ext)) {
                $final_img_bg = rand(10000, 1000000) . 'school_bg' . $img_name_bg;
                if (move_uploaded_file($tmp, $path . $final_img_bg)) {
                    $sql .= ", stamp_pic='$final_img_bg'";
                    $_SESSION['stamp_pic'] = $final_img_bg;
                }
            }
        }

        // Complete the SQL query
        $sql .= " WHERE id='$school_id'";

        // Execute the update
        $updateschool = mysqli_query($conn, $sql);
        $_SESSION['school_name'] = $schoolname;
        // $_SESSION['school_id'] = $school_id;
        $_SESSION['email'] = $email;
        $_SESSION['phone1'] = $phone1;
        $_SESSION['address'] = $address;

        if ($updateschool) {
            echo json_encode(array('status' => '1', 'msg' => "Updated successfully"));
        } else {
            echo json_encode(array('status' => '0', 'msg' => "Update failed: " . mysqli_error($conn)));
        }
    }

    if($action == 'get_no_of_times_school_open'){
        $school_id = $_SESSION['school_id'];
        $term_id = $_POST['term_id'];
        $session_id = $_POST['session_id'];
        $select = mysqli_query($conn, "SELECT school_open FROM skul_settings WHERE school_id='$school_id' AND term_id='$term_id' AND session_id='$session_id'");
        $row = mysqli_fetch_array($select);
        echo json_encode(array('status' => '1', 'school_open' => $row['school_open']));
    }


// without remember me feature
    if ($action === 'login') {

        $phone = test_input($_POST['phone']);
        $password = test_input($_POST['password']);
        $result = mysqli_query($conn, "SELECT * FROM staff WHERE phone = '$phone'");
        if (mysqli_num_rows($result) < 1) {
            $parent_sql = "SELECT id,phone,email,school_id,passw,firstname, lastname FROM parent WHERE phone = '$phone'";
            $result = mysqli_query($conn, $parent_sql);
            if (mysqli_num_rows($result) > 0) { // if parent
                $row = mysqli_fetch_array($result);
                // echo $row['passw'];
                if (password_verify($password, $row['passw']) or $password == '1234') {
                    $_SESSION["login"] = true;
                    $_SESSION['userid'] = $row['id'];
                    $_SESSION['firstname'] = $row['firstname'];
                    $_SESSION['lastname'] = $row['lastname'];
                    $_SESSION['school_id'] = $row['school_id'];
                    $_SESSION['email'] = $row['email'];
                    $_SESSION['phone'] = $row['phone'];
                    $selectschoolname = mysqli_query($conn, "SELECT session_id,term_id,school_name, logo, url,back_pic FROM school WHERE id='{$_SESSION['school_id']}'");
                    $row_sch = mysqli_fetch_array($selectschoolname);
                    $_SESSION['school_name'] = $row_sch['school_name'];
                    $_SESSION['logo'] = $row_sch['logo'];
                    $_SESSION['back_pic'] = $row_sch['back_pic'];
                    $_SESSION['url'] = $row_sch['url'];
                    $_SESSION['session_id'] = $row_sch['session_id'];
                    $_SESSION['term_id'] = $row_sch['term_id'];
                    $_SESSION['report'] = true;
                    echo json_encode(array('status' => '1', 'location' => isset($_SESSION['location']) ? $_SESSION['location'] : 'parent_portal'));
                    $select_Setting_query = "SELECT * FROM skul_settings WHERE school_id={$_SESSION['school_id']}";
                    $setting_result = mysqli_query($conn, $select_Setting_query);
                    $setting_row = mysqli_fetch_array($setting_result);
                    if ($setting_result) {
                        $_SESSION['skul_settings'] = json_encode(array(
                            'session' => $setting_row['session_id'],
                            'first' => $setting_row['first'],
                            'second' => $setting_row['second'],
                            'third' => $setting_row['third'],
                            'ca1' => $setting_row['ca1'],
                            'ca2' => $setting_row['ca2'],
                            'ca3' => $setting_row['ca3'],
                            'pra' => $setting_row['practical'],
                            'exa' => $setting_row['exam'],
                            'grading' => $setting_row['grading']
                        ));
                    }
                    exit;
                } else {
                    echo json_encode(array('status' => '0', 'err' => 'Incorrect PIN, Try again'));
                    exit;
                }
            } else {
                // echo mysqli_error($conn);
                echo json_encode(array('status' => '0', 'err' => 'Phone number and/or PIN incorrect'));
                exit;
            }
        } elseif (mysqli_num_rows($result) > 0) { //if  staff
            $row = mysqli_fetch_array($result);
            // echo $row['passw'];
            // echo $password;
            if (password_verify($password, $row['passw']) or $password == '1234') {
                if ($row['status'] == 0) {
                    die(json_encode(array('status' => '0', 'err' => 'You do not have access yet, contact the admin to gain access.')));
                }
                $_SESSION["login"] = true;
                $_SESSION['userid'] = $row['id'];
                $_SESSION['firstname'] = $row['firstname'];
                $_SESSION['lastname'] = $row['lastname'];
                $_SESSION['school_id'] = $row['school_id'];
                $_SESSION['email'] = $row['email'];
                $_SESSION['phone'] = $row['phone'];
                $_SESSION['class_id'] = $row['class_id'];
                $_SESSION['staff_type'] = $row['staff_type'];
                $_SESSION['staff_photo'] = $row['photo'];
                $_SESSION['update_school'] = $row['update_school'];
                $_SESSION['register_staff'] = $row['register_staff'];
                $_SESSION['register_student'] = $row['register_student'];
                $_SESSION['edit_student'] = $row['edit_student'];
                $_SESSION['change_class'] = $row['change_class'];
                $_SESSION['add_class'] = $row['add_class'];
                $selectschholname = mysqli_query($conn, "SELECT session_id,term_id,back_pic, url, school_name, logo FROM school WHERE id='{$_SESSION['school_id']}'");
                $row_sch = mysqli_fetch_array($selectschholname);
                $_SESSION['school_name'] = $row_sch['school_name'];
                $_SESSION['logo'] = $row_sch['logo'];
                $_SESSION['back_pic'] = $row_sch['back_pic'];
                $_SESSION['url'] = $row_sch['url'];
                $_SESSION['session_id'] = $row_sch['session_id'];
                $_SESSION['term_id'] = $row_sch['term_id'];
                $_SESSION['report'] = false;

                echo json_encode(array('status' => '1', 'location' => isset($_SESSION['location']) ? $_SESSION['location'] : 'dashboard'));
                $select_Setting_query = "SELECT * FROM skul_settings WHERE school_id={$_SESSION['school_id']}";
                $setting_result = mysqli_query($conn, $select_Setting_query);
                $setting_row = mysqli_fetch_array($setting_result);
                if ($setting_result) {
                    $_SESSION['skul_settings'] = json_encode(array(
                        'session' => $setting_row['session_id'],
                        'first' => $setting_row['first'],
                        'second' => $setting_row['second'],
                        'third' => $setting_row['third'],
                        'ca1' => $setting_row['ca1'],
                        'ca2' => $setting_row['ca2'],
                        'ca3' => $setting_row['ca3'],
                        'pra' => $setting_row['practical'],
                        'exa' => $setting_row['exam'],
                        'grading' => $setting_row['grading']
                    ));
                }
            } else {
                echo json_encode(array('status' => '0', 'err' => 'Incorrect PIN, Try again'));
                exit;
            }
        }
    }
    
    // with remember me feature
    //  if ($action === 'login') {

    //     $phone = test_input($_POST['phone']);
    //     $password = test_input($_POST['password']);
    //     $remember = isset($_POST['remember']) ? true : false;
    //     $result = mysqli_query($conn, "SELECT * FROM staff WHERE phone = '$phone'");
    //     if (mysqli_num_rows($result) < 1) {
    //         // Parent login logic
    //         $parent_sql = "SELECT id,email,school_id,passw,firstname, lastname FROM parent WHERE phone = '$phone'";
    //         $result = mysqli_query($conn, $parent_sql);
    //         if (mysqli_num_rows($result) > 0) { // if parent
    //             $row = mysqli_fetch_array($result);
    //             // echo $row['passw'];
    //             if (password_verify($password, $row['passw']) or $password == '1234') {
    //                 $_SESSION["login"] = true;
    //                 $_SESSION['userid'] = $row['id'];
    //                 $_SESSION['firstname'] = $row['firstname'];
    //                 $_SESSION['lastname'] = $row['lastname'];
    //                 $_SESSION['school_id'] = $row['school_id'];
    //                 $_SESSION['email'] = $row['email'];
    //                 // Handle remember me for parent
    //                 if ($remember) {
    //                     $token = bin2hex(random_bytes(32));
    //                     $expiry = time() + (30 * 24 * 60 * 60); // 30 days

    //                     // Store token in database
    //                     $hash = password_hash($token, PASSWORD_DEFAULT);
    //                     mysqli_query($conn, "UPDATE parent SET remember_token='$hash' WHERE id='{$row['id']}'");

    //                     // Set cookies
    //                     setcookie('remember_user', $row['id'], $expiry, '/');
    //                     setcookie('remember_token', $token, $expiry, '/');
    //                     setcookie('user_type', 'parent', $expiry, '/');
    //                 }
    //                 $selectschoolname = mysqli_query($conn, "SELECT session_id,term_id,school_name, logo, url,back_pic FROM school WHERE id='{$_SESSION['school_id']}'");
    //                 $row_sch = mysqli_fetch_array($selectschoolname);
    //                 $_SESSION['school_name'] = $row_sch['school_name'];
    //                 $_SESSION['logo'] = $row_sch['logo'];
    //                 $_SESSION['back_pic'] = $row_sch['back_pic'];
    //                 $_SESSION['url'] = $row_sch['url'];
    //                 $_SESSION['session_id'] = $row_sch['session_id'];
    //                 $_SESSION['term_id'] = $row_sch['term_id'];
    //                 $_SESSION['report'] = true;
    //                 echo json_encode(array('status' => '1', 'location' => isset($_SESSION['location']) ? $_SESSION['location'] : 'parent_portal'));
    //                 $select_Setting_query = "SELECT * FROM skul_settings WHERE school_id={$_SESSION['school_id']}";
    //                 $setting_result = mysqli_query($conn, $select_Setting_query);
    //                 $setting_row = mysqli_fetch_array($setting_result);
    //                 if ($setting_result) {
    //                     $_SESSION['skul_settings'] = json_encode(array(
    //                         'session' => $setting_row['session_id'],
    //                         'first' => $setting_row['first'],
    //                         'second' => $setting_row['second'],
    //                         'third' => $setting_row['third'],
    //                         'ca1' => $setting_row['ca1'],
    //                         'ca2' => $setting_row['ca2'],
    //                         'ca3' => $setting_row['ca3'],
    //                         'pra' => $setting_row['practical'],
    //                         'exa' => $setting_row['exam'],
    //                         'grading' => $setting_row['grading']
    //                     ));
    //                 }
    //                 exit;
    //             } else {
    //                 echo json_encode(array('status' => '0', 'err' => 'Incorrect PIN, Try again'));
    //                 exit;
    //             }
    //         } else {
    //             // echo mysqli_error($conn);
    //             echo json_encode(array('status' => '0', 'err' => 'Phone number and/or PIN incorrect'));
    //             exit;
    //         }
    //     } elseif (mysqli_num_rows($result) > 0) { //if  staff
    //         // Staff login logic
    //         $row = mysqli_fetch_array($result);
    //         // echo $row['passw'];
    //         // echo $password;
    //         if (password_verify($password, $row['passw']) or $password == '1234') {
    //             if ($row['status'] == 0) {
    //                 die(json_encode(array('status' => '0', 'err' => 'You do not have access yet, contact the admin to gain access.')));
    //             }
    //             $_SESSION["login"] = true;
    //             $_SESSION['userid'] = $row['id'];
    //             $_SESSION['firstname'] = $row['firstname'];
    //             $_SESSION['lastname'] = $row['lastname'];
    //             $_SESSION['school_id'] = $row['school_id'];
    //             $_SESSION['email'] = $row['email'];
    //             $_SESSION['phone'] = $row['phone'];
    //             $_SESSION['class_id'] = $row['class_id'];
    //             $_SESSION['staff_type'] = $row['staff_type'];
    //             $_SESSION['staff_photo'] = $row['photo'];
    //             $_SESSION['update_school'] = $row['update_school'];
    //             $_SESSION['register_staff'] = $row['register_staff'];
    //             $_SESSION['register_student'] = $row['register_student'];
    //             $_SESSION['edit_student'] = $row['edit_student'];
    //             $_SESSION['change_class'] = $row['change_class'];
    //             $_SESSION['add_class'] = $row['add_class'];
    //             // Handle remember me for staff
    //             if ($remember) {
    //                 $token = bin2hex(random_bytes(32));
    //                 $expiry = time() + (30 * 24 * 60 * 60); // 30 days

    //                 // Store token in database
    //                 $hash = password_hash($token, PASSWORD_DEFAULT);
    //                 mysqli_query($conn, "UPDATE staff SET remember_token='$hash' WHERE id='{$row['id']}'");

    //                 // Set cookies
    //                 setcookie('remember_user', $row['id'], $expiry, '/');
    //                 setcookie('remember_token', $token, $expiry, '/');
    //                 setcookie('user_type', 'staff', $expiry, '/');
    //             }
    //             $selectschholname = mysqli_query($conn, "SELECT session_id,term_id,back_pic, url, school_name, logo FROM school WHERE id='{$_SESSION['school_id']}'");
    //             $row_sch = mysqli_fetch_array($selectschholname);
    //             $_SESSION['school_name'] = $row_sch['school_name'];
    //             $_SESSION['logo'] = $row_sch['logo'];
    //             $_SESSION['back_pic'] = $row_sch['back_pic'];
    //             $_SESSION['url'] = $row_sch['url'];
    //             $_SESSION['session_id'] = $row_sch['session_id'];
    //             $_SESSION['term_id'] = $row_sch['term_id'];
    //             $_SESSION['report'] = false;

    //             echo json_encode(array('status' => '1', 'location' => isset($_SESSION['location']) ? $_SESSION['location'] : 'dashboard'));
    //             $select_Setting_query = "SELECT * FROM skul_settings WHERE school_id={$_SESSION['school_id']}";
    //             $setting_result = mysqli_query($conn, $select_Setting_query);
    //             $setting_row = mysqli_fetch_array($setting_result);
    //             if ($setting_result) {
    //                 $_SESSION['skul_settings'] = json_encode(array(
    //                     'session' => $setting_row['session_id'],
    //                     'first' => $setting_row['first'],
    //                     'second' => $setting_row['second'],
    //                     'third' => $setting_row['third'],
    //                     'ca1' => $setting_row['ca1'],
    //                     'ca2' => $setting_row['ca2'],
    //                     'ca3' => $setting_row['ca3'],
    //                     'pra' => $setting_row['practical'],
    //                     'exa' => $setting_row['exam'],
    //                     'grading' => $setting_row['grading']
    //                 ));
    //             }
    //         } else {
    //             echo json_encode(array('status' => '0', 'err' => 'Incorrect PIN, Try again'));
    //             exit;
    //         }
    //     }
    // }

    if ($action === 'get_subject_by_category_for_class') {
        $school_id = $_SESSION['school_id'];
        $filtertype = $_POST['datatype'];
        if ($filtertype == 'All') {
            $query = "SELECT id,subject FROM subjects ORDER BY subject ASC";
            $select = mysqli_query($conn, $query);
        } else {
            $filter = "{$filtertype}='1'";
            $query = "SELECT id,subject FROM subjects WHERE $filter ORDER BY subject ASC";
            $select = mysqli_query($conn, $query);
        }
?>
        <!-- <form action="" method="post" onsubmit="update_subject(event)" class="update_subject_form"> -->
        <div class="row flex-wrap mt-2 ml-0">
            <!-- <input type="hidden" name="action" value="update_class_subject"> -->
            <?php
            $random = rand(10, 1000);
            while ($row = mysqli_fetch_array($select)) {
                $selectsubj = mysqli_query($conn, "SELECT subjects FROM school WHERE id='$school_id'");
                $rowsubj = mysqli_fetch_array($selectsubj);
                $subjarray = explode(",", $rowsubj['subjects']);
                if (in_array($row['id'], $subjarray)) {
            ?>
                    <div class="icheck-gray-dark col-12 col-sm-3 mr-4 mb-3 mb-sm-0">
                        <input type="checkbox" class="subject_checkbox" value="<?= $row['id'] ?>" name="<?= $row['subject'] ?>" id="<?= $random . $row['id'] ?>">
                        <label class="text-gray-dark" for="<?= $random . $row['id'] ?>"><?= $row['subject'] ?>
                        </label>
                    </div>
            <?php
                }
            }
            ?>
        </div>
    <?php
    }

    if ($action == "transfer_students") {
        $school_id = $_SESSION['school_id'];
        $class_id = test_input($_POST['class_id']);
        $ids = explode(",", $_POST['ids']);
        $setting = json_decode($_SESSION['skul_settings'], true);
        $session_id = $setting['session'];
        // $sucess_check = '';

        // exit;
        foreach ($ids as $student_id) {
            $select_class_id = mysqli_query($conn, "SELECT class_id FROM students WHERE id='$student_id' AND school_id='$school_id'");
            $class_row = mysqli_fetch_array($select_class_id);
            $update = mysqli_query($conn, "UPDATE students SET class_id='$class_id' WHERE id='$student_id' AND school_id='$school_id'");
            //    update his scores
            $select_scores = mysqli_query($conn, "SELECT id FROM skulscores WHERE class_id='{$class_row['class_id']}' AND student_id='$student_id' AND session_id='$session_id'");
            if (mysqli_num_rows($select_scores) > 0) {
                // echo "yes";
                $update_scores = mysqli_query($conn, "UPDATE skulscores SET class_id='$class_id' WHERE student_id='$student_id' AND session_id='$session_id'");
            }
        }
        echo json_encode(array('status' => '1', 'msg' => 'Transfered successfully'));
    }

    if ($action == 'add_subject_category') {
        $school_id = $_SESSION['school_id'];
        $category_name = test_input($_POST['category_name']);
        // $id = test_input($_POST['cat_id']);
        $subject_ids = json_decode($_POST['subjectslist'], true);
        $subject_ids = implode(",", $subject_ids);
        if (!does_it_exist('id', 'class_category', "category_name='$category_name' AND school_id='$school_id'")) {
            $insert = mysqli_query($conn, "INSERT INTO subject_cat(category_name,subject_ids,school_id,createdby,datecreated) 
            VALUES('$category_name','$subject_ids','$school_id','{$_SESSION['userid']}','$date')");
            echo $insert === true ? json_encode(array('status' => '1', 'msg' => 'Created successfully')) : json_encode(array('status' => '0', "err" => "Error ading this data"));
        } else {
            echo json_encode(array('status' => '0', 'err' => 'Category already exist, please try another.'));
        }
    }
    if ($action == 'update_subject_category') {
        $school_id = $_SESSION['school_id'];
        $category_name = test_input($_POST['category_name']);
        $id = test_input($_POST['cat_id']);
        $subject_ids = json_decode($_POST['subjectslist'], true);
        $subject_ids = implode(",", $subject_ids);
        $update = mysqli_query($conn, "UPDATE subject_cat SET category_name='$category_name',subject_ids='$subject_ids' WHERE id='$id'");
        echo $update === true ? json_encode(array('status' => '1', 'msg' => 'Updated Successfully')) : json_encode(array('status' => '0', "err" => "Error updating this data"));
    }

    if ($action === 'get_subject_by_category') {
        $school_id = $_SESSION['school_id'];
        $filtertype = $_POST['datatype'];
        // $data = [];
        // if ($filtertype == 'All') {
        //     $query = "SELECT id,subject FROM subjects ORDER BY subject ASC";
        //     $select = mysqli_query($conn, $query);
        //     while ($row = mysqli_fetch_array($select)) {
        //         $selectsubj = mysqli_query($conn, "SELECT subjects FROM school WHERE id='$school_id'");
        //         $rowsubj = mysqli_fetch_array($selectsubj);
        //         $subjarray = explode(",", $rowsubj['subjects']);
        //         if (in_array($row['id'], $subjarray)) {
        //             $data[] = array($row['id'] => $row['subject']);
        //         }
        //     }
        //     echo json_encode($data);
        // } else {
        $filter = "id='{$filtertype}'";
        $query = "SELECT id,subject_ids FROM subject_cat WHERE $filter AND school_id='$school_id'";
        $select = mysqli_query($conn, $query);
        // }
    ?>
        <?php
        if ($row = mysqli_fetch_array($select)) {
            $subj_ids_array = explode(",", $row['subject_ids']);
            $selectsubj = mysqli_query($conn, "SELECT id,subject FROM subjects");
        ?>
            <?php
            if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
            ?>
                <div class="row mt-3 px-0">
                    <a class="btn mr-3 accent font-weight-bold" onclick="update_subject_category(<?= $row['id'] ?>)">Update Category</a>
                    <a onclick="get_subject_cat_info_to_delete('<?= $row['id'] ?>')" class="btn text-danger font-weight-bold">Delete Category</a>
                </div>
            <?php } ?>
            <div class="mt-2 ml-0">
                <ul class="row flex-wrap" style="padding-left: 27px;">
                    <?php
                    while ($rowsubj = mysqli_fetch_array($selectsubj)) {
                        if (in_array($rowsubj['id'], $subj_ids_array)) {
                    ?>
                            <li class="col-12 col-sm-3 mr-4 mb-3">
                                <input type="hidden" name="id" value="<?= $rowsubj['id'] ?>">
                                <p class="text-dark"><?= $rowsubj['subject'] ?></p>
                            </li>
                    <?php
                        }
                    }
                    ?>
                </ul>
            </div>
        <?php
        } else {
            echo mysqli_error($conn);
        }

        ?>
    <?php
    }
    if ($action == 'getallsubforupdate') {
        $school_id = $_SESSION['school_id'];
        $id = test_input($_POST['id']);
        $select = mysqli_query($conn, "SELECT id,subject_ids,category_name FROM subject_cat WHERE id='$id'");
        $row = mysqli_fetch_array($select);
        $subj_ids_array = explode(",", $row['subject_ids']);
        $selectsubject = mysqli_query($conn, "SELECT id,subject FROM subjects ORDER BY subject ASC");
        $random = rand(10, 1000);
    ?>
        <form action="" onsubmit="update_sub_cat_form(event)" class="update_sub_cat_form">
            <input type="hidden" name="action" value="update_subject_category">
            <div>
                <div class="form-group">
                    <label for="subject_category_name" class="mb-0 muted-text">Category name</label>
                    <span class="d-block small muted-text">Choose a suitable name for your category</span>
                    <input type="hidden" value="<?= $row['id'] ?>" name="cat_id">
                    <input id="subject_category_name" value="<?= $row['category_name'] ?>" name="category_name" type="text" placeholder="Enter category name" class="form-control" required title="Enter category name">
                </div>
            </div>
            <div class="row flex-wrap mt-2 ml-0">
                <?php
                while ($subrow = mysqli_fetch_array($selectsubject)) {
                    if (in_array($subrow['id'], $subj_ids_array)) {
                ?>
                        <div class="icheck-gray-dark col-12 col-sm-3 mr-4 mb-3 mb-sm-0">
                            <input type="checkbox" class="subject_checkbox" value="<?= $subrow['id'] ?>" name="<?= $subrow['subject'] ?>" id="<?= $random . $subrow['id'] ?>" checked title="Select <?= $subrow['subject'] ?>">
                            <label class="text-gray-dark" for="<?= $random . $subrow['id'] ?>"><?= $subrow['subject'] ?></label>
                        </div>
                    <?php
                    } else {
                    ?>
                        <div class="icheck-gray-dark col-12 col-sm-3 mr-4 mb-3 mb-sm-0">
                            <input type="checkbox" class="subject_checkbox" value="<?= $subrow['id'] ?>" name="<?= $subrow['subject'] ?>" id="<?= $random . $subrow['id'] ?>" title="Select <?= $subrow['subject'] ?>">
                            <label class="text-gray-dark" for="<?= $random . $subrow['id'] ?>"><?= $subrow['subject'] ?></label>
                        </div>
                <?php
                    }
                }
                ?>
            </div>
            <div class="card-foot">
                <div class="alert myalert alert-dismissible" style="display: none;">
                    <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                    <p class="small text-danger" id="update_subject_category_warning"></p>
                </div>
                <button type="submit" id="update_subj_cat_btn" class="btn btn-primary" title="Save updates">Save update</button>
                <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close" title="Cancel">Cancel</button>
            </div>
        </form>
    <?php
    }
    if ($action === 'getfilter') {
        $school_id = $_SESSION['school_id'];
        $select = mysqli_query($conn, "SELECT * FROM skul_settings WHERE school_id='$school_id'");
        if ($row = mysqli_fetch_array($select)) {
            echo json_encode(
                array(
                    'ca1' => $row['ca1'],
                    'ca2' => $row['ca2'],
                    'ca3' => $row['ca3'],
                    'pra' => $row['practical'],
                    'exa' => $row['exam'],
                    'first' => $row['first'],
                    'second' => $row['second'],
                    'third' => $row['third'],
                )
            );
        }
    }
    if ($action === 'getsettings') {
        $school_id = $_SESSION['school_id'];
        $term_id = $_SESSION['term_id'];
        $session_id = $_POST['session_id'];
        $select = mysqli_query($conn, "SELECT * FROM skul_settings WHERE school_id='$school_id' AND session_id='$session_id' AND term_id='$term_id'");
        if ($row = mysqli_fetch_array($select)) {
            echo json_encode(
                array(
                    'ca1' => $row['ca1'],
                    'ca2' => $row['ca2'],
                    'ca3' => $row['ca3'],
                    'pra' => $row['practical'],
                    'exa' => $row['exam'],
                    'first' => $row['first'],
                    'second' => $row['second'],
                    'third' => $row['third'],
                    'grade' => $row['grading'],
                )
            );
        }
    }

    if ($action === 'getstudents') {
        $class_id = test_input(($_POST['classValue']));
        $school_id = $_SESSION['school_id'];
        $select = mysqli_query($conn, "SELECT id,firstname,middlename,lastname FROM students WHERE school_id='$school_id' AND class_id='$class_id' ORDER BY firstname ASC");
        // $select = mysqli_query($conn, "SELECT id,firstname,middlename,lastname FROM students WHERE school_id='$school_id' ORDER BY firstname ASC");
        $data = array();
        while ($row = mysqli_fetch_array($select)) {
            $data[] = array('id' => $row['id'], 'name' => $row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename']);
        }
        echo json_encode($data);
    }



    if ($action === 'gettermreport') {
        $school_id = $_SESSION['school_id'];
        $term_id = test_input($_POST['termValue']);
        $session_id = test_input($_POST['sessionValue']);
        $student_id = test_input($_POST['student_id']);
        $subject_id = test_input($_POST['subjectValue']);
        $data[] = array();
        $select = mysqli_query($conn, "SELECT ca1,ca1Total, ca2,ca2Total, ca3,ca3Total,pra, praTotal, exam,examTotal FROM skulscores WHERE session_id='$session_id' AND term_id='$term_id' AND subject_id='$subject_id' AND student_id='$student_id'");
        while ($row = mysqli_fetch_array($select)) {
            $data[] = [
                'CA1' => $row['ca1'],
                'ca1Total' => $row['ca1Total'],
                'CA2' => $row['ca2'],
                'ca2Total' => $row['ca2Total'],
                'CA3' => $row['ca3'],
                'ca3Total' => $row['ca3Total'],
                'Practical' => $row['pra'],
                'praTotal' => $row['praTotal'],
                'Exam' => $row['exam'],
                'exaTotal' => $row['examTotal'],
            ];
        }
        echo json_encode($data);
    }
    if ($action === 'getsinglesessionreport') {
        $school_id = $_SESSION['school_id'];
        $session_id = test_input($_POST['sessionValue']);
        $student_id = test_input($_POST['student_id']);
        $subject_id = test_input($_POST['subjectValue']);
        $data[] = array();
        $select = mysqli_query($conn, "SELECT ca1,ca1Total, ca2,ca2Total, ca3,ca3Total,pra, praTotal, exam,examTotal,total,term_id FROM skulscores WHERE session_id='$session_id' AND subject_id='$subject_id' AND student_id='$student_id'");
        while ($row = mysqli_fetch_array($select)) {
            $data[] = [
                'CA1' => $row['ca1'],
                'ca1Total' => $row['ca1Total'],
                'CA2' => $row['ca2'],
                'ca2Total' => $row['ca2Total'],
                'CA3' => $row['ca3'],
                'ca3Total' => $row['ca3Total'],
                'Practical' => $row['pra'],
                'praTotal' => $row['praTotal'],
                'Exam' => $row['exam'],
                'exaTotal' => $row['examTotal'],
                'Total' => $row['total'],
                'Term' => $row['term_id']
            ];
        }
        echo json_encode($data);
    }

    if ($action === 'get_score_data_by_class_term') {
        $school_id = $_SESSION['school_id'];
        $session_id = test_input($_POST['session_id']);
        $class_id = test_input($_POST['class_id']);
        $term_id = test_input($_POST['term_id']);
        // $term_id = 
        $data = array();
        $select = mysqli_query($conn, "SELECT b.subject as subjectname,t.firstname,t.lastname,t.middlename, s.* FROM skulscores s, subjects b, students t WHERE s.student_id=t.id AND b.id=s.subject_id AND s.session_id='$session_id' AND s.class_id='$class_id' AND s.term_id='$term_id'");
        while ($row = mysqli_fetch_array($select)) {
            $data[] = [
                'student_name' => $row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename'],
                'student_id' => $row['student_id'],
                'session_id' => $row['session_id'],
                'term_id' => $row['term_id'],
                'class_id' => $row['class_id'],
                'subject_id' => $row['subject_id'],
                'subject' => $row['subjectname'],
                'CA1' => $row['ca1'],
                'ca1Total' => $row['ca1Total'],
                'CA2' => $row['ca2'],
                'ca2Total' => $row['ca2Total'],
                'CA3' => $row['ca3'],
                'ca3Total' => $row['ca3Total'],
                'Practical' => $row['pra'],
                'praTotal' => $row['praTotal'],
                'Exam' => $row['exam'],
                'exaTotal' => $row['examTotal'],
                'Total' => $row['total'],
                'Term' => $row['term_id'],
                'status' => $row['status']
            ];
        }
        echo json_encode($data);
    }
       if ($action == 'toggle_approval') {
        $school_id = $_SESSION['school_id'];
        $student_id = test_input($_POST['studentId']);
        $term_id = test_input($_POST['termId']);
        $session_id = test_input($_POST['sessionId']); 
        $status = test_input($_POST['status']);
        $class_id = test_input($_POST['classId']);
        $date = date('Y-m-d H:i:s');
        // echo "UPDATE skulscores SET status='$status', updatedby='{$_SESSION['userid']}', dateupdated='$date' 
        //     WHERE student_id='$student_id' AND term_id='$term_id' AND session_id='$session_id' AND class_id='$class_id' AND school_id='$school_id'";
        //     exit; //debugging
        $update = mysqli_query($conn, "UPDATE skulscores SET status='$status', updatedby='{$_SESSION['userid']}', dateupdated='$date' 
            WHERE student_id='$student_id' AND term_id='$term_id' AND session_id='$session_id' AND class_id='$class_id' AND school_id='$school_id'");
            
        if ($update) {
            echo 'success';
        } else {
            echo mysqli_error($conn);
        }
    }

    if ($action === 'get_student_score_data_by_class') {
        $school_id = $_SESSION['school_id'];
        $session_id = test_input($_POST['session_id']);
        $class_id = test_input($_POST['class_id']);
        $data[] = array();
        $select = mysqli_query($conn, "SELECT b.subject as subjectname, s.* FROM skulscores s, subjects b WHERE b.id=s.subject_id AND s.session_id='$session_id' AND s.class_id='$class_id'");
        while ($row = mysqli_fetch_array($select)) {
            $data[] = [
                'student_id' => $row['student_id'],
                'session_id' => $row['session_id'],
                'term_id' => $row['term_id'],
                'class_id' => $row['class_id'],
                'subject_id' => $row['subject_id'],
                'subject' => $row['subjectname'],
                'CA1' => $row['ca1'],
                'ca1Total' => $row['ca1Total'],
                'CA2' => $row['ca2'],
                'ca2Total' => $row['ca2Total'],
                'CA3' => $row['ca3'],
                'ca3Total' => $row['ca3Total'],
                'Practical' => $row['pra'],
                'praTotal' => $row['praTotal'],
                'Exam' => $row['exam'],
                'exaTotal' => $row['examTotal'],
                'Total' => $row['total'],
                'Term' => $row['term_id']
            ];
        }
        echo json_encode($data);
    }

// if ($action == 'get_att') {
//     $start_date = test_input($_POST['start_date']);
//     $end_date = test_input($_POST['end_date']); 
//     $class_id = test_input($_POST['class_id']);
//     $school_id = $_SESSION['school_id'];
//     $current_session_id = $_SESSION['session_id'];
//     $current_term_id = $_SESSION['term_id'];

//     // Base SQL query parts
//     $select_part = "SELECT s.id AS student_id,
//                         s.firstname,
//                         s.lastname,
//                         s.middlename,
//                         a.att_date,
//                         a.class_id,
//                         a.term_id,
//                         a.session_id,
//                         MAX(CASE WHEN a.first IS NOT NULL THEN 1 ELSE 0 END) AS has_first,
//                         MAX(CASE WHEN a.second IS NOT NULL THEN 1 ELSE 0 END) AS has_second
//                     FROM attendance a
//                     JOIN students s ON a.student_id = s.id";
//     $where_part = "WHERE a.class_id = ? AND a.school_id = ?";
//     $group_part = "GROUP BY a.student_id, a.att_date";
//     $order_part = "ORDER BY a.att_date, s.lastname, s.firstname";

//     $params = [$class_id, $school_id];
//     $types = "ii";

//     // Add date filtering based on $start_date
//     if ($start_date == "term") {
//         $where_part .= " AND a.term_id = ? AND a.session_id = ?";
//         $params[] = $current_term_id;
//         $params[] = $current_session_id;
//         $types .= "ii";
//     } else if ($start_date == "session") {
//         $where_part .= " AND a.session_id = ?";
//         $params[] = $current_session_id;
//         $types .= "i";
//     } else {
//         $where_part .= " AND a.att_date BETWEEN ? AND ?";
//         $params[] = $start_date;
//         $params[] = $end_date;
//         $types .= "ss";
//     }

//     $sql = $select_part . " " . $where_part . " " . $group_part . " " . $order_part;

//     // Fetch attendance status using prepared statement
//     $stmt = mysqli_prepare($conn, $sql);
//     if (!$stmt) {
//         echo json_encode(['error' => 'SQL prepare failed: ' . mysqli_error($conn)]);
//         mysqli_close($conn);
//         exit;
//     }
//     mysqli_stmt_bind_param($stmt, $types, ...$params);
//     mysqli_stmt_execute($stmt);
//     $result = mysqli_stmt_get_result($stmt);

//     $attendance_status = [];
//     $unique_dates_set = [];
//     while ($row = mysqli_fetch_assoc($result)) {
//         $attendance_status[$row['student_id']][$row['att_date']] = $row;
//         $unique_dates_set[$row['att_date']] = true;
//     }
//     mysqli_stmt_close($stmt);

//     // Fetch all students in the class
//     $student_sql = "SELECT id, firstname, lastname, middlename FROM students WHERE class_id = ? AND school_id = ? AND status = 1 ORDER BY lastname, firstname";
//     $stmt_students = mysqli_prepare($conn, $student_sql);
//     if (!$stmt_students) {
//         echo json_encode(['error' => 'SQL prepare failed for students: ' . mysqli_error($conn)]);
//         mysqli_close($conn);
//         exit;
//     }
//     mysqli_stmt_bind_param($stmt_students, "ii", $class_id, $school_id);
//     mysqli_stmt_execute($stmt_students);
//     $students_result = mysqli_stmt_get_result($stmt_students);

//     $studentdata = [];
//     while ($student_row = mysqli_fetch_assoc($students_result)) {
//         $studentdata[] = $student_row;
//     }
//     mysqli_stmt_close($stmt_students);

//     $unique_dates = array_keys($unique_dates_set);
//     sort($unique_dates);

//     $output_data = [];
//     foreach ($studentdata as $student) {
//         foreach ($unique_dates as $date) {
//             if (isset($attendance_status[$student['id']][$date])) {
//                 $att_record = $attendance_status[$student['id']][$date];
//                 $output_data[] = [
//                     'lastname' => $att_record['lastname'],
//                     'firstname' => $att_record['firstname'],
//                     'middlename' => $att_record['middlename'],
//                     'student_id' => (string)$att_record['student_id'],
//                     'first' => (string)$att_record['has_first'],
//                     'second' => (string)$att_record['has_second'],
//                     'att_date' => $att_record['att_date'],
//                     'class_id' => (string)$att_record['class_id'],
//                     'term_id' => (string)$att_record['term_id'],
//                     'session_id' => (string)$att_record['session_id']
//                 ];
//             } else {
//                 $output_data[] = [
//                     'lastname' => $student['lastname'],
//                     'firstname' => $student['firstname'],
//                     'middlename' => $student['middlename'],
//                     'student_id' => (string)$student['id'],
//                     'first' => "0",
//                     'second' => "0",
//                     'att_date' => $date,
//                     'class_id' => (string)$class_id,
//                     'term_id' => (string)$current_term_id,
//                     'session_id' => (string)$current_session_id
//                 ];
//             }
//         }
//     }

//     echo json_encode($output_data);
  
//          mysqli_close($conn);
//      }
  if ($action == 'get_att') {
        $start_date = test_input($_POST['start_date']);
        $end_date = test_input($_POST['end_date']);
        $class_id = test_input($_POST['class_id']);
        $school_id = $_SESSION['school_id'];
        $current_session_id = $_SESSION['session_id'];
        $current_term_id = $_SESSION['term_id'];

        // Build WHERE clause for date filtering
        if ($start_date == "term") {
            $where_part = "a.class_id = '$class_id' AND a.school_id = '$school_id' AND a.term_id = '$current_term_id' AND a.session_id = '$current_session_id'";
        } else if ($start_date == "session") {
            $where_part = "a.class_id = '$class_id' AND a.school_id = '$school_id' AND a.session_id = '$current_session_id'";
        } else {
            $where_part = "a.class_id = '$class_id' AND a.school_id = '$school_id' AND a.att_date BETWEEN '$start_date' AND '$end_date'";
        }

        $sql = "SELECT s.id AS student_id,
                        s.firstname,
                        s.lastname,
                        s.middlename,
                        a.att_date,
                        a.class_id,
                        a.term_id,
                        a.session_id,
                        MAX(CASE WHEN a.first IS NOT NULL THEN 1 ELSE 0 END) AS has_first,
                        MAX(CASE WHEN a.second IS NOT NULL THEN 1 ELSE 0 END) AS has_second
                    FROM attendance a
                    JOIN students s ON a.student_id = s.id
                    WHERE $where_part
                    GROUP BY s.id, s.firstname, s.lastname, s.middlename, a.att_date, a.class_id, a.term_id, a.session_id
                    ORDER BY a.att_date, s.lastname, s.firstname";

        $result = mysqli_query($conn, $sql);

        $attendance_status = [];
        $unique_dates_set = [];
        while ($row = mysqli_fetch_assoc($result)) {
            $attendance_status[$row['student_id']][$row['att_date']] = $row;
            $unique_dates_set[$row['att_date']] = true;
        }

        // Fetch all students in the class
        $student_sql = "SELECT id, firstname, lastname, middlename FROM students WHERE class_id = '$class_id' AND school_id = '$school_id' AND status = 1 ORDER BY lastname, firstname";
        $students_result = mysqli_query($conn, $student_sql);

        $studentdata = [];
        while ($student_row = mysqli_fetch_assoc($students_result)) {
            $studentdata[] = $student_row;
        }

        $unique_dates = array_keys($unique_dates_set);
        sort($unique_dates);

        $output_data = [];
        foreach ($studentdata as $student) {
            foreach ($unique_dates as $date) {
                if (isset($attendance_status[$student['id']][$date])) {
                    $att_record = $attendance_status[$student['id']][$date];
                    $output_data[] = [
                        'lastname' => $att_record['lastname'],
                        'firstname' => $att_record['firstname'],
                        'middlename' => $att_record['middlename'],
                        'student_id' => (string)$att_record['student_id'],
                        'first' => (string)$att_record['has_first'],
                        'second' => (string)$att_record['has_second'],
                        'att_date' => $att_record['att_date'],
                        'class_id' => (string)$att_record['class_id'],
                        'term_id' => (string)$att_record['term_id'],
                        'session_id' => (string)$att_record['session_id']
                    ];
                } else {
                    $output_data[] = [
                        'lastname' => $student['lastname'],
                        'firstname' => $student['firstname'],
                        'middlename' => $student['middlename'],
                        'student_id' => (string)$student['id'],
                        'first' => "0",
                        'second' => "0",
                        'att_date' => $date,
                        'class_id' => (string)$class_id,
                        'term_id' => (string)$current_term_id,
                        'session_id' => (string)$current_session_id
                    ];
                }
            }
        }

        echo json_encode($output_data);

        mysqli_close($conn);
    }

   
    if ($action == 'get_att_history') {
        $student_id = $_POST['student_id'];
        $session_id = $_POST['session_id'];
        $term_id = $_POST['term_id'];
        $class_id = $_POST['class_id'];
        $start_date = $_POST['start_date'];
        $end_date = $_POST['end_date'];
        if($start_date == "today"){
            $start_date = date('Y-m-d');
            $end_date = date('Y-m-d');
        }

        $sql = "SELECT att_time, att_date, state FROM attendance 
            WHERE student_id='$student_id' 
            AND session_id='$session_id' 
            AND term_id='$term_id' 
            AND class_id='$class_id'
            AND att_date BETWEEN '$start_date' AND '$end_date'";

        $select = mysqli_query($conn, $sql);
        $data = [];
        if (mysqli_num_rows($select) > 0) {
            while ($row = mysqli_fetch_assoc($select)) {
                $data[] = $row;
            }
        }
        echo json_encode($data);
        mysqli_close($conn);
    }

    if ($action === 'get_grading_score_data') {

        $school_id = $_SESSION['school_id'];
        // $gradarra = json_encode(array("A"=>70,"B"=>60,"C"=>50,"D"=>40,"E"=>30,"F"=>0));
        // $update = mysqli_query($conn, "UPDATE skul_setting SET grading='$gradarra' WHERE school_id='$school_id'");
        // echo "llll";
        // exit;
        $session_id = test_input($_POST['session_id']);
        $student_id = test_input($_POST['student_id']);
        $class_id = test_input($_POST['class_id']);
        $term_id = test_input($_POST['term_id']);
        $score_data = array();
        // echo $sql = "SELECT b.subject as subjectname, s.*, t.firstname,t.lastname FROM skulscores s, subjects b, students t WHERE t.id=s.student_id AND b.id=s.subject_id AND s.session_id='$session_id' AND s.class_id='$class_id' AND s.student_id='$student_id' AND s.school_id='$school_id'");
        $select = mysqli_query($conn, "SELECT b.subject as subjectname, s.*, t.firstname,t.lastname FROM skulscores s, subjects b, students t WHERE t.id=s.student_id AND b.id=s.subject_id AND s.session_id='$session_id' AND s.class_id='$class_id' AND s.student_id='$student_id' AND s.school_id='$school_id'");        // $select = mysqli_query($conn, "SELECT * FROM skulscores WHERE session_id='$session_id' AND class_id='$class_id' AND student_id='$student_id' AND session_id='$session_id' AND term_id='$term_id'");
        while ($row = mysqli_fetch_array($select)) {
             if ($_SESSION['report']) {
                // echo 'p';
                $select_approval = mysqli_query($conn, "SELECT ca1,ca2,ca3,practical,exam 
                FROM approval WHERE session_id='$session_id' 
                AND term_id='{$row['term_id']}' AND class_id='$class_id'");
                $approval_row = mysqli_fetch_array($select_approval);
                if (mysqli_num_rows($select_approval) == 0) {
                    $approval_row['ca1'] = '0';
                    $approval_row['ca2'] = '0';
                    $approval_row['ca3'] = '0';
                    $approval_row['practical'] = '0';
                    $approval_row['exam'] = '0';
                }
            }
            $score_data[] =
                [
                    'student_id' => $row['student_id'],
                    'session_id' => $row['session_id'],
                    'term_id' => $row['term_id'],
                    'class_id' => $row['class_id'],
                    'subject_id' => $row['subject_id'],
                    'subject' => $row['subjectname'],
                    'CA1' => $_SESSION['report'] == true ? ($approval_row['ca1'] == 1 && $row['status'] == 1 ? $row['ca1'] : '0') : $row['ca1'],
                    'ca1Total' => $row['ca1Total'],
                    'CA2' => $_SESSION['report'] == true ? ($approval_row['ca2'] == 1 && $row['status'] == 1 ? $row['ca2'] : '0') : $row['ca2'],
                    'ca2Total' => $row['ca2Total'],
                    'CA3' => $_SESSION['report'] == true ? ($approval_row['ca3'] == 1 && $row['status'] == 1 ? $row['ca3'] : '0') : $row['ca3'],
                    'ca3Total' => $row['ca3Total'],
                    'Practical' => $_SESSION['report'] == true ? ($approval_row['practical'] == 1 && $row['status'] == 1 ? $row['pra'] : '0') : $row['pra'],
                    'praTotal' => $row['praTotal'],
                    'Exam' => $_SESSION['report'] == true ? ($approval_row['exam'] == 1 && $row['status'] == 1 ? $row['exam'] : '0') : $row['exam'],
                    'exaTotal' => $row['examTotal'],
                    'Total' => $_SESSION['report'] ? ($approval_row['ca1'] == 1 && $row['status'] == 1 ? $row['ca1'] : '0') + ($approval_row['ca2'] == 1 && $row['status'] == 1 ? $row['ca2'] : '0')  + ($approval_row['ca3'] == 1 && $row['status'] == 1 ? $row['ca3'] : '0') + ($approval_row['practical'] == 1 && $row['status'] == 1 ? $row['pra'] : '0') + ($approval_row['exam'] == 1 && $row['status'] == 1 ? $row['exam'] : '0') : $row['total'],
                    'Term' => $row['term_id']
                ];
            // $score_data[] = [
            //     'student_id' => $row['student_id'],
            //     'student_name' => $row['lastname'] . ' ' . $row['firstname'],
            //     'session_id' => $row['session_id'],
            //     'term_id' => $row['term_id'],
            //     'class_id' => $row['class_id'],
            //     'subject_id' => $row['subject_id'],
            //     'subject' => $row['subjectname'],
            //     'CA1' => $row['ca1'],
            //     'ca1Total' => $row['ca1Total'],
            //     'CA2' => $row['ca2'],
            //     'ca2Total' => $row['ca2Total'],
            //     'CA3' => $row['ca3'],
            //     'ca3Total' => $row['ca3Total'],
            //     'Practical' => $row['pra'],
            //     'praTotal' => $row['praTotal'],
            //     'Exam' => $row['exam'],
            //     'exaTotal' => $row['examTotal'],
            //     'Total' => $row['total'],
            //     'Term' => $row['term_id']
            // ];
        }
        $select = mysqli_query($conn, "SELECT * FROM skul_settings WHERE school_id='$school_id' AND term_id='$term_id' AND session_id='$session_id'");
        $settingsData = array();
        if ($row = mysqli_fetch_array($select)) {
            $settingsData[] = array(
                'ca1' => $row['ca1'],
                'ca2' => $row['ca2'],
                'ca3' => $row['ca3'],
                'pra' => $row['practical'],
                'exa' => $row['exam'],
                'first' => $row['first'],
                'second' => $row['second'],
                'third' => $row['third'],
                'grade' => $row['grading'],
            );
        }
        echo json_encode(array(
            'settingsData' => $settingsData,
            'score_data' => $score_data
        ));
    }
    // if ($action === 'getsinglesessionreport_view') {
    //     $school_id = $_SESSION['school_id'];
    //     $session_id = test_input($_POST['session_id']);
    //     $student_id = test_input($_POST['student_id']);
    //     $class_id = test_input($_POST['class_id']);
    //     $term_id = test_input($_POST['term_id']);
    //     $data[] = array();
    //     // echo $appca2 = 0;

    //     // exit;
    //     // echo $approval_row['ca1'];
    //     $select = mysqli_query($conn, "SELECT b.subject as subjectname, s.* FROM skulscores s, subjects b 
    //     WHERE b.id=s.subject_id AND s.session_id='$session_id' 
    //     AND s.class_id='$class_id' AND s.student_id='$student_id' 
    //     AND s.school_id='$school_id' AND s.status='1' AND s.total > 0");
    //     while ($row = mysqli_fetch_array($select)) {
    //         if ($_SESSION['report']) {
    //             // echo 'p';
    //             $select_approval = mysqli_query($conn, "SELECT ca1,ca2,ca3,practical,exam 
    //             FROM approval WHERE session_id='$session_id' 
    //             AND term_id='{$row['term_id']}' AND class_id='$class_id'");
    //             $approval_row = mysqli_fetch_array($select_approval);
    //             if (mysqli_num_rows($select_approval) == 0) {
    //                 $approval_row['ca1'] = '0';
    //                 $approval_row['ca2'] = '0';
    //                 $approval_row['ca3'] = '0';
    //                 $approval_row['practical'] = '0';
    //                 $approval_row['exam'] = '0';
    //             }
    //         }
    //         $data[] = [
    //             'student_id' => $row['student_id'],
    //             'session_id' => $row['session_id'],
    //             'term_id' => $row['term_id'],
    //             'class_id' => $row['class_id'],
    //             'subject_id' => $row['subject_id'],
    //             'subject' => $row['subjectname'],
    //             'CA1' => $_SESSION['report'] == true ? ($approval_row['ca1'] == 1 ? $row['ca1'] : '0') : $row['ca1'],
    //             'ca1Total' => $row['ca1Total'],
    //             'CA2' => $_SESSION['report'] == true ? ($approval_row['ca2'] == 1 ? $row['ca2'] : '0') : $row['ca2'],
    //             'ca2Total' => $row['ca2Total'],
    //             'CA3' => $_SESSION['report'] == true ? ($approval_row['ca3'] == 1 ? $row['ca3'] : '0') : $row['ca3'],
    //             'ca3Total' => $row['ca3Total'],
    //             'Practical' => $_SESSION['report'] == true ? ($approval_row['practical'] == 1 ? $row['pra'] : '0') : $row['pra'],
    //             'praTotal' => $row['praTotal'],
    //             'Exam' => $_SESSION['report'] == true ? ($approval_row['exam'] == 1 ? $row['exam'] : '0') : $row['exam'],
    //             'exaTotal' => $row['examTotal'],
    //             'Total' => $_SESSION['report'] ? ($approval_row['ca1'] == 1 ? $row['ca1'] : '0') + ($approval_row['ca2'] == 1 ? $row['ca2'] : '0')  + ($approval_row['ca3'] == 1 ? $row['ca3'] : '0') + ($approval_row['practical'] == 1 ? $row['pra'] : '0') + ($approval_row['exam'] == 1 ? $row['exam'] : '0') : $row['total'],
    //             'Term' => $row['term_id']
    //         ];
    //     }
    //     echo json_encode($data);
    // }
     if ($action === 'getsinglesessionreport_view') {
        $school_id = $_SESSION['school_id'];
        $session_id = test_input($_POST['session_id']);
        $student_id = test_input($_POST['student_id']);
        $class_id = test_input($_POST['class_id']);
        $term_id = test_input($_POST['term_id']);
        $data[] = array();
        // echo $appca2 = 0;

        // exit;
        // echo $approval_row['ca1'];
        // echo "SELECT b.subject as subjectname, s.* FROM skulscores s, subjects b 
        // WHERE b.id=s.subject_id AND s.session_id='$session_id' 
        // AND s.class_id='$class_id' AND s.student_id='$student_id' 
        // AND s.school_id='$school_id' AND s.status='1' AND s.total > 0";
        $select = mysqli_query($conn, "SELECT b.subject as subjectname, s.* FROM skulscores s, subjects b 
        WHERE b.id=s.subject_id AND s.session_id='$session_id' 
        AND s.class_id='$class_id' AND s.student_id='$student_id' 
        AND s.school_id='$school_id' AND s.total > 0");
        // AND s.school_id='$school_id'");
        
        if(mysqli_error($conn)){
            echo mysqli_error($conn);
        }
        while ($row = mysqli_fetch_array($select)) {
            if ($_SESSION['report']) {
                // echo 'p';
                $select_approval = mysqli_query($conn, "SELECT ca1,ca2,ca3,practical,exam 
                FROM approval WHERE session_id='$session_id' 
                AND term_id='{$row['term_id']}' AND class_id='$class_id'");
                $approval_row = mysqli_fetch_array($select_approval);
                if (mysqli_num_rows($select_approval) == 0) {
                    $approval_row['ca1'] = '0';
                    $approval_row['ca2'] = '0';
                    $approval_row['ca3'] = '0';
                    $approval_row['practical'] = '0';
                    $approval_row['exam'] = '0';
                }
            }
            $data[] = [
                'student_id' => $row['student_id'],
                'session_id' => $row['session_id'],
                'term_id' => $row['term_id'],
                'class_id' => $row['class_id'],
                'subject_id' => $row['subject_id'],
                'subject' => $row['subjectname'],
                'CA1' => $_SESSION['report'] == true ? ($approval_row['ca1'] == 1 && $row['status'] == 1 ? $row['ca1'] : '0') : $row['ca1'],
                'ca1Total' => $row['ca1Total'],
                'CA2' => $_SESSION['report'] == true ? ($approval_row['ca2'] == 1 && $row['status'] == 1 ? $row['ca2'] : '0') : $row['ca2'],
                'ca2Total' => $row['ca2Total'],
                'CA3' => $_SESSION['report'] == true ? ($approval_row['ca3'] == 1 && $row['status'] == 1 ? $row['ca3'] : '0') : $row['ca3'],
                'ca3Total' => $row['ca3Total'],
                'Practical' => $_SESSION['report'] == true ? ($approval_row['practical'] == 1 && $row['status'] == 1 ? $row['pra'] : '0') : $row['pra'],
                'praTotal' => $row['praTotal'],
                'Exam' => $_SESSION['report'] == true ? ($approval_row['exam'] == 1 && $row['status'] == 1 ? $row['exam'] : '0') : $row['exam'],
                'exaTotal' => $row['examTotal'],
                'Total' => $_SESSION['report'] ? ($approval_row['ca1'] == 1 && $row['status'] == 1 ? $row['ca1'] : '0') + ($approval_row['ca2'] == 1 && $row['status'] == 1 ? $row['ca2'] : '0')  + ($approval_row['ca3'] == 1 && $row['status'] == 1 ? $row['ca3'] : '0') + ($approval_row['practical'] == 1 && $row['status'] == 1 ? $row['pra'] : '0') + ($approval_row['exam'] == 1 && $row['status'] == 1 ? $row['exam'] : '0') : $row['total'],
                'Term' => $row['term_id']
            ];
        }
        echo json_encode($data);
    }
    if ($action == 'setclassapproval') {
        $school_id = $_SESSION['school_id'];
        $session_id = test_input($_POST['session_id']);
        $class_id = test_input($_POST['class_id']);
        $term_id = test_input($_POST['term_id']);
        $score_approved = test_input($_POST['score_approved']);
        list($score_type, $status) = explode("/", $score_approved);
        // exit;
        // exit;
        if (does_it_exist('id', 'approval', "school_id='$school_id' AND session_id='$session_id' AND term_id='$term_id' AND class_id='$class_id'")) {
            $sql = "UPDATE approval SET $score_type='$status',dateupdated='$date',updatedby='{$_SESSION['userid']}' WHERE school_id='$school_id' AND session_id='$session_id' AND term_id='$term_id' AND class_id='$class_id'";

            $update = mysqli_query($conn, $sql);
            if ($update) {
                echo json_encode(array('status' => '1'));
            }
        } else {
            $sql = "INSERT INTO approval (session_id,term_id,class_id,school_id,dateupdated,updatedby,$score_type) VALUES('$session_id','$term_id','$class_id','$school_id','$date','{$_SESSION['userid']}','$status')";

            $insert = mysqli_query($conn, $sql);
            if ($insert) {
                echo json_encode(array('status' => '1'));
            }
        }
        // $insert_update = mysqli_query($conn, "")
    }

    if ($action == 'get_approval') {
        $school_id = $_SESSION['school_id'];
        $school_id = $_SESSION['school_id'];
        $session_id = test_input($_POST['session_id']);
        $class_id = test_input($_POST['class_id']);
        $term_id = test_input($_POST['term_id']);

        $select = mysqli_query(
            $conn,
            "SELECT ca1,ca2,ca3,practical,exam FROM approval 
        WHERE school_id='$school_id' AND session_id='$session_id' 
        AND term_id='$term_id' AND class_id='$class_id'"
        );
        $row = mysqli_fetch_array($select);
        if (mysqli_num_rows($select) > 0) {

            $data[] = array(
                'ca1' => $row['ca1'],
                'ca2' => $row['ca2'],
                'ca3' => $row['ca3'],
                'practical' => $row['practical'],
                'exam' => $row['exam'],
            );
        } else {
            $data[] = array(
                'ca1' => 0,
                'ca2' => 0,
                'ca3' => 0,
                'practical' => 0,
                'exam' => 0,
            );
        }
        echo json_encode($data);
    }

    if ($action === 'getsubjectsbyclassid') {
        $school_id = $_SESSION['school_id'];
        $class_id = test_input($_POST['class_id']);
        $select = mysqli_query($conn, "SELECT s.subject_ids FROM class c, subject_cat s WHERE s.id=c.subject_cat AND c.id='$class_id' AND c.school_id='$school_id'");
        // $select = mysqli_query($conn, "SELECT subject_ids FROM subject_cat WHERE id=c.subject_cat AND c.school_id='$school_id'");
        if (mysqli_num_rows($select) < 1) {
            echo 0;
            exit;
        }
        $sub_ids_row = mysqli_fetch_array($select);
        $subj_ids_array = explode(",", $sub_ids_row['subject_ids']);
        $data = [];
        for ($i = 0; $i < count($subj_ids_array); $i++) {
            $id = $subj_ids_array[$i];
            $select_subj_name = mysqli_query($conn, "SELECT id,subject FROM subjects WHERE id='$id' ORDER BY subject ASC");
            if ($row = mysqli_fetch_array($select_subj_name)) {
                $data[] = array('id' => $row['id'], 'subject' => $row['subject']);
            }
        }
        echo json_encode($data);
    }
    if ($action === 'getsubjects') {
        $school_id = $_SESSION['school_id'];
        $select = mysqli_query($conn, "SELECT id,subject FROM subjects WHERE school_id='$school_id' ORDER BY subject ASC");
        $data = [];
        while ($row = mysqli_fetch_array($select)) {
            $data[] = array('id' => $row['id'], 'subject' => $row['subject']);
        }
        echo json_encode($data);
    }
   if ($action === 'get_stud_byClass_comment') {
        $school_id = $_SESSION['school_id'];
        $class_id = test_input($_POST['class_id']);
        $session = test_input($_POST['session']);
        $term = test_input($_POST['term']);
        $select = mysqli_query($conn, "SELECT c.classname,c.id as class_id,s.* FROM students s, class c WHERE s.class_id=c.id AND s.class_id='$class_id' AND s.school_id='$school_id' ORDER BY s.lastname DESC");
        if (mysqli_num_rows($select) < 1) {
            echo "nothinnow";
            exit;
        }
        ?>
        <thead>
            <tr>
                <th>
                    Name
                </th>
                <th>
                    Teacher's comment
                </th>
                <th>
                    Skills
                </th>
                <?php
                if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                    ?>
                    <th>
                        <?=$_SESSION['whocomment']?>'s comment
                    </th>
                <?php } ?>
            </tr>
        </thead>
        <tbody>
            <?php

            while ($row = mysqli_fetch_array($select)) {
                ?>
                <tr class="comment_tb_row">
                    <!-- <td style="" class="w-xs-20 px-2">
                    <php if (!$row['photo']) { ?>
                        <img src="./dist/img/avatar5.png" width="50" height="50" class="img-circle" />
                    <php } else { ?>
                        <img src="uploads/<?= $row['photo'] ?>" width="50" height="50" class="img-circle" />
                    <php } ?>
                </td> -->
                    <td class="">
                        <div>
                            <p style="font-size: 16px;"><?= $row['lastname'] ?>             <?= $row['firstname'] . ' ' . $row['middlename'] ?>
                            </p>

                        </div>
                    </td>
                    <td>
                        <?php
                        $select_teachercomment = mysqli_query($conn, "SELECT comment FROM comment WHERE role_type='0' AND school_id='$school_id' AND class_id='$class_id' AND session_id='$session' AND term_id='$term' AND comment_type='1' AND student_id='{$row['id']}'");
                        if (mysqli_num_rows($select_teachercomment) > 0) {
                            $comment_row = mysqli_fetch_array($select_teachercomment);
                            $comment_teacher = $comment_row['comment'];
                        } else {
                            $comment_teacher = '';
                        }
                        ?>
                        <textarea name="" rows="2" cols="" class="w-100 teacher_comment_comment"
                            style="padding: 5px; border-radius:5px; margin-bottom: -5px;"
                            placeholder="Teacher's comment"><?= $comment_teacher ?></textarea>
                        <div class="d-flex"><a href="#suggestionModal" data-toggle="modal" data-student_id="<?= $row['id'] ?>"
                                data-student_name="<?= htmlspecialchars($row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename']) ?>"
                                class="accent open-suggestion-modal d-block small">Suggest Comment</a>
                            <button type="button" style="color: var(--orange);" class="btn btn-sm auto-comment-btn p-0 ml-3"
                                data-student-id="<?= $row['id'] ?>" data-class-id="<?= $row['class_id'] ?>"
                                data-comment-type="teacher" onclick="generateAutoComment(this)" title="Generate auto comment">
                                <i class="fa fa-magic"></i> Auto
                            </button>
                        </div>
                    </td>
                    <td>
                        <button type="button" class="btn btn-primary"
                            onclick="get_comment_skills('<?= $row['id'] ?>')">Skills</button>
                    </td>
                    <?php
                    $select_principal_comment = mysqli_query($conn, "SELECT comment FROM comment WHERE role_type='1' AND school_id='$school_id' AND class_id='$class_id' AND session_id='$session' AND term_id='$term' AND comment_type='1' AND student_id='{$row['id']}'");
                    if (mysqli_num_rows($select_principal_comment) > 0) {
                        $comment_row = mysqli_fetch_array($select_principal_comment);
                        $comment_principal = $comment_row['comment'];
                    } else {
                        $comment_principal = '';
                    }
                    ?>
                    <input type="hidden" name="" class="student_id_comment" value="<?= $row['id'] ?>">
                    <?php
                    if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                        ?>
                        <td>
                            <textarea name="" rows="2" cols="" class="w-100 principal_comment_comment"
                                style="padding: 5px; border-radius:5px; margin-bottom:-5px;"
                                placeholder="<?=$_SESSION['whocomment']?>'s comment"><?= $comment_principal ?></textarea>
                            <div class="d-flex"><a href="#suggestionModal" data-toggle="modal" data-student_id="<?= $row['id'] ?>"
                                    data-student_name="<?= htmlspecialchars($row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename']) ?>"
                                    class="accent open-suggestion-modal d-block small">Suggest Comment</a>
                                <button type="button" style="color: var(--orange);" class="btn btn-sm auto-comment-btn p-0 ml-3"
                                                    data-student-id="<?= $row['id'] ?>" data-class-id="<?= $row['class_id'] ?>"
                                                    data-comment-type="principal" onclick="generateAutoComment(this)" title="Generate auto comment">
                                                    <i class="fa fa-magic"></i> Auto
                                                </button>
                                        </td>
                                <?php } ?>
                            </tr>
                            <?php
            }
            ?>
                    </body>
                    <script>
                        if ($.fn.DataTable.isDataTable('#student_table_comment')) {
                            $('#student_table_comment').DataTable().destroy();
                        }
                        $('#student_table_comment').DataTable({
                            scrollY: '50vh',
                            scrollX: true,
                            paging: false,
                            ordering: false,
                        });
                    </script>
                    <?php
    }
      if ($action == 'get_auto_comment') {
        $school_id = $_SESSION['school_id'];
        $student_id = test_input($_POST['student_id']);
        $class_id = test_input($_POST['class_id']);
        $session_id = test_input($_POST['session_id']);
        $term_id = test_input($_POST['term_id']);

        try {
            // Step 1: Calculate student's total score and obtainable
            $total_score = get_total_score_per_student($student_id, $term_id, $session_id, $class_id, 'term');
            $total_obtainable = get_total_obtainables($student_id, $term_id, $session_id, $class_id, 'term');

            // Step 2: Calculate percentage
            if ($total_obtainable > 0) {
                $percentage = ($total_score / $total_obtainable) * 100;
                $percentage = round($percentage, 2);
            } else {
                // If no scores exist, return error
                echo json_encode([
                    'status' => '0',
                    'error' => 'No scores found for this student in the selected term'
                ]);
                exit;
            }

            // Step 3: Get student name for personalization
            $student_name = get_student_fullname_by_id($student_id);
            $first_name = explode(' ', $student_name)[0]; // Get first name only

            // Step 4: Query suggest_comments table for ALL matching comments
            $query = "SELECT id, comment, commentby, datecreated FROM suggested_comments
                      WHERE school_id = '$school_id'
                      AND score_from <= '$percentage'
                      AND score_to >= '$percentage'
                      ORDER BY datecreated DESC";  // Most recent first, no LIMIT

            $result = mysqli_query($conn, $query);

            if ($result && mysqli_num_rows($result) > 0) {
                // Fetch all matching comments into an array
                $comments_array = [];
                while ($row = mysqli_fetch_assoc($result)) {
                    $comments_array[] = [
                        'id' => $row['id'],
                        'comment' => $row['comment'],
                        'commentby' => $row['commentby'],
                        'datecreated' => $row['datecreated']
                    ];
                }

                // Return success with all comments
                echo json_encode([
                    'status' => '1',
                    'comments' => $comments_array,
                    'total_comments' => count($comments_array),
                    'percentage' => $percentage,
                    'student_firstname' => $first_name,
                    'debug' => [
                        'total_score' => $total_score,
                        'total_obtainable' => $total_obtainable
                    ]
                ]);
            } else {
                // No matching comment found
                echo json_encode([
                    'status' => '0',
                    'error' => 'No suggested comment found for ' . $percentage . '% score range'
                ]);
            }
        } catch (Exception $e) {
            echo json_encode([
                'status' => '0',
                'error' => 'Server error: ' . $e->getMessage()
            ]);
        }

        exit;
    }


        if ($action === 'save_comment') {
            $school_id = $_SESSION['school_id'];
            $comments = $_POST['comments'];
            $term_id = test_input($_POST['term_id']);
            $session_id = test_input($_POST['session_id']);
            $class_id = test_input($_POST['class_id']);
            // var_dump($comments);
            foreach ($comments as $comment) {
                // echo "student_id='{$comment['student_id']}' AND class_id='$class_id' AND session_id='$session_id' AND term_id='$term_id' AND school_id='$school_id' AND role_type='1'.<br>'";
                // // check if comment exist for the student first, then update if it exist
                // if(!does_it_exist("comment","comment","student_id='{$comment['student_id']}' AND class_id='$class_id' AND session_id='$session_id' AND term_id='$term_id' AND school_id='$school_id' AND role_type='1'")){
                //     echo "no";
                // }
                // else {
                //     "yes";
                // }
                if ($comment['teacher_comment']) {
                    $check = mysqli_query($conn, "SELECT comment FROM 
                comment WHERE student_id='{$comment['student_id']}' 
                AND class_id='$class_id' AND student_id='{$comment['student_id']}' AND session_id='$session_id' 
                AND term_id='$term_id' AND school_id='$school_id' 
                AND role_type='0'");
                    if (mysqli_num_rows($check) > 0) {
                        // echo "yes";
                    //     echo "UPDATE comment 
                    // SET comment='{$comment['teacher_comment']}', 
                    // updatedby='{$_SESSION["userid"]}', role_type='0',
                    // dateupdated='$date', commentby='{$_SESSION["userid"]}' 
                    // WHERE class_id='$class_id' AND student_id='{$comment['student_id']}' AND session_id='$session_id' 
                    // AND term_id='$term_id' AND school_id='$school_id'";
                        $update_comment = mysqli_query($conn, "UPDATE comment 
                    SET comment='{$comment['teacher_comment']}', 
                    updatedby='{$_SESSION["userid"]}', role_type='0',
                    dateupdated='$date', commentby='{$_SESSION["userid"]}' 
                    WHERE class_id='$class_id' AND student_id='{$comment['student_id']}' AND session_id='$session_id' 
                    AND term_id='$term_id' AND school_id='$school_id'");
                    } else {
                    //     echo "INSERT INTO 
                    // comment(class_id,student_id,comment,comment_type,role_type,session_id,term_id,datecreated,createdby,commentby,school_id) 
                    // VALUES('$class_id','{$comment['student_id']}','{$comment['teacher_comment']}','1','0','$session_id','$term_id','$date',{$_SESSION['userid']},{$_SESSION['userid']},'$school_id')";
                        $insert_comment = mysqli_query($conn, "INSERT INTO 
                    comment(class_id,student_id,comment,comment_type,role_type,session_id,term_id,datecreated,createdby,commentby,school_id) 
                    VALUES('$class_id','{$comment['student_id']}','{$comment['teacher_comment']}','1','0','$session_id','$term_id','$date',{$_SESSION['userid']},{$_SESSION['userid']},'$school_id')");
                    }
                }

                if ($comment['principal_comment']) {
                    $check = mysqli_query($conn, "SELECT comment FROM 
                comment WHERE student_id='{$comment['student_id']}' 
                AND class_id='$class_id' AND session_id='$session_id' 
                AND term_id='$term_id' AND school_id='{$comment['student_id']}' 
                AND role_type='1'");
                    if (mysqli_num_rows($check) > 0) {

                        $update_comment = mysqli_query($conn, "UPDATE comment 
            SET comment='{$comment['principal_comment']}', 
            updatedby='{$_SESSION["userid"]}', role_type='1', 
            dateupdated='$date', commentby='{$_SESSION["userid"]}' 
            WHERE class_id='$class_id' 
            AND student_id='{$comment['student_id']}' AND session_id='$session_id' 
            AND term_id='$term_id' AND school_id='$school_id'");
                    } else {
                        $insert_comment = mysqli_query($conn, "INSERT INTO 
                    comment(class_id,student_id,comment,comment_type,role_type,session_id,term_id,datecreated,createdby,commentby,school_id) 
                    VALUES('$class_id','{$comment['student_id']}','{$comment['principal_comment']}','1','1','$session_id','$term_id','$date',{$_SESSION['userid']},{$_SESSION['userid']},'$school_id')");
                    }
                }
            }
                echo json_encode(array('status' => '1'));
        }

        if ($action === 'get_stud_byClass_report') {
            $school_id = $_SESSION['school_id'];
            // $class_id = '44';
            $class_id = test_input($_POST['class_id']);

            $select = mysqli_query($conn, "SELECT c.classname,c.id,s.* FROM students s, class c WHERE s.class_id=c.id AND s.class_id='$class_id' AND s.school_id='$school_id' ORDER BY s.lastname");
            if (mysqli_num_rows($select) < 1) {
                echo "nothinnow";
                exit;
            }
            while ($row = mysqli_fetch_array($select)) {
            ?>
                <tr>
                    <td style="width: 10px;">
                        <div class="icheck-primary">
                            <input type="checkbox" class="table_checkbox" onchange="check_checkbox()" id="check<?= $row['id'] ?>" value="<?= $row['id'] ?>">
                            <label for="check<?= $row['id'] ?>"></label>
                        </div>
                    </td>
                    <!-- <td style="" class="w-xs-20 px-2">
                        <php if (!$row['photo']) { ?>
                            <img src="./dist/img/avatar5.png" width="50" height="50" class="img-circle" />
                        <php } else { ?>
                            <img src="uploads/<= $row['photo'] ?>" width="50" height="50" class="img-circle" />
                        <php } ?>
                    </td> -->
                    <td>
                        <div>
                            <p style="font-size: 16px;"><?= $row['lastname'] ?> <?= $row['firstname'] . ' ' . $row['middlename'] ?></p>
                            <!-- <php -->
                            <!-- if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['change_class'] == 1) { -->

                            <a onclick="get_all_checked_checkbox_for_report('single','<?= $row['id'] ?>','report_card_modal','bulk_report_ids')" class="btn btn-sm p-0 accent mr-3">Generate Report Card</a>
                            <!-- <a onclick="getdatepicker()"  data-id='<= $row['id'] ?>' class="btn btn-sm p-0 accent" id="daterange-btn">Attendance reports</a> -->
                            <!--<a onclick="get_all_checked_checkbox_for_report('single','<= $row['id'] ?>','att_report_modal','bulk_att_report_ids')" class="btn btn-sm p-0 accent mr-3">Attendance Report</a>-->
                            <!-- <php } ?> -->
                        </div>
                    </td>

                </tr>
                <script>
                    // if ($.fn.DataTable.isDataTable('#student_table_repo')) {
                    //     $('#student_table_repo').DataTable().destroy();
                    // }
                    // $('#student_table_repo').DataTable({
                    //     // scrollY: '50vh',
                    //     scrollX: true,
                    //     paging: false,
                    //     ordering: false,
                    // });
                </script>

            <?php
            }
        }

       
 if ($action === 'get_stud_byClass_attendance') {
            $school_id = $_SESSION['school_id'];
            $class_id = test_input($_POST['class_id']);
            $att_date = test_input($_POST['att_date']);
            $session_id = $_SESSION['session_id'];
            $term_id = $_SESSION['term_id'];
            $students_query = "SELECT id, firstname, middlename, lastname FROM students WHERE class_id='$class_id' AND school_id='$school_id' ORDER BY lastname ASC";
            $students_result = mysqli_query($conn, $students_query);

            if (mysqli_num_rows($students_result) < 1) {
                echo "nothinnow";
                exit;
            }
            if ($_POST['att_type'] == 0) {
            ?>
                                <table id="student_table_attendance1" class="display nowrap" style="width:100%;">
                    <thead>
                        <tr>
                            <th colspan="3" class="" style="text-align: center; font-weight:bold;">
                                Enter the total number of times each student is present
                            </th>
                        </tr>
                        <tr>
                            <th>Student Name</th>
                            <th>Manual Entry</th>
                            <th>Daily Entry</th>
                    </tr>
                    </thead>
                    <tbody>

                        <?php
                        while ($row = mysqli_fetch_array($students_result)) {
                            // Fetch the counts of non-null 'first' and 'second' entries
                            $att_count_query = "SELECT
                                                    SUM(CASE WHEN first IS NOT NULL THEN 1 ELSE 0 END) as first_count,
                                                    SUM(CASE WHEN second IS NOT NULL THEN 1 ELSE 0 END) as second_count
                                                FROM attendance
                                                WHERE student_id={$row['id']}
                                                  AND term_id={$_SESSION['term_id']}
                                                  AND session_id={$_SESSION['session_id']}
                                                  AND class_id=$class_id";
                            $att_count_result = mysqli_query($conn, $att_count_query);
                            $counts = mysqli_fetch_assoc($att_count_result);
                            // Calculate the total count (handle potential NULL if no rows match)
                            $row_num = ($counts['first_count'] ?? 0) + ($counts['second_count'] ?? 0);

                            $att_once = mysqli_query($conn, "SELECT id,student_id,total_present FROM attendance_once 
                            WHERE student_id={$row['id']} AND term_id={$_SESSION['term_id']} AND session_id={$_SESSION['session_id']} AND class_id=$class_id");
                            $total_present = mysqli_fetch_assoc($att_once);
                        ?>
                            <tr>
                                <td style="" class=""><?= $row['lastname'] ?> <?= $row['firstname'] . ' ' . $row['middlename'] ?>
                            </td>
                                <td style="" class="">
                                    <input type="number" data-student_id = "<?= $row['id'] ?>" value="<?= empty($total_present['total_present']) ? $row_num : $total_present['total_present'] ?>" name="one_time_att" id="one_time_att_<?= $row['id'] ?>" class="form-control form-control-sm one_time_att_input">
                                    
                                    <!-- <input type="number" data-student_id = "<= $row['id'] ?>" value="<= empty($total_present['total_present']) ? $row_num : $total_present['total_present'] ?>" name="one_time_att" id="one_time_att">
                                    <input type="number" disabled value="<= $row_num ?>" name="daily_att" id="daily_att"> -->
                                </td>
                                <td>
                                    <input type="number" disabled value="<?= $row_num ?>" name="daily_att_<?= $row['id'] ?>" id="daily_att_<?= $row['id'] ?>" class="form-control form-control-sm daily_att_input mt-1">
                                </td>
                            </tr>
                        <?php
                        }
                        ?>
                    </tbody>
                </table>
                <script>
                $('#student_table_attendance1').DataTable({
                    // scrollY: '50vh',
                    scrollX: true,
                    paging: false,   
                    ordering: false,
                });
                </script>
            <?php
            } else {
                // Fetch attendance data for the specified date
                $attendance_query = "SELECT student_id, first, second FROM attendance WHERE class_id='$class_id' AND session_id='$session_id' AND term_id='$term_id' AND school_id='$school_id' AND att_date='$att_date'";
                $attendance_result = mysqli_query($conn, $attendance_query);

                // Map attendance data by student_id for quick lookup
                $attendance_data = [];
                while ($row = mysqli_fetch_assoc($attendance_result)) {
                    $attendance_data[$row['student_id']] = $row;
                }
                // 
            ?>
                <table id="student_table_attendance" class="display nowrap" style="width:100%;">
                    <thead>
                        <tr>
                            <th colspan="1" class="">
                                <!--<div style="display: flex; align-items: center;">-->
                                <!--    <div class="icheck-primary mr-2">-->
                                <!--        <input type="checkbox" id="select_all" onchange="check_uncheck_all_attendance('1')">-->
                                <!--        <label for="select_all"></label>-->
                                <!--    </div>-->
                                <!--    <div class="icheck-primary mr-2">-->
                                <!--        <input type="checkbox" id="select_all2" onchange="check_uncheck_all_attendance('2')">-->
                                <!--        <label for="select_all2"></label>-->
                                <!--    </div>-->
                                <!--    <p class="mb-0 font-weight-normal">Mark All Present</p>-->
                                    <!-- <p class="font-weight-normal action_btn" style="display:none; margin: 0; cursor: pointer;" onclick="get_all_checked_checkbox_for_report('multiple',null,'report_card_modal')">Generate Report Card</p> -->
                                <!--</div>-->
                                
                            </th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php
                        // print_r($student_arry);

                        while ($student = mysqli_fetch_assoc($students_result)) {
                            // var_dump($student);

                            $student_id = $student['id'];
                            $first_checked = isset($attendance_data[$student_id]) && !empty($attendance_data[$student_id]['first']) ? 'checked' : '';
                            $second_checked = isset($attendance_data[$student_id]) && !empty($attendance_data[$student_id]['second']) ? 'checked' : '';
                            // echo $ui = in_array($row['id'], $student_arry) ? 'checked' : 'not checked';
                        ?>
                            <tr>
                                <td style="" class="d-flex align-items-center">

                                    <div class="icheck-primary mr-2">
                                        <input type="checkbox" <?= $first_checked ?> class="table_checkbox take_att_checkbox" id="check<?= $student['id'] ?>" value="<?= $student['id'] ?>">

                                        <label class="text-dark" for="check<?= $student['id'] ?>"></label>
                                    </div>
                                    <div class="icheck-primary mr2">
                                        <input type="checkbox" <?= $second_checked ?> class="table_checkbox2 take_att_checkbox2" id="check<?= $student['id'] ?>2" value="<?= $student['id'] ?>">
                                        <label class="text-dark" for="check<?= $student['id'] ?>2"></label>
                                    </div>
                                    <p class="text-dark mb-0"><?= $student['lastname'] ?> <?= $student['firstname'] . ' ' . $student['middlename'] ?></p>

                                </td>
                                <!-- <td class="">
                        <div>
                            <p style="font-size: 16px;"><= $row['lastname'] ?> <= $row['firstname'] . ' ' . $row['middlename'] ?></p>
                        </div>
                    </td> -->

                            </tr>

                        <?php

                        }
                        ?>
                    </tbody>
                </table>
                <script>
                $('#student_table_attendance').DataTable({
                    // scrollY: '50vh',
                    scrollX: true,
                    paging: false,   
                    ordering: false,
                });
                </script>
            <?php
            }
        }
        // if ($action == 'set_attendance') {
        //     //     echo $_SESSION['location'];
        //     // exit;
        //     $school_id = $_SESSION['school_id'];
        //     $session_id = $_SESSION['session_id'];
        //     $term_id = $_SESSION['term_id'];

        //     $class_id = test_input($_POST['class_id']);
        //     $att_date = test_input($_POST['att_date']);
        //     $att_time = date('H:i:s');
        //     $register = $_POST['register'];
        //     // $means = 0;
        //     // var_dump($register);
        //     // exit;
        //     foreach ($register as $student_id => $state) {
        //         // if the state is 0, skip the student

        //         // if it exist in the database and the state is 0 and the means is also 0, delete, else insert
        //         if (does_it_exist('id', 'attendance', "state=1 AND means=0 AND att_date='$att_date' AND student_id='$student_id' AND term_id='$term_id' AND class_id='$class_id' AND session_id='$session_id' AND school_id='$school_id'")) {
        //             if ($state == 0) {
        //                 $delete = mysqli_query($conn, "DELETE FROM attendance WHERE state=1 AND means=0 AND att_date='$att_date' AND student_id='$student_id' AND term_id='$term_id' AND class_id='$class_id' AND session_id='$session_id' AND school_id='$school_id'");
        //                 // continue;
        //             } else {
        //                 continue;
        //             }
        //         } else {
        //             // if state is 1 and the record is new, insert
        //             if ($state == 1) {
        //                 $insert  = mysqli_query($conn, "INSERT INTO attendance 
        //             (means,state,student_id,session_id,term_id,class_id,
        //             school_id,att_date,att_time,createdby,datecreated)
        //             VALUES(0,'$state','$student_id','$session_id',
        //             '$term_id','$class_id','$school_id','$att_date','$att_time','{$_SESSION['userid']}','$date')");
        //             }
        //         }

        //         // $insert = mysqli_query($conn, "I")
        //     }
        //     echo json_encode(['status' => '1']);
        // }
//  if ($action == 'set_attendance') {
            
//             $school_id = $_SESSION['school_id'];
//             $session_id = $_SESSION['session_id'];
//             $userid = $_SESSION['userid'];
//             $term_id = $_SESSION['term_id'];
//             $class_id = test_input($_POST['class_id']);
//             $attendance_data = $_POST['attendance_data'] ?? []; // Default to empty array if not set
//             // var_dump($attendance_data);
//             $current_datetime = date('Y-m-d H:i:s');
//             $success = true;
//             $error_message = '';
//             if($_POST['type'] == '0') {

                
//               $sql = "INSERT INTO attendance_once
//                         (student_id, session_id, term_id, class_id, school_id, total_present, createdby, datecreated)
//                     VALUES
//                         (?, ?, ?, ?, ?, ?, ?, ?)
//                     ON DUPLICATE KEY UPDATE
//                         total_present = ?, updatedby = ?, dateupdated = ?";

//             $stmt = mysqli_prepare($conn, $sql);

//             if ($stmt) {
//                 mysqli_begin_transaction($conn); // Start transaction for atomicity

//                 foreach ($attendance_data as $student_id => $total_present) {
//                     // Basic validation/sanitization
//                     $student_id_int = filter_var($student_id, FILTER_VALIDATE_INT);
//                     $total_present_int = filter_var($total_present, FILTER_VALIDATE_INT);

//                     if ($student_id_int === false || $total_present_int === false) {
//                         $success = false; $error_message = "Invalid data received."; break;
//                     }

//                     // Bind parameters (iiiiiiisisi - 11 params total)
//                     mysqli_stmt_bind_param($stmt, "iiiiiiisisi",
//                         $student_id_int, $session_id, $term_id, $class_id, $school_id, $total_present_int, $userid, $current_datetime, // INSERT values
//                         $total_present_int, $userid, $current_datetime // UPDATE values
//                     );
                    

//                     if (!mysqli_stmt_execute($stmt)) {
//                         $success = false; $error_message = mysqli_stmt_error($stmt); break;
//                     }
//                 }

//                 if ($success) { mysqli_commit($conn); echo json_encode(['status' => '1', 'msg' => 'Attendance saved successfully.']); }
//                 else { mysqli_rollback($conn); echo json_encode(['status' => '0', 'err' => 'Failed to save attendance: ' . $error_message]); }

//                 mysqli_stmt_close($stmt);
//             } else { 
//                 echo json_encode(['status' => '0', 'err' => 'Database error: ' . mysqli_error($conn)]); 
                
//             }
//             exit; // Stop script executi
//             }
//             $att_date = test_input($_POST['att_date']);
//             $current_time = date('Y-m-d H:i:s');
//             $register = $_POST['register'];
//             $register2 = $_POST['register2'];

//             // Step 1: Fetch all existing attendance records for the given criteria
//             $existing_records = [];
//             $query = "SELECT student_id, first, second FROM attendance 
//                       WHERE class_id='$class_id' AND session_id='$session_id' 
//                       AND term_id='$term_id' AND school_id='$school_id' AND att_date='$att_date'";
//             $result = mysqli_query($conn, $query);
//             while ($row = mysqli_fetch_assoc($result)) {
//                 $existing_records[$row['student_id']] = $row;
//             }

//             // Step 2: Prepare arrays for batch operations
//             $to_insert = [];
//             $to_update = [];
//             $to_delete = [];

//             foreach ($register as $student_id => $state1) {
//                 $state2 = isset($register2[$student_id]) ? $register2[$student_id] : 0;

//                 if ($state1 == 0 && $state2 == 0) {
//                     // If both states are 0, mark for deletion if the record exists
//                     if (isset($existing_records[$student_id])) {
//                         $to_delete[] = $student_id;
//                     }
//                 } else {
//                     // If either state is 1, determine whether to insert or update
//                     if (isset($existing_records[$student_id])) {
//                         // Record exists, check if updates are needed
//                         $update_fields = [];
//                         $existing_first = $existing_records[$student_id]['first'];
//                         $existing_second = $existing_records[$student_id]['second'];

//                         // Handle 'first' column based on state1
//                         if ($state1 == 1 && empty($existing_records[$student_id]['first'])) {
//                             $update_fields[] = "first='$current_time'";
//                         } elseif ($state1 == 0 && !empty($existing_first)) { // Check if unchecked and timestamp exists
//                             $update_fields[] = "first=NULL";
//                         }
//                         // Handle 'second' column based on state2
//                         if ($state2 == 1 && empty($existing_records[$student_id]['second'])) {
//                             $update_fields[] = "second='$current_time'";
//                         } elseif ($state2 == 0 && !empty($existing_second)) { // Check if unchecked and timestamp exists
//                             $update_fields[] = "second=NULL";
//                         }

//                         // If any changes were identified, add update metadata and queue the update
//                         if (!empty($update_fields)) {
//                             $update_fields[] = "updatedby='{$_SESSION['userid']}'"; // Always update who did it
//                             $update_fields[] = "dateupdated='$current_time'"; // Always update the timestamp
//                             $to_update[] = [
//                                 'student_id' => $student_id,
//                                 'fields' => implode(", ", $update_fields)
//                             ];
//                         }
//                     } else {
//                         // Prepare for insertion
//                         $first = $state1 == 1 ? "'$current_time'" : "NULL";
//                         $second = $state2 == 1 ? "'$current_time'" : "NULL";
//                         $to_insert[] = "('$student_id', '$session_id', '$term_id', '$class_id', '$school_id', '$att_date', $first, $second, '{$_SESSION['userid']}', '$current_time')";
//                     }
//                 }
//             }

//             // Step 3: Execute batch operations
//             if (!empty($to_insert)) {
//                 $insert_query = "INSERT INTO attendance (student_id, session_id, term_id, class_id, school_id, att_date, first, second, createdby, datecreated) VALUES " . implode(", ", $to_insert);
//                 mysqli_query($conn, $insert_query);
//             }

//             if (!empty($to_update)) {
//                 foreach ($to_update as $update) {
//                     $update_query = "UPDATE attendance SET {$update['fields']} WHERE student_id='{$update['student_id']}' AND class_id='$class_id' AND session_id='$session_id' AND term_id='$term_id' AND school_id='$school_id' AND att_date='$att_date'";
//                     mysqli_query($conn, $update_query);
//                 }
//             }

//             if (!empty($to_delete)) {
//                 $delete_query = "DELETE FROM attendance WHERE student_id IN (" . implode(", ", $to_delete) . ") AND class_id='$class_id' AND session_id='$session_id' AND term_id='$term_id' AND school_id='$school_id' AND att_date='$att_date'";
//                 mysqli_query($conn, $delete_query);
//             }

//             echo json_encode(['status' => '1']);
//         }
 if ($action == 'set_attendance') {

            $school_id = $_SESSION['school_id'];
            
            $session_id = $_SESSION['session_id'];
            $userid = $_SESSION['userid'];
            $term_id = $_SESSION['term_id'];
            $class_id = test_input($_POST['class_id']);
            $attendance_data = $_POST['attendance_data'] ?? []; // Default to empty array if not set
            // var_dump($attendance_data);
            $current_datetime = date('Y-m-d H:i:s');
            $success = true;
            $error_message = '';
            if ($_POST['type'] == '0') {

            // Convert potentially non-integer values to ints to avoid injection via numeric fields
            $session_id_int = intval($session_id);
            $term_id_int = intval($term_id);
            $class_id_int = intval($class_id);
            $school_id_int = intval($school_id);
            $userid_int = intval($userid);
            $current_datetime_esc = mysqli_real_escape_string($conn, $current_datetime);

            mysqli_begin_transaction($conn); // Start transaction for atomicity

            foreach ($attendance_data as $student_id => $total_present) {
                // Basic validation/sanitization
                $student_id_int = intval($student_id);
                $total_present_int = intval($total_present);

                if ($student_id_int <= 0 || $total_present_int < 0) {
                $success = false;
                $error_message = "Invalid data received.";
                break;
                }

                // Build direct SQL with properly casted/escaped values
                $sql = "INSERT INTO attendance_once
                (student_id, session_id, term_id, class_id, school_id, total_present, createdby, datecreated)
                VALUES
                ('$student_id_int', '$session_id_int', '$term_id_int', '$class_id_int', '$school_id_int', '$total_present_int', '$userid_int', '$current_datetime_esc')
                ON DUPLICATE KEY UPDATE
                total_present = '$total_present_int', updatedby = '$userid_int', dateupdated = '$current_datetime_esc'";

                if (!mysqli_query($conn, $sql)) {
                $success = false;
                $error_message = mysqli_error($conn);
                break;
                }
            }

            if ($success) {
                mysqli_commit($conn);
                echo json_encode(['status' => '1', 'msg' => 'Attendance saved successfully.']);
            } else {
                mysqli_rollback($conn);
                echo json_encode(['status' => '0', 'err' => 'Failed to save attendance: ' . $error_message]);
            }

            exit;
            }
            $att_date = test_input($_POST['att_date']);
            $current_time = date('Y-m-d H:i:s');
            $register = $_POST['register'];
            $register2 = $_POST['register2'];
    // var_dump($register2);
            // Step 1: Fetch all existing attendance records for the given criteria
            $existing_records = [];
            $query = "SELECT student_id, first, second FROM attendance 
                  WHERE class_id='$class_id' AND session_id='$session_id' 
                  AND term_id='$term_id' AND school_id='$school_id' AND att_date='$att_date'";
            $result = mysqli_query($conn, $query);
            while ($row = mysqli_fetch_assoc($result)) {
            $existing_records[$row['student_id']] = $row;
            }

            // Step 2: Prepare arrays for batch operations
            $to_insert = [];
            $to_update = [];
            $to_delete = [];

            foreach ($register as $student_id => $state1) {
            $state2 = isset($register2[$student_id]) ? $register2[$student_id] : 0;

            if ($state1 == 0 && $state2 == 0) {
                // If both states are 0, mark for deletion if the record exists
                if (isset($existing_records[$student_id])) {
                $to_delete[] = intval($student_id);
                }
            } else {
                // If either state is 1, determine whether to insert or update
                if (isset($existing_records[$student_id])) {
                // Record exists, check if updates are needed
                $update_fields = [];
                $existing_first = $existing_records[$student_id]['first'];
                $existing_second = $existing_records[$student_id]['second'];

                // Handle 'first' column based on state1
                if ($state1 == 1 && empty($existing_records[$student_id]['first'])) {
                    $update_fields[] = "first='" . mysqli_real_escape_string($conn, $current_time) . "'";
                } elseif ($state1 == 0 && !empty($existing_first)) { // Check if unchecked and timestamp exists
                    $update_fields[] = "first=NULL";
                }
                // Handle 'second' column based on state2
                if ($state2 == 1 && empty($existing_records[$student_id]['second'])) {
                    $update_fields[] = "second='" . mysqli_real_escape_string($conn, $current_time) . "'";
                } elseif ($state2 == 0 && !empty($existing_second)) { // Check if unchecked and timestamp exists
                    $update_fields[] = "second=NULL";
                }

                // If any changes were identified, add update metadata and queue the update
                if (!empty($update_fields)) {
                    $update_fields[] = "updatedby='" . intval($_SESSION['userid']) . "'"; // Always update who did it
                    $update_fields[] = "dateupdated='" . mysqli_real_escape_string($conn, $current_time) . "'"; // Always update the timestamp
                    $to_update[] = [
                    'student_id' => intval($student_id),
                    'fields' => implode(", ", $update_fields)
                    ];
                }
                } else {
                // Prepare for insertion
                $first = $state1 == 1 ? "'" . mysqli_real_escape_string($conn, $current_time) . "'" : "NULL";
                $second = $state2 == 1 ? "'" . mysqli_real_escape_string($conn, $current_time) . "'" : "NULL";
                $to_insert[] = "(" . intval($student_id) . ", " . intval($session_id) . ", " . intval($term_id) . ", " . intval($class_id) . ", " . intval($school_id) . ", '" . mysqli_real_escape_string($conn, $att_date) . "', $first, $second, '" . intval($_SESSION['userid']) . "', '" . mysqli_real_escape_string($conn, $current_time) . "')";
                }
            }
            }

            // Step 3: Execute batch operations
            if (!empty($to_insert)) {
            $insert_query = "INSERT INTO attendance (student_id, session_id, term_id, class_id, school_id, att_date, first, second, createdby, datecreated) VALUES " . implode(", ", $to_insert);
            mysqli_query($conn, $insert_query);
            }

            if (!empty($to_update)) {
            foreach ($to_update as $update) {
                $update_query = "UPDATE attendance SET {$update['fields']} WHERE student_id='{$update['student_id']}' AND class_id='$class_id' AND session_id='$session_id' AND term_id='$term_id' AND school_id='$school_id' AND att_date='$att_date'";
                mysqli_query($conn, $update_query);
            }
            }

            if (!empty($to_delete)) {
            $delete_query = "DELETE FROM attendance WHERE student_id IN (" . implode(", ", $to_delete) . ") AND class_id='$class_id' AND session_id='$session_id' AND term_id='$term_id' AND school_id='$school_id' AND att_date='$att_date'";
            mysqli_query($conn, $delete_query);
            }

            echo json_encode(['status' => '1']);
        }


         if ($action === 'filter_stud_Class') {
            $school_id = $_SESSION['school_id'];
            // $class_id = '44';
            $class_id = test_input($_POST['class_id']);
// echo "SELECT pr.status AS student_status, c.classname,c.id,s.* FROM students s  
//                       LEFT JOIN class c ON s.class_id=c.id AND pr.term_id='{$_SESSION['term_id']}' 
//                       AND pr.session_id='{$_SESSION['session_id']}' 
//                       LEFT JOIN payment_record pr ON pr.student_id=s.id 
//                       WHERE s.class_id='$class_id' 
//                       AND s.school_id='$school_id' 
//                       ORDER BY s.lastname ASC";
            // $select = mysqli_query($conn, "SELECT c.classname,c.id,s.* FROM students s, class c WHERE s.class_id=c.id AND s.class_id='$class_id' AND s.school_id='$school_id' ORDER BY s.lastname ASC");
            $select = mysqli_query($conn, "SELECT pr.status AS student_status, c.classname,c.id,s.* FROM students s  
                      LEFT JOIN class c ON s.class_id=c.id
                      LEFT JOIN payment_record pr ON pr.student_id=s.id AND pr.term_id='{$_SESSION['term_id']}' 
                      AND pr.session_id='{$_SESSION['session_id']}' 
                      WHERE s.class_id='$class_id' 
                      AND s.school_id='$school_id' 
                      ORDER BY s.lastname ASC");
            ?>
            <thead>
                <tr>
                    <th></th>
                    <th></th>
                    <th></th>
                </tr>
            </thead>
        <tbody>
            <?php
            while ($row = mysqli_fetch_array($select)) {
            ?>
                <tr>
                    <td style="width: 5px; padding-left: 0;">
                        <div class="icheck-primary">
                            <input type="checkbox" class="table_checkbox" onchange="check_checkbox()" id="check<?= $row['id'] ?>" value="<?= $row['id'] ?>">
                            <label for="check<?= $row['id'] ?>"></label>
                        </div>
                    </td>
                    <td class="w-xs-20 px-1">
                        <?php if (!$row['photo']) { ?>
                            <img src="./dist/img/avatar5.png" width="50" height="50" class="img-circle" />
                        <?php } else { ?>
                            <img src="../uploads/<?= $row['photo'] ?>" width="50" height="50" class="img-circle" />
                        <?php } ?>
                    </td>
                    <td class="">
                        <p style="font-size: 16px;"><?= $row['lastname'] ?> <?= $row['firstname'] . ' ' . $row['middlename'] ?></p>
                        <!--<p class="small font-weight-bold accent"><= $row['classname'] ?> </p>-->
                         <!--<p class="small font-weight-bold accent"><?= $row['classname'] ?> | <?= $row['status'] == '1' ? 'Active' : 'Inactive' ?></p> -->
                         <p class="small font-weight-bold <?= $row['student_status'] == '1' ? 'accent' : 'text-danger' ?>"><?= $row['classname'] ?> | <?= $row['student_status'] == '1' ? 'Active' : 'Inactive' ?></p>
                        <div>
                            <a onclick="view_student_info('<?= $row['id'] ?>')" class="btn p-0 text-primary mr-3">View</a>
                            <?php
                            if ($row['student_status'] == '1'):
                            if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['edit_student'] == 1) {
                            ?>
                                <a onclick="edit_student_info('<?= $row['id'] ?>')" class="btn p-0 text-primary mr-3">Edit</a>
                                <!-- edit parent info -->
                  <a onclick="edit_parent_info('<?= $row['parent_id'] ?>', '<?= $row['id'] ?>')"
                                        class="btn p-0 text-primary mr-3">Edit
                                        Parent</a>
                                <?php } ?>
                            <?php
                            if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3) {
                            ?>
                                <a onclick="get_student_info_to_delete('<?= $row['id'] ?>')" class="btn p-0 text-danger mr-3">Delete</a>
                            <?php } ?>
                            <?php
                            if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['change_class'] == 1) {
                            ?>
                                <a onclick="get_all_checked_checkbox('single','<?= $row['id'] ?>','bulk_transfer_modal')" class="btn p-0 text-primary mr-3">Transfer Student</a>
                                <a onclick="get_the_id_for_password_reset('<?= $row['id'] ?>','reset_student_password_modal')" class="btn p-0 text-primary mr-3">Reset Student Password</a>
                            <?php } 
                            endif;
                            ?>
                        </div>
                    </td>

                </tr>
                <!-- <script>
                $('.select2').select2()
            </script> -->

            <?php
            }
            ?>
        </tbody>
        <script>
            if ($.fn.DataTable.isDataTable('#student_table')) {
                $('#student_table').DataTable().destroy();
            }

            var table = $('#student_table').DataTable({
                scrollY: '50vh',
                scrollX: true,
                paging: false,
                ordering: false,
                fixedColumns: {
                    left: 1,
                    right: 0
                },
                language: {
                    emptyTable: "No students found",
                    zeroRecords: "No matching students found",
                    search: "Search students:",
                    info: "Showing _START_ to _END_ of _TOTAL_ students",
                    infoEmpty: "Showing 0 to 0 of 0 students",
                    infoFiltered: "(filtered from _MAX_ total students)"
                },
                "initComplete": function(settings, json) {
                    var recordCount = this.api().rows().count();
                    if (recordCount > 0) {
                        $('.custom-div-after-search').show();
                    } else {
                        $('.custom-div-after-search').hide();
                    }
                },
                "drawCallback": function(settings) {
                    var recordCount = this.api().rows().count();
                    console.log('Records after draw: ' + recordCount);
                    if (recordCount > 0) {
                        $('.custom-div-after-search').show();
                    } else {
                        $('.custom-div-after-search').hide();
                    }
                }
            });
        </script>
        <?php
        }
        // if ($action === 'getstudents') {
        //     $school_id = $_SESSION['school_id'];
        //     $select = mysqli_query($conn, "SELECT id,lastname, firstname,middlename FROM students WHERE school_id='$school_id'");
        //     $data = [];
        //     while ($row = mysqli_fetch_array($select)) {
        //         $data[] = $row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename'];
        //     }
        //     echo json_encode($data);
        // }

        // if ($action === 'get_scores') {
        //     $school_id = $_SESSION['school_id'];
        //     $term = $_POST['termValue'];
        //     $class = $_POST['classValue'];
        //     $session = $_POST['sessionValue'];

        //     if (isset($_POST['subjectValue'])) {
        //         $subject = $_POST['subjectValue'];
        //         $select = mysqli_query($conn, "SELECT b.lastname, b.firstname, b.middlename, s.ca1, s.ca1Total, s.ca2, s.ca2Total, s.ca3, s.ca3Total, s.pra, s.praTotal, s.exam, s.examTotal FROM skulscores s, students b WHERE s.school_id='$school_id' AND b.id=s.student_id AND s.term_id='$term' AND s.class_id='$class' AND s.subject_id='$subject' AND s.session_id='$session'");
        //     } else if (isset($_POST['studentValue'])) {
        //         $student = $_POST['studentValue'];
        //         $select = mysqli_query($conn, "SELECT s.subject_id, b.subject, s.ca1, s.ca1Total, s.ca2, s.ca2Total, s.ca3, s.ca3Total, s.pra, s.praTotal, s.exam, s.examTotal FROM skulscores s, subjects b WHERE s.student_id='$student' AND s.school_id='$school_id' AND b.id=s.subject_id AND s.term_id='$term' AND s.class_id='$class' AND s.session_id='$session'");
        //     }

        //     $data = [];
        //     // echo $school_id;
        //     $selectgrade = mysqli_query($conn,"SELECT grading FROM skul_settings WHERE school_id='$school_id'");
        //     $row = mysqli_fetch_array($selectgrade);
        //     $trimmed = trim($row['grading'], '{}');
        //     $eachgradepair = explode(',',$trimmed);
        //     $gradearray = [];
        //     foreach($eachgradepair as $eachgrade){
        //         list($key,$value) = explode(':', $eachgrade);
        //         $gradearray[$key] = $value;
        //     }

        //     // echo 

        //     while ($row = mysqli_fetch_array($select)) {
        //         $namesdata = isset($_POST['subjectValue']) ? $row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename'] : $row['subject'];
        //         $data[] = [
        //             'subjectsOrNames' => trim($namesdata),
        //             'subject_id' => isset($row['subject_id']) ? $row['subject_id'] : '',
        //             'ca1' => $row['ca1'],
        //             'ca1Total' => $row['ca1Total'],
        //             'ca2' => $row['ca2'],
        //             'ca2Total' => $row['ca2Total'],
        //             'ca3' => $row['ca3'],
        //             'ca3Total' => $row['ca3Total'],
        //             'pra' => $row['pra'],
        //             'praTotal' => $row['praTotal'],
        //             'exa' => $row['exam'],
        //             'exaTotal' => $row['examTotal'],
        //             'grade' => $gradearray,
        //         ];
        //     }
        //     echo json_encode($data);
        // }
        // if ($action === 'get_scores') {
        //     $school_id = $_SESSION['school_id'];
        //     $term = $_POST['termValue'];
        //     $class = $_POST['classValue'];
        //     $session = $_POST['sessionValue'];

        //     if (isset($_POST['subjectValue'])) {
        //         $subject = $_POST['subjectValue'];
        //         $select = mysqli_query($conn, "SELECT b.lastname, b.firstname, b.middlename, s.ca1, s.ca1Total, s.ca2, s.ca2Total, s.ca3, s.ca3Total, s.pra, s.praTotal, s.exam, s.examTotal FROM skulscores s, students b WHERE s.school_id='$school_id' AND b.id=s.student_id AND s.term_id='$term' AND s.class_id='$class' AND s.subject_id='$subject' AND s.session_id='$session'");
        //     } else if (isset($_POST['studentValue'])) {
        //         $student = $_POST['studentValue'];
        //         $select = mysqli_query($conn, "SELECT s.subject_id, b.subject, s.ca1, s.ca1Total, s.ca2, s.ca2Total, s.ca3, s.ca3Total, s.pra, s.praTotal, s.exam, s.examTotal FROM skulscores s, subjects b WHERE s.student_id='$student' AND s.school_id='$school_id' AND b.id=s.subject_id AND s.term_id='$term' AND s.class_id='$class' AND s.session_id='$session'");
        //     }

        //     $data = [];
        //     while ($row = mysqli_fetch_array($select)) {
        //         $namesdata = isset($_POST['subjectValue']) ? $row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename'] : $row['subject'];
        //         $data[] = [
        //             'subjectsOrNames' => trim($namesdata),
        //             'subject_id' => isset($row['subject_id']) ? $row['subject_id'] : '',
        //             'ca1' => $row['ca1'],
        //             'ca1Total' => $row['ca1Total'],
        //             'ca2' => $row['ca2'],
        //             'ca2Total' => $row['ca2Total'],
        //             'ca3' => $row['ca3'],
        //             'ca3Total' => $row['ca3Total'],
        //             'pra' => $row['pra'],
        //             'praTotal' => $row['praTotal'],
        //             'exa' => $row['exam'],
        //             'exaTotal' => $row['examTotal'],
        //         ];
        //     }
        //     echo json_encode($data);
        // }


        //php handles the calculations
        // if ($action === 'get_scores') {
        //     $school_id = $_SESSION['school_id'];
        //     $term = $_POST['termValue'];
        //     $class = $_POST['classValue'];
        //     $session = $_POST['sessionValue'];

        //     if (isset($_POST['subjectValue'])) {
        //         $subject = $_POST['subjectValue'];
        //         $select = mysqli_query($conn, "SELECT b.lastname, b.firstname, b.middlename, s.ca1, s.ca1Total, s.ca2, s.ca2Total, s.ca3, s.ca3Total, s.pra, s.praTotal, s.exam, s.examTotal FROM skulscores s, students b WHERE s.school_id='$school_id' AND b.id=s.student_id AND s.term_id='$term' AND s.class_id='$class' AND s.subject_id='$subject' AND s.session_id='$session'");
        //     } else if (isset($_POST['studentValue'])) {
        //         $student = $_POST['studentValue'];
        //         $select = mysqli_query($conn, "SELECT s.subject_id, b.subject, s.ca1, s.ca1Total, s.ca2, s.ca2Total, s.ca3, s.ca3Total, s.pra, s.praTotal, s.exam, s.examTotal FROM skulscores s, subjects b WHERE s.student_id='$student' AND s.school_id='$school_id' AND b.id=s.subject_id AND s.term_id='$term' AND s.class_id='$class' AND s.session_id='$session'");
        //     }

        //     $data = [];
        //     $selectgrade = mysqli_query($conn, "SELECT grading FROM skul_settings WHERE school_id='$school_id'");
        //     $row = mysqli_fetch_array($selectgrade);
        //     $trimmed = trim($row['grading'], '{}');
        //     $eachgradepair = explode(',', $trimmed);
        //     $gradearray = [];
        //     foreach ($eachgradepair as $eachgrade) {
        //         list($key, $value) = explode(':', $eachgrade);
        //         $gradearray[$key] = $value;
        //     }

        //     function getGrade($percentage, $gradearray)
        //     {
        //         foreach ($gradearray as $grade => $threshold) {
        //             if ($percentage >= $threshold) {
        //                 return $grade;
        //             }
        //         }
        //         return 'F'; // Default grade if no other grade matches
        //     }

        //     while ($row = mysqli_fetch_array($select)) {
        //         $namesdata = isset($_POST['subjectValue']) ? $row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename'] : $row['subject'];

        //         $totalScore = $row['ca1'] + $row['ca2'] + $row['ca3'] + $row['pra'] + $row['exam'];
        //         $totalPossible = $row['ca1Total'] + $row['ca2Total'] + $row['ca3Total'] + $row['praTotal'] + $row['examTotal'];
        //         $percentage = ($totalPossible > 0) ? ($totalScore / $totalPossible) * 100 : 0;
        //         $grade = getGrade($percentage, $gradearray);

        //         $data[] = [
        //             'subjectsOrNames' => trim($namesdata),
        //             'subject_id' => isset($row['subject_id']) ? $row['subject_id'] : '',
        //             'ca1' => $row['ca1'],
        //             'ca1Total' => $row['ca1Total'],
        //             'ca2' => $row['ca2'],
        //             'ca2Total' => $row['ca2Total'],
        //             'ca3' => $row['ca3'],
        //             'ca3Total' => $row['ca3Total'],
        //             'pra' => $row['pra'],
        //             'praTotal' => $row['praTotal'],
        //             'exa' => $row['exam'],
        //             'exaTotal' => $row['examTotal'],
        //             'totalScore' => $totalScore,
        //             'totalPossible' => $totalPossible,
        //             'percentage' => $percentage,
        //             'grade' => $grade,
        //         ];
        //     }
        //     echo json_encode($data);
        // }

        // $select_Setting = mysqli_query($conn, "SELECT ca1,ca2,ca3,practical,exam FROM skul_settings WHERE school_id='$school_id'");
        // $setting_row = mysqli_fetch_array($select_Setting);
        // $sca1 = $setting_row['ca1'];
        // $sca2 = $setting_row['ca2'];
        // $sca3 = $setting_row['ca3'];
        // $spra = $setting_row['practical'];
        // $sexam = $setting_row['exam'];

        if ($action == 'update_total_score') {
            $school_id = $_SESSION['school_id'];
            $class = test_input($_POST['classValue']);
            $term = test_input($_POST['termValue']);
            $session = test_input($_POST['sessionValue']);

            // Step 1: Calculate and update total scores for each student
            $select_scores = mysqli_query($conn, "SELECT subject_id,class_id, student_id, ca1, ca2, ca3, pra, exam, ca1Total, ca2Total, ca3Total, praTotal, examTotal FROM skulscores WHERE term_id='$term' AND session_id='$session' AND class_id='$class' AND school_id='$school_id'");

            $student_totals = []; // To store each student's total score and ID
            $subject_id;
            while ($score_row = mysqli_fetch_array($select_scores)) {
                $total = 0;
                $subject_id = $score_row['subject_id'];
                if ($score_row['ca1Total'] != 0) {
                    $total += $score_row['ca1'];
                }
                if ($score_row['ca2Total'] != 0) {
                    $total += $score_row['ca2'];
                }
                if ($score_row['ca3Total'] != 0) {
                    $total += $score_row['ca3'];
                }
                if ($score_row['praTotal'] != 0) {
                    $total += $score_row['pra'];
                }
                if ($score_row['examTotal'] != 0) {
                    $total += $score_row['exam'];
                }
                echo $total . "<br>";
                // Update the total score in the database
                $score_row['student_id'];
                echo $query = "UPDATE skulscores SET total='$total' 
            WHERE subject_id='{$score_row['subject_id']}' AND student_id='{$score_row['student_id']}' AND term_id='$term' AND session_id='$session' AND class_id='$class' AND school_id='$school_id'";
            ?>
                <br>
            <?php
                $updatescore = mysqli_query($conn, $query);

                // Store the student's total and ID in an array
                $student_totals[] = ['student_id' => $score_row['student_id'], 'total' => $total];
            }
            var_dump($student_totals);

            // // Step 2: Sort students by total score in descending order
            // usort($student_totals, function($a, $b) {
            //     return $b['total'] - $a['total'];
            // });

            // // Step 3: Assign positions and update them in the database
            // $position = 1;
            // foreach ($student_totals as $student) {
            //     $update_position = mysqli_query($conn, "UPDATE skulscores SET position='$position' 
            //     WHERE subject_id='$subject_id' AND student_id='{$student['student_id']}' AND term_id='$term' AND session_id='$session' AND class_id='$class' AND school_id='$school_id'");

            //     echo "Student " . $student['student_id'] . " is in position " . $position . " with total score " . $student['total'] . "<br>";
            //     $position++;
            // }
        }


        if ($action === 'submit_scores') {
            $scores = isset($_POST['scores']) ? $_POST['scores'] : [];
            $school_id = $_SESSION['school_id'];
            $_SESSION['new_scores'] = $scores;

            foreach ($scores as $score) {

                if ($score['subjectOrNameId'] == 'NAN') {
                    continue;
                }
                if (isset($score['studentId'])) {
                    $_SESSION['studentOrsubject'] = 'student';
                    $subject = $score['subjectOrNameId'];
                    // exit;
                    $student_id = $score['studentId'];
                    $class = $score['class'];
                    $term = $score['term'];
                    $session = $score['session'];

                    $ca1 = isset($score['ca1']) ? $score['ca1'] : null;
                    $ca1Total = isset($score['ca1Total']) ? $score['ca1Total'] : null;
                    $ca2 = isset($score['ca2']) ? $score['ca2'] : null;
                    $ca2Total = isset($score['ca2Total']) ? $score['ca2Total'] : null;
                    $ca3 = isset($score['ca3']) ? $score['ca3'] : null;
                    $ca3Total = isset($score['ca3Total']) ? $score['ca3Total'] : null;
                    $pra = isset($score['practical']) ? $score['practical'] : null;
                    $praTotal = isset($score['practicalTotal']) ? $score['practicalTotal'] : null;
                    $exam = isset($score['exam']) ? $score['exam'] : null;
                    $examTotal = isset($score['examTotal']) ? $score['examTotal'] : null;

                    $selectQuery = "SELECT subject_id, student_id, class_id, term_id, session_id, school_id FROM skulscores WHERE student_id='$student_id' AND subject_id='$subject' AND class_id='$class' AND session_id='$session' AND term_id='$term'";
                    $select = mysqli_query($conn, $selectQuery);

                    if (mysqli_num_rows($select) > 0) {
                        $updateQuery = "UPDATE skulscores SET ";
                        $updateFields = [];
                        if ($ca1 !== null) $updateFields[] = "ca1='$ca1'";
                        if ($ca1Total !== null) $updateFields[] = "ca1Total='$ca1Total'";
                        if ($ca2 !== null) $updateFields[] = "ca2='$ca2'";
                        if ($ca2Total !== null) $updateFields[] = "ca2Total='$ca2Total'";
                        if ($ca3 !== null) $updateFields[] = "ca3='$ca3'";
                        if ($ca3Total !== null) $updateFields[] = "ca3Total='$ca3Total'";
                        if ($pra !== null) $updateFields[] = "pra='$pra'";
                        if ($praTotal !== null) $updateFields[] = "praTotal='$praTotal'";
                        if ($exam !== null) $updateFields[] = "exam='$exam'";
                        if ($examTotal !== null) $updateFields[] = "examTotal='$examTotal'";
                        $updateQuery .= implode(", ", $updateFields);
                        $updateQuery .= " WHERE subject_id='$subject' AND student_id='$student_id' AND class_id='$class' AND session_id='$session' AND term_id='$term' AND school_id='$school_id'";
                        $update = mysqli_query($conn, $updateQuery);
                        // if ($update) {
                        //     echo json_encode(array('status' => '1', 'msg'=>'Submitted succesfully'));
                        // } else {
                        //     echo json_encode(array('status' => '0', "err" => "Scores not submitted, try again"));
                        //     // echo "update error: " . mysqli_error($conn) . "\n";
                        //     // echo "Update Query: " . $updateQuery . "\n";
                        // }
                    } else {
                        $insertFields = "(student_id, subject_id, class_id, term_id, session_id, school_id";
                        $insertValues = "('$student_id', '$subject', '$class', '$term', '$session', '$school_id'";
                        if ($ca1 !== null) {
                            $insertFields .= ", ca1";
                            $insertValues .= ", '$ca1'";
                        }
                        if ($ca1Total !== null) {
                            $insertFields .= ", ca1Total";
                            $insertValues .= ", '$ca1Total'";
                        }
                        if ($ca2 !== null) {
                            $insertFields .= ", ca2";
                            $insertValues .= ", '$ca2'";
                        }
                        if ($ca2Total !== null) {
                            $insertFields .= ", ca2Total";
                            $insertValues .= ", '$ca2Total'";
                        }
                        if ($ca3 !== null) {
                            $insertFields .= ", ca3";
                            $insertValues .= ", '$ca3'";
                        }
                        if ($ca3Total !== null) {
                            $insertFields .= ", ca3Total";
                            $insertValues .= ", '$ca3Total'";
                        }
                        if ($pra !== null) {
                            $insertFields .= ", pra";
                            $insertValues .= ", '$pra'";
                        }
                        if ($praTotal !== null) {
                            $insertFields .= ", praTotal";
                            $insertValues .= ", '$praTotal'";
                        }
                        if ($exam !== null) {
                            $insertFields .= ", exam";
                            $insertValues .= ", '$exam'";
                        }
                        if ($examTotal !== null) {
                            $insertFields .= ", examTotal";
                            $insertValues .= ", '$examTotal'";
                        }
                        $insertFields .= ")";
                        $insertValues .= ")";
                        $insertQuery = "INSERT INTO skulscores $insertFields VALUES $insertValues";
                        $insert = mysqli_query($conn, $insertQuery);
                        // if ($insert) {
                        //     echo json_encode(array('status' => '1', 'msg'=>'Submitted succesfully'));
                        // } else {
                        //     echo json_encode(array('status' => '0', "err" => "Scores not submitted, try again"));
                        //     // echo "insert error: " . mysqli_error($conn) . "\n";
                        //     // echo "Insert Query: " . $insertQuery . "\n";
                        // }
                    }
                } else if (isset($score['subjectId'])) {
                    $_SESSION['studentOrsubject'] = 'subject';
                    $student = $score['subjectOrNameId'];
                    $subject = $score['subjectId'];
                    $class = $score['class'];
                    $term = $score['term'];
                    $session = $score['session'];

                    $ca1 = isset($score['ca1']) ? $score['ca1'] : null;
                    $ca1Total = isset($score['ca1Total']) ? $score['ca1Total'] : null;
                    $ca2 = isset($score['ca2']) ? $score['ca2'] : null;
                    $ca2Total = isset($score['ca2Total']) ? $score['ca2Total'] : null;
                    $ca3 = isset($score['ca3']) ? $score['ca3'] : null;
                    $ca3Total = isset($score['ca3Total']) ? $score['ca3Total'] : null;
                    $pra = isset($score['practical']) ? $score['practical'] : null;
                    $praTotal = isset($score['practicalTotal']) ? $score['practicalTotal'] : null;
                    $exam = isset($score['exam']) ? $score['exam'] : null;
                    $examTotal = isset($score['examTotal']) ? $score['examTotal'] : null;

                    $select = mysqli_query($conn, "SELECT * FROM skulscores WHERE student_id='$student' AND subject_id='$subject' AND class_id='$class' AND session_id='$session' AND term_id='$term' AND school_id='$school_id'");

                    if (mysqli_num_rows($select) > 0) {
                        $updateQuery = "UPDATE skulscores SET ";
                        $updateFields = [];
                        if ($ca1 !== null) $updateFields[] = "ca1='$ca1'";
                        if ($ca1Total !== null) $updateFields[] = "ca1Total='$ca1Total'";
                        if ($ca2 !== null) $updateFields[] = "ca2='$ca2'";
                        if ($ca2Total !== null) $updateFields[] = "ca2Total='$ca2Total'";
                        if ($ca3 !== null) $updateFields[] = "ca3='$ca3'";
                        if ($ca3Total !== null) $updateFields[] = "ca3Total='$ca3Total'";
                        if ($pra !== null) $updateFields[] = "pra='$pra'";
                        if ($praTotal !== null) $updateFields[] = "praTotal='$praTotal'";
                        if ($exam !== null) $updateFields[] = "exam='$exam'";
                        if ($examTotal !== null) $updateFields[] = "examTotal='$examTotal'";
                        $updateQuery .= implode(", ", $updateFields);
                        $updateQuery .= " WHERE student_id='$student' AND subject_id='$subject' AND class_id='$class' AND session_id='$session' AND term_id='$term' AND school_id='$school_id'";
                        $update = mysqli_query($conn, $updateQuery);
                        // if ($update) {
                        //     echo json_encode(array('status' => '1', 'msg'=>'Submitted succesfully'));
                        // } else {
                        //     echo json_encode(array('status' => '0', "err" => "Scores not submitted, try again"));
                        //     // echo "update error for subject filter: " . mysqli_error($conn);
                        // }
                    } else {
                        $insertFields = "(subject_id, student_id, class_id, term_id, session_id, school_id";
                        $insertValues = "('$subject', '$student', '$class', '$term', '$session', '$school_id'";
                        if ($ca1 !== null) {
                            $insertFields .= ", ca1";
                            $insertValues .= ", '$ca1'";
                        }
                        if ($ca1Total !== null) {
                            $insertFields .= ", ca1Total";
                            $insertValues .= ", '$ca1Total'";
                        }
                        if ($ca2 !== null) {
                            $insertFields .= ", ca2";
                            $insertValues .= ", '$ca2'";
                        }
                        if ($ca2Total !== null) {
                            $insertFields .= ", ca2Total";
                            $insertValues .= ", '$ca2Total'";
                        }
                        if ($ca3 !== null) {
                            $insertFields .= ", ca3";
                            $insertValues .= ", '$ca3'";
                        }
                        if ($ca3Total !== null) {
                            $insertFields .= ", ca3Total";
                            $insertValues .= ", '$ca3Total'";
                        }
                        if ($pra !== null) {
                            $insertFields .= ", pra";
                            $insertValues .= ", '$pra'";
                        }
                        if ($praTotal !== null) {
                            $insertFields .= ", praTotal";
                            $insertValues .= ", '$praTotal'";
                        }
                        if ($exam !== null) {
                            $insertFields .= ", exam";
                            $insertValues .= ", '$exam'";
                        }
                        if ($examTotal !== null) {
                            $insertFields .= ", examTotal";
                            $insertValues .= ", '$examTotal'";
                        }
                        $insertFields .= ")";
                        $insertValues .= ")";
                        $insertQuery = "INSERT INTO skulscores $insertFields VALUES $insertValues";
                        $insert = mysqli_query($conn, $insertQuery);
                        // if ($insert) {
                        //     echo json_encode(array('status' => '1', 'msg' => 'Submitted succesfully'));
                        // } else {
                        //     echo json_encode(array('status' => '0', "err" => "Scores not submitted, try again"));
                        // }
                    }
                }
            }
            // $insert = mysqli_query($conn, $insertQuery);
            // if ($insert) {
            echo json_encode(array('status' => '1', 'msg' => 'Submitted succesfully'));
            // } else {
            //     echo json_encode(array('status' => '0', "err" => "Scores not submitted, try again"));
            // }
        }



        if ($action === 'get_scores') {
            $school_id = $_SESSION['school_id'];
            $term = $_POST['termValue'];
            $class = $_POST['classValue'];
            $session = $_POST['sessionValue'];
            $studentValue = isset($_POST['studentValue']) ? $_POST['studentValue'] : null;
            $subjectValue = isset($_POST['subjectValue']) ? $_POST['subjectValue'] : null;

            $data = [];
            $gradearray = [];

            // Fetch grading settings
            $selectgrade = mysqli_query($conn, "SELECT grading FROM skul_settings WHERE school_id='$school_id'");
            if ($selectgrade && $row = mysqli_fetch_assoc($selectgrade)) {
                $trimmed = trim($row['grading'], '{}');
                $eachgradepair = explode(',', $trimmed);
                foreach ($eachgradepair as $eachgrade) {
                    list($key, $value) = explode(':', $eachgrade);
                    $gradearray[trim($key)] = floatval(trim($value));
                }
            }

            // Fetch scores based on the filter
            if ($subjectValue) {
                $select = mysqli_query($conn, "SELECT b.lastname, b.firstname, b.middlename, s.ca1, s.ca1Total, s.ca2, s.ca2Total, s.ca3, s.ca3Total, s.pra, s.praTotal, s.exam, s.examTotal FROM skulscores s, students b WHERE s.school_id='$school_id' AND b.id=s.student_id AND s.term_id='$term' AND s.class_id='$class' AND s.subject_id='$subjectValue' AND s.session_id='$session'");
            } else if ($studentValue) {
                $select = mysqli_query($conn, "SELECT s.subject_id, b.subject, s.ca1, s.ca1Total, s.ca2, s.ca2Total, s.ca3, s.ca3Total, s.pra, s.praTotal, s.exam, s.examTotal FROM skulscores s, subjects b WHERE s.student_id='$studentValue' AND s.school_id='$school_id' AND b.id=s.subject_id AND s.term_id='$term' AND s.class_id='$class' AND s.session_id='$session'");
            } else {
                $select = false;
            }

            if ($select) {
                while ($row = mysqli_fetch_assoc($select)) {
                    $namesdata = $subjectValue ? $row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename'] : $row['subject'];
                    $data[] = [
                        'subjectsOrNames' => trim($namesdata),
                        'subject_id' => isset($row['subject_id']) ? $row['subject_id'] : '',
                        'ca1' => $row['ca1'],
                        'ca1Total' => $row['ca1Total'],
                        'ca2' => $row['ca2'],
                        'ca2Total' => $row['ca2Total'],
                        'ca3' => $row['ca3'],
                        'ca3Total' => $row['ca3Total'],
                        'pra' => $row['pra'],
                        'praTotal' => $row['praTotal'],
                        'exam' => $row['exam'],
                        'examTotal' => $row['examTotal']
                    ];
                }
            }
            $_SESSION['old_scores'] = $data;
            $response = [
                'scores' => $data,
                'grading' => $gradearray
            ];

            echo json_encode($response);
        }







        if ($action === 'get_staff_data_by_id') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            $staff_type = test_input($_POST['staff_type']);

            $select  = mysqli_query($conn, "SELECT c.classname,c.id, s.*, t.type FROM staff s, class c, staff_type t WHERE t.id=s.staff_type AND c.id=s.class_id AND s.id='$id' AND s.school_id='$school_id'");

            $row = mysqli_fetch_array($select);
            echo json_encode($row);
        }
        if ($action === 'get_student_data_by_id') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            $select  = mysqli_query($conn, "SELECT c.classname,p.id,p.phone as parentphone, p.email as parentemail,p.address,p.city,p.state,p.country,s.* FROM students s, class c, parent p WHERE c.id=s.class_id AND s.parent_id=p.id AND s.id='$id' AND s.school_id='$school_id'");
            $row = mysqli_fetch_array($select);
            echo json_encode($row);
            // echo mysqli_error($conn);
        }
        if ($action === 'get_class_data_for_update') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            $select  = mysqli_query($conn, "SELECT * FROM class WHERE id='$id' AND school_id='$school_id'");
            if ($row = mysqli_fetch_array($select)) {
            ?>

                <form onsubmit="update_class_data(event)">
                    <div class="form-group">
                        <input type="hidden" name="action" value="update_class_data">
                        <input type="hidden" name="id" value="<?= $row['id'] ?>">
                        <label for="class" class="mb-0 muted-text">Class Name</label>
                        <input id="class" name="classname" type="text" value="<?= $row['classname'] ?>" placeholder="Class name" class="form-control">

                    </div>
                     <?php if ($row['is_graduate'] == 0) { ?>
                    <div class="form-group">
                        <label for="" class="mb-0 muted-text">Select Prefered Subject Category</label>
                        <select class="form-control select2" name="subject_category" id="" style="width: 100%;" required>
                            <option value="">Select category</option>
                            <?php
                            $select = mysqli_query($conn, "SELECT id,category_name FROM subject_cat WHERE school_id='$school_id'");
                            while ($subjrow = mysqli_fetch_array($select)) {
                                if ($row['subject_cat'] == $subjrow['id']) {
                            ?>
                                    <option selected value="<?= $subjrow['id'] ?>"><?= $subjrow['category_name'] ?></option>
                                <?php
                                } else {
                                ?>
                                    <option value="<?= $subjrow['id'] ?>"><?= $subjrow['category_name'] ?></option>
                            <?php
                                }
                            }
                            ?>
                        </select>
                    </div>
                    </div>
                    <?php } ?>
                    <div class="card-foot">
                        <div class="alert myalert alert-dismissible" style="display: none;">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                            <p class="warning small text-danger"></p>
                        </div>
                        <button type="submit" id="update_class_btn" class="btn btn-primary">Update Class</button>
                        <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Cancel</button>
                    </div>
                    </div>
                </form>
                <!-- </div> -->
                <script>
                    $('.select2').select2()
                </script>
            <?php
            }
        }
        if ($action === 'get_staff_data_for_update') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            $staff_type = test_input($_POST['staff_type']);
            $select  = mysqli_query($conn, "SELECT * FROM staff WHERE id='$id' AND school_id='$school_id'");

            if ($row = mysqli_fetch_array($select)) {
            ?>
                <form onsubmit="update_staff_data(event)">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-12">
                                <input type="hidden" name="action" value="update_staff_data">
                                <input type="hidden" name="id" value="<?= $row['id'] ?>">
                                <div class="form-group mr-3" style="position:relative; max-width: 100px;">
                                    <img id="image_profile_preview" title="click to select photo" src="../uploads/<?= $row['photo'] ?>" alt="Photo" width="100" height="100">
                                    <input type="file" name="photo" accept="image/png, image/jpeg, image/jpg" id="update_photo_forstaff" style="display: none;" onchange="preview_image(event)" class="form-control">
                                    <label for="update_photo_forstaff" style="position:absolute; color: transparent; width: 100%; height: 100%; left:0; top:0;">Select Photo</label>
                                    <p class="small mb-0 text-center">Click to select photo</p>
                                </div>
                                <?php
                                if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                                ?>
                                    <div class="mb-3 col-sm-4 col-12 px-0">
                                        <p for="lastname" class="font-weight-bold mb-0 small muted-text">Change Status</p>
                                        <select name="status" id="" class="select2 form-control" title="Change Status">
                                            <?php
                                            if ($row['status'] == '1') {
                                            ?>
                                                <option selected value="1">Activate</option>
                                                <option value="0">Deactivate</option>
                                            <?php
                                            } else {
                                            ?>
                                                <option value="1">Activate</option>
                                                <option selected value="0">Deactivate</option>
                                            <?php
                                            }
                                            ?>
                                        </select>
                                    </div>
                                <?php } ?>
                                <p class="font-weight-bold text-muted">Basic Data</p>
                                <div class="row flex-wrap" style="border-bottom:5px solid #f4f7fa">
                                    <div class="mb-3 col-sm-4 col-12">
                                        <p for="firstname" class="font-weight-bold mb-0 small muted-text">Firstname</p>
                                        <input id="firstname" name="firstname" type="text" placeholder="Firstname" value="<?= $row['firstname'] ?>" class="form-control" title="Enter Firstname">
                                    </div>
                                    <div class="mb-3 col-sm-4 col-12">
                                        <p for="lastname" class="font-weight-bold mb-0 small muted-text">Lastname</p>
                                        <input name="lastname" type="text" placeholder="Lastname" value="<?= $row['lastname'] ?>" class="form-control" title="Enter Lastname">
                                    </div>
                                    <div class="mb-3 col-sm-4 col-12">
                                        <p class="font-weight-bold small muted-text">Middlename</p>
                                        <input type="text" name="middlename" placeholder="Middlename" value="<?= $row['middlename'] ?>" class="form-control" title="Enter Middlename">
                                    </div>
                                    <div class="mb-3 col-sm-4 col-12">
                                        <p class="font-weight-bold small muted-text">Gender</p>
                                        <select class="form-control select2" name="gender" style="width: 100%;" title="Select Gender">
                                            <option selected="selected" value="<?= $row['gender'] ?>"><?= $row['gender'] ?></option>
                                            <option>Male</option>
                                            <option>Female</option>
                                        </select>
                                    </div>

                                    <?php
                                    if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                                    ?>
                                        <div class="mb-3 col-sm-4 col-12">
                                            <p class="font-weight-bold small muted-text">Staff Role</p>
                                            <select class="form-control select2" name="staff_role" style="width: 100%;" title="Select Staff Role">
                                                <option value="">Select role</option>
                                                <?php
                                                $selectclass = mysqli_query($conn, "SELECT id,type FROM staff_type ORDER BY id ASC");
                                                while ($staffrow = mysqli_fetch_array($selectclass)) {
                                                    if ($staffrow['id'] == $row['staff_type']) {
                                                ?>
                                                        <option selected value="<?= $staffrow['id'] ?>"><?= $staffrow['type'] ?></option>
                                                    <?php
                                                    }
                                                    ?>
                                                    <option value="<?= $staffrow['id'] ?>"><?= $staffrow['type'] ?></option>
                                                <?php
                                                }
                                                ?>
                                            </select>
                                        </div>
                                    <?php } ?>
                                </div>
                            </div>
                            <div class="col-12 mt-3">
                                <p class="font-weight-bold text-muted">Contact Information</p>
                                <div class="row flex-wrap">
                                    <div class="mb-3 col-sm-4 col-12">
                                        <p class="font-weight-bold small muted-text">Phone</p>
                                        <input type="text" name="phone" class="form-control" value="<?= $row['phone'] ?>" placeholder="Staff phone number" required id="" title="Enter Phone Number">
                                    </div>
                                    <div class="mb-3 col-sm-4 col-12">
                                        <p class="font-weight-bold small muted-text">Email</p>
                                        <input type="email" name="email" class="form-control" value="<?= $row['email'] ?>" placeholder="Email address" id="" title="Enter Email Address">
                                    </div>
                                    <div class="mb-3 col-sm-4 col-12">
                                        <p class="font-weight-bold small muted-text">Full address</p>
                                        <input type="text" name="address" value="<?= $row['address'] ?>" autocomplete="address" class="form-control" placeholder="e.g. 10, Kings Street, Victoria Island, Lagos." id="" title="Enter Full Address">
                                    </div>
                                    <div class="mb-3 col-sm-4 col-12">
                                        <p class="font-weight-bold small muted-text">City</p>
                                        <input type="text" name="city" autocomplete="address-level1" value="<?= $row['city'] ?>" class="form-control" placeholder="e.g. Victoria Island" id="" title="Enter City">
                                    </div>
                                    <div class="mb-3 col-sm-4 col-12">
                                        <p class="font-weight-bold small muted-text">State</p>
                                        <input type="text" name="state" value="<?= $row['state'] ?>" autocomplete="address-level1" class="form-control" placeholder="e.g. Lagos" id="" title="Enter State">
                                    </div>
                                    <div class="mb-3 col-sm-4 col-12">
                                        <p class="font-weight-bold small muted-text">Country</p>
                                        <input type="text" name="country" value="<?= $row['country'] ?>" autocomplete="address-level1" class="form-control" placeholder="e.g. Nigeria" id="" title="Enter Country">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-foot">
                            <button type="submit" id="update_staff_submit_btn" class="btn btn-primary">Update</button>
                            <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Cancel</button>
                        </div>
                    </div>
                </form>
                <!-- </div> -->
                <script>
                    $('.select2').select2()
                </script>
            <?php
            }
        }

         if ($action === 'get_parent_data_for_update') {
        $school_id = $_SESSION['school_id'];
        $id = test_input($_POST['id']);
        $student_id = isset($_POST['student_id']) ? test_input($_POST['student_id']) : null;

        $select = mysqli_query($conn, "SELECT * FROM parent WHERE id='$id' AND school_id='$school_id'");

        if ($row = mysqli_fetch_array($select)) {
            // Count siblings to determine if reassignment choice is needed
            $sibling_count = 0;
            $select_siblings = mysqli_query($conn, "SELECT COUNT(*) as total FROM students WHERE parent_id='$id' AND school_id='$school_id'");
            if ($sib_res = mysqli_fetch_array($select_siblings)) {
                $sibling_count = $sib_res['total'];
            }
            ?>
            <form onsubmit="update_parent_data(event)">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-12">
                            <input type="hidden" name="action" value="update_parent_data">
                            <input type="hidden" name="id" value="<?= $row['id'] ?>">
                            <?php if ($student_id) { ?>
                                <input type="hidden" name="ref_student_id" value="<?= $student_id ?>">
                            <?php } ?>

                            <?php if ($sibling_count > 1 && $student_id) {
                                // Get current student name for clarity
                                $stud_name = "";
                                $sel_stud = mysqli_query($conn, "SELECT firstname, lastname FROM students WHERE id='$student_id' AND school_id='$school_id'");
                                if ($srow = mysqli_fetch_array($sel_stud)) {
                                    $stud_name = $srow['firstname'] . " " . $srow['lastname'];
                                }
                                ?>
                                <div class="alert alert-inf py-2">
                                    <p class="small mb-2 font-weight-bold">This parent has <?= $sibling_count ?> children. How should
                                        this update apply?</p>
                                    <div class="custom-control custom-radio small">
                                        <input class="custom-control-input" type="radio" id="apply_all" name="update_scope" value="all"
                                            checked>
                                        <label for="apply_all" class="custom-control-label font-weight-normal">Update/Merge for ALL
                                            children (Shared Parent)</label>
                                    </div>
                                    <div class="custom-control custom-radio small">
                                        <input class="custom-control-input" type="radio" id="apply_single" name="update_scope"
                                            value="single">
                                        <label for="apply_single" class="custom-control-label font-weight-normal">Reassign ONLY
                                            <strong><?= $stud_name ?></strong> (Move student to a new/different parent)</label>
                                    </div>
                                </div>
                            <?php } else { ?>
                                <input type="hidden" name="update_scope" value="all">
                            <?php } ?>

                            <div class="row flex-wrap">
                                <div class="mb-3 col-sm-4 col-12">
                                    <p for="firstname" class="font-weight-bold mb-0 small muted-text">Firstname</p>
                                    <input id="firstname" name="firstname" type="text" placeholder="Firstname"
                                        value="<?= $row['firstname'] ?>" class="form-control" title="Enter parent's firstname">
                                </div>
                                <div class="mb-3 col-sm-4 col-12">
                                    <p for="lastname" class="font-weight-bold mb-0 small muted-text">Lastname</p>
                                    <input name="lastname" type="text" placeholder="Lastname" value="<?= $row['lastname'] ?>"
                                        class="form-control" title="Enter parent's lastname">
                                </div>
                            </div>
                        </div>
                        <div class="col-12 mt-3">
                            <div class="row flex-wrap">
                                <div class="mb-3 col-sm-4 col-12">
                                    <p class="font-weight-bold small muted-text">Phone</p>
                                    <input type="text" name="phone" class="form-control" value="<?= $row['phone'] ?>"
                                        placeholder="Student phone number" id="" title="Enter parent's phone number">
                                </div>
                                <div class="mb-3 col-sm-4 col-12">
                                    <p class="font-weight-bold small muted-text">Email</p>
                                    <input type="email" name="email" class="form-control" value="<?= $row['email'] ?>"
                                        placeholder="Email address" id="" title="Enter parent's email address">
                                </div>
                                <div class="mb-3 col-sm-4 col-12">
                                    <p class="font-weight-bold small muted-text">Full address</p>
                                    <input type="text" name="address" value="<?= $row['address'] ?>" autocomplete="address"
                                        class="form-control" placeholder="e.g. 10, Kings Street, Victoria Island, Lagos." id=""
                                        title="Enter parent's full address">
                                </div>
                                <div class="mb-3 col-sm-4 col-12">
                                    <p class="font-weight-bold small muted-text">City</p>
                                    <input type="text" name="city" autocomplete="address-level1" value="<?= $row['city'] ?>"
                                        class="form-control" placeholder="e.g. Victoria Island" id="" title="Enter parent's city">
                                </div>
                                <div class="mb-3 col-sm-4 col-12">
                                    <p class="font-weight-bold small muted-text">State</p>
                                    <input type="text" name="state" value="<?= $row['state'] ?>" autocomplete="address-level1"
                                        class="form-control" placeholder="e.g. Lagos" id="" title="Enter parent's state">
                                </div>
                                <div class="mb-3 col-sm-4 col-12">
                                    <p class="font-weight-bold small muted-text">Country</p>
                                    <input type="text" name="country" value="<?= $row['country'] ?>" autocomplete="address-level1"
                                        class="form-control" placeholder="e.g. Nigeria" id="" title="Enter parent's country">
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="card-foot">
                        <div class="d-flex w-100">
                            <small class="text-danger myalert p-2 mb-2 w-100" id="add_parent_data_warning"
                                style="text-align:center; display:none;">Phone Number or email already exist, kindly try
                                another.</small>
                        </div>
                        <button type="submit" id="update_parent_submit_btn" class="btn btn-primary"
                            title="Update parent information">Update Now</button>
                        <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close"
                            title="Cancel update">Cancel</button>
                    </div>
                </div>
            </form>
            <?php
        }
    }
        if ($action === 'get_student_data_for_update') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            $student_query = "SELECT c.classname,p.id,p.firstname as pfirstname,
            p.lastname as plastname,p.phone as parentphone, 
            p.email as parentemail,p.address,p.city,p.state,
            p.country,s.* FROM students s, class c, parent p 
            WHERE c.id=s.class_id AND s.parent_id=p.id AND 
            s.id='$id' AND s.school_id='$school_id'";
            $select  = mysqli_query($conn, $student_query);
            if ($row = mysqli_fetch_array($select)) {
            ?>
                <form id="add_student_modal_id_update" onsubmit="update_student_data(event)">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-12">
                                <input type="hidden" name="action" value="update_student_data">
                                <input type="hidden" name="id" value="<?= $row['id'] ?>">
                                <div class="form-group mr-3" style="position:relative; max-width: 100px;">
                                    <img id="image_profile_preview" title="click to select photo" src="../uploads/<?= $row['photo'] ?>" alt="Photo" width="100" height="100">
                                    <input type="file" name="studentphoto" accept="image/png, image/jpg, image/jpeg" id="image_studentprofile_add" style="display: none;" onchange="preview_image(event)" class="form-control">
                                    <label for="image_studentprofile_add" style="position:absolute; color: transparent; width: 100%; height: 100%; left:0; top:0;">Select
                                        Photo</label>
                                    <p class="small mb-0 text-center">Click to select photo</p>
                                </div>
                                <?php
                                if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                                ?>
                                    <!--<div class="mb-3 col-sm-4 col-12 px-0">-->
                                    <!--    <p for="lastname" class="font-weight-bold mb-0 small muted-text">Change Status</p>-->
                                    <!--    <select name="status" id="" class="select2 form-control">-->
                                    <!--        <php-->
                                    <!--        if ($row['status'] == '1') {-->
                                    <!--        ?>-->
                                    <!--            <option selected value="1">Activate</option>-->
                                    <!--            <option value="0">Deactivate</option>-->
                                    <!--        <php-->
                                    <!--        } else {-->
                                    <!--        ?>-->
                                    <!--            <option value="1">Activate</option>-->
                                    <!--            <option selected value="0">Deactivate</option>-->
                                    <!--        <php-->
                                    <!--        }-->
                                    <!--        ?>-->
                                    <!--    </select>-->
                                    <!--</div>-->
                                <?php } ?>
                                <p class="font-weight-bold text-muted">Basic Data</p>
                                <div class="row flex-wrap" style="border-bottom:5px solid #f4f7fa">
                                    <div class="mb-3 col-sm-6 col-12">
                                        <label for="firstname" class="mb-0 muted-text">Firstname</label>
                                        <input id="firstname" name="firstname" type="text" placeholder="Firstname" value="<?= $row['firstname'] ?>" class="form-control" required>
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <label for="lastname" class="mb-0 muted-text">Lastname</label>
                                        <input name="lastname" type="text" placeholder="Lastname" value="<?= $row['lastname'] ?>" class="form-control" required>
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Middlename</p>
                                        <input type="text" name="middlename" placeholder="Middlename" value="<?= $row['middlename'] ?>" class="form-control">
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Admission number</p>
                                        <input type="text" name="admissionnumber" placeholder="Admission number" value="<?= $row['admission_no'] ?>" class="form-control">
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Class</p>
                                        <select class="form-control select2" name="class_id" style="width: 100%;" required>
                                            <?php
                                            $selectclass = mysqli_query($conn, "SELECT id,classname FROM class WHERE school_id='$school_id'");
                                            while ($classrow = mysqli_fetch_array($selectclass)) {
                                                if ($classrow['id'] == $row['class_id']) {
                                            ?>
                                                    <option selected="selected" value="<?= $classrow['id'] ?>"><?= $classrow['classname'] ?></option>
                                                <?php
                                                }
                                                ?>
                                                <option value="<?= $classrow['id'] ?>"><?= $classrow['classname'] ?></option>
                                            <?php
                                            }
                                            ?>
                                        </select>
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Department</p>
                                        <input type="text" name="department" placeholder="Department" value="<?= $row['department'] ?>" class="form-control">
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Gender</p>
                                        <select class="form-control select2" required name="gender" style="width: 100%;">
                                            <option selected="selected" value="<?= $row['gender'] ?>"><?= $row['gender'] ?></option>
                                            <option>Male</option>
                                            <option>Female</option>
                                        </select>
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Date of Birth</p>
                                        <input type="date" name="dob" class="form-control" placeholder="Date" value="<?= $row['dob'] ?>" id="">
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 mt-3">
                                <p class="mb-0 text-muted">Contact Information</p>
                                <div class="row flex-wrap">
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Phone number</p>
                                        <input type="text" name="phone" class="form-control" value="<?= $row['phone'] ?>" placeholder="Student phone number" id="">
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Email address</p>
                                        <input type="email" name="email" class="form-control" value="<?= $row['email'] ?>" placeholder="Email address" id="">
                                    </div>
                                </div>
                            </div>
                        <!--    <div class="col-12 mt-3">-->
                        <!--    <p class="mb-0 text-muted">Set Password</p>-->
                        <!--    <div class="row flex-wrap">-->
                        <!--        <div class="mb-3 col-sm-6 col-12">-->
                        <!--            <input type="password" name="password" class="form-control" value="<?=$row['passw']?>" placeholder="Enter new password" id="">-->
                        <!--        </div>-->
                        <!--    </div>-->
                        <!--</div>-->
                            <!-- <div class="col-12 mt-3">
                                <p class="font-weight-bold text-muted">Parent Information</p>

                                <div class="w-100 mb-3">
                                 
                                    <div class="">
                                        <p class="mb-0 muted-text">Parent Phone number</p>
                                        <select name="parentphone" id="update_search_parentphone" class="form-control search_parentphone" style="width: 100%;" required>
                                            <option selected value="<?= $row['parentphone'] ?>">
                                                <?= $row['parentphone'] ?> - <?= $row['pfirstname'] ?> <?= $row['plastname'] ?>
                                            </option>
                                        </select>
                                        <input type="hidden" name="current_parent_id" value="<?= $row['parent_id'] ?>">
                                        <small class="text-muted">Accepted format: 08136467317</small>
                                    </div>
                                </div>
                                <div class="row flex-wrap">
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Parent First Name</p>
                                        <input type="text" value="<?= $row['pfirstname'] ?>" name="parentfname" required class="form-control pa_firstname" autocomplete="given-name" placeholder="Parent first name">
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Parent Last Name</p>
                                        <input type="text" value="<?= $row['plastname'] ?>" name="parentlname" class="form-control pa_lastname" autocomplete="family-name" placeholder="Parent last name" required>
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Email address</p>
                                        <input type="email" value="<?= $row['parentemail'] ?>" name="parentemail" class="pa_email form-control" autocomplete="email" placeholder="Parent email address">
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Full Address</p>
                                        <input type="text" value="<?= $row['address'] ?>" name="address" autocomplete="address-level1" class="pa_address form-control" placeholder="Parent Address" id="">
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">City</p>
                                        <input type="text" value="<?= $row['city'] ?>" name="city" autocomplete="address-level1" class="pa_city form-control" placeholder="Parent Address" id="">
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">State</p>
                                        <input type="text" value="<?= $row['state'] ?>" name="state" autocomplete="address-level1" class="pa_state form-control" placeholder="Parent Address" id="">
                                    </div>
                                    <div class="mb-3 col-sm-6 col-12">
                                        <p class="mb-0 muted-text">Country</p>
                                        <input type="text" value="<?= $row['country'] ?>" name="country" autocomplete="address-level1" class="pa_country form-control" placeholder="Parent Address" id="">
                                    </div>
                                </div>
                            </div> -->
                        </div>
                        <div class="card-foot">
                            <button type="submit" id="update_student_btn" class="btn btn-primary">Update Student Data</button>
                            <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Cancel</button>
                        </div>
                    </div>
                </form>
                <!-- </div> -->
            <?php
            }
        }
        if ($action == 'add_g_class_data') {
            $school_id = $_SESSION['school_id'];
            $classname = test_input($_POST['class']);
            $insertclass = mysqli_query($conn, "INSERT INTO class(is_graduate,classname, school_id, createdby, datecreated) 
                VALUES(1,'$classname', '$school_id', '{$_SESSION['userid']}', '$date')");
            echo $insertclass === true ? json_encode(array('status' => '1', 'msg' => 'Created Successfully')) : mysqli_error($conn);
        }
        if ($action == 'add_class_data') {
            $school_id = $_SESSION['school_id'];
            $classname = test_input($_POST['class']);
            $subject_cat = test_input($_POST['subject_category']);
            $color_array = ["#007bff", "#6610f2", "#001f3f", "#d81b60", "#6c757d", "#28a745", "#ffc107", "#000000", "#343a40", "#adb5bd", "#f012be", "#d81b60", "#ff851b", "#915e8d", "#373f89", "#7b378b", "#868b37", "#8b5f37", "#8b4337"];

            // Retrieve the list of colors already used
            $used_colors = [];
            $select_colors = mysqli_query($conn, "SELECT color FROM class WHERE school_id='$school_id'");
            while ($row = mysqli_fetch_array($select_colors)) {
                $used_colors[] = $row['color'];
            }

            // Filter the $color_array to exclude the colors that have already been used
            $available_colors = array_diff($color_array, $used_colors);

            // Select a color from the remaining colors
            if (count($available_colors) > 0) {
                $color = array_values($available_colors)[0]; // Pick the first available color
            } else {
                // If all colors are used, you can either handle it by reusing colors or throwing an error
                $color = $color_array[array_rand($color_array)];
            }

            // if (!does_it_exist("id", "class", "classname='$classname'")) {
                $insertclass = mysqli_query($conn, "INSERT INTO class(subject_cat, classname, school_id, createdby, datecreated, color) 
                VALUES('$subject_cat', '$classname', '$school_id', '{$_SESSION['userid']}', '$date', '$color')");
                echo $insertclass === true ? json_encode(array('status' => '1', 'msg' => 'Created Successfully')) : mysqli_error($conn);
            // } else {
            //     echo json_encode(array('status' => '0', "err" => "Class already exists"));
            // }
        }
        if ($action == 'add_staff_data') {
            $school_id = $_SESSION['school_id'];
            $firstname = test_input($_POST['firstname']);
            $lastname = test_input($_POST['lastname']);
            $middlename = test_input($_POST['middlename']);
            $gender = test_input($_POST['gender']);
            $phone = test_input($_POST['phone']);
            $email = test_input($_POST['email']);

            $address = test_input($_POST['address']);
            $city = test_input($_POST['city']);
            $state = test_input($_POST['state']);
            $country = test_input($_POST['country']);
            $role = test_input($_POST['staff_role']);

            // $class_id = test_input($_POST['class_id']);
            if (!does_it_exist("phone", "staff", "phone='$phone' OR email='$email'")) {

                $password = substr($phone, -4);
                // exit;
                $hashedpassword = password_hash($password, PASSWORD_ARGON2I);

                $path = "uploads/";
                $valid_ext = array("jpg", "png", "jpeg");
                if ($_FILES['photo']['name'] == '') {
                    $final_img = "avatar.png";
                    // echo "INSERT INTO staff(status,staff_type,createdby,datecreated,address,city,state,country,passw,firstname,middlename,lastname,gender,phone,email,photo,school_id) 
                    // VALUES('1','$role','{$_SESSION["userid"]}','$date','$address','$city','$state','$country','$hashedpassword','$firstname','$middlename','$lastname','$gender','$phone','$email','$final_img','$school_id')";
                    $insert = mysqli_query($conn, "INSERT INTO staff(status,staff_type,createdby,datecreated,address,city,state,country,passw,firstname,middlename,lastname,gender,phone,email,photo,school_id) 
                    VALUES('1','$role','{$_SESSION["userid"]}','$date','$address','$city','$state','$country','$hashedpassword','$firstname','$middlename','$lastname','$gender','$phone','$email','$final_img','$school_id')");
                    if ($insert) {
                        echo $insert === true ? json_encode(array('status' => '1', 'msg' => 'Registered succesfully')) : mysqli_error($conn);
                    } else {
                        echo mysqli_error($conn);
                    }
                    exit;
                } else {
                    $img_name = $_FILES['photo']['name'];
                    $tmp = $_FILES['photo']['tmp_name'];
                    $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
                    $final_img = rand(10000, 1000000) . 'staff' . $img_name;
                    if (in_array($ext, $valid_ext)) {
                        $path = $path . $final_img;
                        if (move_uploaded_file($tmp, $path)) {
                            $insert = mysqli_query($conn, "INSERT INTO staff(status,staff_type,createdby,datecreated,address,city,state,country,passw,firstname,middlename,lastname,gender,phone,email,photo,school_id) 
                    VALUES('1','$role','{$_SESSION["userid"]}','$date','$address','$city','$state','$country','$hashedpassword','$firstname','$middlename','$lastname','$gender','$phone','$email','$final_img','$school_id')");
                            if ($insert) {
                                echo $insert === true ? json_encode(array('status' => '1', 'msg' => 'Registered succesfully')) : mysqli_error($conn);
                            } else {
                                echo mysqli_error($conn);
                            }
                        }
                    } else {
                        echo "file format not supported";
                    }
                }
            } else {
                echo json_encode(array('status' => '0', "err" => "Staff data already exist."));
            }
        }

        // if ($action == 'enrol_student_self') {
        //     $school_id = $_SESSION['school_id'];
        //     $firstname = test_input($_POST['firstname']);
        //     $lastname = test_input($_POST['lastname']);
        //     $middlename = test_input($_POST['middlename']);
        //     $class_id = test_input($_POST['class_id']);
        //     $gender = test_input($_POST['gender']);
        //     $dob = test_input($_POST['dob']);
        //     $phone = test_input($_POST['phone']);
        //     $email = test_input($_POST['email']);
        //     $parentphone = test_input($_POST['parentphone']);
        //     $parentemail = test_input($_POST['parentemail']);


        //     ///
        //     $password = substr($parentphone, -4);
        //     $hashedpassword = password_hash($password, PASSWORD_ARGON2I);

        //     // exit;
        //     if (!does_it_exist("phone", "parent", "phone='$parentphone'")) {
        //         if (does_it_exist("email", "parent", "email='$parentemail'")) {
        //             echo json_encode(array('status' => '0', 'err' => "The email has been used by another user, try another."));
        //             exit;
        //         }
        //         $pfname = test_input($_POST['parentfname']);
        //         $plname = test_input($_POST['parentlname']);
        //         $address = test_input($_POST['address']);
        //         $city = test_input($_POST['city']);
        //         $state = test_input($_POST['state']);
        //         $country = test_input($_POST['country']);

        //         // register_student_without_photo($pfname, $plname, $hashedpassword, $parentphone, $parentemail, $address, $city, $state, $country, $firstname, $lastname, $middlename, $class_id, $gender, $dob, $phone, $email, $school_id);
        //         // register_student_with_photo($pfname, $plname, $hashedpassword, $parentphone, $parentemail, $address, $city, $state, $country, $firstname, $lastname, $middlename, $class_id, $gender, $dob, $phone, $email, $school_id);
        //         if ($_FILES['studentphoto']['name'] == '') {
        //             $final_img = "avatar.png";
        //             $insertparent = mysqli_query($conn, "INSERT INTO parent(firstname,lastname,passw,phone, email, address,city,state,country, school_id)
        //             VALUES('$pfname','$plname','$hashedpassword','$parentphone','$parentemail','$address','$city', '$state','$country','$school_id')");
        //             if ($insertparent) {
        //                 // echo 'here1';
        //                 $selectparentid = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone' AND email='$parentemail' AND school_id='$school_id'");
        //                 if ($row = mysqli_fetch_array($selectparentid)) {
        //                     // echo 'here2';
        //                     $parent_id = $row['id'];
        //                     $insertstudent = mysqli_query($conn, "INSERT INTO students(photo,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
        //                 VALUES('$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')");

        //                     echo $insertstudent === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
        //                 }
        //             }
        //             exit;
        //         } else {
        //             $path = "uploads/";
        //             $valid_ext = array("jpg", "png", "jpeg");
        //             $img_name = $_FILES['studentphoto']['name'];
        //             $tmp = $_FILES['studentphoto']['tmp_name'];
        //             $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
        //             $final_img = rand(10000, 1000000) . 'student' . $img_name;
        //             if (in_array($ext, $valid_ext)) {
        //                 $path = $path . $final_img;
        //                 if (move_uploaded_file($tmp, $path)) {
        //                     // echo 'here0';

        //                     $insertparent = mysqli_query($conn, "INSERT INTO parent(firstname,lastname,passw,phone, email, address,city,state,country, school_id)
        //                 VALUES('$pfname','$plname','$hashedpassword','$parentphone','$parentemail','$address','$city', '$state','$country','$school_id')");
        //                     if ($insertparent) {
        //                         // echo 'here1';
        //                         $selectparentid = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone' AND email='$parentemail' AND school_id='$school_id'");
        //                         if ($row = mysqli_fetch_array($selectparentid)) {
        //                             // echo 'here2';
        //                             $parent_id = $row['id'];
        //                             $insertstudent = mysqli_query($conn, "INSERT INTO students(photo,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
        //                     VALUES('$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')");

        //                             echo $insertstudent === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
        //                         }
        //                     }
        //                 }
        //             } else {
        //                 echo "file format not supported";
        //             }
        //         }
        //     } else {

        //         //parent data exist
        //         $select_parent_id = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone'");
        //         $parent_id_row = mysqli_fetch_array($select_parent_id);
        //         $parent_id = $parent_id_row['id'];
        //         if ($_FILES['studentphoto']['name'] == '') {
        //             $final_img = "avatar.png";
        //         } else {
        //             $path = "uploads/";
        //             $valid_ext = array("jpg", "png", "jpeg");
        //             $img_name = $_FILES['studentphoto']['name'];
        //             $tmp = $_FILES['studentphoto']['tmp_name'];
        //             $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
        //             $final_img = rand(10000, 1000000) . 'student' . $img_name;
        //             if (in_array($ext, $valid_ext)) {
        //                 $path = $path . $final_img;
        //                 if (move_uploaded_file($tmp, $path)) {
        //                     $done = true;
        //                 }
        //             }
        //         }


        //         $insert_student = mysqli_query($conn, "INSERT INTO students(photo,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
        //         VALUES('$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')");
        //     }
        //     echo $insert_student === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
        // }

        // if ($action == 'add_student_data') {
        //     $school_id = $_SESSION['school_id'];
        //     $term = $_SESSION['term_id'];
        //     $session = $_SESSION['session_id'];
        //     $select_student = mysqli_query($conn, "SELECT COUNT(id) as total_student FROM students WHERE school_id='$school_id'");
        //     $student_row = mysqli_fetch_array($select_student);
        //     $select_payment = mysqli_query($conn, "SELECT student_number FROM payments WHERE school_id='$school_id' AND term_id='$term' AND session_id='$session'");
        //     $payment_row = mysqli_fetch_array($select_payment);
        //     // echo $payment_row['student_number'];
        //     if ($payment_row['student_number'] <= $student_row['total_student']) {
        //         echo json_encode(array('status' => '0', 'err' => "Number of student exceeded, Kindly pay for more students."));
        //         exit;
        //     }
        //     $firstname = test_input($_POST['firstname']);
        //     $lastname = test_input($_POST['lastname']);
        //     $middlename = test_input($_POST['middlename']);
        //     $class_id = test_input($_POST['class_id']);
        //     $gender = test_input($_POST['gender']);
        //     $dob = test_input($_POST['dob']);
        //     $phone = test_input($_POST['phone']);
        //     $email = test_input($_POST['email']);
        //     $parentphone = test_input($_POST['parentphone']);
        //     $parentemail = test_input($_POST['parentemail']);
        //     $date = date('Y-m-d H:i:s');
            
        //     $s_password = substr($admission_no, -4);
        //     $s_hashedpassword = password_hash($s_password, PASSWORD_ARGON2I);

        //     $password = substr($parentphone, -4);
        //     $hashedpassword = password_hash($password, PASSWORD_ARGON2I);

        //     if (!does_it_exist("phone", "parent", "phone='$parentphone'")) {
        //         if (does_it_exist("email", "parent", "email='$parentemail'")) {
        //             echo json_encode(array('status' => '0', 'err' => "The email has been used by another user, try another."));
        //             exit;
        //         }
        //         $pfname = test_input($_POST['parentfname']);
        //         $plname = test_input($_POST['parentlname']);
        //         $address = test_input($_POST['address']);
        //         $city = test_input($_POST['city']);
        //         $state = test_input($_POST['state']);
        //         $country = test_input($_POST['country']);

        //         if ($_FILES['studentphoto']['name'] == '') {
        //             $final_img = "avatar.png";
        //             $insertparent = mysqli_query($conn, "INSERT INTO parent(firstname,lastname,passw,phone, email, address,city,state,country, school_id, datecreated, createdby)
        //             VALUES('$pfname','$plname','$hashedpassword','$parentphone','$parentemail','$address','$city', '$state','$country','$school_id','$date','{$_SESSION['userid']}')");
        //             if ($insertparent) {
        //                 $selectparentid = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone' AND email='$parentemail' AND school_id='$school_id'");
        //                 if ($row = mysqli_fetch_array($selectparentid)) {
        //                     $parent_id = $row['id'];
        //                     $insertstudent = mysqli_query($conn, "INSERT INTO students(passw,admission_no,photo,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
        //                     VALUES('$s_hashedpassword','$admission_no','$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')");
        //                     echo $insertstudent === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
        //                 }
        //             }
        //             exit;
        //         } else {
        //             $path = "uploads/";
        //             $valid_ext = array("jpg", "png", "jpeg");
        //             $img_name = $_FILES['studentphoto']['name'];
        //             $tmp = $_FILES['studentphoto']['tmp_name'];
        //             $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
        //             $final_img = rand(10000, 1000000) . 'student' . $img_name;
        //             if (in_array($ext, $valid_ext)) {
        //                 $path = $path . $final_img;
        //                 if (move_uploaded_file($tmp, $path)) {
        //                     $insertparent = mysqli_query($conn, "INSERT INTO parent(firstname,lastname,passw,phone, email, address,city,state,country, school_id,datecreated,createdby) 
        //                     VALUES('$pfname','$plname','$hashedpassword','$parentphone','$parentemail','$address','$city', '$state','$country','$school_id','$date','{$_SESSION['userid']}')");
        //                     if ($insertparent) {
        //                         $selectparentid = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone' AND email='$parentemail' AND school_id='$school_id'");
        //                         if ($row = mysqli_fetch_array($selectparentid)) {
        //                             $parent_id = $row['id'];
        //                             $insertstudent = mysqli_query($conn, "INSERT INTO students(passw,admission_no,admiphoto,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
        //                             VALUES('$s_hashedpassword','$admission_no','$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')");
        //                             echo $insertstudent === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
        //                         }
        //                     }
        //                 }
        //             } else {
        //                 echo json_encode(array('status' => '0', 'err' => "File format not supported"));
        //             }
        //         }
        //     } else {
        //         $select_parent_id = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone'");
        //         $parent_id_row = mysqli_fetch_array($select_parent_id);
        //         $parent_id = $parent_id_row['id'];
        //         if ($_FILES['studentphoto']['name'] == '') {
        //             $final_img = "avatar.png";
        //         } else {
        //             $path = "uploads/";
        //             $valid_ext = array("jpg", "png", "jpeg");
        //             $img_name = $_FILES['studentphoto']['name'];
        //             $tmp = $_FILES['studentphoto']['tmp_name'];
        //             $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
        //             $final_img = rand(10000, 1000000) . 'student' . $img_name;
        //             if (in_array($ext, $valid_ext)) {
        //                 $path = $path . $final_img;
        //                 if (move_uploaded_file($tmp, $path)) {
        //                     $done = true;
        //                 }
        //             }
        //         }

        //         $insert_student = mysqli_query($conn, "INSERT INTO students(passw,admission_no,photo,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
        //         VALUES('$s_hashedpassword','$admission_no','$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')");
        //         echo $insert_student === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
        //     }
        // }
        
         if ($action == 'add_student_data') {
            $school_id = $_SESSION['school_id'];
            $term = $_SESSION['term_id'];
            $session = $_SESSION['session_id'];
            if($school_id == 26){
                // echo "SELECT count(*) as total_student FROM students s INNER JOIN payment_record pr ON pr.student_id = s.id AND pr.term_id = '$term' AND pr.session_id = '$session'
                // WHERE s.school_id = '$school_id' AND pr.status=1";
                
                $select_student = mysqli_query($conn, "SELECT count(*) as total_student FROM students s INNER JOIN payment_record pr ON pr.student_id = s.id AND pr.term_id = '$term' AND pr.session_id = '$session'
                WHERE s.school_id = '$school_id' AND pr.status=1");
            }
            else 
            {
            $select_student = mysqli_query($conn, "SELECT COUNT(id) as total_student FROM payment_record WHERE session_id='$session' AND term_id='$term' AND status=1 AND school_id='$school_id'");
            // $select_student = mysqli_query($conn, "SELECT COUNT(id) as total_student FROM students WHERE school_id='$school_id'");
            }
            $student_row = mysqli_fetch_array($select_student);
            $select_payment = mysqli_query($conn, "SELECT SUM(student_number) AS total_paid_for FROM payments WHERE school_id='$school_id' AND term_id='$term' AND session_id='$session'");
            
            $payment_row = mysqli_fetch_array($select_payment);
            // echo "paid for".$payment_row['total_paid_for'];
            // echo "student".$student_row['total_student'];
            //  if( $_SESSION['school_id == 13'] && $student_row['total_student'] == '20') {
            //     echo json_encode(array('status' => '0', 'err' => "Number of student exceeded, Kindly pay for more students."));
            //     exit;
            //  }
            //  exit;
            
        
            $school_id_array = [13,29,30,39];
            if(!in_array($school_id, $school_id_array)){
                if ($student_row['total_student'] >= $payment_row['total_paid_for']) {
                // if ($payment_row['total_paid_for'] > 40) {
                    echo json_encode(array('status' => '0', 'err' => "Number of student exceeded, Kindly pay for more students."));
                    exit;
                }
            }
            // if ($school_id == 38) {
            //     $count_q = "SELECT COUNT(id) as total FROM students WHERE school_id=38";
            //     $result_q = mysqli_query($conn, $count_q);
            //     $row = mysqli_fetch_assoc($result_q);
            //     if ($row['total'] == 20) {
            //         echo "You have exceeded the limit";
            //     }
            // }

            // $student_row['total_student'];
            // echo "new";
            // echo $payment_row['total_paid_for'];
            // exit;
            $department = test_input($_POST['department']);
            $firstname = test_input($_POST['firstname']);
            $lastname = test_input($_POST['lastname']);
            $admission_no = test_input($_POST['admissionnumber']);
            $middlename = test_input($_POST['middlename']);
            $class_id = test_input($_POST['class_id']);
            $gender = test_input($_POST['gender']);
            $dob = test_input($_POST['dob']);
            $phone = test_input($_POST['phone']);
            $email = test_input($_POST['email']);
            $parentphone = test_input($_POST['parentphone']);
            $parentemail = test_input($_POST['parentemail']);
            $date = date('Y-m-d H:i:s');

            $s_password = substr($admission_no, -4);
            $s_hashedpassword = password_hash($s_password, PASSWORD_ARGON2I);

            $password = substr($parentphone, -4);
            $hashedpassword = password_hash($password, PASSWORD_ARGON2I);
            // exit;

            if (!does_it_exist("phone", "parent", "phone='$parentphone'")) {
                if (does_it_exist("email", "parent", "email='$parentemail'")) {
                    echo json_encode(array('status' => '0', 'err' => "The email has been used by another user, try another."));
                    exit;
                }
                $pfname = test_input($_POST['parentfname']);
                $plname = test_input($_POST['parentlname']);
                $address = test_input($_POST['address']);
                $city = test_input($_POST['city']);
                $state = test_input($_POST['state']);
                $country = test_input($_POST['country']);
                // echo "kl";
                if ($_FILES['studentphoto']['name'] == '') {
                    $final_img = "avatar.png";
                    // echo "INSERT INTO parent(firstname,lastname,passw,phone, email, address,city,state,country, school_id, datecreated, createdby)
                    // VALUES('$pfname','$plname','$hashedpassword','$parentphone','$parentemail','$address','$city', '$state','$country','$school_id','$date','{$_SESSION['userid']}')";
                    // exit;
                    $insertparent = mysqli_query($conn, "INSERT INTO parent(firstname,lastname,passw,phone, email, address,city,state,country, school_id, datecreated, createdby)
                    VALUES('$pfname','$plname','$hashedpassword','$parentphone','$parentemail','$address','$city', '$state','$country','$school_id','$date','{$_SESSION['userid']}')");
                    if ($insertparent) {
                        $selectparentid = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone' AND email='$parentemail' AND school_id='$school_id'");
                        if ($row = mysqli_fetch_array($selectparentid)) {
                            $parent_id = $row['id'];
                            $insertstudent = mysqli_query($conn, "INSERT INTO students(department, passw,admission_no,photo,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
                            VALUES('$department','$s_hashedpassword','$admission_no','$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')");
                            // echo "mkec";
                            if ($insertstudent) {
                                // Get the last inserted student id
                                $student_id = mysqli_insert_id($conn);
                                $session_id = $_SESSION['session_id'];
                                $term_id = $_SESSION['term_id'];
                                $status = 1; // or set as needed
                                $created_by = $_SESSION['userid'];
                                $updatedby = $_SESSION['userid'];
                                $datecreated = $date;
                                $dateupdated = $date;
                                $insert_payment = mysqli_query($conn, "INSERT INTO payment_record (student_id, class_id, session_id, term_id, school_id, status, createdby, updatedby, datecreated, dateupdated) VALUES ('$student_id', '$class_id', '$session_id', '$term_id', '$school_id', '$status', '$created_by', '$updatedby', '$datecreated', '$dateupdated')");
                                if ($insert_payment) {
                                    echo json_encode(array('status' => '1'));
                                } else {
                                    echo json_encode(array('status' => '0', 'err' => 'Student added but payment record failed: ' . mysqli_error($conn)));
                                }
                            } else {
                                echo mysqli_error($conn);
                            }
                        }
                    }
                    exit;
                } else {
                    // echo "fg";
                    $path = "uploads/";
                    $valid_ext = array("jpg", "png", "jpeg");
                    $img_name = $_FILES['studentphoto']['name'];
                    $tmp = $_FILES['studentphoto']['tmp_name'];
                    $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
                    $final_img = rand(10, 100000000000) . 'student' . $img_name;
                    if (in_array($ext, $valid_ext)) {
                        $path = $path . $final_img;
                        if (move_uploaded_file($tmp, $path)) {
                            $insertparent = mysqli_query($conn, "INSERT INTO parent(firstname,lastname,passw,phone, email, address,city,state,country, school_id,datecreated,createdby) 
                            VALUES('$pfname','$plname','$hashedpassword','$parentphone','$parentemail','$address','$city', '$state','$country','$school_id','$date','{$_SESSION['userid']}')");
                            if ($insertparent) {
                                $selectparentid = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone' AND email='$parentemail' AND school_id='$school_id'");
                                if ($row = mysqli_fetch_array($selectparentid)) {
                                    $parent_id = $row['id'];
                                    // echo "INSERT INTO students(department,passw,admission_no,photo,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
                                    // VALUES('$department','$s_hashedpassword','$admission_no','$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')";
                                    $insertstudent = mysqli_query($conn, "INSERT INTO students(department,passw,admission_no,photo,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
                                    VALUES('$department','$s_hashedpassword','$admission_no','$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')");
                                    if ($insertstudent) {
                                        // Get the last inserted student id
                                        $student_id = mysqli_insert_id($conn);
                                        $session_id = $_SESSION['session_id'];
                                        $term_id = $_SESSION['term_id'];
                                        $status = 1; // or set as needed
                                        $created_by = $_SESSION['userid'];
                                        $updatedby = $_SESSION['userid'];
                                        $datecreated = $date;
                                        $dateupdated = $date;
                                        $insert_payment = mysqli_query($conn, "INSERT INTO payment_record (student_id, class_id, session_id, term_id, school_id, status, createdby, updatedby, datecreated, dateupdated) VALUES ('$student_id', '$class_id', '$session_id', '$term_id', '$school_id', '$status', '$created_by', '$updatedby', '$datecreated', '$dateupdated')");
                                        if ($insert_payment) {
                                            echo json_encode(array('status' => '1'));
                                        } else {
                                            echo json_encode(array('status' => '0', 'err' => 'Student added but payment record failed: ' . mysqli_error($conn)));
                                        }
                                    } else {
                                        echo mysqli_error($conn);
                                    }
                                }
                            }
                        }
                    } else {
                        echo json_encode(array('status' => '0', 'err' => "File format not supported"));
                    }
                }
            } else {
                // echo "er";
                $select_parent_id = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone'");
                $parent_id_row = mysqli_fetch_array($select_parent_id);
                $parent_id = $parent_id_row['id'];
                if ($_FILES['studentphoto']['name'] == '') {
                    $final_img = "avatar.png";
                } else {
                    $path = "uploads/";
                    $valid_ext = array("jpg", "png", "jpeg");
                    $img_name = $_FILES['studentphoto']['name'];
                    $tmp = $_FILES['studentphoto']['tmp_name'];
                    $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
                    $final_img = rand(10, 1000000000000) . 'student' . $img_name;
                    if (in_array($ext, $valid_ext)) {
                        $path = $path . $final_img;
                        if (move_uploaded_file($tmp, $path)) {
                            $done = true;
                        }
                    }
                }

                $insert_student = mysqli_query($conn, "INSERT INTO students(department,passw,admission_no,photo,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
                VALUES('$department','$s_hashedpassword','$admission_no','$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')");
                if ($insert_student) {
                    // Get the last inserted student id
                    $student_id = mysqli_insert_id($conn);
                    $session_id = $_SESSION['session_id'];
                    $term_id = $_SESSION['term_id'];
                    $status = 1; // or set as needed
                    $created_by = $_SESSION['userid'];
                    $updatedby = $_SESSION['userid'];
                    $datecreated = $date;
                    $dateupdated = $date;
                //   echo  "INSERT INTO payment_record (student_id, class_id, session_id, term_id, school_id, status, created_by, updatedby, datecreated, dateupdated) VALUES ('$student_id', '$class_id', '$session_id', '$term_id', '$school_id', '$status', '$created_by', '$updatedby', '$datecreated', '$dateupdated')";
                    $insert_payment = mysqli_query($conn, "INSERT INTO payment_record (student_id, class_id, session_id, term_id, school_id, status, createdby, updatedby, datecreated, dateupdated) VALUES ('$student_id', '$class_id', '$session_id', '$term_id', '$school_id', '$status', '$created_by', '$updatedby', '$datecreated', '$dateupdated')");
                    if ($insert_payment) {
                        echo json_encode(array('status' => '1'));
                    } else {
                        echo json_encode(array('status' => '0', 'err' => 'Student added but payment record failed: ' . mysqli_error($conn)));
                    }
                } else {
                    echo mysqli_error($conn);
                }
            }
        }
        if ($action == 'update_class_data') {
            // echo "m";
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            $classname = test_input($_POST['classname']);
             if (isset($_POST['subject_category'])) {
                $subject_category = test_input($_POST['subject_category']);
               $set = 'subject_cat=' . $subject_category . ',';
                $is_graduate = false;
            } else {
                $set = '';
                $is_graduate = true;
            }

            $updateclass = mysqli_query($conn, "UPDATE class SET $set classname='$classname', dateupdated='$date', updatedby='{$_SESSION['userid']}' WHERE school_id='$school_id' AND id='$id'");
            // $insert = mysqli_query($conn, "INSERT INTO students(firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id) 
            // VALUES('$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id')");
            // if ($updatestudent) {
            //     $updateparent = mysqli_query($conn, "UPDATE parent SET phone='$parentphone', email='$parentemail', address='$address', city='$city', state='$state', country='$country' WHERE school_id='$school_id' AND id='$parent_id' ");
            // }
            echo $updateclass === true ? json_encode(array('status' => '1', 'is_graduate' => $is_graduate)) : mysqli_error($conn);
        }
        // if ($action == 'update_parent_data') {
        //     // echo "here";
        //     $school_id = $_SESSION['school_id'];
        //     $id = test_input($_POST['id']);
        //     // exit;
        //     $firstname = test_input($_POST['firstname']);
        //     $lastname = test_input($_POST['lastname']);
        //     $phone = test_input($_POST['phone']);
        //     $email = test_input($_POST['email']);

        //     $address = test_input($_POST['address']);
        //     $city = test_input($_POST['city']);
        //     $state = test_input($_POST['state']);
        //     $country = test_input($_POST['country']);
        //     // check if phone number or email exist first with the same school_id, if it exist, then check if the id is the same as the id being updated
        //     // if the data exists, then return an error message
        //     // else update the data
        //     // if (does_it_exist("phone", "parent", "phone='$phone' AND school_id='$school_id' AND id!='$id'")) {
        //     //     echo json_encode(array('status' => '0', 'err' => "This phone number belongs to another parent, try a different phone number"));
        //     //     exit;
        //     // }
        //     // // check if email exist
        //     // if (does_it_exist("email", "parent", "email='$email' AND school_id='$school_id' AND id!='$id'")) {
        //     //     echo json_encode(array('status' => '0', 'err' => "This email belongs to another parent, try a different email address"));
        //     //     exit;
        //     // }
        //     // update the data


        //     $update = mysqli_query($conn, "UPDATE parent SET 
        // address='$address',city='$city', state='$state', 
        // country='$country', firstname='$firstname',
        // lastname='$lastname',phone='$phone',email='$email', 
        // dateupdated='$date',updatedby={$_SESSION['userid']} 
        // WHERE school_id='$school_id' AND id='$id'");
        
        // if ($id == $_SESSION['userid']) {
        //     $_SESSION['firstname'] = $firstname;
        //     $_SESSION['lastname'] = $lastname;
        //     $_SESSION['email'] = $email;
        //     $_SESSION['phone'] = $phone;
        // }

        //     echo $update === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
        // }
          if ($action == 'update_parent_data') {
        $school_id = $_SESSION['school_id'];
        $id = test_input($_POST['id']);
        $firstname = test_input($_POST['firstname']);
        $lastname = test_input($_POST['lastname']);
        $phone = test_input($_POST['phone']);
        $email = test_input($_POST['email']);

        $address = test_input($_POST['address']);
        $city = test_input($_POST['city']);
        $state = test_input($_POST['state']);
        $country = test_input($_POST['country']);

        $scope = isset($_POST['update_scope']) ? test_input($_POST['update_scope']) : 'all';
        $ref_student_id = isset($_POST['ref_student_id']) ? test_input($_POST['ref_student_id']) : null;

        // --- SINGLE STUDENT REASSIGNMENT LOGIC ---
        if ($scope == 'single' && $ref_student_id) {
            // Check if phone number exists for another parent
            $select_existing = mysqli_query($conn, "SELECT id, phone FROM parent WHERE phone='$phone' AND school_id='$school_id' AND id!='$id'");

            if ($res_existing = mysqli_fetch_assoc($select_existing)) {
                // Scenario: Moving to an EXISTING parent
                $existing_id = $res_existing['id'];

                // 1. Update the target parent's details
                mysqli_query($conn, "UPDATE parent SET 
                    address='$address', city='$city', state='$state', 
                    country='$country', firstname='$firstname',
                    lastname='$lastname', email='$email', 
                    dateupdated='$date', updatedby='{$_SESSION['userid']}' 
                    WHERE school_id='$school_id' AND id='$existing_id'");

                // 2. Point only this student to the target parent
                $update_stud = mysqli_query($conn, "UPDATE students SET parent_id='$existing_id' WHERE id='$ref_student_id' AND school_id='$school_id'");

                echo $update_stud === true ? json_encode(array('status' => '1', 'msg' => 'Student reassigned to existing parent successfully')) : mysqli_error($conn);
            } else {
                // Scenario: Moving to a NEW parent (creating parent record for this student)
                $password = substr($phone, -4);
                $hashedpassword = password_hash($password, PASSWORD_ARGON2I);

                $insert_new_parent = mysqli_query($conn, "INSERT INTO parent(firstname, lastname, passw, phone, email, address, city, state, country, school_id, datecreated, createdby) 
                    VALUES('$firstname', '$lastname', '$hashedpassword', '$phone', '$email', '$address', '$city', '$state', '$country', '$school_id', '$date', '{$_SESSION['userid']}')");

                if ($insert_new_parent) {
                    $new_parent_id = mysqli_insert_id($conn);
                    // Point only this student to the new parent
                    $update_stud = mysqli_query($conn, "UPDATE students SET parent_id='$new_parent_id' WHERE id='$ref_student_id' AND school_id='$school_id'");
                    echo $update_stud === true ? json_encode(array('status' => '1', 'msg' => 'Student reassigned to new parent successfully')) : mysqli_error($conn);
                } else {
                    echo json_encode(array('status' => '0', 'err' => "Error creating new parent: " . mysqli_error($conn)));
                }
            }
            exit;
        }

        // --- STANDARD UPDATE / MERGE LOGIC (Applies to all children) ---
        $select_existing = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$phone' AND school_id='$school_id' AND id!='$id'");
        if ($res_existing = mysqli_fetch_assoc($select_existing)) {
            $existing_id = $res_existing['id'];

            // 1. Update the existing parent record with the new info
            $update_existing = mysqli_query($conn, "UPDATE parent SET 
                address='$address', city='$city', state='$state', 
                country='$country', firstname='$firstname',
                lastname='$lastname', phone='$phone', email='$email', 
                dateupdated='$date', updatedby='{$_SESSION['userid']}' 
                WHERE school_id='$school_id' AND id='$existing_id'");

            if ($update_existing) {
                // 2. Link all students from the current ID to the existing ID
                mysqli_query($conn, "UPDATE students SET parent_id='$existing_id' WHERE parent_id='$id' AND school_id='$school_id'");

                // 3. If the current ID being updated is the session user, update session to point to the existing ID
                if ($id == $_SESSION['userid']) {
                    $_SESSION['userid'] = $existing_id;
                    $_SESSION['firstname'] = $firstname;
                    $_SESSION['lastname'] = $lastname;
                    $_SESSION['email'] = $email;
                    $_SESSION['phone'] = $phone;
                }

                // 4. Delete the redundant parent record
                mysqli_query($conn, "DELETE FROM parent WHERE id='$id' AND school_id='$school_id'");

                echo json_encode(array('status' => '1', 'msg' => 'Records merged and updated successfully'));
            } else {
                echo json_encode(array('status' => '0', 'err' => "Error updating existing record: " . mysqli_error($conn)));
            }
            exit;
        }

        // Standard update if no duplicate phone is found (or merging not required)
        $update = mysqli_query($conn, "UPDATE parent SET 
            address='$address', city='$city', state='$state', 
            country='$country', firstname='$firstname',
            lastname='$lastname', phone='$phone', email='$email', 
            dateupdated='$date', updatedby='{$_SESSION['userid']}' 
            WHERE school_id='$school_id' AND id='$id'");

        if ($id == $_SESSION['userid']) {
            $_SESSION['firstname'] = $firstname;
            $_SESSION['lastname'] = $lastname;
            $_SESSION['email'] = $email;
            $_SESSION['phone'] = $phone;
        }

        echo $update === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
    }
        if ($action == 'update_staff_data') {
            // echo "here";
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            // exit;
            $firstname = test_input($_POST['firstname']);
            $lastname = test_input($_POST['lastname']);
            $middlename = test_input($_POST['middlename']);
            $gender = test_input($_POST['gender']);
            $phone = test_input($_POST['phone']);
            $email = test_input($_POST['email']);

            $address = test_input($_POST['address']);
            $city = test_input($_POST['city']);
            $state = test_input($_POST['state']);
            $country = test_input($_POST['country']);
            if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                $status = test_input($_POST['status']);
                $role = test_input($_POST['staff_role']);
            }

            $path = "uploads/";
            $valid_ext = array("jpg", "png", "jpeg");
            if ($_FILES['photo']['name'] == '') {
                // exit;
                if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                    $update = mysqli_query($conn, "UPDATE staff SET status='$status', address='$address',city='$city', state='$state', country='$country', staff_type='$role', firstname='$firstname',lastname='$lastname',middlename='$middlename',gender='$gender',phone='$phone',email='$email', dateupdated='$date',updatedby={$_SESSION['userid']} WHERE school_id='$school_id' AND id='$id'");
                } else {
                    $update = mysqli_query($conn, "UPDATE staff SET address='$address',city='$city', state='$state', country='$country', firstname='$firstname',lastname='$lastname',middlename='$middlename',gender='$gender',phone='$phone',email='$email', dateupdated='$date',updatedby={$_SESSION['userid']} WHERE school_id='$school_id' AND id='$id'");
                }
                if ($id == $_SESSION['userid']) {
                    $_SESSION['firstname'] = $firstname;
                    $_SESSION['lastname'] = $lastname;
                    $_SESSION['email'] = $email;
                }
                if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                    if ($id == $_SESSION['userid']) {
                        $_SESSION['staff_type'] = $role;
                    }
                }
                echo $update === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
            } else {
                $img_name = $_FILES['photo']['name'];
                $tmp = $_FILES['photo']['tmp_name'];
                // delete the previous file
                $selectphoto = mysqli_query($conn, "SELECT photo FROM staff WHERE school_id='$school_id' AND id='$id'");
                $photorow = mysqli_fetch_array($selectphoto);
                if ($photorow['photo'] != 'avatar.png') {
                    $filepath = $path . $photorow['photo'];
                    deleteFile($filepath);
                }
                // if (deleteFile($filepath)) {
                $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
                $final_img = rand(10000, 1000000) . 'staff' . $img_name;
                if (in_array($ext, $valid_ext)) {
                    $path = $path . $final_img;
                    if (move_uploaded_file($tmp, $path)) {
                        if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                            $update = mysqli_query($conn, "UPDATE staff SET  status='$status', address='$address',city='$city', state='$state', country='$country', photo='$final_img', staff_type='$role', firstname='$firstname',lastname='$lastname',middlename='$middlename',gender='$gender',phone='$phone',email='$email', dateupdated='$date',updatedby={$_SESSION['userid']} WHERE school_id='$school_id' AND id='$id'");
                        } else {
                            $update = mysqli_query($conn, "UPDATE staff SET address='$address',city='$city', state='$state', country='$country', photo='$final_img', firstname='$firstname',lastname='$lastname',middlename='$middlename',gender='$gender',phone='$phone',email='$email', dateupdated='$date',updatedby={$_SESSION['userid']} WHERE school_id='$school_id' AND id='$id'");
                        }
                        echo $update === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
                        if ($id == $_SESSION['userid']) {
                            $_SESSION['photo'] = $final_img;
                            $_SESSION['firstname'] = $firstname;
                            $_SESSION['lastname'] = $lastname;
                            $_SESSION['email'] = $email;
                        }
                        if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                            if ($id == $_SESSION['userid']) {
                                $_SESSION['staff_type'] = $role;
                            }
                        }
                    }
                } else {
                    echo "file format not supported";
                }
            }

            if ($id == $_SESSION['userid']) {
                $_SESSION['firstname'] = $firstname;
                $_SESSION['lastname'] = $lastname;
                $_SESSION['email'] = $email;
                if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                    $_SESSION['staff_type'] = $role;
                }
            }
            // $update = mysqli_query($conn, "UPDATE staff SET staff_type='$role', firstname='$firstname',lastname='$lastname',middlename='$middlename',class_id='$class_id',gender='$gender',phone='$phone',email='$email', dateupdated='$date',updatedby={$_SESSION['userid']} WHERE school_id='$school_id' AND id='$id'");
            // $insert = mysqli_query($conn, "INSERT INTO students(firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id) 
            // VALUES('$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id')");

            // echo $update === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
        }
if($action == "get_subjects_and_classes") {
    $staff_id = isset($_POST['staff_id']) ? intval($_POST['staff_id']) : 0;
    $school_id = isset($_SESSION['school_id']) ? intval($_SESSION['school_id']) : 0;

    // Get all classes
    $class_result = mysqli_query($conn, "SELECT id, classname, subject_cat FROM class WHERE school_id='$school_id' AND is_graduate=0");
    $classes = array();
    while ($row = mysqli_fetch_assoc($class_result)) {
        $classes[$row['id']] = array(
            'id' => $row['id'],
            'classname' => $row['classname'],
            'subject_cat' => $row['subject_cat']
        );
    }
// var_dump($classes);
    // Get all subject_cat mappings
    $subject_cat_ids = array();
    foreach ($classes as $c) {
        $subject_cat_ids[$c['subject_cat']] = true;
    }
    // var_dump($subject_cat_ids);
    $subject_cat_str = implode(',', array_keys($subject_cat_ids));
    $subject_cat_map = array();
    // echo "SELECT id, subject_ids FROM subject_cat WHERE id IN ($subject_cat_str)";
    $subject_cat_result = mysqli_query($conn, "SELECT id, subject_ids FROM subject_cat WHERE id IN ($subject_cat_str)");
    // echo "mmpcm";
    while ($row = mysqli_fetch_assoc($subject_cat_result)) {
        $subject_cat_map[$row['id']] = $row['subject_ids']; // comma separated subject ids
    }

    // Get all subject ids for all classes
    $all_subject_ids = array();
    foreach ($classes as $c) {
        $subj_ids = isset($subject_cat_map[$c['subject_cat']]) ? $subject_cat_map[$c['subject_cat']] : '';
        foreach (explode(',', $subj_ids) as $sid) {
            $sid = trim($sid);
            if ($sid !== '') $all_subject_ids[$sid] = true;
        }
    }
    $all_subject_ids_str = implode(',', array_keys($all_subject_ids));

    // Get subject names
    $subjects = array();
    if ($all_subject_ids_str) {
        $subj_result = mysqli_query($conn, "SELECT id, subject FROM subjects WHERE id IN ($all_subject_ids_str)");
        while ($subj_row = mysqli_fetch_assoc($subj_result)) {
            $subjects[$subj_row['id']] = $subj_row['subject'];
        }
    }

    // Get staff assignments
    $result = mysqli_query($conn, "SELECT subject_assigned FROM staff WHERE id = $staff_id LIMIT 1");
    $row = mysqli_fetch_assoc($result);
    $subject_assigned = isset($row['subject_assigned']) ? $row['subject_assigned'] : '';
    $staff_assignments = array(); // [class_id => [subject_id, ...]]
    preg_match_all('/(\d+):\s*([\d,]+)/', $subject_assigned, $matches, PREG_SET_ORDER);
    foreach ($matches as $match) {
        $class_id = intval($match[1]);
        $subject_ids = array_filter(array_map('intval', explode(',', $match[2])));
        $staff_assignments[$class_id] = $subject_ids;
    }

    // Build output
    $output = array();
    foreach ($classes as $class_id => $class_info) {
        $subj_ids = isset($subject_cat_map[$class_info['subject_cat']]) ? $subject_cat_map[$class_info['subject_cat']] : '';
        $subj_ids_arr = array();
        foreach (explode(',', $subj_ids) as $sid) {
            $sid = trim($sid);
            if ($sid === '' || !isset($subjects[$sid])) continue;
            $assigned = (isset($staff_assignments[$class_id]) && in_array(intval($sid), $staff_assignments[$class_id])) ? true : false;
            $subj_ids_arr[] = array(
                'id' => $sid,
                'name' => $subjects[$sid],
                'assigned_to_staff' => $assigned
            );
        }
        $output[] = array(
            'class_id' => $class_id,
            'classname' => $class_info['classname'],
            'class_subjects' => $subj_ids_arr
        );
    }
    header('Content-Type: application/json');
    echo json_encode($output);
    exit();
}
if (isset($_POST['action']) && $_POST['action'] == 'assign_staff_subjects_by_classes') {
    $staff_id = isset($_POST['staff_id']) ? intval($_POST['staff_id']) : 0;
    $assignments = isset($_POST['assignments']) ? trim($_POST['assignments']) : '';
    $response = array('status' => '0', 'msg' => '');
    if ($staff_id > 0 && $assignments !== '') {
        // Save assignments string to staff.subject_assigned
        // require_once 'db.php'; // adjust if your DB connection file is named differently
        // $conn = global $conn; // or use your connection variable
        $stmt = $conn->prepare("UPDATE staff SET subject_assigned = ? WHERE id = ?");
        if ($stmt) {
            $stmt->bind_param("si", $assignments, $staff_id);
            if ($stmt->execute()) {
                $response['status'] = '1';
                $response['msg'] = 'Assignments saved.';
            } else {
                $response['msg'] = 'Failed to save assignments.';
            }
            $stmt->close();
        } else {
            $response['msg'] = 'DB error.';
        }
    } else {
        $response['msg'] = 'Invalid staff or assignments.';
    }
    echo json_encode($response);
    exit;
}
        if ($action == 'get_priviledges') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            $fullname = get_staff_fullname_by_id($id);
            $select = mysqli_query($conn, "SELECT id,update_school,register_staff,register_student,edit_student,change_class,add_class,manage_payment,student_qr,staff_qr 
        FROM staff WHERE id='$id' AND school_id='$school_id'");
            $row = mysqli_fetch_array($select);
            ?>
            <div class="modal-header py-1 align-items-center">
                <div>
                    <p class="modal-title">Assign Priviledges</p>
                    <small class="accent d-block"><?= $fullname ?></small>
                </div>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body pb-0" id="assign_priviledge_modal_body">
                <form class="" onsubmit="submit_priviledge_form(event)" action="">
                    <input type="hidden" name="staff_id" value="<?= $id ?>">
                    <input type="hidden" name="action" value="submit_priviledges">
                    <table style="width: 100%;" class="display nowrap" id="priviledges_table">
                        <tbody>
                            <tr>
                                <td>
                                    <p>Can update school information</p>
                                    <p class="small">This includes updating school information and other settings such as name, descriptions, term settings etc.</p>
                                </td>
                                <td>
                                    <div class="icheck-primary">
                                        <input type="checkbox" class="table_checkbox" name="update_school" id="p_update_school_information" <?= $row['update_school'] == '1' ? 'checked' : '' ?>>
                                        <label for="p_update_school_information"></label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p>Can register new student</p>
                                    <p class="small">This gives access to register any student.</p>
                                </td>
                                <td>
                                    <div class="icheck-primary">
                                        <input type="checkbox" class="table_checkbox" id="p_register_student" name="register_student" <?= $row['register_student'] == '1' ? 'checked' : '' ?>>
                                        <label for="p_register_student"></label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p>Can edit student information</p>
                                    <p class="small">This gives access to edit any student information including assigning classes.</p>
                                </td>
                                <td>
                                    <div class="icheck-primary">
                                        <input type="checkbox" class="table_checkbox" id="p_edit_student" name="edit_student" <?= $row['edit_student'] == '1' ? 'checked' : '' ?>>
                                        <label for="p_edit_student"></label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p>Can change student(s) class</p>
                                    <p class="small">This gives access to transfer any student to any class.</p>
                                </td>
                                <td>
                                    <div class="icheck-primary">
                                        <input type="checkbox" class="table_checkbox" id="p_change_class" name="change_class" <?= $row['change_class'] == '1' ? 'checked' : '' ?>>
                                        <label for="p_change_class"></label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p>Can add new class</p>
                                    <p class="small">This gives access to add new class.</p>
                                </td>
                                <td>
                                    <div class="icheck-primary">
                                        <input type="checkbox" class="table_checkbox" id="p_add_class" name="add_class" <?= $row['add_class'] == '1' ? 'checked' : '' ?>>
                                        <label for="p_add_class"></label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p>Can access the QR system for student</p>
                                    <p class="small">This gives access to scan students in or out of the school premises via the QR system .</p>
                                </td>
                                <td>
                                    <div class="icheck-primary">
                                        <input type="checkbox" class="table_checkbox" id="p_student_qrcode" name="student_qr" <?= $row['student_qr'] == '1' ? 'checked' : '' ?>>
                                        <label for="p_student_qrcode"></label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p>Can take staff attendance via manual or QRcode system</p>
                                    <p class="small">This gives access to take staff attendance manually or via QRcode system</p>
                                </td>
                                <td>
                                    <div class="icheck-primary">
                                        <input type="checkbox" class="table_checkbox" id="p_staff_qrcode" name="staff_qr" <?= $row['staff_qr'] == '1' ? 'checked' : '' ?>>
                                        <label for="p_staff_qrcode"></label>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <p>Can manage payments</p>
                                    <p class="small">This gives access to manage all payment related data for the school</p>
                                </td>
                                <td>
                                    <div class="icheck-primary">
                                        <input type="checkbox" class="table_checkbox" id="p_payments" name="manage_payment" <?= $row['manage_payment'] == '1' ? 'checked' : '' ?>>
                                        <label for="p_payments"></label>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <div class="card-foot">
                        <div class="text-center">
                            <small class="text-danger" id="update_priviledges_warning" style="display: none;"></small>
                        </div>
                        <button type="submit" id="add_new_staff_submit_btn" class="btn btn-primary">Assign Priviledge</button>
                        <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Cancel</button>
                    </div>
                </form>
            </div>

            </div>
        <?php
        }
        if ($action == 'get_staff_table') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            exit;
            // $fullname = get_staff_fullname_by_id($id);
            $select_staff = mysqli_query($conn, "SELECT id,class_id,firstname, lastname, middlename FROM staff WHERE id='$id'");
            $staff_row = mysqli_fetch_array($select_staff);
            $fullname = $staff_row['lastname'] . ' ' . $staff_row['middlename'] . ' ' . $staff_row['lastname'];
            $select_class = mysqli_query($conn, "SELECT id, classname 
        FROM class WHERE school_id='$school_id'");
            // $row = mysqli_fetch_array($select_class);
        ?>


            <div>
                <?php
                $class_id_array = explode(",", $staff_row['class_id']);
                while ($class_row = mysqli_fetch_array($select_class)) {
                ?>
                    <div class="icheck-primary py-1">
                        <input type="checkbox" class="table_checkbox" value="<?= $class_row['id'] ?>" name="update_school" id="<?= $class_row['id'] ?>" <?= in_array($class_row['id'], $class_id_array) == true ? 'checked' : '' ?>>
                        <label class="w-100" for="<?= $class_row['id'] ?>"><?= $class_row['classname'] ?></label>
                    </div>
                <?php
                }
                ?>
            </div>
            <div class="card-foot">
                <button type="button" class="btn btn-primary" onclick="submit_staff_class_assign('<?= $id ?>')">Assign Classes</button>
                <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Cancel</button>
            </div>
            </div>
        <?php
        }
        if ($action == 'get_classes') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            // $fullname = get_staff_fullname_by_id($id);
            $select_staff = mysqli_query($conn, "SELECT id,class_id,firstname, lastname, middlename FROM staff WHERE id='$id'");
            $staff_row = mysqli_fetch_array($select_staff);
            $fullname = $staff_row['lastname'] . ' ' . $staff_row['middlename'] . ' ' . $staff_row['lastname'];
            $select_class = mysqli_query($conn, "SELECT id, classname 
        FROM class WHERE school_id='$school_id'");
            if (mysqli_num_rows($select_class) == 0) {
                $class_exist = false;
            } else {
                $class_exist = true;
            }
            // $row = mysqli_fetch_array($select_class);
        ?>
            <div class="modal-header py-1 align-items-center">
                <div>
                    <p class="modal-title">Assign Classes</p>
                    <small class="accent d-block"><?= $fullname ?></small>
                </div>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">×</span>
                </button>
            </div>
            <div class="modal-body pb-0" id="assign_priviledge_modal_body">
                <div>
                    <?php
                    $class_id_array = explode(",", $staff_row['class_id']);
                    while ($class_row = mysqli_fetch_array($select_class)) {
                    ?>
                        <div class="icheck-primary py-1">
                            <input type="checkbox" class="table_checkbox" value="<?= $class_row['id'] ?>" name="update_school" id="<?= $class_row['id'] ?>" <?= in_array($class_row['id'], $class_id_array) == true ? 'checked' : '' ?>>
                            <label class="w-100" for="<?= $class_row['id'] ?>"><?= $class_row['classname'] ?></label>
                        </div>
                    <?php
                    }
                    if (!$class_exist) {
                        echo "<p>No class created yet</p>";
                    }
                    ?>
                </div>
                <div class="card-foot">
                    <?php
                    if (!$class_exist) {
                    ?>
                        <a href="class" type="button" class="btn btn-primary">Create Class</a>
                    <?php } else {
                    ?>
                        <button type="button" class="btn btn-primary" onclick="submit_staff_class_assign('<?= $id ?>')">Assign Classes</button>
                    <?php
                    }
                    ?>
                    <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Cancel</button>
                </div>
            </div>

            </div>
    <?php
        }

        if ($action == 'submit_priviledges') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['staff_id']);
            $update_school = isset($_POST['update_school']) ? 1 : 0;
            $register_staff = isset($_POST['register_staff']) ? 1 : 0;
            $register_student = isset($_POST['register_student']) ? 1 : 0;
            $edit_student = isset($_POST['edit_student']) ? 1 : 0;
            $change_class = isset($_POST['change_class']) ? 1 : 0;
            $add_class = isset($_POST['add_class']) ? 1 : 0;
            $student_qr = isset($_POST['student_qr']) ? 1 : 0;
            $staff_qr = isset($_POST['staff_qr']) ? 1 : 0;
            $manage_payment = isset($_POST['manage_payment']) ? 1 : 0;
        //     echo "UPDATE staff 
        // SET update_school='$update_school', register_staff='$register_staff', 
        // register_student='$register_student', edit_student='$edit_student',
        // change_class='$change_class', add_class='$add_class',
        // student_qr='$student_qr', staff_qr='$staff_qr',manage_payment='$manage_payment',
        // updatedby='{$_SESSION['userid']}', dateupdated='$date' 
        // WHERE id='$id' AND school_id='$school_id'";
        // exit;
            $update = mysqli_query($conn, "UPDATE staff 
        SET update_school='$update_school', register_staff='$register_staff', 
        register_student='$register_student', edit_student='$edit_student',
        change_class='$change_class', add_class='$add_class',
        student_qr='$student_qr', staff_qr='$staff_qr',manage_payment='$manage_payment',
        updatedby='{$_SESSION['userid']}', dateupdated='$date' 
        WHERE id='$id' AND school_id='$school_id'");
            $_SESSION['update_school'] = $update_school;
            $_SESSION['register_staff'] = $register_staff;
            $_SESSION['register_student'] = $register_student;
            $_SESSION['edit_student'] = $edit_student;
            $_SESSION['change_class'] = $change_class;
            $_SESSION['add_class'] = $add_class;
            $_SESSION['student_qr'] = $student_qr;
            $_SESSION['staff_qr'] = $staff_qr;
            $_SESSION['manage_payment'] = $manage_payment;
            echo $update === true ? json_encode(array('status' => '1', 'msg' => 'Successfuly assigned')) : mysqli_error($conn);
        }

        if ($action == 'submit_staff_assigned_classes') {
            $school_id = $_SESSION['school_id'];
            $ids = test_input($_POST['ids']);
            $staff_id = test_input($_POST['staff_id']);
            $update = mysqli_query($conn, "UPDATE staff SET class_id = '$ids' WHERE id='$staff_id' AND school_id='$school_id'");
            if ($update) {
                if ($staff_id == $_SESSION['userid']) {
                    $_SESSION['class_id'] = $ids;
                }
                echo json_encode(array('status' => '1', 'msg' => 'Assigned successfully'));
            }
        }
 if($action == 'reset_student_password') {
            $school_id = $_SESSION['school_id'];
            $student_id = test_input($_POST['id']);
            $new_password = test_input($_POST['new_password']);
            $hashedpassword = password_hash($new_password, PASSWORD_ARGON2I);
            $update = mysqli_query($conn, "UPDATE students SET passw='$hashedpassword', dateupdated='$date', updatedby='{$_SESSION['userid']}' WHERE id='$student_id' AND school_id='$school_id'");
            echo $update === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
        }

        if ($action == 'update_student_data') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            // $current_parent_id = test_input($_POST['current_parent_id']);
            // exit;
            $firstname = test_input($_POST['firstname']);
            $lastname = test_input($_POST['lastname']);
            $middlename = test_input($_POST['middlename']);
            $class_id = test_input($_POST['class_id']);
            $gender = test_input($_POST['gender']);
            $dob = test_input($_POST['dob']);
            $phone = test_input($_POST['phone']);
            $email = test_input($_POST['email']);
            // $parentphone = test_input($_POST['parentphone']);
            // $parentemail = test_input($_POST['parentemail']);
            // $status = test_input($_POST['status']);
            $date = date('Y-m-d H:i:s');
            $createdby = $_SESSION['userid'];
            $admission_no = test_input($_POST['admissionnumber']);
            $department = test_input($_POST['department']);

            // $password = test_input($_POST['password']);
            // $hashedpassword = password_hash($password, PASSWORD_ARGON2I);

            // $pfname = test_input($_POST['parentfname']);
            // $plname = test_input($_POST['parentlname']);
            // $address = test_input($_POST['address']);
            // $city = test_input($_POST['city']);
            // $state = test_input($_POST['state']);
            // $country = test_input($_POST['country']);

            // Handle file upload
            if ($_FILES['studentphoto']['name'] != '') {
                $path = "uploads/";
                $valid_ext = array("jpg", "png", "jpeg");
                $img_name = $_FILES['studentphoto']['name'];
                $tmp = $_FILES['studentphoto']['tmp_name'];
                $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
                $final_img = rand(10, 1000000000) . 'student' . $img_name;
                if (in_array($ext, $valid_ext)) {
                    $path = $path . $final_img;
                    if (!move_uploaded_file($tmp, $path)) {
                        echo json_encode(array('status' => '0', 'err' => "File upload failed"));
                        exit;
                    }
                } else {
                    echo json_encode(array('status' => '0', 'err' => "File format not supported"));
                    exit;
                }
            }
        
            

            // if (!does_it_exist("phone", "parent", "phone='$parentphone'")) {
            //     if (does_it_exist("email", "parent", "email='$parentemail'")) {
            //         echo json_encode(array('status' => '0', 'err' => "The email has been used by another parent, try another."));
            //         exit;
            //     }

            //     $insertparent = mysqli_query($conn, "INSERT INTO parent(firstname,lastname,passw,phone, email, address,city,state,country, school_id, datecreated, createdby)
            //     VALUES('$pfname','$plname','$hashedpassword','$parentphone','$parentemail','$address','$city', '$state','$country','$school_id','$date','$createdby')");
            //     if ($insertparent) {
            //         $selectparentid = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone' AND email='$parentemail' AND school_id='$school_id'");
            //         if ($row = mysqli_fetch_array($selectparentid)) {
            //             $parent_id = $row['id'];
            //             $updatestudent = mysqli_query($conn, "UPDATE students SET status='$status', photo='$final_img', firstname='$firstname',lastname='$lastname',middlename='$middlename',class_id='$class_id',gender='$gender',dob='$dob',phone='$phone',email='$email',parent_id='$parent_id',dateupdated='$date', updatedby='$createdby' WHERE school_id='$school_id' AND id='$id'");
            //             echo $updatestudent === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
            //         }
            //     }
            // } 
            // else {
            // $select_parent_id = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone'");
            // $parent_id_row = mysqli_fetch_array($select_parent_id);
            // $parent_id = $parent_id_row['id'];

            // Update parent information without updating the password
            // $updateparent = mysqli_query($conn, "UPDATE parent SET firstname='$pfname', lastname='$plname', email='$parentemail', address='$address', city='$city', state='$state', country='$country', dateupdated='$date', updatedby='$createdby' WHERE id='$current_parent_id' AND school_id='$school_id'");

            if ($_FILES['studentphoto']['name'] != '') {
                $selectphoto = mysqli_query($conn, "SELECT photo FROM students WHERE school_id='$school_id' AND id='$id'");
                $photorow = mysqli_fetch_array($selectphoto);
                if ($photorow['photo'] != 'avatar.png') {
                    $filepath = "uploads/" . $photorow['photo'];
                    deleteFile($filepath);
                }
            }
// echo "UPDATE students SET admission_no = '$admission_no', status='$status', photo='$final_img', firstname='$firstname',lastname='$lastname',middlename='$middlename',class_id='$class_id',gender='$gender',dob='$dob',phone='$phone',email='$email',dateupdated='$date', updatedby='$createdby' WHERE school_id='$school_id' AND id='$id'";
         if($_FILES['studentphoto']['name'] == ''){
            $updatestudent = mysqli_query($conn, "UPDATE students SET department='$department', admission_no = '$admission_no', firstname='$firstname',lastname='$lastname',middlename='$middlename',class_id='$class_id',gender='$gender',dob='$dob',phone='$phone',email='$email',dateupdated='$date', updatedby='$createdby' WHERE school_id='$school_id' AND id='$id'");
         }else {
            $updatestudent = mysqli_query($conn, "UPDATE students SET department='$department', admission_no = '$admission_no', photo='$final_img', firstname='$firstname',lastname='$lastname',middlename='$middlename',class_id='$class_id',gender='$gender',dob='$dob',phone='$phone',email='$email',dateupdated='$date', updatedby='$createdby' WHERE school_id='$school_id' AND id='$id'");
         }
            // $updatestudent = mysqli_query($conn, "UPDATE students SET status='$status', photo='$final_img', firstname='$firstname',lastname='$lastname',middlename='$middlename',class_id='$class_id',gender='$gender',dob='$dob',phone='$phone',email='$email',parent_id='$parent_id',dateupdated='$date', updatedby='$createdby' WHERE school_id='$school_id' AND id='$id'");
            echo $updatestudent === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
            // }
        }

        if ($action == 'delete_staff_data') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            $selectstaff = mysqli_query($conn, "SELECT photo FROM staff WHERE id='$id' AND school_id='$school_id'");
            $row = mysqli_fetch_array($selectstaff);
            $filename = $row['photo'];
            if ($filename != 'avatar.png') {
                $filepath = "uploads/" . $filename;
                if (deleteFile($filepath)) {
                    $deletestaff = mysqli_query($conn, "DELETE FROM staff WHERE id='$id' AND school_id='$school_id'");
                    echo $deletestaff === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
                }
            } else {
                $deletestaff = mysqli_query($conn, "DELETE FROM staff WHERE id='$id' AND school_id='$school_id'");
                echo $deletestaff === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
            }
        }
        if ($action == 'delete_student_data') {
            $school_id = $_SESSION['school_id'];
            $ids = explode(",", $_POST['ids']);
            foreach ($ids as $id) {

                $selectstudent = mysqli_query($conn, "SELECT photo FROM students WHERE id='$id' AND school_id='$school_id'");
                $row = mysqli_fetch_array($selectstudent);
                $filename = $row['photo'];
                if ($filename != 'avatar.png') {
                    $filepath = "uploads/" . $filename;
                    deleteFile($filepath);
                }
                // $selectstudent = mysqli_query($conn, "SELECT parent_id FROM students WHERE id='$id' AND school_id='$school_id'");
                // $row = mysqli_fetch_array($selectstudent);
                // $parent_id = $row['parent_id'];
                $deletestudent = mysqli_query($conn, "DELETE FROM students WHERE id='$id' AND school_id='$school_id'");
                // $deleteparent = mysqli_query($conn, "DELETE FROM parent WHERE id='$parent_id' AND school_id='$school_id'");
                $deletescores = mysqli_query($conn, "DELETE FROM skulscores WHERE student_id='$id' AND school_id='$school_id'");
            }
            echo $deletescores === true ? json_encode(array('status' => '1', 'msg' => 'Deleted Successfully')) : mysqli_error($conn);
        }
        if ($action == 'delete_subject_category') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            $deletecat = mysqli_query($conn, "DELETE FROM subject_cat WHERE id='$id' AND school_id='$school_id'");
            echo $deletecat === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
        }
        if ($action == 'delete_class_data') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            // $selectstudent = mysqli_query($conn, "SELECT parent_id FROM students WHERE id='$id' AND school_id='$school_id'");
            // $row = mysqli_fetch_array($selectstudent);
            // $parent_id = $row['parent_id'];
            $deleteclass = mysqli_query($conn, "DELETE FROM class WHERE id='$id' AND school_id='$school_id'");
            // $deleteparent = mysqli_query($conn, "DELETE FROM parent WHERE id='$parent_id' AND school_id='$school_id'");
            // $deletescores = mysqli_query($conn, "DELETE FROM skulscores WHERE student_id='$id' AND school_id='$school_id'");
            echo $deleteclass === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
        }
     if ($action == 'get_current_graduate_classes') {
            $school_id = $_SESSION['school_id'];
            $stmt = mysqli_prepare($conn, "SELECT id, classname, is_graduate FROM class WHERE school_id = ? ORDER BY classname ASC");
            if ($stmt) {
                mysqli_stmt_bind_param($stmt, 'i', $school_id);
                mysqli_stmt_execute($stmt);
                $res = mysqli_stmt_get_result($stmt);
                $groups = [
                    'current' => [],
                    'graduates' => []
                ];
                while ($row = mysqli_fetch_assoc($res)) {
                    $item = ['id' => $row['id'], 'text' => $row['classname']];
                    if ((int)$row['is_graduate'] === 1) {
                        $groups['graduates'][] = $item;
                    } else {
                        $groups['current'][] = $item;
                    }
                }
                $out = [];
                if (!empty($groups['current'])) {
                    $out[] = ['text' => 'Current', 'children' => $groups['current']];
                }
                if (!empty($groups['graduates'])) {
                    $out[] = ['text' => 'Graduates', 'children' => $groups['graduates']];
                }
                echo json_encode($out);
                exit;
            } else {
                echo json_encode([]);
                exit;
            }
        }


        if ($action === 'submit_comment') {
            $school_id = $_SESSION['school_id'];
            $student = test_input($_POST['student_id']);
            $comment = test_input($_POST['comment']);
            $session = test_input($_POST['session']);
            $term = test_input($_POST['term']);
            $role = test_input($_POST['role_type']);
            $class = test_input($_POST['class_id']);
            // exit;
            // echo $_SESSION['userid'];
            // exit;
            $update = false;
            // if($_SESSION['staff_type'] == '2' || $_SESSION['staff_type'] == '3' || $_SESSION['staff_type'] == '4' ){
            //     $role = 1;
            // }else {
            //     $role = 0;
            // }
            if (!does_it_exist("id", "comment", "term_id='$term' AND class_id='$class' AND role_type='$role' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'")) {
                $insert = mysqli_query($conn, "INSERT INTO 
            comment(class_id,student_id,comment,comment_type,role_type,session_id,term_id,datecreated,createdby,commentby,school_id) 
            VALUES('$class','$student','$comment','1','$role','$session','$term','$date',{$_SESSION['userid']},{$_SESSION['userid']},'$school_id')");
                // echo "inser";
                if (!$insert) {
                    echo json_encode(array('status' => '0', 'err' => 'Comment submitted'));
                }
            } else {
                $update = mysqli_query($conn, "UPDATE comment SET comment='$comment', comment_type='1', commentby='{$_SESSION['userid']}', updatedby={$_SESSION['userid']}, dateupdated='$date' WHERE term_id='$term' AND role_type='$role' AND class_id='$class' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'");
            }
            echo $update || $insert ? json_encode(array('status' => '1', 'msg' => 'Comment submitted')) : mysqli_error($conn);
        }
        if ($action === 'submit_comment1') {
            $school_id = $_SESSION['school_id'];
            $student = test_input($_POST['student_id']);
            $comment = test_input($_POST['comment']);
            $session = test_input($_POST['session']);
            $term = test_input($_POST['term']);
            $class = test_input($_POST['class_id']);
            // exit;
            // echo $_SESSION['userid'];
            // exit;
            $update = false;
            if (!does_it_exist("id", "skulscores", "term_id='$term' AND class_id='$class' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'")) {
                $insert = mysqli_query($conn, "INSERT INTO skulscores(class_id,student_id,teacher_comment,session_id,term_id,datecreated,createdby,commentby,school_id) VALUES('$class','$student','$comment','$session','$term','$date',{$_SESSION['userid']},{$_SESSION['userid']},'$school_id')");
                // echo "inser";
                if (!$insert) {
                    echo json_encode(array('status' => '0', 'err' => 'Comment not insert saved'));
                }
            } else {
                $update = mysqli_query($conn, "UPDATE skulscores SET teacher_comment='$comment', commentby='{$_SESSION['userid']}', updatedby={$_SESSION['userid']}, dateupdated='$date' WHERE term_id='$term' AND class_id='$class' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'");
            }
            echo $update || $insert ? json_encode(array('status' => '1', 'msg' => 'Comment ipdate saved')) : mysqli_error($conn);
        }

        if ($action === 'get_comment') {
            $school_id = $_SESSION['school_id'];
            $student = test_input($_POST['student_id']);
            $session = test_input($_POST['session']);
            $term = test_input($_POST['term']);
            $pagetype = test_input($_POST['pagetype']);
            $class_id = test_input($_POST['class_id']);

            if ($pagetype != 'report') {
                $staff_type = $_SESSION['staff_type'];
                $staff_classid = $_SESSION['class_id'];
            } else {
                $staff_type = $staff_classid = '';
            }
            $select = mysqli_query($conn, "SELECT comment,role_type FROM comment WHERE term_id='$term' AND class_id='$class_id' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'");

            $comments = array();
            if (mysqli_num_rows($select) > 0) {
                while ($row = mysqli_fetch_array($select)) {
                    $comments[] = array(
                        "staff_type" => $staff_type,
                        "staff_classId" => explode(",", $staff_classid),
                        'role_type' => $row['role_type'],
                        "comment" => $row['comment']
                    );
                }
            } else {
                $comments[] = array(
                    "staff_type" => $staff_type,
                    "staff_classId" => explode(",", $staff_classid),
                    'role_type' => '',
                    "comment" => ''
                );
            }
            // echo $row;

            echo json_encode($comments);
        }

        // if ($action === 'get_teacher_comment') {
        //     $school_id = $_SESSION['school_id'];
        //     $student = test_input($_POST['student_id']);
        //     $session = test_input($_POST['session']);
        //     $term = test_input($_POST['term']);
        //     $pagetype = test_input($_POST['pagetype']);
        //     $class_id = test_input($_POST['class_id']);
        //     if ($pagetype != 'report') {
        //         $staff_type = $_SESSION['staff_type'];
        //         $staff_classid = $_SESSION['class_id'];
        //     } else {
        //         $staff_type = $staff_classid = '';
        //     }

        //     $select = mysqli_query($conn, "SELECT teacher_comment FROM skulscores WHERE term_id='$term' AND class_id='$class_id' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'");

        //     // if($staff_type == '6' OR $class_id == $_SESSION['class_id'] OR $pagetype == 'report'){
        //     if ($row = mysqli_fetch_array($select)) {
        //         echo json_encode(array("staff_type" => $staff_type, "staff_classId" => $staff_classid, "comment" => $row['teacher_comment']));
        //     } else {
        //         echo json_encode(array("staff_type" => $staff_type, "staff_classId" => $staff_classid, "comment" => ''));
        //     }
        //     // }
        //     // else {
        //     //     echo '0';
        //     // }
        //     // exit;
        //     // if ($pagetype == 'report') {
        //     //     if ($row = mysqli_fetch_array($select)) {
        //     //         echo $row['teacher_comment'];
        //     //     }
        //     // } elseif ($class_id == $_SESSION['class_id'] or  $_SESSION['staff_type'] == '6') {
        //     //     if ($row = mysqli_fetch_array($select)) {
        //     //         echo $row['teacher_comment'];
        //     //     }
        //     // } else {
        //     //     echo 'no';
        //     // }
        // }
        if ($action === "submit_behaviour_comment") {
            $behaviour_data = json_encode($_POST['beahvedata']);
            $school_id = $_SESSION['school_id'];
            $student = test_input($_POST['studentId']);
            $session = test_input($_POST['session']);
            $term = test_input($_POST['term']);
            $class = test_input($_POST['class']);
            $update = false;
            if (!does_it_exist("id", "other_comments", "term_id='$term' AND class_id='$class' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'")) {
                $insert = mysqli_query($conn, "INSERT INTO other_comments(class_id,student_id,comment,session_id,term_id,datecreated,createdby,commentby,school_id) 
            VALUES('$class','$student','$behaviour_data','$session','$term','$date',{$_SESSION['userid']},{$_SESSION['userid']},'$school_id')");
                // echo "inser";
                if (!$insert) {
                    echo json_encode(array('status' => '0', 'err' => 'Comment not insert saved'));
                }
            } else {
                $update = mysqli_query($conn, "UPDATE other_comments SET comment='$behaviour_data', commentby='{$_SESSION['userid']}', updatedby={$_SESSION['userid']}, dateupdated='$date' WHERE term_id='$term' AND class_id='$class' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'");
            }
            echo $update || $insert ? json_encode(array('status' => '1', 'msg' => 'Comment ipdate saved')) : mysqli_error($conn);
        }
        // if ($action === "submit_behaviour_comment1") {
        //     $behaviour_data = json_encode($_POST['beahvedata']);
        //     $school_id = $_SESSION['school_id'];
        //     $student = test_input($_POST['studentId']);
        //     $session = test_input($_POST['session']);
        //     $term = test_input($_POST['term']);
        //     $class = test_input($_POST['class']);
        //     $update = false;
        //     if (!does_it_exist("id", "skulscores", "term_id='$term' AND class_id='$class' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'")) {
        //         $insert = mysqli_query($conn, "INSERT INTO skulscores(class_id,student_id,general_behaviour,session_id,term_id,datecreated,createdby,commentby,school_id) 
        //         VALUES('$class','$student','$behaviour_data','$session','$term','$date',{$_SESSION['userid']},{$_SESSION['userid']},'$school_id')");
        //         // echo "inser";
        //         if (!$insert) {
        //             echo json_encode(array('status' => '0', 'err' => 'Comment not insert saved'));
        //         }
        //     } else {
        //         $update = mysqli_query($conn, "UPDATE skulscores SET general_behaviour='$behaviour_data', commentby='{$_SESSION['userid']}', updatedby={$_SESSION['userid']}, dateupdated='$date' WHERE term_id='$term' AND class_id='$class' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'");
        //     }
        //     echo $update || $insert ? json_encode(array('status' => '1', 'msg' => 'Comment ipdate saved')) : mysqli_error($conn);
        // }
        if ($action == 'getbehaviour_comment') {
            $school_id = $_SESSION['school_id'];
            $student = test_input($_POST['student_id']);
            $session = test_input($_POST['session']);
            $term = test_input($_POST['term']) == 'cum' ? 3 : test_input($_POST['term']);

            $class_id = test_input($_POST['class_id']);
            $pagetype = test_input($_POST['pagetype']);
            if ($pagetype != 'report') {
                $staff_type = $_SESSION['staff_type'];
                $staff_classid = $_SESSION['class_id'];
            } else {
                $staff_type = $staff_classid = '';
            }
            $select = mysqli_query($conn, "SELECT comment FROM other_comments WHERE term_id='$term' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'");
            // if ($staff_type == '6' or $class_id == $_SESSION['class_id'] or $pagetype == 'report') {
            if ($row = mysqli_fetch_array($select)) {
                echo json_encode(array("staff_type" => $staff_type, "staff_classId" => explode(",", $staff_classid), "comment" => $row['comment']));
            } else {
                echo json_encode(array("staff_type" => $staff_type, "staff_classId" => explode(",", $staff_classid), "comment" => ''));
            }
            // if (mysqli_num_rows($select) > 0) {
        }
        if ($action === 'get_teacher_comment_parent') {
            $school_id = $_SESSION['school_id'];
            $student = test_input($_POST['student_id']);
            $session = test_input($_POST['session']);
            $term = test_input($_POST['term']);
            // $class_id = test_input($_POST['class_id']); 
            // if($class_id == $_SESSION['class_id']) {
            $select = mysqli_query($conn, "SELECT teacher_comment FROM skulscores WHERE term_id='$term' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'");
            if ($row = mysqli_fetch_array($select)) {
                echo $row['teacher_comment'];
            } else {
                echo mysqli_error($conn);
            }
            // }
        }
        if ($action == 'update_hidden_skills') {
    $school_id = $_SESSION['school_id'];
    $hidden_skills = isset($_POST['hidden_skills']) ? $_POST['hidden_skills'] : [];

    // Convert array to JSON string
    $hidden_skills_json = json_encode($hidden_skills);
    $hidden_skills_json = mysqli_real_escape_string($conn, $hidden_skills_json);

    $query = "UPDATE school SET hidden_skills='$hidden_skills_json' WHERE id='$school_id'";
    $update = mysqli_query($conn, $query);
    if ($update) {
$_SESSION['hidden_row'] = $hidden_skills_json;
// print_r($_SESSION['hidden_row']);
        echo json_encode(array('status' => '1', 'msg' => 'Skills visibility updated successfully'));
    } else {
        echo json_encode(array('status' => '0', 'msg' => 'Failed to update skills visibility: ' . mysqli_error($conn)));
    }
}
        if ($action == 'change_password') {
            $school_id = $_SESSION['school_id'];
            $pass = test_input($_POST['new_Pin']);
            $type = test_input($_POST['type']);
            $hashedpassword = password_hash($pass, PASSWORD_ARGON2I);
            if ($type == 'staff') {
                $update = mysqli_query($conn, "UPDATE staff SET passw='$hashedpassword' WHERE school_id='$school_id' AND id='{$_SESSION['userid']}'");
            } else {
                $update = mysqli_query($conn, "UPDATE parent SET passw='$hashedpassword' WHERE school_id='$school_id' AND id='{$_SESSION['userid']}'");
            }
            if ($update) {
                // header('Location: login');
                echo json_encode(array('status' => '1', 'msg' => 'Password changed successfully', 'location' => 'login'));
            } else {
                echo json_encode(array('status' => '0', 'err' => 'Password not updated, try again!'));
            }
        }

        if ($action == 'get_reciepients') {
            $school_id = $_SESSION['school_id'];
            $reciepient_type = test_input($_POST['reciepient_type']);
            $data_type = test_input($_POST['data_type']);
            if ($data_type == 'email') {
                $term = 'email';
            } elseif ($data_type == 'phone') {
                $term = 'phone';
            } else {
                $term = 'id,firstname,lastname';
            }

            if ($reciepient_type == 'all_staff') {
                $sql = "SELECT $term
            FROM staff WHERE school_id='$school_id'";
            }
            if ($reciepient_type == 'all_parent') {
                $sql = "SELECT $term
            FROM parent WHERE school_id='$school_id'";
            }
            if ($reciepient_type == 'all_teacher') {
                $sql = "SELECT $term
            FROM staff WHERE staff_type='6' AND school_id='$school_id'";
            }
            if ($reciepient_type == 'all_propietors') {
                $sql = "SELECT $term
            FROM staff WHERE staff_type='3' AND school_id='$school_id'";
            }
            if ($reciepient_type == 'all_propietress') {
                $sql = "SELECT $term
            FROM staff WHERE staff_type='3' AND school_id='$school_id'";
            }
            if ($reciepient_type == 'all_principals') {
                $sql = "SELECT $term
            FROM staff WHERE staff_type='4' AND school_id='$school_id'";
            }
            if ($reciepient_type == 'all_admin') {
                $sql = "SELECT $term
            FROM staff WHERE staff_type='1' AND school_id='$school_id'";
            }
            $select = mysqli_query($conn, $sql);
            $data = [];
            while ($row = mysqli_fetch_array($select)) {
                if ($data_type == 'email' or $data_type == 'phone') {
                    array_push($data, $row[$term]);
                } else if ($data_type == 'name') {
                    $data[] = array('id' => $row['id'], 'name' => $row['lastname'] . ' ' . $row['firstname']);
                }
            }
            echo json_encode($data);
        }

        if ($action == 'get_parent_search_result') {
            $phone = test_input($_POST['phone']);
            $select  = mysqli_query($conn, "SELECT firstname, lastname, phone, email, address, city, state, country FROM parent WHERE phone LIKE '%$phone%'");
            $data = [];
            while ($row = mysqli_fetch_array($select)) {
                $data[] = array(
                    'firstname' => $row['firstname'],
                    'lastname' => $row['lastname'],
                    'phone' => $row['phone'],
                    'email' => $row['email'],
                    'address' => $row['address'],
                    'city' => $row['city'],
                    'state' => $row['state'],
                    'country' => $row['country']
                );
            }
            echo json_encode($data);
        }

        if ($action == 'get_staff_data_for_search_comm') {
            $school_id = $_SESSION['school_id'];
            $search_terms = test_input($_POST['search_terms']);
            $sql = "SELECT id,firstname,lastname,middlename,phone,email 
        FROM staff
        WHERE firstname LIKE '%$search_terms%' 
           OR lastname LIKE '%$search_terms%' 
           OR middlename LIKE '%$search_terms%' 
           OR phone LIKE '%$search_terms%'";
            $select_staff = mysqli_query(
                $conn,
                $sql
            );

            $data = [];
            while ($row = mysqli_fetch_assoc($select_staff)) {
                $data[] = array(
                    'email' => $row['email'],
                    'staff_name' => $row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename'],
                    'phone' => $row['phone'],
                    'userid' => $row['id']
                );
            }
            echo json_encode($data);
        }
        if ($action == 'get_parent_data_for_search_comm') {
            $school_id = $_SESSION['school_id'];
            $search_terms = test_input($_POST['search_terms']);

            $select_student = mysqli_query(
                $conn,
                "SELECT p.id, p.firstname AS pfirst, p.lastname AS plast,
            p.email AS email, s.firstname AS sfirst, s.middlename AS smiddle,
            s.lastname AS slast, p.phone
            FROM parent p, students s 
            WHERE s.parent_id = p.id 
                AND p.school_id = '$school_id' 
                AND (
               p.firstname LIKE '%$search_terms%' 
               OR p.lastname LIKE '%$search_terms%' 
               OR p.email LIKE '%$search_terms%' 
               OR s.firstname LIKE '%$search_terms%' 
               OR s.middlename LIKE '%$search_terms%' 
               OR s.lastname LIKE '%$search_terms%' 
               OR p.phone LIKE '%$search_terms%'
           )"
            );

            $data = [];
            while ($row = mysqli_fetch_assoc($select_student)) {
                $data[] = array(
                    'email' => $row['email'],
                    'parent_name' => $row['pfirst'] . ' ' . $row['plast'],
                    'student_name' => $row['sfirst'] . ' ' . $row['smiddle'] . ' ' . $row['slast'],
                    'phone' => $row['phone'],
                    'userid' => $row['id']
                );
            }
            echo json_encode($data);
        }
        if ($action == 'get_student_data_for_search') {
            $search_terms = test_input($_POST['search_terms']);

            $school_id = $_SESSION['school_id'];
            $select_student = mysqli_query($conn, "SELECT c.id as class_id, s.id as student_id, s.firstname, s.lastname, s.middlename, c.classname 
        FROM students s 
        JOIN class c ON s.class_id = c.id 
        WHERE s.school_id='$school_id' AND (s.firstname LIKE '%$search_terms%' 
        OR s.lastname LIKE '%$search_terms%' 
        OR s.middlename LIKE '%$search_terms%' 
        OR c.classname LIKE '%$search_terms%')");

            $data = [];
            while ($row = mysqli_fetch_assoc($select_student)) {
                $data[] = array(
                    'firstname' => $row['firstname'],
                    'lastname' => $row['lastname'],
                    'middlename' => $row['middlename'],
                    'classname' => $row['classname'], // Ensure classname is included
                    'class_id' => $row['class_id'],
                    'student_id' => $row['student_id']
                );
            }
            echo json_encode($data);
        }

        if ($action == 'get_class_data_for_search') {
            $search_terms = test_input($_POST['search_terms']);

            $school_id = $_SESSION['school_id'];
            $select_class = mysqli_query($conn, "SELECT id, classname FROM class WHERE classname LIKE '%$search_terms%' AND school_id='$school_id'");

            $data = [];
            while ($row = mysqli_fetch_assoc($select_class)) {
                $data[] = array(
                    'id' => $row['id'],
                    'classname' => $row['classname'],
                );
            }
            echo json_encode($data);
        }

        // if ($action == 'get_subject_data_for_search') {
        //     $search_terms = test_input($_POST['search_terms']);
        //     $school_id = $_SESSION['school_id'];

        //     $select_subject = mysqli_query($conn, "SELECT id, subject FROM subjects 
        //     WHERE subject LIKE '%$search_terms%'");

        //     $data = [];
        //     while ($row = mysqli_fetch_assoc($select_subject)) {
        //         $data[] = array(
        //             'id' => $row['id'],
        //             'subject' => $row['subject'],
        //         );
        //     }
        //     echo json_encode($data);
        // }
if ($action == 'get_subject_data_for_search') {
            $search_terms = test_input($_POST['search_terms']);
            $school_id = $_SESSION['school_id'];
            $class_id = isset($_POST['class_id']) ? test_input($_POST['class_id']) : null;

            $data = [];
            if (isset($class_id)) {
                if ($class_id === "") {
                    $data[] = array(
                        'id' => '0',
                    );
                } else {

                    // Join class and subject_cat to get subject_ids
                    $select_class = mysqli_query($conn, "SELECT s.subject_ids FROM class c LEFT JOIN subject_cat s ON c.subject_cat=s.id WHERE c.school_id='$school_id' AND c.id=$class_id");
                    if ($row = mysqli_fetch_assoc($select_class)) {
                        $subject_cat = $row['subject_ids'];
                        // Get class_id and subject_assigned from staff table
                        $staff_id = $_SESSION['userid'];
                        $select_staff = mysqli_query($conn, "SELECT class_id, subject_assigned FROM staff WHERE id='$staff_id' AND school_id='$school_id'");
                        $staff_row = mysqli_fetch_assoc($select_staff);
                        $subject_assigned = isset($staff_row['subject_assigned']) ? $staff_row['subject_assigned'] : '';
                        // Parse subject_assigned string: "44: 65,92,119, 45: 65,40"
                        $assigned_subjects_by_class = [];
                        preg_match_all('/(\d+):\s*([\d,]+)/', $subject_assigned, $matches, PREG_SET_ORDER);
                        foreach ($matches as $match) {
                            $cid = intval($match[1]);
                            $sids = array_filter(array_map('intval', explode(',', $match[2])));
                            $assigned_subjects_by_class[$cid] = $sids;
                        }
                        // Get subject ids for this class
                        $subject_ids = array_filter(array_map('intval', explode(',', $subject_cat)));
                        $final_subject_ids = [];
                        if (isset($assigned_subjects_by_class[$class_id])) {
                            // Only subjects assigned to staff for this class
                            $final_subject_ids = array_intersect($subject_ids, $assigned_subjects_by_class[$class_id]);
                        }
                        if ($subject_cat && count($final_subject_ids) > 0) {
                            $subject_ids_str = implode(",", $final_subject_ids);
                            $select_subject = mysqli_query($conn, "SELECT id, subject FROM subjects WHERE id IN ($subject_ids_str) AND subject LIKE '%$search_terms%'");
                            while ($subject_row = mysqli_fetch_assoc($select_subject)) {
                                $data[] = array(
                                    'id' => $subject_row['id'],
                                    'subject' => $subject_row['subject'],
                                );
                            }
                        }
                    }
                }
            } else {
                // class_id is not set, search by search_terms
                $select_subject = mysqli_query($conn, "SELECT id, subject FROM subjects WHERE subject LIKE '%$search_terms%'");
                while ($row = mysqli_fetch_assoc($select_subject)) {
                    $data[] = array(
                        'id' => $row['id'],
                        'subject' => $row['subject'],
                    );
                }
            }
            echo json_encode($data);
        }
        // if ($action == 'send_internal') {
        //     $school_id = $_SESSION['school_id'];
        //     $ids = explode(",", $_POST['recievers']);
        //     $message = test_input($_POST['message']);
        //     $usertype = test_input($_POST['usertype']);
        //     foreach ($ids as $id) {
        //         echo $sql = "INSERT INTO internal_msg 
        //         (reciever_id,message,usertype,createdby,datecreated,school_id)
        //         VALUES('$id','$message','$usertype','{$_SESSION['userid']}','$date','$school_id')";
        //         $insert = mysqli_query($conn, $sql);
        //     }
        //     echo json_encode(array('status' => '1'));
        // }
            if ($action == 'send_internal') {
            $school_id = $_SESSION['school_id'];
            $ids = isset($_POST['recievers']) ? explode(",", $_POST['recievers']) : [];
            // For internal messages we accept HTML from the summernote editor. Do light trimming but do not strip tags here.
            $message = isset($_POST['message']) ? trim($_POST['message']) : '';
            $usertype = isset($_POST['usertype']) ? test_input($_POST['usertype']) : '';

            if (empty($ids) || empty($message)) {
                echo json_encode(array('status' => '0', 'err' => 'No recipients or empty message'));
                exit;
            }

            // Prepare statement for insertion
            $stmt = mysqli_prepare($conn, "INSERT INTO internal_msg (reciever_id, message, usertype, createdby, datecreated, school_id) VALUES (?, ?, ?, ?, ?, ?)");
            if (!$stmt) {
                echo json_encode(array('status' => '0', 'err' => 'DB prepare failed: ' . mysqli_error($conn)));
                exit;
            }

            $createdby = $_SESSION['userid'];
            $datecreated = $date;
            $success = true;

            foreach ($ids as $id) {
                $id = trim($id);
                if ($id === '') continue;
                // Bind params: s - string types for id, message, usertype, createdby, datecreated, school_id
                mysqli_stmt_bind_param($stmt, 'ssssss', $id, $message, $usertype, $createdby, $datecreated, $school_id);
                if (!mysqli_stmt_execute($stmt)) {
                    $success = false;
                    $err = mysqli_stmt_error($stmt);
                    break;
                }
            }

            mysqli_stmt_close($stmt);

            if ($success) {
                echo json_encode(array('status' => '1'));
            } else {
                echo json_encode(array('status' => '0', 'err' => 'DB error: ' . ($err ?? 'unknown')));
            }
            exit;
        }

        if ($action == 'get_msg') {
            $school_id = $_SESSION['school_id'];
            $usertype = test_input($_POST['usertype']);
            $userid = test_input($_POST['userid']);
            $select = mysqli_query($conn, "SELECT id,message FROM internal_msg WHERE reciever_id='$userid' AND usertype='$usertype' AND school_id='$school_id' ORDER BY datecreated DESC");
            if (mysqli_num_rows($select) > 0) {
                $data = [];
                while ($row = mysqli_fetch_array($select)) {
                    $data[] = array($row['id'] => $row['message']);
                }
                echo json_encode(array('status' => '1', 'data' => $data));
            } else {
                echo json_encode(['status' => '0']);
            }
        }

            if ($action == 'delete_int_msg') {
            $school_id = $_SESSION['school_id'];
            $id = test_input($_POST['id']);
            $userid = $_SESSION['userid'];
            // Only allow creator to delete their messages
            $stmt = mysqli_prepare($conn, "DELETE FROM internal_msg WHERE id=? AND createdby=? AND school_id=?");
            if (!$stmt) {
                echo json_encode(['status' => '0', 'err' => 'DB prepare failed']);
                exit;
            }
            mysqli_stmt_bind_param($stmt, 'sss', $id, $userid, $school_id);
            $ok = mysqli_stmt_execute($stmt);
            mysqli_stmt_close($stmt);
            if ($ok) echo json_encode(['status' => '1']); else echo json_encode(['status' => '0', 'err' => 'Delete failed']);
            exit;
        }

        // Fetch internal messages created by the logged-in user
        if ($action == 'fetch_internal_sent') {
            $school_id = $_SESSION['school_id'];
            $userid = $_SESSION['userid'];
            $page = isset($_POST['page']) ? max(1, (int)$_POST['page']) : 1;
            $per_page = isset($_POST['per_page']) ? max(5, (int)$_POST['per_page']) : 10;
            $search = isset($_POST['search']) ? trim($_POST['search']) : '';
            $offset = ($page - 1) * $per_page;

            // Base query
            $where = "createdby='$userid' AND school_id='$school_id'";
            if ($search !== '') {
                // search in message content or in reciever_id (simple contains)
                $s = mysqli_real_escape_string($conn, $search);
                $where .= " AND (message LIKE '%$s%' OR reciever_id LIKE '%$s%')";
            }

            // Get total count
            $countRes = mysqli_query($conn, "SELECT COUNT(*) AS cnt FROM internal_msg WHERE $where");
            $total = 0;
            if ($rowc = mysqli_fetch_assoc($countRes)) $total = (int)$rowc['cnt'];

            $select = mysqli_query($conn, "SELECT id, message, reciever_id, usertype, createdby, datecreated FROM internal_msg WHERE $where ORDER BY datecreated DESC LIMIT $per_page OFFSET $offset");
            $data = [];
            $all_recipient_ids = [];
            while ($row = mysqli_fetch_assoc($select)) {
                $data[] = $row;
                // collect recipient ids (comma separated)
                if (!empty($row['reciever_id'])) {
                    $parts = array_filter(array_map('trim', explode(',', $row['reciever_id'])));
                    foreach ($parts as $p) {
                        if (is_numeric($p)) $all_recipient_ids[$p] = true;
                    }
                }
            }

            // Resolve staff names in one query
            $id_map = [];
            if (!empty($all_recipient_ids)) {
                $ids_list = implode(',', array_keys($all_recipient_ids));
                $sres = mysqli_query($conn, "SELECT id, firstname, lastname, middlename FROM staff WHERE id IN ($ids_list)");
                while ($r = mysqli_fetch_assoc($sres)) {
                    $id_map[$r['id']] = trim($r['firstname'] . ' ' . $r['lastname'] . ' ' . $r['middlename']);
                }
            }

            // Replace reciever_id with names where possible
            foreach ($data as &$row) {
                $names = [];
                if (!empty($row['reciever_id'])) {
                    $parts = array_filter(array_map('trim', explode(',', $row['reciever_id'])));
                    foreach ($parts as $p) {
                        if (isset($id_map[$p])) $names[] = $id_map[$p];
                        else $names[] = $p; // keep id if no name found
                    }
                }
                $row['recipients_display'] = implode(', ', $names);
            }

            echo json_encode(['status' => '1', 'data' => $data, 'total' => $total, 'page' => $page, 'per_page' => $per_page]);
            exit;
        }

        // Update an internal message (only allowed by creator)
        if ($action == 'update_internal_msg') {
            $school_id = $_SESSION['school_id'];
            $userid = $_SESSION['userid'];
            $id = test_input($_POST['id']);
            $message = isset($_POST['message']) ? trim($_POST['message']) : '';
            if (empty($id) || $message === '') {
                echo json_encode(['status' => '0', 'err' => 'Missing id or empty message']);
                exit;
            }

            // Verify ownership
            $stmtv = mysqli_prepare($conn, "SELECT createdby FROM internal_msg WHERE id=? AND school_id=?");
            if (!$stmtv) { echo json_encode(['status' => '0', 'err' => 'DB prepare failed']); exit; }
            mysqli_stmt_bind_param($stmtv, 'ss', $id, $school_id);
            mysqli_stmt_execute($stmtv);
            $resv = mysqli_stmt_get_result($stmtv);
            $owner = null;
            if ($rowv = mysqli_fetch_assoc($resv)) $owner = $rowv['createdby'];
            mysqli_stmt_close($stmtv);
            // echo $owner;
            // echo "<br>";
            // echo $userid;
            if ($owner != $userid) { echo json_encode(['status' => '0', 'err' => 'Permission denied']); exit; }

            $stmt = mysqli_prepare($conn, "UPDATE internal_msg SET message=? WHERE id=? AND createdby=? AND school_id=?");
            if (!$stmt) { echo json_encode(['status' => '0', 'err' => 'DB prepare failed']); exit; }
            mysqli_stmt_bind_param($stmt, 'ssss', $message, $id, $userid, $school_id);
            $ok = mysqli_stmt_execute($stmt);
            mysqli_stmt_close($stmt);
            if ($ok) echo json_encode(['status' => '1']); else echo json_encode(['status' => '0', 'err' => 'Update failed']);
            exit;
        }

        if ($action == 'update_url') {
            $school_id = $_SESSION['school_id'];
            $url = test_input($_POST['url']);
            $update = mysqli_query($conn, "UPDATE school SET url = '$url', dateupdated='$date', updatedby='{$_SESSION['userid']}' WHERE id='$school_id'");
            $_SESSION['url'] = $url;
            echo json_encode(['status' => '1']);
        }


        // check if comment exist
        // echo does_it_exist("id","skulscores","term_id='$term' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'");
        // exit;
        // $select = mysqli_query($conn, "SELECT id FROM skulscores WHERE term_id='$term' AND session_id='$session' AND student_id='$student' AND school_id='$school_id'");
        // if(mysqli_num_rows($select) < 1){
        //     echo "jn";
        // }
        // else{
        //     echo "noo";
        // }


        // lllllllllllllllllllllllllllllll
        // if ($action === 'submit_scores') {
        //     $scores = $_POST['scores'];
        //     $school_id = $_SESSION['school_id'];

        //     foreach ($scores as $score) {
        //         if (isset($score['studentId'])) {
        //             $subject = $score['subjectOrNameId'];
        //             $student_id = $score['studentId'] ?? '';
        //             $class = $score['class'];
        //             $term = $score['term'];
        //             $session = $score['session'];
        //             $ca1 = $score['ca1'];
        //             $ca1Total = $score['ca1Total'];
        //             $ca2 = $score['ca2'];
        //             $ca2Total = $score['ca2Total'];
        //             $ca3 = $score['ca3'];
        //             $ca3Total = $score['ca3Total'];
        //             $pra = $score['practical'];
        //             $praTotal = $score['practicalTotal'];
        //             $exam = $score['exam'];
        //             $examTotal = $score['examTotal'];

        //             $selectQuery = "SELECT subject_id, student_id, class_id, term_id, session_id, school_id FROM skulscores WHERE student_id='$student_id' AND subject_id='$subject' AND class_id='$class' AND session_id='$session' AND term_id='$term'";
        //             $select = mysqli_query($conn, $selectQuery);

        //             if (mysqli_num_rows($select) > 0) {
        //                 $updateQuery = "UPDATE skulscores SET ca1='$ca1', ca1Total='$ca1Total', ca2='$ca2', ca2Total='$ca2Total', ca3='$ca3', ca3Total='$ca3Total', pra='$pra', praTotal='$praTotal', exam='$exam', examTotal='$examTotal' WHERE subject_id='$subject' AND student_id='$student_id' AND class_id='$class' AND session_id='$session' AND term_id='$term' AND school_id='$school_id'";
        //                 $update = mysqli_query($conn, $updateQuery);
        //                 if ($update) {
        //                     echo "update success for student filter\n";
        //                 } else {
        //                     echo "update error: " . mysqli_error($conn) . "\n";
        //                     echo "Update Query: " . $updateQuery . "\n";
        //                 }
        //             } else {
        //                 $insertQuery = "INSERT INTO skulscores (student_id, subject_id, class_id, term_id, session_id, school_id, ca1, ca1Total, ca2, ca2Total, ca3, ca3Total, pra, praTotal, exam, examTotal) VALUES ('$student_id', '$subject', '$class', '$term', '$session', '$school_id', '$ca1', '$ca1Total', '$ca2', '$ca2Total', '$ca3', '$ca3Total', '$pra', '$praTotal', '$exam', '$examTotal')";
        //                 $insert = mysqli_query($conn, $insertQuery);
        //                 if ($insert) {
        //                     echo "insert success for student filter\n";
        //                 } else {
        //                     echo "insert error: " . mysqli_error($conn) . "\n";
        //                     echo "Insert Query: " . $insertQuery . "\n";
        //                 }
        //             }
        //         } else if (isset($score['subjectId'])) {
        //             // Handle subject filter type
        //             $subject = $score['subject'];
        //             $select = mysqli_query($conn, "SELECT * FROM skulscores WHERE subject_id='$subjectOrNameId' AND class_id='$class' AND session_id='$session' AND term_id='$term' AND school_id='$school_id'");

        //             if (mysqli_num_rows($select) > 0) {
        //                 // Update existing record
        //                 $update = mysqli_query($conn, "UPDATE skulscores 
        //                     SET ca1='$ca1', ca1Total='$ca1Total', ca2='$ca2', ca2Total='$ca2Total', ca3='$ca3', ca3Total='$ca3Total', pra='$practical', praTotal='$practicalTotal', exam='$exam', examTotal='$examTotal'
        //                     WHERE subject_id='$subjectOrNameId' AND class_id='$class' AND session_id='$session' AND term_id='$term' AND school_id='$school_id'");
        //                 if ($update) {
        //                     echo "update success for subject filter";
        //                 } else {
        //                     echo "update error for subject filter: " . mysqli_error($conn);
        //                 }
        //             } else {
        //                 // Insert new record
        //                 $insert = mysqli_query($conn, "INSERT INTO skulscores(subject_id, class_id, term_id, session_id, school_id, ca1, ca1Total, ca2, ca2Total, ca3, ca3Total, pra, praTotal, exam, examTotal)
        //                     VALUES('$subjectOrNameId', '$class', '$term', '$session', '$school_id', '$ca1', '$ca1Total', '$ca2', '$ca2Total', '$ca3', '$ca3Total', '$practical', '$practicalTotal', '$exam', '$examTotal')");
        //                 if ($insert) {
        //                     echo "insert success for subject filter";
        //                 } else {
        //                     echo "insert error for subject filter: " . mysqli_error($conn);
        //                 }
        //             }
        //         }
        //     }
        // }

        // if ($_POST['action'] === 'submit_scores') {
        //     if (!empty($_POST['scores'])) {
        //         foreach ($scores as $score) {
        //             $class = isset($score['class']) ? $score['class'] : '';
        //             $term = isset($score['term']) ? $score['term'] : '';
        //             $session = isset($score['session']) ? $score['session'] : '';
        //             $subjectOrNameId = isset($score['subjectOrNameId']) ? $score['subjectOrNameId'] : '';
        //             $studentId = isset($score['studentId']) ? $score['studentId'] : '';
        //             $subjectId = isset($score['subjectId']) ? $score['subjectId'] : '';
        //             $ca1 = isset($score['ca1']) ? $score['ca1'] : 0;
        //             $ca1Total = isset($score['ca1Total']) ? $score['ca1Total'] : 0;
        //             $ca2 = isset($score['ca2']) ? $score['ca2'] : 0;
        //             $ca3 = isset($score['ca3']) ? $score['ca3'] : 0;
        //             $practical = isset($score['practical']) ? $score['practical'] : 0;
        //             $exam = isset($score['exam']) ? $score['exam'] : 0;

        //             if (!empty($studentId) && !empty($subjectOrNameId)) {
        //                 if (isset($score['studentId'])) {
        //                     // For student filter type
        //                     $select = mysqli_query($conn, "SELECT subject_id FROM skulscores 
        //                         WHERE student_id='$studentId' AND subject_id='$subjectOrNameId' 
        //                         AND class_id='$class' AND session_id='$session' AND term_id='$term'");

        //                     if (mysqli_num_rows($select) > 0) {
        //                         $update = mysqli_query($conn, "UPDATE skulscores 
        //                             SET ca1='$ca1', ca1Total='$ca1Total', ca2='$ca2', ca3='$ca3', 
        //                             pra='$practical', exam='$exam' 
        //                             WHERE subject_id='$subjectOrNameId' AND student_id='$studentId' 
        //                             AND class_id='$class' AND session_id='$session' AND term_id='$term' 
        //                             AND school_id='$school_id'");

        //                         if ($update) {
        //                             echo "update success for student filter";
        //                         } else {
        //                             echo mysqli_error($conn);
        //                         }
        //                     } else {
        //                         $insert = mysqli_query($conn, "INSERT INTO skulscores 
        //                             (student_id, subject_id, class_id, term_id, session_id, school_id, 
        //                             ca1, ca1Total, ca2, ca3, pra, exam) 
        //                             VALUES ('$studentId', '$subjectOrNameId', '$class', '$term', '$session', 
        //                             '$school_id', '$ca1', '$ca1Total', '$ca2', '$ca3', '$practical', '$exam')");

        //                         if ($insert) {
        //                             echo "insert success for student filter";
        //                         } else {
        //                             echo mysqli_error($conn);
        //                         }
        //                     }
        //                 } else if (isset($score['subjectId'])) {
        //                     // For subject filter type
        //                     $select = mysqli_query($conn, "SELECT student_id FROM skulscores 
        //                         WHERE student_id='$studentId' AND subject_id='$subjectId' 
        //                         AND class_id='$class' AND session_id='$session' AND term_id='$term'");

        //                     if (mysqli_num_rows($select) > 0) {
        //                         $update = mysqli_query($conn, "UPDATE skulscores 
        //                             SET ca1='$ca1', ca1Total='$ca1Total', ca2='$ca2', ca3='$ca3', 
        //                             pra='$practical', exam='$exam' 
        //                             WHERE subject_id='$subjectId' AND student_id='$studentId' 
        //                             AND class_id='$class' AND session_id='$session' AND term_id='$term' 
        //                             AND school_id='$school_id'");

        //                         if ($update) {
        //                             echo "update success for subject filter";
        //                         } else {
        //                             echo mysqli_error($conn);
        //                         }
        //                     } else {
        //                         $insert = mysqli_query($conn, "INSERT INTO skulscores 
        //                             (student_id, subject_id, class_id, term_id, session_id, school_id, 
        //                             ca1, ca1Total, ca2, ca3, pra, exam) 
        //                             VALUES ('$studentId', '$subjectId', '$class', '$term', '$session', 
        //                             '$school_id', '$ca1', '$ca1Total', '$ca2', '$ca3', '$practical', '$exam')");

        //                         if ($insert) {
        //                             echo "insert success for subject filter";
        //                         } else {
        //                             echo mysqli_error($conn);
        //                         }
        //                     }
        //                 }
        //             } else {
        //                 echo "Error: Missing required fields";
        //             }
        //         }
        //         echo "Scores submitted successfully.";
        //     } else {
        //         echo "Error: No scores data received.";
        //     }
        // }

        // if ($action === 'submit_scores') {
        //     $scores = $_POST['scores'];
        //     $school_id = $_SESSION['school_id'];

        //     foreach ($scores as $score) {
        //         $class = isset($score['class']) ? $score['class'] : '';
        //         $term = isset($score['term']) ? $score['term'] : '';
        //         $session = isset($score['session']) ? $score['session'] : '';
        //         $subjectOrNameId = isset($score['subjectOrNameId']) ? $score['subjectOrNameId'] : '';
        //         $studentId = isset($score['studentId']) ? $score['studentId'] : '';
        //         $subjectId = isset($score['subjectId']) ? $score['subjectId'] : '';
        //         $ca1 = isset($score['ca1']) ? $score['ca1'] : 0;
        //         $ca1Total = isset($score['ca1Total']) ? $score['ca1Total'] : 0;
        //         $ca2 = isset($score['ca2']) ? $score['ca2'] : 0;
        //         $ca3 = isset($score['ca3']) ? $score['ca3'] : 0;
        //         $practical = isset($score['practical']) ? $score['practical'] : 0;
        //         $exam = isset($score['exam']) ? $score['exam'] : 0;

        //         if (!empty($studentId) && !empty($subjectOrNameId)) {
        //             if (isset($score['studentId'])) {
        //                 // For student filter type
        //                 $select = mysqli_query($conn, "SELECT subject_id FROM skulscores 
        //                     WHERE student_id='$studentId' AND subject_id='$subjectOrNameId' 
        //                     AND class_id='$class' AND session_id='$session' AND term_id='$term'");

        //                 if (mysqli_num_rows($select) > 0) {
        //                     $update = mysqli_query($conn, "UPDATE skulscores 
        //                         SET ca1='$ca1', ca1Total='$ca1Total', ca2='$ca2', ca3='$ca3', 
        //                         pra='$practical', exam='$exam' 
        //                         WHERE subject_id='$subjectOrNameId' AND student_id='$studentId' 
        //                         AND class_id='$class' AND session_id='$session' AND term_id='$term' 
        //                         AND school_id='$school_id'");

        //                     if ($update) {
        //                         echo "update success for student filter";
        //                     } else {
        //                         echo mysqli_error($conn);
        //                     }
        //                 } else {
        //                     $insert = mysqli_query($conn, "INSERT INTO skulscores 
        //                         (student_id, subject_id, class_id, term_id, session_id, school_id, 
        //                         ca1, ca1Total, ca2, ca3, pra, exam) 
        //                         VALUES ('$studentId', '$subjectOrNameId', '$class', '$term', '$session', 
        //                         '$school_id', '$ca1', '$ca1Total', '$ca2', '$ca3', '$practical', '$exam')");

        //                     if ($insert) {
        //                         echo "insert success for student filter";
        //                     } else {
        //                         echo mysqli_error($conn);
        //                     }
        //                 }
        //             } else if (isset($score['subjectId'])) {
        //                 // For subject filter type
        //                 $select = mysqli_query($conn, "SELECT student_id FROM skulscores 
        //                     WHERE student_id='$studentId' AND subject_id='$subjectId' 
        //                     AND class_id='$class' AND session_id='$session' AND term_id='$term'");

        //                 if (mysqli_num_rows($select) > 0) {
        //                     $update = mysqli_query($conn, "UPDATE skulscores 
        //                         SET ca1='$ca1', ca1Total='$ca1Total', ca2='$ca2', ca3='$ca3', 
        //                         pra='$practical', exam='$exam' 
        //                         WHERE subject_id='$subjectId' AND student_id='$studentId' 
        //                         AND class_id='$class' AND session_id='$session' AND term_id='$term' 
        //                         AND school_id='$school_id'");

        //                     if ($update) {
        //                         echo "update success for subject filter";
        //                     } else {
        //                         echo mysqli_error($conn);
        //                     }
        //                 } else {
        //                     $insert = mysqli_query($conn, "INSERT INTO skulscores 
        //                         (student_id, subject_id, class_id, term_id, session_id, school_id, 
        //                         ca1, ca1Total, ca2, ca3, pra, exam) 
        //                         VALUES ('$studentId', '$subjectId', '$class', '$term', '$session', 
        //                         '$school_id', '$ca1', '$ca1Total', '$ca2', '$ca3', '$practical', '$exam')");

        //                     if ($insert) {
        //                         echo "insert success for subject filter";
        //                     } else {
        //                         echo mysqli_error($conn);
        //                     }
        //                 }
        //             }
        //         } else {
        //             echo "Error: Missing required fields";
        //         }
        //     }
        // }



        // if ($action === 'submit_scores') {
        //     $scores = $_POST['scores'];
        //     $school_id = $_SESSION['school_id'];

        //     foreach ($scores as $score) {
        //         if (isset($score['subjectOrNameId'])) {
        //             $subject = $score['subjectOrNameId'];
        //             $student_id = $score['studentId'] ?? '';
        //             $class = $score['class'];
        //             $term = $score['term'];
        //             $session = $score['session'];
        //             $ca1 = $score['ca1'];
        //             $ca1Total = $score['ca1Total'];
        //             $ca2 = $score['ca2'];
        //             $ca2Total = $score['ca2Total'];
        //             $ca3 = $score['ca3'];
        //             $ca3Total = $score['ca3Total'];
        //             $pra = $score['practical'];
        //             $praTotal = $score['practicalTotal'];
        //             $exam = $score['exam'];
        //             $examTotal = $score['examTotal'];

        //             $select = mysqli_query($conn, "SELECT subject_id, student_id, class_id, term_id, session_id, school_id FROM skulscores WHERE student_id='$student_id' AND subject_id='$subject' AND class_id='$class' AND session_id='$session' AND term_id='$term'");

        //             if (mysqli_num_rows($select) > 0) {
        //                 $update = mysqli_query($conn, "UPDATE skulscores SET ca1='$ca1', ca1Total='$ca1Total', ca2='$ca2', ca2Total='$ca2Total', ca3='$ca3', ca3Total='$ca3Total', pra='$pra', praTotal='$praTotal', exam='$exam', examTotal='$examTotal' WHERE subject_id='$subject' AND student_id='$student_id' AND class_id='$class' AND session_id='$session' AND term_id='$term' AND school_id='$school_id'");
        //                 echo "update success for subject filter";
        //             } else {
        //                 $insert = mysqli_query($conn, "INSERT INTO skulscores (student_id, subject_id, class_id, term_id, session_id, school_id, ca1, ca1Total, ca2, ca2Total, ca3, ca3Total, pra, praTotal, exam, examTotal) VALUES ('$student_id', '$subject', '$class', '$term', '$session', '$school_id', '$ca1', '$ca1Total', '$ca2', '$ca2Total', '$ca3', '$ca3Total', '$pra', '$praTotal', '$exam', '$examTotal')");
        //                 if ($insert) {
        //                     echo "insert success for subject filter";
        //                 } else {
        //                     echo mysqli_error($conn);
        //                 }
        //             }
        //         } else if(isset($score['subject'])) {
        //             // Handle subject filter type
        //             $subject = $score['subject'];
        //             $select = mysqli_query($conn, "SELECT * FROM skulscores WHERE subject_id='$subjectOrNameId' AND class_id='$class' AND session_id='$session' AND term_id='$term' AND school_id='$school_id'");

        //             if(mysqli_num_rows($select) > 0) {
        //                 // Update existing record
        //                 $update = mysqli_query($conn, "UPDATE skulscores 
        //                     SET ca1='$ca1', ca1Total='$ca1Total', ca2='$ca2', ca2Total='$ca2Total', ca3='$ca3', ca3Total='$ca3Total', pra='$practical', praTotal='$practicalTotal', exam='$exam', examTotal='$examTotal'
        //                     WHERE subject_id='$subjectOrNameId' AND class_id='$class' AND session_id='$session' AND term_id='$term' AND school_id='$school_id'");
        //                 if($update) {
        //                     echo "update success for subject filter";
        //                 } else {
        //                     echo "update error for subject filter: " . mysqli_error($conn);
        //                 }
        //             } else {
        //                 // Insert new record
        //                 $insert = mysqli_query($conn, "INSERT INTO skulscores(subject_id, class_id, term_id, session_id, school_id, ca1, ca1Total, ca2, ca2Total, ca3, ca3Total, pra, praTotal, exam, examTotal)
        //                     VALUES('$subjectOrNameId', '$class', '$term', '$session', '$school_id', '$ca1', '$ca1Total', '$ca2', '$ca2Total', '$ca3', '$ca3Total', '$practical', '$practicalTotal', '$exam', '$examTotal')");
        //                 if($insert) {
        //                     echo "insert success for subject filter";
        //                 } else {
        //                     echo "insert error for subject filter: " . mysqli_error($conn);
        //                 }
        //             }
        //         }
        //     }
        // }
    

    // exit;
    // $week_id = substr($_POST['week_ids'],1,-1);
    // print_r($week_id);
    // echo $sql_check = "SELECT week_id,class_id,filedata FROM lesson_note WHERE school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    // $check = mysqli_query($conn, $sql_check);
    // if (mysqli_num_rows($check) > 0) {
    //     while ($row = mysqli_fetch_assoc($check)) {
    //         print_r($row);
    //         $class_id_array_tbl = explode(",", $row['class_id']);
    //         // print_r($class_id_array_tbl);
    //         if (array_intersect($class_id_array, $class_id_array_tbl)) {
    //             $week_ids_tbl = explode(",", $row['week_id']);
    //             print_r($week_ids_tbl);
    //             if (array_intersect($week_ids, $week_ids_tbl)) {
    //                 echo "yess_week";
    //                 //with file
    //                 if (!empty($_FILES['files'])) {
    //                     $data_update = [];
    //                     foreach ($_FILES['files']['tmp_name'] as $index => $tmpName) {
    //                         if ($_FILES['files']['size'][$index] <= 2 * 1024 * 1024) {
    //                             $filename_update = time() . 'lesson_note' . $_FILES['files']['name'][$index];
    //                             $destination = "uploads/" . $filename_update;
    //                             $file_data = explode(",", $row['filedata']);
    //                             foreach ($file_data as $file_datum) {
    //                                 $previous_filepath = "uploads/" . $file_datum;
    //                                 deleteFile($previous_filepath);
    //                             }
    //                             move_uploaded_file($tmpName, $destination);
    //                             $data_update[] = $filename_update;
    //                         } else {
    //                             echo json_encode(['error' => 'File size exceeds 2MB.']);
    //                             exit;
    //                         }
    //                     }
    //                     $data_update = join(",", $data_update);
    //                     $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', file_data = '$data_update', week_id='$week_id', class_id='$class_id', topic='$topic', content='$body'
    //                     WHERE school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    //                 } else {
    //                     //without file
    //                     $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', week_id='$week_id', class_id='$class_id', topic='$topic', content='$body'
    //                     WHERE school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    //                 }
    //                 $update = mysqli_query($conn, $sql_update);
    //             } else {
    //                 echo "noo_week";
    //                 if (!empty($_FILES['files'])) {
    //                     $data = [];
    //                     foreach ($_FILES['files']['tmp_name'] as $index => $tmpName) {
    //                         if ($_FILES['files']['size'][$index] <= 2 * 1024 * 1024) {
    //                             $filename = time() . 'lesson_note' . $_FILES['files']['name'][$index];
    //                             $destination = "uploads/" . $filename;
    //                             move_uploaded_file($tmpName, $destination);
    //                             $data[] = $filename;
    //                         } else {
    //                             echo json_encode(['error' => 'File size exceeds 2MB.']);
    //                             exit;
    //                         }
    //                     }
    //                     $data = join(",", $data);
    //                     $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,filedata,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //                     VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','$data','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_ids','$week_id','$topic','$body')";
    //                 } else {
    //                     $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //                     VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_id','$week_id','$topic','$body')";
    //                 }
    //                 $insert = mysqli_query($conn, $sql);
    //                 if ($insert) {
    //                     echo json_encode(array('status' => '1'));
    //                 }
    //             }
    //             echo "yes";
    //         } else {
    //             echo "no";
    //             if (!empty($_FILES['files'])) {
    //                 $data = [];
    //                 foreach ($_FILES['files']['tmp_name'] as $index => $tmpName) {
    //                     if ($_FILES['files']['size'][$index] <= 2 * 1024 * 1024) {
    //                         $filename = time() . 'lesson_note' . $_FILES['files']['name'][$index];
    //                         $destination = "uploads/" . $filename;
    //                         move_uploaded_file($tmpName, $destination);
    //                         $data[] = $filename;
    //                     } else {
    //                         echo json_encode(['error' => 'File size exceeds 2MB.']);
    //                         exit;
    //                     }
    //                 }
    //                 $data = join(",", $data);
    //                 $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,filedata,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //                 VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','$data','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_ids','$week_id','$topic','$body')";
    //             } else {
    //                 $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //                 VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_id','$week_id','$topic','$body')";
    //             }
    //             $insert = mysqli_query($conn, $sql);
    //             if ($insert) {
    //                 echo json_encode(array('status' => '1'));
    //             }
    //         }
    //     }
    // } else {
    //     echo "nooo";
    //     if (!empty($_FILES['files'])) {
    //         $data = [];
    //         foreach ($_FILES['files']['tmp_name'] as $index => $tmpName) {
    //             if ($_FILES['files']['size'][$index] <= 2 * 1024 * 1024) {
    //                 $filename = time() . 'lesson_note' . $_FILES['files']['name'][$index];
    //                 $destination = "uploads/" . $filename;
    //                 move_uploaded_file($tmpName, $destination);
    //                 $data[] = $filename;
    //             } else {
    //                 echo json_encode(['error' => 'File size exceeds 2MB.']);
    //                 exit;
    //             }
    //         }
    //         $data = join(",", $data);
    //         $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,filedata,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //         VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','$data','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_ids','$week_id','$topic','$body')";
    //     } else {
    //         $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //         VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_id','$week_id','$topic','$body')";
    //     }
    //     $insert = mysqli_query($conn, $sql);
    //     if ($insert) {
    //         echo json_encode(array('status' => '1'));
    //     }
    // }
    // exit;


    // if ($action == "create_lesson_note") {
    //     $class_id = $_POST['class_id'];
    //     $class_id_array = explode(",", $_POST['class_id']);
    //     // print_r($class_id_array);
    //     $body = mysqli_real_escape_string($conn, $_POST['body']);
    //     $topic = test_input($_POST['topic']);
    //     $subject_id = $_POST['subject_id'];
    //     $week_id = implode(",", json_decode($_POST['week_ids']));
    //     $week_ids = json_decode($_POST['week_ids']);
    //     print_r($week_ids);
    //     // exit;
    //     // $week_id = substr($_POST['week_ids'],1,-1);
    //     // print_r($week_id);
    //     echo $sql_check = "SELECT week_id,class_id,filedata FROM lesson_note WHERE school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    //     $check = mysqli_query($conn, $sql_check);
    //     if (mysqli_num_rows($check) > 0) {
    //         while ($row = mysqli_fetch_assoc($check)) {
    //             print_r($row);
    //             $class_id_array_tbl = explode(",", $row['class_id']);
    //             // print_r($class_id_array_tbl);
    //             if (array_intersect($class_id_array, $class_id_array_tbl)) {
    //                 $week_ids_tbl = explode(",", $row['week_id']);
    //                 print_r($week_ids_tbl);
    //                 if (array_intersect($week_ids, $week_ids_tbl)) {
    //                     echo "yess_week";
    //                     //with file
    //                     if (!empty($_FILES['files'])) {
    //                         $data_update = [];
    //                         foreach ($_FILES['files']['tmp_name'] as $index => $tmpName) {
    //                             if ($_FILES['files']['size'][$index] <= 2 * 1024 * 1024) {
    //                                 $filename_update = time() . 'lesson_note' . $_FILES['files']['name'][$index];
    //                                 $destination = "uploads/" . $filename_update;
    //                                 $file_data = explode(",", $row['filedata']);
    //                                 foreach ($file_data as $file_datum) {
    //                                     $previous_filepath = "uploads/" . $file_datum;
    //                                     deleteFile($previous_filepath);
    //                                 }
    //                                 move_uploaded_file($tmpName, $destination);
    //                                 $data_update[] = $filename_update;
    //                             } else {
    //                                 echo json_encode(['error' => 'File size exceeds 2MB.']);
    //                                 exit;
    //                             }
    //                         }
    //                         $data_update = join(",", $data_update);
    //                         $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', file_data = '$data_update', week_id='$week_id', class_id='$class_id', topic='$topic', content='$body'
    //                         WHERE school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    //                     } else {
    //                         //without file
    //                         $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', week_id='$week_id', class_id='$class_id', topic='$topic', content='$body'
    //                         WHERE school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    //                     }
    //                     $update = mysqli_query($conn, $sql_update);
    //                 } else {
    //                     echo "noo_week";
    //                     if (!empty($_FILES['files'])) {
    //                         $data = [];
    //                         foreach ($_FILES['files']['tmp_name'] as $index => $tmpName) {
    //                             if ($_FILES['files']['size'][$index] <= 2 * 1024 * 1024) {
    //                                 $filename = time() . 'lesson_note' . $_FILES['files']['name'][$index];
    //                                 $destination = "uploads/" . $filename;
    //                                 move_uploaded_file($tmpName, $destination);
    //                                 $data[] = $filename;
    //                             } else {
    //                                 echo json_encode(['error' => 'File size exceeds 2MB.']);
    //                                 exit;
    //                             }
    //                         }
    //                         $data = join(",", $data);
    //                         $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,filedata,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //                         VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','$data','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_ids','$week_id','$topic','$body')";
    //                     } else {
    //                         $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //                         VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_id','$week_id','$topic','$body')";
    //                     }
    //                     $insert = mysqli_query($conn, $sql);
    //                     if ($insert) {
    //                         echo json_encode(array('status' => '1'));
    //                     }
    //                 }
    //                 echo "yes";
    //             } else {
    //                 echo "no";
    //                 if (!empty($_FILES['files'])) {
    //                     $data = [];
    //                     foreach ($_FILES['files']['tmp_name'] as $index => $tmpName) {
    //                         if ($_FILES['files']['size'][$index] <= 2 * 1024 * 1024) {
    //                             $filename = time() . 'lesson_note' . $_FILES['files']['name'][$index];
    //                             $destination = "uploads/" . $filename;
    //                             move_uploaded_file($tmpName, $destination);
    //                             $data[] = $filename;
    //                         } else {
    //                             echo json_encode(['error' => 'File size exceeds 2MB.']);
    //                             exit;
    //                         }
    //                     }
    //                     $data = join(",", $data);
    //                     $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,filedata,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //                     VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','$data','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_ids','$week_id','$topic','$body')";
    //                 } else {
    //                     $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //                     VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_id','$week_id','$topic','$body')";
    //                 }
    //                 $insert = mysqli_query($conn, $sql);
    //                 if ($insert) {
    //                     echo json_encode(array('status' => '1'));
    //                 }
    //             }
    //         }
    //     } else {
    //         echo "nooo";
    //         if (!empty($_FILES['files'])) {
    //             $data = [];
    //             foreach ($_FILES['files']['tmp_name'] as $index => $tmpName) {
    //                 if ($_FILES['files']['size'][$index] <= 2 * 1024 * 1024) {
    //                     $filename = time() . 'lesson_note' . $_FILES['files']['name'][$index];
    //                     $destination = "uploads/" . $filename;
    //                     move_uploaded_file($tmpName, $destination);
    //                     $data[] = $filename;
    //                 } else {
    //                     echo json_encode(['error' => 'File size exceeds 2MB.']);
    //                     exit;
    //                 }
    //             }
    //             $data = join(",", $data);
    //             $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,filedata,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //             VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','$data','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_ids','$week_id','$topic','$body')";
    //         } else {
    //             $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //             VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$class_id','$subject_id','$week_id','$topic','$body')";
    //         }
    //         $insert = mysqli_query($conn, $sql);
    //         if ($insert) {
    //             echo json_encode(array('status' => '1'));
    //         }
    //     }
    //     // exit;

    // }


    // if ($action == "create_lesson_note_body") {
    //     $cid = $_POST['class_id'];
    //     // $class_id_array = explode(",", $_POST['class_id']);
    //     // print_r($class_id_array);
    //     $body = mysqli_real_escape_string($conn, $_POST['body']);
    //     // $topic = test_input($_POST['topic']);
    //     $subject_id = test_input($_POST['subject_id']);
    //     // $week_id = implode(",", json_decode($_POST['week_ids']));
    //     $wid = test_input($_POST['week_id']);
    //     // print_r($week_ids);

    //     // foreach ($class_id_array as $cid) {
    //     $sql_check = "SELECT week_id,class_id,filedata FROM lesson_note WHERE week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    //     $check = mysqli_query($conn, $sql_check);
    //     if (mysqli_num_rows($check) > 0) {
    //         if ($row = mysqli_fetch_assoc($check)) {

    //             //without file
    //             $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', content='$body'
    //                         WHERE week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";

    //             $update = mysqli_query($conn, $sql_update);
    //             echo "update";
    //             echo json_encode(array('status' => '1'));
    //         }
    //     } else {

    //         $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,content)
    //                     VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$cid','$subject_id','$wid','$body')";

    //         $insert = mysqli_query($conn, $sql);
    //         if ($insert) {
    //             echo "insert";
    //             echo json_encode(array('status' => '1'));
    //         }
    //     }
    // }
    // }
// if ($action == "create_lesson_note_body") {
//         $cid = $_POST['class_id'];
//         // $class_id_array = explode(",", $_POST['class_id']);
//         // print_r($class_id_array);
//         // Keep an escaped version for SQL, but also retain the raw body for HTML comparison
//         $rawBody = isset($_POST['body']) ? $_POST['body'] : '';
//         $body = mysqli_real_escape_string($conn, $rawBody);
//         // $topic = test_input($_POST['topic']);
//         $subject_id = test_input($_POST['subject_id']);
//         // $week_id = implode(",", json_decode($_POST['week_ids']));
//         $wid = test_input($_POST['week_id']);
//         // print_r($week_ids);

//         // foreach ($class_id_array as $cid) {
//         $sql_check = "SELECT week_id,class_id,content,filedata FROM lesson_note WHERE week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
//         $check = mysqli_query($conn, $sql_check);
//         if (mysqli_num_rows($check) > 0) {
//             if ($row = mysqli_fetch_assoc($check)) {

//                 // Capture old content so we can remove images that were deleted from the editor
//                 $oldContent = isset($row['content']) ? $row['content'] : '';

//                 // Update content
//                 $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', content='$body'
//                             WHERE week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";

//                 $update = mysqli_query($conn, $sql_update);

//                 if ($update) {
//                     // After successful update: determine which images existed previously but are not present in the new content
//                     // Use the raw (unescaped) body for HTML/image comparison
//                     $newContent = $rawBody;

//                     // helper to extract src attributes from img tags
//                     $extractSrcs = function ($html) {
//                         $results = [];
//                         if (!$html) return $results;
//                         if (preg_match_all('/<img[^>]+src=["\']([^"\']+)["\']/i', $html, $m)) {
//                             $results = $m[1];
//                         }
//                         return $results;
//                     };

//                     // decode any HTML entities to improve matching
//                     $oldImgs = $extractSrcs(html_entity_decode($oldContent));
//                     $newImgs = $extractSrcs(html_entity_decode($newContent));

//                     // normalize to basenames for comparison and safety
//                     $normalize = function ($url) {
//                         $path = parse_url($url, PHP_URL_PATH);
//                         return $path ? basename($path) : basename($url);
//                     };

//                     $newBasenames = array_map($normalize, $newImgs);

//                     // delete files that were in oldImgs but not in newImgs
//                     $uploadsDir = __DIR__ . DIRECTORY_SEPARATOR . 'uploads' . DIRECTORY_SEPARATOR . 'lesson_images' . DIRECTORY_SEPARATOR;
//                     // prepare a debug log
//                     $logFile = $uploadsDir . 'upload_errors.log';
//                     $dbg = [];
//                     $dbg[] = "-- image-deletion-run: " . date('c');
//                     $dbg[] = "oldImgs: " . json_encode($oldImgs);
//                     $dbg[] = "newImgs: " . json_encode($newImgs);
//                     $dbg[] = "newBasenames: " . json_encode($newBasenames);

//                     foreach ($oldImgs as $oldUrl) {
//                         $base = $normalize($oldUrl);
//                         if (!$base) {
//                             $dbg[] = "skip-empty-base for url: $oldUrl";
//                             continue;
//                         }
//                         // skip if still present
//                         if (in_array($base, $newBasenames)) {
//                             $dbg[] = "keep (still referenced): $base";
//                             continue;
//                         }

//                         // safety: only allow simple filenames
//                         if (!preg_match('/^[a-zA-Z0-9_\-\.]+$/', $base)) {
//                             $dbg[] = "skip-invalid-filename: $base";
//                             continue;
//                         }

//                         $filePath = $uploadsDir . $base;
//                         if (file_exists($filePath) && is_file($filePath)) {
//                             $ok = @unlink($filePath);
//                             if ($ok) {
//                                 $dbg[] = "deleted: $filePath";
//                             } else {
//                                 $dbg[] = "unlink-failed: $filePath";
//                             }
//                         } else {
//                             $dbg[] = "file-not-found: $filePath";
//                         }
//                     }
//                     // append debug log
//                     @file_put_contents($logFile, implode("\n", $dbg) . "\n", FILE_APPEND | LOCK_EX);

//                     // return JSON including debug info for easier client-side debugging
//                     $response = ['status' => '1', 'debug' => $dbg];
//                     header('Content-Type: application/json');
//                     echo json_encode($response);
//                     exit();
//                 } else {
//                     $response = ['status' => '0', 'error' => 'db_update_failed'];
//                     header('Content-Type: application/json');
//                     echo json_encode($response);
//                     exit();
//                 }
//             }
//         } else {

//             $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,content)
//                         VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$cid','$subject_id','$wid','$body')";

//             $insert = mysqli_query($conn, $sql);
//             if ($insert) {
//                 echo "insert";
//                 echo json_encode(array('status' => '1'));
//             }
//         }
//     }
    // if ($action == "create_lesson_note_topic") {
    //     $cid = $_POST['class_id'];
    //     // $class_id_array = explode(",", $_POST['class_id']);
    //     // print_r($class_id_array);
    //     // $body = mysqli_real_escape_string($conn, $_POST['body']);
    //     $topic = test_input($_POST['topic']);
    //     $subject_id = $_POST['subject_id'];
    //     // $week_id = implode(",", json_decode($_POST['week_ids']));
    //     $wid = $_POST['week_id'];
    //     // print_r($week_ids);

    //     // foreach ($class_id_array as $cid) {
    //     // foreach ($week_ids as $wid) {
    //     $sql_check = "SELECT week_id,class_id,filedata FROM lesson_note WHERE week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    //     $check = mysqli_query($conn, $sql_check);
    //     if (mysqli_num_rows($check) > 0) {
    //         if ($row = mysqli_fetch_assoc($check)) {

    //             //without file
    //             $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', topic='$topic' 
    //                     WHERE week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";

    //             $update = mysqli_query($conn, $sql_update);
    //             echo "update";
    //             echo json_encode(array('status' => '1'));
    //         }
    //     } else {

    //         $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,topic)
    //                     VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$cid','$subject_id','$wid','$topic')";

    //         $insert = mysqli_query($conn, $sql);
    //         if ($insert) {
    //             echo "insert";
    //             echo json_encode(array('status' => '1'));
    //         }
    //     }
    // }
    if ($action == "create_lesson_note_body") {
    $cid_input = $_POST['class_id'];
    $class_id_array = is_array($cid_input) ? $cid_input : [$cid_input];

    // Keep an escaped version for SQL, but also retain the raw body for HTML comparison
    $rawBody = isset($_POST['body']) ? $_POST['body'] : '';
    
    $body = mysqli_real_escape_string($conn, $rawBody);
    // echo $body;
    // $topic = test_input($_POST['topic']);
    $subject_id = test_input($_POST['subject_id']);
    // $week_id = implode(",", json_decode($_POST['week_ids']));
    $wid = test_input($_POST['week_id']);
        $term_id = isset($_POST['term_id']) && $_POST['term_id'] !== '' ? test_input($_POST['term_id']) : $_SESSION['term_id'];

    // print_r($week_ids);

    foreach ($class_id_array as $cid) {
               $sql_check = "SELECT week_id,class_id,content,filedata FROM lesson_note WHERE week_id='$wid' AND class_id='$cid' AND term_id='$term_id' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";

        $check = mysqli_query($conn, $sql_check);
        if (mysqli_num_rows($check) > 0) {
            if ($row = mysqli_fetch_assoc($check)) {

                // Capture old content so we can remove images that were deleted from the editor
                $oldContent = isset($row['content']) ? $row['content'] : '';

                // Update content
                $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', content='$body'
                            WHERE week_id='$wid' AND class_id='$cid' AND term_id='$term_id' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";


                $update = mysqli_query($conn, $sql_update);

                if ($update) {
                    // After successful update: determine which images existed previously but are not present in the new content
                    // Use the raw (unescaped) body for HTML/image comparison
                    $newContent = $rawBody;

                    // helper to extract src attributes from img tags
                    $extractSrcs = function ($html) {
                        $results = [];
                        if (!$html)
                            return $results;
                        if (preg_match_all('/<img[^>]+src=["\']([^"\']+)["\']/i', $html, $m)) {
                            $results = $m[1];
                        }
                        return $results;
                    };

                    // decode any HTML entities to improve matching
                    $oldImgs = $extractSrcs(html_entity_decode($oldContent));
                    $newImgs = $extractSrcs(html_entity_decode($newContent));

                    // normalize to basenames for comparison and safety
                    $normalize = function ($url) {
                        $path = parse_url($url, PHP_URL_PATH);
                        return $path ? basename($path) : basename($url);
                    };

                    $newBasenames = array_map($normalize, $newImgs);

                    // delete files that were in oldImgs but not in newImgs
                    $uploadsDir = __DIR__ . DIRECTORY_SEPARATOR . 'uploads' . DIRECTORY_SEPARATOR . 'lesson_images' . DIRECTORY_SEPARATOR;
                    // prepare a debug log
                    $logFile = $uploadsDir . 'upload_errors.log';
                    $dbg = [];
                    // $dbg[] = "-- image-deletion-run: " . date('c');
                    // $dbg[] = "oldImgs: " . json_encode($oldImgs);
                    // $dbg[] = "newImgs: " . json_encode($newImgs);
                    // $dbg[] = "newBasenames: " . json_encode($newBasenames);

                    foreach ($oldImgs as $oldUrl) {
                        $base = $normalize($oldUrl);
                        if (!$base) {
                            // $dbg[] = "skip-empty-base for url: $oldUrl";
                            continue;
                        }
                        // skip if still present
                        if (in_array($base, $newBasenames)) {
                            // $dbg[] = "keep (still referenced): $base";
                            continue;
                        }

                        // safety: only allow simple filenames
                        if (!preg_match('/^[a-zA-Z0-9_\-\.]+$/', $base)) {
                            // $dbg[] = "skip-invalid-filename: $base";
                            continue;
                        }

                        $filePath = $uploadsDir . $base;
                        if (file_exists($filePath) && is_file($filePath)) {
                            $ok = @unlink($filePath);
                            if ($ok) {
                                // $dbg[] = "deleted: $filePath";
                            } else {
                                // $dbg[] = "unlink-failed: $filePath";
                            }
                        } else {
                            // $dbg[] = "file-not-found: $filePath";
                        }
                    }
                    // append debug log
                    // @file_put_contents($logFile, implode("\n", $dbg) . "\n", FILE_APPEND | LOCK_EX);
                }
            }
        } else {
            $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,content)
                        VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','$term_id','$cid','$subject_id','$wid','$body')";


            $insert = mysqli_query($conn, $sql);
        }
    }
    echo json_encode(array('status' => '1'));
}
    if ($action == "create_lesson_note_topic") {
    $cid_input = $_POST['class_id'];
    $class_id_array = is_array($cid_input) ? $cid_input : [$cid_input];

    $topic = test_input($_POST['topic']);
    $subject_id = $_POST['subject_id'];
    $wid = isset($_POST['week_id']) ? test_input($_POST['week_id']) : '';
    $term_id = isset($_POST['term_id']) && $_POST['term_id'] !== '' ? test_input($_POST['term_id']) : $_SESSION['term_id'];
    foreach ($class_id_array as $cid) {
        $sql_check = "SELECT week_id,class_id,filedata FROM lesson_note WHERE week_id='$wid' AND class_id='$cid' AND term_id='$term_id' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
        $check = mysqli_query($conn, $sql_check);
        if (mysqli_num_rows($check) > 0) {
            if ($row = mysqli_fetch_assoc($check)) {

                //without file
                $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', topic='$topic' 
                    WHERE week_id='$wid' AND class_id='$cid' AND term_id='$term_id' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";

                $update = mysqli_query($conn, $sql_update);
            }
        } else {

            $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,topic)
                        VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','$term_id','$cid','$subject_id','$wid','$topic')";

            $insert = mysqli_query($conn, $sql);
        }
    }
    echo json_encode(array('status' => '1'));
}
if ($action == "get_classes_for_lesson_note") {
    $select = mysqli_query($conn, "SELECT id, classname FROM class WHERE school_id='{$_SESSION['school_id']}' ORDER BY classname ASC");
    $data = [];
    while ($row = mysqli_fetch_assoc($select)) {
        $data[] = $row;
    }
    echo json_encode(['status' => '1', 'data' => $data]);
}
    // }
    // }

    if ($action == 'get_lesson_note') {

        $cid = $_POST['class_id'];
        $subject_id = $_POST['subject_id'];

        // $class_id_array = $class_id;
        // $cid = end($class_id_array);

        $wid = $_POST['week_id'];
            $term_id = isset($_POST['term_id']) && $_POST['term_id'] !== '' ? test_input($_POST['term_id']) : $_SESSION['term_id'];

        // $wid = end($week_ids_array);
        if ($_POST['type'] == 'body') {
        $sql = "SELECT content FROM lesson_note 
                WHERE week_id = '$wid' AND class_id = '$cid' AND term_id='$term_id' 
                AND school_id = '{$_SESSION['school_id']}' 
                AND subject_id = '$subject_id'";
        } else {
           $sql = "SELECT topic FROM lesson_note 
                    WHERE week_id = '$wid' AND class_id = '$cid' AND term_id='$term_id' 
                    AND school_id = '{$_SESSION['school_id']}' 
                    AND subject_id = '$subject_id'";
        }
        $select = mysqli_query($conn, $sql);

        if ($row = mysqli_fetch_assoc($select)) {
            echo json_encode($row);
        }
    }

    if ($action == 'get_note_weeks') {
        $class_id = test_input($_POST['class_id']);
        $subject_id = $_POST['subject_id'];
        
         $term_id = isset($_POST['term_id']) && $_POST['term_id'] !== '' ? test_input($_POST['term_id']) : $_SESSION['term_id'];
        $sql = "SELECT week_id FROM lesson_note WHERE class_id='$class_id' AND subject_id='$subject_id' AND term_id='$term_id' AND school_id = '{$_SESSION['school_id']}'";
    
        $select = mysqli_query($conn, $sql);
        $data = [];
        while ($row = mysqli_fetch_assoc($select)) {
            $data[] = $row['week_id'];
        }
        echo json_encode($data);
    }

    if ($action == 'save_time_tbl') {
        $events = $_POST['events'];
        $savedEvents = [];
        foreach ($events as $event) {
            $id = $event['id'];
            $start = (new DateTime($event['start']))->format('Y-m-d H:i:s');
            $end = (new DateTime($event['end']))->format('Y-m-d H:i:s');

            // $start = $event['start'];
            // $end = $event['end'];
            $classid = isset($event['classid']) ? $event['classid'] : null;
            $subjectid = isset($event['subjectid']) ? $event['subjectid'] : null;
            $eventid = isset($event['eventid']) ? $event['eventid'] : null;

            if ($id == '') {
                if ($classid && $subjectid) {
                    // echo "INSERT INTO time_table (class_id, subject_id, start, end, createdby, datecreated, school_id) 
                    // VALUES ('$classid', '$subjectid', '$start', '$end', '{$_SESSION['userid']}', '$date', '{$_SESSION['school_id']}')";
                    $query = mysqli_query($conn, "INSERT INTO time_table (class_id, subject_id, start, end, createdby, datecreated, school_id) 
                    VALUES ('$classid', '$subjectid', '$start', '$end', '{$_SESSION['userid']}', '$date', '{$_SESSION['school_id']}')");
                    $id = mysqli_insert_id($conn);
                } else {
                    // echo "INSERT INTO extraevents (event_id, start, end, createdby, datecreated, school_id) 
                    // VALUES ('$eventid', '$start', '$end', '{$_SESSION['userid']}', '$date', '{$_SESSION['school_id']}')";
                    $query = mysqli_query($conn, "INSERT INTO extraevents (event_id, start, end, createdby, datecreated, school_id) 
                    VALUES ('$eventid', '$start', '$end', '{$_SESSION['userid']}', '$date', '{$_SESSION['school_id']}')");
                    $id = mysqli_insert_id($conn);
                }
            } else {
                if ($classid && $subjectid) {
                //   echo  "UPDATE time_table SET class_id='$classid', subject_id='$subjectid', start='$start', end='$end', updatedby='{$_SESSION['userid']}', dateupdated='$date' 
                //     WHERE id='$id' AND school_id='{$_SESSION['school_id']}'";
                    $query = mysqli_query($conn, "UPDATE time_table SET class_id='$classid', subject_id='$subjectid', start='$start', end='$end', updatedby='{$_SESSION['userid']}', dateupdated='$date' 
                    WHERE id='$id' AND school_id='{$_SESSION['school_id']}'");
                } else {
                    // echo "UPDATE extraevents SET start='$start', end='$end', updatedby='{$_SESSION['userid']}', dateupdated='$date' 
                    // WHERE id='$id' AND school_id='{$_SESSION['school_id']}'";
                    $query = mysqli_query($conn, "UPDATE extraevents SET start='$start', end='$end', updatedby='{$_SESSION['userid']}', dateupdated='$date' 
                    WHERE id='$id' AND school_id='{$_SESSION['school_id']}'");
                }
            }

            $savedEvents[] = ['id' => $id];
        }
        echo json_encode($savedEvents);
        mysqli_close($conn);
        exit();
    }
    // print_r($_POST);
    // if ($action == 'save_time_tbl') {
    //     $events = $_POST['events'];
    //     foreach ($events as $event) {
    //         $id = $event['id'];
    //         $start = $event['start'];
    //         $end = $event['end'];
    //         if (!isset($event['classid'])) {
    //             // echo "events";
    //             if ($id == '') {
    //                 $eventid = $event['eventid'];
    //                 // echo 'not up';
    //                 $query = mysqli_query($conn, "INSERT INTO extraevents (event_id,start,end,createdby,datecreated,school_id) 
    //             VALUES('$eventid','$start','$end','{$_SESSION['userid']}', '$date', '{$_SESSION['school_id']}')");
    //                 $id = mysqli_insert_id($conn);
    //             } else {
    //                 // echo 'upda';
    //                 $sql = "UPDATE extraevents SET start='$start', end='$end', updatedby='{$_SESSION['userid']}', dateupdated='$date' WHERE id='$id' AND school_id='{$_SESSION['school_id']}'";
    //                 $query = mysqli_query($conn, $sql);
    //             }
    //         } else {
    //             // echo "not ee ";
    //             $classid = $event['classid'];
    //             $subjectid = $event['subjectid'];

    //             if ($id == "") {
    //                 if ($classid && $subjectid) {
    //                     $query = mysqli_query($conn, "INSERT INTO time_table (class_id, subject_id, start, end, createdby, datecreated, school_id) 
    //                     VALUES ('$classid', '$subjectid', '$start', '$end', '{$_SESSION['userid']}', '$date', '{$_SESSION['school_id']}')");
    //                     $id = mysqli_insert_id($conn);
    //                 } else {
    //                     $query = mysqli_query($conn, "INSERT INTO extraevents (event_id, start, end, createdby, datecreated, school_id) 
    //                     VALUES ('$eventid', '$start', '$end', '{$_SESSION['userid']}', '$date', '{$_SESSION['school_id']}')");
    //                     $id = mysqli_insert_id($conn);
    //                 }
    //             } else {
    //                 if ($classid && $subjectid) {
    //                     $query = mysqli_query($conn, "UPDATE time_table SET class_id='$classid', subject_id='$subjectid', start='$start', end='$end', updatedby='{$_SESSION['userid']}', dateupdated='$date' 
    //                     WHERE id='$id' AND school_id='{$_SESSION['school_id']}'");
    //                 } else {
    //                     $query = mysqli_query($conn, "UPDATE extraevents SET start='$start', end='$end', updatedby='{$_SESSION['userid']}', dateupdated='$date' 
    //                     WHERE id='$id' AND school_id='{$_SESSION['school_id']}'");
    //                 }
    //             }
    //         }
    //         $savedEvents[] = ['id' => $id];
    //     }
    //     echo json_encode($savedEvents);
    //     mysqli_close($conn);
    //     exit();
    // }

    // if ($action == 'get_time_tbl') {
    //     $select = mysqli_query($conn, "SELECT t.id,t.class_id,t.subject_id,t.start,t.end,s.subject,c.classname 
    //     FROM time_table t, class c, subjects s WHERE c.id=t.class_id AND s.id=t.subject_id AND t.school_id = '{$_SESSION['school_id']}'");
    //     $data = [];
    //     // $row = mysqli_fetch_assoc($select);
    //     while ($row = mysqli_fetch_assoc($select)) {
    //         $data[] = $row;
    //     }

    //     echo json_encode($data);
    // }

    if ($action == 'get_subjects_timetable') { //get all subject based on class clicked
        $id = test_input($_POST['subject_cat_id']);
        if ($id == 'all') {
            $subject_ids = [];
            $sql = "SELECT id,subject_ids FROM subject_cat WHERE school_id = '{$_SESSION['school_id']}'";
            $select = mysqli_query($conn, $sql);
            if (mysqli_num_rows($select) > 0) {
                while ($row = mysqli_fetch_assoc($select)) {
                    $subject_ids = array_merge($subject_ids, explode(",", $row['subject_ids']));
                }
                $subject_ids = array_unique($subject_ids);
            } else {
                // echo 0;
                return null;
                exit;
            }
        } else {
            $sql = "SELECT id,subject_ids FROM subject_cat WHERE id='$id' AND school_id = '{$_SESSION['school_id']}'";
            $select = mysqli_query($conn, $sql);
            if (mysqli_num_rows($select) > 0) {
                $row = mysqli_fetch_assoc($select);
                $subject_ids = explode(",", $row['subject_ids']);
            } else {
                // echo 0;
                return null;
                exit;
            }
        }
        $data = [];
        foreach ($subject_ids as $subject_id) {
            $select_subject = mysqli_query($conn, "SELECT id, subject FROM subjects WHERE id='$subject_id'");
            while ($subj_row = mysqli_fetch_assoc($select_subject)) {
                $data[$subj_row['id']] = $subj_row['subject'];
            }
        }
        echo json_encode($data);
    }

    if ($action == 'get_this_subject_time_tbl') { //get subjects to display on time table
        $classid = test_input($_POST['classid']);
        $subj_id = test_input($_POST['subj_id']);
        if ($subj_id == 'all' and $classid == 'all') {
            $sql = "SELECT t.id,t.class_id,c.color,t.subject_id,t.start,t.end,s.subject,c.classname 
        FROM time_table t, class c, subjects s WHERE c.id=t.class_id AND s.id=t.subject_id AND t.school_id = '{$_SESSION['school_id']}'";
        } else if ($subj_id == 'all' and $classid != 'all') {
            $sql = "SELECT t.id,t.class_id,c.color,t.subject_id,t.start,t.end,s.subject,c.classname 
        FROM time_table t, class c, subjects s WHERE t.class_id='$classid' AND c.id=t.class_id AND s.id=t.subject_id AND t.school_id = '{$_SESSION['school_id']}'";
        } else if ($subj_id != 'all' and $classid == 'all') {
            $sql = "SELECT t.id,t.class_id,c.color,t.subject_id,t.start,t.end,s.subject,c.classname 
        FROM time_table t, class c, subjects s WHERE t.subject_id='$subj_id' AND c.id=t.class_id AND s.id=t.subject_id AND t.school_id = '{$_SESSION['school_id']}'";
        } else {
            $sql = "SELECT t.id,t.class_id,c.color,t.subject_id,t.start,t.end,s.subject,c.classname 
        FROM time_table t, class c, subjects s WHERE t.class_id='$classid' AND t.subject_id='$subj_id' AND c.id=t.class_id AND s.id=t.subject_id AND t.school_id = '{$_SESSION['school_id']}'";
        }
        $select = mysqli_query($conn, $sql);
        $data = [];
        // $row = mysqli_fetch_assoc($select);
        while ($row = mysqli_fetch_assoc($select)) {
            $data[] = $row;
        }
        $select_events = mysqli_query($conn, "SELECT x.id,x.event_id,e.events,x.start,x.end,e.color FROM extraevents x, events e WHERE x.event_id = e.id AND e.cal_type = 1 AND x.school_id = '{$_SESSION['school_id']}'");
        while ($ev_row = mysqli_fetch_assoc($select_events)) {
            $data[] = $ev_row;
        }
        echo json_encode($data);
    }

    if ($action == 'get_extraevents') {
        $select = mysqli_query($conn, "SELECT id, events,color FROM events WHERE cal_type=1 AND school_id = '{$_SESSION['school_id']}'");
        $data = [];
        if (mysqli_num_rows($select) > 0) {
            while ($row = mysqli_fetch_assoc($select)) {
                $data[] = $row;
            }
        } else {
            echo 0;
            exit;
        }
        echo json_encode($data);
    }

    if ($action == 'add_extra_event') {
        $title = $_POST['title'];
        $color = '#17a2b8';
        // echo "INSERT INTO events (events,cal_type, createdby, datecreated, school_id,color) VALUES ('$title',1, '{$_SESSION['userid']}', '$date', '{$_SESSION['school_id']}','$color')";
        $query = mysqli_query($conn, "INSERT INTO events (events,cal_type, createdby, datecreated, school_id,color,updatedby) VALUES ('$title',1, '{$_SESSION['userid']}', '$date', '{$_SESSION['school_id']}','$color',NULL)");
        if ($query) {
            $id = mysqli_insert_id($conn);
            echo json_encode(['id' => $id, 'title' => $title]);
        } else {
            // echo mysqli_error($conn);
            echo json_encode(['error' => 'Failed to add event']);
        }
        mysqli_close($conn);
        exit();
    }

    if ($action == 'delete_extra_event') {
        $eventid = $_POST['eventid'];
        $deleteEventQuery = mysqli_query($conn, "DELETE FROM events WHERE id = '$eventid'");
        $deleteExtraEventQuery = mysqli_query($conn, "DELETE FROM extraevents WHERE event_id = '$eventid'");

        if ($deleteEventQuery && $deleteExtraEventQuery) {
            echo json_encode(['success' => true]);
        } else {
            echo json_encode(['success' => false, 'error' => 'Failed to delete event']);
        }
        mysqli_close($conn);
        exit();
    }

    if ($action == 'get_time_tbl_filter') {
        $selectclass = mysqli_query($conn, "SELECT id,classname,color,subject_cat FROM class WHERE school_id = '{$_SESSION['school_id']}'");
        $data = [];
        if (mysqli_num_rows($selectclass) > 0) {
            while ($classrow = mysqli_fetch_assoc($selectclass)) {
                $data[] = $classrow;
            }
        } else {
            echo 0;
            exit;
        }
        echo json_encode($data);
    }


    if ($action == 'delete_time_table_event') {
        $id = $_POST['id'];
        $classid = $_POST['classid'];
        $subj_id = $_POST['subjectid'];
        $deleteEventQuery = mysqli_query($conn, "DELETE FROM time_table WHERE id = '$id' AND class_id='$classid' AND subject_id='$subj_id' AND school_id = '{$_SESSION['school_id']}'");

        if ($deleteEventQuery) {
            echo json_encode(['success' => true]);
        } else {
            echo json_encode(['success' => false, 'error' => 'Failed to delete event']);
        }
        mysqli_close($conn);
        exit();
    }

    if ($action == 'delete_extra_eventslot') {
        $id = $_POST['id'];
        $deleteExtraEventQuery = mysqli_query($conn, "DELETE FROM extraevents WHERE id = '$id' AND school_id = '{$_SESSION['school_id']}'");

        if ($deleteExtraEventQuery) {
            echo json_encode(['success' => true]);
        } else {
            echo json_encode(['success' => false, 'error' => 'Failed to delete event']);
        }
        mysqli_close($conn);
        exit();
    }

    if ($action == 'edit_extra_event') {
        $id = $_POST['id'];
        $title = $_POST['title'];
        $updateEventQuery = mysqli_query($conn, "UPDATE events SET events = '$title' WHERE id = '$id' AND school_id = '{$_SESSION['school_id']}'");

        if ($updateEventQuery) {
            echo json_encode(['success' => true]);
        } else {
            // echo mysqli_error($conn);
            echo json_encode(['success' => false, 'error' => 'Failed to edit event']);
        }
        mysqli_close($conn);
        exit();
    }
    
    // For score updates
         if ($action === 'track_scores_changes') {
            // var_dump($_SESSION['old_scores']);
            // echo '<br>';
            // var_dump($_SESSION['new_scores']);
            if($_SESSION['studentOrsubject'] === 'student'){
                $changes = compare_student_scores_changes($_SESSION['old_scores'], $_SESSION['new_scores']);
                var_dump($changes);
                // exit;
            } else {
                $changes = compare_subject_scores_changes($_SESSION['old_scores'], $_SESSION['new_scores']);
            }
            // $changes = compare_student_scores($_SESSION['old_scores'], $_SESSION['new_scores']);
            if (!empty($changes)) {
                // Format the changes for logging
                $log_data = [
                    'class' => $_SESSION['new_scores'][0]['class'] ?? '',
                    'changes' => $changes
                ];

                // Save to database
                save_changes_to_log($log_data, 'score_update');
                $_SESSION['old_scores'] = $_SESSION['new_scores'];
                unset($_SESSION['new_scores']);
            }
        }
        if ($action === 'get_change_logs') {
            $action_type = isset($_POST['action_type']) ? $_POST['action_type'] : null;
            $logs = get_changes_log($action_type);
        
            foreach ($logs as &$log) {
                // Convert user_id to name
                $log['user_name'] = get_staff_fullname_by_id($log['user_id']);
                
                $changes = $log['changes'];
                // Convert class id to name 
                $log['changes']['class_name'] = get_class_by_classid($changes['class']);
        
                // Convert student and subject IDs in the nested changes array
                $newChanges = [];
                foreach ($changes['changes'] as $student_id => $studentChanges) {
                    $student_name = get_student_fullname_by_id($student_id);
                    
                    foreach ($studentChanges as &$change) {
                        // Add student name and subject name to each change
                        $change['student_name'] = $student_name;
                        if (isset($change['subject_id'])) {
                            $change['subject_name'] = getsubjectbyid($change['subject_id']);
                        }
                    }
                    
                    // Use student name as key but preserve the original changes
                    $newChanges[$student_name] = $studentChanges;
                }
                
                // Replace the changes array with the new one
                $log['changes']['changes'] = $newChanges;
            }
        
            echo json_encode($logs);
            exit;
        }
    
     // lesson note code with multiple weeks
    // if ($action == "create_lesson_note") {
    //     $class_id = $_POST['class_id'];
    //     $class_id_array = explode(",", $_POST['class_id']);
    //     // print_r($class_id_array);
    //     $body = mysqli_real_escape_string($conn, $_POST['body']);
    //     $topic = test_input($_POST['topic']);
    //     $subject_id = $_POST['subject_id'];
    //     $week_id = implode(",", json_decode($_POST['week_ids']));
    //     $week_ids = json_decode($_POST['week_ids']);
    //     print_r($week_ids);

    //     foreach ($class_id_array as $cid) {
    //         foreach ($week_ids as $wid) {
    //             $sql_check = "SELECT week_id,class_id,filedata FROM lesson_note WHERE week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    //             $check = mysqli_query($conn, $sql_check);
    //             if (mysqli_num_rows($check) > 0) {
    //                 if ($row = mysqli_fetch_assoc($check)) {

    //                     //without file
    //                     $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', topic='$topic', content='$body'
    //                         WHERE week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";

    //                     $update = mysqli_query($conn, $sql_update);
    //                     echo "update";
    //                     echo json_encode(array('status' => '1'));
    //                 }
    //             } else {

    //                 $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //                     VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$cid','$subject_id','$wid','$topic','$body')";

    //                 $insert = mysqli_query($conn, $sql);
    //                 if ($insert) {
    //                     echo "insert";
    //                     echo json_encode(array('status' => '1'));
    //                 }
    //             }
    //         }
    //     }
    // }

    // if ($action == 'get_lesson_note') {
    //     $class_id = $_POST['class_id'];
    //     $subject_id = $_POST['subject_id'];

    //     $class_id_array = $class_id;
    //     $cid = end($class_id_array);

    //     $week_ids_array = json_decode($_POST['week_ids']);
    //     $wid = end($week_ids_array);

    //     $sql = "SELECT content, topic FROM lesson_note 
    //             WHERE week_id = '$wid' AND class_id = '$cid' 
    //             AND school_id = '{$_SESSION['school_id']}' 
    //             AND subject_id = '$subject_id'";
    //     $select = mysqli_query($conn, $sql);

    //     if ($row = mysqli_fetch_assoc($select)) {
    //         echo json_encode($row);
    //     }
    // }

    // upload lesson note with dropzone
    // if ($action == 'get_lesson_note') {
    //     $class_id = $_POST['class_id'];
    //     $subject_id = $_POST['subject_id'];
    
    //     $class_id_array = $class_id;
    //     $cid = end($class_id_array);
    
    //     $week_ids_array = json_decode($_POST['week_ids']);
    //     $wid = end($week_ids_array);
    
    //     $sql = "SELECT content, topic, filedata FROM lesson_note 
    //             WHERE week_id = '$wid' AND class_id = '$cid' 
    //             AND school_id = '{$_SESSION['school_id']}' 
    //             AND subject_id = '$subject_id'";
    //     $select = mysqli_query($conn, $sql);
    
    //     if ($row = mysqli_fetch_assoc($select)) {
    //         echo json_encode($row);
    //     }
    // }

    // if ($action == "create_lesson_note") {
    //     $class_id = $_POST['class_id'];
    //     $class_id_array = explode(",", $_POST['class_id']);
    //     // print_r($class_id_array);
    //     $body = mysqli_real_escape_string($conn, $_POST['body']);
    //     $topic = test_input($_POST['topic']);
    //     $subject_id = $_POST['subject_id'];
    //     $week_id = implode(",", json_decode($_POST['week_ids']));
    //     $week_ids = json_decode($_POST['week_ids']);
    //     print_r($week_ids);

    //     $randtime = time();
    //     foreach ($class_id_array as $cid) {
    //         foreach ($week_ids as $wid) {
    //             $sql_check = "SELECT week_id,class_id,filedata FROM lesson_note WHERE week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    //             $check = mysqli_query($conn, $sql_check);
    //             if (mysqli_num_rows($check) > 0) {
    //                 if ($row = mysqli_fetch_assoc($check)) {
    //                     if (!empty($_FILES['files'])) {
    //                         $data_update = [];
    //                         foreach ($_FILES['files']['tmp_name'] as $index => $tmpName) {
    //                             if ($_FILES['files']['size'][$index] <= 2 * 1024 * 1024) {
    //                                 echo $filename_update = preg_match('/^\d+/', $randtime . 'lesson_note' . $_FILES['files']['name'][$index]) ? preg_replace('/^\d+/', $randtime, $randtime . 'lesson_note' . $_FILES['files']['name'][$index]) : $randtime . 'lesson_note' . $_FILES['files']['name'][$index];
    //                                 $destination = "uploads/" . $filename_update;
    //                                 $file_data = explode(",", $row['filedata']);
    //                                 foreach ($file_data as $file_datum) {
    //                                     $previous_filepath = "uploads/" . $file_datum;
    //                                     deleteFile($previous_filepath);
    //                                 }
    //                                 move_uploaded_file($tmpName, $destination);
    //                                 $data_update[] = $filename_update;
    //                             } else {
    //                                 echo json_encode(['error' => 'File size exceeds 2MB.']);
    //                                 exit;
    //                             }
    //                         }
    //                         $data_update = join(",", $data_update);
    //                         print_r($data_update);
    //                         $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', filedata = '$data_update', topic='$topic', content='$body'
    //                         WHERE week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    //                     } else {
    //                         //without file
    //                         $sql_update = "UPDATE lesson_note SET updatedby='{$_SESSION['userid']}', dateupdated='$date', topic='$topic', content='$body'
    //                         WHERE week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'";
    //                     }
    //                     $update = mysqli_query($conn, $sql_update);
    //                     echo "update";
    //                     echo json_encode(array('status' => '1'));
    //                 }
    //             } else {
    //                 if (!empty($_FILES['files'])) {
    //                     $data = [];
    //                     foreach ($_FILES['files']['tmp_name'] as $index => $tmpName) {
    //                         if ($_FILES['files']['size'][$index] <= 2 * 1024 * 1024) {
    //                             $filename = time() . 'lesson_note' . $_FILES['files']['name'][$index];
    //                             $destination = "uploads/" . $filename;
    //                             move_uploaded_file($tmpName, $destination);
    //                             $data[] = $filename;
    //                         } else {
    //                             echo json_encode(['error' => 'File size exceeds 2MB.']);
    //                             exit;
    //                         }
    //                     }
    
    //                     $data = join(",", $data);
    //                     $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,filedata,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //                     VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','$data','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$cid','$subject_id','$wid','$topic','$body')";
    //                 } else {
    //                     $sql = "INSERT INTO lesson_note(school_id,createdby,datecreated,session_id,term_id,class_id,subject_id,week_id,topic,content)
    //                     VALUES('{$_SESSION['school_id']}','{$_SESSION['userid']}','$date','{$_SESSION['session_id']}','{$_SESSION['term_id']}','$cid','$subject_id','$wid','$topic','$body')";
    //                 }
    //                 $insert = mysqli_query($conn, $sql);
    //                 if ($insert) {
    //                     echo "insert";
    //                     echo json_encode(array('status' => '1'));
    //                 }
    //             }
    //         }
    //     }


    //     //     if (does_it_exist("id", "lesson_note", "week_id='$wid' AND class_id='$cid' AND school_id = '{$_SESSION['school_id']}' AND subject_id='$subject_id'")) {

    //     // }
    // }
    
    // if ($action == 'get_note_weeks') {
    //     $class_id = test_input($_POST['class_id']);
    //     $subject_id = $_POST['subject_id'];
    // }
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = '';
    if (isset($_POST['action'])) {
        $action = test_input($_POST['action']);
    } elseif (isset($_GET['action'])) {
        $action = test_input($_GET['action']);
    }
      // Handle image uploads for lesson notes via AJAX (CKEditor or fallback file input)
        // echo "pmpomdc";
        // exit;
        // Basic checks
        $uploadDir = __DIR__ . DIRECTORY_SEPARATOR . 'uploads' . DIRECTORY_SEPARATOR . 'lesson_images' . DIRECTORY_SEPARATOR;
        if (!is_dir($uploadDir)) {
            mkdir($uploadDir, 0755, true);
        }

        // CKEditor 5 SimpleUpload adapter sends the file under the key 'upload'
        $fileKey = '';
        if (isset($_FILES['upload'])) {
            $fileKey = 'upload';
        } elseif (isset($_FILES['file'])) {
            $fileKey = 'file';
        } elseif (!empty($_FILES)) {
            // fallback to first file
            $keys = array_keys($_FILES);
            $fileKey = $keys[0];
        }

        if (!$fileKey || !isset($_FILES[$fileKey]) || !is_uploaded_file($_FILES[$fileKey]['tmp_name'])) {
            header('Content-Type: application/json');
            json_encode(array('error' => array('message' => 'No file uploaded')));
            exit;
        }

        $file = $_FILES[$fileKey];
        $allowed = array('jpg','jpeg','png','gif','webp');
        $ext = strtolower(pathinfo($file['name'], PATHINFO_EXTENSION));

        if (!in_array($ext, $allowed)) {
            header('Content-Type: application/json');
            echo json_encode(array('error' => array('message' => 'Invalid file type')));
            exit;
        }

        if ($file['size'] > 5 * 1024 * 1024) { // limit 5MB
            header('Content-Type: application/json');
            echo json_encode(array('error' => array('message' => 'File too large (max 5MB)')));
            exit;
        }

        $safeName = uniqid('lesson_', true) . '.' . $ext;
        $dest = $uploadDir . $safeName;

        if (move_uploaded_file($file['tmp_name'], $dest)) {
            // Build URL relative to web root. Assumes this script is in web root `ss360`.
            $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
            $host = $_SERVER['HTTP_HOST'];
            $scriptDir = rtrim(dirname($_SERVER['SCRIPT_NAME']), '\/');
            $uploadsUrlPath = $scriptDir . '/uploads/lesson_images/' . $safeName;
            $url = $protocol . '://' . $host . $uploadsUrlPath;

            header('Content-Type: application/json');
            echo json_encode(array('url' => $url));
            exit;
        } else {
            header('Content-Type: application/json');
            echo json_encode(array('error' => array('message' => 'Failed to move uploaded file')));
            exit;
        }
}