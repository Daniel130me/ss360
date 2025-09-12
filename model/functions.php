<?php
// error_reporting(E_ALL);
$date = date("Y-m-d H:i:s");
function getSSessionName($id) {
    global $conn;
    $query = "SELECT session FROM sessions WHERE id = '$id'";
    $result = mysqli_query($conn, $query);
    if ($result) {
        $row = mysqli_fetch_assoc($result);
        return $row['session'] ?? 'Unknown Session';
    }
    return 'Unknown Session';
}

function getTermName($id) {
    switch ($id) {
        case 1:
            return 'First Term';
        case 2:
            return 'Second Term';
        case 3:
            return 'Third Term';
        default:
            return 'Unknown Term';
    }
}
function get_class_id_by_student_id($student_id) {
    global $conn;
    $select = mysqli_query($conn, "SELECT class_id FROM students WHERE id='$student_id' AND school_id='{$_SESSION['school_id']}'");
    if ($row = mysqli_fetch_array($select)) {
        return $row['class_id'];
    } else {
        return null; // Or handle the case where no class is found for the student
    }
}
function get_lateness_time()
{
    global $conn;
    $query = "SELECT att_lateness_time FROM school WHERE id = '{$_SESSION['school_id']}'";
    $result = mysqli_query($conn, $query);
    if ($result) {
        $row = mysqli_fetch_assoc($result);
        return $row['att_lateness_time'] ?? '08:00'; // Return '08:00' (8:00AM) if no record found
    }
    return '08:00'; // Return '08:00' if query fails
}
function get_changes_log($action_type = null, $limit = 50) {
    global $conn;
    
    $school_id = $_SESSION['school_id'];
    $query = "SELECT * FROM change_log 
              WHERE school_id = '$school_id' ";
              
    if ($action_type) {
        $query .= "AND action_type = '$action_type' ";
    }
    
    $query .= "ORDER BY timestamp DESC LIMIT $limit";
    
    
    $result = mysqli_query($conn, $query);
    
    $logs = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $row['changes'] = json_decode($row['changes'], true);
        $logs[] = $row;
    }
    
    return $logs;
}
function save_changes_to_log($changes, $action_type) {
    global $conn, $date;
    
    // Prepare the data
    $session_id = $_SESSION['session_id'];
    $term_id = $_SESSION['term_id'];
    $user_id = $_SESSION['userid'] ?? '0';
    $school_id = $_SESSION['school_id'] ?? '0';
    // $timestamp = date("Y-m-d H:i:s");
    
    // Convert changes array to JSON
    $changes_json = json_encode($changes, JSON_PRETTY_PRINT);
    // var_dump($changes_json);
    
    $query = "INSERT INTO change_log (user_id,session_id,term_id, action_type, changes, timestamp, school_id) 
              VALUES ('$user_id','$session_id','$term_id','$action_type', '$changes_json', '$date', '$school_id')";
              
    $result = mysqli_query($conn, $query);
    
    return $result;
}

function compare_staff_changes($old_data, $new_data) {
    $changes = [];
    
    // Fields to track (excluding technical fields like passwords, tokens etc)
    $tracked_fields = [
        'firstname' => 'First Name',
        'lastname' => 'Last Name', 
        'middlename' => 'Middle Name',
        'gender' => 'Gender',
        'phone' => 'Phone Number',
        'email' => 'Email',
        'address' => 'Address',
        'city' => 'City',
        'state' => 'State',
        'country' => 'Country',
        'staff_type' => 'Staff Role',
        'status' => 'Status'
    ];

    foreach ($tracked_fields as $field => $label) {
        // Check if field exists in both arrays
        if (isset($old_data[$field]) && isset($new_data[$field])) {
            $old_value = trim($old_data[$field]);
            $new_value = trim($new_data[$field]);
            
            // Compare values
            if ($old_value !== $new_value) {
                // Special handling for staff_type/staff_role
                if ($field === 'staff_type' && isset($new_data['staff_role'])) {
                    $new_value = $new_data['staff_role'];
                }
                
                $changes[$field] = [
                    'field' => $label,
                    'old' => $old_value,
                    'new' => $new_value
                ];
            }
        }
    }

    return $changes;
}

