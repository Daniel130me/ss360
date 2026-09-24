<?php

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$database = getenv('SS360_TEST_DB') ?: 'ss360';
$conn = new mysqli(
    getenv('SS360_DB_HOST') ?: '127.0.0.1',
    getenv('SS360_DB_USER') ?: 'root',
    getenv('SS360_DB_PASSWORD') ?: '',
    $database,
    (int)(getenv('SS360_DB_PORT') ?: 3306)
);
$conn->set_charset('utf8mb4');

require_once __DIR__ . '/../model/functions.php';
require_once __DIR__ . '/../model/report_card_renderer.php';

function assert_history_test(bool $condition, string $message): void
{
    if (!$condition) {
        throw new RuntimeException($message);
    }
}

if (!student_class_history_available($conn)) {
    fwrite(STDOUT, "Skipped: student class history migration is not installed in {$database}.\n");
    exit(0);
}

$candidate = $conn->query(
    "SELECT e.school_id, e.student_id, e.session_id, e.term_id, e.class_id,
            s.class_id AS current_class_id
     FROM student_class_enrollments e
     INNER JOIN students s ON s.id = e.student_id AND s.school_id = e.school_id
     WHERE e.class_id <> s.class_id
       AND EXISTS (
          SELECT 1 FROM skulscores sc
          WHERE sc.school_id = e.school_id AND sc.student_id = e.student_id
            AND sc.session_id = e.session_id AND sc.term_id = e.term_id
            AND sc.class_id <> e.class_id AND sc.total > 0
       )
     LIMIT 1"
)->fetch_assoc();

if (!$candidate) {
    fwrite(STDOUT, "Skipped: no recovered historical-class candidate exists in {$database}.\n");
    exit(0);
}

$schoolId = (int)$candidate['school_id'];
$studentId = (int)$candidate['student_id'];
$sessionId = (int)$candidate['session_id'];
$termId = (int)$candidate['term_id'];
$historicalClassId = (int)$candidate['class_id'];
$currentClassId = (int)$candidate['current_class_id'];

$_SESSION['school_id'] = $schoolId;
$resolvedClassId = resolve_student_report_class_id(
    $studentId,
    $sessionId,
    (string)$termId,
    $currentClassId,
    $schoolId
);
assert_history_test(
    $resolvedClassId === $historicalClassId,
    'The report resolver returned the current class instead of recovered history.'
);

$latestEnrollmentStmt = $conn->prepare(
    'SELECT class_id
     FROM student_class_enrollments
     WHERE school_id = ? AND student_id = ? AND session_id = ?
     ORDER BY term_id DESC
     LIMIT 1'
);
$latestEnrollmentStmt->bind_param('iii', $schoolId, $studentId, $sessionId);
$latestEnrollmentStmt->execute();
$latestEnrollment = $latestEnrollmentStmt->get_result()->fetch_assoc();
$latestEnrollmentStmt->close();
assert_history_test(
    resolve_student_report_class_id($studentId, $sessionId, 'cum', $currentClassId, $schoolId)
        === (int)$latestEnrollment['class_id'],
    'The cumulative report did not use the latest recovered academic class.'
);

$roster = fetch_students_for_class_period(
    $conn,
    $schoolId,
    $historicalClassId,
    $sessionId,
    $termId
);
$rosterIds = array_map(static fn(array $student): int => (int)$student['id'], $roster);
assert_history_test(
    in_array($studentId, $rosterIds, true),
    'The recovered student is missing from the historical class roster.'
);
assert_history_test(
    count_students_for_class_period($conn, $schoolId, $historicalClassId, $sessionId, $termId) === count($roster),
    'The report-card class count does not match the historical roster.'
);

$scoreRows = get_report_card_score_rows_for_table(
    $studentId,
    $historicalClassId,
    $sessionId,
    $termId,
    $schoolId
);
assert_history_test(
    count($scoreRows) > 0,
    'Valid score rows were hidden because their legacy class_id differs from recovered history.'
);

// Verify that enrolment writes participate in the caller's transaction.
$conn->begin_transaction();
try {
    set_student_enrollment_from_term(
        $conn,
        $schoolId,
        $studentId,
        $sessionId,
        $termId,
        $historicalClassId,
        0,
        'manual'
    );
    $conn->rollback();
} catch (Throwable $error) {
    $conn->rollback();
    throw $error;
}

$graduateCandidate = $conn->query(
    "SELECT c.school_id, c.id AS class_id, sc.session_id, sc.term_id
     FROM class c
     INNER JOIN students s ON s.school_id = c.school_id AND s.class_id = c.id
     INNER JOIN skulscores sc ON sc.school_id = s.school_id AND sc.student_id = s.id
     WHERE c.is_graduate = 1
       AND (COALESCE(sc.ca1Total, 0) + COALESCE(sc.ca2Total, 0)
            + COALESCE(sc.ca3Total, 0) + COALESCE(sc.praTotal, 0) + COALESCE(sc.examTotal, 0)) > 0
     GROUP BY c.school_id, c.id, sc.session_id, sc.term_id
     LIMIT 1"
)->fetch_assoc();

if ($graduateCandidate) {
    $graduateSchoolId = (int)$graduateCandidate['school_id'];
    $graduateClassId = (int)$graduateCandidate['class_id'];
    $graduateSessionId = (int)$graduateCandidate['session_id'];
    $graduateTermId = (int)$graduateCandidate['term_id'];
    $graduateRoster = fetch_students_for_class_period(
        $conn,
        $graduateSchoolId,
        $graduateClassId,
        $graduateSessionId,
        $graduateTermId
    );
    $graduateScores = fetch_score_rows_for_class_period(
        $conn,
        $graduateSchoolId,
        $graduateClassId,
        $graduateSessionId,
        $graduateTermId
    );
    assert_history_test(count($graduateRoster) > 0, 'The graduate cohort roster is empty.');
    assert_history_test(count($graduateScores) > 0, 'The graduate cohort scores were not resolved from its former class.');
    $graduateRosterIds = array_fill_keys(
        array_map(static fn(array $student): int => (int)$student['id'], $graduateRoster),
        true
    );
    foreach ($graduateScores as $graduateScore) {
        assert_history_test(
            isset($graduateRosterIds[(int)$graduateScore['student_id']]),
            'A score outside the selected graduate cohort was returned.'
        );
    }
}

fwrite(STDOUT, "Student class history integration tests passed.\n");
