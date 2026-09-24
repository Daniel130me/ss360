<?php

function ss360_term_name($term_id)
{
    $names = ['1' => '1st Term', '2' => '2nd Term', '3' => '3rd Term'];
    return $names[(string)$term_id] ?? 'Unknown Term';
}

function ss360_round_percent($value)
{
    return round((float)$value, 1);
}

function ss360_score_max($row)
{
    return (float)$row['ca1Total'] + (float)$row['ca2Total'] + (float)$row['ca3Total'] + (float)$row['praTotal'] + (float)$row['examTotal'];
}

function ss360_score_percent($total, $max)
{
    return $max > 0 ? ss360_round_percent(((float)$total / (float)$max) * 100) : null;
}

function ss360_parse_grading($grading)
{
    $grading = trim((string)$grading);
    if ($grading === '') {
        return [];
    }

    $decoded = json_decode($grading, true);
    if (is_array($decoded)) {
        return $decoded;
    }

    $normalized = preg_replace('/([A-Za-z0-9+_-]+)\s*:/', '"$1":', $grading);
    $decoded = json_decode($normalized, true);
    return is_array($decoded) ? $decoded : [];
}

function ss360_grade_for_percent($percentage, $grading)
{
    if ($percentage === null || empty($grading)) {
        return null;
    }

    arsort($grading, SORT_NUMERIC);
    foreach ($grading as $grade => $minimum) {
        if ((float)$percentage >= (float)$minimum) {
            return (string)$grade;
        }
    }

    $grades = array_keys($grading);
    return end($grades) ?: null;
}

function ss360_trim_list($items, $limit = 5)
{
    return array_slice(array_values($items), 0, $limit);
}

function ss360_statement_rows($stmt)
{
    $result = mysqli_stmt_get_result($stmt);
    $rows = [];
    while ($row = mysqli_fetch_assoc($result)) {
        $rows[] = $row;
    }
    mysqli_stmt_close($stmt);
    return $rows;
}

function ss360_get_student_ai_profile($conn, $school_id, $student_id, $class_id, $session_id)
{
    $sql = "SELECT s.id, s.firstname, s.lastname, s.middlename, s.class_id, c.classname, se.session
            FROM students s
            INNER JOIN class c ON c.id = ? AND c.school_id = s.school_id
            LEFT JOIN sessions se ON se.id = ?
            WHERE s.id = ? AND s.school_id = ?
            LIMIT 1";
    $stmt = mysqli_prepare($conn, $sql);
    mysqli_stmt_bind_param($stmt, 'iiii', $class_id, $session_id, $student_id, $school_id);
    mysqli_stmt_execute($stmt);
    $rows = ss360_statement_rows($stmt);
    if (empty($rows)) {
        return null;
    }

    $student = $rows[0];
    return [
        'id' => (int)$student['id'],
        'name' => trim($student['lastname'] . ' ' . $student['firstname'] . ' ' . $student['middlename']),
        'class' => $student['classname'],
        'session' => $student['session'] ?? '',
    ];
}

function ss360_get_grading_for_context($conn, $school_id, $session_id, $term_id)
{
    $lookup_term = in_array((string)$term_id, ['1', '2', '3'], true) ? (int)$term_id : 1;
    $sql = "SELECT grading FROM skul_settings WHERE school_id = ? AND session_id = ? AND term_id = ? LIMIT 1";
    $stmt = mysqli_prepare($conn, $sql);
    mysqli_stmt_bind_param($stmt, 'iii', $school_id, $session_id, $lookup_term);
    mysqli_stmt_execute($stmt);
    $rows = ss360_statement_rows($stmt);
    return ss360_parse_grading($rows[0]['grading'] ?? '');
}

