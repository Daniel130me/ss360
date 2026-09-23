<?php

require_once __DIR__ . '/../model/assessment_delivery.php';

function assert_delivery_test(bool $condition, string $message): void
{
    if (!$condition) {
        throw new RuntimeException($message);
    }
}

$questionIds = range(101, 140);
$firstAttempt = [
    'assessment_id' => 12,
    'student_id' => 34,
    'attempt_id' => 56,
];
$secondAttempt = [
    'assessment_id' => 12,
    'student_id' => 34,
    'attempt_id' => 57,
];
$anotherStudent = [
    'assessment_id' => 12,
    'student_id' => 35,
    'attempt_id' => 58,
];

$firstOrder = assessment_delivery_shuffle_question_ids($questionIds, $firstAttempt);
$reloadedOrder = assessment_delivery_shuffle_question_ids($questionIds, $firstAttempt);
$resetOrder = assessment_delivery_shuffle_question_ids($questionIds, $secondAttempt);
$otherStudentOrder = assessment_delivery_shuffle_question_ids($questionIds, $anotherStudent);

assert_delivery_test($firstOrder === $reloadedOrder, 'An attempt changed order after reload.');
assert_delivery_test($firstOrder !== $resetOrder, 'A reset attempt reused the former order.');
assert_delivery_test($firstOrder !== $otherStudentOrder, 'Different students received the same order.');

$sortedInput = $questionIds;
$sortedOutput = $firstOrder;
sort($sortedInput);
sort($sortedOutput);
assert_delivery_test($sortedInput === $sortedOutput, 'The shuffle lost or duplicated a question.');

echo "Assessment delivery shuffle tests passed.\n";
