<?php
session_start();
header('Content-Type: application/json');

if (!isset($_SESSION['userid'])) {
    echo json_encode(['status' => 'error', 'message' => 'Unauthorized']);
    exit();
}

include_once("model/connect.php");
include_once("model/ai_usage.php");
include_once("model/ai_client.php");

$userid = (int)$_SESSION['userid'];
$school_id = isset($_SESSION['school_id']) ? (int)$_SESSION['school_id'] : 0;
$action = $_POST['action'] ?? '';

function qb_json($payload)
{
    echo json_encode($payload);
    exit();
}

function qb_is_ss360_admin()
{
    $truthy_flags = ['is_ss360_admin', 'platform_admin', 'super_admin'];
    foreach ($truthy_flags as $flag) {
        if (!empty($_SESSION[$flag])) {
            return true;
        }
    }

    return (int)($_SESSION['school_id'] ?? -1) === 0;
}

function qb_ensure_platform_admin_schema($conn)
{
    mysqli_query($conn, "CREATE TABLE IF NOT EXISTS ss360_platform_admins (
        id INT AUTO_INCREMENT PRIMARY KEY,
        staff_id INT NOT NULL,
        school_id INT NOT NULL,
        status TINYINT(1) NOT NULL DEFAULT 1,
        datecreated DATETIME NULL,
        UNIQUE KEY uniq_ss360_platform_admin (staff_id, school_id),
        KEY idx_ss360_platform_admin_status (status)
    )");
}

function qb_is_allowed_platform_admin($conn)
{
    if (qb_is_ss360_admin()) {
        return true;
    }

    qb_ensure_platform_admin_schema($conn);
    $staff_id = (int)($_SESSION['userid'] ?? 0);
    $school_id = (int)($_SESSION['school_id'] ?? 0);
    if ($staff_id <= 0 || $school_id <= 0) {
        return false;
    }

    $stmt = $conn->prepare("SELECT id FROM ss360_platform_admins WHERE staff_id = ? AND school_id = ? AND status = 1 LIMIT 1");
    $stmt->bind_param("ii", $staff_id, $school_id);
    $stmt->execute();
    return $stmt->get_result()->num_rows > 0;
}

function qb_require_ss360_admin()
{
    global $conn;
    if (!qb_is_allowed_platform_admin($conn)) {
        qb_json(['status' => 'error', 'message' => 'Only SchoolSuite360 admins can manage the global question bank.']);
    }
}

function qb_table_has_column($conn, $table, $column)
{
    $table = mysqli_real_escape_string($conn, $table);
    $column = mysqli_real_escape_string($conn, $column);
    $result = mysqli_query($conn, "SHOW COLUMNS FROM `$table` LIKE '$column'");
    return $result && mysqli_num_rows($result) > 0;
}

function qb_table_has_index($conn, $table, $index)
{
    $table = mysqli_real_escape_string($conn, $table);
    $index = mysqli_real_escape_string($conn, $index);
    $result = mysqli_query($conn, "SHOW INDEX FROM `$table` WHERE Key_name = '$index'");
    return $result && mysqli_num_rows($result) > 0;
}

function qb_add_index_if_missing($conn, $table, $index, $sql)
{
    if (!qb_table_has_index($conn, $table, $index)) {
        mysqli_query($conn, $sql);
    }
}

