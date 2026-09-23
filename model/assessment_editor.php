<?php

const ASSESSMENT_EDITOR_STAFF_TYPES = [1, 2, 3, 4, 5, 6];

function assessment_editor_require_staff(): array
{
    $schoolId = (int)($_SESSION['school_id'] ?? 0);
    $staffId = (int)($_SESSION['userid'] ?? 0);
    $staffType = (int)($_SESSION['staff_type'] ?? 0);

    if ($schoolId <= 0 || $staffId <= 0 || !in_array($staffType, ASSESSMENT_EDITOR_STAFF_TYPES, true)) {
        throw new RuntimeException('You are not authorized to manage assessments.', 403);
    }

    return ['school_id' => $schoolId, 'staff_id' => $staffId];
}

function assessment_editor_plain_text(string $html): string
{
    $decoded = html_entity_decode($html, ENT_QUOTES | ENT_HTML5, 'UTF-8');
    return trim(str_replace("\xC2\xA0", ' ', strip_tags($decoded)));
}

function assessment_editor_normalize_class_ids($value): string
{
    $ids = is_array($value) ? $value : explode(',', (string)$value);
    $ids = array_values(array_unique(array_filter(array_map('intval', $ids), static fn($id) => $id > 0)));

    if (!$ids) {
        throw new InvalidArgumentException('Assign at least one class to the assessment.');
    }

    return implode(',', $ids);
}

function assessment_editor_assert_classes_belong_to_school(
    mysqli $conn,
    string $classIds,
    int $schoolId
): void {
    $ids = array_map('intval', explode(',', $classIds));
    $placeholders = implode(',', array_fill(0, count($ids), '?'));
    $types = str_repeat('i', count($ids) + 1);
    $params = array_merge($ids, [$schoolId]);

    $stmt = $conn->prepare(
        "SELECT COUNT(*) AS class_count FROM class WHERE id IN ({$placeholders}) AND school_id = ?"
    );
    $stmt->bind_param($types, ...$params);
    $stmt->execute();
    $classCount = (int)$stmt->get_result()->fetch_assoc()['class_count'];
    $stmt->close();

    if ($classCount !== count($ids)) {
        throw new InvalidArgumentException('One or more selected classes do not belong to this school.');
    }
}

function assessment_editor_validate_settings(array $settings): array
{
    $assessmentType = (int)($settings['assessment_type'] ?? 0);
    $term = (int)($settings['term'] ?? 0);
    $subjectId = (int)($settings['subject_id'] ?? 0);
    $scoreDestination = (int)($settings['ca_type'] ?? 6);
    $duration = max(0, (int)($settings['duration'] ?? 0));
    $deadlineDate = trim((string)($settings['deadline_date'] ?? ''));
    $deadlineTime = trim((string)($settings['deadline_time'] ?? '')) ?: '00:00:00';

    if (!in_array($assessmentType, [1, 2, 3], true)) {
        throw new InvalidArgumentException('Select a valid assessment type.');
    }
    if (!in_array($term, [1, 2, 3], true)) {
        throw new InvalidArgumentException('Select a valid term.');
    }
    if ($subjectId <= 0) {
        throw new InvalidArgumentException('Select a subject.');
    }
    if (!in_array($scoreDestination, [1, 2, 3, 4, 5, 6], true)) {
        throw new InvalidArgumentException('Select a valid score destination.');
    }

    return [
        'assessment_id' => max(0, (int)($settings['assessment_id'] ?? 0)),
        'assessment_type' => $assessmentType,
        'term' => $term,
        'subject_id' => $subjectId,
        'class_ids' => assessment_editor_normalize_class_ids($settings['class_ids'] ?? ''),
        'instruction' => trim((string)($settings['instruction'] ?? '')),
        'duration_set' => $duration > 0 ? 1 : 0,
        'duration' => $duration,
        'deadline_set' => $deadlineDate !== '' ? 1 : 0,
        'deadline_date' => $deadlineDate !== '' ? $deadlineDate : null,
        'deadline_time' => $deadlineTime,
        'desired_score' => max(0, (int)($settings['desired_score'] ?? 0)),
        'round_off_decimal' => !empty($settings['round_off_decimal']) ? 1 : 0,
        'score_destination' => $scoreDestination,
        'save_token' => trim((string)($settings['save_token'] ?? '')),
    ];
}