function compare_student_scores_changes($old_scores, $new_scores) {
    $changes = [];
    
    // Create lookup array for old scores by subject_id
    $old_scores_lookup = [];
    foreach ($old_scores as $old_score) {
        $old_scores_lookup[$old_score['subject_id']] = $old_score;
    }
    
    // Compare each new score entry
    foreach ($new_scores as $new_score) {
        // Skip entries with 'NAN'
        if ($new_score['subjectOrNameId'] === 'NAN') {
            continue;
        }
        
        $subject_id = $new_score['subjectOrNameId'];
        $student_id = $new_score['studentId'];
        
        // Track components to compare
        $components = [
            'ca1' => 'CA1 Score',
            'ca1Total' => 'CA1 Total Possible',
            'ca2' => 'CA2 Score', 
            'ca2Total' => 'CA2 Total Possible',
            'ca3' => 'CA3 Score',
            'ca3Total' => 'CA3 Total Possible',
            'pra' => 'Practical Score',
            'praTotal' => 'Practical Total Possible', 
            'exam' => 'Exam Score',
            'examTotal' => 'Exam Total Possible'
        ];

        $student_changes = [];

        // Check if we have old scores for this subject
        if (isset($old_scores_lookup[$subject_id])) {
            $old_score = $old_scores_lookup[$subject_id];
            
            // Compare each score component
            foreach ($components as $key => $label) {
                $new_key = $key;
                if ($key === 'pra') $new_key = 'practical';
                if ($key === 'praTotal') $new_key = 'practicalTotal';
                
                $old_value = isset($old_score[$key]) ? (int)$old_score[$key] : 0;
                $new_value = isset($new_score[$new_key]) ? (int)$new_score[$new_key] : 0;

                // Record changes if values are different
                if ($old_value !== $new_value) {
                    $student_changes[] = [
                        'field' => $label,
                        'student_id' => $student_id,
                        'subject_id' => $subject_id,
                        'old' => $old_value,
                        'new' => $new_value,
                        'change_type' => 'update'
                    ];
                }
            }
        } else {
            // This is a new score entry - record all non-zero values
            foreach ($components as $key => $label) {
                $new_key = $key;
                if ($key === 'pra') $new_key = 'practical';
                if ($key === 'praTotal') $new_key = 'practicalTotal';
                
                $new_value = isset($new_score[$new_key]) ? (int)$new_score[$new_key] : 0;
                if ($new_value !== 0) {
                    $student_changes[] = [
                        'field' => $label,
                        'student_id' => $student_id,
                        'subject_id' => $subject_id,
                        'old' => 'Not previously set',
                        'new' => $new_value,
                        'change_type' => 'new_entry'
                    ];
                }
            }
        }
        
        // Store changes by student_id instead of subject_id
        if (!empty($student_changes)) {
            if (!isset($changes[$student_id])) {
                $changes[$student_id] = [];
            }
            $changes[$student_id] = array_merge($changes[$student_id], $student_changes);
        }
    }
    
    return $changes;
}


