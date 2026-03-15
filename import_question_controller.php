<?php
session_start();
if (!isset($_SESSION['userid'])) {
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized']);
    exit();
}
include_once("model/connect.php");

$action = isset($_POST['action']) ? $_POST['action'] : '';
$school_id = $_SESSION['school_id'];

if ($action == 'get_import_filters') {
    $response = [
        'subjects' => [],
        'classes' => [],
        'exam_bodies' => [],
        'topics' => []
    ];

    // Subjects
    $sql = "SELECT id, subject FROM subjects ORDER BY subject ASC";
    $res = mysqli_query($conn, $sql);
    while($row = mysqli_fetch_assoc($res)) {
        $response['subjects'][] = $row;
    }

    // Classes
    $sql = "SELECT id, classname FROM class WHERE id > 0 AND school_id = ? ORDER BY id ASC";
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("i", $school_id);
    $stmt->execute();
    $res = $stmt->get_result();
    while($row = $res->fetch_assoc()) {
        $response['classes'][] = $row;
    }

    // Exam Bodies
    $sql = "SELECT id, name FROM exam_bodies ORDER BY name ASC";
    $res = mysqli_query($conn, $sql);
    while($row = mysqli_fetch_assoc($res)) {
        $response['exam_bodies'][] = $row;
    }

    // Topics
    $sql = "SELECT id, topic_name, subject_id, class_id FROM topics ORDER BY topic_name ASC";
    $res = mysqli_query($conn, $sql);
    while($row = mysqli_fetch_assoc($res)) {
        $response['topics'][] = $row;
    }

    echo json_encode(['status' => 'success', 'data' => $response]);
    exit();
}

if ($action == 'fetch_bank_questions') {
    $subject_id = isset($_POST['subject_id']) ? (int)$_POST['subject_id'] : 0;
    $class_id = isset($_POST['class_id']) ? (int)$_POST['class_id'] : 0;
    $source_type = isset($_POST['source_type']) ? $_POST['source_type'] : '';
    $exam_body_id = isset($_POST['exam_body_id']) ? (int)$_POST['exam_body_id'] : 0;
    $topic_id = isset($_POST['topic_id']) ? (int)$_POST['topic_id'] : 0;
    
    $page = isset($_POST['page']) ? max(1, (int)$_POST['page']) : 1;
    $per_page = isset($_POST['per_page']) ? max(1, (int)$_POST['per_page']) : 5;
    $offset = ($page - 1) * $per_page;

    $questions = [];
    $total_count = 0;

    if ($source_type == 'Local') {
        $stmt = $conn->prepare("SELECT SQL_CALC_FOUND_ROWS q.id, q.question FROM questions q JOIN assessment a ON q.ass_id = a.id WHERE a.school_id = ? AND a.subject_id = ? AND FIND_IN_SET(?, a.class_ids) > 0 AND q.deleted = 0 LIMIT ?, ?");
        $stmt->bind_param("iiiii", $school_id, $subject_id, $class_id, $offset, $per_page);
        $stmt->execute();
        $res = $stmt->get_result();
        while($row = $res->fetch_assoc()) {
            $questions[] = $row;
        }
        $count_res = mysqli_query($conn, "SELECT FOUND_ROWS() as cnt");
        $total_count = mysqli_fetch_assoc($count_res)['cnt'];

    } else if ($source_type == 'Exam bodies') {
        $stmt = $conn->prepare("SELECT SQL_CALC_FOUND_ROWS id, question FROM question_bank WHERE subject_id = ? AND source_type = 'exam_body' AND exam_body_id = ? LIMIT ?, ?");
        $stmt->bind_param("iiii", $subject_id, $exam_body_id, $offset, $per_page);
        $stmt->execute();
        $res = $stmt->get_result();
        while($row = $res->fetch_assoc()) {
            $questions[] = $row;
        }
        $count_res = mysqli_query($conn, "SELECT FOUND_ROWS() as cnt");
        $total_count = mysqli_fetch_assoc($count_res)['cnt'];

    } else if ($source_type == 'Topics') {
        $stmt = $conn->prepare("SELECT SQL_CALC_FOUND_ROWS id, question FROM question_bank WHERE subject_id = ? AND source_type = 'topic' AND topic_id = ? LIMIT ?, ?");
        $stmt->bind_param("iiii", $subject_id, $topic_id, $offset, $per_page);
        $stmt->execute();
        $res = $stmt->get_result();
        while($row = $res->fetch_assoc()) {
            $questions[] = $row;
        }
        $count_res = mysqli_query($conn, "SELECT FOUND_ROWS() as cnt");
        $total_count = mysqli_fetch_assoc($count_res)['cnt'];
    }

    $total_pages = ceil($total_count / $per_page);

    if (!empty($questions)) {
        $q_ids = array_column($questions, 'id');
        $ids_str = implode(',', $q_ids);
        
        $options_map = [];
        if ($source_type == 'Local') {
            $o_sql = "SELECT question_id, options, answer FROM options WHERE question_id IN ($ids_str) AND deleted = 0";
        } else {
            $o_sql = "SELECT question_id, options, answer FROM question_bank_options WHERE question_id IN ($ids_str)";
        }
        
        $o_res = mysqli_query($conn, $o_sql);
        if ($o_res) {
            while ($o_row = mysqli_fetch_assoc($o_res)) {
                $options_map[$o_row['question_id']][] = [
                    'options' => $o_row['options'],
                    'answer' => $o_row['answer']
                ];
            }
        }
        
        foreach ($questions as &$q) {
            $q['options'] = isset($options_map[$q['id']]) ? $options_map[$q['id']] : [];
        }
    }

    echo json_encode([
        'status' => 'success', 
        'data' => $questions, 
        'pagination' => [
            'page' => $page,
            'total_pages' => max(1, $total_pages),
            'total_count' => $total_count
        ]
    ]);
    exit();
}

