<?php
session_start();

header('Content-Type: application/json; charset=utf-8');

if (!isset($_SESSION['userid']) || ($_SESSION['user_type'] ?? '') !== 'student') {
    echo json_encode(['status' => 'error', 'message' => 'Please log in as a student to view progress.']);
    exit;
}

include_once("model/connect.php");

mysqli_set_charset($conn, 'utf8mb4');

const LEARNING_PROGRESS_WEEK = 'week';
const LEARNING_PROGRESS_ALL_TIME = 'all';
const LEARNING_PROGRESS_TOPIC_LIMIT = 8;

function progress_json($payload)
{
    echo json_encode($payload);
    exit;
}

function progress_bind_params($stmt, $types, $params)
{
    if ($types === '') {
        return;
    }

    $refs = [$types];
    foreach ($params as $key => $value) {
        $refs[] = &$params[$key];
    }
    call_user_func_array([$stmt, 'bind_param'], $refs);
}

function progress_fetch_all($conn, $sql, $types = '', $params = [])
{
    $stmt = $conn->prepare($sql);
    if (!$stmt) {
        progress_json(['status' => 'error', 'message' => 'Unable to prepare progress request.']);
    }

    progress_bind_params($stmt, $types, $params);
    if (!$stmt->execute()) {
        progress_json(['status' => 'error', 'message' => 'Unable to load progress right now.']);
    }

    $result = $stmt->get_result();
    $rows = [];
    while ($result && $row = $result->fetch_assoc()) {
        $rows[] = $row;
    }
    $stmt->close();
    return $rows;
}

function progress_fetch_one($conn, $sql, $types = '', $params = [])
{
    $rows = progress_fetch_all($conn, $sql, $types, $params);
    return $rows[0] ?? [];
}

function progress_range_filter($range)
{
    if ($range === LEARNING_PROGRESS_ALL_TIME) {
        return ['', '', []];
    }

    return [' AND s.completed_at >= DATE_SUB(NOW(), INTERVAL 7 DAY)', '', []];
}

function progress_read_summary($conn, $student_id, $school_id, $range)
{
    [$range_sql, $range_types, $range_params] = progress_range_filter($range);
    $params = array_merge([$student_id, $school_id], $range_params);

    $summary = progress_fetch_one(
        $conn,
        "SELECT
            COUNT(*) AS completed_sessions,
            COALESCE(SUM(s.total_questions), 0) AS questions_attempted,
            COALESCE(SUM(s.score), 0) AS correct_answers,
            COALESCE(SUM(
                CASE
                    WHEN s.started_at IS NOT NULL AND s.completed_at IS NOT NULL AND s.completed_at >= s.started_at
                    THEN TIMESTAMPDIFF(SECOND, s.started_at, s.completed_at)
                    ELSE 0
                END
            ), 0) AS time_spent_seconds
        FROM student_practice_sessions s
        WHERE s.student_id = ? AND s.school_id = ? AND s.status = 'completed' $range_sql",
        "ii" . $range_types,
        $params
    );

    $attempted = (int)($summary['questions_attempted'] ?? 0);
    $correct = (int)($summary['correct_answers'] ?? 0);
    $summary['average_score'] = $attempted > 0 ? round(($correct / $attempted) * 100, 1) : 0;

    return [
        'completed_sessions' => (int)($summary['completed_sessions'] ?? 0),
        'questions_attempted' => $attempted,
        'correct_answers' => $correct,
        'average_score' => $summary['average_score'],
        'time_spent_seconds' => (int)($summary['time_spent_seconds'] ?? 0),
    ];
}

function progress_read_subjects($conn, $student_id, $school_id, $range)
{
    [$range_sql, $range_types, $range_params] = progress_range_filter($range);
    $params = array_merge([$student_id, $school_id], $range_params);

    return progress_fetch_all(
        $conn,
        "SELECT
            q.subject_id,
            COALESCE(sub.subject, 'Unknown Subject') AS subject,
            COUNT(a.id) AS answered_questions,
            COALESCE(SUM(CASE WHEN a.is_correct = 1 THEN 1 ELSE 0 END), 0) AS correct_answers,
            ROUND((COALESCE(SUM(CASE WHEN a.is_correct = 1 THEN 1 ELSE 0 END), 0) / COUNT(a.id)) * 100, 1) AS mastery_percent
        FROM student_practice_answers a
        INNER JOIN student_practice_sessions s ON s.id = a.session_id
        INNER JOIN question_bank q ON q.id = a.question_id
        LEFT JOIN subjects sub ON sub.id = q.subject_id
        WHERE s.student_id = ? AND s.school_id = ? AND s.status = 'completed' $range_sql
        GROUP BY q.subject_id, sub.subject
        HAVING answered_questions > 0
        ORDER BY mastery_percent DESC, answered_questions DESC, subject ASC",
        "ii" . $range_types,
        $params
    );
}