function compare_subject_scores_changes($old_scores, $new_scores) {
    $changes = [];
    
    // Create lookup array for old scores by student_id
    $old_scores_lookup = [];
    foreach ($old_scores as $old_score) {
        $old_scores_lookup[isset($old_score['student_id']) ? $old_score['student_id']  : $old_score['subjectOrNameId'] ] = $old_score;
    }
    
    // Compare each new score entry
    foreach ($new_scores as $new_score) {
        // Skip entries with 'NAN' 
        if ($new_score['subjectOrNameId'] === 'NAN') {
            continue;
        }
        
        $student_id = $new_score['subjectOrNameId'];
        $subject_id = $new_score['subjectId'];
        $student_changes = [];
        
        // Check if student existed in old scores
        if (isset($old_scores_lookup[$student_id])) {
            $old_score = $old_scores_lookup[$student_id];
            
            // Compare each component
            $components = [
                'ca1' => 'CA1 Score',
                'ca1Total' => 'CA1 Total Possible',
                'ca2' => 'CA2 Score',
                'ca2Total' => 'CA2 Total Possible',
                'ca3' => 'CA3 Score',
                'ca3Total' => 'CA3 Total Possible',
                'pra' => 'Practical Score', 
                'praTotal' => 'Practical Total Possible',
                'exam' => 'Exam Score',
                'examTotal' => 'Exam Total Possible'
            ];

            foreach ($components as $key => $label) {
                $old_value = isset($old_score[$key]) ? (int)$old_score[$key] : 0;
                $new_value = isset($new_score[$key]) ? (int)$new_score[$key] : 0;

                if ($old_value !== $new_value) {
                    $student_changes[] = [
                        'field' => $label,
                        'student_id' => $student_id,
                        'subject_id' => $subject_id,
                        'old' => $old_value,
                        'new' => $new_value,
                        'change_type' => 'update'
                    ];
                }
            }
        } else {
            // This is a new score entry - record all non-zero values as changes
            $components = [
                'ca1' => 'CA1 Score',
                'ca1Total' => 'CA1 Total Possible', 
                'ca2' => 'CA2 Score',
                'ca2Total' => 'CA2 Total Possible',
                'ca3' => 'CA3 Score', 
                'ca3Total' => 'CA3 Total Possible',
                'pra' => 'Practical Score',
                'praTotal' => 'Practical Total Possible',
                'exam' => 'Exam Score',
                'examTotal' => 'Exam Total Possible'
            ];

            foreach ($components as $key => $label) {
                $new_value = isset($new_score[$key]) ? (int)$new_score[$key] : 0;
                if ($new_value !== 0) {
                    $student_changes[] = [
                        'field' => $label,
                        'student_id' => $student_id,
                        'subject_id' => $subject_id,
                        'old' => 'Not previously set',
                        'new' => $new_value,
                        'change_type' => 'new_entry'
                    ];
                }
            }
        }

        // Add student changes if any found
        if (!empty($student_changes)) {
            $changes[$student_id] = $student_changes;
        }
    }
    
    return $changes;
}

function test_input($data)
{
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}



// function getclassbyid($id) {
//     global $conn;
//     $select  = mysqli_query($conn, "SELECT classname FROM class WHERE id='$id'");
//     $row = mysqli_fetch_array($select);
//     return $row['classname'];
// } 
function get_female_students()
{
    global $conn;
    $select = mysqli_query($conn, "SELECT COUNT(*) AS total_female_students FROM students WHERE gender='female' AND school_id='{$_SESSION['school_id']}'");
    $row = mysqli_fetch_array($select);
    return $row['total_female_students'];
}
function get_male_students()
{
    global $conn;
    $select = mysqli_query($conn, "SELECT COUNT(*) AS total_male_students FROM students WHERE gender='male' AND school_id='{$_SESSION['school_id']}'");
    $row = mysqli_fetch_array($select);
    return $row['total_male_students'];
}
function get_total_staff()
{
    global $conn;
    $select = mysqli_query($conn, "SELECT COUNT(*) AS total_staff FROM staff WHERE school_id='{$_SESSION['school_id']}'");
    $row = mysqli_fetch_array($select);
    return $row['total_staff'];
}
function get_total_parent()
{
    global $conn;
    $select = mysqli_query($conn, "SELECT COUNT(*) AS total_parent FROM parent WHERE school_id='{$_SESSION['school_id']}'");
    $row = mysqli_fetch_array($select);
    return $row['total_parent'];
}
function get_no_of_student_by_id($id)
{
    global $conn;
    $select = mysqli_query($conn, "SELECT COUNT(*) AS total_student FROM students WHERE class_id='$id' AND school_id='{$_SESSION['school_id']}'");
    $row = mysqli_fetch_array($select);
    return $row['total_student'];
}
function get_no_of_teacher_by_id($id)
{
    // return $id;
    global $conn;
    $select = mysqli_query($conn, "SELECT COUNT(*) AS total_teacher FROM staff WHERE class_id='$id' AND school_id='{$_SESSION['school_id']}'");
    $row = mysqli_fetch_array($select);
    return $row['total_teacher'];
}