function qb_ensure_schema($conn)
{
    qb_ensure_platform_admin_schema($conn);

    mysqli_query($conn, "CREATE TABLE IF NOT EXISTS question_bank (
        id INT AUTO_INCREMENT PRIMARY KEY,
        question TEXT NOT NULL,
        subject_id INT NOT NULL DEFAULT 0,
        class_id INT NOT NULL DEFAULT 0,
        source_type VARCHAR(30) NOT NULL DEFAULT 'topic',
        exam_body_id INT NOT NULL DEFAULT 0,
        topic_id INT NOT NULL DEFAULT 0,
        difficulty VARCHAR(20) NOT NULL DEFAULT 'Medium',
        recommended_class VARCHAR(100) NULL,
        term_tag VARCHAR(50) NULL,
        question_category VARCHAR(100) NULL,
        explanation TEXT NULL,
        review_status VARCHAR(20) NOT NULL DEFAULT 'approved',
        quality_score INT NOT NULL DEFAULT 0,
        times_used INT NOT NULL DEFAULT 0,
        school_id INT NOT NULL DEFAULT 0,
        createdby INT NOT NULL DEFAULT 0,
        datecreated DATETIME NULL,
        dateupdated DATETIME NULL,
        deleted TINYINT(1) NOT NULL DEFAULT 0,
        KEY idx_qb_subject_source (subject_id, source_type),
        KEY idx_qb_topic (topic_id),
        KEY idx_qb_exam_body (exam_body_id),
        KEY idx_qb_school_deleted (school_id, deleted)
    )");

    mysqli_query($conn, "CREATE TABLE IF NOT EXISTS question_bank_options (
        id INT AUTO_INCREMENT PRIMARY KEY,
        question_id INT NOT NULL,
        options TEXT NOT NULL,
        answer TINYINT(1) NOT NULL DEFAULT 0,
        deleted TINYINT(1) NOT NULL DEFAULT 0,
        KEY idx_qbo_question (question_id)
    )");

    $columns = [
        'class_id' => "ALTER TABLE question_bank ADD class_id INT NOT NULL DEFAULT 0",
        'difficulty' => "ALTER TABLE question_bank ADD difficulty VARCHAR(20) NOT NULL DEFAULT 'Medium'",
        'recommended_class' => "ALTER TABLE question_bank ADD recommended_class VARCHAR(100) NULL",
        'term_tag' => "ALTER TABLE question_bank ADD term_tag VARCHAR(50) NULL",
        'question_category' => "ALTER TABLE question_bank ADD question_category VARCHAR(100) NULL",
        'explanation' => "ALTER TABLE question_bank ADD explanation TEXT NULL",
        'review_status' => "ALTER TABLE question_bank ADD review_status VARCHAR(20) NOT NULL DEFAULT 'approved'",
        'quality_score' => "ALTER TABLE question_bank ADD quality_score INT NOT NULL DEFAULT 0",
        'times_used' => "ALTER TABLE question_bank ADD times_used INT NOT NULL DEFAULT 0",
        'school_id' => "ALTER TABLE question_bank ADD school_id INT NOT NULL DEFAULT 0",
        'createdby' => "ALTER TABLE question_bank ADD createdby INT NOT NULL DEFAULT 0",
        'datecreated' => "ALTER TABLE question_bank ADD datecreated DATETIME NULL",
        'dateupdated' => "ALTER TABLE question_bank ADD dateupdated DATETIME NULL",
        'deleted' => "ALTER TABLE question_bank ADD deleted TINYINT(1) NOT NULL DEFAULT 0",
    ];

    foreach ($columns as $column => $sql) {
        if (!qb_table_has_column($conn, 'question_bank', $column)) {
            mysqli_query($conn, $sql);
        }
    }

    if (!qb_table_has_column($conn, 'question_bank_options', 'deleted')) {
        mysqli_query($conn, "ALTER TABLE question_bank_options ADD deleted TINYINT(1) NOT NULL DEFAULT 0");
    }

    qb_add_index_if_missing($conn, 'question_bank', 'idx_qb_global_lookup', "ALTER TABLE question_bank ADD INDEX idx_qb_global_lookup (school_id, deleted, review_status, subject_id, topic_id, difficulty)");
    qb_add_index_if_missing($conn, 'question_bank', 'idx_qb_soft_filters', "ALTER TABLE question_bank ADD INDEX idx_qb_soft_filters (recommended_class, term_tag, question_category)");
    qb_add_index_if_missing($conn, 'question_bank', 'idx_qb_quality', "ALTER TABLE question_bank ADD INDEX idx_qb_quality (quality_score, times_used)");

    mysqli_query($conn, "CREATE TABLE IF NOT EXISTS question_bank_feedback (
        id INT AUTO_INCREMENT PRIMARY KEY,
        question_id INT NOT NULL,
        school_id INT NOT NULL DEFAULT 0,
        user_id INT NOT NULL DEFAULT 0,
        feedback_type VARCHAR(40) NOT NULL,
        datecreated DATETIME NULL,
        KEY idx_qbf_question (question_id),
        KEY idx_qbf_type (feedback_type)
    )");
}

function qb_clean_html($value)
{
    $allowed = '<p><br><b><strong><i><em><u><sup><sub><span><div><ol><ul><li><table><thead><tbody><tr><th><td>';
    return trim(strip_tags((string)$value, $allowed));
}

