<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}

include_once('model/connect.php');
include_once('model/assessment_delivery.php');

header('Content-Type: application/json; charset=utf-8');

$assessmentId = (int)($_POST['assessment_id'] ?? 0);
$submittedAnswers = json_decode((string)($_POST['answers'] ?? ''), true);
$timeRemaining = max(0, (int)($_POST['time_remaining'] ?? 0));
$studentId = (int)($_SESSION['userid'] ?? 0);
$schoolId = (int)($_SESSION['school_id'] ?? 0);

function assessment_submission_response(array $result): array
{
    return [
        'success' => true,
        'result_id' => (int)$result['id'],
        'score' => (int)$result['score'],
        'total' => (int)$result['total_questions'],
        'percentage' => (float)$result['percentage_score'],
    ];
}

try {
    if (($_SESSION['user_type'] ?? '') !== 'student' || $assessmentId <= 0 || !is_array($submittedAnswers)) {
        throw new InvalidArgumentException('Invalid assessment submission.');
    }

    // A retry after a successful response must be harmless and return the original result.
    $existingStmt = $conn->prepare(
        "SELECT r.id, r.score, r.total_questions, r.percentage_score
         FROM assessment_results r
         INNER JOIN assessment a ON a.id = r.assessment_id AND a.school_id = ?
         WHERE r.assessment_id = ? AND r.student_id = ?
         LIMIT 1"
    );
    $existingStmt->bind_param('iii', $schoolId, $assessmentId, $studentId);
    $existingStmt->execute();
    $existingResult = $existingStmt->get_result()->fetch_assoc();
    $existingStmt->close();
    if ($existingResult) {
        echo json_encode(assessment_submission_response($existingResult));
        exit;
    }

    $context = assessment_delivery_require_student($conn, $assessmentId);
    $conn->begin_transaction();

    // Serialize submission and timer/autosave updates for this attempt.
    $attemptStmt = $conn->prepare(
        'SELECT id, status FROM assessment_attempts WHERE id = ? FOR UPDATE'
    );
    $attemptStmt->bind_param('i', $context['attempt_id']);
    $attemptStmt->execute();
    $attempt = $attemptStmt->get_result()->fetch_assoc();
    $attemptStmt->close();
    if (!$attempt || $attempt['status'] !== 'in_progress') {
        throw new RuntimeException('This assessment attempt is no longer active.');
    }

    $assessmentStmt = $conn->prepare(
        "SELECT subject_id, desired_score, score_destination, round_off_decimal
         FROM assessment WHERE id = ? AND school_id = ? LIMIT 1"
    );
    $assessmentStmt->bind_param('ii', $assessmentId, $schoolId);
    $assessmentStmt->execute();
    $assessment = $assessmentStmt->get_result()->fetch_assoc();
    $assessmentStmt->close();
    if (!$assessment) {
        throw new RuntimeException('Assessment not found.');
    }

    // One query loads the valid question/option map and replaces the former N+1 scoring loop.
    $questionStmt = $conn->prepare(
        "SELECT q.id AS question_id, o.id AS option_id, o.answer
         FROM questions q
         LEFT JOIN options o ON o.question_id = q.id AND o.deleted = 0
         WHERE q.ass_id = ? AND q.deleted = 0
         ORDER BY q.id, o.id"
    );
    $questionStmt->bind_param('i', $assessmentId);
    $questionStmt->execute();
    $questionRows = $questionStmt->get_result();

    $validOptions = [];
    while ($row = $questionRows->fetch_assoc()) {
        $questionId = (int)$row['question_id'];
        if (!isset($validOptions[$questionId])) {
            $validOptions[$questionId] = [];
        }
        if ($row['option_id'] !== null) {
            $validOptions[$questionId][(int)$row['option_id']] = (int)$row['answer'] === 1;
        }
    }
    $questionStmt->close();

    $totalQuestions = count($validOptions);
    if ($totalQuestions < 1) {
        throw new RuntimeException('This assessment has no questions.');
    }

    $answers = [];
    $score = 0;
    foreach ($submittedAnswers as $questionId => $optionId) {
        $questionId = (int)$questionId;
        $optionId = (int)$optionId;
        if (!isset($validOptions[$questionId][$optionId])) {
            continue;
        }
        $answers[$questionId] = $optionId;
        if ($validOptions[$questionId][$optionId]) {
            $score++;
        }
    }

    $percentageScore = ($score / $totalQuestions) * 100;
    $actualScore = ((float)$assessment['desired_score'] / $totalQuestions) * $score;
    $actualScore = (int)$assessment['round_off_decimal'] === 1
        ? round($actualScore, 2)
        : round($actualScore);
    $answersJson = json_encode($answers, JSON_THROW_ON_ERROR);

    $resultStmt = $conn->prepare(
        "INSERT INTO assessment_results
            (assessment_id, student_id, score, total_questions, percentage_score, answers, submitted_at)
         VALUES (?, ?, ?, ?, ?, ?, NOW())"
    );
    $resultStmt->bind_param(
        'iiiids',
        $assessmentId,
        $studentId,
        $score,
        $totalQuestions,
        $percentageScore,
        $answersJson
    );
    $resultStmt->execute();
    $resultId = $conn->insert_id;
    $resultStmt->close();

    $scoreFields = [1 => 'ca1', 2 => 'ca2', 3 => 'ca3', 4 => 'pra', 5 => 'exam'];
    $scoreDestination = (int)$assessment['score_destination'];
    if (isset($scoreFields[$scoreDestination])) {
        $scoreField = $scoreFields[$scoreDestination];
        $subjectId = (int)$assessment['subject_id'];
        $termId = (int)$_SESSION['term_id'];
        $sessionId = (int)$_SESSION['session_id'];
        $classId = (int)$_SESSION['class_id'];

        $scoreRowStmt = $conn->prepare(
            "SELECT id FROM skulscores
             WHERE student_id = ? AND subject_id = ? AND term_id = ?
               AND session_id = ? AND school_id = ? AND class_id = ?
             LIMIT 1 FOR UPDATE"
        );
        $scoreRowStmt->bind_param('iiiiii', $studentId, $subjectId, $termId, $sessionId, $schoolId, $classId);
        $scoreRowStmt->execute();
        $scoreRow = $scoreRowStmt->get_result()->fetch_assoc();
        $scoreRowStmt->close();

        if ($scoreRow) {
            $scoreStmt = $conn->prepare("UPDATE skulscores SET {$scoreField} = ? WHERE id = ?");
            $scoreRowId = (int)$scoreRow['id'];
            $scoreStmt->bind_param('di', $actualScore, $scoreRowId);
        } else {
            $scoreStmt = $conn->prepare(
                "INSERT INTO skulscores
                    (student_id, subject_id, term_id, session_id, school_id, class_id, {$scoreField})
                 VALUES (?, ?, ?, ?, ?, ?, ?)"
            );
            $scoreStmt->bind_param(
                'iiiiiid',
                $studentId,
                $subjectId,
                $termId,
                $sessionId,
                $schoolId,
                $classId,
                $actualScore
            );
        }
        $scoreStmt->execute();
        $scoreStmt->close();
    }

    $completeStmt = $conn->prepare(
        "UPDATE assessment_attempts
         SET status = 'completed', score = ?, answers = ?, time_remaining = ?,
             completed_at = NOW(), last_activity = NOW()
         WHERE id = ? AND status = 'in_progress'"
    );
    $completeStmt->bind_param('isii', $score, $answersJson, $timeRemaining, $context['attempt_id']);
    $completeStmt->execute();
    if ($completeStmt->affected_rows !== 1) {
        throw new RuntimeException('The assessment attempt could not be completed.');
    }
    $completeStmt->close();

    $progressStmt = $conn->prepare(
        'DELETE FROM assessment_progress WHERE assessment_id = ? AND student_id = ?'
    );
    $progressStmt->bind_param('ii', $assessmentId, $studentId);
    $progressStmt->execute();
    $progressStmt->close();

    $conn->commit();
    unset($_SESSION['viewed_instructions'][$assessmentId]);

    echo json_encode(assessment_submission_response([
        'id' => $resultId,
        'score' => $score,
        'total_questions' => $totalQuestions,
        'percentage_score' => $percentageScore,
    ]));
} catch (Throwable $error) {
    try {
        $conn->rollback();
    } catch (Throwable $ignored) {
    }

    $statusCode = (int)$error->getCode() === 403 ? 403 : 422;
    http_response_code($statusCode);
    $reference = strtoupper(substr(hash('sha256', uniqid('', true)), 0, 8));
    error_log("[assessment_submission:{$reference}] " . $error);
    echo json_encode([
        'success' => false,
        'message' => "Unable to submit the assessment. Reference: {$reference}",
        'reference' => $reference,
    ]);
}