function getsubjectbyid($id)
{
    global $conn;
    $select  = mysqli_query($conn, "SELECT subject FROM subjects WHERE id='$id'");
    $row = mysqli_fetch_array($select);
    return $row['subject'];
}
function get_class_by_classid($id)
{
    global $conn;
    $select = mysqli_query($conn, "SELECT classname, id FROM class WHERE id='$id' AND school_id='{$_SESSION['school_id']}'");
    $row = mysqli_fetch_array($select);
    return $row['classname'];
}
// get student fullname by id
function get_student_fullname_by_id($id)
{
    global $conn;
    $select = mysqli_query($conn, "SELECT firstname,lastname,middlename FROM students WHERE id='$id'");
    $row = mysqli_fetch_array($select);
    return $row['firstname'] . ' ' . $row['lastname'] . ' ' . $row['middlename'];
}
function get_staff_type_in_name($id)
{
    global $conn;
    $select = mysqli_query($conn, "SELECT type FROM staff_type WHERE id='$id'");
    $row = mysqli_fetch_array($select);
    return $row['type'];
}
function get_staff_fullname_by_id($id)
{
    global $conn;
    $select = mysqli_query($conn, "SELECT firstname,lastname,middlename FROM staff WHERE id='$id'");
    $row = mysqli_fetch_array($select);
    return $row['firstname'] . ' ' . $row['lastname'] . ' ' . $row['middlename'];
}
function get_parent_firstname_by_id($id)
{
    global $conn;
    $select = mysqli_query($conn, "SELECT type FROM firstname WHERE id='$id'");
    $row = mysqli_fetch_array($select);
    return $row['firstname'];
}

// function does_it_exist($what_to_select,$tbl,$condition) {
//     global $conn;
//     $select_query = mysqli_query($conn, "SELECT $what_to_select FROM $tbl WHERE {$condition}");
//     $ans = mysqli_num_rows($select_query) > 0 ? true : false;
//     return $ans;
// }
function does_it_exist($what_to_select, $tbl, $condition)
{
    global $conn;
    $select_query = mysqli_query($conn, "SELECT $what_to_select FROM $tbl WHERE {$condition}");
    if (!$select_query) {
        die('Error with the query: ' . mysqli_error($conn));
    }
    $ans = mysqli_num_rows($select_query) > 0 ? true : false;
    return $ans;
}

function calculate_age($birthdate)
{
    if($birthdate == '0000-00-00') {
        return 'Nil';
    }
    // return $birthdate;
    $birthDate = new DateTime($birthdate);
    $today = new DateTime('now');
    $age = $birthDate->diff($today);
    return $age->y;
}

function get_total_student_in_class($classid)
{
    global $conn;
    $selectclass = mysqli_query($conn, "SELECT COUNT(*) AS total_student FROM students WHERE class_id='$classid'AND school_id='{$_SESSION['school_id']}'");
    $row = mysqli_fetch_array($selectclass);
    return $row['total_student'];
}

// function get_total_score_per_student($studentid, $term_id, $session_id, $class_id)
// {
//     global $conn;
//     $select = mysqli_query($conn, "SELECT SUM(total) AS total_score FROM skulscores WHERE student_id='$studentid' AND term_id='$term_id' AND session_id='$session_id' AND class_id='$class_id' AND school_id='{$_SESSION['school_id']}'");
//     $row = mysqli_fetch_array($select);
//     return $row['total_score'];
// }

// function get_total_score_per_student($studentid, $term_id, $session_id, $class_id)
// {
//     global $conn;
//     $select = mysqli_query($conn, "SELECT SUM(total) AS total_score 
//         FROM skulscores 
//         WHERE student_id='$studentid' 
//         AND term_id='$term_id' 
//         AND session_id='$session_id' 
//         AND class_id='$class_id' 
//         AND school_id='{$_SESSION['school_id']}'
//         AND total > 0"); // Only sum scores greater than zero
    
//     $row = mysqli_fetch_array($select);
//     return $row['total_score'] ?? 0; // Return 0 if no scores found or if total_score is NULL
// }

