<?php
session_start();

header('Content-Type: application/json; charset=utf-8');

if (!isset($_SESSION['userid']) || ($_SESSION['user_type'] ?? '') !== 'student') {
    echo json_encode(['status' => 'error', 'message' => 'Please log in as a student to practice.']);
    exit;
}

include_once("model/connect.php");
include_once("model/functions.php");

mysqli_set_charset($conn, 'utf8mb4');

const PRACTICE_ALLOWED_COUNTS = [10, 20, 50, 100];
const PRACTICE_ALLOWED_DIFFICULTIES = ['Easy', 'Medium', 'Hard', 'Mixed'];
const PRACTICE_ALLOWED_SCOPES = ['subject', 'topic', 'mixed_topic', 'mixed_subject'];
const PRACTICE_DEFAULT_TIMER_MINUTES = 15;
const PRACTICE_CANDIDATE_LIMIT = 300;

function practice_json($payload)
{
    echo json_encode($payload);
    exit;
}

function practice_table_has_column($conn, $table, $column)
{
    $table = mysqli_real_escape_string($conn, $table);
    $column = mysqli_real_escape_string($conn, $column);
    $result = mysqli_query($conn, "SHOW COLUMNS FROM `$table` LIKE '$column'");
    return $result && mysqli_num_rows($result) > 0;
}

function practice_add_index_if_missing($conn, $table, $index, $sql)
{
    $table = mysqli_real_escape_string($conn, $table);
    $index = mysqli_real_escape_string($conn, $index);
    $result = mysqli_query($conn, "SHOW INDEX FROM `$table` WHERE Key_name = '$index'");
    if (!$result || mysqli_num_rows($result) === 0) {
        mysqli_query($conn, $sql);
    }
}

function practice_ensure_schema($conn)
{
    mysqli_query($conn, "CREATE TABLE IF NOT EXISTS student_practice_sessions (
        id INT AUTO_INCREMENT PRIMARY KEY,
        student_id INT NOT NULL,
        school_id INT NOT NULL DEFAULT 0,
        class_id INT NOT NULL DEFAULT 0,
        subject_id INT NOT NULL DEFAULT 0,
        topic_id INT NOT NULL DEFAULT 0,
        practice_scope VARCHAR(30) NOT NULL DEFAULT 'subject',
        difficulty VARCHAR(20) NOT NULL DEFAULT 'Mixed',
        question_count INT NOT NULL DEFAULT 0,
        timed TINYINT(1) NOT NULL DEFAULT 0,
        duration_minutes INT NOT NULL DEFAULT 0,
        question_ids TEXT NOT NULL,
        score INT NOT NULL DEFAULT 0,
        total_questions INT NOT NULL DEFAULT 0,
        status VARCHAR(20) NOT NULL DEFAULT 'in_progress',
        started_at DATETIME NULL,
        completed_at DATETIME NULL,
        last_activity DATETIME NULL,
        KEY idx_sps_student_status (student_id, status),
        KEY idx_sps_school_class (school_id, class_id),
        KEY idx_sps_subject_topic (subject_id, topic_id)
    )");

    mysqli_query($conn, "CREATE TABLE IF NOT EXISTS student_practice_answers (
        id INT AUTO_INCREMENT PRIMARY KEY,
        session_id INT NOT NULL,
        student_id INT NOT NULL,
        question_id INT NOT NULL,
        selected_option_id INT NOT NULL DEFAULT 0,
        is_correct TINYINT(1) NULL,
        answered_at DATETIME NULL,
        UNIQUE KEY uniq_spa_session_question (session_id, question_id),
        KEY idx_spa_student (student_id),
        KEY idx_spa_question (question_id)
    )");

    $session_columns = [
        'practice_scope' => "ALTER TABLE student_practice_sessions ADD practice_scope VARCHAR(30) NOT NULL DEFAULT 'subject'",
        'question_count' => "ALTER TABLE student_practice_sessions ADD question_count INT NOT NULL DEFAULT 0",
        'timed' => "ALTER TABLE student_practice_sessions ADD timed TINYINT(1) NOT NULL DEFAULT 0",
        'duration_minutes' => "ALTER TABLE student_practice_sessions ADD duration_minutes INT NOT NULL DEFAULT 0",
        'last_activity' => "ALTER TABLE student_practice_sessions ADD last_activity DATETIME NULL",
    ];

    foreach ($session_columns as $column => $sql) {
        if (!practice_table_has_column($conn, 'student_practice_sessions', $column)) {
            mysqli_query($conn, $sql);
        }
    }

    practice_add_index_if_missing(
        $conn,
        'student_practice_sessions',
        'idx_sps_student_status',
        "ALTER TABLE student_practice_sessions ADD INDEX idx_sps_student_status (student_id, status)"
    );
    practice_add_index_if_missing(
        $conn,
        'student_practice_sessions',
        'idx_sps_school_class',
        "ALTER TABLE student_practice_sessions ADD INDEX idx_sps_school_class (school_id, class_id)"
    );
    practice_add_index_if_missing(
        $conn,
        'student_practice_sessions',
        'idx_sps_subject_topic',
        "ALTER TABLE student_practice_sessions ADD INDEX idx_sps_subject_topic (subject_id, topic_id)"
    );
    practice_add_index_if_missing(
        $conn,
        'student_practice_answers',
        'idx_spa_student',
        "ALTER TABLE student_practice_answers ADD INDEX idx_spa_student (student_id)"
    );
    practice_add_index_if_missing(
        $conn,
        'student_practice_answers',
        'idx_spa_question',
        "ALTER TABLE student_practice_answers ADD INDEX idx_spa_question (question_id)"
    );
}

