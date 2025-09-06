<?php

?>
<style>
    .report-card {
        width: 100%;
        padding: 10px;
        background-color: #ffffff;
        transform: scale(0.95); /* Slightly reduce the size to fit */
        transform-origin: top left;
    }

    header {
        text-align: center;
        border-bottom: 2px solid #000000;
        padding-bottom: 10px;
        margin-bottom: 10px;
    }

    header .logo {
        width: 100px;
        height: 100px;
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
        margin-bottom: 10px;
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
    }

    .grades th {
        background-color: #f2f2f2;
    }

    .grades.no_border table {
        border: none;
    }
</style>
<?php
session_start();
include_once("model/connect.php");
include_once("model/functions.php");

$school_id = $_SESSION['school_id'];
$student_id = $_POST['studentid'];
$class_id = $_POST['classid'];
$session_id = $_POST['sessionid'];
$term_id = $_POST['termid'];
// $student_id = 33;
$select_school = mysqli_query($conn, "SELECT school_name, address, city, state, country, logo FROM school WHERE id='$school_id'");
$school_row = mysqli_fetch_array($select_school);

$select_biodata = mysqli_query($conn, "SELECT * FROM students WHERE id='$student_id' AND school_id='$school_id'");
$biorow = mysqli_fetch_array($select_biodata);

$select_settings = mysqli_query($conn, "SELECT first,second,third, ca1, ca2, ca3, practical, exam, grading FROM skul_settings WHERE school_id='$school_id'");
$setrow = mysqli_fetch_array($select_settings);

// Decode and re-encode to validate JSON
// $grading_system = json_decode($setrow['grading'], true);
// $grading_system = json_decode($setrow['grading'], true);
$grading_system = [];
// if ($selectgrade && $row = mysqli_fetch_assoc($selectgrade)) {
$trimmed = trim($setrow['grading'], '{}');
$eachgradepair = explode(',', $trimmed);
foreach ($eachgradepair as $eachgrade) {
    list($key, $value) = explode(':', $eachgrade);
    $grading_system[trim($key)] = floatval(trim($value));
}
// }

if (json_last_error() === JSON_ERROR_NONE && !empty($grading_system)) {
   echo  $grading_system_js = json_encode($grading_system);
} else {
    error_log('Grading system JSON parsing failed: ' . json_last_error_msg());
    // $grading_system_js = '{"A": 70, "B": 60, "C": 50, "D": 40, "E": 30, "F": 0}';
}

?>

