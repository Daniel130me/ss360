<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}
if (!isset($_SESSION['userid']) || $_SESSION['user_type'] !== 'student') {
    header("Location: login");
    exit();
}

$assessment_id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
$student_id = $_SESSION['userid'];

include_once("model/connect.php");
include_once("model/functions.php");

// Get current student info
$school_id = (int)$_SESSION['school_id'];
$student_stmt = $conn->prepare(
    'SELECT firstname, lastname, middlename, admission_no, class_id
     FROM students WHERE id = ? AND school_id = ? AND status = 1 LIMIT 1'
);
$student_stmt->bind_param('ii', $student_id, $school_id);
$student_stmt->execute();
$student_info = $student_stmt->get_result()->fetch_assoc();
$student_stmt->close();

if (!$student_info) {
    header("Location: assessment_status?id=$assessment_id&type=unauthorized");
    exit();
}
$student_fullname = $student_info ? trim($student_info['firstname'] . ' ' . $student_info['lastname'] . ' ' . $student_info['middlename']) : '';
$admission_no = $student_info['admission_no'] ?? '';
$class_name = $student_info ? get_class_by_classid($student_info['class_id']) : '';

// Get assessment info
$assessment_stmt = $conn->prepare(
    'SELECT a.*, s.subject
     FROM assessment a
     INNER JOIN subjects s ON a.subject_id = s.id
     WHERE a.id = ? AND a.school_id = ? LIMIT 1'
);
$assessment_stmt->bind_param('ii', $assessment_id, $school_id);
$assessment_stmt->execute();
$assessment = $assessment_stmt->get_result()->fetch_assoc();
$assessment_stmt->close();

$allowedClasses = $assessment
    ? array_filter(array_map('intval', explode(',', (string)$assessment['class_ids'])))
    : [];
if (!$assessment || !in_array((int)$student_info['class_id'], $allowedClasses, true)) {
    header("Location: assessment_status?id=$assessment_id&type=unauthorized");
    exit();
}

// Get question count
$question_stmt = $conn->prepare(
    'SELECT COUNT(*) AS total FROM questions WHERE ass_id = ? AND deleted = 0'
);
$question_stmt->bind_param('i', $assessment_id);
$question_stmt->execute();
$question_count = (int)$question_stmt->get_result()->fetch_assoc()['total'];
$question_stmt->close();

