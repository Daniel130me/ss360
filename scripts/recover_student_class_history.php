<?php

/**
 * Build term-level student class history from the current database.
 *
 * The script deliberately does not read an older database dump. Each source gets
 * one vote per student/session/term, regardless of how many rows it contains.
 * This prevents attendance or score volume from overpowering other evidence.
 *
 * Usage (dry run):
 *   php scripts/recover_student_class_history.php --database=ss360
 *
 * Persist the audit and apply only high-confidence consensus:
 *   php scripts/recover_student_class_history.php --database=ss360 --write-audit --apply-confirmed
 *
 * Optional connection environment variables:
 *   SS360_DB_HOST, SS360_DB_PORT, SS360_DB_USER, SS360_DB_PASSWORD
 */

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

$options = getopt('', ['database:', 'write-audit', 'apply-confirmed', 'apply-reviewed', 'help']);
if (isset($options['help']) || empty($options['database'])) {
    fwrite(STDOUT, "Usage: php scripts/recover_student_class_history.php --database=NAME [--write-audit] [--apply-confirmed] [--apply-reviewed]\n");
    exit(isset($options['help']) ? 0 : 1);
}

$host = getenv('SS360_DB_HOST') ?: '127.0.0.1';
$port = (int)(getenv('SS360_DB_PORT') ?: 3306);
$user = getenv('SS360_DB_USER') ?: 'root';
$password = getenv('SS360_DB_PASSWORD') ?: '';
$database = (string)$options['database'];
$applyReviewed = isset($options['apply-reviewed']);
$writeAudit = isset($options['write-audit']) || isset($options['apply-confirmed']) || $applyReviewed;
$applyConfirmed = isset($options['apply-confirmed']);

$conn = new mysqli($host, $user, $password, $database, $port);
$conn->set_charset('utf8mb4');

if ($writeAudit && !tableExists($conn, 'student_class_recovery_audit')) {
    throw new RuntimeException('Run database/student_class_history.sql before writing recovery results.');
}
if (($applyConfirmed || $applyReviewed) && !tableExists($conn, 'student_class_enrollments')) {
    throw new RuntimeException('Run database/student_class_history.sql before applying recovery results.');
}

$validClasses = loadValidClasses($conn);
$validStudents = loadValidStudents($conn);
$periods = loadEvidence($conn, $validClasses, $validStudents);
$summary = [
    'confirmed' => 0,
    'inferred' => 0,
    'conflict' => 0,
    'invalid_class_references' => 0,
    'invalid_student_references' => 0,
    'audit_rows_written' => 0,
    'enrollments_applied' => 0,
    'reviewed_enrollments_applied' => 0,
];

