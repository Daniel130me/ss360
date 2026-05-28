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
$sessionOrTerm = $_POST['sessionOrTerm'];
$class_id = resolve_student_report_class_id($student_id, $session_id, $term_id, $class_id, $school_id);
// $hidden_skill=$_SESSION['hidden_row'];
// print_r($_SESSION['hidden_row']);
// print_r($hidden_skill);
// echo $_SESSION['session_name'];
// exit;
// $select_hidden = mysqli_query($conn, "SELECT hidden_skills FROM school WHERE id='{$_SESSION['school_id']}'");
//  $hidden_row = mysqli_fetch_array($select_hidden);
// print_r($hidden_row);
// print_r($_SESSION['hidden_row']);
// exit;
$hidden_skills = json_decode($_SESSION['hidden_row'], true) ?? [];
// $hidden_skills = json_decode($hidden_row['hidden_skills'], true) ?? [];
// $data = json_encode($_POST['data']);
// $settingsData = json_encode($_POST['settingsData']);
// var_dump($settingsData);
// echo "";
// var_dump($data);
// exit;
$select_school = mysqli_query($conn, "SELECT session_id,term_id, school_name, address, city, state, country, logo,phone2,phone1,email,stamp_pic FROM school WHERE id='$school_id'");
$school_row = mysqli_fetch_array($select_school);

$select_biodata = mysqli_query($conn, "SELECT * FROM students WHERE id='$student_id' AND school_id='$school_id'");
$biorow = mysqli_fetch_array($select_biodata);
if ($biorow) {
    $biorow['class_id'] = $class_id;
}
$exact_term_id = $term_id == 'cum' ? 3 : $term_id;
// echo "SELECT first,second,third, ca1, ca2, ca3, practical, exam, grading,school_open FROM skul_settings WHERE session_id='$session_id' and term_id='$exact_term_id' and school_id='$school_id'";
$select_settings = mysqli_query($conn, "SELECT first,second,third, ca1, ca2, ca3, practical, exam, grading,school_open FROM skul_settings WHERE session_id='$session_id' and term_id='$exact_term_id' and school_id='$school_id'");
$setrow = mysqli_fetch_array($select_settings);
$show_report_private_sections = false;
$approval_row = array(
    'ca1' => '0',
    'ca2' => '0',
    'ca3' => '0',
    'practical' => '0',
    'exam' => '0'
);
$settings_row = array(
    'ca1' => isset($setrow['ca1']) ? $setrow['ca1'] : '0',
    'ca2' => isset($setrow['ca2']) ? $setrow['ca2'] : '0',
    'ca3' => isset($setrow['ca3']) ? $setrow['ca3'] : '0',
    'practical' => isset($setrow['practical']) ? $setrow['practical'] : '0',
    'exam' => isset($setrow['exam']) ? $setrow['exam'] : '0'
);

