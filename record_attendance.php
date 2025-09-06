<?php
session_start();
include_once("model/connect.php");

if (!isset($_SESSION['userid'])) {
    http_response_code(401);
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized access']);
    exit();
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = $_POST['action'];
    if ($action == 'record_attendance') {
        header('Content-Type: application/json');
        $student_data = $_POST['student_data'];

        $student_id = mysqli_real_escape_string($conn, $student_data['id']);
        $school_id = mysqli_real_escape_string($conn, $student_data['school_id']);
        $class_id = mysqli_real_escape_string($conn, $student_data['class_id']);
        
        try {
            if (!$student_id || !$school_id || !$class_id) {
                throw new Exception('Invalid student data provided');
            }

            $created_by = $_SESSION['userid'];
            $current_date = date('Y-m-d');
            $current_time = date('H:i:s');
            $current_datetime = date('Y-m-d H:i:s');
            $session_id = $_SESSION['session_id'];
            $term_id = $_SESSION['term_id'];

            $select_query = mysqli_query($conn, "SELECT state FROM attendance WHERE student_id = '$student_id' AND session_id = '$session_id' AND class_id = '$class_id' AND term_id = '$term_id' AND school_id = '$school_id' AND att_date = '$current_date' ORDER BY att_time DESC LIMIT 1");
            
            if (mysqli_num_rows($select_query) > 0) {
                $attendance = mysqli_fetch_assoc($select_query);
                $new_state = ($attendance['state'] == '1') ? '0' : '1';
            } else {
                $new_state = '1';
            }

            $insert_query = mysqli_query($conn, "INSERT INTO attendance (means,state, student_id, session_id, class_id, term_id, school_id, 
                createdby, datecreated, att_date, att_time) 
                VALUES (1,'$new_state', '$student_id','$session_id','$class_id','$term_id','$school_id','$created_by','$current_datetime','$current_date','$current_time')");

            if (!$insert_query) {
                throw new Exception(mysqli_error($conn));
            }

            echo json_encode(['status' => '1', 'message' => 'Attendance recorded successfully']);
            exit;

        } catch (Exception $e) {
            echo json_encode(['status' => 'error', 'message' => $e->getMessage()]);
            exit;
        }
    }

    if($action == 'get_today_attendance') {
        $school_id = $_SESSION['school_id'];
        $current_date = date('Y-m-d');
        
        // Get draw value
        $draw = $_POST['draw'];
        
        // Get start and length values for pagination
        $start = $_POST['start'];
        $length = $_POST['length'];
        
        // Get search value
        $search = $_POST['search']['value'];
        
        // Get order column and direction
        $order_column = $_POST['order'][0]['column'];
        $order_dir = $_POST['order'][0]['dir'];
        
        // Map DataTables column index to actual column names
        $columns = array(
            0 => 's.photo',
            1 => "CONCAT(s.firstname, ' ', s.lastname)",
            2 => 'c.classname',
            3 => 'a.att_time',
            4 => 'a.state'
        );
        
        $order_by = $columns[$order_column];
        
        // Base query
        $base_query = "FROM attendance a 
            JOIN students s ON a.student_id = s.id 
            JOIN class c ON a.class_id = c.id 
            WHERE a.school_id = '$school_id' 
            AND a.att_date = '$current_date'";
            
        // Add search condition if search value exists
        if (!empty($search)) {
            $base_query .= " AND (
                s.firstname LIKE '%$search%' OR 
                s.lastname LIKE '%$search%' OR 
                c.classname LIKE '%$search%'
            )";
        }
        
        // Get total count
        $total_query = "SELECT COUNT(*) as count " . $base_query;
        $total_result = mysqli_query($conn, $total_query);
        $total_count = mysqli_fetch_assoc($total_result)['count'];
        
        // Get filtered data
        $query = "SELECT 
            s.firstname, s.lastname, s.photo,
            c.classname as class,
            a.att_time, a.state
            $base_query
            ORDER BY $order_by $order_dir 
            LIMIT $start, $length";
            
        $result = mysqli_query($conn, $query);
        $attendance = array();
        
        while($row = mysqli_fetch_assoc($result)) {
            $attendance[] = [
                'name' => $row['firstname'] . ' ' . $row['lastname'],
                'photo' => $row['photo'] ?: 'avatar.png',
                'class' => $row['class'],
                'time' => date('h:i A', strtotime($row['att_time'])),
                'status' => $row['state'] == '1' ? 'Entry' : 'Exit'
            ];
        }
        
        echo json_encode([
            'draw' => intval($draw),
            'recordsTotal' => intval($total_count),
            'recordsFiltered' => intval($total_count),
            'data' => $attendance
        ]);
        exit;
    }
}

function formatDuration($seconds) {
    $hours = floor($seconds / 3600);
    $minutes = floor(($seconds % 3600) / 60);
    
    if ($hours > 0) {
        return sprintf("%dh %dm", $hours, $minutes);
    } else {
        return sprintf("%dm", $minutes);
    }
}
