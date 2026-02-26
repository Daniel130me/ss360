<?php
session_start();
if (!isset($_SESSION['userid']) || $_SESSION['user_type'] !== 'student') {
    header("Location: login");
    exit();
}

$assessment_id = isset($_GET['id']) ? (int)$_GET['id'] : 0;
$student_id = $_SESSION['userid'];

include_once("model/connect.php");
include_once("model/functions.php");

// Get assessment info
$sql = "SELECT a.*, s.subject 
        FROM assessment a 
        JOIN subjects s ON a.subject_id = s.id 
        WHERE a.id = '$assessment_id'";
$result = mysqli_query($conn, $sql);
$assessment = mysqli_fetch_assoc($result);

// Get question count
$questions_sql = "SELECT COUNT(*) as total FROM questions WHERE ass_id = '$assessment_id'";
$questions_result = mysqli_query($conn, $questions_sql);
$question_count = mysqli_fetch_assoc($questions_result)['total'];
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
        <?php if (in_array($student_id, explode(',', $assessment['blacklist_students']))) { ?>
            <div class="no-access-container">
                <div class="no-access-icon">
                    <i class="fas fa-ban"></i>
                </div>
                <p class="no-access-message">You do not have access to this assessment.</p>
                <p>Please contact your administrator if you believe this is an error.</p>
            </div>
        <?php exit;
        } ?>
        <div class="card-header">
            <h3 class="card-title">
                <i class="fas fa-book-open mr-2"></i>
                <?= htmlspecialchars($assessment['subject']) ?> Assessment Instructions
            </h3>
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
new_string:
        .no-access-message {
            font-size: 1.5rem;
            font-weight: 500;
            color: #333;
        }
    </style>
</head>

<body>
    <div class="instruction-card">
        <?php if (in_array($student_id, explode(',', $assessment['blacklist_students']))) { ?>
            <div class="no-access-container">
                <div class="no-access-icon">
                    <i class="fas fa-ban"></i>
                </div>
                <p class="no-access-message">You do not have access to this assessment.</p>
                <p>Please contact your administrator if you believe this is an error.</p>
            </div>
        <?php exit;
        } ?>
old_string:
        .no-access-message {
            font-size: 1.5rem;
            font-weight: 500;
            color: #333;
        }
    </style>
</head>

<body>
    <div class="instruction-card">
        <?php if (in_array($student_id, explode(',', $assessment['blacklist_students']))) { ?>
            <div class="no-access-container">
                <div class="no-access-icon">
                    <i class="fas fa-ban"></i>
                </div>
                <p class="no-access-message">You do not have access to this assessment.</p>
                <p>Please contact your administrator if you believe this is an error.</p>
            </div>
        <?php exit;
        } ?>