<?php
session_start();
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
$student_id = $_POST['student_id'];
$class_id = $_POST['class_id'];
$session_id = $_POST['session_id'];
$term_id = $_POST['term_id'];
$sessionOrTerm = $_POST['sessionOrTerm'];
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
$exact_term_id = $term_id == 'cum' ? 3 : $term_id;
// echo "SELECT first,second,third, ca1, ca2, ca3, practical, exam, grading,school_open FROM skul_settings WHERE session_id='$session_id' and term_id='$exact_term_id' and school_id='$school_id'";
$select_settings = mysqli_query($conn, "SELECT first,second,third, ca1, ca2, ca3, practical, exam, grading,school_open FROM skul_settings WHERE session_id='$session_id' and term_id='$exact_term_id' and school_id='$school_id'");
$setrow = mysqli_fetch_array($select_settings);
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


<div class="report-card">
    <div class="watermark"></div>
    <table style="width: 100%; margin-bottom: 20px;">
        <tr style="vertical-align: top;">
            <td style="width: auto;">
                <div class="header-image mr-2">
                    <img width="100" height="100" src="../uploads/<?= $school_row['logo'] ?>" alt="School Logo"
                        class="logo">
                </div>
            </td>
            <td style="vertical-align: top; width: 100%;">
                <div>
                    <p class="font-weight-bold" style="font-size: 25px; line-height: normal;">
                        <?= $school_row['school_name'] ?>
                    </p>
                    <p style="max-width: 100%;">Address: <?= $school_row['address'] ?></p>
                    <p class="">Tel: <?= $school_row['phone1'] . ', ' . $school_row['phone2'] ?></p>
                    <p class="">Email: <?= $school_row['email'] ?></p>
                </div>
            </td>
            <?php if (isset($biorow['photo']) && $biorow['photo'] != 'avatar.png'): ?>
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
                <h2 class="font-weight-bold text-center my-3" style="font-size:1.3rem;"><?= $term_Note ?> TERM
                    <?= $_SESSION['session_name'] ?> ACADEMIC SESSION
                </h2>
            </td>
        </tr>
    </table>
    <!-- <header>
        <img width="100" height="100" src="../uploads/<= $school_row['logo'] ?>" alt="School Logo" class="logo">
        <h1><= $school_row['school_name'] ?></h1>
        <p><= $school_row['address'] . ' ' . $school_row['city'] . ' ' . $school_row['state'] . ' ' . $school_row['country'] ?></p>
    </header> -->

    <section class="grades d-flex" style="column-gap: 10px; justify-content: space-between; align-items: flex-start;">
        <table style="width:68%" class="report_card_table">
            <tr>
                <td class="student-name-header"
                    data-student-name="<?= trim($biorow['lastname'] . ' ' . $biorow['firstname'] . ' ' . $biorow['middlename']) ?>">
                    NAME: <?= $biorow['lastname'] . ' ' . $biorow['firstname'] . ' ' . $biorow['middlename'] ?></td>
                <td>ADM. NO: <?= strtoupper($biorow['admission_no']) ?></td>
            </tr>
            <tr>
                <td>CLASS: <?= get_class_by_classid($biorow['class_id']) . $department ?></td>
                <td>NO IN CLASS: <?= get_total_student_in_class($biorow['class_id']) ?></td>
            </tr>
            <tr>
                <td>NO OF TIMES SCHOOL OPENED: <?= $setrow['school_open'] ?></td>
                <td>NEXT TERM BEGINS: <?= $next_term ?></td>
            </tr>
            <tr>
                <td>NO OF TIMES PRESENT: <?= get_attendance_present($student_id, $exact_term_id, $session_id) ?></td>
                <td>NO OF TIMES ABSENT: <?= get_attendance_absent($student_id, $exact_term_id, $session_id) ?></td>
            </tr>
        </table>
        <table style="width:30%" class="report_card_table performance-summary-table">
            <thead>
                <tr class="">
                    <th colspan="2" style="background-color: lightgrey;">Performance Summary</th>
                </tr>
            </thead>
            <tr>
                <td>TOTAL SCORE: <strong><?= $total_score ?></strong></td>
                <td>TOTAL OBTAINABLE: <strong> <?= $total_obtainable ?></strong></td>
            </tr>
            <tr>
                <td>PERCENTAGE: <strong><?= $total_percent ?></strong></td>
                <td>GRADE: <strong><?= $grade ?></strong></td>
            </tr>
        </table>
    </section>

    <section class="grades" style="">
        <div id="table_visuals_display_report"></div>
    </section>
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
        <div class="w-100">
            <table class="behaviour_report_table w-100 report_card_table report-card-behaviour-table">
                <thead>
                    <tr class="">
                        <th colspan="2" style="background-color: lightgrey;">General Behaviour</th>
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
        <div class="w-100">
            <table class="behaviour_report_table w-100 report_card_table report-card-psychomotive-table">
                <thead>
                    <tr>
                        <th colspan="2" style="background-color: lightgrey;">Psychomotive Skills</th>
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
    </section>
    <section>
        <div style="width: 100%;">
            <div class="grades mb-4 d-flex mt-4" style="column-gap: 10px; align-items: flex-start;">
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
                <table style="width:auto;" class="report_card_table mb-3">
                    <thead>
                        <tr class="">
                            <th colspan="7" style="text-align: center; background-color: lightgrey;">Skill Rating
                                Indices</th>
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
            </div>

        </div>
        <div style="width: 35%;" class="student_behaviour_skills">

        </div>
    </section>

    <section class="remarks">
        <div class="mb-3">
            <p class="mb-0"><strong><?= $school_id == '29' ? 'CLASS ' : '' ?>TEACHER'S COMMENT</strong></p>
            <p class="mb-0 mt-0">
                <?= get_comment_by_student($student_id, $exact_term_id, $session_id, $class_id, 0, 1) ?>
            </p>
        </div>
        <div class="">
            <p class="mb-0"><strong><?= strtoupper($_SESSION['whocomment']) ?>'S COMMENT</strong></p>
            <p class="mb-0 mt-0">
                <?= get_comment_by_student($student_id, $exact_term_id, $session_id, $class_id, 1, 1) ?>
            </p>
        </div>
        <p style="margin-top: 60px;"><strong>SIGNATURE & STAMP:</strong> <span class=""><img
                    style="width: auto; height: 45px; display: inline-block;"
                    src="../uploads/<?= $school_row['stamp_pic'] == '' ? 'logo-placeholder.jpg' : $school_row['stamp_pic'] ?>"
                    alt="Stamp Picture"></span></p>
    </section>
</div>
<script>
    // const gradingSystem = <= $grading_system_js ?>;
    // console.log("lkjjjj",gradingSystem)
    // get_score_data()
</script>
<!-- <script src="dist/js/skul.js"></script> -->