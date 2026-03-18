<?php
session_start();
include_once("model/connect.php");

header('Content-Type: application/json; charset=utf-8');

// ensure connection uses utf8mb4 so JSON (and math/html) are preserved correctly
mysqli_set_charset($conn, 'utf8mb4');

// Increase GROUP_CONCAT length for this session to avoid truncation of concatenated JSON
mysqli_query($conn, "SET SESSION group_concat_max_len = 1000000");

if (!isset($_POST['assessment_id']) || !isset($_POST['question_num'])) {
    echo json_encode(['error' => 'Missing parameters']);
    exit;
}

$assessment_id = (int)$_POST['assessment_id'];
$question_num = (int)$_POST['question_num'] - 1; // Convert to 0-based index

// Get question with pagination
// $sql = "SELECT q.*, GROUP_CONCAT(
//             JSON_OBJECT(
//                 'id', o.id,
//                 'text', o.options,
//                 'isAnswer', o.answer
//             )
//         ) as options
//         FROM questions q
//         LEFT JOIN options o ON q.id = o.question_id
//         WHERE q.ass_id = ? and q.deleted=0
//         GROUP BY q.id
//         LIMIT ?, 1";

$sql = "SELECT q.*, GROUP_CONCAT(
            JSON_OBJECT(
                'id', o.id,
                'text', o.options,
                'isAnswer', o.answer
            )
        ) as options
        FROM questions q
        LEFT JOIN options o ON q.id = o.question_id
        WHERE q.ass_id = ? and q.deleted=0
        GROUP BY q.id
            ORDER BY q.id ASC
            LIMIT ?, 1";

$stmt = mysqli_prepare($conn, $sql);
if (!$stmt) {
    echo json_encode(['error' => 'Prepare failed', 'mysql_error' => mysqli_error($conn)]);
    exit;
}

mysqli_stmt_bind_param($stmt, "ii", $assessment_id, $question_num);
if (!mysqli_stmt_execute($stmt)) {
    echo json_encode(['error' => 'Execute failed', 'stmt_error' => mysqli_stmt_error($stmt)]);
    exit;
}

$result = mysqli_stmt_get_result($stmt);

if ($row = mysqli_fetch_assoc($result)) {
    // If there are no options, GROUP_CONCAT will be null. Ensure we return an empty array instead of null.
    if (empty($row['options'])) {
        $row['options'] = [];
    } else {
        // Wrap in array brackets because GROUP_CONCAT returns comma-separated JSON_OBJECT(...) values
        $json = '[' . $row['options'] . ']';
        $decoded = json_decode($json, true);
        if (json_last_error() !== JSON_ERROR_NONE) {
            // Try to sanitize control characters and retry
            $fixed = preg_replace('/[\x00-\x1F\x7F]/u', '', $row['options']);
            $decoded = json_decode('[' . $fixed . ']', true);
        }
        $row['options'] = $decoded ?: [];
    }

    echo json_encode($row);
} else {
    echo json_encode(['error' => 'Question not found']);
}
