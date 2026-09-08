<?php
require_once __DIR__ . '/../model/functions.php';

function assert_same($expected, $actual, $message)
{
    if ($expected !== $actual) {
        fwrite(STDERR, "$message
Expected: " . var_export($expected, true) . "
Actual: " . var_export($actual, true) . "
");
        exit(1);
    }
}

$rows = [
    ['subject_id' => 10, 'student_id' => 1, 'term_id' => 1, 'total' => 80],
    ['subject_id' => 10, 'student_id' => 1, 'term_id' => 2, 'total' => 70],
    ['subject_id' => 10, 'student_id' => 1, 'term_id' => 3, 'total' => 90],
    ['subject_id' => 10, 'student_id' => 2, 'term_id' => 1, 'total' => 60],
    ['subject_id' => 10, 'student_id' => 3, 'term_id' => 1, 'total' => 0],
    ['subject_id' => 10, 'student_id' => 3, 'term_id' => 2, 'total' => 100],
    ['subject_id' => 20, 'student_id' => 1, 'term_id' => 2, 'total' => 50],
    ['subject_id' => 20, 'student_id' => 4, 'term_id' => 2, 'total' => 70],
];

$comparison = build_report_score_comparison_data($rows, 1);

assert_same('70', $comparison['term']['1']['10']['class_average'], 'Term class average changed unexpectedly.');
assert_same('78', $comparison['cumulative']['2']['10']['class_average'], 'Second-term cumulative average must use each student\'s available terms.');
assert_same('80', $comparison['cumulative']['3']['10']['class_average'], 'Third-term cumulative average must exclude missing and zero-total terms.');
assert_same('2', $comparison['cumulative']['3']['10']['position'], 'Cumulative position must use the same per-student average.');
assert_same('60', $comparison['cumulative']['3']['20']['class_average'], 'A subject offered in one term must use only that term.');
assert_same('2', $comparison['cumulative']['3']['20']['position'], 'One-term subject position is incorrect.');

echo "Report score comparison tests passed.
";