function ss360_get_student_score_rows($conn, $school_id, $student_id, $class_id, $session_id)
{
    $sql = "SELECT sc.term_id, sc.subject_id, sub.subject,
                   sc.ca1, sc.ca1Total, sc.ca2, sc.ca2Total, sc.ca3, sc.ca3Total,
                   sc.pra, sc.praTotal, sc.exam, sc.examTotal, sc.total
            FROM skulscores sc
            INNER JOIN subjects sub ON sub.id = sc.subject_id
            INNER JOIN (
                SELECT MAX(id) AS score_id
                FROM skulscores
                WHERE school_id = ? AND student_id = ? AND session_id = ?
                GROUP BY term_id, subject_id
            ) latest ON latest.score_id = sc.id
            ORDER BY sub.subject ASC, sc.term_id ASC";
    $stmt = mysqli_prepare($conn, $sql);
    mysqli_stmt_bind_param($stmt, 'iii', $school_id, $student_id, $session_id);
    mysqli_stmt_execute($stmt);
    return ss360_statement_rows($stmt);
}

function ss360_get_class_score_rows($conn, $school_id, $class_id, $session_id)
{
    if (function_exists('student_class_history_available') && student_class_history_available($conn)) {
        $sql = "SELECT sc.term_id, sc.subject_id, sc.student_id,
                       sc.total, sc.ca1Total, sc.ca2Total, sc.ca3Total, sc.praTotal, sc.examTotal
                FROM skulscores sc
                INNER JOIN student_class_enrollments e
                   ON e.school_id = sc.school_id AND e.student_id = sc.student_id
                  AND e.session_id = sc.session_id AND e.term_id = sc.term_id
                INNER JOIN (
                    SELECT MAX(id) AS score_id
                    FROM skulscores
                    WHERE school_id = ? AND session_id = ?
                    GROUP BY student_id, term_id, subject_id
                ) latest ON latest.score_id = sc.id
                WHERE e.school_id = ? AND e.class_id = ? AND e.session_id = ?
                  AND sc.status = '1'
                  AND (sc.total > 0 OR sc.ca1 > 0 OR sc.ca2 > 0 OR sc.ca3 > 0 OR sc.pra > 0 OR sc.exam > 0)";
        $stmt = mysqli_prepare($conn, $sql);
        mysqli_stmt_bind_param($stmt, 'iiiii', $school_id, $session_id, $school_id, $class_id, $session_id);
    } else {
        $sql = "SELECT term_id, subject_id, student_id,
                       total, ca1Total, ca2Total, ca3Total, praTotal, examTotal
                FROM skulscores
                WHERE school_id = ? AND class_id = ? AND session_id = ? AND status = '1'
                  AND (total > 0 OR ca1 > 0 OR ca2 > 0 OR ca3 > 0 OR pra > 0 OR exam > 0)";
        $stmt = mysqli_prepare($conn, $sql);
        mysqli_stmt_bind_param($stmt, 'iii', $school_id, $class_id, $session_id);
    }
    mysqli_stmt_execute($stmt);
    return ss360_statement_rows($stmt);
}