function get_total_score_per_student($studentid, $term_id, $session_id, $class_id, $sessionOrTerm)
{
    global $conn;
    // $query = "SELECT SUM(total) AS total_score 
    //     FROM skulscores 
    //     WHERE student_id='$studentid' 
    //     AND session_id='$session_id' 
    //     AND class_id='$class_id' 
    //     AND school_id='{$_SESSION['school_id']}'
    //     AND total > 0"; // Only sum scores greater than zero
     $query = "SELECT SUM(total) AS total_score 
        FROM skulscores 
        WHERE student_id='$studentid' 
        AND session_id='$session_id' 
        AND class_id='$class_id' 
        AND school_id='{$_SESSION['school_id']}'
        AND (
            ca1Total > 0 OR
            ca2Total > 0 OR
            ca3Total > 0 OR
            praTotal > 0 OR
            examTotal > 0
        )"; // Only sum scores where at least one total is greater than zero

    if ($sessionOrTerm == 'term') {
        $query .= " AND term_id='$term_id'";
    }
    // else{
    //     $query .= " AND session_id='$session_id'";
    // }



    $select = mysqli_query($conn, $query);

    $row = mysqli_fetch_array($select);
    return $row['total_score'] ?? 0; // Return 0 if no scores found or if total_score is NULL
}

function get_comment_by_student($studentid, $term_id, $session_id, $class_id, $roletype, $comment_type)
{
    global $conn;
    $select = mysqli_query($conn, "SELECT comment FROM comment WHERE role_type='$roletype' AND comment_type='$comment_type' AND student_id='$studentid' AND term_id='$term_id' AND session_id='$session_id' AND class_id='$class_id' AND school_id='{$_SESSION['school_id']}'");
    $row = mysqli_fetch_array($select);
    if (mysqli_num_rows($select) > 0) {
        return $row['comment'];
    } else {
        return '';
    }
}

function get_total_obtainables($studentid, $term_id, $session_id, $class_id, $sessionOrTerm)
{
    global $conn;
    // $query = "SELECT COUNT(*) as subject_count 
    //     FROM skulscores 
    //     WHERE student_id='$studentid' 
    //     AND class_id='$class_id' 
    //     AND school_id='{$_SESSION['school_id']}'
    //     AND session_id='$session_id'
    //     AND total > 0"; // Only count subjects with scores greater than 0
$query = "SELECT COUNT(*) as subject_count 
        FROM skulscores 
        WHERE student_id='$studentid' 
        AND class_id='$class_id' 
        AND school_id='{$_SESSION['school_id']}'
        AND session_id='$session_id'
        AND total > 0
        AND (
            ca1Total > 0 OR
            ca2Total > 0 OR
            ca3Total > 0 OR
            praTotal > 0 OR
            examTotal > 0
        )"; // Only count subjects where at least one total is greater than zero and total > 0
// ubjects where at least one total is greater than zero

    if ($sessionOrTerm == 'term') {
        $query .= " AND term_id='$term_id'";
    }

    $select = mysqli_query($conn, $query);
    $row = mysqli_fetch_array($select);
    return $row['subject_count'] * 100; // Each subject has a maximum score of 100
}
// function get_total_obtainables($studentid, $term_id, $session_id, $class_id) {
//     global $conn;
//     $select = mysqli_query($conn, "SELECT COUNT(*) as subject_count FROM skulscores 
//         WHERE student_id='$studentid' 
//         AND term_id='$term_id' 
//         AND session_id='$session_id' 
//         AND class_id='$class_id' 
//         AND school_id='{$_SESSION['school_id']}'
//         AND total > 0"); // Only count subjects with scores greater than 0
//     $row = mysqli_fetch_array($select);
//     return $row['subject_count'] * 100; // Each subject has a maximum score of 100
// }

// function calculate_total_percentage($studentid, $term_id, $session_id, $class_id)
// {
//     global $conn;
//     $count = 0;
//     $total = 0;
//     $select = mysqli_query($conn, "SELECT total FROM skulscores WHERE student_id='$studentid' AND term_id='$term_id' AND session_id='$session_id' AND class_id='$class_id' AND school_id='{$_SESSION['school_id']}'");
//     while ($row = mysqli_fetch_array($select)) {
//         $total += $row['total'];
//         $count += 1;
//     }
//     // $total_obtainable = $count * 100;
//     $total_obtainable = get_total_obtainables($studentid, $term_id, $session_id, $class_id);
    