function qb_clean_text($value, $max_length = 100)
{
    return substr(trim(strip_tags((string)$value)), 0, $max_length);
}

function qb_normalize_question($value)
{
    $plain = strtolower(trim(strip_tags((string)$value)));
    $plain = preg_replace('/\s+/', ' ', $plain);
    return preg_replace('/[^a-z0-9 ]/', '', $plain);
}

function qb_question_duplicate_exists($conn, $question_id, $question, $subject_id, $topic_id, $difficulty)
{
    $normalized = qb_normalize_question($question);
    if ($normalized === '') {
        return false;
    }

    $stmt = $conn->prepare("SELECT id, question FROM question_bank WHERE deleted = 0 AND id <> ? AND subject_id = ? AND topic_id = ? AND difficulty = ?");
    $stmt->bind_param("iiis", $question_id, $subject_id, $topic_id, $difficulty);
    $stmt->execute();
    $result = $stmt->get_result();
    while ($row = $result->fetch_assoc()) {
        if (qb_normalize_question($row['question']) === $normalized) {
            return true;
        }
    }

    return false;
}

function qb_fetch_options($conn, $question_ids)
{
    if (empty($question_ids)) {
        return [];
    }

    $ids = implode(',', array_map('intval', $question_ids));
    $options = [];
    $result = mysqli_query($conn, "SELECT id, question_id, options, answer FROM question_bank_options WHERE question_id IN ($ids) AND deleted = 0 ORDER BY id ASC");

    while ($result && $row = mysqli_fetch_assoc($result)) {
        $options[(int)$row['question_id']][] = $row;
    }

    return $options;
}

qb_ensure_schema($conn);

if ($action === 'get_meta') {
    $subjects = [];
    $topics = [];
    $exam_bodies = [];
    $classes = [];

    $subject_result = mysqli_query($conn, "SELECT id, subject FROM subjects ORDER BY subject ASC");
    while ($subject_result && $row = mysqli_fetch_assoc($subject_result)) {
        $subjects[] = $row;
    }

    $topic_result = mysqli_query($conn, "SELECT id, topic_name, subject_id, class_id FROM topics ORDER BY topic_name ASC");
    while ($topic_result && $row = mysqli_fetch_assoc($topic_result)) {
        $topics[] = $row;
    }

    $exam_result = mysqli_query($conn, "SELECT id, name FROM exam_bodies ORDER BY name ASC");
    while ($exam_result && $row = mysqli_fetch_assoc($exam_result)) {
        $exam_bodies[] = $row;
    }

    $class_stmt = $conn->prepare("SELECT id, classname FROM class WHERE school_id = ? ORDER BY id ASC");
    $class_stmt->bind_param("i", $school_id);
    $class_stmt->execute();
    $class_result = $class_stmt->get_result();
    while ($row = $class_result->fetch_assoc()) {
        $classes[] = $row;
    }

    qb_json([
        'status' => 'success',
        'data' => [
            'subjects' => $subjects,
            'topics' => $topics,
            'exam_bodies' => $exam_bodies,
            'classes' => $classes,
        ],
    ]);
}

