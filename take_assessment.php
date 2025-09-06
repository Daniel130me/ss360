<?php
// error_reporting(E_ALL);
date_default_timezone_set('Africa/Lagos'); // Set the timezone to Lagos
session_start();
// echo "l";
if (!isset($_SESSION['userid']) || $_SESSION['user_type'] !== 'student') {
    $_SESSION['take_assessment'] = "take_assessment?id={$_GET['id']}";
    header("Location: login");
    exit();
}

include_once("model/connect.php");
include_once("model/functions.php");

$assessment_id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
// echo $assessment_id;
// exit;
$student_id = $_SESSION['userid'];
// unset($_SESSION['viewed_instructions'][$assessment_id]);
// echo $_SESSION['viewed_instructions'][$assessment_id];
// exit();
// Check if user has viewed instructions
if (!isset($_SESSION['viewed_instructions'][$assessment_id])) {
    // echo "You must view the instructions first";
    header("Location: assessment_instructions?id=$assessment_id");
    exit();
}
// Unset the redirect flag if it exists
if (isset($_SESSION['redirect_to_assessment'])) {
    unset($_SESSION['redirect_to_assessment']);
    unset($_SESSION['take_assessment']);
}

// Check eligibility and attempts
$check_assessment = mysqli_query($conn, "SELECT * FROM assessment WHERE id = '$assessment_id'");
if (!$check_assessment || mysqli_num_rows($check_assessment) === 0) {
    header("Location: assessment_status?id=$assessment_id&type=unauthorized");
    exit();
}


$assessment = mysqli_fetch_assoc($check_assessment);

// Check if student's class is allowed
$student_class = get_class_id_by_student_id($student_id);
$allowed_classes = explode(',', $assessment['class_ids']);
if (!in_array($student_class, $allowed_classes)) {
    header("Location: assessment_status?id=$assessment_id&type=unauthorized");
    exit();
}
// echo "lk";

