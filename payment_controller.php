<?php
error_reporting(E_ALL);
ini_set('display_errors', 1); // ONLY FOR DEBUGGING


session_start();
include 'model/connect.php';
include 'model/functions.php';

// if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'fetch_payment_summary') {
//     $school_id = $_SESSION['school_id'];
//     $session_id = $_SESSION['session_id'];
//     $term_id = $_SESSION['term_id'];

//     // Fetch total students paid for in the current session and term
//     $query_paid = "SELECT SUM(student_number) AS total_paid FROM payments WHERE school_id = '$school_id' AND session_id = '$session_id' AND term_id = '$term_id' AND payment_status = 'successful'";
//     $result_paid = mysqli_query($conn, $query_paid);
//     $total_paid = ($row = mysqli_fetch_assoc($result_paid)) ? (int)$row['total_paid'] : 0;

//     // Fetch total activated and not activated students in the current session and term
//     // $query_status = "SELECT 
//     //                     SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS activated,
//     //                     SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS not_activated
//     //                 FROM students WHERE school_id = '$school_id'";
//     $query_status = "SELECT 
//                         SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS activated,
//                         SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS not_activated
//                     FROM payment_record WHERE school_id = '$school_id' AND session_id = '$session_id' AND term_id = '$term_id'";
   
//     $result_status = mysqli_query($conn, $query_status);
//     $activated = $not_activated = 0;
//     if ($row = mysqli_fetch_assoc($result_status)) {
//         $activated = (int)$row['activated'];
//         $not_activated = (int)$row['not_activated'];
//     }

//     // Return JSON response
//     echo json_encode([
//         'total_paid' => $total_paid,
//         'activated' => $activated,
//         'not_activated' => $not_activated
//     ]);
//     exit;
// }
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'fetch_payment_summary') {
    $school_id = $_SESSION['school_id'];
    $session_id = $_SESSION['session_id'];
    $term_id = $_SESSION['term_id'];

    // Fetch total students paid for in the current session and term
    $query_paid = "SELECT SUM(student_number) AS total_paid FROM payments WHERE school_id = '$school_id' AND session_id = '$session_id' AND term_id = '$term_id' AND payment_status = 'successful'";
    $result_paid = mysqli_query($conn, $query_paid);
    $total_paid = ($row = mysqli_fetch_assoc($result_paid)) ? (int)$row['total_paid'] : 0;

    // Fetch total students in the school
    $query_total_students = "SELECT COUNT(*) AS total_students FROM students WHERE school_id = '$school_id'";
    $result_total_students = mysqli_query($conn, $query_total_students);
    $total_students = ($row = mysqli_fetch_assoc($result_total_students)) ? (int)$row['total_students'] : 0;

    // Fetch total activated students in payment_record
    if($school_id==26) {
    $query_activated = "SELECT count(*) as activated

FROM students s
INNER JOIN payment_record pr 
       ON pr.student_id = s.id 
       AND pr.term_id = '$term_id'
       AND pr.session_id = '$session_id'
WHERE s.school_id = '$school_id' AND pr.status=1";
}else {
    $query_activated = "SELECT COUNT(*) AS activated FROM payment_record WHERE school_id = '$school_id' AND session_id = '$session_id' AND term_id = '$term_id' AND status = 1";
}
    $result_activated = mysqli_query($conn, $query_activated);
    $activated = ($row = mysqli_fetch_assoc($result_activated)) ? (int)$row['activated'] : 0;

    // Calculate not activated
    $not_activated = $total_students - $activated;

    // Return JSON response
    echo json_encode([
        'total_paid' => $total_paid,
        'activated' => $activated,
        'not_activated' => $not_activated
    ]);
    exit;
}
// --- NEW: Action to fetch classes for the filter ---
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'fetch_classes_for_activation') {
    if (!$conn) {
        echo json_encode(['error' => 'Database connection failed']);
        exit;
    }
    $school_id = $_SESSION['school_id'] ?? null;
    if (!$school_id) {
         echo json_encode(['error' => 'School ID not found in session']);
         exit;
    }

    $classes = [];
    // Assuming you have a 'classes' table with 'id' and 'class_name' (adjust table/column names if different)
    $query = "SELECT id, classname FROM class WHERE school_id = ? ORDER BY classname ASC";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, "i", $school_id);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    // echo mysqli_error($conn);

    
    while ($row = mysqli_fetch_assoc($result)) {
        $classes[] = $row;
    }
    mysqli_stmt_close($stmt);

    header('Content-Type: application/json');
    echo json_encode(['classes' => $classes]);
    exit;
}

