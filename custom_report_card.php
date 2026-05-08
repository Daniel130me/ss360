<?php
session_start();
include_once("model/connect.php");
include_once("model/functions.php");
include_once("model/report_card_renderer.php");
$school_id = $_SESSION['school_id'];
$student_id = $_POST['student_id'];
$class_id = $_POST['class_id'];
$session_id = $_POST['session_id'];
$term_id = $_POST['term_id'];
$report_id = $_POST['report_id'];
$sessionOrTerm = $_POST['sessionOrTerm'];

$report_context = build_report_card_context([
    'school_id' => $school_id,
    'student_id' => $student_id,
    'class_id' => $class_id,
    'session_id' => $session_id,
    'term_id' => $term_id,
    'session_or_term' => $sessionOrTerm,
    'report_id' => $report_id,
]);

$hidden_skills = $report_context['hidden_skills'];
$school_row = $report_context['school_row'];
$biorow = $report_context['student_row'];
$report_settings = $report_context['legacy_report'];
$report_name = $report_settings['report_name'] ?? 'Report Card';
$assessment_types = $report_settings['assessment_type'] ?? [];
$exact_term_id = $report_context['exact_term_id'];
$setrow = $report_context['settings_row'];
$grading_system = $report_context['grading_system'];
$template = get_report_card_template_config($report_context);
$template_columns = get_report_card_template_score_columns($template);

// Note: Calculations for Total, Percentage, and Grade will be handled by JavaScript in skul.js
// based on the assessment_types selected for this custom report.

$term_Note = strtoupper(get_term_name($term_id));
$next_term = $report_context['next_term'];
$department = $report_context['department'];
?>
<style>
    .report-card {
        min-width: 800px;
        margin: 0 auto 20px auto;
        transform-origin: top left;
        padding: 10px;
        background-color: #ffffff;
        position: relative;
        z-index: 1;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    .watermark {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        opacity: 0.04;
        z-index: 0;
        pointer-events: none;
        width: 400px;
        height: 400px;
        background-image: url('../uploads/<?= $school_row['logo'] ?>');
        background-repeat: no-repeat;
        background-position: center;
        background-size: contain;
    }

    @media print {
        #preview-content {
            overflow: visible;
            background-color: transparent;
            padding: 0;
        }

        .report-card {
            width: 100%;
            box-shadow: none;
            margin: 0;
            page-break-after: always;
        }

        .report-card:last-child {
            page-break-after: avoid;
        }

        .watermark {
            opacity: 0.04 !important;
            position: absolute;
        }
    }

    td {
        color: black;
    }

    header {
        text-align: center;
        border-bottom: 2px solid #000000;
        padding-bottom: 10px;
        margin-bottom: 10px;
    }

    .student-info,
    .remarks {
        margin-bottom: 25px;
    }

    .student-info p,
    .remarks p {
        font-size: 16px;
        margin: 5px 0;
    }

    .grades table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 10px;
    }

    .grades th,
    .grades td,
    .report_card_table th,
    .report_card_table td {
        text-align: left;
        padding: 2px;
        font-size: 16px;
        border: 1px solid lightgrey;
    }

    table.behaviour_report_table td:nth-child(2) {
        text-align: center;
        width: 65px;
    }
</style>

