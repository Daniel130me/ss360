<?php
session_start();
include_once("model/connect.php");

header('Content-Type: application/json');

if (!isset($_POST['assessment_id']) || !isset($_POST['answers'])) {
    echo json_encode(['success' => false, 'message' => 'Missing parameters']);
    exit;
}

$assessment_id = (int)$_POST['assessment_id'];
$student_id = $_SESSION['userid'];
$answers = json_decode($_POST['answers'], true);

mysqli_begin_transaction($conn);

try {

    // Get assessment details
    $assessment_sql = "SELECT subject_id,desired_score,score_destination,round_off_decimal FROM assessment WHERE id = ?";
    $stmt = mysqli_prepare($conn, $assessment_sql);
    if (!$stmt) {
        throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
    }
    mysqli_stmt_bind_param($stmt, "i", $assessment_id);
    mysqli_stmt_execute($stmt);
    $assessment_result = mysqli_stmt_get_result($stmt);
    $assessment_row = mysqli_fetch_assoc($assessment_result);
    $subject_id = $assessment_row['subject_id'];
    $desired_score = $assessment_row['desired_score'];
    $score_destination = $assessment_row['score_destination'];
    $round_off_decimal = $assessment_row['round_off_decimal'];
    mysqli_stmt_close($stmt);
    
    // Get total number of questions first
    $total_query = "SELECT COUNT(*) as total FROM questions WHERE ass_id = ? and deleted=0";
    $stmt = mysqli_prepare($conn, $total_query);
    if (!$stmt) {
        throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
    }
    mysqli_stmt_bind_param($stmt, "i", $assessment_id);
    mysqli_stmt_execute($stmt);
    $total_result = mysqli_stmt_get_result($stmt);
    $total_row = mysqli_fetch_assoc($total_result);
    $total_questions = $total_row['total'];
    mysqli_stmt_close($stmt);

    // Calculate score
    $score = 0;
    $processed_questions = [];

    foreach ($answers as $question_id => $answer_id) {
        // Validate answer format
        if (!is_numeric($answer_id)) continue;

        // Prevent duplicate answers for same question
        if (in_array($question_id, $processed_questions)) continue;
        $processed_questions[] = $question_id;

        // Check if this question belongs to this assessment
        $question_check = "SELECT id FROM questions WHERE id = ? AND ass_id = ? and deleted=0";
        $stmt = mysqli_prepare($conn, $question_check);
        if (!$stmt) {
            throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
        }
        mysqli_stmt_bind_param($stmt, "ii", $question_id, $assessment_id);
        mysqli_stmt_execute($stmt);
        mysqli_stmt_store_result($stmt);
        if (mysqli_stmt_num_rows($stmt) == 0) {
            mysqli_stmt_free_result($stmt);
            mysqli_stmt_close($stmt);
            continue;
        }
        mysqli_stmt_free_result($stmt);
        mysqli_stmt_close($stmt);

        // Check if answer is correct
        $sql = "SELECT answer FROM options WHERE question_id = ? and deleted=0 AND id = ?";
        $stmt = mysqli_prepare($conn, $sql);
        if (!$stmt) {
            throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
        }
        mysqli_stmt_bind_param($stmt, "ii", $question_id, $answer_id);
        mysqli_stmt_execute($stmt);
        $result = mysqli_stmt_get_result($stmt);

        if ($row = mysqli_fetch_assoc($result)) {
            if ($row['answer'] == '1') {
                $score++;
            }
        }
        mysqli_stmt_close($stmt);
    }
    
    // Calculate percentage score
    $percentage_score = ($score / $total_questions) * 100;
    $actual_score = ((int)$desired_score/(int)$total_questions) * $score;
    if ($round_off_decimal == '1') {
        $actual_score = round($actual_score, 2);
    } else if ($round_off_decimal == '0') {
        $actual_score = round($actual_score, 0);
    }


    // Save result
    $sql = "INSERT INTO assessment_results 
            (assessment_id, student_id, score, total_questions, percentage_score, answers, submitted_at)
            VALUES (?, ?, ?, ?, ?, ?, NOW())";
    $stmt = mysqli_prepare($conn, $sql);
    if (!$stmt) {
        throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
    }   
    $answers_json = json_encode($answers);
    mysqli_stmt_bind_param($stmt, "iiiids",
        $assessment_id, $student_id, $score, $total_questions, $percentage_score, $answers_json);
    
    if (!mysqli_stmt_execute($stmt)) {
        throw new Exception("Execute failed: (" . mysqli_stmt_errno($stmt) . ") " . mysqli_stmt_error($stmt));
    }

    $result_id = mysqli_insert_id($conn);
    mysqli_stmt_close($stmt);


  

    // First check if record exists
    $check_sql = "SELECT id FROM skulscores 
                  WHERE student_id = {$_SESSION['userid']} 
                  AND subject_id = $subject_id
                  AND term_id = {$_SESSION['term_id']}
                  AND session_id = {$_SESSION['session_id']}
                  AND school_id = {$_SESSION['school_id']}
                  AND class_id = {$_SESSION['class_id']}";
    
    $result = mysqli_query($conn, $check_sql);
    
    $score_field = "";
    switch ($score_destination) {
        case 1: $score_field = "ca1"; break;
        case 2: $score_field = "ca2"; break;
        case 3: $score_field = "ca3"; break;
        case 4: $score_field = "pra"; break;
        case 5: $score_field = "exam"; break;
        case 6: $score_field = "assignment"; break;
        default: throw new Exception("Invalid score destination");
    }
    // Only update/insert into skulscores if score destination is not 'assignment'
    if ($score_field !== 'assignment') {
        if (mysqli_num_rows($result) > 0) {
            // Update existing record
            $sql = "UPDATE skulscores SET $score_field = $actual_score 
                    WHERE student_id = {$_SESSION['userid']} 
                    AND subject_id = $subject_id
                    AND term_id = {$_SESSION['term_id']}
                    AND session_id = {$_SESSION['session_id']}
                    AND school_id = {$_SESSION['school_id']}
                    AND class_id = {$_SESSION['class_id']}";
        } else {
            // Insert new record
            $sql = "INSERT INTO skulscores (student_id, subject_id, term_id, session_id, school_id, class_id, $score_field) 
                    VALUES ({$_SESSION['userid']}, $subject_id, {$_SESSION['term_id']}, 
                            {$_SESSION['session_id']}, {$_SESSION['school_id']}, 
                            {$_SESSION['class_id']}, $actual_score)";
        }

            if (!mysqli_query($conn, $sql)) {
                throw new Exception("Query failed: " . mysqli_error($conn));
            }
        }


    // Delete progress data
    mysqli_query($conn, "DELETE FROM assessment_progress 
                WHERE assessment_id = $assessment_id AND student_id = $student_id");

    mysqli_commit($conn);

    echo json_encode([
        'success' => true,
        'result_id' => $result_id,
        'score' => $score,
        'total' => $total_questions,
        'percentage' => $percentage_score
    ]);

} catch (Exception $e) {
    mysqli_rollback($conn);
    error_log("Assessment submission error: " . $e->getMessage());
    echo json_encode([
        'success' => false,
        'message' => 'Error submitting assessment. Please try again. ' . $e->getMessage()
    ]);
}
?>
