<?php
session_start();
include_once("model/connect.php");

header('Content-Type: application/json');

if (!isset($_POST['assessment_id']) || !isset($_POST['question_num'])) {
    echo json_encode(['error' => 'Missing parameters']);
    exit;
}

$assessment_id = (int)$_POST['assessment_id'];
echo $question_num = (int)$_POST['question_num'] - 1; // Convert to 0-based index

// Get question with pagination
echo $sql = "SELECT q.*, GROUP_CONCAT(
            JSON_OBJECT(
                'id', o.id,
                'text', o.options,
                'isAnswer', o.answer
            )
        ) as options
        FROM questions q
        LEFT JOIN options o ON q.id = o.question_id
        WHERE q.ass_id = ?
        GROUP BY q.id
        LIMIT ?, 1";

$stmt = mysqli_prepare($conn, $sql);
mysqli_stmt_bind_param($stmt, "ii", $assessment_id, $question_num);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

if ($row = mysqli_fetch_assoc($result)) {
    $row['options'] = json_decode('[' . $row['options'] . ']');
    var_dump('asssssssssssss',$row);
    echo json_encode($row);
} else {
    echo json_encode(['error' => 'Question not found']);
}