$blacklistedStudents = array_filter(array_map(
    'intval',
    explode(',', (string)($assessment['blacklist_students'] ?? ''))
));
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Assessment Instructions - <?= htmlspecialchars($assessment['subject']) ?></title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="../dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f4f6f9;
            /* Light gray background */
            color: #333;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }

        .instruction-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            width: 90%;
            padding: 30px;
            margin: 20px;
        }

        .card-header {
            background-color: #007bff;
            /* Primary blue */
            color: #fff;
            border-radius: 10px 10px 0 0;
            padding: 20px;
            text-align: center;
        }

        .card-title {
            font-weight: 500;
            font-size: 1.5rem;
            margin-bottom: 0;
        }

        .assessment-details {
            background-color: #e9f5ff;
            /* Light blue */
            color: #0056b3;
            /* Darker blue */
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 1.1rem;
        }

        .assessment-details strong {
            font-weight: 500;
        }

        .instruction-list {
            list-style-type: none;
            padding: 0;
            margin-bottom: 20px;
        }

        .instruction-list li {
            margin-bottom: 15px;
            padding-left: 30px;
            position: relative;
            font-size: 1.05rem;
            line-height: 1.6;
        }

        .instruction-list li::before {
            content: '\f058';
            /* Checkmark icon */
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            position: absolute;
            left: 0;
            color: #28a745;
            /* Green */
        }

        .warning-alert {
            background-color: #fff3cd;
            /* Light yellow */
            color: #856404;
            /* Dark yellow */
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 1.05rem;
        }

        .warning-alert strong {
            font-weight: 500;
        }

        .start-button {
            background-color: #28a745;
            /* Green */
            color: #fff;
            border: none;
            padding: 15px 30px;
            border-radius: 8px;
            font-size: 1.2rem;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .start-button:hover {
            background-color: #218838;
            /* Darker green */
        }

        .icon-container {
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 20px;
        }

        .icon-container i {
            font-size: 4rem;
            color: #007bff;
        }
        .icon-container i {
            font-size: 4rem;
            color: #007bff;
        }

        .no-access-container {
            text-align: center;
            padding: 40px;
        }

        .no-access-icon {
            font-size: 5rem;
            color: #dc3545;
            /* Red for emphasis */
            margin-bottom: 20px;
        }

        .no-access-message {
            font-size: 1.5rem;
            font-weight: 500;
            color: #333;
        }
    </style>
</head>

<body>
    <div class="instruction-card">
        <?php if (in_array((int)$student_id, $blacklistedStudents, true)) { ?>
            <div class="no-access-container">
                <div class="no-access-icon">
                    <i class="fas fa-ban"></i>
                </div>
                <p class="no-access-message">You do not have access to this assessment.</p>
                <p>Please contact your administrator if you believe this is an error.</p>
            </div>
        <?php exit;
        } ?>
        <div class="card-header d-flex flex-column">
            <h3 class="card-title">
                <i class="fas fa-book-open mr-2"></i>
                <?= htmlspecialchars($assessment['subject']) ?> Assessment Instructions
            </h3>
            <div class="student-info" style="margin-top:8px;font-size:0.95rem;color:#f1f1f1;">
                
                <?= htmlspecialchars($student_fullname) ?> &nbsp; | &nbsp; Class: <?= htmlspecialchars($class_name) ?> &nbsp; | &nbsp; ADM No: <?= htmlspecialchars(strtoupper($admission_no)) ?>
            </div>
        </div>
        <div class="card-body">
            <div class="icon-container">
                <i class="fas fa-clipboard-list"></i>
            </div>
            <div class="assessment-details">
                <strong>Assessment Details:</strong><br>
                <i class="fas fa-clock mr-1"></i> Duration: <?php
                                                            $hours = floor($assessment['duration'] / 60);
                                                            $minutes = $assessment['duration'] % 60;
                                                            if ($hours > 0) {
                                                                echo $hours . ':' . str_pad($minutes, 2, '0', STR_PAD_LEFT) . ':00';
                                                            } else {
                                                                echo $minutes . ':00';
                                                            }
                                                            ?><br>
                <i class="fas fa-question-circle mr-1"></i> Total Questions: <?= $question_count ?>
            </div>

            <h5><i class="fas fa-info-circle mr-2"></i> Important Instructions:</h5>
            <?php if($assessment['instruction'] != ''){ ?>
            <div style="padding: 15px; background-color: #fbfffb; border-radius: 10px; margin: 20px 0 20px 0;"><?=$assessment['instruction']?></div>
            <?php } ?>
            <ul class="instruction-list">
                <li>This assessment contains <?= $question_count ?> questions and must be completed within <?php
                                                                                                            if ($hours > 0) {
                                                                                                                echo $hours . ' hour' . ($hours > 1 ? 's' : '') . ($minutes > 0 ? ' and ' . $minutes . ' minute' . ($minutes > 1 ? 's' : '') : '');
                                                                                                            } else {
                                                                                                                echo $minutes . ' minute' . ($minutes > 1 ? 's' : '');
                                                                                                            }
                                                                                                            ?>.</li>
                <li>Once you start the assessment, the timer cannot be paused.</li>
                <li>Do not close the browser window or navigate away from the assessment page.</li>
                <li>Switching browser tabs or windows may result in automatic submission.</li>
                <li>Ensure you have a stable internet connection before starting.</li>
                <li>Use the "Flag Question" button to mark questions for review.</li>
                <li>Your answers are automatically saved as you progress.</li>
                <li>You can review and change your answers before final submission.</li>
                <li>Click "Submit" when you're done or wait for auto-submission when time expires.</li>
            </ul>

            <div class="warning-alert">
                <strong><i class="fas fa-exclamation-triangle mr-2"></i> Warning:</strong> Any violation of exam rules may result in automatic submission or disqualification.
            </div>

            <div class="text-center mt-4">
                <button onclick="markInstructionsViewed()" class="start-button">
                    <i class="fas fa-play mr-2"></i> Start Assessment Now
                </button>
            </div>
        </div>
    </div>
    <script src="../plugins/jquery/jquery.min.js"></script>
    <script>
        function markInstructionsViewed() {
            const assessmentId = <?= $assessment_id ?>;
            $.ajax({
                url: '../controller_new.php',
                method: 'POST',
                data: {
                    action: 'mark_instructions_viewed',
                    assessment_id: assessmentId
                },
                success: function(response) {
                    if (response.status === 'success') {
                        window.location.href = 'take_assessment?id=' + assessmentId;
                    } else {
                        alert('Failed to start assessment');
                    }
                },
                error: function() {
                    alert('Failed to start assessment');
                }
            });
        }
    </script>
</body>

</html>
