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
// $data = json_encode($_POST['data']);
// $settingsData = json_encode($_POST['settingsData']);
// var_dump($settingsData);
// echo "";
// var_dump($data);
// exit;
$select_school = mysqli_query($conn, "SELECT school_name, address, city, state, country, logo,phone2,phone1,email,stamp_pic FROM school WHERE id='$school_id'");
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
function get_total_score_per_student_homat($studentid, $term_id, $session_id, $class_id, $sessionOrTerm)
{
    global $conn;
    // If term_id == 2, sum scores for both first and second term (term_id IN (1,2)), exclude third term
    if ($term_id == 2) {
        $query = "SELECT SUM(total) AS total_score 
            FROM skulscores 
            WHERE student_id='$studentid' 
            AND session_id='$session_id' 
            AND class_id='$class_id' 
            AND school_id='{$_SESSION['school_id']}'
            AND (
                ca1Total > 0 OR
                ca2Total > 0 OR
                ca3Total > 0 OR
                praTotal > 0 OR
                examTotal > 0
            )
            AND term_id IN (1,2)";
    } else {
        $query = "SELECT SUM(total) AS total_score 
            FROM skulscores 
            WHERE student_id='$studentid' 
            AND session_id='$session_id' 
            AND class_id='$class_id' 
            AND school_id='{$_SESSION['school_id']}'
            AND (
                ca1Total > 0 OR
                ca2Total > 0 OR
                ca3Total > 0 OR
                praTotal > 0 OR
                examTotal > 0
            )";
        if ($sessionOrTerm == 'term') {
            $query .= " AND term_id='$term_id'";
        }
        // else{
        //     $query .= " AND session_id='$session_id'";
        // }
    }
    $select = mysqli_query($conn, $query);
    $row = mysqli_fetch_array($select);
    return $row['total_score'] ?? 0;
}
function get_total_obtainables_homat($studentid, $term_id, $session_id, $class_id, $sessionOrTerm)
{
    global $conn;
    // If term_id == 2, count subjects for both first and second term (term_id IN (1,2)), exclude third term
    if ($term_id == 2) {
        $query = "SELECT COUNT(*) as subject_count 
            FROM skulscores 
            WHERE student_id='$studentid' 
            AND class_id='$class_id' 
            AND school_id='{$_SESSION['school_id']}'
            AND session_id='$session_id'
            AND total > 0 and ca1Total>0 
            AND term_id IN (1,2)";
    } else {
        $query = "SELECT COUNT(*) as subject_count 
            FROM skulscores 
            WHERE student_id='$studentid' 
            AND class_id='$class_id' 
            AND school_id='{$_SESSION['school_id']}'
            AND session_id='$session_id'
            AND total > 0 and ca1Total>0 ";
        if ($sessionOrTerm == 'term') {
            $query .= " AND term_id='$term_id'";
        }
    }
    $select = mysqli_query($conn, $query);
    $row = mysqli_fetch_array($select);
    return $row['subject_count'] * 100;
}
$total_score = get_total_score_per_student_homat($student_id, $term_id, $session_id, $class_id, $sessionOrTerm);
// echo $total_score;
// exit;
$total_obtainable = get_total_obtainables_homat($student_id, $term_id, $session_id, $class_id, $sessionOrTerm);
// echo $total_obtainable;
$total_percent = $total_obtainable == 0 ? 0 : round((($total_score / $total_obtainable) * 100), 1);
$grade = get_grade($total_percent, $grading_system);
$fallback_score_rows = get_report_card_score_rows_for_table($student_id, $class_id, $session_id, $exact_term_id, $school_id);
if ($term_id == 1) {
    $term_Note = "FIRST";
    $next_term = $setrow['second'];
} else if ($term_id == 3 || $sessionOrTerm == "session") {
    $term_Note = "THIRD";
    $next_term = $setrow['first'];
} else if ($term_id == 2) {
    $term_Note = "SECOND";
    $next_term = $setrow['third'];
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
        page-break-inside: avoid;
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

    .grades th {
        background-color: lightgrey;
    }

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
    <table style="width: 100%;">
        <tr class="" style="vertical-align: top;">
            <td style="width: auto;">
                <div class="header-image mr-2">
                    <img width="100" height="100" src="../uploads/<?= $school_row['logo'] ?>" alt="School Logo"
                        class="logo">
                </div>
            </td>
            <td style="width: 100%; display: flex; justify-content: space-between; flex-wrap:nowrap;">
                <div>
                    <p class="font-weight-bold" style="font-size: 25px; line-height: normal;">
                        <?= $school_row['school_name'] ?></p>
                    <p style="max-width: 70%;">Address: <?= $school_row['address'] ?></p>
                    <p class="">Tel: <?= $school_row['phone1'] . ', ' . $school_row['phone2'] ?></p>
                    <p class="">Email: <?= $school_row['email'] ?></p>
                </div>
                <?php if (isset($biorow['photo']) && $biorow['photo'] != 'avatar.png'): ?>
                    <div class="header-image ml-2">
                        <img width="100" height="100" src="../uploads/<?= $biorow['photo'] ?>" alt="Student photo"
                            class="logo">
                    </div>
                <?php endif; ?>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <h2 class="font-weight-bold text-center my-3" style="font-size:1.3rem;"><?= $term_Note ?> TERM 2024/2025
                    ACADEMIC SESSION</h2>
            </td>
        </tr>
    </table>
    <!-- <header>
        <img width="100" height="100" src="../uploads/<= $school_row['logo'] ?>" alt="School Logo" class="logo">
        <h1><= $school_row['school_name'] ?></h1>
        <p><= $school_row['address'] . ' ' . $school_row['city'] . ' ' . $school_row['state'] . ' ' . $school_row['country'] ?></p>
    </header> -->

    <section class="grades d-flex" style="column-gap: 10px;justify-content: space-between;">
        <table style="width:75%" class="report_card_table mb-3">
            <tr>
                <td>NAME: <?= $biorow['lastname'] . ' ' . $biorow['firstname'] . ' ' . $biorow['middlename'] ?></td>
                <td>ADM. NO: <?= strtoupper($biorow['admission_no']) ?></td>
            </tr>
            <tr>
                <td>CLASS: <?= get_class_by_classid($class_id) ?></td>
                <td>NO IN CLASS: <?= get_total_students_with_scores_in_class($class_id, $session_id, $term_id, $school_id) ?></td>
            </tr>
            <tr>
                <td>NO OF TIMES SCHOOL OPEN: <?= $setrow['school_open'] ?></td>
                <td>NEXT TERM BEGINS: <?= $next_term ?></td>
            </tr>
            <tr>
                <td>NO OF TIMES PRESENT: <?= get_attendance_present($student_id, $exact_term_id, $session_id) ?></td>
                <td>NO OF TIMES ABSENT: <?= get_attendance_absent($student_id, $term_id, $session_id) ?></td>
            </tr>
        </table>
        <table style="width:35%" class="report_card_table mb-3">
            <thead>
                <tr class="">
                    <th colspan="2">Performance Summary</th>
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
        <div id="table_visuals_display_report">
            <?= render_report_card_score_table_fallback($fallback_score_rows, $setrow, $grading_system) ?>
        </div>
    </section>
    <section class="grades d-flex nowrap student_behaviour_skills"" style=" column-gap: 10px;">
        <div class="w-100">
            <table class="behaviour_report_table w-100 report_card_table report-card-behaviour-table">
                <thead>
                    <tr class="">
                        <th colspan="2">General Behaviour</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Punctuality</td>
                        <td class="punctuality">Not rated</td>
                    </tr>
                    <tr>
                        <td>Classroom attendance</td>
                        <td class="classattendance">Not rated</td>
                    </tr>
                    <tr>
                        <td>Response to assignment</td>
                        <td class="resptoass">Not rated</td>
                    </tr>
                    <tr>
                        <td>Neatness</td>
                        <td class="Neatness">Not rated</td>
                    </tr>
                    <tr>
                        <td>Politeness</td>
                        <td class="Politeness">Not rated</td>
                    </tr>
                    <tr>
                        <td>Honesty</td>
                        <td class="Honesty">Not rated</td>
                    </tr>
                    <tr>
                        <td>Self control</td>
                        <td class="selfcontrol">Not rated</td>
                    </tr>
                    <tr>
                        <td>Relationship with others</td>
                        <td class="relationship">Not rated</td>
                    </tr>
                    <tr>
                        <td>Organizational Ability</td>
                        <td class="organizationability">Not rated</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="w-100">
            <table class="behaviour_report_table w-100 report_card_table report-card-psychomotive-table">
                <thead>
                    <tr>
                        <th colspan="2">Psychomotive Skills</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Obedience</td>
                        <td class="Obedience">Not rated</td>
                    </tr>
                    <tr>
                        <td>Creativity</td>
                        <td class="Creativity">Not rated</td>
                    </tr>
                    <tr>
                        <td>Writing</td>
                        <td class="Writing">Not rated</td>
                    </tr>
                    <tr>
                        <td>Fluency</td>
                        <td class="Fluency">Not rated</td>
                    </tr>
                    <tr>
                        <td>Sport</td>
                        <td class="Sport">Not rated</td>
                    </tr>
                    <tr>
                        <td>Games</td>
                        <td class="Games">Not rated</td>
                    </tr>
                    <tr>
                        <td>Drawing &amp; Painting</td>
                        <td class="DrawingPainting">Not rated</td>
                    </tr>
                    <tr>
                        <td>Music Performance</td>
                        <td class="Music">Not rated</td>
                    </tr>
                    <tr>
                        <td>Handling Tools</td>
                        <td class="HandlingTools">Not rated</td>
                    </tr>
                    <tr>
                        <td>Craft</td>
                        <td class="Crafts">Not rated</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </section>
    <section>
        <div style="width: 75%;">
            <div class="grades mb-4 d-flex mt-4" style="column-gap: 10px;justify-content: space-between;">
                <table style="width:50%" class="report_card_table mb-3">
                    <thead>
                        <tr>
                            <th colspan="7" style="text-align: center; background-color: lightgrey;">Grade Scale</th>
                        </tr>
                    </thead>
                    <tr style="text-align: center;">
                        <td><strong>Score Range</strong></td>
                        <?php foreach ($grading_system as $grade => $min_score): ?>
                            <td><?= $min_score ?>+</td>
                        <?php endforeach; ?>
                    </tr>
                    <tr style="text-align: center;">
                        <td><strong>Grade</strong></td>
                        <?php foreach ($grading_system as $grade => $min_score): ?>
                            <td><?= $grade ?></td>
                        <?php endforeach; ?>
                    </tr>
                </table>
                <table style="width:50%" class="report_card_table mb-3">
                    <thead>
                        <tr class="">
                            <th colspan="7">Skill Rating Indices</th>
                        </tr>
                    </thead>
                    <tr>
                        <td>Excellent</td>
                        <td>Very Good</td>
                        <td>Average</td>
                        <td>Below Average</td>
                        <td>Fair</td>
                    </tr>
                    <tr>
                        <td>5</td>
                        <td>4</td>
                        <td>3</td>
                        <td>2</td>
                        <td>1</td>
                    </tr>
                </table>
            </div>

        </div>
        <div style="width: 35%;" class="student_behaviour_skills">

        </div>
    </section>

    <section class="remarks">
        <div class="mb-3">
            <p class="mb-0"><strong>TEACHER'S REMARK</strong></p>
            <p class="mb-0 mt-0">
                <?= get_comment_by_student($student_id, $exact_term_id, $session_id, $class_id, 0, 1) ?></p>
        </div>
        <div class="">
            <p class="mb-0"><strong>HEAD TEACHER'S REMARK</strong></p>
            <p class="mb-0 mt-0">
                <?= get_comment_by_student($student_id, $exact_term_id, $session_id, $class_id, 1, 1) ?></p>
        </div>
        <p style="margin-top: 60px;"><strong>SIGNATURE & STAMP:</strong> <span class=""><img
                    style="width: auto; height: 45px; display: inline-block;"
                    src="../uploads/<?= $school_row['stamp_pic'] == '' ? 'logo-placeholder.jpg' : $school_row['stamp_pic'] ?>"
                    alt="Background Picture"></span></p>
    </section>
</div>
<script>
    // const gradingSystem = <= $grading_system_js ?>;
    // console.log("lkjjjj",gradingSystem)
    // get_score_data()
</script>
<!-- <script src="dist/js/skul.js"></script> -->
