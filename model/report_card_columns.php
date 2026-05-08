<?php
function get_report_score_column_registry()
{
    return [
        'subject' => [
            'label' => 'Subject',
            'group' => 'identity',
            'required' => true,
            'source' => 'subject',
        ],
        'ca1' => [
            'label' => 'CA1',
            'group' => 'assessment',
            'score_field' => 'CA1',
            'max_field' => 'ca1Total',
            'legacy_assessment' => 'ca1',
        ],
        'ca2' => [
            'label' => 'CA2',
            'group' => 'assessment',
            'score_field' => 'CA2',
            'max_field' => 'ca2Total',
            'legacy_assessment' => 'ca2',
        ],
        'ca3' => [
            'label' => 'CA3',
            'group' => 'assessment',
            'score_field' => 'CA3',
            'max_field' => 'ca3Total',
            'legacy_assessment' => 'ca3',
        ],
        'practical' => [
            'label' => 'Practical',
            'group' => 'assessment',
            'score_field' => 'Practical',
            'max_field' => 'praTotal',
            'legacy_assessment' => 'practical',
        ],
        'exam' => [
            'label' => 'Exam',
            'group' => 'assessment',
            'score_field' => 'Exam',
            'max_field' => 'exaTotal',
            'legacy_assessment' => 'exam',
        ],
        'total' => [
            'label' => 'Total',
            'group' => 'summary',
            'resolver' => 'current_term_total',
        ],
        'percentage' => [
            'label' => 'Total(%)',
            'group' => 'summary',
            'resolver' => 'percentage',
        ],
        'grade' => [
            'label' => 'Grade',
            'group' => 'summary',
            'resolver' => 'grade',
        ],
        'first_term_total' => [
            'label' => '1st Term Total',
            'group' => 'cumulative',
            'resolver' => 'first_term_total',
        ],
        'second_term_total' => [
            'label' => '2nd Term Total',
            'group' => 'cumulative',
            'resolver' => 'second_term_total',
        ],
        'third_term_total' => [
            'label' => '3rd Term Total',
            'group' => 'cumulative',
            'resolver' => 'third_term_total',
        ],
        'grand_total' => [
            'label' => 'Grand Total',
            'group' => 'cumulative',
            'resolver' => 'grand_total',
        ],
        'average' => [
            'label' => 'Average',
            'group' => 'cumulative',
            'resolver' => 'average',
        ],
        'class_average' => [
            'label' => 'Class Average',
            'group' => 'comparison',
            'resolver' => 'class_average',
        ],
        'position' => [
            'label' => 'Position',
            'group' => 'comparison',
            'resolver' => 'position',
        ],
    ];
}

function get_report_score_column_keys()
{
    return array_keys(get_report_score_column_registry());
}

function get_report_score_column_labels()
{
    $labels = [];
    foreach (get_report_score_column_registry() as $key => $column) {
        $labels[$key] = $column['label'];
    }
    return $labels;
}

function get_default_report_score_columns()
{
    return [
        'subject',
        'ca1',
        'ca2',
        'ca3',
        'practical',
        'exam',
        'total',
        'percentage',
        'grade',
    ];
}

function get_cumulative_report_score_columns()
{
    return [
        'first_term_total',
        'second_term_total',
        'third_term_total',
        'grand_total',
        'average',
        'class_average',
        'position',
    ];
}

function normalize_report_score_columns($columns)
{
    $allowed_columns = get_report_score_column_keys();
    $normalized_columns = [];

    if (is_array($columns)) {
        foreach ($columns as $column) {
            $column = trim((string)$column);
            if (in_array($column, $allowed_columns, true) && !in_array($column, $normalized_columns, true)) {
                $normalized_columns[] = $column;
            }
        }
    }

    if (empty($normalized_columns)) {
        return get_default_report_score_columns();
    }

    $normalized_columns = array_values(array_filter($normalized_columns, function ($column) {
        return $column !== 'subject';
    }));
    array_unshift($normalized_columns, 'subject');

    return $normalized_columns;
}

function map_legacy_assessment_to_report_column($assessment_type)
{
    $assessment_type = strtolower(trim((string)$assessment_type));
    foreach (get_report_score_column_registry() as $key => $column) {
        if (($column['legacy_assessment'] ?? '') === $assessment_type) {
            return $key;
        }
    }
    return '';
}