$select_approval = mysqli_query($conn, "SELECT ca1,ca2,ca3,practical,exam
    FROM approval
    WHERE school_id='$school_id' AND session_id='$session_id'
    AND term_id='$exact_term_id' AND class_id='$class_id'");
if ($approval_data = mysqli_fetch_array($select_approval)) {
    $approval_row = $approval_data;
}

$enabled_components = array(
    'ca1' => $settings_row['ca1'],
    'ca2' => $settings_row['ca2'],
    'ca3' => $settings_row['ca3'],
    'practical' => $settings_row['practical'],
    'exam' => $settings_row['exam']
);

$all_enabled_components_approved = true;
$has_enabled_component = false;
foreach ($enabled_components as $component => $enabled) {
    if ($enabled == '1' || $enabled == 1) {
        $has_enabled_component = true;
        if (!isset($approval_row[$component]) || $approval_row[$component] != '1') {
            $all_enabled_components_approved = false;
            break;
        }
    }
}

$student_result_is_published = false;
$select_status = mysqli_query($conn, "SELECT id FROM skulscores
    WHERE school_id='$school_id' AND session_id='$session_id' AND term_id='$exact_term_id'
    AND class_id='$class_id' AND student_id='$student_id' AND status='1'
    LIMIT 1");
if ($select_status && mysqli_num_rows($select_status) > 0) {
    $student_result_is_published = true;
}

$is_historical_report_session = isset($_SESSION['session_id']) && (string)$session_id !== (string)$_SESSION['session_id'];
$show_report_private_sections = $has_enabled_component &&
    $all_enabled_components_approved &&
    $student_result_is_published;
if ($is_historical_report_session && $student_result_is_published) {
    $show_report_private_sections = true;
}
$grading_system = [];
try {
    // Parse the grading string directly as JSON
    $grading_system = json_decode($setrow['grading'], true);

    // Sort the grading system in descending order by score
    if (is_array($grading_system)) {
        arsort($grading_system);
    } else {
        error_log('Grading system is not properly formatted in database');
        $grading_system = []; // Empty array instead of hardcoded values
    }
} catch (Exception $e) {
    error_log('Error parsing grading system: ' . $e->getMessage());
    $grading_system = [];
}
// $percentage = calculate_total_percentage($student_id, $term_id, $session_id, $class_id, $sessionOrTerm);
$total_score = get_total_score_per_student($student_id, $term_id, $session_id, $class_id, $sessionOrTerm);
$total_obtainable = get_total_obtainables($student_id, $term_id, $session_id, $class_id, $sessionOrTerm);
$total_percent = $total_obtainable == 0 ? 0 : round((($total_score / $total_obtainable) * 100), 1);
// echo "llkn";
// exit;
$grade = get_grade($total_percent, $grading_system);
$fallback_score_rows = get_report_card_score_rows_for_table($student_id, $class_id, $session_id, $exact_term_id, $school_id);
if ($is_historical_report_session && !empty($fallback_score_rows)) {
    $show_report_private_sections = true;
}
if (!$show_report_private_sections) {
    $total_score = 0;
    $total_obtainable = 0;
    $total_percent = 0;
    $grade = 'Poor';
    $fallback_score_rows = [];
}
if ($sessionOrTerm == 'session') {
    $term_Note = "THIRD";
    $next_term = $setrow['first'];
} else if ($term_id == 1) {
    $term_Note = "FIRST";
    $next_term = $setrow['second'];
} else if ($term_id == 3 || $sessionOrTerm == "session") {
    $term_Note = "THIRD";
    $next_term = $setrow['first'];
} else if ($term_id == 2) {
    $term_Note = "SECOND";
    $next_term = $setrow['third'];
}
$department = '';
if (!empty($biorow['department'])) {
    $department = '[' . $biorow['department'] . ']';
}
$template_context = get_report_template_by_context($school_id, $session_id, $term_id == 'cum' ? 'cumulative' : $term_id);
$template = normalize_report_template_config($template_context['template_json'] ?? []);
$template_columns = get_report_card_template_score_columns($template);
$template_labels = $template['labels'] ?? [];
$report_title = render_report_template_text(
    report_card_template_label($template, 'titles', 'term_title', '{term} TERM {session} ACADEMIC SESSION'),
    [
        'term' => $term_Note,
        'session' => $_SESSION['session_name'] ?? '',
        'report_name' => 'Report Card',
    ]
);
?>
<style>
    /* .report-card {
        width: 100%;
        padding: 10px;
        background-color: #ffffff;
        transform: scale(1);
        transform-origin: top left;
        position: relative;
        z-index: 1;
    } */
    .report-card {
        /* --- Core Changes --- */
        min-width: 800px;
        /* Set a fixed width (e.g., typical A4-ish width) */
        /* Adjust this value based on your desired report card size */
        margin: 0 auto 20px auto;
        /* Center the card horizontally, add bottom margin */
        transform-origin: top left;
        /* Zoom from the top-left corner */
        /* transform: scale(1); */
        /* Remove or comment out fixed scale, JS will control this */
        /* --- End Core Changes --- */

        /* Keep existing styles */
        padding: 10px;
        background-color: #ffffff;
        position: relative;
        /* Keep for watermark positioning if needed */
        z-index: 1;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        /* Optional: Add shadow for better visual separation */
    }

    /* .watermark {
        position: fixed;
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
    } */
    /* Adjust watermark if needed - position: absolute might work better with scaling */
    .watermark {
        position: absolute;
        /* Changed from fixed */
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        opacity: 0.04;
        z-index: 0;
        pointer-events: none;
        width: 400px;
        /* Adjust as needed */
        height: 400px;
        /* Adjust as needed */
        background-image: url('../uploads/<?= $school_row['logo'] ?>');
        background-repeat: no-repeat;
        background-position: center;
        background-size: contain;
    }

    /* @media print {
        .watermark {
            position: fixed;
            display: block !important;
            opacity: 0.04;
        }
    } */
    /* Ensure watermark is visible for print preview within the modal context */
    @media print {

        /* Styles specific to printing the preview if needed */
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
            /* Ensure each report card is on a new page when printing */
        }

        .report-card:last-child {
            page-break-after: avoid;
        }

        .watermark {
            /* Ensure watermark prints if needed, opacity might need adjustment */
            opacity: 0.04 !important;
            position: absolute;
            /* Keep absolute for print layout */
        }
    }

    /* --- Add styles for zoom controls --- */
    .zoom-controls {
        position: absolute;
        /* Or fixed, depending on where you place it */
        top: 10px;
        right: 60px;
        /* Adjust position */
        z-index: 1055;
        /* Ensure it's above modal content */
        background: rgba(255, 255, 255, 0.8);
        padding: 5px;
        border-radius: 4px;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
    }

    .zoom-controls button {
        margin: 0 2px;
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

    header .logo {
        width: 100%;
        max-width: 80px;
        height: auto;
        margin-bottom: 10px;
    }

    header h1 {
        font-size: 24px;
        margin: 0;
    }

    header p {
        font-size: 16px;
        margin: 5px 0;
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

    .data-line {
        display: inline-block;
        border-bottom: 1px solid #000;
        width: 150px;
        padding-bottom: 2px;
    }

    .grades table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 10px;
        /*page-break-inside: avoid;*/
    }

    .grades th,
    .grades td,
    .report_card_table th,
    .report_card_table td {
        text-align: left;
        padding: 2px;
        font-size: 16px;
        border: 1px solid lightgrey;
        /* white-space: nowrap; */
    }

    /*.grades th {*/
    /*    background-color: lightgrey;*/
    /*}*/

    .grades.no_border table {
        border: 1px solid lightgrey;
    }

    table.behaviour_report_table td:nth-child(2) {
        text-align: center;
        width: 65px;
    }
</style>


<div class="report-card" data-template-columns='<?= htmlspecialchars(json_encode($template_columns), ENT_QUOTES, 'UTF-8') ?>' data-template-labels='<?= htmlspecialchars(json_encode($template_labels), ENT_QUOTES, 'UTF-8') ?>'>
    <?php if (report_card_template_field_enabled($template, 'school_logo')): ?>
        <div class="watermark"></div>
    <?php endif; ?>
    <?php if (report_card_template_section_enabled($template, 'school_header')): ?>
    <table style="width: 100%; margin-bottom: 20px;">
        <tr style="vertical-align: top;">
            <?php if (report_card_template_field_enabled($template, 'school_logo')): ?>
                <td style="width: auto;">
                    <div class="header-image mr-2">
                        <img width="100" height="100" src="../uploads/<?= $school_row['logo'] ?>" alt="School Logo"
                            class="logo">
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
                        <img width="100" height="100" src="../uploads/<?= $biorow['photo'] ?>" alt="Student photo"
                            class="logo">
                    </div>
                </td>
            <?php endif; ?>
        </tr>
        <tr>
            <td colspan="3">
                <h2 class="font-weight-bold text-center my-3" style="font-size:1.3rem;"><?= htmlspecialchars($report_title) ?></h2>
            </td>
        </tr>
    </table>
    <?php endif; ?>
    <!-- <header>
        <img width="100" height="100" src="../uploads/<= $school_row['logo'] ?>" alt="School Logo" class="logo">
        <h1><= $school_row['school_name'] ?></h1>
        <p><= $school_row['address'] . ' ' . $school_row['city'] . ' ' . $school_row['state'] . ' ' . $school_row['country'] ?></p>
    </header> -->

    <?php if (report_card_template_section_enabled($template, 'student_details') || report_card_template_section_enabled($template, 'performance_summary')): ?>
    <section class="grades d-flex" style="column-gap: 10px; justify-content: space-between; align-items: flex-start;">
        <?php if (report_card_template_section_enabled($template, 'student_details')): ?>
        <table style="width:68%" class="report_card_table">
            <?php if (report_card_template_field_enabled($template, 'student_name') || report_card_template_field_enabled($template, 'admission_no')): ?>
                <tr>
                    <?php if (report_card_template_field_enabled($template, 'student_name')): ?>
                        <td class="student-name-header"
                            data-student-name="<?= trim($biorow['lastname'] . ' ' . $biorow['firstname'] . ' ' . $biorow['middlename']) ?>">
                            <?= htmlspecialchars(report_card_template_label($template, 'fields', 'student_name', 'NAME')) ?>: <?= $biorow['lastname'] . ' ' . $biorow['firstname'] . ' ' . $biorow['middlename'] ?></td>
                    <?php endif; ?>
                    <?php if (report_card_template_field_enabled($template, 'admission_no')): ?>
                        <td><?= htmlspecialchars(report_card_template_label($template, 'fields', 'admission_no', 'ADM. NO')) ?>: <?= strtoupper($biorow['admission_no']) ?></td>
                    <?php endif; ?>
                </tr>
            <?php endif; ?>
            <?php if (report_card_template_field_enabled($template, 'class') || report_card_template_field_enabled($template, 'no_in_class')): ?>
                <tr>
                    <?php if (report_card_template_field_enabled($template, 'class')): ?>
                        <td><?= htmlspecialchars(report_card_template_label($template, 'fields', 'class', 'CLASS')) ?>: <?= get_class_by_classid($class_id) . $department ?></td>
                    <?php endif; ?>
                    <?php if (report_card_template_field_enabled($template, 'no_in_class')): ?>
                        <td><?= htmlspecialchars(report_card_template_label($template, 'fields', 'no_in_class', 'NO IN CLASS')) ?>: <?= get_total_students_with_scores_in_class($class_id, $session_id, $term_id, $school_id) ?></td>
                    <?php endif; ?>
                </tr>
            <?php endif; ?>
            <?php if (report_card_template_field_enabled($template, 'school_open') || report_card_template_field_enabled($template, 'next_term_begins')): ?>
                <tr>
                    <?php if (report_card_template_field_enabled($template, 'school_open')): ?>
                        <td><?= htmlspecialchars(report_card_template_label($template, 'fields', 'school_open', 'NO OF TIMES SCHOOL OPENED')) ?>: <?= $setrow['school_open'] ?></td>
                    <?php endif; ?>
                    <?php if (report_card_template_field_enabled($template, 'next_term_begins')): ?>
                        <td><?= htmlspecialchars(report_card_template_label($template, 'fields', 'next_term_begins', 'NEXT TERM BEGINS')) ?>: <?= $next_term ?></td>
                    <?php endif; ?>
                </tr>
            <?php endif; ?>
            <?php if (report_card_template_field_enabled($template, 'times_present') || report_card_template_field_enabled($template, 'times_absent')): ?>
                <tr>
                    <?php if (report_card_template_field_enabled($template, 'times_present')): ?>
                        <td><?= htmlspecialchars(report_card_template_label($template, 'fields', 'times_present', 'NO OF TIMES PRESENT')) ?>: <?= get_attendance_present($student_id, $exact_term_id, $session_id) ?></td>
                    <?php endif; ?>
                    <?php if (report_card_template_field_enabled($template, 'times_absent')): ?>
                        <td><?= htmlspecialchars(report_card_template_label($template, 'fields', 'times_absent', 'NO OF TIMES ABSENT')) ?>: <?= get_attendance_absent($student_id, $exact_term_id, $session_id) ?></td>
                    <?php endif; ?>
                </tr>
            <?php endif; ?>
        </table>
        <?php endif; ?>
        <?php if (report_card_template_section_enabled($template, 'performance_summary')): ?>
        <table style="width:30%" class="report_card_table performance-summary-table">
            <thead>
                <tr class="">
                    <th colspan="2" style="background-color: lightgrey;"><?= htmlspecialchars(report_card_template_label($template, 'sections', 'performance_summary', 'Performance Summary')) ?></th>
                </tr>
            </thead>
            <tr>
                <td><?= htmlspecialchars(report_card_template_label($template, 'summary', 'total_score', 'TOTAL SCORE')) ?>: <strong><?= $total_score ?></strong></td>
                <td><?= htmlspecialchars(report_card_template_label($template, 'summary', 'total_obtainable', 'TOTAL OBTAINABLE')) ?>: <strong> <?= $total_obtainable ?></strong></td>
            </tr>
            <tr>
                <td><?= htmlspecialchars(report_card_template_label($template, 'summary', 'percentage', 'PERCENTAGE')) ?>: <strong><?= $total_percent ?></strong></td>
                <td><?= htmlspecialchars(report_card_template_label($template, 'summary', 'grade', 'GRADE')) ?>: <strong><?= $grade ?></strong></td>
            </tr>
        </table>
        <?php endif; ?>
    </section>
    <?php endif; ?>

    <?php if (report_card_template_section_enabled($template, 'score_table')): ?>
    <section class="grades" style="">
        <div id="table_visuals_display_report">
            <?= render_report_card_score_table_fallback($fallback_score_rows, $settings_row, $grading_system) ?>
        </div>
    </section>
    <?php endif; ?>
    <?php if ($show_report_private_sections && (report_card_template_section_enabled($template, 'behaviour_skills') || report_card_template_section_enabled($template, 'psychomotor_skills'))): ?>
        <section class="grades d-flex nowrap student_behaviour_skills" style="column-gap: 10px; align-items: flex-start;">
            <?php
            $behaviour_skills = [];
            $psychomotive_skills = [];
            $skills_query_report = mysqli_query($conn, "SELECT * FROM skills WHERE school_id = 0 OR school_id = '$school_id' ORDER BY id ASC");
            while ($skill_row = mysqli_fetch_array($skills_query_report)) {
                if ($skill_row['category'] == 'behaviour') {
                    $behaviour_skills[$skill_row['skill_key']] = $skill_row['skill_label'];
                } elseif ($skill_row['category'] == 'psychomotor') {
                    $psychomotive_skills[$skill_row['skill_key']] = $skill_row['skill_label'];
                }
            }
            ?>
            <?php if (report_card_template_section_enabled($template, 'behaviour_skills')): ?>
            <div class="w-100">
                <table class="behaviour_report_table w-100 report_card_table report-card-behaviour-table">
                    <thead>
                        <tr class="">
                            <th colspan="2" style="background-color: lightgrey;"><?= htmlspecialchars(report_card_template_label($template, 'sections', 'behaviour_skills', 'General Behaviour')) ?></th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($behaviour_skills as $key => $label):
                            // echo $key;
                            // print_r($hidden_skills);
                            // echo in_array($key, $hidden_skills);
                        ?>

                            <?php if (!in_array($key, $hidden_skills)): ?>
                                <tr>
                                    <td><?= $label ?></td>
                                    <td class="<?= $key ?>">Not rated</td>
                                </tr>
                            <?php endif; ?>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
            <?php endif; ?>
            <?php if (report_card_template_section_enabled($template, 'psychomotor_skills')): ?>
            <div class="w-100">
                <table class="behaviour_report_table w-100 report_card_table report-card-psychomotive-table">
                    <thead>
                        <tr>
                            <th colspan="2" style="background-color: lightgrey;"><?= htmlspecialchars(report_card_template_label($template, 'sections', 'psychomotor_skills', 'Psychomotive Skills')) ?></th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($psychomotive_skills as $key => $label): ?>
                            <?php if (!in_array($key, $hidden_skills)): ?>
                                <tr>
                                    <td><?= $label ?></td>
                                    <td class="<?= $key ?>">Not rated</td>
                                </tr>
                            <?php endif; ?>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>
            <?php endif; ?>
        </section>
    <?php endif; ?>
    <?php if (report_card_template_section_enabled($template, 'grade_scale') || report_card_template_section_enabled($template, 'skill_rating_indices')): ?>
    <section>
        <div style="width: 100%;">
            <div class="grades mb-4 d-flex mt-4" style="column-gap: 10px; align-items: flex-start;">
                <?php if (report_card_template_section_enabled($template, 'grade_scale')): ?>
                <table style="width:auto;" class="report_card_table mb-3">
                    <thead>
                        <tr>
                            <th colspan="7" style="text-align: center; background-color: lightgrey;"><?= htmlspecialchars(report_card_template_label($template, 'sections', 'grade_scale', 'Grade Scale')) ?></th>
                        </tr>
                    </thead>
                    <tr style="text-align: center;">
                        <td style="font-size: 15px;"><strong><?= htmlspecialchars(report_card_template_label($template, 'summary', 'score_range', 'Score Range')) ?></strong></td>
                        <?php foreach ($grading_system as $grade => $min_score): ?>
                            <td style="font-size:15px;"><?= $min_score ?>+</td>
                        <?php endforeach; ?>
                    </tr>
                    <tr style="text-align: center;">
                        <td style="font-size: 15px;"><strong><?= htmlspecialchars(report_card_template_label($template, 'summary', 'grade_row', 'Grade')) ?></strong></td>
                        <?php foreach ($grading_system as $grade => $min_score): ?>
                            <td style="font-size: 15px;"><?= $grade ?></td>
                        <?php endforeach; ?>
                    </tr>
                </table>
                <?php endif; ?>
                <?php if (report_card_template_section_enabled($template, 'skill_rating_indices')): ?>
                <table style="width:auto;" class="report_card_table mb-3">
                    <thead>
                        <tr class="">
                            <th colspan="7" style="text-align: center; background-color: lightgrey;"><?= htmlspecialchars(report_card_template_label($template, 'sections', 'skill_rating_indices', 'Skill Rating Indices')) ?></th>
                        </tr>
                    </thead>
                    <tr>
                        <td style="font-size: 15px;">Excellent</td>
                        <td style="font-size: 15px;">Very Good</td>
                        <td style="font-size: 15px;">Average</td>
                        <td style="font-size: 15px;">Below Average</td>
                        <td style="font-size: 15px;">Fair</td>
                    </tr>
                    <tr>
                        <td style="font-size: 15px;">5</td>
                        <td style="font-size: 15px;">4</td>
                        <td style="font-size: 15px;">3</td>
                        <td style="font-size: 15px;">2</td>
                        <td style="font-size: 15px;">1</td>
                    </tr>
                </table>
                <?php endif; ?>
            </div>

        </div>
        <div style="width: 35%;" class="student_behaviour_skills">

        </div>
    </section>
    <?php endif; ?>

    <?php if ($show_report_private_sections && (report_card_template_section_enabled($template, 'comments') || report_card_template_section_enabled($template, 'signature_stamp'))): ?>
        <section class="remarks">
            <?php if (report_card_template_section_enabled($template, 'comments')): ?>
            <?php if (report_card_template_field_enabled($template, 'teacher_comment')): ?>
            <div class="mb-3">
                <p class="mb-0"><strong><?= $school_id == '29' ? 'CLASS ' : '' ?>TEACHER'S COMMENT</strong></p>
                <p class="mb-0 mt-0">
                    <?= get_comment_by_student($student_id, $exact_term_id, $session_id, $class_id, 0, 1) ?>
                </p>
            </div>
            <?php endif; ?>
            <?php if (report_card_template_field_enabled($template, 'head_teacher_comment')): ?>
            <div class="">
                <p class="mb-0"><strong><?= strtoupper($_SESSION['whocomment']) ?>'S COMMENT</strong></p>
                <p class="mb-0 mt-0">
                    <?= get_comment_by_student($student_id, $exact_term_id, $session_id, $class_id, 1, 1) ?>
                </p>
            </div>
            <?php endif; ?>
            <?php endif; ?>
            <?php if (report_card_template_section_enabled($template, 'signature_stamp')): ?>
            <p style="margin-top: 60px;"><strong>SIGNATURE & STAMP:</strong> <span class=""><img
                        style="width: auto; height: 45px; display: inline-block;"
                        src="../uploads/<?= $school_row['stamp_pic'] == '' ? 'logo-placeholder.jpg' : $school_row['stamp_pic'] ?>"
                        alt="Stamp Picture"></span></p>
            <?php endif; ?>
        </section>
    <?php endif; ?>
</div>
<script>
    // const gradingSystem = <= $grading_system_js ?>;
    // console.log("lkjjjj",gradingSystem)
    // get_score_data()
</script>
<!-- <script src="dist/js/skul.js"></script> -->