$auditStmt = null;
$enrollmentStmt = null;
if ($writeAudit) {
    $auditStmt = $conn->prepare(
        'INSERT INTO student_class_recovery_audit
            (school_id, student_id, session_id, term_id, proposed_class_id, confidence, evidence_json)
         VALUES (?, ?, ?, ?, ?, ?, ?)
         ON DUPLICATE KEY UPDATE
            proposed_class_id = IF(review_status = \'pending\', VALUES(proposed_class_id), proposed_class_id),
            confidence = IF(review_status = \'pending\', VALUES(confidence), confidence),
            evidence_json = IF(review_status = \'pending\', VALUES(evidence_json), evidence_json),
            dateupdated = CURRENT_TIMESTAMP'
    );
}
if ($applyConfirmed) {
    $enrollmentStmt = $conn->prepare(
        'INSERT INTO student_class_enrollments
            (school_id, student_id, session_id, term_id, class_id, confidence, source)
         VALUES (?, ?, ?, ?, ?, \'confirmed\', \'recovery_consensus\')
         ON DUPLICATE KEY UPDATE
            class_id = IF(confidence = \'manual\', class_id, VALUES(class_id)),
            confidence = IF(confidence = \'manual\', confidence, VALUES(confidence)),
            source = IF(confidence = \'manual\', source, VALUES(source)),
            dateupdated = CURRENT_TIMESTAMP'
    );
}

if ($writeAudit || $applyConfirmed) {
    $conn->begin_transaction();
}

try {
    foreach ($periods as $period) {
        $decision = $period['student_exists']
            ? decideClass($period['sources'])
            : ['class_id' => null, 'confidence' => 'conflict', 'rule' => 'student_record_missing'];
        $summary[$decision['confidence']]++;
        $summary['invalid_class_references'] += count($period['invalid_class_references']);
        $summary['invalid_student_references'] += $period['student_exists'] ? 0 : 1;

        $evidence = json_encode(
            [
                'sources' => $period['sources'],
                'invalid_class_references' => $period['invalid_class_references'],
                'student_exists' => $period['student_exists'],
                'rule' => $decision['rule'],
            ],
            JSON_THROW_ON_ERROR
        );

        if ($auditStmt) {
            $proposedClassId = $decision['class_id'];
            $confidence = $decision['confidence'];
            $schoolId = $period['school_id'];
            $studentId = $period['student_id'];
            $sessionId = $period['session_id'];
            $termId = $period['term_id'];
            $auditStmt->bind_param(
                'iiiiiss',
                $schoolId,
                $studentId,
                $sessionId,
                $termId,
                $proposedClassId,
                $confidence,
                $evidence
            );
            $auditStmt->execute();
            $summary['audit_rows_written']++;
        }

        if ($enrollmentStmt && $decision['confidence'] === 'confirmed' && $decision['class_id'] !== null) {
            $schoolId = $period['school_id'];
            $studentId = $period['student_id'];
            $sessionId = $period['session_id'];
            $termId = $period['term_id'];
            $classId = $decision['class_id'];
            $enrollmentStmt->bind_param(
                'iiiii',
                $schoolId,
                $studentId,
                $sessionId,
                $termId,
                $classId
            );
            $enrollmentStmt->execute();
            $summary['enrollments_applied']++;
        }
    }

    if ($applyReviewed) {
        $reviewedCount = $conn->query(
            "SELECT COUNT(*) AS total
             FROM student_class_recovery_audit a
             INNER JOIN students s ON s.id = a.student_id AND s.school_id = a.school_id
             INNER JOIN class c ON c.id = a.proposed_class_id AND c.school_id = a.school_id
             WHERE a.review_status = 'accepted' AND a.proposed_class_id IS NOT NULL"
        )->fetch_assoc();
        $summary['reviewed_enrollments_applied'] = (int)($reviewedCount['total'] ?? 0);

        $conn->query(
            "INSERT INTO student_class_enrollments
                (school_id, student_id, session_id, term_id, class_id, confidence, source, updatedby)
             SELECT a.school_id, a.student_id, a.session_id, a.term_id, a.proposed_class_id,
                    'manual', 'recovery_review', a.reviewedby
             FROM student_class_recovery_audit a
             INNER JOIN students s ON s.id = a.student_id AND s.school_id = a.school_id
             INNER JOIN class c ON c.id = a.proposed_class_id AND c.school_id = a.school_id
             WHERE a.review_status = 'accepted' AND a.proposed_class_id IS NOT NULL
             ON DUPLICATE KEY UPDATE
                class_id = VALUES(class_id),
                confidence = 'manual',
                source = 'recovery_review',
                updatedby = VALUES(updatedby),
                dateupdated = CURRENT_TIMESTAMP"
        );
    }

    if ($writeAudit || $applyConfirmed) {
        $conn->commit();
    }
} catch (Throwable $exception) {
    if ($writeAudit || $applyConfirmed) {
        $conn->rollback();
    }
    throw $exception;
} finally {
    if ($auditStmt) {
        $auditStmt->close();
    }
    if ($enrollmentStmt) {
        $enrollmentStmt->close();
    }
    $conn->close();
}

fwrite(STDOUT, json_encode($summary, JSON_PRETTY_PRINT | JSON_THROW_ON_ERROR) . PHP_EOL);

function tableExists(mysqli $conn, string $table): bool
{
    $stmt = $conn->prepare(
        'SELECT 1 FROM information_schema.tables
         WHERE table_schema = DATABASE() AND table_name = ? LIMIT 1'
    );
    $stmt->bind_param('s', $table);
    $stmt->execute();
    $exists = $stmt->get_result()->num_rows === 1;
    $stmt->close();

    return $exists;
}

/** @return array<int, array<int, bool>> */
function loadValidClasses(mysqli $conn): array
{
    $classes = [];
    $result = $conn->query('SELECT id, school_id FROM class');
    while ($row = $result->fetch_assoc()) {
        $classes[(int)$row['school_id']][(int)$row['id']] = true;
    }

    return $classes;
}

/** @return array<int, array<int, bool>> */
function loadValidStudents(mysqli $conn): array
{
    $students = [];
    $result = $conn->query('SELECT id, school_id FROM students');
    while ($row = $result->fetch_assoc()) {
        $students[(int)$row['school_id']][(int)$row['id']] = true;
    }

    return $students;
}

/**
 * @param array<int, array<int, bool>> $validClasses
 * @param array<int, array<int, bool>> $validStudents
 * @return array<string, array<string, mixed>>
 */
function loadEvidence(mysqli $conn, array $validClasses, array $validStudents): array
{
    $sql = <<<'SQL'
        SELECT source_name, school_id, student_id, session_id, term_id, class_id, COUNT(*) AS row_count
        FROM (
            SELECT 'comment' AS source_name, school_id, student_id, session_id, term_id, class_id FROM comment
            UNION ALL
            SELECT 'other_comments', school_id, student_id, session_id, term_id, class_id FROM other_comments
            UNION ALL
            SELECT 'attendance', school_id, student_id, session_id, term_id, class_id FROM attendance
            UNION ALL
            SELECT 'payment_record', school_id, student_id, session_id, term_id, class_id FROM payment_record
            UNION ALL
            SELECT 'scores', school_id, student_id, session_id, term_id, class_id FROM skulscores
        ) evidence
        WHERE school_id > 0 AND student_id > 0 AND session_id > 0
          AND term_id BETWEEN 1 AND 3 AND class_id > 0
        GROUP BY source_name, school_id, student_id, session_id, term_id, class_id
        ORDER BY school_id, student_id, session_id, term_id, source_name, class_id
        SQL;

    $periods = [];
    $result = $conn->query($sql);
    while ($row = $result->fetch_assoc()) {
        $schoolId = (int)$row['school_id'];
        $studentId = (int)$row['student_id'];
        $sessionId = (int)$row['session_id'];
        $termId = (int)$row['term_id'];
        $classId = (int)$row['class_id'];
        $source = (string)$row['source_name'];
        $key = implode(':', [$schoolId, $studentId, $sessionId, $termId]);

        if (!isset($periods[$key])) {
            $periods[$key] = [
                'school_id' => $schoolId,
                'student_id' => $studentId,
                'session_id' => $sessionId,
                'term_id' => $termId,
                'sources' => [],
                'invalid_class_references' => [],
                'student_exists' => isset($validStudents[$schoolId][$studentId]),
            ];
        }

        if (!isset($validClasses[$schoolId][$classId])) {
            $periods[$key]['invalid_class_references'][] = [
                'source' => $source,
                'class_id' => $classId,
                'rows' => (int)$row['row_count'],
            ];
            continue;
        }

        $periods[$key]['sources'][$source][(string)$classId] = (int)$row['row_count'];
    }

    return $periods;
}

/**
 * Resolve a class without letting row volume become a vote.
 *
 * Non-score sources are stronger because the known corruption rewrote scores.
 * A confirmed decision therefore needs unanimous agreement from at least two
 * unambiguous non-score sources. Everything else is inferred or sent for review.
 *
 * @param array<string, array<string, int>> $sources
 * @return array{class_id:?int, confidence:string, rule:string}
 */
function decideClass(array $sources): array
{
    $nonScoreVotes = [];
    $ambiguousSources = [];

    foreach ($sources as $source => $classes) {
        if (count($classes) !== 1) {
            $ambiguousSources[] = $source;
            continue;
        }

        $classId = (int)array_key_first($classes);
        if ($source !== 'scores') {
            $nonScoreVotes[$source] = $classId;
        }
    }

    $uniqueNonScoreClasses = array_values(array_unique(array_values($nonScoreVotes)));
    if (count($uniqueNonScoreClasses) > 1) {
        return ['class_id' => null, 'confidence' => 'conflict', 'rule' => 'non_score_sources_disagree'];
    }

    if (count($nonScoreVotes) >= 2 && count($uniqueNonScoreClasses) === 1) {
        return [
            'class_id' => $uniqueNonScoreClasses[0],
            'confidence' => 'confirmed',
            'rule' => 'two_or_more_non_score_sources_agree',
        ];
    }

    if (count($nonScoreVotes) === 1) {
        return [
            'class_id' => $uniqueNonScoreClasses[0],
            'confidence' => 'inferred',
            'rule' => 'one_unambiguous_non_score_source',
        ];
    }

    if (isset($sources['scores']) && count($sources['scores']) === 1) {
        return [
            'class_id' => (int)array_key_first($sources['scores']),
            'confidence' => 'inferred',
            'rule' => 'scores_only',
        ];
    }

    return [
        'class_id' => null,
        'confidence' => 'conflict',
        'rule' => $ambiguousSources ? 'only_ambiguous_sources' : 'no_valid_class_evidence',
    ];
}