<div class="report-card" data-report-id="<?= $report_id ?>" data-assessments='<?= json_encode($assessment_types) ?>' data-template-columns='<?= htmlspecialchars(json_encode($template_columns), ENT_QUOTES, 'UTF-8') ?>'>
    <?php if (report_card_template_field_enabled($template, 'school_logo')): ?>
        <div class="watermark"></div>
    <?php endif; ?>
    <?php if (report_card_template_section_enabled($template, 'school_header')): ?>
    <table style="width: 100%; margin-bottom: 20px;">
        <tr style="vertical-align: top;">
            <?php if (report_card_template_field_enabled($template, 'school_logo')): ?>
                <td style="width: auto;">
                    <div class="header-image mr-2">
                        <img width="100" height="100" src="../uploads/<?= $school_row['logo'] ?>" alt="School Logo" class="logo">
                    </div>
                </td>
            <?php endif; ?>
            <td style="vertical-align: top; width: 100%;">
                <div>
                    <?php if (report_card_template_field_enabled($template, 'school_name')): ?>
                        <p class="font-weight-bold" style="font-size: 25px; line-height: normal;">
                            <?= $school_row['school_name'] ?>
                        </p>
                    <?php endif; ?>
                    <?php if (report_card_template_field_enabled($template, 'school_address')): ?>
                        <p style="max-width: 100%;">Address: <?= $school_row['address'] ?></p>
                    <?php endif; ?>
                    <?php if (report_card_template_field_enabled($template, 'school_phone')): ?>
                        <p class="">Tel: <?= $school_row['phone1'] . ', ' . $school_row['phone2'] ?></p>
                    <?php endif; ?>
                    <?php if (report_card_template_field_enabled($template, 'school_email')): ?>
                        <p class="">Email: <?= $school_row['email'] ?></p>
                    <?php endif; ?>
                </div>
            </td>
            <?php if (report_card_template_field_enabled($template, 'student_photo') && isset($biorow['photo']) && $biorow['photo'] != 'avatar.png'): ?>
                <td style="width: 110px; text-align: right;">
                    <div class="header-image ml-2">
                        <img width="100" height="100" src="../uploads/<?= $biorow['photo'] ?>" alt="Student photo" class="logo">
                    </div>
                </td>
            <?php endif; ?>
        </tr>
        <tr>
            <td colspan="3">
                <h2 class="font-weight-bold text-center my-3" style="font-size:1.3rem;">
                    <?= strtoupper($report_name) ?> - <?= $term_Note ?>  <?= $_SESSION['session_name'] ?>
                </h2>
            </td>
        </tr>
    </table>
    <?php endif; ?>

    <?php if (report_card_template_section_enabled($template, 'student_details') || report_card_template_section_enabled($template, 'performance_summary')): ?>
    <section class="grades d-flex" style="column-gap: 10px; justify-content: space-between; align-items: flex-start;">
        <?php if (report_card_template_section_enabled($template, 'student_details')): ?>
        <table style="width:68%" class="report_card_table">
            <?php if (report_card_template_field_enabled($template, 'student_name') || report_card_template_field_enabled($template, 'admission_no')): ?>
                <tr>
                    <?php if (report_card_template_field_enabled($template, 'student_name')): ?>
                        <td class="student-name-header" data-student-name="<?= trim($biorow['lastname'] . ' ' . $biorow['firstname'] . ' ' . $biorow['middlename']) ?>">
                            NAME: <?= $biorow['lastname'] . ' ' . $biorow['firstname'] . ' ' . $biorow['middlename'] ?></td>
                    <?php endif; ?>
                    <?php if (report_card_template_field_enabled($template, 'admission_no')): ?>
                        <td>ADM. NO: <?= strtoupper($biorow['admission_no']) ?></td>
                    <?php endif; ?>
                </tr>
            <?php endif; ?>
            <?php if (report_card_template_field_enabled($template, 'class') || report_card_template_field_enabled($template, 'no_in_class')): ?>
                <tr>
                    <?php if (report_card_template_field_enabled($template, 'class')): ?>
                        <td>CLASS: <?= get_class_by_classid($biorow['class_id']) . $department ?></td>
                    <?php endif; ?>
                    <?php if (report_card_template_field_enabled($template, 'no_in_class')): ?>
                        <td>NO IN CLASS: <?= get_total_student_in_class($biorow['class_id']) ?></td>
                    <?php endif; ?>
                </tr>
            <?php endif; ?>
            <?php if (report_card_template_field_enabled($template, 'school_open') || report_card_template_field_enabled($template, 'next_term_begins')): ?>
                <tr>
                    <?php if (report_card_template_field_enabled($template, 'school_open')): ?>
                        <td>NO OF TIMES SCHOOL OPENED: <?= $setrow['school_open'] ?></td>
                    <?php endif; ?>
                    <?php if (report_card_template_field_enabled($template, 'next_term_begins')): ?>
                        <td>NEXT TERM BEGINS: <?= $next_term ?></td>
                    <?php endif; ?>
                </tr>
            <?php endif; ?>
            <?php if (report_card_template_field_enabled($template, 'times_present') || report_card_template_field_enabled($template, 'times_absent')): ?>
                <tr>
                    <?php if (report_card_template_field_enabled($template, 'times_present')): ?>
                        <td>NO OF TIMES PRESENT: <?= get_attendance_present($student_id, $exact_term_id, $session_id) ?></td>
                    <?php endif; ?>
                    <?php if (report_card_template_field_enabled($template, 'times_absent')): ?>
                        <td>NO OF TIMES ABSENT: <?= get_attendance_absent($student_id, $exact_term_id, $session_id) ?></td>
                    <?php endif; ?>
                </tr>
            <?php endif; ?>
        </table>
        <?php endif; ?>
        <?php if (report_card_template_section_enabled($template, 'performance_summary')): ?>
        <table style="width:30%" class="report_card_table performance-summary-table">
            <thead>
                <tr class="">
                    <th colspan="2" style="background-color: lightgrey;">Performance Summary</th>
                </tr>
            </thead>
            <tr>
                <td>TOTAL SCORE: <strong class="custom-total-score">0</strong></td>
                <td>TOTAL OBTAINABLE: <strong class="custom-total-obtainable">0</strong></td>
            </tr>
            <tr>
                <td>PERCENTAGE: <strong class="custom-percentage">0%</strong></td>
                <td>GRADE: <strong class="custom-grade">N/A</strong></td>
            </tr>
        </table>
        <?php endif; ?>
    </section>
    <?php endif; ?>

    <section class="grades <?= report_card_template_section_enabled($template, 'score_table') ? '' : 'd-none' ?>">
        <div class="table_visuals_display_report_custom"></div>
    </section>

    <?php if (report_card_template_section_enabled($template, 'grade_scale') || report_card_template_section_enabled($template, 'skill_rating_indices')): ?>
    <section>
        <div style="width: 100%;">
            <div class="grades mb-4 d-flex mt-4" style="column-gap: 10px; align-items: flex-start;">
                <?php if (report_card_template_section_enabled($template, 'grade_scale')): ?>
                <table style="width:auto;" class="report_card_table mb-3">
                    <thead>
                        <tr>
                            <th colspan="7" style="text-align: center; background-color: lightgrey;">Grade Scale</th>
                        </tr>
                    </thead>
                    <tr style="text-align: center;">
                        <td style="font-size: 15px;"><strong>Score Range</strong></td>
                        <?php foreach ($grading_system as $grade => $min_score): ?>
                            <td style="font-size:15px;"><?= $min_score ?>+</td>
                        <?php endforeach; ?>
                    </tr>
                    <tr style="text-align: center;">
                        <td style="font-size: 15px;"><strong>Grade</strong></td>
                        <?php foreach ($grading_system as $grade => $min_score): ?>
                            <td style="font-size: 15px;"><?= $grade ?></td>
                        <?php endforeach; ?>
                    </tr>
                </table>
                <?php endif; ?>
            </div>
        </div>
    </section>
    <?php endif; ?>

    <?php if (report_card_template_section_enabled($template, 'signature_stamp')): ?>
    <section class="remarks" style="margin-top: 30px;">
        <p><strong>SIGNATURE &amp; STAMP:</strong> <span><img
                    style="width: auto; height: 45px; display: inline-block;"
                    src="../uploads/<?= ($school_row['stamp_pic'] ?? '') == '' ? 'logo-placeholder.jpg' : $school_row['stamp_pic'] ?>"
                    alt="Stamp Picture"></span></p>
    </section>
    <?php endif; ?>
</div>
