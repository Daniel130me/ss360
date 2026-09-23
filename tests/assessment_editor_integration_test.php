<?php

$_SESSION = ['env' => 'dev', 'school_id' => 13, 'userid' => 57, 'staff_type' => 4];
require_once __DIR__ . '/../model/connect.php';
require_once __DIR__ . '/../model/assessment_editor.php';

// Match production hosts that enforce strict aggregate queries.
$conn->query("SET SESSION sql_mode = CONCAT_WS(',', @@SESSION.sql_mode, 'ONLY_FULL_GROUP_BY')");

function assessment_test_assert(bool $condition, string $message): void
{
    if (!$condition) {
        throw new RuntimeException($message);
    }
}

function assessment_test_question(string $text, ?int $id = null, array $optionIds = []): array
{
    $options = [];
    foreach (['Correct', 'Wrong B', 'Wrong C', 'Wrong D'] as $index => $option) {
        $options[] = [
            'id' => $optionIds[$index] ?? null,
            'text' => "<p>{$option}</p>",
            'isAnswer' => $index === 0,
        ];
    }

    return ['id' => $id, 'question' => "<p>{$text}</p>", 'options' => $options];
}

$token = bin2hex(random_bytes(16));
$assessmentId = 0;

try {
    $subject = $conn->query('SELECT id AS subject_id FROM subjects LIMIT 1')->fetch_assoc();
    $class = $conn->query('SELECT id FROM class WHERE school_id = 13 LIMIT 1')->fetch_assoc();
    assessment_test_assert((bool)$subject && (bool)$class, 'Test school needs at least one subject and class.');

    $settings = [
        'assessment_id' => null,
        'assessment_type' => 1,
        'term' => 1,
        'subject_id' => (int)$subject['subject_id'],
        'class_ids' => (string)$class['id'],
        'instruction' => 'Automated assessment editor test',
        'duration' => 20,
        'deadline_date' => '',
        'deadline_time' => '',
        'desired_score' => 10,
        'round_off_decimal' => 1,
        'ca_type' => 6,
        'save_token' => $token,
    ];

    $initialQuestions = [
        assessment_test_question('Regression question one'),
        assessment_test_question('Regression question two'),
    ];
    $created = assessment_editor_save($conn, $settings, $initialQuestions, true);
    $assessmentId = (int)$created['assessment_id'];
    assessment_test_assert($assessmentId > 0, 'Create did not return an assessment ID.');
    assessment_test_assert(count($created['mapping']) === 2, 'Create mapping is incomplete.');

    // Simulate a lost HTTP response: the browser retries with the same token and no saved IDs.
    $replayed = assessment_editor_save($conn, $settings, $initialQuestions, true);
    assessment_test_assert((int)$replayed['assessment_id'] === $assessmentId, 'Retry created a duplicate assessment.');
    $count = (int)$conn->query("SELECT COUNT(*) AS count FROM questions WHERE ass_id = {$assessmentId}")->fetch_assoc()['count'];
    assessment_test_assert($count === 2, 'Retry duplicated questions.');

    // A retry may contain the user's latest settings and must update the same assessment.
    $settings['instruction'] = 'Automated assessment editor test replayed';
    $replayed = assessment_editor_save($conn, $settings, $initialQuestions, true);
    $savedInstruction = $conn->query(
        "SELECT instruction FROM assessment WHERE id = {$assessmentId}"
    )->fetch_assoc()['instruction'];
    assessment_test_assert($savedInstruction === $settings['instruction'], 'Retry did not preserve updated settings.');

    $mapping = $replayed['mapping'];
    $settings['assessment_id'] = $assessmentId;
    $changedQuestions = [
        assessment_test_question('Regression question one edited', (int)$mapping[0]['question_id'], $mapping[0]['options']),
        assessment_test_question('Regression question three newly added'),
    ];
    $changed = assessment_editor_save($conn, $settings, $changedQuestions, true);
    assessment_test_assert(count($changed['mapping']) === 2, 'Update mapping is incomplete.');
    $count = (int)$conn->query("SELECT COUNT(*) AS count FROM questions WHERE ass_id = {$assessmentId}")->fetch_assoc()['count'];
    assessment_test_assert($count === 2, 'Full save did not remove the omitted question.');

    // Simulate single_assessment.php page save, including a newly added question and repeated save.
    $pageQuestion = assessment_test_question('Regression paginated question');
    $pageMapping = assessment_editor_save_question_page($conn, $assessmentId, [$pageQuestion]);
    $pageQuestion['id'] = (int)$pageMapping[0]['question_id'];
    foreach ($pageQuestion['options'] as $index => &$option) {
        $option['id'] = (int)$pageMapping[0]['options'][$index];
    }
    unset($option);
    assessment_editor_save_question_page($conn, $assessmentId, [$pageQuestion]);
    $copies = (int)$conn->query(
        "SELECT COUNT(*) AS count FROM questions
         WHERE ass_id = {$assessmentId} AND question = '<p>Regression paginated question</p>'"
    )->fetch_assoc()['count'];
    assessment_test_assert($copies === 1, 'Repeated paginated save duplicated a question.');

    assessment_editor_delete_question($conn, $assessmentId, (int)$pageQuestion['id']);
    $deleted = (int)$conn->query(
        "SELECT COUNT(*) AS count FROM questions WHERE id = " . (int)$pageQuestion['id']
    )->fetch_assoc()['count'];
    assessment_test_assert($deleted === 0, 'Delete left the question in the database.');

    // An invalid payload must roll back without modifying the assessment.
    $before = (int)$conn->query("SELECT COUNT(*) AS count FROM questions WHERE ass_id = {$assessmentId}")->fetch_assoc()['count'];
    $invalid = assessment_test_question('Invalid question');
    $invalid['options'][1]['isAnswer'] = true;
    try {
        assessment_editor_save_question_page($conn, $assessmentId, [$invalid]);
        throw new RuntimeException('Invalid correct-answer count was accepted.');
    } catch (InvalidArgumentException $expected) {
        // Expected validation failure.
    }
    $after = (int)$conn->query("SELECT COUNT(*) AS count FROM questions WHERE ass_id = {$assessmentId}")->fetch_assoc()['count'];
    assessment_test_assert($before === $after, 'Invalid save was not rolled back.');

    // IDs may only be used once and only under their owning question.
    $firstMapping = $changed['mapping'][0];
    $secondMapping = $changed['mapping'][1];
    $tamperedQuestion = assessment_test_question(
        'Tampered option ownership',
        (int)$firstMapping['question_id'],
        $firstMapping['options']
    );
    $tamperedQuestion['options'][0]['id'] = (int)$secondMapping['options'][0];
    try {
        assessment_editor_save_question_page($conn, $assessmentId, [$tamperedQuestion]);
        throw new RuntimeException('Cross-question option ID was accepted.');
    } catch (InvalidArgumentException $expected) {
        // Expected ownership validation failure.
    }

    $duplicateQuestion = assessment_test_question(
        'Duplicated ID',
        (int)$firstMapping['question_id'],
        $firstMapping['options']
    );
    try {
        assessment_editor_save_question_page($conn, $assessmentId, [$duplicateQuestion, $duplicateQuestion]);
        throw new RuntimeException('Duplicate question ID was accepted.');
    } catch (InvalidArgumentException $expected) {
        // Expected duplicate-ID validation failure.
    }

    $invalidClassSettings = $settings;
    $invalidClassSettings['assessment_id'] = $assessmentId;
    $invalidClassSettings['class_ids'] = '999999999';
    try {
        assessment_editor_save($conn, $invalidClassSettings, [$changedQuestions[0]], false);
        throw new RuntimeException('A class from outside the school was accepted.');
    } catch (InvalidArgumentException $expected) {
        // Expected school ownership validation failure.
    }

    // Cross-school IDs must never be editable.
    $_SESSION['school_id'] = 1;
    try {
        assessment_editor_save_question_page($conn, $assessmentId, [$changedQuestions[0]]);
        throw new RuntimeException('Cross-school assessment access was accepted.');
    } catch (RuntimeException $expected) {
        assessment_test_assert($expected->getMessage() === 'Assessment not found.', 'Unexpected cross-school error.');
    }

    // The persisted-delete endpoint must not leave an assessment with zero questions.
    $_SESSION['school_id'] = 13;
    $remainingQuestionIds = array_map(
        'intval',
        array_column(
            $conn->query("SELECT id FROM questions WHERE ass_id = {$assessmentId} ORDER BY id")->fetch_all(MYSQLI_ASSOC),
            'id'
        )
    );
    assessment_test_assert(count($remainingQuestionIds) === 2, 'Unexpected question count before final-delete test.');
    assessment_editor_delete_question($conn, $assessmentId, $remainingQuestionIds[1]);
    try {
        assessment_editor_delete_question($conn, $assessmentId, $remainingQuestionIds[0]);
        throw new RuntimeException('The final assessment question was deleted.');
    } catch (InvalidArgumentException $expected) {
        // Expected final-question protection.
    }

    echo "PASS: assessment editor create/retry/update/remove/pagination/rollback/security tests\n";
} finally {
    $_SESSION['school_id'] = 13;
    if ($assessmentId > 0) {
        $conn->query(
            "DELETE o FROM options o INNER JOIN questions q ON q.id = o.question_id
             WHERE q.ass_id = {$assessmentId}"
        );
        $conn->query("DELETE FROM questions WHERE ass_id = {$assessmentId}");
        $conn->query("DELETE FROM assessment WHERE id = {$assessmentId}");
    } else {
        $stmt = $conn->prepare('DELETE FROM assessment WHERE school_id = 13 AND save_token = ?');
        $stmt->bind_param('s', $token);
        $stmt->execute();
        $stmt->close();
    }
}