// --- NEW: Action to fetch students for activation ---
// if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'fetch_students_for_activation') {
//      if (!$conn) {
//         echo json_encode(['error' => 'Database connection failed']);
//         exit;
//     }
//     $school_id = $_SESSION['school_id'] ?? null;
//     $class_id = isset($_POST['class_id']) ? (int)$_POST['class_id'] : null;

//     if (!$school_id) {
//          echo json_encode(['error' => 'School ID not found in session']);
//          exit;
//     }

//     $students = [];
//     // Base query for non-activated students
//     $query = "SELECT st.id, st.firstname, st.lastname, st.admission_no, c.classname 
//               FROM payment_record s 
//               LEFT JOIN class c ON s.class_id = c.id 
//               LEFT JOIN students st ON s.student_id = st.id 
//               WHERE s.school_id = ? AND s.status = 0 AND s.term_id=$_SESSION[term_id] AND s.session_id=$_SESSION[session_id]";
//     // AND s.class_id = c.id AND s.session_id = c.session_id AND s.term_id = c.term_id";
//     $params = [$school_id];
//     $types = "i";

//     // Add class filter if provided

//     if ($class_id && $class_id > 0) {
//         $query .= " AND s.class_id = ?";
//         $params[] = $class_id;
//         $types .= "i";
//     }

//     $query .= " ORDER BY lastname ASC, firstname ASC";
// // echo $query;
//     $stmt = mysqli_prepare($conn, $query);
//     mysqli_stmt_bind_param($stmt, $types, ...$params); // Use splat operator for variable params
//     mysqli_stmt_execute($stmt);
//     $result = mysqli_stmt_get_result($stmt);

//     while ($row = mysqli_fetch_assoc($result)) {
//         $students[] = $row;
//     }
//     mysqli_stmt_close($stmt);

//     header('Content-Type: application/json');
//     echo json_encode(['students' => $students]);
//     exit;
// }
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'fetch_students_for_activation') {
     if (!$conn) {
        echo json_encode(['error' => 'Database connection failed']);
        exit;
    }
    $school_id = $_SESSION['school_id'] ?? null;
    $class_id = isset($_POST['class_id']) ? (int)$_POST['class_id'] : null;

    if (!$school_id) {
         echo json_encode(['error' => 'School ID not found in session']);
         exit;
    }

    $students = [];
    // Pagination parameters
    $page = isset($_POST['page']) ? max(1, (int)$_POST['page']) : 1;
    $per_page = isset($_POST['per_page']) ? max(1, (int)$_POST['per_page']) : 10;
    $offset = ($page - 1) * $per_page;

    // Count total students for pagination
    $count_query = "SELECT COUNT(*) AS total FROM students st
        WHERE st.school_id = ?
        AND st.id NOT IN (
            SELECT pr.student_id FROM payment_record pr
            WHERE pr.school_id = ? AND pr.session_id = ? AND pr.term_id = ? AND pr.status = 1
        )";
    $count_params = [$school_id, $school_id, $_SESSION['session_id'], $_SESSION['term_id']];
    $count_types = "iiii";
    if ($class_id && $class_id > 0) {
        $count_query .= " AND st.class_id = ?";
        $count_params[] = $class_id;
        $count_types .= "i";
    }
    $count_stmt = mysqli_prepare($conn, $count_query);
    mysqli_stmt_bind_param($count_stmt, $count_types, ...$count_params);
    mysqli_stmt_execute($count_stmt);
    $count_result = mysqli_stmt_get_result($count_stmt);
    $total_students = ($row = mysqli_fetch_assoc($count_result)) ? (int)$row['total'] : 0;
    mysqli_stmt_close($count_stmt);

    // Select students for current page
    $query = "SELECT st.id, st.firstname, st.lastname, st.admission_no, st.class_id, c.classname
              FROM students st
              LEFT JOIN class c ON st.class_id = c.id
              WHERE st.school_id = ?
              AND st.id NOT IN (
                  SELECT pr.student_id FROM payment_record pr
                  WHERE pr.school_id = ? AND pr.session_id = ? AND pr.term_id = ? AND pr.status = 1
              )";
    $params = [$school_id, $school_id, $_SESSION['session_id'], $_SESSION['term_id']];
    $types = "iiii";
    if ($class_id && $class_id > 0) {
        $query .= " AND st.class_id = ?";
        $params[] = $class_id;
        $types .= "i";
    }
    $query .= " ORDER BY c.classname ASC, st.lastname ASC, st.firstname ASC LIMIT ? OFFSET ?";
    $params[] = $per_page;
    $params[] = $offset;
    $types .= "ii";
    $stmt = mysqli_prepare($conn, $query);
    mysqli_stmt_bind_param($stmt, $types, ...$params);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    while ($row = mysqli_fetch_assoc($result)) {
        $students[] = $row;
    }
    mysqli_stmt_close($stmt);

    header('Content-Type: application/json');
    echo json_encode([
        'students' => $students,
        'total' => $total_students,
        'page' => $page,
        'per_page' => $per_page,
        'total_pages' => ceil($total_students / $per_page)
    ]);
    exit;
}
// if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'activate_selected_students') {
//     if (!$conn) {
//         echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
//         exit;
//     }
//     $school_id = $_SESSION['school_id'] ?? null;
//     $userid = $_SESSION['userid'] ?? null;
//     $students = isset($_POST['students']) && is_array($_POST['students']) ? $_POST['students'] : [];
//     $activation_limit = isset($_POST['activation_limit']) ? (int)$_POST['activation_limit'] : 0;