function assessment_editor_validate_questions($questions): array
{
    if (!is_array($questions) || !$questions) {
        throw new InvalidArgumentException('Add at least one question.');
    }

    foreach ($questions as $index => &$question) {
        if (!is_array($question) || assessment_editor_plain_text((string)($question['question'] ?? '')) === '') {
            throw new InvalidArgumentException('Question ' . ($index + 1) . ' cannot be empty.');
        }
        if (!isset($question['options']) || !is_array($question['options']) || count($question['options']) < 2) {
            throw new InvalidArgumentException('Question ' . ($index + 1) . ' must have at least two options.');
        }

        $correctAnswers = 0;
        foreach ($question['options'] as $optionIndex => &$option) {
            if (!is_array($option) || assessment_editor_plain_text((string)($option['text'] ?? '')) === '') {
                throw new InvalidArgumentException(
                    'Option ' . ($optionIndex + 1) . ' in Question ' . ($index + 1) . ' cannot be empty.'
                );
            }
            $option['isAnswer'] = !empty($option['isAnswer']);
            $correctAnswers += $option['isAnswer'] ? 1 : 0;
        }
        unset($option);

        if ($correctAnswers !== 1) {
            throw new InvalidArgumentException('Question ' . ($index + 1) . ' must have exactly one correct answer.');
        }
    }
    unset($question);

    return $questions;
}

function assessment_editor_find_owned_assessment(mysqli $conn, int $assessmentId, int $schoolId, bool $lock = false): ?array
{
    $sql = 'SELECT id FROM assessment WHERE id = ? AND school_id = ? LIMIT 1' . ($lock ? ' FOR UPDATE' : '');
    $stmt = $conn->prepare($sql);
    $stmt->bind_param('ii', $assessmentId, $schoolId);
    $stmt->execute();
    $assessment = $stmt->get_result()->fetch_assoc() ?: null;
    $stmt->close();

    return $assessment;
}

/**
 * Synchronize question and option rows and return IDs in the same order as the payload.
 * Full-set mode also removes saved questions omitted by the create/edit-all page.
 */
function assessment_editor_sync_questions(
    mysqli $conn,
    int $assessmentId,
    array $questions,
    bool $fullSet
): array {
    $questions = assessment_editor_validate_questions($questions);
    $existingQuestions = [];
    $existingOptions = [];

    $stmt = $conn->prepare(
        'SELECT q.id AS question_id, o.id AS option_id
         FROM questions q
         LEFT JOIN options o ON o.question_id = q.id AND o.deleted = 0
         WHERE q.ass_id = ? AND q.deleted = 0'
    );
    $stmt->bind_param('i', $assessmentId);
    $stmt->execute();
    $rows = $stmt->get_result();
    while ($row = $rows->fetch_assoc()) {
        $questionId = (int)$row['question_id'];
        $existingQuestions[$questionId] = true;
        if ($row['option_id'] !== null) {
            $existingOptions[$questionId][(int)$row['option_id']] = true;
        }
    }
    $stmt->close();

    $insertQuestion = $conn->prepare('INSERT INTO questions (question, ass_id, deleted) VALUES (?, ?, 0)');
    $updateQuestion = $conn->prepare('UPDATE questions SET question = ?, deleted = 0 WHERE id = ? AND ass_id = ?');
    $insertOption = $conn->prepare('INSERT INTO options (options, question_id, answer, deleted) VALUES (?, ?, ?, 0)');
    $updateOption = $conn->prepare(
        'UPDATE options SET options = ?, answer = ?, deleted = 0 WHERE id = ? AND question_id = ?'
    );

    $keptQuestions = [];
    $keptOptions = [];
    $mapping = [];

    foreach ($questions as $question) {
        $questionId = (int)($question['id'] ?? 0);
        $questionHtml = (string)$question['question'];

        if ($questionId > 0) {
            if (!isset($existingQuestions[$questionId]) || isset($keptQuestions[$questionId])) {
                throw new InvalidArgumentException('A question does not belong to this assessment or was submitted twice.');
            }
            $updateQuestion->bind_param('sii', $questionHtml, $questionId, $assessmentId);
            $updateQuestion->execute();
        } else {
            $insertQuestion->bind_param('si', $questionHtml, $assessmentId);
            $insertQuestion->execute();
            $questionId = $insertQuestion->insert_id;
            $existingOptions[$questionId] = [];
        }

        $keptQuestions[$questionId] = true;
        $optionIds = [];
        foreach ($question['options'] as $option) {
            $optionId = (int)($option['id'] ?? 0);
            $optionHtml = (string)$option['text'];
            $isAnswer = $option['isAnswer'] ? 1 : 0;

            if ($optionId > 0) {
                if (!isset($existingOptions[$questionId][$optionId]) || isset($keptOptions[$optionId])) {
                    throw new InvalidArgumentException('An option does not belong to its question or was submitted twice.');
                }
                $updateOption->bind_param('siii', $optionHtml, $isAnswer, $optionId, $questionId);
                $updateOption->execute();
            } else {
                $insertOption->bind_param('sii', $optionHtml, $questionId, $isAnswer);
                $insertOption->execute();
                $optionId = $insertOption->insert_id;
            }

            $keptOptions[$optionId] = true;
            $optionIds[] = $optionId;
        }

        $mapping[] = ['question_id' => $questionId, 'options' => $optionIds];
    }

    $insertQuestion->close();
    $updateQuestion->close();
    $insertOption->close();
    $updateOption->close();

    $incomingQuestionIds = array_keys($keptQuestions);
    $optionScope = $incomingQuestionIds ? implode(',', array_map('intval', $incomingQuestionIds)) : '0';
    $keptOptionIds = array_keys($keptOptions);
    $optionExclusion = $keptOptionIds ? ' AND o.id NOT IN (' . implode(',', array_map('intval', $keptOptionIds)) . ')' : '';
    $conn->query(
        "DELETE o FROM options o
         INNER JOIN questions q ON q.id = o.question_id
         WHERE q.ass_id = {$assessmentId} AND q.id IN ({$optionScope}){$optionExclusion}"
    );

    if ($fullSet) {
        $questionExclusion = $incomingQuestionIds
            ? ' AND q.id NOT IN (' . implode(',', array_map('intval', $incomingQuestionIds)) . ')'
            : '';
        $conn->query(
            "DELETE o FROM options o
             INNER JOIN questions q ON q.id = o.question_id
             WHERE q.ass_id = {$assessmentId}{$questionExclusion}"
        );
        $conn->query("DELETE q FROM questions q WHERE q.ass_id = {$assessmentId}{$questionExclusion}");
    }

    return $mapping;
}

