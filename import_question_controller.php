<?php
session_start();
if (!isset($_SESSION['userid'])) {
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized']);
    exit();
}

include_once("model/connect.php");

$action = $_POST['action'] ?? '';
$school_id = (int)($_SESSION['school_id'] ?? 0);

function iq_json($payload)
{
    echo json_encode($payload);
    exit();
}

function iq_table_has_column($conn, $table, $column)
{
    $table = mysqli_real_escape_string($conn, $table);
    $column = mysqli_real_escape_string($conn, $column);
    $result = mysqli_query($conn, "SHOW COLUMNS FROM `$table` LIKE '$column'");
    return $result && mysqli_num_rows($result) > 0;
}

function iq_ensure_bank_columns($conn)
{
    $columns = [
        'recommended_class' => "ALTER TABLE question_bank ADD recommended_class VARCHAR(100) NULL",
        'term_tag' => "ALTER TABLE question_bank ADD term_tag VARCHAR(50) NULL",
        'question_category' => "ALTER TABLE question_bank ADD question_category VARCHAR(100) NULL",
        'exam_year' => "ALTER TABLE question_bank ADD exam_year INT NOT NULL DEFAULT 0",
        'explanation' => "ALTER TABLE question_bank ADD explanation TEXT NULL",
        'review_status' => "ALTER TABLE question_bank ADD review_status VARCHAR(20) NOT NULL DEFAULT 'approved'",
        'quality_score' => "ALTER TABLE question_bank ADD quality_score INT NOT NULL DEFAULT 0",
        'times_used' => "ALTER TABLE question_bank ADD times_used INT NOT NULL DEFAULT 0",
        'school_id' => "ALTER TABLE question_bank ADD school_id INT NOT NULL DEFAULT 0",
        'deleted' => "ALTER TABLE question_bank ADD deleted TINYINT(1) NOT NULL DEFAULT 0",
    ];

    foreach ($columns as $column => $sql) {
        if (!iq_table_has_column($conn, 'question_bank', $column)) {
            mysqli_query($conn, $sql);
        }
    }

    if (!iq_table_has_column($conn, 'question_bank_options', 'deleted')) {
        mysqli_query($conn, "ALTER TABLE question_bank_options ADD deleted TINYINT(1) NOT NULL DEFAULT 0");
    }

    mysqli_query($conn, "UPDATE question_bank SET exam_year = 2024 WHERE source_type = 'exam_body' AND exam_year = 0 AND question LIKE '%BECE 2024 English Language - Item%'");
    mysqli_query($conn, "UPDATE question_bank SET exam_year = 2025 WHERE source_type = 'exam_body' AND exam_year = 0 AND question LIKE '%BECE 2025 English Language - Item%'");
    mysqli_query($conn, "UPDATE question_bank SET exam_year = 2025 WHERE source_type = 'exam_body' AND exam_year = 0 AND question LIKE '%WAEC 2025 English - Item%'");
}

function iq_clean_text($value, $max_length = 100)
{
    return substr(trim(strip_tags((string)$value)), 0, $max_length);
}

function iq_bind_params($stmt, $types, $params)
{
    if ($params) {
        $stmt->bind_param($types, ...$params);
    }
}

function iq_fetch_options($conn, $question_ids, $source_type)
{
    if (!$question_ids) {
        return [];
    }

    $ids = implode(',', array_map('intval', $question_ids));
    $table = $source_type === 'Local' ? 'options' : 'question_bank_options';
    $sql = "SELECT question_id, options, answer FROM $table WHERE question_id IN ($ids) AND deleted = 0 ORDER BY id ASC";
    $result = mysqli_query($conn, $sql);
    $options = [];

    while ($result && $row = mysqli_fetch_assoc($result)) {
        $options[(int)$row['question_id']][] = [
            'options' => $row['options'],
            'answer' => $row['answer'],
        ];
    }

    return $options;
}

iq_ensure_bank_columns($conn);