function practice_bind_params($stmt, $types, $params)
{
    if ($types === '') {
        return;
    }

    $refs = [];
    $refs[] = $types;
    foreach ($params as $key => $value) {
        $refs[] = &$params[$key];
    }
    call_user_func_array([$stmt, 'bind_param'], $refs);
}

function practice_fetch_all($conn, $sql, $types = '', $params = [])
{
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        practice_json(['status' => 'error', 'message' => 'Unable to prepare request.']);
    }

    practice_bind_params($stmt, $types, $params);
    if (!$stmt->execute()) {
        practice_json(['status' => 'error', 'message' => 'Unable to complete request.']);
    }

    $result = $stmt->get_result();
    $rows = [];
    while ($result && $row = $result->fetch_assoc()) {
        $rows[] = $row;
    }
    $stmt->close();
    return $rows;
}

function practice_fetch_one($conn, $sql, $types = '', $params = [])
{
    $rows = practice_fetch_all($conn, $sql, $types, $params);
    return $rows[0] ?? null;
}

function practice_get_student_class_id($conn, $student_id, $school_id)
{
    $row = practice_fetch_one(
        $conn,
        "SELECT class_id FROM students WHERE id = ? AND school_id = ? LIMIT 1",
        "ii",
        [$student_id, $school_id]
    );
    return (int)($row['class_id'] ?? 0);
}

function practice_base_where($school_id, $class_id)
{
    return [
        "q.deleted = 0
            AND q.review_status = 'approved'
            AND (q.school_id = 0 OR q.school_id = ?)
            AND (q.class_id = 0 OR q.class_id = ?)",
        "ii",
        [$school_id, $class_id],
    ];
}

function practice_filtered_where($school_id, $class_id, $scope, $subject_id, $topic_id, $difficulty)
{
    [$where, $types, $params] = practice_base_where($school_id, $class_id);

    if ($scope !== 'mixed_subject' && $subject_id > 0) {
        $where .= " AND q.subject_id = ?";
        $types .= "i";
        $params[] = $subject_id;
    }

    if ($scope === 'topic' && $topic_id > 0) {
        $where .= " AND q.topic_id = ?";
        $types .= "i";
        $params[] = $topic_id;
    }

    if ($difficulty !== 'Mixed') {
        $where .= " AND q.difficulty = ?";
        $types .= "s";
        $params[] = $difficulty;
    }

    return [$where, $types, $params];
}

function practice_load_session($conn, $session_id, $student_id)
{
    return practice_fetch_one(
        $conn,
        "SELECT * FROM student_practice_sessions WHERE id = ? AND student_id = ? LIMIT 1",
        "ii",
        [$session_id, $student_id]
    );
}

function practice_decode_question_ids($question_ids_json)
{
    $ids = json_decode($question_ids_json, true);
    if (!is_array($ids)) {
        return [];
    }
    return array_values(array_filter(array_map('intval', $ids), fn($id) => $id > 0));
}

practice_ensure_schema($conn);

$student_id = (int)$_SESSION['userid'];
$school_id = (int)($_SESSION['school_id'] ?? 0);
$class_id = practice_get_student_class_id($conn, $student_id, $school_id);
$action = $_POST['action'] ?? '';