function assessment_editor_save(
    mysqli $conn,
    array $settings,
    array $questions,
    bool $fullQuestionSet
): array {
    $context = assessment_editor_require_staff();
    $settings = assessment_editor_validate_settings($settings);
    $questions = assessment_editor_validate_questions($questions);
    $schoolId = $context['school_id'];
    $staffId = $context['staff_id'];
    $assessmentId = $settings['assessment_id'];

    $conn->begin_transaction();
    try {
        assessment_editor_assert_classes_belong_to_school($conn, $settings['class_ids'], $schoolId);

        if ($assessmentId > 0) {
            if (!assessment_editor_find_owned_assessment($conn, $assessmentId, $schoolId, true)) {
                throw new RuntimeException('Assessment not found.', 404);
            }

            $stmt = $conn->prepare(
                'UPDATE assessment SET subject_id = ?, instruction = ?, duration_set = ?, duration = ?,
                 deadline_set = ?, deadline_date = ?, deadline_time = ?, class_ids = ?, assessment_type = ?,
                 term = ?, desired_score = ?, round_off_decimal = ?, score_destination = ?, updatedby = ?,
                 dateupdated = NOW() WHERE id = ? AND school_id = ?'
            );
            $stmt->bind_param(
                'isiiisssiiiiiiii',
                $settings['subject_id'],
                $settings['instruction'],
                $settings['duration_set'],
                $settings['duration'],
                $settings['deadline_set'],
                $settings['deadline_date'],
                $settings['deadline_time'],
                $settings['class_ids'],
                $settings['assessment_type'],
                $settings['term'],
                $settings['desired_score'],
                $settings['round_off_decimal'],
                $settings['score_destination'],
                $staffId,
                $assessmentId,
                $schoolId
            );
            $stmt->execute();
            $stmt->close();
        } else {
            if ($settings['save_token'] === '') {
                throw new InvalidArgumentException('The assessment save token is missing. Refresh the page and try again.');
            }

            $tokenLookup = $conn->prepare(
                'SELECT id FROM assessment WHERE school_id = ? AND save_token = ? LIMIT 1 FOR UPDATE'
            );
            $tokenLookup->bind_param('is', $schoolId, $settings['save_token']);
            $tokenLookup->execute();
            $wasIdempotentReplay = (bool)$tokenLookup->get_result()->fetch_assoc();
            $tokenLookup->close();

            $stmt = $conn->prepare(
                'INSERT INTO assessment
                 (assessment_type, term, subject_id, school_id, class_ids, instruction, duration_set, duration,
                  deadline_set, deadline_date, deadline_time, desired_score, score_destination, round_off_decimal,
                  save_token, created_by, datecreated, updatedby, dateupdated)
                 VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, NOW())
                 ON DUPLICATE KEY UPDATE
                  id = LAST_INSERT_ID(id), assessment_type = VALUES(assessment_type), term = VALUES(term),
                  subject_id = VALUES(subject_id), class_ids = VALUES(class_ids),
                  instruction = VALUES(instruction), duration_set = VALUES(duration_set), duration = VALUES(duration),
                  deadline_set = VALUES(deadline_set), deadline_date = VALUES(deadline_date),
                  deadline_time = VALUES(deadline_time), desired_score = VALUES(desired_score),
                  score_destination = VALUES(score_destination), round_off_decimal = VALUES(round_off_decimal),
                  updatedby = VALUES(updatedby), dateupdated = NOW()'
            );
            $stmt->bind_param(
                'iiiissiiissiiisii',
                $settings['assessment_type'],
                $settings['term'],
                $settings['subject_id'],
                $schoolId,
                $settings['class_ids'],
                $settings['instruction'],
                $settings['duration_set'],
                $settings['duration'],
                $settings['deadline_set'],
                $settings['deadline_date'],
                $settings['deadline_time'],
                $settings['desired_score'],
                $settings['score_destination'],
                $settings['round_off_decimal'],
                $settings['save_token'],
                $staffId,
                $staffId
            );
            $stmt->execute();
            $assessmentId = $stmt->insert_id;
            $wasIdempotentReplay = $wasIdempotentReplay || $stmt->affected_rows !== 1;
            $stmt->close();

            // A response may be lost after the first commit. Replaying the same token replaces that
            // initial question set, preventing a second assessment or duplicate question rows.
            if ($wasIdempotentReplay) {
                $conn->query(
                    "DELETE o FROM options o INNER JOIN questions q ON q.id = o.question_id
                     WHERE q.ass_id = {$assessmentId}"
                );
                $conn->query("DELETE FROM questions WHERE ass_id = {$assessmentId}");
            }
        }

        $mapping = assessment_editor_sync_questions($conn, $assessmentId, $questions, $fullQuestionSet);
        $conn->commit();

        return ['assessment_id' => $assessmentId, 'mapping' => $mapping];
    } catch (Throwable $error) {
        $conn->rollback();
        throw $error;
    }
}