if ($action === 'get_import_filters') {
    $response = [
        'subjects' => [],
        'classes' => [],
        'exam_bodies' => [],
        'exam_years' => [],
        'topics' => [],
    ];

    $result = mysqli_query($conn, "SELECT id, subject FROM subjects ORDER BY subject ASC");
    while ($result && $row = mysqli_fetch_assoc($result)) {
        $response['subjects'][] = $row;
    }

    $stmt = $conn->prepare("SELECT id, classname FROM class WHERE id > 0 AND school_id = ? ORDER BY id ASC");
    $stmt->bind_param("i", $school_id);
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        $response['classes'][] = $row;
    }

    $result = mysqli_query($conn, "SELECT id, name FROM exam_bodies ORDER BY name ASC");
    while ($result && $row = mysqli_fetch_assoc($result)) {
        $response['exam_bodies'][] = $row;
    }

    $result = mysqli_query($conn, "SELECT exam_body_id, exam_year FROM question_bank WHERE source_type = 'exam_body' AND exam_year > 0 AND deleted = 0 GROUP BY exam_body_id, exam_year ORDER BY exam_year DESC");
    while ($result && $row = mysqli_fetch_assoc($result)) {
        $response['exam_years'][] = [
            'exam_body_id' => (int)$row['exam_body_id'],
            'exam_year' => (int)$row['exam_year'],
        ];
    }

    $result = mysqli_query($conn, "SELECT id, topic_name, subject_id, class_id FROM topics ORDER BY topic_name ASC");
    while ($result && $row = mysqli_fetch_assoc($result)) {
        $response['topics'][] = $row;
    }

    iq_json(['status' => 'success', 'data' => $response]);
}