if ($action === 'get_filters') {
    [$where, $types, $params] = practice_base_where($school_id, $class_id);

    $subjects = practice_fetch_all(
        $conn,
        "SELECT q.subject_id AS id, s.subject, COUNT(*) AS question_count
            FROM question_bank q
            INNER JOIN subjects s ON s.id = q.subject_id
            WHERE $where
            GROUP BY q.subject_id, s.subject
            ORDER BY s.subject ASC",
        $types,
        $params
    );

    $topics = practice_fetch_all(
        $conn,
        "SELECT q.topic_id AS id, t.topic_name, q.subject_id, COUNT(*) AS question_count
            FROM question_bank q
            INNER JOIN topics t ON t.id = q.topic_id
            WHERE $where AND q.topic_id > 0
            GROUP BY q.topic_id, t.topic_name, q.subject_id
            ORDER BY t.topic_name ASC",
        $types,
        $params
    );

    $difficulties = practice_fetch_all(
        $conn,
        "SELECT q.difficulty, COUNT(*) AS question_count
            FROM question_bank q
            WHERE $where
            GROUP BY q.difficulty
            ORDER BY FIELD(q.difficulty, 'Easy', 'Medium', 'Hard'), q.difficulty",
        $types,
        $params
    );

    practice_json([
        'status' => 'success',
        'data' => [
            'subjects' => $subjects,
            'topics' => $topics,
            'difficulties' => $difficulties,
            'counts' => PRACTICE_ALLOWED_COUNTS,
            'timer_minutes' => PRACTICE_DEFAULT_TIMER_MINUTES,
        ],
    ]);
}

if ($action === 'start_session') {
    $scope = $_POST['practice_scope'] ?? 'subject';
    $subject_id = (int)($_POST['subject_id'] ?? 0);
    $topic_id = (int)($_POST['topic_id'] ?? 0);
    $difficulty = $_POST['difficulty'] ?? 'Mixed';
    $requested_count = (int)($_POST['question_count'] ?? 10);
    $timed = (int)($_POST['timed'] ?? 0) === 1 ? 1 : 0;
    $duration_minutes = $timed ? PRACTICE_DEFAULT_TIMER_MINUTES : 0;

    if (!in_array($scope, PRACTICE_ALLOWED_SCOPES, true)) {
        $scope = 'subject';
    }
    if (!in_array($difficulty, PRACTICE_ALLOWED_DIFFICULTIES, true)) {
        $difficulty = 'Mixed';
    }
    if (!in_array($requested_count, PRACTICE_ALLOWED_COUNTS, true)) {
        $requested_count = 10;
    }
    if ($scope !== 'mixed_subject' && $subject_id <= 0) {
        practice_json(['status' => 'error', 'message' => 'Please choose a subject first.']);
    }
    if ($scope === 'topic' && $topic_id <= 0) {
        practice_json(['status' => 'error', 'message' => 'Please choose a topic first.']);
    }

    [$where, $types, $params] = practice_filtered_where($school_id, $class_id, $scope, $subject_id, $topic_id, $difficulty);
    $available = practice_fetch_one($conn, "SELECT COUNT(*) AS total FROM question_bank q WHERE $where", $types, $params);
    $available_count = (int)($available['total'] ?? 0);

    if ($available_count === 0) {
        practice_json([
            'status' => 'error',
            'message' => 'No practice questions are ready for this choice yet. Try another subject or topic.',
        ]);
    }

    $session_count = min($requested_count, $available_count);
    $candidate_limit = min(PRACTICE_CANDIDATE_LIMIT, max($session_count * 5, $session_count));
    $candidate_types = $types . 'i';
    $candidate_params = array_merge($params, [$candidate_limit]);

    $candidate_rows = practice_fetch_all(
        $conn,
        "SELECT q.id
            FROM question_bank q
            WHERE $where
            ORDER BY q.times_used ASC, q.id ASC
            LIMIT ?",
        $candidate_types,
        $candidate_params
    );

    $question_ids = array_map(fn($row) => (int)$row['id'], $candidate_rows);
    shuffle($question_ids);
    $question_ids = array_slice($question_ids, 0, $session_count);

    if (empty($question_ids)) {
        practice_json(['status' => 'error', 'message' => 'No practice questions are ready for this choice yet.']);
    }

    $question_ids_json = json_encode($question_ids);
    $stmt = $conn->prepare("INSERT INTO student_practice_sessions
        (student_id, school_id, class_id, subject_id, topic_id, practice_scope, difficulty, question_count, timed,
         duration_minutes, question_ids, total_questions, status, started_at, last_activity)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'in_progress', NOW(), NOW())");
    if (!$stmt) {
        practice_json(['status' => 'error', 'message' => 'Unable to start practice.']);
    }
    $stmt->bind_param(
        "iiiiissiiisi",
        $student_id,
        $school_id,
        $class_id,
        $subject_id,
        $topic_id,
        $scope,
        $difficulty,
        $requested_count,
        $timed,
        $duration_minutes,
        $question_ids_json,
        $session_count
    );
    if (!$stmt->execute()) {
        practice_json(['status' => 'error', 'message' => 'Unable to start practice.']);
    }
    $session_id = (int)$conn->insert_id;
    $stmt->close();

    $ids_for_update = implode(',', array_map('intval', $question_ids));
    mysqli_query($conn, "UPDATE question_bank SET times_used = times_used + 1 WHERE id IN ($ids_for_update)");

    practice_json([
        'status' => 'success',
        'message' => $session_count < $requested_count
            ? "Only $session_count question(s) are available, so practice will start with those."
            : 'Practice started.',
        'data' => [
            'session_id' => $session_id,
            'total_questions' => $session_count,
            'timed' => $timed,
            'duration_seconds' => $duration_minutes * 60,
        ],
    ]);
}