function ss360_build_academic_summary($score_rows, $grading)
{
    $term_totals = [];
    $subjects = [];
    $data_gaps = [];

    foreach ($score_rows as $row) {
        $term_id = (string)$row['term_id'];
        $subject_id = (string)$row['subject_id'];
        $max = ss360_score_max($row);
        $total = (float)$row['total'];
        $percent = ss360_score_percent($total, $max);

        if (!isset($term_totals[$term_id])) {
            $term_totals[$term_id] = ['term' => ss360_term_name($term_id), 'total' => 0, 'max' => 0];
        }
        $term_totals[$term_id]['total'] += $total;
        $term_totals[$term_id]['max'] += $max;

        if (!isset($subjects[$subject_id])) {
            $subjects[$subject_id] = [
                'subject_id' => (int)$row['subject_id'],
                'subject' => $row['subject'],
                'terms' => [],
            ];
        }

        $ca_total = (float)$row['ca1'] + (float)$row['ca2'] + (float)$row['ca3'] + (float)$row['pra'];
        $ca_max = (float)$row['ca1Total'] + (float)$row['ca2Total'] + (float)$row['ca3Total'] + (float)$row['praTotal'];
        $exam_percent = ss360_score_percent($row['exam'], $row['examTotal']);
        $ca_percent = ss360_score_percent($ca_total, $ca_max);

        $subjects[$subject_id]['terms'][$term_id] = [
            'term_id' => (int)$term_id,
            'term' => ss360_term_name($term_id),
            'total' => $total,
            'max' => $max,
            'percentage' => $percent,
            'grade' => ss360_grade_for_percent($percent, $grading),
            'ca_percentage' => $ca_percent,
            'exam_percentage' => $exam_percent,
        ];

        if ($max <= 0 || $percent === null) {
            $data_gaps[] = $row['subject'] . ' has no obtainable score for ' . ss360_term_name($term_id) . '.';
        }
    }

    $term_trends = [];
    $session_total = 0;
    $session_max = 0;
    foreach ($term_totals as $term_id => $term) {
        $percentage = ss360_score_percent($term['total'], $term['max']);
        $term_trends[] = [
            'term_id' => (int)$term_id,
            'term' => $term['term'],
            'total' => ss360_round_percent($term['total']),
            'max' => ss360_round_percent($term['max']),
            'percentage' => $percentage,
            'grade' => ss360_grade_for_percent($percentage, $grading),
        ];
        $session_total += $term['total'];
        $session_max += $term['max'];
    }

    usort($term_trends, function ($a, $b) {
        return $a['term_id'] <=> $b['term_id'];
    });

    $subject_trends = [];
    foreach ($subjects as $subject) {
        ksort($subject['terms']);
        $terms = array_values($subject['terms']);
        $percentages = array_values(array_filter(array_column($terms, 'percentage'), function ($value) {
            return $value !== null;
        }));
        $average = count($percentages) ? ss360_round_percent(array_sum($percentages) / count($percentages)) : null;
        $first = count($percentages) ? reset($percentages) : null;
        $last = count($percentages) ? end($percentages) : null;
        $change = ($first !== null && $last !== null && count($percentages) > 1) ? ss360_round_percent($last - $first) : null;

        $ca_exam_notes = [];
        foreach ($terms as $term) {
            if ($term['ca_percentage'] !== null && $term['exam_percentage'] !== null) {
                $gap = ss360_round_percent($term['exam_percentage'] - $term['ca_percentage']);
                if (abs($gap) >= 15) {
                    $ca_exam_notes[] = $term['term'] . ': exam is ' . abs($gap) . '% ' . ($gap > 0 ? 'higher' : 'lower') . ' than CA/practical average';
                }
            }
        }

        $subject_trends[] = [
            'subject_id' => $subject['subject_id'],
            'subject' => $subject['subject'],
            'average_percentage' => $average,
            'change_from_first_to_last' => $change,
            'terms' => $terms,
            'ca_exam_notes' => ss360_trim_list($ca_exam_notes, 3),
        ];
    }

    $strengths = $subject_trends;
    usort($strengths, function ($a, $b) {
        return ($b['average_percentage'] ?? -1) <=> ($a['average_percentage'] ?? -1);
    });

    $weaknesses = $subject_trends;
    usort($weaknesses, function ($a, $b) {
        return ($a['average_percentage'] ?? 101) <=> ($b['average_percentage'] ?? 101);
    });

    $improvements = array_filter($subject_trends, function ($item) {
        return $item['change_from_first_to_last'] !== null && $item['change_from_first_to_last'] > 0;
    });
    usort($improvements, function ($a, $b) {
        return $b['change_from_first_to_last'] <=> $a['change_from_first_to_last'];
    });

    $declines = array_filter($subject_trends, function ($item) {
        return $item['change_from_first_to_last'] !== null && $item['change_from_first_to_last'] < 0;
    });
    usort($declines, function ($a, $b) {
        return $a['change_from_first_to_last'] <=> $b['change_from_first_to_last'];
    });

    return [
        'academic_summary' => [
            'session_total' => ss360_round_percent($session_total),
            'session_max' => ss360_round_percent($session_max),
            'session_percentage' => ss360_score_percent($session_total, $session_max),
            'subject_count' => count($subject_trends),
        ],
        'term_trends' => $term_trends,
        'subject_trends' => ss360_trim_list($subject_trends, 25),
        'strengths' => ss360_trim_list($strengths, 5),
        'weaknesses' => ss360_trim_list($weaknesses, 5),
        'improvements' => ss360_trim_list($improvements, 5),
        'declines' => ss360_trim_list($declines, 5),
        'data_gaps' => ss360_trim_list($data_gaps, 10),
    ];
}