if ($action === 'list_questions') {
    $page = max(1, (int)($_POST['page'] ?? 1));
    $per_page = min(50, max(5, (int)($_POST['per_page'] ?? 10)));
    $offset = ($page - 1) * $per_page;
    $search = trim((string)($_POST['search'] ?? ''));
    $subject_id = (int)($_POST['subject_id'] ?? 0);
    $source_type = trim((string)($_POST['source_type'] ?? ''));
    $topic_id = (int)($_POST['topic_id'] ?? 0);
    $difficulty = trim((string)($_POST['difficulty'] ?? ''));
    $review_status = trim((string)($_POST['review_status'] ?? ''));
    $recommended_class = trim((string)($_POST['recommended_class'] ?? ''));
    $term_tag = trim((string)($_POST['term_tag'] ?? ''));
    $question_category = trim((string)($_POST['question_category'] ?? ''));

    $where = ["q.deleted = 0"];
    $params = [];
    $types = '';

    if ($search !== '') {
        $where[] = "q.question LIKE ?";
        $params[] = '%' . $search . '%';
        $types .= 's';
    }

    if ($subject_id > 0) {
        $where[] = "q.subject_id = ?";
        $params[] = $subject_id;
        $types .= 'i';
    }

    if ($source_type !== '') {
        $where[] = "q.source_type = ?";
        $params[] = $source_type;
        $types .= 's';
    }

    if ($topic_id > 0) {
        $where[] = "q.topic_id = ?";
        $params[] = $topic_id;
        $types .= 'i';
    }

    if (in_array($difficulty, ['Easy', 'Medium', 'Hard'], true)) {
        $where[] = "q.difficulty = ?";
        $params[] = $difficulty;
        $types .= 's';
    }

    if (in_array($review_status, ['draft', 'approved', 'rejected'], true)) {
        $where[] = "q.review_status = ?";
        $params[] = $review_status;
        $types .= 's';
    }

    if ($recommended_class !== '') {
        $where[] = "q.recommended_class LIKE ?";
        $params[] = '%' . $recommended_class . '%';
        $types .= 's';
    }

    if ($term_tag !== '') {
        $where[] = "q.term_tag LIKE ?";
        $params[] = '%' . $term_tag . '%';
        $types .= 's';
    }

    if ($question_category !== '') {
        $where[] = "q.question_category LIKE ?";
        $params[] = '%' . $question_category . '%';
        $types .= 's';
    }

    $where_sql = implode(' AND ', $where);
    $count_sql = "SELECT COUNT(*) AS total FROM question_bank q WHERE $where_sql";
    $count_stmt = $conn->prepare($count_sql);
    if ($params) {
        $count_stmt->bind_param($types, ...$params);
    }
    $count_stmt->execute();
    $total = (int)$count_stmt->get_result()->fetch_assoc()['total'];

    $sql = "SELECT q.id, q.question, q.subject_id, q.class_id, q.source_type, q.exam_body_id, q.topic_id, q.difficulty,
                   q.recommended_class, q.term_tag, q.question_category, q.explanation, q.review_status, q.quality_score, q.times_used,
                   s.subject, c.classname, eb.name AS exam_body_name, t.topic_name
            FROM question_bank q
            LEFT JOIN subjects s ON s.id = q.subject_id
            LEFT JOIN class c ON c.id = q.class_id
            LEFT JOIN exam_bodies eb ON eb.id = q.exam_body_id
            LEFT JOIN topics t ON t.id = q.topic_id
            WHERE $where_sql
            ORDER BY q.id DESC
            LIMIT ? OFFSET ?";

    $list_params = $params;
    $list_params[] = $per_page;
    $list_params[] = $offset;
    $list_types = $types . 'ii';
    $stmt = $conn->prepare($sql);
    $stmt->bind_param($list_types, ...$list_params);
    $stmt->execute();
    $result = $stmt->get_result();

    $questions = [];
    while ($row = $result->fetch_assoc()) {
        $row['id'] = (int)$row['id'];
        $questions[] = $row;
    }

    $options_map = qb_fetch_options($conn, array_column($questions, 'id'));
    foreach ($questions as &$question) {
        $question['options'] = $options_map[$question['id']] ?? [];
    }

    qb_json([
        'status' => 'success',
        'data' => $questions,
        'pagination' => [
            'page' => $page,
            'per_page' => $per_page,
            'total' => $total,
            'total_pages' => max(1, (int)ceil($total / $per_page)),
        ],
    ]);
}