if ($action === 'fetch_bank_questions') {
    $subject_id = (int)($_POST['subject_id'] ?? 0);
    $class_id = (int)($_POST['class_id'] ?? 0);
    $source_type = $_POST['source_type'] ?? '';
    $exam_body_id = (int)($_POST['exam_body_id'] ?? 0);
    $exam_year = (int)($_POST['exam_year'] ?? 0);
    $topic_id = (int)($_POST['topic_id'] ?? 0);
    $topic_ids = json_decode($_POST['topic_ids'] ?? '[]', true);
    $topic_ids = array_values(array_filter(array_map('intval', is_array($topic_ids) ? $topic_ids : [])));
    if (!$topic_ids && $topic_id > 0) {
        $topic_ids = [$topic_id];
    }
    $difficulty = $_POST['difficulty'] ?? '';
    $term_tag = iq_clean_text($_POST['term_tag'] ?? '', 50);
    $question_category = iq_clean_text($_POST['question_category'] ?? '', 100);
    $recommended_class = iq_clean_text($_POST['recommended_class'] ?? '', 100);
    $search = iq_clean_text($_POST['search'] ?? '', 150);
    $page = max(1, (int)($_POST['page'] ?? 1));
    $per_page = min(25, max(1, (int)($_POST['per_page'] ?? 5)));
    $offset = ($page - 1) * $per_page;

    $questions = [];
    $total_count = 0;

    if ($source_type === 'Local') {
        if ($subject_id <= 0 || $class_id <= 0) {
            iq_json(['status' => 'success', 'data' => [], 'pagination' => ['page' => $page, 'total_pages' => 1, 'total_count' => 0]]);
        }

        $where = ["a.school_id = ?", "a.subject_id = ?", "FIND_IN_SET(?, a.class_ids) > 0", "q.deleted = 0"];
        $params = [$school_id, $subject_id, $class_id];
        $types = 'iii';

        if ($search !== '') {
            $where[] = "(q.question LIKE ? OR EXISTS (
                SELECT 1 FROM options o
                WHERE o.question_id = q.id AND o.deleted = 0 AND o.options LIKE ?
            ))";
            $params[] = '%' . $search . '%';
            $params[] = '%' . $search . '%';
            $types .= 'ss';
        }

        $where_sql = implode(' AND ', $where);
        $count_stmt = $conn->prepare("SELECT COUNT(*) AS total FROM questions q JOIN assessment a ON q.ass_id = a.id WHERE $where_sql");
        iq_bind_params($count_stmt, $types, $params);
        $count_stmt->execute();
        $total_count = (int)$count_stmt->get_result()->fetch_assoc()['total'];

        $params[] = $per_page;
        $params[] = $offset;
        $types .= 'ii';
        $stmt = $conn->prepare("SELECT q.id, q.question FROM questions q JOIN assessment a ON q.ass_id = a.id WHERE $where_sql ORDER BY q.id DESC LIMIT ? OFFSET ?");
        iq_bind_params($stmt, $types, $params);
        $stmt->execute();
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()) {
            $questions[] = $row;
        }
    } else {
        $where = ["q.deleted = 0", "q.review_status = 'approved'", "(q.school_id = 0 OR q.school_id = ?)"];
        $params = [$school_id];
        $types = 'i';

        if ($subject_id > 0) {
            $where[] = "q.subject_id = ?";
            $params[] = $subject_id;
            $types .= 'i';
        }

        if ($source_type === 'Exam bodies') {
            $where[] = "q.source_type = 'exam_body'";
            if ($exam_body_id > 0) {
                $where[] = "q.exam_body_id = ?";
                $params[] = $exam_body_id;
                $types .= 'i';
            }
            if ($exam_year > 0) {
                $where[] = "q.exam_year = ?";
                $params[] = $exam_year;
                $types .= 'i';
            }
        } else {
            $where[] = "q.source_type = 'topic'";
            if ($topic_ids) {
                $where[] = "q.topic_id IN (" . implode(',', $topic_ids) . ")";
            }
        }

        if (in_array($difficulty, ['Easy', 'Medium', 'Hard'], true)) {
            $where[] = "q.difficulty = ?";
            $params[] = $difficulty;
            $types .= 's';
        }

        if ($question_category !== '') {
            $where[] = "q.question_category LIKE ?";
            $params[] = '%' . $question_category . '%';
            $types .= 's';
        }

        if ($search !== '') {
            $where[] = "(q.question LIKE ? OR EXISTS (
                SELECT 1 FROM question_bank_options o
                WHERE o.question_id = q.id AND o.deleted = 0 AND o.options LIKE ?
            ))";
            $params[] = '%' . $search . '%';
            $params[] = '%' . $search . '%';
            $types .= 'ss';
        }

        $class_boost = '';
        if ($recommended_class === '' && $class_id > 0) {
            $class_stmt = $conn->prepare("SELECT classname FROM class WHERE id = ? AND school_id = ? LIMIT 1");
            $class_stmt->bind_param("ii", $class_id, $school_id);
            $class_stmt->execute();
            $class_row = $class_stmt->get_result()->fetch_assoc();
            $recommended_class = $class_row['classname'] ?? '';
        }
        if ($recommended_class !== '') {
            $class_boost = "CASE WHEN q.recommended_class LIKE ? THEN 1 ELSE 0 END DESC,";
            $params[] = '%' . $recommended_class . '%';
            $types .= 's';
        }

        $term_boost = '';
        if ($term_tag !== '') {
            $term_boost = "CASE WHEN q.term_tag LIKE ? THEN 1 ELSE 0 END DESC,";
            $params[] = '%' . $term_tag . '%';
            $types .= 's';
        }

        $where_sql = implode(' AND ', $where);
        $count_params = array_slice($params, 0, count($params) - (($recommended_class !== '' ? 1 : 0) + ($term_tag !== '' ? 1 : 0)));
        $count_types = substr($types, 0, strlen($types) - (($recommended_class !== '' ? 1 : 0) + ($term_tag !== '' ? 1 : 0)));
        $count_stmt = $conn->prepare("SELECT COUNT(*) AS total FROM question_bank q WHERE $where_sql");
        iq_bind_params($count_stmt, $count_types, $count_params);
        $count_stmt->execute();
        $total_count = (int)$count_stmt->get_result()->fetch_assoc()['total'];

        $params[] = $per_page;
        $params[] = $offset;
        $types .= 'ii';
        $sql = "SELECT q.id, q.question, q.difficulty, q.recommended_class, q.term_tag, q.question_category, q.exam_year, q.quality_score, q.times_used
                FROM question_bank q
                WHERE $where_sql
                ORDER BY $class_boost $term_boost q.quality_score DESC, q.times_used DESC, q.id DESC
                LIMIT ? OFFSET ?";
        $stmt = $conn->prepare($sql);
        iq_bind_params($stmt, $types, $params);
        $stmt->execute();
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()) {
            $questions[] = $row;
        }
    }

    $options_map = iq_fetch_options($conn, array_column($questions, 'id'), $source_type);
    foreach ($questions as &$question) {
        $question['options'] = $options_map[(int)$question['id']] ?? [];
    }

    iq_json([
        'status' => 'success',
        'data' => $questions,
        'pagination' => [
            'page' => $page,
            'total_pages' => max(1, (int)ceil($total_count / $per_page)),
            'total_count' => $total_count,
        ],
    ]);
}

