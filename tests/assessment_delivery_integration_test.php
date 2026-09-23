<?php

$_SESSION['env'] = 'local';

require_once __DIR__ . '/../model/connect.php';
require_once __DIR__ . '/../model/assessment_delivery.php';

function assert_delivery_integration(bool $condition, string $message): void
{
    if (!$condition) {
        throw new RuntimeException($message);
    }
}

$candidateSql =
    "SELECT a.id AS assessment_id, a.school_id, s.id AS student_id
     FROM assessment a
     INNER JOIN students s
        ON s.school_id = a.school_id
       AND s.status = 1
       AND FIND_IN_SET(s.class_id, a.class_ids)
     WHERE (a.blacklist_students IS NULL
            OR a.blacklist_students = ''
            OR NOT FIND_IN_SET(s.id, a.blacklist_students))
       AND (SELECT COUNT(*)
            FROM questions q
            WHERE q.ass_id = a.id AND q.deleted = 0) >= 5
     LIMIT 1";
$candidate = $conn->query($candidateSql)->fetch_assoc();

if (!$candidate) {
    fwrite(STDERR, "Skipped: no suitable local assessment and student pair was found.\n");
    exit(0);
}

$conn->begin_transaction();

try {
    $assessmentId = (int)$candidate['assessment_id'];
    $studentId = (int)$candidate['student_id'];
    $_SESSION['userid'] = $studentId;
    $_SESSION['school_id'] = (int)$candidate['school_id'];
    $_SESSION['user_type'] = 'student';

    $attemptStmt = $conn->prepare(
        "INSERT INTO assessment_attempts
            (assessment_id, student_id, start_time, time_remaining, status)
         VALUES (?, ?, NOW(), 1800, 'in_progress')"
    );
    $attemptStmt->bind_param('ii', $assessmentId, $studentId);
    $attemptStmt->execute();

    $context = assessment_delivery_require_student($conn, $assessmentId);
    $firstOrder = assessment_delivery_question_ids($conn, $context);
    $reloadedOrder = assessment_delivery_question_ids($conn, $context);

    assert_delivery_integration(count($firstOrder) >= 5, 'The question list was incomplete.');
    assert_delivery_integration($firstOrder === $reloadedOrder, 'Reloading changed the question order.');

    $question = assessment_delivery_find_question($conn, $context, $firstOrder[0]);
    assert_delivery_integration($question !== null, 'The first shuffled question could not be loaded.');
    assert_delivery_integration($question['id'] === $firstOrder[0], 'A different question was returned.');
    foreach ($question['options'] as $option) {
        assert_delivery_integration(
            !array_key_exists('isAnswer', $option) && !array_key_exists('answer', $option),
            'The correct-answer marker was exposed to the student.'
        );
    }

    $deleteAttempt = $conn->prepare('DELETE FROM assessment_attempts WHERE id = ?');
    $deleteAttempt->bind_param('i', $context['attempt_id']);
    $deleteAttempt->execute();
    $attemptStmt->execute();
    $resetContext = assessment_delivery_require_student($conn, $assessmentId);
    $resetOrder = assessment_delivery_question_ids($conn, $resetContext);
    assert_delivery_integration($firstOrder !== $resetOrder, 'A reset did not create a new order.');

    $_SESSION['user_type'] = 'staff';
    try {
        assessment_delivery_require_student($conn, $assessmentId);
        throw new RuntimeException('A staff session was allowed to use a student delivery endpoint.');
    } catch (RuntimeException $error) {
        assert_delivery_integration($error->getCode() === 403, 'Unauthorized access returned the wrong error.');
    }

    $conn->rollback();
    echo "Assessment delivery database integration tests passed.\n";
} catch (Throwable $error) {
    $conn->rollback();
    throw $error;
}
