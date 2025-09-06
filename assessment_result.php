<?php
session_start();
// echo 'lkl';
// exit;
if (!isset($_SESSION['userid']) || $_SESSION['user_type'] !== 'student') {
    header("Location: login");
    exit();
}

include_once("model/connect.php");
include_once("model/functions.php");

if (!isset($_GET['id'])) {
    header("Location: student_portal");
    exit();
}

$result_id = (int)$_GET['id'];
$student_id = $_SESSION['userid'];

// Get result data
$sql = "SELECT r.*, a.subject_id, a.instruction, s.subject
        FROM assessment_results r
        JOIN assessment a ON r.assessment_id = a.id
        JOIN subjects s ON a.subject_id = s.id
        WHERE r.id = ? AND r.student_id = ?";

$stmt = mysqli_prepare($conn, $sql);
mysqli_stmt_bind_param($stmt, "ii", $result_id, $student_id);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

if (!$row = mysqli_fetch_assoc($result)) {
    header("Location: student_portal");
    exit();
}

$score_percentage = ($row['score'] / $row['total_questions']) * 100;
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assessment Result</title>
    <!-- Add your CSS includes here -->
</head>
<body>
    <div class="container mt-4">
        <div class="card">
            <div class="card-header">
                <h3>Assessment Result - <?= htmlspecialchars($row['subject_name']) ?></h3>
            </div>
            <div class="card-body">
                <div class="result-summary">
                    <h4>Score: <?= $row['score'] ?> / <?= $row['total_questions'] ?> (<?= number_format($score_percentage, 1) ?>%)</h4>
                    <p class="mt-3">Submitted on: <?= date('F j, Y, g:i a', strtotime($row['submitted_at'])) ?></p>
                </div>

                <div class="answers-review mt-4">
                    <h5>Review Answers</h5>
                    <?php
                    $answers = json_decode($row['answers'], true);
                    foreach ($answers as $question_id => $answer_id):
                        $q_sql = "SELECT question FROM questions WHERE id = ?";
                        $stmt = mysqli_prepare($conn, $q_sql);
                        mysqli_stmt_bind_param($stmt, "i", $question_id);
                        mysqli_stmt_execute($stmt);
                        $q_result = mysqli_stmt_get_result($stmt);
                        $question = mysqli_fetch_assoc($q_result);
                    ?>
                        <div class="question-review mb-3">
                            <p class="font-weight-bold"><?= htmlspecialchars($question['question']) ?></p>
                            <?php
                            $o_sql = "SELECT * FROM options WHERE question_id = ?";
                            $stmt = mysqli_prepare($conn, $o_sql);
                            mysqli_stmt_bind_param($stmt, "i", $question_id);
                            mysqli_stmt_execute($stmt);
                            $o_result = mysqli_stmt_get_result($stmt);
                            while ($option = mysqli_fetch_assoc($o_result)):
                                $is_selected = $answer_id == $option['id'];
                                $is_correct = $option['answer'] == 1;
                                $class = '';
                                if ($is_selected && $is_correct) $class = 'text-success';
                                elseif ($is_selected && !$is_correct) $class = 'text-danger';
                                elseif (!$is_selected && $is_correct) $class = 'text-success';
                            ?>
                                <div class="option <?= $class ?>">
                                    <?= $is_selected ? '✓' : '○' ?> 
                                    <?= htmlspecialchars($option['options']) ?>
                                    <?= $is_correct ? '(Correct Answer)' : '' ?>
                                </div>
                            <?php endwhile; ?>
                        </div>
                    <?php endforeach; ?>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
