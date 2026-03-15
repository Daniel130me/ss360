<?php
include_once("model/connect.php");

// Clear existing dummy data if needed (optional, but good for clean test)
// mysqli_query($conn, "TRUNCATE TABLE exam_bodies");
// mysqli_query($conn, "TRUNCATE TABLE topics");
// mysqli_query($conn, "TRUNCATE TABLE question_bank");
// mysqli_query($conn, "TRUNCATE TABLE question_bank_options");

// Ensure Exam Bodies exist
$bodies = [
    ['id' => 1, 'name' => 'WAEC', 'desc' => 'West African Examinations Council'],
    ['id' => 2, 'name' => 'JAMB', 'desc' => 'Joint Admissions and Matriculation Board']
];

foreach ($bodies as $b) {
    mysqli_query($conn, "INSERT IGNORE INTO exam_bodies (id, name, description) VALUES ({$b['id']}, '{$b['name']}', '{$b['desc']}')");
}

// Topics for Mathematics (Subject 1) 
// Classes: 64 (JSS1), 65 (SS3)
$topics = [
    ['sub' => 1, 'class' => 64, 'name' => 'Number Systems'],
    ['sub' => 1, 'class' => 64, 'name' => 'Fractions and Decimals'],
    ['sub' => 1, 'class' => 65, 'name' => 'Probability'],
    ['sub' => 1, 'class' => 65, 'name' => 'Calculus'],
    ['sub' => 1, 'class' => 65, 'name' => 'Statistics']
];

$topic_ids = [];
foreach ($topics as $t) {
    mysqli_query($conn, "INSERT INTO topics (subject_id, class_id, topic_name) VALUES ({$t['sub']}, {$t['class']}, '{$t['name']}')");
    $topic_ids[] = mysqli_insert_id($conn);
}

// Questions
$questions = [
    [
        'sub' => 1, 'class' => 65, 'type' => 'exam_body', 'eb' => 1, 'topic' => 'NULL', 
        'q' => 'Solve for x: 3x^2 - 5x + 2 = 0',
        'opts' => [
            ['text' => 'x=1, 2/3', 'ans' => 1],
            ['text' => 'x=2, 3', 'ans' => 0],
            ['text' => 'x=0, 1', 'ans' => 0],
            ['text' => 'x=1, -1', 'ans' => 0]
        ]
    ],
    [
        'sub' => 1, 'class' => 65, 'type' => 'exam_body', 'eb' => 2, 'topic' => 'NULL', 
        'q' => 'Evaluate the integral of cos(x) from 0 to pi/2',
        'opts' => [
            ['text' => '0', 'ans' => 0],
            ['text' => '1', 'ans' => 1],
            ['text' => '-1', 'ans' => 0],
            ['text' => '0.5', 'ans' => 0]
        ]
    ],
    [
        'sub' => 1, 'class' => 64, 'type' => 'topic', 'eb' => 'NULL', 'topic' => $topic_ids[0], 
        'q' => 'Convert 1011 (base 2) to base 10',
        'opts' => [
            ['text' => '11', 'ans' => 1],
            ['text' => '10', 'ans' => 0],
            ['text' => '8', 'ans' => 0],
            ['text' => '13', 'ans' => 0]
        ]
    ],
    [
        'sub' => 1, 'class' => 65, 'type' => 'topic', 'eb' => 'NULL', 'topic' => $topic_ids[2], 
        'q' => 'What is the probability of rolling a 6 on a fair die?',
        'opts' => [
            ['text' => '1/6', 'ans' => 1],
            ['text' => '1/2', 'ans' => 0],
            ['text' => '1/3', 'ans' => 0],
            ['text' => '1/4', 'ans' => 0]
        ]
    ]
];

foreach ($questions as $q) {
    mysqli_query($conn, "INSERT INTO question_bank (subject_id, class_id, source_type, exam_body_id, topic_id, question) VALUES ({$q['sub']}, {$q['class']}, '{$q['type']}', {$q['eb']}, {$q['topic']}, '{$q['q']}')");
    $qid = mysqli_insert_id($conn);
    foreach ($q['opts'] as $o) {
        mysqli_query($conn, "INSERT INTO question_bank_options (question_id, options, answer) VALUES ($qid, '{$o['text']}', {$o['ans']})");
    }
}

echo "Seeding completed successfully!";
?>
