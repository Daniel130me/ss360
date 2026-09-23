<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}
// echo $_SESSION['term_id'];
// echo $_SESSION['school_id'];
// echo $_SESSION['session_id'];
// echo $_SESSION['class_id'];
// echo $_SESSION['userid'];
// exit;
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
?>
<!DOCTYPE html>

<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Assignments</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <!-- Add the new sidebar CSS -->
    <!-- <link rel="stylesheet" href="../css/sidebar.css"> -->
     <style>
        body {
            background: linear-gradient(135deg, #e0e7ff 0%, #f8fafc 100%);
            min-height: 100vh;
        }
        .user-panel img {
            border: 2px solid #6366f1;
            box-shadow: 0 2px 8px rgba(99,102,241,0.15);
        }
        .hero-section {
            background: linear-gradient(120deg, #000000 0%, #818cf8 100%);
            color: #fff;
            /* border-radius: 24px; */
            padding: 40px 30px 30px 30px;
            margin-bottom: 40px;
            box-shadow: 0 8px 32px rgba(99,102,241,0.12);
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .hero-section h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }
        .hero-section p {
            font-size: 1.2rem;
            opacity: 0.95;
        }
        .hero-section::after {
            content: '';
            position: absolute;
            right: -60px;
            top: -60px;
            width: 180px;
            height: 180px;
            background: rgba(255,255,255,0.08);
            border-radius: 50%;
            z-index: 0;
        }
         .fade-in {
            opacity: 0;
            animation: fadeIn 1.2s ease-in forwards;
        }
        @keyframes fadeIn {
            to { opacity: 1; }
        }
        .assignment-card {
            transition: all 0.3s ease;
            border: 0;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .assignment-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 20px rgba(0,0,0,0.12);
        }
        .assignment-card .card-header {
            background-color: #f8f9fa;
            border-bottom: 1px solid #e9ecef;
        }
        .assignment-card .card-title {
            font-weight: 600;
            color: #495057;
        }
        .instruction-container {
            position: relative;
        }
        .instruction-text {
            max-height: 4.5em; /* Approx 3 lines */
            overflow: hidden;
            transition: max-height 0.3s ease-out;
            position: relative;
        }
        .instruction-text.expanded {
            max-height: 500px; /* Large enough to show all content */
        }
        .read-more {
            cursor: pointer;
        }
     </style>
   
</head>

<body class="hold-transition sidebar-mini">
    <div class="wrapper">

      

        <!-- Content Wrapper. Contains page content -->
        <!-- <input type="hidden" id="report_page" value="report_scores">
        <div class="content-wrapper" style="min-height: 590.4px; background-color: #f4f7fa; padding-bottom: 100px;">
<input type="hidden" name="session_id" id="select_session_field" value="<?= $_SESSION['session_id'] ?>">
<input type="hidden" name="class_id" id="select_class_field" value="<?= $_SESSION['class_id'] ?>">
<input type="hidden" name="term_id" id="select_term_field" value="<?= $_SESSION['term_id'] ?>">
<input type="hidden" name="student_id" id="select_student_field" value="<?= $_SESSION['userid'] ?>"> -->

        <!-- Main content -->
        <div class="content fade-in">
                <div class="hero-section d-flex flex-column align-items-center justify-content-center" style="position: relative;">
                    <div style="position: absolute; top: 20px; right: 30px; z-index:1;">
                        <a href="logout" title="Logout" style="color: #fff;">
                            <span class="material-symbols-outlined" style="font-size: 2.2rem; vertical-align: middle;">logout</span>
                        </a>
                    </div>
                    <img src="<?php echo isset($_SESSION['photo']) ? '../uploads/'.$_SESSION['photo'] : '../dist/img/avatar.png'; ?>" alt="Profile" style="width: 80px; height: 80px; object-fit: cover; border-radius: 50%; box-shadow: 0 2px 8px rgba(99,102,241,0.15); margin-bottom: 18px; border: 3px solid #fff;">
                    <h1>Assignments</h1>
                    <p>Your personalized space for all your assignments.</p>
                </div>
            <div class="container">
               

                <div class="card-body">
                    <div id="assignment" class="row">
                        <!-- Ajax populated content will go here -->
                    </div>
                </div>

                <!-- /.row -->
            </div>
            <!--/. container-fluid -->
        </div>
        <!-- /.row -->
    </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->

    </div>
    <!-- ./wrapper -->

    <!-- REQUIRED SCRIPTS -->

    <!-- jQuery -->
    <script src="../plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- Select2 -->
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <script src="../dist/js/skul.js"></script>
</body>
<script>
    var skul_settings = <?= $_SESSION['skul_settings'] ?>;
    get_notices('<?= $_SESSION['userid'] ?>', '1');
    loadSettings().done(() => {

        get_score_data()
    });
</script>
<script>
        // current student id available to JS for blacklist checks
    const currentStudentId = '<?= $_SESSION['userid'] ?>';
    // Add this after existing scripts
    $(document).ready(function() {
        loadAssignments();
    });

    function loadAssignments() {
        $.ajax({
            url: '../controller_new.php',
            type: 'POST',
            data: {
                action: 'get_student_assignments',
                class_id: '<?= $_SESSION['class_id'] ?>',
                student_id: '<?= $_SESSION['userid'] ?>'
            },
            success: function(response) {
                if (response.success) {
                    let html = '';
                    if (response.assignments.length === 0) {
                        html = '<div class="col-12"><div class="alert alert-info text-center">No assignments available at the moment.</div></div>';
                    } else {
                        response.assignments.forEach(function(assignment) {
                             // If the assignment has a blacklist_students string, check if the current student is blacklisted
                            if (assignment.blacklist_students) {
                                // create an array of ids (trim to be safe)
                                const blacklisted = assignment.blacklist_students.split(',').map(s => s.trim()).filter(Boolean);
                                if (blacklisted.indexOf(currentStudentId) !== -1) {
                                    // skip rendering this assignment for the current student
                                    return;
                                }
                            }
                            // Determine if deadline is active (deadline_date + deadline_time in future)
                            function isDeadlineActive(deadlineDate, deadlineTime) {
                                if (!deadlineDate) return true; // no deadline means always active
                                // If deadline_time is empty, treat as end of day
                                const timePart = deadlineTime ? deadlineTime : '23:59:59';
                                const dt = new Date(deadlineDate + ' ' + timePart);
                                console.log("another",deadlineDate + ' ' + timePart);
                                console.log("datteime", dt.getTime() > Date.now())
                                return dt.getTime() > Date.now();
                                
                            }

                            const showTakeButton = isDeadlineActive(assignment.deadline_date, assignment.deadline_time);

                            html += `
                            <div class="col-lg-4 col-md-6 d-flex align-items-stretch">
                                <div class="card assignment-card w-100 mb-4">
                                    <div class="card-header">
                                        <h5 class="card-title mb-0">${assignment.subject}</h5>
                                    </div>
                                    <div class="card-body d-flex flex-column">
                                        <div class="card-text">
                                            <div class="instruction-container">
                                                <p class="text-muted instruction-text" id="instruction-${assignment.id}">
                                                    ${assignment.instruction ? `<strong>Instructions:</strong> ${assignment.instruction}` : 'No instructions provided.'}
                                                </p>
                                            </div>
                                            <hr>
                                            <div class="d-flex justify-content-between text-muted small mb-2">
                                                <span><i class="fas fa-clock mr-1"></i> Duration</span>
                                                <strong>${assignment.duration_set ? formatDurationText(assignment.duration) : 'No time limit'}</strong>
                                            </div>
                                            <div class="d-flex justify-content-between text-muted small mt-2">
                                                <span><i class="fas fa-calendar-alt mr-1"></i> Deadline</span>
                                                <strong>${formatDateTime(assignment.deadline_date, assignment.deadline_time)}</strong>
                                            </div>
                                            ${assignment.deadline_set ? `<div class="d-flex justify-content-between text-muted small mt-2"><span><i class="fas fa-hourglass-half mr-1"></i> Time Remaining</span><strong>${formatTimeRemaining(assignment.deadline_date, assignment.deadline_time)}</strong></div>` : ''}
                                             ${assignment.show_score == '1' && assignment.percentage_score !== null ?
                                                `<div class="d-flex justify-content-between text-muted small mt-2">
                                                    <span><i class="fas fa-poll mr-1"></i> Result</span>
                                                    <strong>${assignment.student_score}/${assignment.total_questions} (${parseFloat(assignment.percentage_score).toFixed(1)}%)</strong>
                                                </div>`
                                            : ''}
                                        </div>
                                        <div class="mt-auto pt-3">
                                            ${assignment.has_attempted
                                                ? `<div class="alert alert-success text-center mb-0 py-2"><i class="fas fa-check-circle mr-1"></i> Completed</div>`
                                                : showTakeButton ?
                                                `<button type="button" onclick="takeAssessment(${assignment.id})" class="btn btn-primary btn-block">
                                                    <i class="fas fa-play-circle mr-1"></i> Take Assessment
                                                </button>`
                                            : ``
                                            }
                                        </div>
                                    </div>
                                </div>
                            </div>
                        `;
                        });
                    }
                    $('#assignment').html(html);
                } else {
                    $('#assignment').html('<div class="col-12"><div class="alert alert-danger">Error loading assignments. Please try again.</div></div>');
                }

                // After rendering, check for overflowing instructions
                response.assignments.forEach(function(assignment) {
                    if (assignment.instruction) {
                        const p = document.getElementById(`instruction-${assignment.id}`);
                        if (p && p.scrollHeight > p.clientHeight) {
                            const readMore = document.createElement('a');
                            readMore.innerText = 'Read more';
                            readMore.className = 'read-more text-primary small';
                            readMore.href = '#';
                            p.parentElement.appendChild(readMore);
                            readMore.addEventListener('click', function(e) {
                                e.preventDefault();
                                p.classList.toggle('expanded');
                                this.innerText = p.classList.contains('expanded') ? 'Read less' : 'Read more';
                            });
                        }
                    }
                });
            }
        });
    }

    function formatDateTime(date, time) {
        if (!date) {
            return 'No deadline';
        }
        let dateObj = new Date(date + ' ' + time);
        return dateObj.toLocaleString();
    }

    function formatTimeRemaining(deadlineDate, deadlineTime) {
        if (!deadlineDate) {
            return 'N/A';
        }

        const timePart = deadlineTime ? deadlineTime : '23:59:59';
        const deadline = new Date(`${deadlineDate} ${timePart}`).getTime();
        const now = new Date().getTime();
        const difference = deadline - now;

        if (difference < 0) {
            return '<span class="text-danger">Deadline Passed</span>';
        }

        const days = Math.floor(difference / (1000 * 60 * 60 * 24));
        const hours = Math.floor((difference % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
        const minutes = Math.floor((difference % (1000 * 60 * 60)) / (1000 * 60));

        let remainingString = '';
        if (days > 0) remainingString += `${days}d `;
        if (hours > 0) remainingString += `${hours}h `;
        if (minutes > 0) remainingString += `${minutes}m`;

        return remainingString.trim() + ' left';
    }




    function formatDuration(minutes) {
        const hours = Math.floor(minutes / 60);
        const remainingMinutes = minutes % 60;
        if (hours > 0) {
            return `${hours}:${remainingMinutes.toString().padStart(2, '0')}:00`;
        }
        return `${remainingMinutes}:00`;
    }

    function formatDurationText(minutes) {
        const hours = Math.floor(minutes / 60);
        const remainingMinutes = minutes % 60;
        if (hours > 0) {
            return `${hours} hour${hours > 1 ? 's' : ''}${remainingMinutes > 0 ? ` and ${remainingMinutes} minute${remainingMinutes > 1 ? 's' : ''}` : ''}`;
        }
        return `${remainingMinutes} minute${remainingMinutes > 1 ? 's' : ''}`;
    }

    function takeAssessment(id) {
        window.location.href = 'take_assessment?id=' + id;
    }
</script>

</html>