//     if ($count > 0) {
//         return number_format((($total / $total_obtainable) * 100),0,'.',"");
//     } else {
//         return 0;
//     }
// }
function calculate_total_percentage($studentid, $term_id, $session_id, $class_id, $sessionOrTerm)
{
    global $conn;
    $count = 0;
    $total = 0;
    $select = mysqli_query($conn, "SELECT total FROM skulscores WHERE student_id='$studentid' AND term_id='$term_id' AND session_id='$session_id' AND class_id='$class_id' AND school_id='{$_SESSION['school_id']}'");
    while ($row = mysqli_fetch_array($select)) {
        $total += $row['total'];
        $count += 1;
    }
    // $total_obtainable = $count * 100;
    $total_obtainable = get_total_obtainables($studentid, $term_id, $session_id, $class_id,$sessionOrTerm);

    if ($count > 0) {
        return number_format((($total / $total_obtainable) * 100), 0, '.', "");
    } else {
        return 0;
    }
}

function deleteFile($filePath)
{
    if (is_file($filePath)) { 
        if (unlink($filePath)) { 
            return true;
        } else {
            error_log("Failed to delete file: " . $filePath . " - " . error_get_last()['message']);
            return false;
        }
    } else {
       
        return false;
    }
}

function onboard_settings($phone, $email, $staff_type)
{
    global $conn, $date;
    $select = mysqli_query($conn, "SELECT id FROM staff WHERE phone='$phone' AND email='$email'");
    if ($row = mysqli_fetch_array($select)) {
        $_SESSION['userid'] = $row['id']; //id => 23, name => sola
        $_SESSION['phone'] = $phone;
        $_SESSION['email'] = $email;
        $_SESSION['staff_type'] = $staff_type;
        $update = mysqli_query($conn, "UPDATE school SET createdby='{$row['id']}' WHERE id='{$_SESSION['school_id']}'");
        $insertsetting = mysqli_query($conn, "INSERT INTO skul_settings (school_id,grading,datecreated,createdby) VALUES('{$_SESSION['school_id']}','{A:70,B:60,C:50,D:40,E:30,F:0}','$date','{$row['id']}')");
        $insertsub_cat = mysqli_query(
            $conn,
            "INSERT INTO subject_cat (category_name,createdby, datecreated,subject_ids,school_id) 
                    VALUES('Primary','{$row['id']}','$date','65,92,4,16,62,2,23,15,58,1,14,19','{$_SESSION['school_id']}')"
        );
        echo json_encode(array('status' => '1', 'location' => '../login'));
    }
}

