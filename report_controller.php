<?php
session_start();
include_once("model/connect.php");

if (!isset($_SESSION['school_id'])) {
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized']);
    exit;
}

$school_id = $_SESSION['school_id'];
$action = $_POST['action'] ?? '';

// Set JSON header for all responses
header('Content-Type: application/json');

if ($action == 'fetch_reports') {
    $session_id = $_POST['session_id'];
    $term_id = $_POST['term_id'];

    $query = "SELECT * FROM report_settings WHERE school_id = '$school_id' AND session_id = '$session_id' AND term_id = '$term_id' ORDER BY id ASC";
    $result = mysqli_query($conn, $query);

    $reports = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $row['assessment_type'] = json_decode($row['assessment_type'], true);
        $reports[] = $row;
    }

    echo json_encode(['status' => 'success', 'data' => $reports]);
    exit;
} elseif ($action == 'save_report') {
    $id = $_POST['id'] ?? null;
    $report_name = mysqli_real_escape_string($conn, $_POST['report_name']);
    $assessment_type = json_encode($_POST['assessment_type']);
    $status = $_POST['status'];
    $session_id = $_POST['session_id'];
    $term_id = $_POST['term_id'];
    $user_id = $_SESSION['userid'] ?? 0;

    if ($id) {
        $query = "UPDATE report_settings SET 
                    report_name = '$report_name', 
                    assessment_type = '$assessment_type', 
                    status = '$status', 
                    updatedby = '$user_id', 
                    dateupdated = NOW() 
                  WHERE id = '$id' AND school_id = '$school_id'";
    } else {
        $query = "INSERT INTO report_settings (report_name, assessment_type, status, school_id, session_id, term_id, createdby, datecreated) 
                  VALUES ('$report_name', '$assessment_type', '$status', '$school_id', '$session_id', '$term_id', '$user_id', NOW())";
    }

    if (mysqli_query($conn, $query)) {
        $new_id = $id ? $id : mysqli_insert_id($conn);
        echo json_encode(['status' => 'success', 'id' => $new_id]);
    } else {
        echo json_encode(['status' => 'error', 'message' => mysqli_error($conn)]);
    }
    exit;
} elseif ($action == 'delete_report') {
    $id = $_POST['id'];
    $query = "DELETE FROM report_settings WHERE id = '$id' AND school_id = '$school_id'";

    if (mysqli_query($conn, $query)) {
        echo json_encode(['status' => 'success']);
    } else {
        echo json_encode(['status' => 'error', 'message' => mysqli_error($conn)]);
    }
    exit;
}

if ($action == 'fetch_report_by_id') {
    $report_id = $_POST['report_id'];
    $school_id = $_SESSION['school_id'];
    $select = mysqli_query($conn, "SELECT * FROM report_settings WHERE id='$report_id' AND school_id='$school_id'");
    if ($row = mysqli_fetch_array($select)) {
        echo json_encode(['status' => 'success', 'data' => $row]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Report not found']);
    }
    exit;
}