//     if (!$school_id) {
//         echo json_encode(['status' => 'error', 'message' => 'School ID not found in session']);
//         exit;
//     }
//     if (empty($students)) {
//         echo json_encode(['status' => 'error', 'message' => 'No students selected.']);
//         exit;
//     }
//     if (count($students) > $activation_limit) {
//         echo json_encode(['status' => 'error', 'message' => 'You cannot activate more students than the available limit (' . $activation_limit . ').']);
//         exit;
//     }

//     $activated_count = 0;
//     $errors = [];

//     // Use a transaction for atomicity
//     mysqli_begin_transaction($conn);

//     try {
//         foreach ($students as $student) {
//             $id = isset($student['id']) ? (int)$student['id'] : 0;
//             $class_id = isset($student['class_id']) ? (int)$student['class_id'] : null;
//             // Check if record exists
//             $check_query = "SELECT status FROM payment_record WHERE student_id = ? AND school_id = ? AND term_id = ? AND session_id = ?";
//             $check_stmt = mysqli_prepare($conn, $check_query);
//             mysqli_stmt_bind_param($check_stmt, "iiii", $id, $school_id, $_SESSION['term_id'], $_SESSION['session_id']);
//             mysqli_stmt_execute($check_stmt);
//             $check_result = mysqli_stmt_get_result($check_stmt);
//             if ($row = mysqli_fetch_assoc($check_result)) {
//                 if ($row['status'] == 0) {
//                     // Update status to 1 and set updatedby, dateupdated
//                     $update_query = "UPDATE payment_record SET status = 1, updatedby = ?, dateupdated = NOW() WHERE student_id = ? AND school_id = ? AND status = 0 AND term_id = ? AND session_id = ?";
//                     $update_stmt = mysqli_prepare($conn, $update_query);
//                     mysqli_stmt_bind_param($update_stmt, "iiiii", $userid, $id, $school_id, $_SESSION['term_id'], $_SESSION['session_id']);
//                     if (mysqli_stmt_execute($update_stmt) && mysqli_stmt_affected_rows($update_stmt) > 0) {
//                         $activated_count++;
//                     } else {
//                         $errors[] = "Could not activate student ID: $id (database error).";
//                     }
//                     mysqli_stmt_close($update_stmt);
//                 } else {
//                     $errors[] = "Student ID: $id is already active.";
//                 }
//             } else {
//                 // Insert new record and activate, with class_id, createdby, updatedby, datecreated, dateupdated
//                 $insert_query = "INSERT INTO payment_record (student_id, school_id, class_id, status, term_id, session_id, createdby, updatedby, datecreated, dateupdated) VALUES (?, ?, ?, 1, ?, ?, ?, ?, NOW(), NOW())";
//                 $insert_stmt = mysqli_prepare($conn, $insert_query);
//                 mysqli_stmt_bind_param($insert_stmt, "iiiiiiii", $id, $school_id, $class_id, $_SESSION['term_id'], $_SESSION['session_id'], $userid, $userid);
//                 if (mysqli_stmt_execute($insert_stmt)) {
//                     $activated_count++;
//                 } else {
//                     $errors[] = "Could not insert and activate student ID: $id (database error).";
//                 }
//                 mysqli_stmt_close($insert_stmt);
//             }
//             mysqli_stmt_close($check_stmt);
//         }