<div class="report-card">
    <header>
        <img src="uploads/<?= $school_row['logo'] ?>" alt="School Logo" class="logo">
        <h1><?= $school_row['school_name'] ?></h1>
        <p><?= $school_row['address'] . ' ' . $school_row['city'] . ' ' . $school_row['state'] . ' ' . $school_row['country'] ?></p>
    </header>

    <section class="student-info">
        <p><strong>NAME OF STUDENT:</strong> <span class="data-line"><?= $biorow['lastname'] . ' ' . $biorow['firstname'] . ' ' . $biorow['middlename'] ?></span> <strong>AGE:</strong> <span class="data-line"><?=calculate_age($biorow['dob'])?></span><strong>CLASS:</strong> <span class="data-line"><?=get_class_by_classid($biorow['class_id'])?></span> </p>
        <p><strong>NO IN CLASS:</strong> <span class="data-line"><?=get_total_student_in_class($biorow['class_id'])?></span> <strong>NEXT TERM BEGINS:</strong> <span class="data-line"><?=$setrow['first']?></span></p>
        <!-- <p><strong>NO OF TIMES SCHOOL OPENED:</strong> <span class="data-line">50</span> </p> -->
    </section>

    <section class="grades">
        <table>
            <thead>
                <tr>
                    <th>Subject</th>
                    <th class="<?= $setrow['ca1'] == 0 ? 'd-none' : '' ?>">CA1</th>
                    <th class="<?= $setrow['ca2'] == 0 ? 'd-none' : '' ?>">CA2</th>
                    <th class="<?= $setrow['ca3'] == 0 ? 'd-none' : '' ?>">CA3</th>
                    <th class="<?= $setrow['practical'] == 0 ? 'd-none' : '' ?>">PRACTICAL</th>
                    <th class="<?= $setrow['exam'] == 0 ? 'd-none' : '' ?>">EXAM</th>
                    <th>TOTAL</th>
                    <th>TOTAL(%)</th>
                    <th>GRADE</th>
                </tr>
            </thead>
            <tbody>
                <?php
                $select_score = mysqli_query($conn, "SELECT subject_id, ca1, ca1Total, ca2, ca2Total, ca3, ca3Total, pra, praTotal, exam, examTotal FROM skulscores 
                WHERE term_id='$term_id' AND session_id='$session_id' AND class_id='$class_id' AND school_id='$school_id' AND student_id='$student_id'");
                while ($score_row = mysqli_fetch_array($select_score)) {
                ?>
                    <tr>
                        <td><?= getsubjectbyid($score_row['subject_id']) ?></td>
                        <td class="<?= $setrow['ca1'] == 0 ? 'd-none score' : 'score' ?>" data-score="<?= $score_row['ca1'] ?>" data-max-score="<?= $score_row['ca1Total'] ?>"><?= $score_row['ca1'] ?></td>
                        <td class="<?= $setrow['ca2'] == 0 ? 'd-none score' : 'score' ?>" data-score="<?= $score_row['ca2'] ?>" data-max-score="<?= $score_row['ca2Total'] ?>"><?= $score_row['ca2'] ?></td>
                        <td class="<?= $setrow['ca3'] == 0 ? 'd-none score' : 'score' ?>" data-score="<?= $score_row['ca3'] ?>" data-max-score="<?= $score_row['ca3Total'] ?>"><?= $score_row['ca3'] ?></td>
                        <td class="<?= $setrow['practical'] == 0 ? 'd-none score' : 'score' ?>" data-score="<?= $score_row['pra'] ?>" data-max-score="<?= $score_row['praTotal'] ?>"><?= $score_row['pra'] ?></td>
                        <td class="<?= $setrow['exam'] == 0 ? 'd-none score' : 'score' ?>" data-score="<?= $score_row['exam'] ?>" data-max-score="<?= $score_row['examTotal'] ?>"><?= $score_row['exam'] ?></td>
                        <td class="total-score"></td>
                        <td class="percentage"></td>
                        <td class="gradeclass"></td>
                    </tr>
                <?php
                }
                ?>
            </tbody>

        </table>
    </section>
    <!-- <section class="grades no_border" style="display: flex; justify-content: space-between;">
        <div class="">
            <table class="">
                <thead>
                    <tr>
                        <th>Effective General Behaviour</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Punctuality</td>
                        <td class="punctuality"></td>
                    </tr>
                    <tr>
                        <td>Classroom attendance</td>
                        <td class="classattendance"></td>
                    </tr>
                    <tr>
                        <td>Response to assignment</td>
                        <td class="resptoass"></td>
                    </tr>
                    <tr>
                        <td>Neatness</td>
                        <td class="Neatness"></td>
                    </tr>
                    <tr>
                        <td>Politeness</td>
                        <td class="Politeness"></td>
                    </tr>
                    <tr>
                        <td>Honesty</td>
                        <td class="Honesty"></td>
                    </tr>
                    <tr>
                        <td>Self control</td>
                        <td class="selfcontrol"></td>
                    </tr>
                    <tr>
                        <td>Relationship with others</td>
                        <td class="relationship"></td>
                    </tr>
                    <tr>
                        <td>Organizational Ability</td>
                        <td class="organizationability"></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <div class="">
            <table>
                <thead>
                    <tr>
                        <th>PSYCHOMOTIVE SKILLS</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Obedience</td>
                        <td class="Obedience"></td>
                    </tr>
                    <tr>
                        <td>Creativity</td>
                        <td class="Creativity"></td>
                    </tr>
                    <tr>
                        <td>Writing</td>
                        <td class="Writing"></td>
                    </tr>
                    <tr>
                        <td>Fluency</td>
                        <td class="Fluency"></td>
                    </tr>
                    <tr>
                        <td>Sport</td>
                        <td class="Sport"></td>
                    </tr>
                    <tr>
                        <td>Games</td>
                        <td class="Games"></td>
                    </tr>
                    <tr>
                        <td>Drawing & Painting</td>
                        <td class="DrawingPainting"></td>
                    </tr>
                    <tr>
                        <td>Music Performance</td>
                        <td class="Music"></td>
                    </tr>
                    <tr>
                        <td>Handling Tools</td>
                        <td class="HandlingTools"></td>
                    </tr>
                    <tr>
                        <td>Craft</td>
                        <td class="Crafts"></td>
                    </tr>
                </tbody>
            </table>
        </div>
    </section> -->

    <section class="remarks">
        <p><strong>TOTAL MARK SCORED:</strong> <span class="data-line"><?=get_total_score_per_student($student_id,$term_id,$session_id,$class_id)?></span> <strong>PERCENTAGE:</strong> <span class="data-line"><?=calculate_total_percentage($student_id,$term_id,$session_id,$class_id)?></span></p>
        <p><strong>FORM MASTER’S REMARK:</strong> <span class="data-line" style="width: 700px;"><?=get_comment_by_student($student_id,$term_id,$session_id,$class_id,0,1)?></span> <strong>SIGNATURE:</strong> <span class="data-line">Mr. Smith</span></p>
        <p><strong>PRINCIPAL’S REMARK:</strong> <span class="data-line" style="width: 550px;"><?=get_comment_by_student($student_id,$term_id,$session_id,$class_id,1,1)?></span></p>
        <p><strong>SIGNATURE & STAMP:</strong> <span class="data-line"></span></p>
        <!-- <p><strong>NEXT TERM FEE(N):</strong> <span class="data-line">30,000</span> <strong>OUTSTANDING FEE(N):</strong> <span class="data-line">5,000</span></p> -->
    </section>
</div>







<script>
    // Grading system logic (unchanged)
    alert(<?= $grading_system_js ?>)
    const gradingSystem = <?= $grading_system_js ?>;
    console.log("Grading System:", gradingSystem);

    function calculateGrade1(percentage, gradingSystem) {
        for (const grade in gradingSystem) {
            if (percentage >= gradingSystem[grade]) {
                return grade;
            }
        }
        return 'F'; // Default to 'F' if no grade matches
    }

    document.querySelectorAll('tbody tr').forEach(row => {
        let totalScore = 0;
        let totalPossible = 0;

        row.querySelectorAll('.score').forEach(cell => {
            if (!cell.classList.contains('d-none')) {
                const score = parseInt(cell.dataset.score);
                const maxScore = parseInt(cell.dataset.maxScore);

                if (!isNaN(score) && !isNaN(maxScore)) {
                    totalScore += score;
                    totalPossible += maxScore;
                }
            }
        });

        const percentage = (totalScore / totalPossible) * 100;
        console.log("Calculating grade for percentage:", percentage);
        const grade = calculateGrade1(percentage, gradingSystem);
        console.log("Assigned Grade:", grade);

        const totalScoreElement = row.querySelector('.total-score');
        const percentageElement = row.querySelector('.percentage');
        const gradeElement = row.querySelector('.gradeclass');

        if (totalScoreElement) totalScoreElement.textContent = totalScore;
        if (percentageElement) percentageElement.textContent = percentage.toFixed(2) + '%';
        if (gradeElement) gradeElement.textContent = grade;
    });

    // HTML to PDF generation
    

    // // Call the generatePDF function when needed, e.g., on button click
    // document.querySelector('#download-pdf-button').addEventListener('click', generatePDF);
</script>