function progress_read_topics($conn, $student_id, $school_id, $range)
{
    [$range_sql, $range_types, $range_params] = progress_range_filter($range);
    $params = array_merge([$student_id, $school_id, LEARNING_PROGRESS_TOPIC_LIMIT], $range_params);

    return progress_fetch_all(
        $conn,
        "SELECT
            q.topic_id,
            COALESCE(t.topic_name, 'General Practice') AS topic_name,
            COALESCE(sub.subject, 'Unknown Subject') AS subject,
            COUNT(a.id) AS answered_questions,
            COALESCE(SUM(CASE WHEN a.is_correct = 1 THEN 1 ELSE 0 END), 0) AS correct_answers,
            ROUND((COALESCE(SUM(CASE WHEN a.is_correct = 1 THEN 1 ELSE 0 END), 0) / COUNT(a.id)) * 100, 1) AS mastery_percent
        FROM student_practice_answers a
        INNER JOIN student_practice_sessions s ON s.id = a.session_id
        INNER JOIN question_bank q ON q.id = a.question_id
        LEFT JOIN topics t ON t.id = q.topic_id
        LEFT JOIN subjects sub ON sub.id = q.subject_id
        WHERE s.student_id = ? AND s.school_id = ? AND s.status = 'completed' $range_sql
        GROUP BY q.topic_id, t.topic_name, sub.subject
        HAVING answered_questions > 0
        ORDER BY mastery_percent ASC, answered_questions DESC, topic_name ASC
        LIMIT ?",
        "iii" . $range_types,
        $params
    );
}

function progress_read_weekly_change($conn, $student_id, $school_id)
{
    $rows = progress_fetch_all(
        $conn,
        "SELECT
            CASE
                WHEN completed_at >= DATE_SUB(NOW(), INTERVAL 7 DAY) THEN 'current'
                WHEN completed_at >= DATE_SUB(NOW(), INTERVAL 14 DAY) AND completed_at < DATE_SUB(NOW(), INTERVAL 7 DAY) THEN 'previous'
            END AS period_name,
            COALESCE(SUM(score), 0) AS correct_answers,
            COALESCE(SUM(total_questions), 0) AS questions_attempted
        FROM student_practice_sessions
        WHERE student_id = ? AND school_id = ? AND status = 'completed'
            AND completed_at >= DATE_SUB(NOW(), INTERVAL 14 DAY)
        GROUP BY period_name
        HAVING period_name IS NOT NULL",
        "ii",
        [$student_id, $school_id]
    );

    $scores = [
        'current' => null,
        'previous' => null,
    ];
    foreach ($rows as $row) {
        $attempted = (int)$row['questions_attempted'];
        $scores[$row['period_name']] = $attempted > 0 ? round(((int)$row['correct_answers'] / $attempted) * 100, 1) : null;
    }

    return [
        'current_week_average' => $scores['current'],
        'previous_week_average' => $scores['previous'],
        'change' => $scores['current'] !== null && $scores['previous'] !== null
            ? round($scores['current'] - $scores['previous'], 1)
            : null,
    ];
}

$student_id = (int)$_SESSION['userid'];
$school_id = (int)($_SESSION['school_id'] ?? 0);
$action = $_POST['action'] ?? 'get_dashboard';
$range = $_POST['range'] ?? LEARNING_PROGRESS_WEEK;
$range = $range === LEARNING_PROGRESS_ALL_TIME ? LEARNING_PROGRESS_ALL_TIME : LEARNING_PROGRESS_WEEK;

if ($action === 'get_dashboard') {
    $summary = progress_read_summary($conn, $student_id, $school_id, $range);
    $subjects = progress_read_subjects($conn, $student_id, $school_id, $range);
    $topics = progress_read_topics($conn, $student_id, $school_id, $range);

    $best_subject = $subjects[0] ?? null;
    $weakest_subject = null;
    if (!empty($subjects)) {
        $weakest_subjects = $subjects;
        usort($weakest_subjects, function ($left, $right) {
            $score_compare = ((float)$left['mastery_percent']) <=> ((float)$right['mastery_percent']);
            if ($score_compare !== 0) {
                return $score_compare;
            }
            return ((int)$right['answered_questions']) <=> ((int)$left['answered_questions']);
        });
        $weakest_subject = $weakest_subjects[0];
    }

    progress_json([
        'status' => 'success',
        'data' => [
            'range' => $range,
            'summary' => $summary,
            'best_subject' => $best_subject,
            'weakest_subject' => $weakest_subject,
            'topics' => $topics,
            'weekly_change' => progress_read_weekly_change($conn, $student_id, $school_id),
        ],
    ]);
}

progress_json(['status' => 'error', 'message' => 'Unknown progress action.']);