function ss360_build_class_comparison($student_subject_trends, $class_rows, $student_id)
{
    $class_buckets = [];
    foreach ($class_rows as $row) {
        $max = (float)$row['ca1Total'] + (float)$row['ca2Total'] + (float)$row['ca3Total'] + (float)$row['praTotal'] + (float)$row['examTotal'];
        $percent = ss360_score_percent($row['total'], $max);
        if ($percent === null) {
            continue;
        }
        $key = $row['term_id'] . ':' . $row['subject_id'];
        if (!isset($class_buckets[$key])) {
            $class_buckets[$key] = [];
        }
        $class_buckets[$key][(string)$row['student_id']] = $percent;
    }

    $comparison = [];
    foreach ($student_subject_trends as $subject) {
        foreach ($subject['terms'] as $term) {
            if ($term['percentage'] === null) {
                continue;
            }
            $term_id = (string)$term['term_id'];
            $bucket_key = $term_id . ':' . $subject['subject_id'];
            if (empty($class_buckets[$bucket_key])) {
                continue;
            }

            $scores = $class_buckets[$bucket_key];
            arsort($scores, SORT_NUMERIC);
            $position = 1;
            foreach (array_keys($scores) as $rank_student_id) {
                if ((string)$rank_student_id === (string)$student_id) {
                    break;
                }
                $position++;
            }

            $comparison[] = [
                'subject' => $subject['subject'],
                'term' => $term['term'],
                'student_percentage' => $term['percentage'],
                'class_average' => ss360_round_percent(array_sum($scores) / count($scores)),
                'position' => isset($scores[(string)$student_id]) ? $position : null,
                'class_size' => count($scores),
            ];
        }
    }

    usort($comparison, function ($a, $b) {
        return abs(($b['student_percentage'] ?? 0) - ($b['class_average'] ?? 0)) <=> abs(($a['student_percentage'] ?? 0) - ($a['class_average'] ?? 0));
    });

    return ss360_trim_list($comparison, 12);
}

function ss360_get_assessment_summary($conn, $school_id, $student_id, $class_id)
{
    $sql = "SELECT ar.score, ar.total_questions, ar.percentage_score, ar.submitted_at,
                   a.id AS assessment_id, a.class_ids, sub.subject
            FROM assessment_results ar
            INNER JOIN assessment a ON a.id = ar.assessment_id
            INNER JOIN subjects sub ON sub.id = a.subject_id
            WHERE ar.student_id = ? AND a.school_id = ?
            ORDER BY ar.submitted_at DESC
            LIMIT 20";
    $stmt = mysqli_prepare($conn, $sql);
    if (!$stmt) {
        return ['attempted_count' => 0, 'average_percentage' => null, 'recent_results' => [], 'strong_subjects' => [], 'weak_subjects' => []];
    }
    mysqli_stmt_bind_param($stmt, 'ii', $student_id, $school_id);
    mysqli_stmt_execute($stmt);
    $rows = ss360_statement_rows($stmt);

    $filtered = [];
    foreach ($rows as $row) {
        $class_ids = array_filter(array_map('trim', explode(',', (string)$row['class_ids'])));
        if (empty($class_ids) || in_array((string)$class_id, $class_ids, true)) {
            $filtered[] = $row;
        }
    }

    $subject_scores = [];
    $recent = [];
    foreach ($filtered as $row) {
        $percentage = ss360_round_percent($row['percentage_score']);
        $recent[] = [
            'subject' => $row['subject'],
            'score' => (float)$row['score'],
            'total_questions' => (int)$row['total_questions'],
            'percentage' => $percentage,
            'submitted_at' => $row['submitted_at'],
        ];

        if (!isset($subject_scores[$row['subject']])) {
            $subject_scores[$row['subject']] = [];
        }
        $subject_scores[$row['subject']][] = $percentage;
    }

    $subject_averages = [];
    foreach ($subject_scores as $subject => $scores) {
        $subject_averages[] = [
            'subject' => $subject,
            'average_percentage' => ss360_round_percent(array_sum($scores) / count($scores)),
            'attempts' => count($scores),
        ];
    }

    $strong = $subject_averages;
    usort($strong, function ($a, $b) {
        return $b['average_percentage'] <=> $a['average_percentage'];
    });
    $weak = $subject_averages;
    usort($weak, function ($a, $b) {
        return $a['average_percentage'] <=> $b['average_percentage'];
    });

    $all_percentages = array_column($recent, 'percentage');
    return [
        'attempted_count' => count($recent),
        'average_percentage' => count($all_percentages) ? ss360_round_percent(array_sum($all_percentages) / count($all_percentages)) : null,
        'recent_results' => ss360_trim_list($recent, 8),
        'strong_subjects' => ss360_trim_list($strong, 5),
        'weak_subjects' => ss360_trim_list($weak, 5),
    ];
}

