<?php

/**
 * Helpers used while a student is taking an assessment.
 *
 * Question order is derived from the attempt rather than generated in the browser.
 * This gives different attempts different orders while keeping an in-progress
 * attempt stable across page refreshes, devices and autosaves.
 */

function assessment_delivery_require_student(mysqli $conn, int $assessmentId): array
{
    $studentId = (int)($_SESSION['userid'] ?? 0);
    $schoolId = (int)($_SESSION['school_id'] ?? 0);

    if (($_SESSION['user_type'] ?? '') !== 'student' || $studentId <= 0 || $schoolId <= 0) {
        throw new RuntimeException('You are not authorized to take this assessment.', 403);
    }

    $stmt = $conn->prepare(
        "SELECT a.class_ids, a.blacklist_students, s.class_id, aa.id AS attempt_id
         FROM assessment a
         INNER JOIN students s
            ON s.id = ? AND s.school_id = a.school_id AND s.status = 1
         INNER JOIN assessment_attempts aa
            ON aa.assessment_id = a.id
           AND aa.student_id = s.id
           AND aa.status = 'in_progress'
         WHERE a.id = ? AND a.school_id = ?
         ORDER BY aa.id DESC
         LIMIT 1"
    );
    $stmt->bind_param('iii', $studentId, $assessmentId, $schoolId);
    $stmt->execute();
    $context = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    if (!$context) {
        throw new RuntimeException('No active assessment attempt was found.', 403);
    }

    $allowedClasses = array_filter(array_map('intval', explode(',', (string)$context['class_ids'])));
    if (!in_array((int)$context['class_id'], $allowedClasses, true)) {
        throw new RuntimeException('This assessment is not assigned to your class.', 403);
    }

    $blacklistedStudents = array_filter(array_map('intval', explode(',', (string)$context['blacklist_students'])));
    if (in_array($studentId, $blacklistedStudents, true)) {
        throw new RuntimeException('You are not allowed to take this assessment.', 403);
    }

    return [
        'assessment_id' => $assessmentId,
        'student_id' => $studentId,
        'attempt_id' => (int)$context['attempt_id'],
    ];
}

function assessment_delivery_shuffle_question_ids(array $questionIds, array $context): array
{
    $questionIds = array_values(array_map('intval', $questionIds));
    $seed = implode(':', [
        $context['assessment_id'],
        $context['student_id'],
        $context['attempt_id'],
    ]);

    // Pre-compute sort keys so the comparison function stays inexpensive.
    $sortKeys = [];
    foreach ($questionIds as $questionId) {
        $sortKeys[$questionId] = hash('sha256', $seed . ':' . $questionId);
    }

    usort($questionIds, static function (int $left, int $right) use ($sortKeys): int {
        $comparison = strcmp($sortKeys[$left], $sortKeys[$right]);
        return $comparison !== 0 ? $comparison : ($left <=> $right);
    });

    return $questionIds;
}

function assessment_delivery_question_ids(mysqli $conn, array $context): array
{
    $stmt = $conn->prepare(
        'SELECT id FROM questions WHERE ass_id = ? AND deleted = 0 ORDER BY id'
    );
    $stmt->bind_param('i', $context['assessment_id']);
    $stmt->execute();
    $result = $stmt->get_result();

    $questionIds = [];
    while ($row = $result->fetch_assoc()) {
        $questionIds[] = (int)$row['id'];
    }
    $stmt->close();

    return assessment_delivery_shuffle_question_ids($questionIds, $context);
}

function assessment_delivery_find_question(mysqli $conn, array $context, int $questionId): ?array
{
    $stmt = $conn->prepare(
        "SELECT q.id, q.question,
                o.id AS option_id, o.options AS option_text
         FROM questions q
         LEFT JOIN options o ON o.question_id = q.id AND o.deleted = 0
         WHERE q.id = ? AND q.ass_id = ? AND q.deleted = 0
         ORDER BY o.id"
    );
    $stmt->bind_param('ii', $questionId, $context['assessment_id']);
    $stmt->execute();
    $result = $stmt->get_result();

    $question = null;
    while ($row = $result->fetch_assoc()) {
        if ($question === null) {
            $question = [
                'id' => (int)$row['id'],
                'question' => $row['question'],
                'options' => [],
            ];
        }

        if ($row['option_id'] !== null) {
            $question['options'][] = [
                'id' => (int)$row['option_id'],
                'text' => $row['option_text'],
            ];
        }
    }
    $stmt->close();

    return $question;
}
