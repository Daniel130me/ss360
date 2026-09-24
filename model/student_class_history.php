<?php

/**
 * True when the class-history migration has been installed.
 *
 * The compatibility check lets code be deployed before the SQL migration without
 * taking existing report pages offline. It can be removed after every school has
 * migrated.
 */
function student_class_history_available(mysqli $conn): bool
{
    static $availableByConnection = [];
    $key = spl_object_hash($conn);

    if (!array_key_exists($key, $availableByConnection)) {
        $result = $conn->query(
            "SELECT 1
             FROM information_schema.tables
             WHERE table_schema = DATABASE()
               AND table_name = 'student_class_enrollments'
             LIMIT 1"
        );
        $availableByConnection[$key] = $result && $result->num_rows === 1;
    }

    return $availableByConnection[$key];
}

function get_student_enrollment_class_id(
    mysqli $conn,
    int $schoolId,
    int $studentId,
    int $sessionId,
    int $termId
): ?int {
    if (
        !student_class_history_available($conn)
        || $schoolId <= 0
        || $studentId <= 0
        || $sessionId <= 0
        || $termId < 1
        || $termId > 3
    ) {
        return null;
    }

    $stmt = $conn->prepare(
        'SELECT class_id
         FROM student_class_enrollments
         WHERE school_id = ? AND student_id = ? AND session_id = ? AND term_id = ?
         LIMIT 1'
    );
    $stmt->bind_param('iiii', $schoolId, $studentId, $sessionId, $termId);
    $stmt->execute();
    $row = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    return $row ? (int)$row['class_id'] : null;
}

function student_class_is_graduate(mysqli $conn, int $schoolId, int $classId): bool
{
    $stmt = $conn->prepare('SELECT is_graduate FROM class WHERE id = ? AND school_id = ? LIMIT 1');
    $stmt->bind_param('ii', $classId, $schoolId);
    $stmt->execute();
    $row = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    return $row && (int)$row['is_graduate'] === 1;
}

/**
 * Graduate classes are cohort containers, not the academic class in which scores
 * were earned. Current membership supports recovered legacy graduates; movement
 * history preserves membership for future class changes.
 */
function fetch_graduate_cohort_students(mysqli $conn, int $schoolId, int $classId): array
{
    $movementCondition = student_class_history_available($conn)
        ? ' OR EXISTS (
                SELECT 1
                FROM student_class_movements m
                WHERE m.school_id = s.school_id AND m.student_id = s.id
                  AND m.to_class_id = ? AND m.movement_type = \'graduation\'
            )'
        : '';
    $stmt = $conn->prepare(
        "SELECT s.id, s.firstname, s.middlename, s.lastname, s.photo, s.status
         FROM students s
         WHERE s.school_id = ? AND (s.class_id = ? {$movementCondition})
         ORDER BY s.lastname, s.firstname, s.id"
    );
    if (student_class_history_available($conn)) {
        $stmt->bind_param('iii', $schoolId, $classId, $classId);
    } else {
        $stmt->bind_param('ii', $schoolId, $classId);
    }
    $stmt->execute();
    $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $stmt->close();

    return $rows;
}

/**
 * Store one student's class from the effective term through the end of session.
 * This is an authorized movement operation, so it intentionally replaces any
 * existing assignment for the effective and future terms only.
 */
function set_student_enrollment_from_term(
    mysqli $conn,
    int $schoolId,
    int $studentId,
    int $sessionId,
    int $effectiveTermId,
    int $classId,
    int $actorId,
    string $source = 'transfer'
): void {
    if (!student_class_history_available($conn)) {
        throw new RuntimeException('Student class history migration has not been installed.');
    }

    $effectiveTermId = max(1, min(3, $effectiveTermId));
    $confidence = $source === 'manual' ? 'manual' : 'confirmed';
    $stmt = $conn->prepare(
        'INSERT INTO student_class_enrollments
            (school_id, student_id, session_id, term_id, class_id, confidence, source, createdby, updatedby)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
         ON DUPLICATE KEY UPDATE
            class_id = VALUES(class_id),
            confidence = VALUES(confidence),
            source = VALUES(source),
            updatedby = VALUES(updatedby),
            dateupdated = CURRENT_TIMESTAMP'
    );

    for ($termId = $effectiveTermId; $termId <= 3; $termId++) {
        $stmt->bind_param(
            'iiiiissii',
            $schoolId,
            $studentId,
            $sessionId,
            $termId,
            $classId,
            $confidence,
            $source,
            $actorId,
            $actorId
        );
        if (!$stmt->execute()) {
            $message = $stmt->error;
            $stmt->close();
            throw new RuntimeException($message);
        }
    }
    $stmt->close();
}