//         if (empty($errors) && $activated_count > 0) {
//             mysqli_commit($conn);
//             header('Content-Type: application/json');
//             echo json_encode(['status' => 'success', 'message' => $activated_count . ' student(s) activated successfully.']);
//         } else {
//             mysqli_rollback($conn);
//             header('Content-Type: application/json');
//             echo json_encode(['status' => 'error', 'message' => 'Activation failed. ' . implode(' ', $errors)]);
//         }

//     } catch (Exception $e) {
//         mysqli_rollback($conn);
//         header('Content-Type: application/json');
//         echo json_encode(['status' => 'error', 'message' => 'An exception occurred: ' . $e->getMessage()]);
//     }

//     exit;
// }
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'activate_selected_students') {
    if (!$conn) {
        echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
        exit;
    }
    $school_id = $_SESSION['school_id'] ?? null;
    $userid = $_SESSION['userid'] ?? null;
    $students = isset($_POST['students']) && is_array($_POST['students']) ? $_POST['students'] : [];
    // var_dump($students);
    // exit;
    $activation_limit = isset($_POST['activation_limit']) ? (int)$_POST['activation_limit'] : 0;

    if (!$school_id) {
        echo json_encode(['status' => 'error', 'message' => 'School ID not found in session']);
        exit;
    }
    if (empty($students)) {
        echo json_encode(['status' => 'error', 'message' => 'No students selected.']);
        exit;
    }
    if (count($students) > $activation_limit) {
        echo json_encode(['status' => 'error', 'message' => 'You cannot activate more students than the available limit (' . $activation_limit . ').']);
        exit;
    }

    $activated_count = 0;
    $errors = [];

    // Use a transaction for atomicity
    mysqli_begin_transaction($conn);

    try {
        foreach ($students as $student) {
            $id = isset($student['id']) ? (int)$student['id'] : 0;
            $class_id = isset($student['class_id']) ? (int)$student['class_id'] : null;
            // Check if record exists
            $check_query = "SELECT status FROM payment_record WHERE student_id = ? AND school_id = ? AND term_id = ? AND session_id = ?";
            $check_stmt = mysqli_prepare($conn, $check_query);
            mysqli_stmt_bind_param($check_stmt, "iiii", $id, $school_id, $_SESSION['term_id'], $_SESSION['session_id']);
            mysqli_stmt_execute($check_stmt);
            $check_result = mysqli_stmt_get_result($check_stmt);
            if ($row = mysqli_fetch_assoc($check_result)) {
                if ($row['status'] == 0) {
                    // Update status to 1 and set updatedby, dateupdated
                    $update_query = "UPDATE payment_record SET status = 1, updatedby = ?, dateupdated = NOW() WHERE student_id = ? AND school_id = ? AND status = 0 AND term_id = ? AND session_id = ?";
                    $update_stmt = mysqli_prepare($conn, $update_query);
                    mysqli_stmt_bind_param($update_stmt, "iiiii", $userid, $id, $school_id, $_SESSION['term_id'], $_SESSION['session_id']);
                    if (mysqli_stmt_execute($update_stmt) && mysqli_stmt_affected_rows($update_stmt) > 0) {
                        $activated_count++;
                    } else {
                        $errors[] = "Could not activate student ID: $id (database error).";
                    }
                    mysqli_stmt_close($update_stmt);
                } else {
                    $errors[] = "Student ID: $id is already active.";
                }
            } else {
                // Insert new record and activate, with class_id, createdby, updatedby, datecreated, dateupdated
                $insert_query = "INSERT INTO payment_record (student_id, school_id, class_id, status, term_id, session_id, createdby, updatedby, datecreated, dateupdated) VALUES (?, ?, ?, 1, ?, ?, ?, ?, NOW(), NOW())";
                $insert_stmt = mysqli_prepare($conn, $insert_query);
                mysqli_stmt_bind_param($insert_stmt, "iiiiiii", $id, $school_id, $class_id, $_SESSION['term_id'], $_SESSION['session_id'], $userid, $userid);
                if (mysqli_stmt_execute($insert_stmt)) {
                    $activated_count++;
                } else {
                    $errors[] = "Could not insert and activate student ID: $id (database error).";
                }
                mysqli_stmt_close($insert_stmt);
            }
            mysqli_stmt_close($check_stmt);
        }

        if (empty($errors) && $activated_count > 0) {
            mysqli_commit($conn);
            header('Content-Type: application/json');
            echo json_encode(['status' => 'success', 'message' => $activated_count . ' student(s) activated successfully.']);
        } else {
            mysqli_rollback($conn);
            header('Content-Type: application/json');
            echo json_encode(['status' => 'error', 'message' => 'Activation failed. ' . implode(' ', $errors)]);
        }

    } catch (Exception $e) {
        mysqli_rollback($conn);
        header('Content-Type: application/json');
        echo json_encode(['status' => 'error', 'message' => 'An exception occurred: ' . $e->getMessage()]);
    }

    exit;
}
// --- NEW: Action to ACTUALLY activate selected students (Placeholder) ---
// if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'activate_selected_students') {
//     if (!$conn) {
//         echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
//         exit;
//     }
//     $school_id = $_SESSION['school_id'] ?? null;
//     $student_ids = isset($_POST['student_ids']) && is_array($_POST['student_ids']) ? $_POST['student_ids'] : [];
//     $activation_limit = isset($_POST['activation_limit']) ? (int)$_POST['activation_limit'] : 0;

    
//     if (!$school_id) {
//          echo json_encode(['status' => 'error', 'message' => 'School ID not found in session']);
//          exit;
//     }
//      if (empty($student_ids)) {
//          echo json_encode(['status' => 'error', 'message' => 'No students selected.']);
//          exit;
//     }
//     if (count($student_ids) > $activation_limit) {
//          echo json_encode(['status' => 'error', 'message' => 'You cannot activate more students than the available limit (' . $activation_limit . ').']);
//          exit;
//     }