function register_student_without_photo($pfname, $plname, $hashedpassword, $parentphone, $parentemail, $address, $city, $state, $country, $firstname, $lastname, $middlename, $class_id, $gender, $dob, $phone, $email, $school_id)
{
    global $conn, $date;
    if ($_FILES['studentphoto']['name'] == '') {
        $final_img = "avatar.png";
        $insertparent = mysqli_query($conn, "INSERT INTO parent(firstname,lastname,passw,phone, email, address,city,state,country, school_id)
            VALUES('$pfname','$plname','$hashedpassword','$parentphone','$parentemail','$address','$city', '$state','$country','$school_id')");
        if ($insertparent) {
            // echo 'here1';
            $selectparentid = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone' AND email='$parentemail' AND school_id='$school_id'");
            if ($row = mysqli_fetch_array($selectparentid)) {
                // echo 'here2';
                $parent_id = $row['id'];
                $insertstudent = mysqli_query($conn, "INSERT INTO students(photo,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
                VALUES('$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')");

                echo $insertstudent === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
            }
        }
        exit;
    }
}

function register_student_with_photo($pfname,$plname,$hashedpassword,$parentphone,$parentemail,$address,$city, $state,$country,$firstname,$lastname,$middlename,$class_id,$gender,$dob,$phone,$email,$school_id)
{
    global $conn, $date;
    $path = "uploads/";
    $valid_ext = array("jpg", "png", "jpeg");
    $img_name = $_FILES['studentphoto']['name'];
    $tmp = $_FILES['studentphoto']['tmp_name'];
    $ext = strtolower(pathinfo($img_name, PATHINFO_EXTENSION));
    $final_img = rand(10000, 1000000) . 'student' . $img_name;
    if (in_array($ext, $valid_ext)) {
        $path = $path . $final_img;
        if (move_uploaded_file($tmp, $path)) {
            // echo 'here0';

            $insertparent = mysqli_query($conn, "INSERT INTO parent(firstname,lastname,passw,phone, email, address,city,state,country, school_id)
                    VALUES('$pfname','$plname','$hashedpassword','$parentphone','$parentemail','$address','$city', '$state','$country','$school_id')");
            if ($insertparent) {
                // echo 'here1';
                $selectparentid = mysqli_query($conn, "SELECT id FROM parent WHERE phone='$parentphone' AND email='$parentemail' AND school_id='$school_id'");
                if ($row = mysqli_fetch_array($selectparentid)) {
                    // echo 'here2';
                    $parent_id = $row['id'];
                    $insertstudent = mysqli_query($conn, "INSERT INTO students(photo,firstname,lastname,middlename,class_id,gender,dob,phone,email,parent_id,school_id,datecreated,createdby) 
                        VALUES('$final_img','$firstname','$lastname','$middlename','$class_id','$gender','$dob','$phone','$email','$parent_id','$school_id','$date','{$_SESSION['userid']}')");

                    echo $insertstudent === true ? json_encode(array('status' => '1')) : mysqli_error($conn);
                }
            }
        }
    } else {
        echo "file format not supported";
    }
}

// Common validation functions
function validate_phone($phone) {
    return empty($phone) || preg_match('/^[0-9]{11}$/', $phone);
}

function validate_student_number($number) {
    return is_numeric($number) && $number > 0 && $number <= 10000;
}

function validate_session_id($session_id) {
    return in_array($session_id, [1, 2, 3]);
}

function validate_term_id($term_id) {
    return in_array($term_id, [1, 2, 3]);
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

function calculate_amount($student_number) {
    $amount_per_student = 500;
    return $student_number * $amount_per_student;
}

function sanitize_input($data) {
    return htmlspecialchars(strip_tags(trim($data)));
}

// Payment helper functions
function verify_flutterwave_payment($transaction_id) {
    $curl = curl_init();
    curl_setopt_array($curl, array(
        CURLOPT_URL => "https://api.flutterwave.com/v3/transactions/{$transaction_id}/verify",
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_HTTPHEADER => array(
            "Authorization: Bearer FLWSECK_TEST-52d53b2bb50091db282cc73d8306197c-X",
            "Content-Type: application/json"
        ),
    ));

    $response = curl_exec($curl);
    $err = curl_error($curl);
    curl_close($curl);

    if ($err) {
        return ['status' => 'error', 'message' => $err];
    }

    return ['status' => 'success', 'data' => json_decode($response)];
}

function save_payment_to_database($conn, $payment_data) {
    $query = "INSERT INTO payments (
        transaction_id, tx_ref, amount, email, phone, name, payment_date,
        school_id, session_id, term_id, student_number, payment_purpose,
        amount_per_student, payment_status
    ) VALUES (
        ?, ?, ?, ?, ?, ?, ?,
        ?, ?, ?, ?, ?,
        ?, ?
    )";

    $stmt = mysqli_prepare($conn, $query);
    if ($stmt) {
        mysqli_stmt_bind_param($stmt, 
            'ssdssssissssss',
            $payment_data['transaction_id'],
            $payment_data['tx_ref'],
            $payment_data['amount'],
            $payment_data['email'],
            $payment_data['phone'],
            $payment_data['name'],
            $payment_data['payment_date'],
            $payment_data['school_id'],
            $payment_data['session_id'],
            $payment_data['term_id'],
            $payment_data['student_number'],
            $payment_data['payment_purpose'],
            $payment_data['amount_per_student'],
            $payment_data['payment_status']
        );

        $result = mysqli_stmt_execute($stmt);
        mysqli_stmt_close($stmt);
        return $result;
    }
    
    return false;
}

// Error handling function
function handle_payment_error($message, $redirect = true) {
    if ($redirect) {
        header('Location: my_payment.php?status=error&message=' . urlencode($message));
        exit;
    }
    return ['status' => 'error', 'message' => $message];
}

function get_grade($percentage, $grading_system) {
    if (empty($grading_system)) {
        return 'N/A'; // Return Not Available if no grading system is defined
    }
    
    foreach ($grading_system as $grade => $min_score) {
        if ($percentage >= (float)$min_score) {
            return $grade;
        }
    }
    return array_key_first($grading_system); // return lowest grade from defined system
}


// function get_attendance_present($student_id, $term_id, $session_id) {
//     global $conn;
//     $query = "SELECT COUNT(DISTINCT att_date) as present_days 
//               FROM attendance 
//               WHERE student_id = '$student_id' 
//               AND term_id = '$term_id' 
//               AND session_id = '$session_id'";
//     $result = mysqli_query($conn, $query);
//     $row = mysqli_fetch_assoc($result);
//     return $row['present_days'] *2;
// }
function get_attendance_present($student_id, $term_id, $session_id)
{
    global $conn;
    $query  = "SELECT total_present FROM attendance_once WHERE student_id = '$student_id' AND term_id = '$term_id' AND session_id = '$session_id' AND school_id='{$_SESSION['school_id']}'";
    $result = mysqli_query($conn, $query);
    if ($result) {
        $row = mysqli_fetch_assoc($result);

        if (!$row) {
            $daily_query = "SELECT SUM(CASE WHEN first IS NOT NULL AND second IS NOT NULL THEN 2
            WHEN first IS NOT NULL THEN 1
            WHEN second IS NOT NULL THEN 1
            ELSE 0
            END) AS total_presence
            FROM attendance
            WHERE student_id = '$student_id'
            AND term_id = '$term_id'
            AND session_id = '$session_id'";
            $daily_result = mysqli_query($conn, $daily_query);
            // $row = mysqli_fetch_assoc($daily_result);
            if ($daily_result) {
                $daily_row = mysqli_fetch_assoc($daily_result);
                return $daily_row['total_presence'] ?? 10; // Return 0 if no records found
            } else {
                return 20; // Return 0 if query fails
            }
        } else {
            return $row['total_present'] ?? 30; // Return 0 if no records found
        }
    }
    // $query = "SELECT COUNT(*) as present_days

    // return $row['total_presence'];
}

function get_attendance_absent($student_id, $term_id, $session_id) {
    global $conn, $setrow;
    $present_days = get_attendance_present($student_id, $term_id, $session_id);
    $school_open = (int)$setrow['school_open'];
    return max(0, $school_open - $present_days);
}

function get_school_amount()
{
    global $conn;
    $query = "SELECT amount FROM school WHERE id = '{$_SESSION['school_id']}'";
    $result = mysqli_query($conn, $query);
    if ($result) {
        $row = mysqli_fetch_assoc($result);
        return (int)($row['amount'] ?? 0);
    }
    return 0;
}

// Function to get a student's score for a specific assessment from assessment_results table
function get_assessment_score($assessment_id, $student_id) {
    global $conn;
    $query = "SELECT score FROM assessment_results 
              WHERE assessment_id = '$assessment_id' 
              AND student_id = '$student_id'";
    $result = mysqli_query($conn, $query);
    if ($row = mysqli_fetch_assoc($result)) {
        return (int)$row['score'];
    }
    return 0;
}

function get_school_id_by_url($url) {
    global $conn;
    $query = "SELECT id FROM school WHERE url = '$url'";
    $result = mysqli_query($conn, $query);
    if ($row = mysqli_fetch_assoc($result)) {
        return (int)$row['id'];
    }
    return 0;
}

// function get_total_obtainables($studentid, $term_id, $session_id, $class_id) {
//     global $conn;
//     $select = mysqli_query($conn, "SELECT COUNT(*) as subject_count FROM skulscores 
//         WHERE student_id='$studentid' 
//         AND term_id='$term_id' 
//         AND session_id='$session_id' 
//         AND class_id='$class_id' 
//         AND school_id='{$_SESSION['school_id']}'");
//     $row = mysqli_fetch_array($select);
//     return $row['subject_count'] * 100; // Each subject has a maximum score of 100
// }

// function get_total_obtainables($studentid, $term_id, $session_id, $class_id) {
//     global $conn;
//     $select = mysqli_query($conn, "SELECT COUNT(*) as subject_count FROM skulscores 
//         WHERE student_id='$studentid' 
//         AND term_id='$term_id' 
//         AND session_id='$session_id' 
//         AND class_id='$class_id' 
//         AND school_id='{$_SESSION['school_id']}'
//         AND total > 0"); // Only count subjects with scores greater than 0
//     $row = mysqli_fetch_array($select);
//     return $row['subject_count'] * 100; // Each subject has a maximum score of 100
// }
?>