/**
 * Return the selected class roster for a historical period.
 *
 * If the migration has not been run, the legacy current-class lookup is retained
 * only as a rollout fallback. Once history exists, current student.class_id is not
 * used to answer historical questions.
 */
function fetch_students_for_class_period(
    mysqli $conn,
    int $schoolId,
    int $classId,
    int $sessionId,
    int $termId
): array {
    if (student_class_is_graduate($conn, $schoolId, $classId)) {
        return fetch_graduate_cohort_students($conn, $schoolId, $classId);
    }

    $usedHistory = false;
    if (student_class_history_available($conn) && $sessionId > 0 && $termId >= 1 && $termId <= 3) {
        $usedHistory = true;
        $stmt = $conn->prepare(
            'SELECT s.id, s.firstname, s.middlename, s.lastname, s.photo, s.status
             FROM student_class_enrollments e
             INNER JOIN students s
                ON s.id = e.student_id AND s.school_id = e.school_id
             WHERE e.school_id = ? AND e.class_id = ? AND e.session_id = ? AND e.term_id = ?
             ORDER BY s.lastname, s.firstname, s.id'
        );
        $stmt->bind_param('iiii', $schoolId, $classId, $sessionId, $termId);
    } else {
        $stmt = $conn->prepare(
            'SELECT id, firstname, middlename, lastname, photo, status
             FROM students
             WHERE school_id = ? AND class_id = ?
             ORDER BY lastname, firstname, id'
        );
        $stmt->bind_param('ii', $schoolId, $classId);
    }

    $stmt->execute();
    $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $stmt->close();

    // Newly registered students may not have produced any evidence yet. Until the
    // registration flow creates their history row, current-period screens must
    // still show them. This fallback is never used for a past period.
    if ($usedHistory) {
        $periodStmt = $conn->prepare('SELECT session_id, term_id FROM school WHERE id = ? LIMIT 1');
        $periodStmt->bind_param('i', $schoolId);
        $periodStmt->execute();
        $currentPeriod = $periodStmt->get_result()->fetch_assoc();
        $periodStmt->close();

        if (
            $currentPeriod
            && (int)$currentPeriod['session_id'] === $sessionId
            && (int)$currentPeriod['term_id'] === $termId
        ) {
            $fallbackStmt = $conn->prepare(
                'SELECT id, firstname, middlename, lastname, photo, status
                 FROM students
                 WHERE school_id = ? AND class_id = ?
                 ORDER BY lastname, firstname, id'
            );
            $fallbackStmt->bind_param('ii', $schoolId, $classId);
            $fallbackStmt->execute();
            $currentRows = $fallbackStmt->get_result()->fetch_all(MYSQLI_ASSOC);
            $fallbackStmt->close();

            // Merge by student ID so a current student with no evidence yet is
            // visible without duplicating students already present in history.
            $rowsByStudent = [];
            foreach (array_merge($rows, $currentRows) as $student) {
                $rowsByStudent[(int)$student['id']] = $student;
            }
            $rows = array_values($rowsByStudent);
            usort($rows, static function (array $left, array $right): int {
                return [$left['lastname'], $left['firstname'], $left['id']]
                    <=> [$right['lastname'], $right['firstname'], $right['id']];
            });
        }
    }

    return $rows;
}

function count_students_for_class_period(
    mysqli $conn,
    int $schoolId,
    int $classId,
    int $sessionId,
    int $termId
): int {
    if (student_class_is_graduate($conn, $schoolId, $classId)) {
        return count(fetch_graduate_cohort_students($conn, $schoolId, $classId));
    }

    if (!student_class_history_available($conn)) {
        $stmt = $conn->prepare('SELECT COUNT(*) AS total FROM students WHERE school_id = ? AND class_id = ?');
        $stmt->bind_param('ii', $schoolId, $classId);
    } else {
        $periodStmt = $conn->prepare('SELECT session_id, term_id FROM school WHERE id = ? LIMIT 1');
        $periodStmt->bind_param('i', $schoolId);
        $periodStmt->execute();
        $currentPeriod = $periodStmt->get_result()->fetch_assoc();
        $periodStmt->close();
        $isCurrentPeriod = $currentPeriod
            && (int)$currentPeriod['session_id'] === $sessionId
            && (int)$currentPeriod['term_id'] === $termId;

        if ($isCurrentPeriod) {
            $stmt = $conn->prepare(
                'SELECT COUNT(*) AS total
                 FROM (
                    SELECT student_id
                    FROM student_class_enrollments
                    WHERE school_id = ? AND class_id = ? AND session_id = ? AND term_id = ?
                    UNION
                    SELECT id
                    FROM students
                    WHERE school_id = ? AND class_id = ?
                 ) roster'
            );
            $stmt->bind_param('iiiiii', $schoolId, $classId, $sessionId, $termId, $schoolId, $classId);
        } else {
            $stmt = $conn->prepare(
                'SELECT COUNT(*) AS total
                 FROM student_class_enrollments
                 WHERE school_id = ? AND class_id = ? AND session_id = ? AND term_id = ?'
            );
            $stmt->bind_param('iiii', $schoolId, $classId, $sessionId, $termId);
        }
    }

    $stmt->execute();
    $row = $stmt->get_result()->fetch_assoc();
    $stmt->close();

    return (int)($row['total'] ?? 0);
}