//     // --- IMPORTANT: Add Validation Here ---
//     // 1. Verify the user has permission to activate students.
//     // 2. Double-check the activation limit against current payments/activated count again on the server-side.
//     // 3. Ensure all submitted student_ids actually belong to the school_id and have status = 0.

//     $activated_count = 0;
//     $errors = [];

//     // Use a transaction for atomicity
//     mysqli_begin_transaction($conn);

//     try {
//         $query = "UPDATE payment_record SET status = 1, dateupdated = NOW() WHERE student_id = ? AND school_id = ? AND status = 0 AND term_id=$_SESSION[term_id] AND session_id=$_SESSION[session_id]";        
//         $stmt = mysqli_prepare($conn, $query);

//         foreach ($student_ids as $student_id) {
//             $id = (int)$student_id; // Sanitize
//             mysqli_stmt_bind_param($stmt, "ii", $id, $school_id);
//             if (mysqli_stmt_execute($stmt)) {
//                 if (mysqli_stmt_affected_rows($stmt) > 0) {
//                     $activated_count++;
//                 } else {
//                     // Could happen if student was already active or doesn't belong to school
//                     $errors[] = "Could not activate student ID: $id (already active or invalid).";
//                 }
//             } else {
//                  $errors[] = "Database error activating student ID: $id.";
//             }
//         }
//         mysqli_stmt_close($stmt);

//         if (empty($errors) && $activated_count > 0) {
//             mysqli_commit($conn);
//             header('Content-Type: application/json');
//             echo json_encode(['status' => 'success', 'message' => $activated_count . ' student(s) activated successfully.']);
//         } else {
//             mysqli_rollback($conn);
//             header('Content-Type: application/json');
//             echo json_encode(['status' => 'error', 'message' => 'Activation failed. ' . implode(' ', $errors)]);
//         }

//     } catch (Exception $e) {
//         mysqli_rollback($conn);
//         header('Content-Type: application/json');
//         echo json_encode(['status' => 'error', 'message' => 'An exception occurred: ' . $e->getMessage()]);
//     }