function assessment_editor_save_question_page(mysqli $conn, int $assessmentId, array $questions): array
{
    $context = assessment_editor_require_staff();
    $conn->begin_transaction();
    try {
        if (!assessment_editor_find_owned_assessment($conn, $assessmentId, $context['school_id'], true)) {
            throw new RuntimeException('Assessment not found.', 404);
        }
        $mapping = assessment_editor_sync_questions($conn, $assessmentId, $questions, false);
        $conn->commit();
        return $mapping;
    } catch (Throwable $error) {
        $conn->rollback();
        throw $error;
    }
}

function assessment_editor_delete_question(mysqli $conn, int $assessmentId, int $questionId): void
{
    $context = assessment_editor_require_staff();
    $conn->begin_transaction();
    try {
        if (!assessment_editor_find_owned_assessment($conn, $assessmentId, $context['school_id'], true)) {
            throw new RuntimeException('Assessment not found.', 404);
        }

        $stmt = $conn->prepare('SELECT id FROM questions WHERE id = ? AND ass_id = ? LIMIT 1 FOR UPDATE');
        $stmt->bind_param('ii', $questionId, $assessmentId);
        $stmt->execute();
        $exists = (bool)$stmt->get_result()->fetch_assoc();
        $stmt->close();
        if (!$exists) {
            throw new RuntimeException('Question not found.', 404);
        }

        $stmt = $conn->prepare('SELECT COUNT(*) AS question_count FROM questions WHERE ass_id = ? AND deleted = 0');
        $stmt->bind_param('i', $assessmentId);
        $stmt->execute();
        $questionCount = (int)$stmt->get_result()->fetch_assoc()['question_count'];
        $stmt->close();
        if ($questionCount <= 1) {
            throw new InvalidArgumentException('An assessment must keep at least one question. Add a replacement before deleting this question.');
        }

        $stmt = $conn->prepare('DELETE FROM options WHERE question_id = ?');
        $stmt->bind_param('i', $questionId);
        $stmt->execute();
        $stmt->close();
        $stmt = $conn->prepare('DELETE FROM questions WHERE id = ? AND ass_id = ?');
        $stmt->bind_param('ii', $questionId, $assessmentId);
        $stmt->execute();
        $stmt->close();
        $conn->commit();
    } catch (Throwable $error) {
        $conn->rollback();
        throw $error;
    }
}
