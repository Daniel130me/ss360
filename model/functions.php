<?php
// error_reporting(E_ALL);
require_once __DIR__ . '/report_card_columns.php';
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

function resolve_student_report_class_id($student_id, $session_id, $term_id, $requested_class_id, $school_id = null)
{
    global $conn;

    $student_id = (int)$student_id;
    $session_id = (int)$session_id;
    $requested_class_id = (int)$requested_class_id;
    $school_id = $school_id === null ? (int)($_SESSION['school_id'] ?? 0) : (int)$school_id;
    $term_id = (string)$term_id;
    $exact_term_id = $term_id === 'cum' ? '3' : (int)$term_id;
    $has_term_filter = $term_id === 'cum' || (ctype_digit($term_id) && (int)$term_id > 0);

    if ($student_id <= 0 || $session_id <= 0 || $school_id <= 0) {
        return $requested_class_id;
    }

    if ($requested_class_id > 0) {
        $requested_check = mysqli_query($conn, "SELECT id FROM skulscores
            WHERE school_id='$school_id' AND student_id='$student_id' AND session_id='$session_id'
            AND class_id='$requested_class_id'" . (!$has_term_filter || $term_id === 'cum' ? "" : " AND term_id='$exact_term_id'") . "
            LIMIT 1");

        if ($requested_check && mysqli_num_rows($requested_check) > 0) {
            return $requested_class_id;
        }
    }

    // If the student's current class has no score rows for this report period,
    // use the class stored on the historical score rows for the selected session/term.
    $resolve_query = "SELECT class_id, COUNT(*) AS score_rows
        FROM skulscores
        WHERE school_id='$school_id' AND student_id='$student_id' AND session_id='$session_id'";

    if ($has_term_filter && $term_id !== 'cum') {
        $resolve_query .= " AND term_id='$exact_term_id'";
    }

    $resolve_query .= " GROUP BY class_id ORDER BY score_rows DESC, class_id DESC LIMIT 1";
    $resolved = mysqli_query($conn, $resolve_query);

    if ($resolved && $row = mysqli_fetch_assoc($resolved)) {
        return (int)$row['class_id'];
    }

    return $requested_class_id;
}

function get_total_students_with_scores_in_class($class_id, $session_id, $term_id, $school_id = null)
{
    global $conn;

    $class_id = (int)$class_id;
    $session_id = (int)$session_id;
    $school_id = $school_id === null ? (int)($_SESSION['school_id'] ?? 0) : (int)$school_id;
    $term_id = (string)$term_id;
    $exact_term_id = $term_id === 'cum' ? '3' : (int)$term_id;

    if ($class_id <= 0 || $session_id <= 0 || $school_id <= 0) {
        return 0;
    }

    $query = "SELECT COUNT(DISTINCT student_id) AS total_student
        FROM skulscores
        WHERE school_id='$school_id' AND class_id='$class_id' AND session_id='$session_id'";

    if ($term_id !== 'cum') {
        $query .= " AND term_id='$exact_term_id'";
    }

    $select = mysqli_query($conn, $query);
    $row = mysqli_fetch_assoc($select);

    return (int)($row['total_student'] ?? 0);
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

function transport_admin_staff_types()
{
    return [1, 2, 3, 4];
}

function transport_current_school_id()
{
    return isset($_SESSION['school_id']) ? (int) $_SESSION['school_id'] : 0;
}

function transport_current_user_id()
{
    return isset($_SESSION['userid']) ? (int) $_SESSION['userid'] : 0;
}

function transport_is_staff_user()
{
    return isset($_SESSION['staff_type']);
}

function transport_is_admin()
{
    if (!transport_is_staff_user()) {
        return false;
    }

    return in_array((int) $_SESSION['staff_type'], transport_admin_staff_types(), true);
}

function transport_user_has_assigned_bus($staff_id = null, $school_id = null)
{
    if (!transport_is_staff_user()) {
        return false;
    }

    $staff_id = $staff_id === null ? transport_current_user_id() : (int) $staff_id;
    $school_id = $school_id === null ? transport_current_school_id() : (int) $school_id;

    if ($staff_id <= 0 || $school_id <= 0) {
        return false;
    }

    $row = transport_fetch_one(
        "SELECT id FROM school_buses
         WHERE school_id = ? AND status = 1
         AND (driver_staff_id = ? OR assistant_staff_id = ?)
         LIMIT 1",
        'iii',
        [$school_id, $staff_id, $staff_id]
    );

    return $row !== null;
}

function transport_stmt_bind($stmt, $types, $params)
{
    if ($types === '' || empty($params)) {
        return true;
    }

    $refs = [$stmt, $types];
    foreach ($params as $key => $value) {
        $refs[] = &$params[$key];
    }

    return call_user_func_array('mysqli_stmt_bind_param', $refs);
}

function transport_fetch_one($sql, $types = '', $params = [])
{
    global $conn;

    $stmt = mysqli_prepare($conn, $sql);
    if (!$stmt) {
        return null;
    }

    transport_stmt_bind($stmt, $types, $params);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    $row = $result ? mysqli_fetch_assoc($result) : null;
    mysqli_stmt_close($stmt);

    return $row ?: null;
}

function transport_parent_can_view_student($student_id)
{
    if (transport_is_staff_user()) {
        return false;
    }

    $row = transport_fetch_one(
        "SELECT id FROM students WHERE id = ? AND parent_id = ? AND school_id = ? LIMIT 1",
        'iii',
        [(int) $student_id, transport_current_user_id(), transport_current_school_id()]
    );

    return $row !== null;
}

function transport_staff_can_view_bus($bus_id)
{
    if (!transport_is_staff_user()) {
        return false;
    }

    $row = transport_fetch_one(
        "SELECT id FROM school_buses WHERE id = ? AND school_id = ? LIMIT 1",
        'ii',
        [(int) $bus_id, transport_current_school_id()]
    );

    return $row !== null;
}

function transport_staff_can_track_bus($bus_id)
{
    if (!transport_is_staff_user()) {
        return false;
    }

    if (transport_is_admin()) {
        return transport_staff_can_view_bus($bus_id);
    }

    $row = transport_fetch_one(
        "SELECT id FROM school_buses
         WHERE id = ? AND school_id = ? AND status = 1
         AND (driver_staff_id = ? OR assistant_staff_id = ?)
         LIMIT 1",
        'iiii',
        [(int) $bus_id, transport_current_school_id(), transport_current_user_id(), transport_current_user_id()]
    );

    return $row !== null;
}

function transport_parent_can_view_bus($bus_id, $student_id = null)
{
    if (transport_is_staff_user()) {
        return false;
    }

    $params = [transport_current_user_id(), transport_current_school_id(), (int) $bus_id];
    $types = 'iii';
    $student_filter = '';

    if ($student_id !== null) {
        $student_filter = ' AND s.id = ?';
        $types .= 'i';
        $params[] = (int) $student_id;
    }

    $row = transport_fetch_one(
        "SELECT bsa.id
         FROM bus_student_assignments bsa
         INNER JOIN students s ON s.id = bsa.student_id AND s.school_id = bsa.school_id
         WHERE s.parent_id = ? AND bsa.school_id = ? AND bsa.bus_id = ?
         AND bsa.status = 1{$student_filter}
         LIMIT 1",
        $types,
        $params
    );

    return $row !== null;
}

function transport_get_tracking_settings($school_id = null)
{
    $school_id = $school_id === null ? transport_current_school_id() : (int) $school_id;
    $defaults = [
        'update_interval_seconds' => 20,
        'stale_after_seconds' => 90,
        'min_movement_meters' => 30,
        'max_accuracy_meters' => 100,
        'history_retention_days' => 30,
    ];

    if ($school_id <= 0) {
        return $defaults;
    }

    $row = transport_fetch_one(
        "SELECT update_interval_seconds, stale_after_seconds, min_movement_meters,
                max_accuracy_meters, history_retention_days
         FROM bus_tracking_settings
         WHERE school_id = ? AND status = 1
         LIMIT 1",
        'i',
        [$school_id]
    );

    if (!$row) {
        return $defaults;
    }

    return [
        'update_interval_seconds' => max(15, (int) $row['update_interval_seconds']),
        'stale_after_seconds' => max(30, (int) $row['stale_after_seconds']),
        'min_movement_meters' => max(0, (int) $row['min_movement_meters']),
        'max_accuracy_meters' => max(20, (int) $row['max_accuracy_meters']),
        'history_retention_days' => max(1, (int) $row['history_retention_days']),
    ];
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
function get_default_report_template_config()
{
    return [
        'version' => 1,
        'template_name' => 'Default Report Card',
        'page' => [
            'size' => 'A4',
            'orientation' => 'portrait',
            'show_watermark' => true,
        ],
        'sections' => [
            ['key' => 'school_header', 'enabled' => true, 'order' => 1],
            ['key' => 'student_details', 'enabled' => true, 'order' => 2],
            ['key' => 'performance_summary', 'enabled' => true, 'order' => 3],
            ['key' => 'score_table', 'enabled' => true, 'order' => 4],
            ['key' => 'behaviour_skills', 'enabled' => true, 'order' => 5],
            ['key' => 'psychomotor_skills', 'enabled' => true, 'order' => 6],
            ['key' => 'grade_scale', 'enabled' => true, 'order' => 7],
            ['key' => 'skill_rating_indices', 'enabled' => true, 'order' => 8],
            ['key' => 'comments', 'enabled' => true, 'order' => 9],
            ['key' => 'signature_stamp', 'enabled' => true, 'order' => 10],
        ],
        'fields' => [
            'school_logo' => true,
            'school_name' => true,
            'school_address' => true,
            'school_phone' => true,
            'school_email' => true,
            'student_photo' => true,
            'student_name' => true,
            'admission_no' => true,
            'class' => true,
            'no_in_class' => true,
            'school_open' => true,
            'times_present' => true,
            'times_absent' => true,
            'next_term_begins' => true,
            'teacher_comment' => true,
            'head_teacher_comment' => true,
        ],
        'score_columns' => get_default_report_score_columns(),
        'available_cumulative_columns' => get_cumulative_report_score_columns(),
        'labels' => get_default_report_template_labels(),
    ];
}

function get_default_report_template_labels()
{
    return [
        'columns' => get_report_score_column_labels(),
        'sections' => [
            'performance_summary' => 'Performance Summary',
            'behaviour_skills' => 'General Behaviour',
            'psychomotor_skills' => 'Psychomotive Skills',
            'grade_scale' => 'Grade Scale',
            'skill_rating_indices' => 'Skill Rating Indices',
        ],
        'fields' => [
            'student_name' => 'NAME',
            'admission_no' => 'ADM. NO',
            'class' => 'CLASS',
            'no_in_class' => 'NO IN CLASS',
            'school_open' => 'NO OF TIMES SCHOOL OPENED',
            'times_present' => 'NO OF TIMES PRESENT',
            'times_absent' => 'NO OF TIMES ABSENT',
            'next_term_begins' => 'NEXT TERM BEGINS',
        ],
        'summary' => [
            'total_score' => 'TOTAL SCORE',
            'total_obtainable' => 'TOTAL OBTAINABLE',
            'percentage' => 'PERCENTAGE',
            'grade' => 'GRADE',
            'score_range' => 'Score Range',
            'grade_row' => 'Grade',
        ],
        'titles' => [
            'term_title' => '{term} TERM {session} ACADEMIC SESSION',
            'custom_report_title' => '{report_name} - {term} {session}',
        ],
    ];
}

function normalize_report_template_labels($labels)
{
    $default_labels = get_default_report_template_labels();
    if (!is_array($labels)) {
        return $default_labels;
    }

    // Older templates stored column labels as a flat key/value array.
    $has_grouped_labels = false;
    foreach (array_keys($default_labels) as $group) {
        if (isset($labels[$group]) && is_array($labels[$group])) {
            $has_grouped_labels = true;
            break;
        }
    }
    if (!$has_grouped_labels) {
        $labels = ['columns' => $labels];
    }

    $normalized = $default_labels;
    foreach ($default_labels as $group => $group_labels) {
        if (!isset($labels[$group]) || !is_array($labels[$group])) {
            continue;
        }
        foreach ($group_labels as $key => $fallback_label) {
            if (isset($labels[$group][$key]) && trim((string)$labels[$group][$key]) !== '') {
                $normalized[$group][$key] = trim((string)$labels[$group][$key]);
            }
        }
    }

    return $normalized;
}

function report_card_template_label($template, $group, $key, $fallback = '')
{
    $labels = normalize_report_template_labels($template['labels'] ?? []);
    if (isset($labels[$group][$key]) && trim((string)$labels[$group][$key]) !== '') {
        return $labels[$group][$key];
    }
    return $fallback;
}

function render_report_template_text($text, $tokens = [])
{
    $text = (string)$text;
    foreach ($tokens as $key => $value) {
        $text = str_replace('{' . $key . '}', (string)$value, $text);
    }
    return $text;
}

function get_report_template_allowed_sections()
{
    return [
        'school_header',
        'student_details',
        'performance_summary',
        'score_table',
        'behaviour_skills',
        'psychomotor_skills',
        'grade_scale',
        'skill_rating_indices',
        'comments',
        'signature_stamp',
    ];
}

function get_report_template_allowed_score_columns()
{
    return get_report_score_column_keys();
}

function normalize_report_template_term_id($term_id)
{
    $term_id = trim((string)$term_id);
    $allowed_terms = ['default', '1', '2', '3', 'cumulative'];
    return in_array($term_id, $allowed_terms, true) ? $term_id : 'default';
}

function normalize_report_template_config($template)
{
    if (is_string($template)) {
        $template = json_decode($template, true);
    }

    $default_template = get_default_report_template_config();
    if (!is_array($template)) {
        return $default_template;
    }

    $allowed_sections = get_report_template_allowed_sections();

    $normalized = $default_template;
    if (isset($template['version'])) {
        $normalized['version'] = (int)$template['version'];
    }
    if (!empty($template['template_name'])) {
        $normalized['template_name'] = trim((string)$template['template_name']);
    }
    if (isset($template['page']) && is_array($template['page'])) {
        $normalized['page'] = array_merge($default_template['page'], $template['page']);
    }
    if (isset($template['fields']) && is_array($template['fields'])) {
        $normalized['fields'] = array_merge($default_template['fields'], $template['fields']);
    }
    if (isset($template['labels']) && is_array($template['labels'])) {
        $normalized['labels'] = normalize_report_template_labels($template['labels']);
    }

    $normalized_sections = [];

    if (!empty($template['sections']) && is_array($template['sections'])) {
        foreach ($template['sections'] as $section) {
            if (!is_array($section) || empty($section['key']) || !in_array($section['key'], $allowed_sections, true)) {
                continue;
            }

            $normalized_sections[] = [
                'key' => $section['key'],
                'enabled' => !isset($section['enabled']) || (bool)$section['enabled'],
                'order' => isset($section['order']) ? (int)$section['order'] : count($normalized_sections) + 1,
            ];
        }
    }

    $normalized['sections'] = !empty($normalized_sections) ? $normalized_sections : $default_template['sections'];

    $normalized['score_columns'] = normalize_report_score_columns($template['score_columns'] ?? []);

    return $normalized;
}

function get_report_template_by_context($school_id, $session_id, $term_id)
{
    global $conn;

    $school_id = (int)$school_id;
    $term_id = normalize_report_template_term_id($term_id);
    $default_template = get_default_report_template_config();

    if (!isset($conn) || !$conn) {
        return $default_template;
    }

    $queries = [];
    $queries[] = "school_id='$school_id' AND term_id='$term_id' AND status='1'";
    $queries[] = "school_id='$school_id' AND term_id='default' AND is_default='1' AND status='1'";
    $queries[] = "school_id='0' AND term_id='default' AND is_default='1' AND status='1'";

    foreach ($queries as $where_clause) {
        try {
            $select_template = mysqli_query($conn, "SELECT * FROM report_templates WHERE $where_clause ORDER BY session_id IS NULL DESC, id DESC LIMIT 1");
        } catch (Throwable $e) {
            return [
                'id' => null,
                'school_id' => 0,
                'session_id' => null,
                'term_id' => 'default',
                'template_name' => $default_template['template_name'],
                'template_json' => $default_template,
                'is_default' => 1,
                'status' => 1,
            ];
        }

        if ($select_template && $row = mysqli_fetch_assoc($select_template)) {
            $row['template_json'] = normalize_report_template_config($row['template_json']);
            return $row;
        }
    }

    return [
        'id' => null,
        'school_id' => 0,
        'session_id' => null,
        'term_id' => 'default',
        'template_name' => $default_template['template_name'],
        'template_json' => $default_template,
        'is_default' => 1,
        'status' => 1,
    ];
}

function legacy_report_settings_to_template($report_settings)
{
    $template = get_default_report_template_config();
    if (!is_array($report_settings)) {
        return $template;
    }

    if (!empty($report_settings['report_name'])) {
        $template['template_name'] = $report_settings['report_name'];
    }

    $assessment_types = $report_settings['assessment_type'] ?? [];
    if (is_string($assessment_types)) {
        $assessment_types = json_decode($assessment_types, true);
    }

    $columns = ['subject'];
    if (is_array($assessment_types)) {
        foreach ($assessment_types as $assessment_type) {
            $column = map_legacy_assessment_to_report_column($assessment_type);
            if ($column !== '') {
                $columns[] = $column;
            }
        }
    }

    $template['score_columns'] = array_merge(array_values(array_unique($columns)), ['total', 'percentage', 'grade']);
    return normalize_report_template_config($template);
}

function get_report_card_template_score_columns($template)
{
    return normalize_report_score_columns($template['score_columns'] ?? []);
}

function build_report_score_comparison_data($score_rows, $target_student_id)
{
    $comparison_data = ['term' => [], 'cumulative' => []];
    $term_scores = [];

    if (!is_array($score_rows)) {
        return $comparison_data;
    }

    foreach ($score_rows as $row) {
        $subject_id = (string)($row['subject_id'] ?? '');
        $student_id = (string)($row['student_id'] ?? '');
        $term_id = (string)($row['term_id'] ?? '');
        $total = (float)($row['total'] ?? 0);

        if ($subject_id === '' || $student_id === '' || $term_id === '' || $total <= 0) {
            continue;
        }

        if (!isset($term_scores[$term_id][$subject_id])) {
            $term_scores[$term_id][$subject_id] = [];
        }
        $term_scores[$term_id][$subject_id][$student_id] = $total;
    }

    foreach ($term_scores as $term_id => $subjects) {
        foreach ($subjects as $subject_id => $student_scores) {
            $comparison_data['term'][$term_id][$subject_id] = summarize_report_comparison_scores($student_scores, $target_student_id);
        }
    }

    foreach (['2' => ['1', '2'], '3' => ['1', '2', '3']] as $scope => $terms) {
        $subject_scores = [];
        foreach ($terms as $term_id) {
            foreach (($term_scores[$term_id] ?? []) as $subject_id => $student_scores) {
                foreach ($student_scores as $student_id => $total) {
                    if (!isset($subject_scores[$subject_id][$student_id])) {
                        $subject_scores[$subject_id][$student_id] = 0;
                    }
                    $subject_scores[$subject_id][$student_id] += $total;
                }
            }
        }

        foreach ($subject_scores as $subject_id => $student_scores) {
            $comparison_data['cumulative'][$scope][$subject_id] = summarize_report_comparison_scores($student_scores, $target_student_id);
        }
    }

    return $comparison_data;
}

function summarize_report_comparison_scores($student_scores, $target_student_id)
{
    $student_scores = array_filter($student_scores, function ($score) {
        return (float)$score > 0;
    });

    if (empty($student_scores)) {
        return ['class_average' => '-', 'position' => '-'];
    }

    arsort($student_scores, SORT_NUMERIC);
    $target_student_id = (string)$target_student_id;
    $target_position = '-';
    $rank = 0;

    foreach ($student_scores as $student_id => $score) {
        $rank++;
        if ((string)$student_id === $target_student_id) {
            $target_position = (string)$rank;
            break;
        }
    }

    return [
        'class_average' => (string)round(array_sum($student_scores) / count($student_scores)),
        'position' => $target_position,
    ];
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

function onboard_settings($phone, $email, $staff_type, $staff_id = null)
{
    global $conn, $date;
    
    if (!$staff_id) {
        $select = mysqli_query($conn, "SELECT id FROM staff WHERE phone='$phone' AND email='$email'");
        if ($row = mysqli_fetch_array($select)) {
            $staff_id = $row['id'];
        } else {
            throw new Exception("Staff record not found for onboarding settings.");
        }
    }

    $_SESSION['userid'] = $staff_id;
    $_SESSION['phone'] = $phone;
    $_SESSION['email'] = $email;
    $_SESSION['staff_type'] = $staff_type;
    
    $grading = '{"A":"70","B":"60","C":"50","D":"40","E":"30","F":"0"}';
    
    $update = mysqli_query($conn, "UPDATE school SET createdby='$staff_id' WHERE id='{$_SESSION['school_id']}'");
    if (!$update) {
        throw new Exception("Failed to update school creator: " . mysqli_error($conn));
    }

    $insertsetting = mysqli_query($conn, "INSERT INTO skul_settings (session_id,term_id,ca1,ca2,exam,school_id,grading,datecreated,createdby) VALUES('{$_SESSION['session_id']}', '{$_SESSION['term_id']}',1,1,1,'{$_SESSION['school_id']}','$grading','$date','$staff_id')");
    if (!$insertsetting) {
        throw new Exception("Failed to insert school settings: " . mysqli_error($conn));
    }

    $insertsub_cat = mysqli_query(
        $conn,
        "INSERT INTO subject_cat (category_name,createdby, datecreated,subject_ids,school_id) 
                VALUES('Primary','$staff_id','$date','65,92,4,16,62,2,23,15,58,1,14,19','{$_SESSION['school_id']}')"
    );
    if (!$insertsub_cat) {
        throw new Exception("Failed to insert subject categories: " . mysqli_error($conn));
    }

    return true;
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
                return $daily_row['total_presence'] ?? 0; // Return 0 if no records found
            } else {
                return 0; // Return 0 if query fails
            }
        } else {
            return $row['total_present'] ?? 0; // Return 0 if no records found
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