if ($action === 'get_question') {
    $session_id = (int)($_POST['session_id'] ?? 0);
    $position = max(1, (int)($_POST['position'] ?? 1));
    $session = practice_load_session($conn, $session_id, $student_id);
    if (!$session) {
        practice_json(['status' => 'error', 'message' => 'Practice session was not found.']);
    }

    $question_ids = practice_decode_question_ids($session['question_ids']);
    $question_id = $question_ids[$position - 1] ?? 0;
    if ($question_id <= 0) {
        practice_json(['status' => 'error', 'message' => 'Question was not found.']);
    }

    $question = practice_fetch_one(
        $conn,
        "SELECT q.id, q.question, q.subject_id, q.topic_id, q.difficulty, s.subject, t.topic_name
            FROM question_bank q
            LEFT JOIN subjects s ON s.id = q.subject_id
            LEFT JOIN topics t ON t.id = q.topic_id
            WHERE q.id = ? AND q.deleted = 0 AND q.review_status = 'approved'
            LIMIT 1",
        "i",
        [$question_id]
    );
    if (!$question) {
        practice_json(['status' => 'error', 'message' => 'Question was not found.']);
    }

    $options = practice_fetch_all(
        $conn,
        "SELECT id, options AS text FROM question_bank_options WHERE question_id = ? AND deleted = 0 ORDER BY id ASC",
        "i",
        [$question_id]
    );
    $saved = practice_fetch_one(
        $conn,
        "SELECT selected_option_id FROM student_practice_answers WHERE session_id = ? AND student_id = ? AND question_id = ? LIMIT 1",
        "iii",
        [$session_id, $student_id, $question_id]
    );

    practice_json([
        'status' => 'success',
        'data' => [
            'question' => $question,
            'options' => $options,
            'selected_option_id' => (int)($saved['selected_option_id'] ?? 0),
            'position' => $position,
            'total_questions' => count($question_ids),
            'status' => $session['status'],
        ],
    ]);
}