//     exit;
// }
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action']) && $_POST['action'] === 'activate_selected_students') {
    if (!$conn) {
        echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
        exit;
    }
    $school_id = $_SESSION['school_id'] ?? null;
    $student_ids = isset($_POST['student_ids']) && is_array($_POST['student_ids']) ? $_POST['student_ids'] : [];
    $activation_limit = isset($_POST['activation_limit']) ? (int)$_POST['activation_limit'] : 0;

    
    if (!$school_id) {
         echo json_encode(['status' => 'error', 'message' => 'School ID not found in session']);
         exit;
    }
     if (empty($student_ids)) {
         echo json_encode(['status' => 'error', 'message' => 'No students selected.']);
         exit;
    }
    if (count($student_ids) > $activation_limit) {
         echo json_encode(['status' => 'error', 'message' => 'You cannot activate more students than the available limit (' . $activation_limit . ').']);
         exit;
    }


    // --- IMPORTANT: Add Validation Here ---
    // 1. Verify the user has permission to activate students.
    // 2. Double-check the activation limit against current payments/activated count again on the server-side.
    // 3. Ensure all submitted student_ids actually belong to the school_id and have status = 0.

    $activated_count = 0;
    $errors = [];

    // Use a transaction for atomicity
    mysqli_begin_transaction($conn);

    try {
        foreach ($student_ids as $student_id) {
            $id = (int)$student_id; // Sanitize
            // Check if record exists
            $check_query = "SELECT status FROM payment_record WHERE student_id = ? AND school_id = ? AND term_id = ? AND session_id = ?";
            $check_stmt = mysqli_prepare($conn, $check_query);
            mysqli_stmt_bind_param($check_stmt, "iiii", $id, $school_id, $_SESSION['term_id'], $_SESSION['session_id']);
            mysqli_stmt_execute($check_stmt);
            $check_result = mysqli_stmt_get_result($check_stmt);
            if ($row = mysqli_fetch_assoc($check_result)) {
                if ($row['status'] == 0) {
                    // Update status to 1
                    $update_query = "UPDATE payment_record SET status = 1, dateupdated = NOW() WHERE student_id = ? AND school_id = ? AND status = 0 AND term_id = ? AND session_id = ?";
                    $update_stmt = mysqli_prepare($conn, $update_query);
                    mysqli_stmt_bind_param($update_stmt, "iiii", $id, $school_id, $_SESSION['term_id'], $_SESSION['session_id']);
                    if (mysqli_stmt_execute($update_stmt) && mysqli_stmt_affected_rows($update_stmt) > 0) {
                        $activated_count++;
                    } else {
                        $errors[] = "Could not activate student ID: $id (database error).";
                    }
                    mysqli_stmt_close($update_stmt);
                } else {
                    $errors[] = "Student ID: $id is already active.";
                }
            } else {
                // Insert new record and activate
                $insert_query = "INSERT INTO payment_record (student_id, school_id, status, term_id, session_id, dateupdated) VALUES (?, ?, 1, ?, ?, NOW())";
                $insert_stmt = mysqli_prepare($conn, $insert_query);
                mysqli_stmt_bind_param($insert_stmt, "iiii", $id, $school_id, $_SESSION['term_id'], $_SESSION['session_id']);
                if (mysqli_stmt_execute($insert_stmt)) {
                    $activated_count++;
                } else {
                    $errors[] = "Could not insert and activate student ID: $id (database error).";
                }
                mysqli_stmt_close($insert_stmt);
            }
            mysqli_stmt_close($check_stmt);
        }

        if (empty($errors) && $activated_count > 0) {
            mysqli_commit($conn);
            header('Content-Type: application/json');
            echo json_encode(['status' => 'success', 'message' => $activated_count . ' student(s) activated successfully.']);
        } else {
            mysqli_rollback($conn);
            header('Content-Type: application/json');
            echo json_encode(['status' => 'error', 'message' => 'Activation failed. ' . implode(' ', $errors)]);
        }

    } catch (Exception $e) {
        mysqli_rollback($conn);
        header('Content-Type: application/json');
        echo json_encode(['status' => 'error', 'message' => 'An exception occurred: ' . $e->getMessage()]);
    }

    exit;
}

// If no action matches
// Consider adding a default response or error handling here
// echo json_encode(['error' => 'Invalid action specified']);

?>