if ($action === 'get_questions_details') {
    $question_ids = $_POST['question_ids'] ?? [];
    $source_type = $_POST['source_type'] ?? '';

    if (!$question_ids) {
        iq_json(['status' => 'success', 'data' => []]);
    }

    $ids = array_values(array_filter(array_map('intval', $question_ids)));
    if (!$ids) {
        iq_json(['status' => 'success', 'data' => []]);
    }

    $ids_str = implode(',', $ids);
    $results = [];

    if ($source_type === 'Local') {
        $result = mysqli_query($conn, "SELECT id, question FROM questions WHERE id IN ($ids_str) AND deleted = 0");
        $options_map = iq_fetch_options($conn, $ids, 'Local');
        while ($result && $row = mysqli_fetch_assoc($result)) {
            $results[] = [
                'question' => $row['question'],
                'bank_question_id' => 0,
                'options' => $options_map[(int)$row['id']] ?? [],
            ];
        }
    } else {
        $result = mysqli_query($conn, "SELECT id, question FROM question_bank WHERE id IN ($ids_str) AND deleted = 0 AND review_status = 'approved'");
        $options_map = iq_fetch_options($conn, $ids, $source_type);
        $used_ids = [];
        while ($result && $row = mysqli_fetch_assoc($result)) {
            $used_ids[] = (int)$row['id'];
            $results[] = [
                'question' => $row['question'],
                'bank_question_id' => (int)$row['id'],
                'options' => $options_map[(int)$row['id']] ?? [],
            ];
        }

        if ($used_ids) {
            $used_str = implode(',', $used_ids);
            mysqli_query($conn, "UPDATE question_bank SET times_used = times_used + 1, quality_score = quality_score + 1 WHERE id IN ($used_str)");
        }
    }

    iq_json(['status' => 'success', 'data' => $results]);
}

if ($action === 'build_from_bank') {
    $subject_id = (int)($_POST['subject_id'] ?? 0);
    $topic_ids = json_decode($_POST['topic_ids'] ?? '[]', true);
    $topic_ids = array_values(array_filter(array_map('intval', is_array($topic_ids) ? $topic_ids : [])));
    $easy_count = max(0, (int)($_POST['easy_count'] ?? 0));
    $medium_count = max(0, (int)($_POST['medium_count'] ?? 0));
    $hard_count = max(0, (int)($_POST['hard_count'] ?? 0));

    if ($subject_id <= 0 || !$topic_ids || ($easy_count + $medium_count + $hard_count) <= 0) {
        iq_json(['status' => 'error', 'message' => 'Select subject, at least one topic, and a question mix.']);
    }

    $topic_sql = implode(',', $topic_ids);
    $requested = ['Easy' => $easy_count, 'Medium' => $medium_count, 'Hard' => $hard_count];
    $questions = [];

    foreach ($requested as $difficulty => $limit) {
        if ($limit <= 0) {
            continue;
        }
        $stmt = $conn->prepare("SELECT id, question FROM question_bank
            WHERE deleted = 0 AND review_status = 'approved' AND source_type = 'topic'
              AND (school_id = 0 OR school_id = ?) AND subject_id = ? AND topic_id IN ($topic_sql) AND difficulty = ?
            ORDER BY quality_score DESC, times_used ASC, id DESC
            LIMIT ?");
        $stmt->bind_param("iisi", $school_id, $subject_id, $difficulty, $limit);
        $stmt->execute();
        $result = $stmt->get_result();
        while ($row = $result->fetch_assoc()) {
            $questions[] = $row;
        }
    }

    $options_map = iq_fetch_options($conn, array_column($questions, 'id'), 'Topics');
    foreach ($questions as &$question) {
        $question['bank_question_id'] = (int)$question['id'];
        $question['options'] = $options_map[(int)$question['id']] ?? [];
    }

    iq_json(['status' => 'success', 'data' => $questions]);
}

iq_json(['status' => 'error', 'message' => 'Invalid action.']);