if ($action === 'save_answer') {
    $session_id = (int)($_POST['session_id'] ?? 0);
    $question_id = (int)($_POST['question_id'] ?? 0);
    $option_id = (int)($_POST['option_id'] ?? 0);
    $session = practice_load_session($conn, $session_id, $student_id);

    if (!$session || $session['status'] !== 'in_progress') {
        practice_json(['status' => 'error', 'message' => 'This practice session is no longer active.']);
    }

    $question_ids = practice_decode_question_ids($session['question_ids']);
    if (!in_array($question_id, $question_ids, true)) {
        practice_json(['status' => 'error', 'message' => 'This question is not part of your practice.']);
    }

    $option = practice_fetch_one(
        $conn,
        "SELECT answer FROM question_bank_options WHERE id = ? AND question_id = ? AND deleted = 0 LIMIT 1",
        "ii",
        [$option_id, $question_id]
    );
    if (!$option) {
        practice_json(['status' => 'error', 'message' => 'Please choose one of the answer options.']);
    }

    $is_correct = (int)$option['answer'] === 1 ? 1 : 0;
    $stmt = $conn->prepare("INSERT INTO student_practice_answers
        (session_id, student_id, question_id, selected_option_id, is_correct, answered_at)
        VALUES (?, ?, ?, ?, ?, NOW())
        ON DUPLICATE KEY UPDATE selected_option_id = VALUES(selected_option_id), is_correct = VALUES(is_correct), answered_at = NOW()");
    if (!$stmt) {
        practice_json(['status' => 'error', 'message' => 'Unable to save your answer.']);
    }
    $stmt->bind_param("iiiii", $session_id, $student_id, $question_id, $option_id, $is_correct);
    if (!$stmt->execute()) {
        practice_json(['status' => 'error', 'message' => 'Unable to save your answer.']);
    }
    $stmt->close();

    $touch = $conn->prepare("UPDATE student_practice_sessions SET last_activity = NOW() WHERE id = ? AND student_id = ?");
    $touch->bind_param("ii", $session_id, $student_id);
    $touch->execute();
    $touch->close();

    practice_json(['status' => 'success', 'message' => 'Answer saved.']);
}

if ($action === 'finish_session') {
    $session_id = (int)($_POST['session_id'] ?? 0);
    $session = practice_load_session($conn, $session_id, $student_id);
    if (!$session) {
        practice_json(['status' => 'error', 'message' => 'Practice session was not found.']);
    }

    $question_ids = practice_decode_question_ids($session['question_ids']);
    if (empty($question_ids)) {
        practice_json(['status' => 'error', 'message' => 'This practice has no questions.']);
    }

    $score_row = practice_fetch_one(
        $conn,
        "SELECT COUNT(*) AS score
            FROM student_practice_answers
            WHERE session_id = ? AND student_id = ? AND is_correct = 1",
        "ii",
        [$session_id, $student_id]
    );
    $score = (int)($score_row['score'] ?? 0);
    $total = count($question_ids);

    $stmt = $conn->prepare("UPDATE student_practice_sessions
        SET score = ?, total_questions = ?, status = 'completed', completed_at = NOW(), last_activity = NOW()
        WHERE id = ? AND student_id = ?");
    $stmt->bind_param("iiii", $score, $total, $session_id, $student_id);
    $stmt->execute();
    $stmt->close();

    $ids = implode(',', array_map('intval', $question_ids));
    $review_rows = practice_fetch_all(
        $conn,
        "SELECT q.id AS question_id, q.question, q.explanation, qo.id AS option_id, qo.options AS option_text,
                qo.answer, spa.selected_option_id
            FROM question_bank q
            INNER JOIN question_bank_options qo ON qo.question_id = q.id AND qo.deleted = 0
            LEFT JOIN student_practice_answers spa
                ON spa.question_id = q.id AND spa.session_id = ? AND spa.student_id = ?
            WHERE q.id IN ($ids)
            ORDER BY FIELD(q.id, $ids), qo.id ASC",
        "ii",
        [$session_id, $student_id]
    );

    $review = [];
    foreach ($review_rows as $row) {
        $qid = (int)$row['question_id'];
        if (!isset($review[$qid])) {
            $review[$qid] = [
                'question_id' => $qid,
                'question' => $row['question'],
                'explanation' => $row['explanation'],
                'selected_option_id' => (int)($row['selected_option_id'] ?? 0),
                'correct_option_id' => 0,
                'correct_option_text' => '',
                'options' => [],
            ];
        }

        $option = [
            'id' => (int)$row['option_id'],
            'text' => $row['option_text'],
            'is_correct' => (int)$row['answer'] === 1,
        ];
        $review[$qid]['options'][] = $option;

        if ($option['is_correct']) {
            $review[$qid]['correct_option_id'] = $option['id'];
            $review[$qid]['correct_option_text'] = $option['text'];
        }
    }

    practice_json([
        'status' => 'success',
        'message' => 'Practice completed.',
        'data' => [
            'score' => $score,
            'total_questions' => $total,
            'percentage' => $total > 0 ? round(($score / $total) * 100, 1) : 0,
            'review' => array_values($review),
        ],
    ]);
}

practice_json(['status' => 'error', 'message' => 'Unknown practice action.']);
