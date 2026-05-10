<?php
require_once __DIR__ . '/functions.php';

function get_report_card_hidden_skills()
{
    return json_decode($_SESSION['hidden_row'] ?? '[]', true) ?: [];
}

function parse_report_card_grading_system($grading_json)
{
    $grading_system = json_decode($grading_json ?? '', true);
    if (!is_array($grading_system)) {
        return [];
    }

    arsort($grading_system);
    return $grading_system;
}

function get_report_card_term_context($term_id, $session_or_term, $settings_row)
{
    $term_id = (string)$term_id;
    $exact_term_id = $term_id === 'cum' ? '3' : $term_id;
    $next_term = '';

    if ($session_or_term === 'session' || $term_id === '3' || $term_id === 'cum') {
        $term_note = 'THIRD';
        $next_term = $settings_row['first'] ?? '';
    } elseif ($term_id === '2') {
        $term_note = 'SECOND';
        $next_term = $settings_row['third'] ?? '';
    } else {
        $term_note = 'FIRST';
        $next_term = $settings_row['second'] ?? '';
    }

    return [
        'exact_term_id' => $exact_term_id,
        'term_note' => $term_note,
        'next_term' => $next_term,
    ];
}

function get_report_card_student_department_label($student_row)
{
    return !empty($student_row['department']) ? '[' . $student_row['department'] . ']' : '';
}

function get_report_card_legacy_settings($report_id, $school_id)
{
    global $conn;

    if ($report_id === null || $report_id === '') {
        return [];
    }

    $report_id = (int)$report_id;
    $school_id = (int)$school_id;
    $select_report = mysqli_query($conn, "SELECT * FROM report_settings WHERE id='$report_id' AND school_id='$school_id'");

    if ($select_report && $row = mysqli_fetch_assoc($select_report)) {
        $row['assessment_type'] = json_decode($row['assessment_type'] ?? '[]', true) ?: [];
        $row['template_json'] = legacy_report_settings_to_template($row);
        return $row;
    }

    return [];
}

function get_report_card_template_config($report_context)
{
    $template = $report_context['active_template']['template_json'] ?? [];
    return normalize_report_template_config($template);
}

function report_card_template_section_enabled($template, $section_key)
{
    foreach (($template['sections'] ?? []) as $section) {
        if (($section['key'] ?? '') === $section_key) {
            return !isset($section['enabled']) || (bool)$section['enabled'];
        }
    }

    return true;
}

function report_card_template_field_enabled($template, $field_key)
{
    return !isset($template['fields'][$field_key]) || (bool)$template['fields'][$field_key];
}

function build_report_card_context($params)
{
    global $conn;

    $school_id = (int)$params['school_id'];
    $student_id = (int)$params['student_id'];
    $class_id = (int)$params['class_id'];
    $session_id = (int)$params['session_id'];
    $term_id = (string)$params['term_id'];
    $session_or_term = $params['session_or_term'] ?? 'term';
    $report_id = $params['report_id'] ?? null;

    $exact_term_id = $term_id === 'cum' ? '3' : $term_id;

    $select_school = mysqli_query($conn, "SELECT session_id,term_id, school_name, address, city, state, country, logo,phone2,phone1,email,stamp_pic FROM school WHERE id='$school_id'");
    $school_row = mysqli_fetch_array($select_school);

    $select_biodata = mysqli_query($conn, "SELECT * FROM students WHERE id='$student_id' AND school_id='$school_id'");
    $student_row = mysqli_fetch_array($select_biodata);

    $select_settings = mysqli_query($conn, "SELECT first,second,third, ca1, ca2, ca3, practical, exam, grading,school_open FROM skul_settings WHERE session_id='$session_id' and term_id='$exact_term_id' and school_id='$school_id'");
    $settings_row = mysqli_fetch_array($select_settings);

    $term_context = get_report_card_term_context($term_id, $session_or_term, $settings_row ?: []);
    $legacy_report = get_report_card_legacy_settings($report_id, $school_id);
    $template_context = get_report_template_by_context($school_id, $session_id, $term_id === 'cum' ? 'cumulative' : $term_id);

    return [
        'school_id' => $school_id,
        'student_id' => $student_id,
        'class_id' => $class_id,
        'session_id' => $session_id,
        'term_id' => $term_id,
        'session_or_term' => $session_or_term,
        'report_id' => $report_id,
        'hidden_skills' => get_report_card_hidden_skills(),
        'school_row' => $school_row ?: [],
        'student_row' => $student_row ?: [],
        'settings_row' => $settings_row ?: [],
        'legacy_report' => $legacy_report,
        'active_template' => $template_context,
        'grading_system' => parse_report_card_grading_system($settings_row['grading'] ?? ''),
        'exact_term_id' => $term_context['exact_term_id'],
        'term_note' => $term_context['term_note'],
        'next_term' => $term_context['next_term'],
        'department' => get_report_card_student_department_label($student_row ?: []),
    ];
}
