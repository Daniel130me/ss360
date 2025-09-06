<?php
session_start();
include_once("model/connect.php");
include_once("model/functions.php");

$school_id = $_SESSION['school_id'];
$student_id = $_POST['student_id'];
$class_id = $_POST['class_id'];
$session_id = $_POST['session_id'];
$term_id = $_POST['term_id'];
// $data = json_encode($_POST['data']);
// $settingsData = json_encode($_POST['settingsData']);
// var_dump($settingsData);
// echo "";
// var_dump($data);
// exit;
$select_school = mysqli_query($conn, "SELECT school_name, address, city, state, country, logo,phone2,phone1,email FROM school WHERE id='$school_id'");
$school_row = mysqli_fetch_array($select_school);

$select_biodata = mysqli_query($conn, "SELECT * FROM students WHERE id='$student_id' AND school_id='$school_id'");
$biorow = mysqli_fetch_array($select_biodata);

$select_settings = mysqli_query($conn, "SELECT first,second,third, ca1, ca2, ca3, practical, exam, grading,school_open FROM skul_settings WHERE school_id='$school_id'");
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
$percentage = calculate_total_percentage($student_id, $term_id, $session_id, $class_id);
$grade = get_grade($percentage, $grading_system);

?>
<style>
    .report-card {
        width: 100%;
        padding: 10px;
        background-color: #ffffff;
        transform: scale(1);
        transform-origin: top left;
        position: relative;
        z-index: 1;
    }

    .watermark {
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
    }

    @media print {
        .watermark {
            position: fixed;
            display: block !important;
            opacity: 0.04;
        }
    }
    
    td {
        color:black;
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
        font-size: 14px;
        margin: 5px 0;
    }

    .student-info,
    .remarks {
        margin-bottom: 25px;
    }

    .student-info p,
    .remarks p {
        font-size: 14px;
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
        font-size: 14px;
        border: 1px solid lightgrey;
    }

    .grades th {
        background-color: lightgrey;
    }

    .grades.no_border table {
        border: 1px solid lightgrey;
    }
    table.behaviour_report_table td:nth-child(2) {
            width:25px;
    }

</style>


<div class="report-card">
<table>
        <tr class="" style="vertical-align: top;">
            <td style="width: auto;">
                <div class="header-image mr-2">
                <img width="100" height="100" src="../uploads/<?= $school_row['logo'] ?>" alt="School Logo" class="logo"></div>
            </td>
            <td>
                <p class="font-weight-bold" style="font-size: 25px; line-height: normal;"><?= $school_row['school_name'] ?></p>
                <p style="max-width: 70%;">Address: <?=$school_row['address']?></p>
                <p class="">Tel: <?=$school_row['phone1']. ', '. $school_row['phone2']?></p>
                <p class="">Email: <?=$school_row['email']?></p>
            </td>
        </tr>
        <tr>
            <td colspan="2"><h2 class="font-weight-bold text-center my-3" style="font-size:1.3rem;">2ND TERM 2024/2025 ACADEMIC SESSION</h2></td>
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
                <td>ADM. NO: <?= strtoupper($biorow['admission_no'])?></td>
            </tr>
            <tr>
                <td>CLASS: <?= get_class_by_classid($biorow['class_id']) ?></td>
                <td>NO IN CLASS: <?= get_total_student_in_class($biorow['class_id']) ?></td>
            </tr>
            <tr>
                <td>NO OF TIMES SCHOOL OPENS: <?= $setrow['school_open'] ?></td>
                <td>NEXT TERM BEGINS: <?= $setrow['third'] ?></td>
            </tr>
            <tr>
                <td>NO OF TIMES PRESENT: <?= get_attendance_present($student_id, $term_id, $session_id) ?></td>
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
                <td>TOTAL SCORE: <strong><?=get_total_score_per_student($student_id, $term_id, $session_id, $class_id) ?></strong></td>
                <td>TOTAL OBTAINABLE: <strong> <?= get_total_obtainables($student_id, $term_id, $session_id, $class_id) ?></strong></td>
            </tr>
            <tr>
                <td>PERCENTAGE: <strong><?= $percentage ?></strong></td>
                <td>GRADE: <strong><?= $grade ?></strong></td>
            </tr>
        </table>
    </section>

   <section class="grades mb-4 d-flex" style="column-gap: 10px;justify-content: space-between;">
        <div style="width: 75%;">
            <div id="table_visuals_display_report"></div>
            <div class="grades mb-4 d-flex mt-4" style="column-gap: 10px;justify-content: space-between;">
        <table style="width:50%" class="report_card_table mb-3">
            <thead>
                <tr>
                    <th colspan="7" style="text-align: center; background-color: lightgrey;">Grade Scale</th>
                </tr>
            </thead>
            <tr style="text-align: center;">
                <td><strong>Score Range</strong></td>
                <?php foreach($grading_system as $grade => $min_score): ?>
                    <td><?= $min_score ?>+</td>
                <?php endforeach; ?>
            </tr>
            <tr style="text-align: center;">
                <td><strong>Grade</strong></td>
                <?php foreach($grading_system as $grade => $min_score): ?>
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
            <div>
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
            <div>
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
        </div>
    </section>

    <section class="remarks">
        <div class="mb-3">
            <p class="mb-0"><strong>TEACHER'S REMARK</strong></p> 
            <p class="mb-0 mt-0"><?= get_comment_by_student($student_id, $term_id, $session_id, $class_id, 0, 1) ?></p> 
        </div>
        <div class="">      
       <p class="mb-0"><strong>HEAD TEACHER'S REMARK</strong></p> 
        <p class="mb-0 mt-0"><?= get_comment_by_student($student_id, $term_id, $session_id, $class_id, 1, 1) ?></p>
        </div>
        <p style="margin-top: 60px;"><strong>SIGNATURE & STAMP:</strong> <span class="data-line"></span></p>
    </section>
</div>
<script>
    // const gradingSystem = <= $grading_system_js ?>;
    // console.log("lkjjjj",gradingSystem)
    // get_score_data()
</script>
<!-- <script src="dist/js/skul.js"></script> -->