if ($action == 'get_questions_details') {
    $question_ids = isset($_POST['question_ids']) ? $_POST['question_ids'] : [];
    $source_type = isset($_POST['source_type']) ? $_POST['source_type'] : '';

    if (empty($question_ids)) {
        echo json_encode(['status' => 'success', 'data' => []]);
        exit();
    }

    // sanitize ids
    $ids = array_map('intval', $question_ids);
    $ids_str = implode(',', $ids);

    $results = [];

    if ($source_type == 'Local') {
        $q_sql = "SELECT * FROM questions WHERE id IN ($ids_str)";
        $q_res = mysqli_query($conn, $q_sql);
        while ($q_row = mysqli_fetch_assoc($q_res)) {
            $options = [];
            $o_sql = "SELECT * FROM options WHERE question_id = '{$q_row['id']}' AND deleted = 0";
            $o_res = mysqli_query($conn, $o_sql);
            while ($o_row = mysqli_fetch_assoc($o_res)) {
                $options[] = $o_row;
            }
            $results[] = [
                'question' => $q_row['question'],
                'options' => $options
            ];
        }
    } else {
        // Exam body or Topic
        $q_sql = "SELECT * FROM question_bank WHERE id IN ($ids_str)";
        $q_res = mysqli_query($conn, $q_sql);
        while ($q_row = mysqli_fetch_assoc($q_res)) {
            $options = [];
            $o_sql = "SELECT * FROM question_bank_options WHERE question_id = '{$q_row['id']}'";
            $o_res = mysqli_query($conn, $o_sql);
            while ($o_row = mysqli_fetch_assoc($o_res)) {
                $options[] = [
                    'options' => $o_row['options'],
                    'answer' => $o_row['answer']
                ];
            }
            $results[] = [
                'question' => $q_row['question'],
                'options' => $options
            ];
        }
    }

    echo json_encode(['status' => 'success', 'data' => $results]);
    exit();
}

?>
