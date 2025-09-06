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
$select_school = mysqli_query($conn, "SELECT school_name, address, city, state, country, logo FROM school WHERE id='$school_id'");
$school_row = mysqli_fetch_array($select_school);

$select_biodata = mysqli_query($conn, "SELECT * FROM students WHERE id='$student_id' AND school_id='$school_id'");
$biorow = mysqli_fetch_array($select_biodata);

$select_settings = mysqli_query($conn, "SELECT first,second,third, ca1, ca2, ca3, practical, exam, grading,school_open FROM skul_settings WHERE school_id='$school_id'");
$setrow = mysqli_fetch_array($select_settings);

$grading_system = [];
$trimmed = trim($setrow['grading'], '{}');
$eachgradepair = explode(',', $trimmed);
foreach ($eachgradepair as $eachgrade) {
    list($key, $value) = explode(':', $eachgrade);
    $grading_system[trim($key)] = floatval(trim($value));
}
// }

if (json_last_error() === JSON_ERROR_NONE && !empty($grading_system)) {
    $grading_system_js = json_encode($grading_system);
} else {
    error_log('Grading system JSON parsing failed: ' . json_last_error_msg());
}
?>
<style>
    .report-card {
        width: 100%;
        padding: 10px;
        background-color: #ffffff;
        transform: scale(0.95);
        /* Slightly reduce the size to fit */
        transform-origin: top left;
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
    .grades td {
        text-align: left;
        padding: 2px;
        font-size: 14px;
        border: 1px solid lightgrey;
    }

    .grades th {
        background-color: #f3f9ff;
    }

    .grades.no_border table {
        border: 1px solid lightgrey;
    }

    .report_card_table th,
    .report_card_table td {
        border: 1px solid #878787;
    }
</style>


<div class="report-card">
    <header>
        <img width="100" height="100" src="../uploads/<?= $school_row['logo'] ?>" alt="School Logo" class="logo">
        <h1><?= $school_row['school_name'] ?></h1>
        <p><?= $school_row['address'] . ' ' . $school_row['city'] . ' ' . $school_row['state'] . ' ' . $school_row['country'] ?></p>
    </header>

    <section class="student-info">
        <p><strong>NAME OF STUDENT:</strong> <span class="data-line" style="width: 390px;"><?= $biorow['lastname'] . ' ' . $biorow['firstname'] . ' ' . $biorow['middlename'] ?></span> <strong>AGE:</strong> <span class="data-line"><?= calculate_age($biorow['dob']) ?></span> </p>
        <p><strong>CLASS:</strong> <span class="data-line"><?= get_class_by_classid($biorow['class_id']) ?></span><strong>NO OF TIMES SCHOOL OPENS:</strong> <span class="data-line"><?= $setrow['school_open'] ?></span></p>
        <p><strong>NO IN CLASS:</strong> <span class="data-line"><?= get_total_student_in_class($biorow['class_id']) ?></span> <strong>NEXT TERM BEGINS:</strong> <span class="data-line"><?= $setrow['first'] ?></span></p>
        <!-- <p><strong>NO OF TIMES SCHOOL OPENED:</strong> <span class="data-line">50</span> </p> -->
    </section>

    <section class="grades mb-4 d-flex" style="column-gap: 10px;justify-content: space-between;">
        <div style="width: 75%;" id="table_visuals_display_report">
        
        </div>
        <div style="width: 35%;">
            <div>
                <table class="behaviour_report_table w-100 report_card_table">
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
                <table class="behaviour_report_table w-100 report_card_table">
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
        <p><strong>TOTAL MARK SCORED:</strong> <span class="data-line"><?= get_total_score_per_student($student_id, $term_id, $session_id, $class_id) ?></span> <strong>PERCENTAGE:</strong> <span class="data-line"><?= calculate_total_percentage($student_id, $term_id, $session_id, $class_id) ?></span></p>
        <p><strong>FORM MASTER’S REMARK:</strong> <span class="data-line" style="width: 700px;"><?= get_comment_by_student($student_id, $term_id, $session_id, $class_id, 0, 1) ?></span> <strong>SIGNATURE:</strong> <span class="data-line">Mr. Smith</span></p>
        <p><strong>PRINCIPAL’S REMARK:</strong> <span class="data-line" style="width: 700px;"><?= get_comment_by_student($student_id, $term_id, $session_id, $class_id, 1, 1) ?></span></p>
        <p style="margin-top: 60px;"><strong>SIGNATURE & STAMP:</strong> <span class="data-line"></span></p>
    </section>
</div>
<script>
    // const gradingSystem = <= $grading_system_js ?>;
    // console.log("lkjjjj",gradingSystem)
    // get_score_data()
</script>
<!-- <script src="dist/js/skul.js"></script> -->