// Check if assessment is already completed
$result_check = mysqli_query($conn, "SELECT * FROM assessment_results 
    WHERE assessment_id = '$assessment_id' 
    AND student_id = '$student_id'");

if (mysqli_num_rows($result_check) > 0) {
    header("Location: assessment_status?id=$assessment_id&type=completed");
    exit();
}
// Check if attempt exists and its status
$attempt_check = mysqli_query($conn, "SELECT * FROM assessment_attempts 
    WHERE assessment_id = '$assessment_id' 
    AND student_id = '$student_id'");

if ($attempt = mysqli_fetch_assoc($attempt_check)) {
    if ($attempt['status'] === 'completed') {
        header("Location: assessment_status?id=$assessment_id&type=completed");
        exit();
    }
    if ($attempt['status'] === 'expired') {
        header("Location: assessment_status?id=$assessment_id&type=expired");
        exit();
    }

    // Get assessment duration
    $assessment_sql = "SELECT * FROM assessment WHERE id = '$assessment_id'";
    $assessment_result = mysqli_query($conn, $assessment_sql);
    $assessment = mysqli_fetch_assoc($assessment_result);

    $duration_minutes = $assessment['duration'];
    $total_time_seconds = $duration_minutes * 60;

    // Calculate time remaining
    if ($attempt['time_remaining'] > 0) {
        // Use stored time if available
        $time_left = $attempt['time_remaining'];
    } else {
        // Calculate from start time if no stored time
        $started_at = strtotime($attempt['start_time']);
        $time_elapsed = time() - $started_at;
        $time_left = $total_time_seconds - $time_elapsed;
    }

    if ($time_left <= 0 && $attempt['status'] !== 'in_progress') {
        // Update attempt status to expired only if not in progress
        mysqli_query($conn, "UPDATE assessment_attempts 
            SET status = 'expired', 
                completed_at = NOW() 
            WHERE id = '{$attempt['id']}'");

        header("Location: assessment_status?id=$assessment_id&type=expired");
        exit();
    }
} else {
    // Create new attempt
    mysqli_query($conn, "INSERT INTO assessment_attempts 
        (assessment_id, student_id, start_time, time_remaining, status) 
        VALUES ('$assessment_id', '$student_id', NOW(), 
        {$assessment['duration']} * 60, 'in_progress')");
}

// Get questions
$questions_sql = "SELECT * FROM questions WHERE ass_id = '$assessment_id'";
$questions_result = mysqli_query($conn, $questions_sql);
$total_questions = mysqli_num_rows($questions_result);
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Take Assessment - <?= htmlspecialchars($assessment['subject_name']) ?></title>
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <style>
        .question-nav {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(40px, 1fr));
            gap: 5px;
        }

        .question-nav button {
            width: 40px;
            height: 40px;
            border: 1px solid #ddd;
        }

        .question-nav .answered {
            background: #343a40;
            color: white;
        }

        .question-nav .current {
            border: 2px solid #007bff;
        }

        .question-nav .flagged {
            background: #ffc107;
            border:none !important
        }

        .timer {
            font-size: 24px;
            color: #000000;
            font-weight: bold;
        }

        .option-image {
            max-width: 100%;
            height: auto;
        }

        .flagged {
            background-color: #ffc107 !important;
            border-color: #ffc107 !important;
            color: #000 !important;
        }

        .answered {
            background-color: #343a40 !important;
            border-color: #343a40 !important;
            color: #fff !important;
        }

        .current {
            border: 2px solid #007bff !important;
        }

        .options p {
            margin-bottom: 0;
        }
    </style>
</head>

<body class="hold-transition">
    <div class="wrapper">
        <nav class="navbar navbar-expand navbar-white px-2">
            <div class="container">
                <span class="navbar-brand font-weight-bold"><?= htmlspecialchars(getsubjectbyid($assessment['subject_id'])) ?></span>
                <div class="ml-auto d-flex align-items-center">
                    <div class="timer mr-3" id="timer"></div>

                </div>
            </div>
        </nav>
        <div class="content-wrapper ml-0 pt-3 px-2" style="min-height: 590.4px; background-color: #f4f7fa; padding-bottom: 100px;">
            <div class="container mt-3">
                <div class="">
                    <div class="">
                        <div class="">
                            <div class="">
                                <div id="questionContainer"></div>
                                <!-- <div class="mt-4 text-center">
                                <button type="button" class="btn btn-danger btn-lg" onclick="submitExam()">Submit Assessment</button>
                            </div> -->
                                <hr>
                                <div class="d-flex">
                                    <button class="btn btn-secondary mr-2" id="prevBtn">Previous</button>
                                    <button class="btn btn-primary" id="nextBtn">Next</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="mt-5">
                        <div class="">
                            <div class="question-nav" id="questionNav"></div>
                            <hr>
                            <div class="text-center">
                                <button id="calculatorBtn" class="btn btn-outline-secondary mr-3" title="Open Calculator">
                        <i class="fas fa-calculator"></i> Calculator
                    </button>
                                <button class="btn btn-warning" id="flagBtn">Flag Question</button>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </div>

    <input type="hidden" id="durationSet" value="<?= $assessment['duration_set'] ?>">
    <input type="hidden" id="duration" value="<?= $assessment['duration'] ?>">
    <input type="hidden" id="totalQuestions" value="<?= $total_questions ?>">
    <input type="hidden" id="assessmentId" value="<?= $assessment_id ?>">

    <script src="../plugins/jquery/jquery.min.js"></script>
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script>
        const totalQuestions = parseInt($('#totalQuestions').val());
        let currentQuestion = 1;
        let answers = {};
        let flaggedQuestions = [];
        let autoSaveInterval;
        let timeLeft;
        // write an ajax query to load the question ids in object form [1:"question id", 2: "question id"]
        let questionIds = {};
        $.ajax({
            url: '../controller_new.php',
            method: 'POST',
            async: false,
            cache: true,
            data: {
                action: 'getQuestionIds',
                assessment_id: $('#assessmentId').val()
            },
            success: function(response) {
                questionIds = response; // Assuming response is in the format {1: "question id", 2: "question id"}
                console.log(questionIds);
            },
            error: function() {
                console.error('Failed to load question IDs');
            }
        });
    </script>
    <script src="../dist/js/examination.js?v=iok1q121tazlklk"></script>
    <script>
        // Setup calculator button
    document.getElementById('calculatorBtn').addEventListener('click', function() {
        
        // For Windows, we'll use the run command to open calc.exe
        try {
            window.open('ms-calculator:', '_blank');
        } catch (e) {
            // Fallback method
            const newWindow = window.open('about:blank', '_blank');
            if (newWindow) {
                newWindow.close(); // Close the blank window
                // Show a message to the user
                toastr.info('To open calculator: Press Windows + R, type "calc" and press Enter');
            } else {
                toastr.warning('Please allow popups to use the calculator');
            }
        }
    });
    document.addEventListener('DOMContentLoaded', function () {
    initExam();
    setupSecurityFeatures();

    // Add modal HTML to the page
    const modalHtml = `
        <div class="modal fade" id="submitConfirmModal" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Confirm Submission</h5>
                        <button type="button" class="close" data-dismiss="modal">
                            <span>&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        Are you sure you want to submit this assessment?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="confirmSubmit">Submit</button>
                    </div>
                </div>
            </div>
        </div>`;
    document.body.insertAdjacentHTML('beforeend', modalHtml);

    // Add modal submit handler
    document.getElementById('confirmSubmit').addEventListener('click', function () {
        $('#submitConfirmModal').modal('hide');
        processSubmission();
    });
});
        // ...existing code...

        // function submitExam() {
        //     if (confirm('Are you sure you want to submit this assessment? This action cannot be undone.')) {
        //         // Clear any autosave intervals
        //         clearInterval(autoSaveInterval);

        //         $.ajax({
        //             url: '../submit_assessment.php',
        //             method: 'POST',
        //             data: {
        //                 assessment_id: $('#assessmentId').val(),
        //                 answers: JSON.stringify(answers)
        //             },
        //             success: function(response) {
        //                 if (response.success) {
        //                     toastr.success('Assessment submitted successfully');
        //                     // Redirect to results page
        //                     window.location.href = 'assessment_result?id=' + response.result_id;
        //                 } else {
        //                     toastr.error(response.message || 'Error submitting assessment');
        //                 }
        //             },
        //             error: function() {
        //                 toastr.error('Network error occurred');
        //             }
        //         });
        //     }
        // }

        // Update the answer saving logic
        // $(document).on('change', 'input[name="answer"]', function() {
        //     const selectedValue = $(this).val();
        //     answers[currentQuestion] = selectedValue;
        //     updateNavigationPanel();
        //     saveProgress();

        //     // Also update the UI to show answered status
        //     const button = $(`.question-nav button:nth-child(${currentQuestion})`);
        //     button.addClass('answered');
        // });

        // ...existing code...
    </script>

</body>

</html>