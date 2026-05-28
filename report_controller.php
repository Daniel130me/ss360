<?php
session_start();
include_once("model/connect.php");
include_once("model/functions.php");

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

if ($action == 'fetch_report_template') {
    $term_id = $_POST['term_id'] ?? 'default';
    $template = get_report_template_by_context($school_id, null, $term_id);

    echo json_encode(['status' => 'success', 'data' => $template]);
    exit;
}

if ($action == 'fetch_report_templates') {
    $term_id = isset($_POST['term_id']) ? normalize_report_template_term_id($_POST['term_id']) : '';
    $where = "school_id='$school_id'";

    if ($term_id !== '') {
        $where .= " AND term_id='$term_id'";
    }

    $select_templates = mysqli_query($conn, "SELECT * FROM report_templates WHERE $where ORDER BY is_default DESC, term_id ASC, session_id IS NULL DESC, id ASC");
    if (!$select_templates) {
        echo json_encode(['status' => 'error', 'message' => mysqli_error($conn)]);
        exit;
    }

    $templates = [];
    while ($row = mysqli_fetch_assoc($select_templates)) {
        $row['template_json'] = normalize_report_template_config($row['template_json']);
        $templates[] = $row;
    }

    echo json_encode(['status' => 'success', 'data' => $templates]);
    exit;
}

if ($action == 'save_report_template') {
    $id = isset($_POST['id']) && $_POST['id'] !== '' ? (int)$_POST['id'] : null;
    $term_id = normalize_report_template_term_id($_POST['term_id'] ?? 'default');
    $template_name = mysqli_real_escape_string($conn, trim($_POST['template_name'] ?? 'Report Card'));
    $template_json = normalize_report_template_config($_POST['template_json'] ?? []);
    $template_json = mysqli_real_escape_string($conn, json_encode($template_json));
    $is_default = isset($_POST['is_default']) ? (int)$_POST['is_default'] : 0;
    $status = isset($_POST['status']) ? (int)$_POST['status'] : 1;
    $user_id = $_SESSION['userid'] ?? 0;

    if ($id) {
        $select_existing_template = mysqli_query($conn, "SELECT id FROM report_templates WHERE id='$id' AND school_id='$school_id' LIMIT 1");
        if (!$select_existing_template || mysqli_num_rows($select_existing_template) === 0) {
            $id = null;
        }
    } else {
        $select_existing_template = mysqli_query($conn, "SELECT id FROM report_templates WHERE school_id='$school_id' AND term_id='$term_id' ORDER BY session_id IS NULL DESC, id DESC LIMIT 1");
        if ($select_existing_template && $row = mysqli_fetch_assoc($select_existing_template)) {
            $id = (int)$row['id'];
        }
    }

    if ($id) {
        $query = "UPDATE report_templates SET
                    session_id=NULL,
                    term_id='$term_id',
                    template_name='$template_name',
                    template_json='$template_json',
                    is_default='$is_default',
                    status='$status',
                    updatedby='$user_id',
                    dateupdated=NOW()
                  WHERE id='$id' AND school_id='$school_id'";
    } else {
        $query = "INSERT INTO report_templates
                    (school_id, session_id, term_id, template_name, template_json, is_default, status, createdby, datecreated)
                  VALUES
                    ('$school_id', NULL, '$term_id', '$template_name', '$template_json', '$is_default', '$status', '$user_id', NOW())";
    }

    if (mysqli_query($conn, $query)) {
        echo json_encode(['status' => 'success', 'id' => $id ?: mysqli_insert_id($conn)]);
    } else {
        echo json_encode(['status' => 'error', 'message' => mysqli_error($conn)]);
    }
    exit;
}

if ($action == 'delete_report_template') {
    $id = isset($_POST['id']) ? (int)$_POST['id'] : 0;

    if ($id <= 0) {
        echo json_encode(['status' => 'error', 'message' => 'Template not found']);
        exit;
    }

    $query = "DELETE FROM report_templates WHERE id='$id' AND school_id='$school_id'";

    if (mysqli_query($conn, $query)) {
        echo json_encode(['status' => 'success']);
    } else {
        echo json_encode(['status' => 'error', 'message' => mysqli_error($conn)]);
    }
    exit;
}

if ($action == 'set_report_template_status') {
    $id = isset($_POST['id']) ? (int)$_POST['id'] : 0;
    $status = isset($_POST['status']) ? (int)$_POST['status'] : 0;
    $user_id = $_SESSION['userid'] ?? 0;

    if ($id <= 0) {
        echo json_encode(['status' => 'error', 'message' => 'Template not found']);
        exit;
    }

    $status = $status === 1 ? 1 : 0;
    $query = "UPDATE report_templates
              SET status='$status', updatedby='$user_id', dateupdated=NOW()
              WHERE id='$id' AND school_id='$school_id'";

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