/**
 * Fetch one canonical score row per student/subject for a selected class period.
 * Graduate classes use cohort membership; ordinary classes use term enrolment.
 */
function fetch_score_rows_for_class_period(
    mysqli $conn,
    int $schoolId,
    int $classId,
    int $sessionId,
    int $termId
): array {
    $publishedTotalPredicate = '(COALESCE(s.ca1Total, 0) + COALESCE(s.ca2Total, 0)
        + COALESCE(s.ca3Total, 0) + COALESCE(s.praTotal, 0) + COALESCE(s.examTotal, 0)) > 0';
    $publishedTotalSubqueryPredicate = str_replace('s.', 'sc.', $publishedTotalPredicate);
    $historyAvailable = student_class_history_available($conn);

    if (student_class_is_graduate($conn, $schoolId, $classId)) {
        $movementCondition = $historyAvailable
            ? " OR EXISTS (
                    SELECT 1 FROM student_class_movements m
                    WHERE m.school_id = t.school_id AND m.student_id = t.id
                      AND m.to_class_id = ? AND m.movement_type = 'graduation'
                )"
            : '';
        $stmt = $conn->prepare(
            "SELECT b.subject AS subjectname, t.firstname, t.lastname, t.middlename, s.*
             FROM students t
             INNER JOIN skulscores s ON s.student_id = t.id AND s.school_id = t.school_id
             INNER JOIN subjects b ON b.id = s.subject_id
             INNER JOIN (
                SELECT MAX(sc.id) AS score_id
                FROM skulscores sc
                WHERE sc.school_id = ? AND sc.session_id = ? AND sc.term_id = ?
                  AND {$publishedTotalSubqueryPredicate}
                GROUP BY sc.student_id, sc.subject_id
             ) latest ON latest.score_id = s.id
             WHERE t.school_id = ? AND (t.class_id = ? {$movementCondition})
               AND {$publishedTotalPredicate}
             ORDER BY t.lastname, t.firstname, b.subject"
        );
        if ($historyAvailable) {
            $stmt->bind_param('iiiiii', $schoolId, $sessionId, $termId, $schoolId, $classId, $classId);
        } else {
            $stmt->bind_param('iiiii', $schoolId, $sessionId, $termId, $schoolId, $classId);
        }
    } elseif ($historyAvailable) {
        $stmt = $conn->prepare(
            'SELECT b.subject AS subjectname, t.firstname, t.lastname, t.middlename, s.*
             FROM student_class_enrollments e
             INNER JOIN students t ON t.id = e.student_id AND t.school_id = e.school_id
             INNER JOIN skulscores s
                ON s.student_id = e.student_id
               AND s.school_id = e.school_id
               AND s.session_id = e.session_id
               AND s.term_id = e.term_id
             INNER JOIN subjects b ON b.id = s.subject_id
             INNER JOIN (
                SELECT MAX(sc.id) AS score_id
                FROM skulscores sc
                WHERE sc.school_id = ? AND sc.session_id = ? AND sc.term_id = ?
                  AND ' . $publishedTotalSubqueryPredicate . '
                GROUP BY sc.student_id, sc.subject_id
             ) latest ON latest.score_id = s.id
             WHERE e.school_id = ? AND e.class_id = ? AND e.session_id = ? AND e.term_id = ?
               AND ' . $publishedTotalPredicate . '
             ORDER BY t.lastname, t.firstname, b.subject'
        );
        $stmt->bind_param('iiiiiii', $schoolId, $sessionId, $termId, $schoolId, $classId, $sessionId, $termId);
    } else {
        $stmt = $conn->prepare(
            'SELECT b.subject AS subjectname, t.firstname, t.lastname, t.middlename, s.*
             FROM skulscores s
             INNER JOIN subjects b ON b.id = s.subject_id
             INNER JOIN students t ON t.id = s.student_id AND t.school_id = s.school_id
             WHERE s.school_id = ? AND s.session_id = ? AND s.class_id = ? AND s.term_id = ?
               AND ' . $publishedTotalPredicate . '
             ORDER BY t.lastname, t.firstname, b.subject'
        );
        $stmt->bind_param('iiii', $schoolId, $sessionId, $classId, $termId);
    }

    $stmt->execute();
    $rows = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
    $stmt->close();

    return $rows;
}