function ss360_filter_context_for_question($context, $message)
{
    $message = strtolower((string)$message);
    $subjects = $context['subject_trends'] ?? [];
    $matched_subjects = [];

    foreach ($subjects as $subject) {
        if ($subject['subject'] && strpos($message, strtolower($subject['subject'])) !== false) {
            $matched_subjects[] = $subject;
        }
    }

    if (!empty($matched_subjects)) {
        $context['subject_trends'] = ss360_trim_list($matched_subjects, 8);
    }

    $encoded = json_encode($context);
    $max_bytes = 18000;
    if (strlen($encoded) <= $max_bytes) {
        return $context;
    }

    $context['class_comparison'] = ss360_trim_list($context['class_comparison'] ?? [], 6);
    $context['subject_trends'] = ss360_trim_list($context['subject_trends'] ?? [], 12);
    $context['assessment_summary']['recent_results'] = ss360_trim_list($context['assessment_summary']['recent_results'] ?? [], 5);

    return $context;
}

function ss360_build_student_ai_context_base($conn, $school_id, $student_id, $class_id, $session_id, $term_id)
{
    $profile = ss360_get_student_ai_profile($conn, $school_id, $student_id, $class_id, $session_id);
    if (!$profile) {
        return ['status' => 'error', 'message' => 'Student record was not found for this school and class.'];
    }

    $grading = ss360_get_grading_for_context($conn, $school_id, $session_id, $term_id);
    $score_rows = ss360_get_student_score_rows($conn, $school_id, $student_id, $class_id, $session_id);
    $academic = ss360_build_academic_summary($score_rows, $grading);
    $class_rows = ss360_get_class_score_rows($conn, $school_id, $class_id, $session_id);
    $comparison = ss360_build_class_comparison($academic['subject_trends'], $class_rows, $student_id);
    $assessment_summary = ss360_get_assessment_summary($conn, $school_id, $student_id, $class_id);

    $context = [
        'student' => $profile,
        'selected_filter' => [
            'session_id' => (int)$session_id,
            'term_id' => $term_id,
            'term' => in_array((string)$term_id, ['1', '2', '3'], true) ? ss360_term_name($term_id) : 'Summary',
        ],
        'academic_summary' => $academic['academic_summary'],
        'term_trends' => $academic['term_trends'],
        'subject_trends' => $academic['subject_trends'],
        'strengths' => $academic['strengths'],
        'weaknesses' => $academic['weaknesses'],
        'improvements' => $academic['improvements'],
        'declines' => $academic['declines'],
        'class_comparison' => $comparison,
        'assessment_summary' => $assessment_summary,
        'data_gaps' => $academic['data_gaps'],
        'excluded_context' => 'Attendance, staff comments, behaviour, psychomotor skills, parent/contact data, and answer-level assessment data are intentionally excluded.',
    ];

    return [
        'status' => 'success',
        'context' => $context,
    ];
}

function ss360_build_student_ai_context($conn, $school_id, $student_id, $class_id, $session_id, $term_id, $message = '')
{
    $context_result = ss360_build_student_ai_context_base($conn, $school_id, $student_id, $class_id, $session_id, $term_id);
    if ($context_result['status'] !== 'success') {
        return $context_result;
    }

    return [
        'status' => 'success',
        'context' => ss360_filter_context_for_question($context_result['context'], $message),
    ];
}