if ($action === 'save_question') {
    qb_require_ss360_admin();

    $question_id = (int)($_POST['question_id'] ?? 0);
    $question = qb_clean_html($_POST['question'] ?? '');
    $subject_id = (int)($_POST['subject_id'] ?? 0);
    $class_id = (int)($_POST['class_id'] ?? 0);
    $source_type = in_array($_POST['source_type'] ?? 'topic', ['topic', 'exam_body'], true) ? $_POST['source_type'] : 'topic';
    $topic_id = $source_type === 'topic' ? (int)($_POST['topic_id'] ?? 0) : 0;
    $exam_body_id = $source_type === 'exam_body' ? (int)($_POST['exam_body_id'] ?? 0) : 0;
    $difficulty = in_array($_POST['difficulty'] ?? 'Medium', ['Easy', 'Medium', 'Hard'], true) ? $_POST['difficulty'] : 'Medium';
    $recommended_class = qb_clean_text($_POST['recommended_class'] ?? '', 100);
    $term_tag = qb_clean_text($_POST['term_tag'] ?? '', 50);
    $question_category = qb_clean_text($_POST['question_category'] ?? '', 100);
    $explanation = qb_clean_html($_POST['explanation'] ?? '');
    $review_status = in_array($_POST['review_status'] ?? 'draft', ['draft', 'approved', 'rejected'], true) ? $_POST['review_status'] : 'draft';
    $options = json_decode($_POST['options'] ?? '[]', true);

    if ($question === '' || $subject_id <= 0 || !is_array($options) || count($options) < 2) {
        qb_json(['status' => 'error', 'message' => 'Question, subject, and at least two options are required.']);
    }

    if ($source_type === 'topic' && $topic_id <= 0) {
        qb_json(['status' => 'error', 'message' => 'Select a topic for topic-based questions.']);
    }

    if ($source_type === 'exam_body' && $exam_body_id <= 0) {
        qb_json(['status' => 'error', 'message' => 'Select an exam body for exam-body questions.']);
    }

    $valid_options = [];
    $correct_count = 0;
    foreach ($options as $option) {
        $text = qb_clean_html($option['text'] ?? '');
        $is_correct = !empty($option['is_correct']) ? 1 : 0;
        if ($text === '') {
            continue;
        }
        $correct_count += $is_correct;
        $valid_options[] = ['text' => $text, 'is_correct' => $is_correct];
    }

    if (count($valid_options) < 2 || $correct_count !== 1) {
        qb_json(['status' => 'error', 'message' => 'Add at least two options and select exactly one correct answer.']);
    }

    if (qb_question_duplicate_exists($conn, $question_id, $question, $subject_id, $topic_id, $difficulty)) {
        qb_json(['status' => 'error', 'message' => 'A similar question already exists for this subject, topic, and difficulty.']);
    }

    if ($question_id > 0) {
        $stmt = $conn->prepare("UPDATE question_bank
            SET question = ?, subject_id = ?, class_id = ?, source_type = ?, exam_body_id = ?, topic_id = ?, difficulty = ?,
                recommended_class = ?, term_tag = ?, question_category = ?, explanation = ?, review_status = ?, dateupdated = NOW()
            WHERE id = ? AND deleted = 0");
        $stmt->bind_param("siisiissssssi", $question, $subject_id, $class_id, $source_type, $exam_body_id, $topic_id, $difficulty, $recommended_class, $term_tag, $question_category, $explanation, $review_status, $question_id);
        $saved = $stmt->execute();
    } else {
        $stmt = $conn->prepare("INSERT INTO question_bank
            (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag,
             question_category, explanation, review_status, school_id, createdby, datecreated)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, ?, NOW())");
        $stmt->bind_param("siisiissssssi", $question, $subject_id, $class_id, $source_type, $exam_body_id, $topic_id, $difficulty, $recommended_class, $term_tag, $question_category, $explanation, $review_status, $userid);
        $saved = $stmt->execute();
        $question_id = (int)$conn->insert_id;
    }

    if (!$saved) {
        qb_json(['status' => 'error', 'message' => 'Unable to save question.']);
    }

    $delete_stmt = $conn->prepare("DELETE FROM question_bank_options WHERE question_id = ?");
    $delete_stmt->bind_param("i", $question_id);
    $delete_stmt->execute();

    $option_stmt = $conn->prepare("INSERT INTO question_bank_options (question_id, options, answer) VALUES (?, ?, ?)");
    foreach ($valid_options as $option) {
        $option_stmt->bind_param("isi", $question_id, $option['text'], $option['is_correct']);
        $option_stmt->execute();
    }

    qb_json(['status' => 'success', 'message' => 'Question saved successfully.']);
}

if ($action === 'delete_question') {
    qb_require_ss360_admin();

    $question_id = (int)($_POST['question_id'] ?? 0);
    if ($question_id <= 0) {
        qb_json(['status' => 'error', 'message' => 'Invalid question selected.']);
    }

    $option_stmt = $conn->prepare("DELETE FROM question_bank_options WHERE question_id = ?");
    $option_stmt->bind_param("i", $question_id);
    $option_stmt->execute();

    $stmt = $conn->prepare("DELETE FROM question_bank WHERE id = ?");
    $stmt->bind_param("i", $question_id);
    $stmt->execute();

    qb_json(['status' => 'success', 'message' => 'Question deleted successfully.']);
}

if ($action === 'update_review_status') {
    qb_require_ss360_admin();

    $question_id = (int)($_POST['question_id'] ?? 0);
    $review_status = $_POST['review_status'] ?? '';

    if ($question_id <= 0 || !in_array($review_status, ['draft', 'approved', 'rejected'], true)) {
        qb_json(['status' => 'error', 'message' => 'Invalid review update.']);
    }

    $stmt = $conn->prepare("UPDATE question_bank SET review_status = ?, dateupdated = NOW() WHERE id = ? AND deleted = 0");
    $stmt->bind_param("si", $review_status, $question_id);
    $stmt->execute();

    qb_json(['status' => 'success', 'message' => 'Review status updated.']);
}

if ($action === 'record_feedback') {
    $question_id = (int)($_POST['question_id'] ?? 0);
    $feedback_type = qb_clean_text($_POST['feedback_type'] ?? '', 40);
    $allowed_feedback = ['useful', 'too_easy', 'too_hard', 'wrong_answer', 'poorly_worded', 'not_relevant'];

    if ($question_id <= 0 || !in_array($feedback_type, $allowed_feedback, true)) {
        qb_json(['status' => 'error', 'message' => 'Invalid feedback.']);
    }

    $stmt = $conn->prepare("INSERT INTO question_bank_feedback (question_id, school_id, user_id, feedback_type, datecreated) VALUES (?, ?, ?, ?, NOW())");
    $stmt->bind_param("iiis", $question_id, $school_id, $userid, $feedback_type);
    $stmt->execute();

    $delta = $feedback_type === 'useful' ? 2 : -2;
    if (in_array($feedback_type, ['wrong_answer', 'not_relevant'], true)) {
        $delta = -5;
    }
    $stmt = $conn->prepare("UPDATE question_bank SET quality_score = quality_score + ? WHERE id = ? AND deleted = 0");
    $stmt->bind_param("ii", $delta, $question_id);
    $stmt->execute();

    qb_json(['status' => 'success', 'message' => 'Feedback recorded.']);
}

if ($action === 'generate_bank_questions') {
    qb_require_ss360_admin();

    $subject_name = qb_clean_text($_POST['subject_name'] ?? '', 150);
    $topic_name = qb_clean_text($_POST['topic_name'] ?? '', 150);
    $subject_id = (int)($_POST['subject_id'] ?? 0);
    $topic_id = (int)($_POST['topic_id'] ?? 0);
    $difficulty = in_array($_POST['difficulty'] ?? 'Medium', ['Easy', 'Medium', 'Hard', 'Mixed'], true) ? $_POST['difficulty'] : 'Medium';
    $num_questions = min(25, max(1, (int)($_POST['num_questions'] ?? 5)));
    $recommended_class = qb_clean_text($_POST['recommended_class'] ?? '', 100);
    $term_tag = qb_clean_text($_POST['term_tag'] ?? '', 50);
    $question_category = qb_clean_text($_POST['question_category'] ?? '', 100);
    $curriculum_context = qb_clean_text($_POST['curriculum_context'] ?? '', 500);

    if ($subject_id <= 0 || $topic_id <= 0 || $subject_name === '' || $topic_name === '') {
        qb_json(['status' => 'error', 'message' => 'Subject and topic are required for bank generation.']);
    }

    $usage = ss360_ai_usage_can_consume($conn, $userid, $num_questions);
    if (!$usage['allowed']) {
        qb_json([
            'status' => 'error',
            'message' => 'Daily AI limit reached. You have ' . $usage['remaining'] . ' use(s) left today, but this request needs ' . $num_questions . '.',
            'usage' => $usage,
        ]);
    }

    $system_prompt = "You are an expert Nigerian school assessment editor creating teacher-usable multiple-choice questions for a global question bank.
Return only valid JSON with this exact shape:
{
  \"questions\": [
    {
      \"question\": \"Question text\",
      \"difficulty\": \"Easy|Medium|Hard\",
      \"question_category\": \"Short category such as Identification, Computation, Word Problem, Application, Definition, Process, Diagram-Based\",
      \"explanation\": \"Brief explanation of the correct answer\",
      \"options\": [
        {\"text\": \"Option text\", \"is_correct\": true},
        {\"text\": \"Option text\", \"is_correct\": false}
      ]
    }
  ]
}
Rules:
- Create varied questions, not repeated clones.
- Each question must have exactly 4 options.
- Exactly one option must be correct.
- Avoid curriculum-order assumptions; class and term are only optional guidance.
- Do not include markdown outside the JSON.";

    $user_prompt = "Generate $num_questions multiple-choice questions.
Subject: $subject_name
Topic: $topic_name
Difficulty: $difficulty
Recommended class/level: " . ($recommended_class !== '' ? $recommended_class : 'Not specified') . "
Term tag: " . ($term_tag !== '' ? $term_tag : 'Not specified') . "
Question category preference: " . ($question_category !== '' ? $question_category : 'Use varied categories') . "
Curriculum/context: " . ($curriculum_context !== '' ? $curriculum_context : 'Use general Nigerian school curriculum expectations.') . "";

    $ai_result = ss360_ai_chat_json($conn, [
        ['role' => 'system', 'content' => $system_prompt],
        ['role' => 'user', 'content' => $user_prompt],
    ], 0.5, [
        'response_format_json' => true,
        'recover_failed_generation' => false,
    ]);

    if ($ai_result['status'] !== 'success') {
        qb_json([
            'status' => 'error',
            'message' => 'AI could not generate bank questions. Please try again.',
            'debug_message' => $ai_result['message'] ?? 'Unknown AI gateway error.',
        ]);
    }

    $parsed = $ai_result['data'];
    $items = isset($parsed['questions']) && is_array($parsed['questions']) ? $parsed['questions'] : [];
    $inserted = 0;
    $skipped = 0;

    foreach ($items as $item) {
        $item_question = qb_clean_html($item['question'] ?? '');
        $item_difficulty = in_array($item['difficulty'] ?? '', ['Easy', 'Medium', 'Hard'], true) ? $item['difficulty'] : ($difficulty === 'Mixed' ? 'Medium' : $difficulty);
        $item_category = qb_clean_text($item['question_category'] ?? $question_category, 100);
        $item_explanation = qb_clean_html($item['explanation'] ?? '');
        $item_options = [];
        $correct_count = 0;

        foreach (($item['options'] ?? []) as $option) {
            $option_text = qb_clean_html($option['text'] ?? '');
            if ($option_text === '') {
                continue;
            }
            $is_correct = !empty($option['is_correct']) ? 1 : 0;
            $correct_count += $is_correct;
            $item_options[] = ['text' => $option_text, 'is_correct' => $is_correct];
        }

        if ($item_question === '' || count($item_options) !== 4 || $correct_count !== 1 || qb_question_duplicate_exists($conn, 0, $item_question, $subject_id, $topic_id, $item_difficulty)) {
            $skipped++;
            continue;
        }

        $source_type = 'topic';
        $review_status = 'draft';
        $stmt = $conn->prepare("INSERT INTO question_bank
            (question, subject_id, class_id, source_type, exam_body_id, topic_id, difficulty, recommended_class, term_tag,
             question_category, explanation, review_status, school_id, createdby, datecreated)
            VALUES (?, ?, 0, ?, 0, ?, ?, ?, ?, ?, ?, ?, 0, ?, NOW())");
        $stmt->bind_param("sisissssssi", $item_question, $subject_id, $source_type, $topic_id, $item_difficulty, $recommended_class, $term_tag, $item_category, $item_explanation, $review_status, $userid);
        if (!$stmt->execute()) {
            $skipped++;
            continue;
        }
        $question_id = (int)$conn->insert_id;

        $option_stmt = $conn->prepare("INSERT INTO question_bank_options (question_id, options, answer) VALUES (?, ?, ?)");
        foreach ($item_options as $option) {
            $option_stmt->bind_param("isi", $question_id, $option['text'], $option['is_correct']);
            $option_stmt->execute();
        }
        $inserted++;
    }

    if ($inserted > 0) {
        $usage = ss360_ai_usage_record_success($conn, $userid, $inserted);
    }

    qb_json([
        'status' => 'success',
        'message' => "Generated $inserted draft question(s). Skipped $skipped incomplete or duplicate item(s).",
        'inserted' => $inserted,
        'skipped' => $skipped,
        'usage' => $usage,
    ]);
}

if ($action === 'restructure_questions') {
    $raw_questions = trim((string)($_POST['raw_questions'] ?? ''));
    $subject = trim((string)($_POST['subject_name'] ?? ''));
    $difficulty = trim((string)($_POST['difficulty'] ?? 'Medium'));

    if ($raw_questions === '') {
        qb_json(['status' => 'error', 'message' => 'Paste the questions you want AI to restructure.']);
    }

    $raw_plain_text = trim(strip_tags($raw_questions));
    if ($raw_plain_text === '' && strpos($raw_questions, 'math-editor-rendered') === false && strpos($raw_questions, '<img') === false) {
        qb_json(['status' => 'error', 'message' => 'Paste the questions you want AI to restructure.']);
    }

    $usage = ss360_ai_usage_can_consume($conn, $userid, 1);
    if (!$usage['allowed']) {
        qb_json([
            'status' => 'error',
            'message' => 'Daily AI limit reached. You have ' . $usage['remaining'] . ' use(s) left today.',
            'usage' => $usage,
        ]);
    }

    $system_prompt = "You are an expert teacher and assessment editor. Convert pasted questions into clean multiple-choice questions for a school question bank.
Return only valid JSON with this exact shape:
{
  \"questions\": [
    {
      \"question\": \"Clean question text\",
      \"difficulty\": \"Easy|Medium|Hard\",
      \"options\": [
        {\"text\": \"Option text\", \"is_correct\": true},
        {\"text\": \"Option text\", \"is_correct\": false}
      ]
    }
  ]
}
Rules:
- Keep the academic meaning intact.
- Use clear student-friendly wording.
- Preserve meaningful HTML formatting from the source, including bold, italic, underline, superscript, subscript, lists, tables, highlighted spans, and MathQuill spans.
- Each question must have 2 to 5 options.
- Exactly one option must be correct.
- If the answer is not supplied, infer the best answer only when it is obvious; otherwise omit that question.
- Do not include explanations or markdown.";

    $user_prompt = "Subject: " . ($subject !== '' ? $subject : 'Not specified') . "\nDifficulty preference: $difficulty\n\nPasted questions:\n$raw_questions";

    $ai_result = ss360_ai_chat_json($conn, [
        ['role' => 'system', 'content' => $system_prompt],
        ['role' => 'user', 'content' => $user_prompt],
    ], 0.3, [
        'response_format_json' => true,
        'recover_failed_generation' => false,
    ]);

    if ($ai_result['status'] !== 'success') {
        qb_json([
            'status' => 'error',
            'message' => 'AI could not restructure the questions. Please try again.',
            'debug_message' => $ai_result['message'] ?? 'Unknown AI gateway error.',
        ]);
    }

    $parsed = $ai_result['data'];
    $questions = isset($parsed['questions']) && is_array($parsed['questions']) ? $parsed['questions'] : [];
    $clean_questions = [];

    foreach ($questions as $item) {
        $item_question = qb_clean_html($item['question'] ?? '');
        $item_options = [];
        $item_correct_count = 0;

        foreach (($item['options'] ?? []) as $option) {
            $option_text = qb_clean_html($option['text'] ?? '');
            if ($option_text === '') {
                continue;
            }

            $is_correct = !empty($option['is_correct']);
            $item_correct_count += $is_correct ? 1 : 0;
            $item_options[] = ['text' => $option_text, 'is_correct' => $is_correct];
        }

        if ($item_question !== '' && count($item_options) >= 2 && $item_correct_count === 1) {
            $clean_questions[] = [
                'question' => $item_question,
                'difficulty' => in_array($item['difficulty'] ?? '', ['Easy', 'Medium', 'Hard'], true) ? $item['difficulty'] : $difficulty,
                'options' => $item_options,
            ];
        }
    }

    if (empty($clean_questions)) {
        qb_json(['status' => 'error', 'message' => 'AI did not return any complete questions. Add answers/options and try again.']);
    }

    $new_usage = ss360_ai_usage_record_success($conn, $userid, 1);
    qb_json([
        'status' => 'success',
        'data' => $clean_questions,
        'usage' => $new_usage,
    ]);
}

qb_json(['status' => 'error', 'message' => 'Invalid action.']);
