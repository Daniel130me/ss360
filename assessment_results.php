<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}

include_once("model/connect.php");
include_once("model/functions.php");
include_once("model/assessment_editor.php");

try {
    $staffContext = assessment_editor_require_staff();
} catch (Throwable $error) {
    http_response_code(403);
    exit('You are not authorized to view assessment results.');
}

$assessment_id = isset($_GET['id']) ? intval($_GET['id']) : 0;
// Accept single or comma-separated class IDs (e.g. ?class_id=45 or ?class_id=45,44)
$class_id_raw = isset($_GET['class_id']) ? $_GET['class_id'] : '';
$class_ids = [];
if ($class_id_raw !== '') {
    // split on comma, cast to int and keep only positive ints
    $parts = explode(',', $class_id_raw);
    foreach ($parts as $p) {
        $v = intval($p);
        if ($v > 0) $class_ids[] = $v;
    }
}
if (empty($class_ids)) {
    // fallback to a non-matching id to avoid accidental full-table matches
    $class_ids = [0];
}
$class_id_list = implode(',', $class_ids);

// Get assessment details

$assessmentStmt = $conn->prepare(
    'SELECT a.*, s.subject FROM assessment a
     JOIN subjects s ON a.subject_id = s.id
     WHERE a.id = ? AND a.school_id = ? LIMIT 1'
);
$assessmentStmt->bind_param('ii', $assessment_id, $staffContext['school_id']);
$assessmentStmt->execute();
$assessment = $assessmentStmt->get_result()->fetch_assoc();
$assessmentStmt->close();
if (!$assessment) {
    http_response_code(404);
    exit('Assessment not found.');
}

// Get all students who haven't attempted


// Students who haven't attempted in any of the selected classes
$not_attempted_query = "SELECT s.id, s.firstname, s.lastname, c.classname 
                       FROM students s 
                       LEFT JOIN class c ON s.class_id = c.id
                       LEFT JOIN assessment_results ar ON s.id = ar.student_id AND ar.assessment_id = $assessment_id
                       WHERE s.school_id = {$staffContext['school_id']}
                         AND s.class_id IN ($class_id_list) AND ar.id IS NULL";
$not_attempted = $conn->query($not_attempted_query)->fetch_all(MYSQLI_ASSOC);

// Get results with filters

// Build results filter and include class filter so results are limited to the selected classes
$where = "WHERE ar.assessment_id = $assessment_id
          AND s.school_id = {$staffContext['school_id']}
          AND s.class_id IN ($class_id_list)";
if (isset($_GET['score_min'])) {
    $score_min = floatval($_GET['score_min']);
    $where .= " AND ar.percentage_score >= $score_min";
}
if (isset($_GET['score_max'])) {
    $score_max = floatval($_GET['score_max']);
    $where .= " AND ar.percentage_score <= $score_max";
}
$requested_sort = isset($_GET['sort']) ? $_GET['sort'] : '';
// whitelist allowed sort values to avoid SQL injection
$allowed_sorts = [
    'submitted_at DESC',
    'percentage_score DESC',
    'percentage_score ASC'
];
$order_by = in_array($requested_sort, $allowed_sorts, true) ? $requested_sort : 'submitted_at DESC';
$results_query = "SELECT ar.*, s.firstname, s.lastname 
                 FROM assessment_results ar
                 JOIN students s ON ar.student_id = s.id 
                 $where
                 ORDER BY $order_by";
$results = $conn->query($results_query)->fetch_all(MYSQLI_ASSOC);

// Calculate class average

$avg_query = "SELECT AVG(percentage_score) as avg_score 
              FROM assessment_results 
              WHERE assessment_id = $assessment_id";
$avg_score = $conn->query($avg_query)->fetch_assoc()['avg_score'];
?>

<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Assessment Result</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Select2 -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/css/select2.min.css" rel="stylesheet" />
    <!-- summernote -->
    <link rel="stylesheet" href="../plugins/summernote/summernote-bs4.min.css">
    <!-- <link rel="stylesheet" href="../plugins/select2/css/select2.min.css"> -->
    <!-- daterange picker -->
    <link rel="stylesheet" href="../plugins/daterangepicker/daterangepicker.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.9.3/dropzone.min.css">
    <style>
        .accent_active {
            background-color: #007bff;
            color: white;
        }
    </style>
</head>

<body class="hold-transition sidebar-mini">
    <div class="wrapper">

        <!-- Navbar -->
        <nav class="main-header navbar border-bottom-0 navbar-expand justify-content-between bg1">
            <!-- <div class=""> -->

            <!-- Left navbar links -->
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i
                            class="muted-text fas fa-bars"></i></a>
                </li>

            </ul>

            <!-- Right navbar links -->
            <ul class="navbar-nav align-items-center">
                <li class="nav-item dropdown">
                    <a class="" data-toggle="dropdown" href="#" style="height: auto;">
                        <div class="user-panel d-flex align-items-center">
                            <span class="material-symbols-outlined">arrow_drop_down</span>
                            <div class="image pl-0">
                                <img src="../uploads/<?= $_SESSION['staff_photo'] ?>" class="img-circle elevation-2" alt="User Image">
                            </div>
                            <div class="info d-none d-sm-inline-block">
                                <p style="font-size: 14px;" class="mb-0 d-block">
                                    <?= $_SESSION['firstname'] . ' ' . $_SESSION['lastname'] ?></p>
                                <p style="font-size: 12px;" class="d-block mb-0 accent">
                                    <?= get_staff_type_in_name($_SESSION['staff_type']) ?>
                                </p>
                            </div>
                        </div>
                    </a>
                    <div class="dropdown-menu dropdown-menu-sm dropdown-menu-right p-2" style="border-radius: 10px;">
                        <a href="profile" class="dropdown-item text-muted d-flex">
                            <i class="material-symbols-outlined mr-2 d-inline">person</i> Profile
                        </a>
                        <a href="change_password" class="dropdown-item text-muted d-flex">
                            <span class="material-symbols-outlined mr-2">lock</span> Change PIN
                        </a>
                        <?php
                        if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                        ?>
                            <a href="my_payment" class="dropdown-item text-muted d-flex">
                                <span class="material-symbols-outlined mr-2">payments</span> Billing
                            </a>
                        <?php
                        } ?>
                        <a href="logout" class="dropdown-item text-muted d-flex">
                            <span class="material-symbols-outlined mr-2">logout</span> Logout
                        </a>
                    </div>
                </li>
            </ul>
            <!-- </div> -->
        </nav>
        <!-- /.navbar -->

        <!-- Main Sidebar Container -->
        <!-- Main Sidebar Container -->
        <aside class="main-sidebar sidebar-light-primary elevation-4">
            <!-- Brand Logo -->
            <a href="" class="brand-link">
                <img src="../uploads/<?= $_SESSION['logo'] ?>" alt="<?= $_SESSION['school_name'] ?>" class="brand-image" style="opacity: .8">
                <span class="brand-text font-weight-light" style="visibility: hidden;">Rus</span>
            </a>


            <!-- <div href="" class="px-15 pt-15 border-bottom" style="padding-bottom: 30px;">
                <img src="../uploads/<= $_SESSION['logo'] ?>" style="height: 200px; object-fit:cover;" alt="Logo"
                    class="brand-image img-circle elevation-5 w-100">
            </div> -->
            <div href="" class="py-2 px-15">
                <p class="font-weight-bold text-tertiary"><?= $_SESSION['school_name'] ?></p>
            </div>

            <!-- Sidebar -->
            <div class="sidebar">

                <!-- Sidebar Menu -->
                <nav class="mt-2">
                    <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu"
                        data-accordion="false">

                        <li class="nav-item">
                            <a href="dashboard" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">dashboard</i>
                                    Dashboard
                                </p>
                            </a>
                        </li>
                        <?php
                        if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                        ?>
                            <li class="nav-item">
                                <a href="settings" class="nav-link">
                                    <p class="d-flex">
                                        <i class="material-symbols-outlined pr-2">tune</i>
                                        Settings
                                    </p>
                                </a>
                            </li>
                        <?php
                        }
                        ?>
                        <li class="nav-item">
                            <a href="staff" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">supervisor_account</i>
                                    Staff
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="subjects" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">responsive_layout</i>
                                    Subjects
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="class" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">app_registration</i>
                                    Classes
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="students" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">supervisor_account</i>
                                    Students
                                </p>
                            </a>
                        </li>


                        <li class="nav-item">
                            <a href="post_scores" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">add_chart</i>
                                    Post Scores
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="view_scores" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">signal_cellular_alt</i>
                                    View Scores
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="comment" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">comment</i>
                                    Comments
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="attendance" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">list</i>
                                    Attendance
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="staff_attendance" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">add_chart</i>
                                    Staff Attendance
                                </p>
                            </a>
                        </li>
                        <?php if ($_SESSION['school_id'] == 27 || $_SESSION['school_id'] == 13) {  ?>
                            <li class="nav-item">
                                <a href="lesson_note" class="nav-link">
                                    <p class="d-flex">
                                        <i class="material-symbols-outlined pr-2">list</i>
                                        Lesson Note
                                    </p>
                                </a>
                            </li>
                        <?php } ?>
                        <li class="nav-item">
                            <a href="assessment" class="nav-link active">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">app_registration</i>
                                    Assessments
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="payments" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">payments</i>
                                    Payments
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="time_table" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">list</i>
                                    Time Table
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="communication" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2" style="font-size: 20px;">hub</i>
                                    Communication
                                </p>
                            </a>
                        </li>
                        <!--<li class="nav-item">-->
                        <!--    <a href="reports" class="nav-link">-->
                        <!--        <p class="d-flex">-->
                        <!--            <i class="material-symbols-outlined pr-2">list</i>-->
                        <!--            Reports-->
                        <!--        </p>-->
                        <!--    </a>-->
                        <!--</li>-->
                    </ul>
                </nav>
                <!-- /.sidebar-menu -->
            </div>
            <a href="" class="brand-link" style="background:white; position: fixed; bottom:0;">
                <img src="../dist/img/company_logo.png" alt="Schoolsuite360" class="brand-image img-circle elevation-3" style="opacity: .8">
                <span class="brand-text font-weight-light">Schoolsuite360</span>
            </a>
            <!-- /.sidebar -->
        </aside>
        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper" style="min-height: 590.4px; background-color: #f4f7fa; padding-bottom: 100px;">


            <div class="container-fluid pt-3">
                <div class="row m-0">
                    <div class="col-sm-6 row ml-0">
                        <div class="mr-2">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <a href="assessment" class="accent">Back</a>
                                <!-- <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i></a> -->
                            </div>
                        </div>
                        <div class="">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="">
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>
                                            </a>
                                        </li>
                                        <li class="breadcrumb-item active font-14"><a href="assessment">assessment</a></li>
                                        <li class="breadcrumb-item active font-14">Result</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Main content -->
            <section class="content">
                <div class="container-fluid mb-2 pt-3">
                    <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                        <p class="mb-3" style="font-size: 20px;"><?php echo htmlspecialchars($assessment['subject']); ?> Assessment Results</p>
                        <!-- Class Statistics -->
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-body">
                                        <h5>Class Average</h5>
                                        <h3><?php echo number_format((float)($avg_score ?? 0), 1); ?>%</h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-body">
                                        <h5>Total Attempts</h5>
                                        <h3><?php echo count($results); ?></h3>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-body">
                                        <h5>Not Attempted</h5>
                                        <h3><?php echo count($not_attempted); ?></h3>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Results Table -->
                        <table id="results-table" class="table table-striped" style="width: 100%;">
                            <thead>
                                <tr>
                                    <th>Student Name</th>
                                    <th>Score</th>
                                    <th>Questions Attempted</th>
                                    <th>Percentage</th>
                                    <th>Submitted At</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($results as $result): ?>
                                    <tr>
                                        <td><?php echo htmlspecialchars($result['firstname'] . ' ' . $result['lastname']); ?></td>
                                        <td><?php echo $result['score']; ?>/<?php echo $result['total_questions']; ?></td>
                                        <td>
                                            <?php
                                            $answers_array = json_decode($result['answers'], true);
                                            echo is_array($answers_array) ? count($answers_array) : 0;
                                            ?>
                                        </td>
                                        <td><?php echo number_format($result['percentage_score'], 1); ?>%</td>
                                        <td><?php echo date('Y-m-d H:i', strtotime($result['submitted_at'])); ?></td>
                                        <td>
                                            <a href="view_student_result?id=<?php echo $result['id']; ?>"
                                                class="btn btn-sm btn-primary m-1">View Details</a>
                                            <button type="button" onclick="launch_modal_reset_assessment('<?= $result['assessment_id'] ?>','<?= $result['student_id'] ?>')" class="btn btn-sm btn-danger">Reset Assessment</button>

                                        </td>
                                    </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="container-fluid">

                    <!-- Not Attempted List -->
                    <div class="card mt-4">
                        <div class="card-header">
                            <p class="font-weight-bold">Students Yet to Attempt</p>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <?php foreach ($not_attempted as $student): ?>
                                    <div class="col-md-4">
                                        <div class="card mb-3">
                                            <div class="card-body">
                                                <h5 class="card-title"><?php echo htmlspecialchars($student['firstname'] . ' ' . $student['lastname']); ?></h5>
                                                <p class="card-text">Class: <?php echo htmlspecialchars($student['classname']); ?></p>
                                                <!-- button to blacklist student from attempting the assessment -->
                                                <?php
                                                $blacklistedStudents = array_filter(array_map(
                                                    'intval',
                                                    explode(',', (string)($assessment['blacklist_students'] ?? ''))
                                                ));
                                                $is_blacklisted = in_array((int)$student['id'], $blacklistedStudents, true);
                                                $button_class = $is_blacklisted ? 'btn-success' : 'btn-danger';
                                                $button_text = $is_blacklisted ? 'Allow Attempt' : 'Disallow Attempt';
                                                $button_data_status = $is_blacklisted ? 0 : 1;
                                                ?>
                                                <button type="button" data-status="<?php echo $button_data_status; ?>" onclick="disallow_attempt(this,'<?= $assessment_id ?>','<?= $student['id'] ?>')" class="btn btn-sm <?php echo $button_class; ?> float-right"><?php echo $button_text; ?></button>
                                            </div>
                                        </div>
                                    </div>
                                <?php endforeach; ?>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>
    <div class="modal fade" id="reset_assessment_modal" tabindex="-1" role="dialog" aria-labelledby="reset_assessment_modal_label" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body">
                    <input type="hidden" id="assessment_id" value="">
                    <input type="hidden" id="student_id" value="">
                    <p class="mb-3">Are you sure to reset the assessment?</p>
                    <div class="d-flex">
                        <button type="button" id="reset_assessment_modal_btn" onclick="reset_assessment()" class="btn btn-primary">Reset Assessment</button>
                        <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- jQuery -->
    <script src="../plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- Select2 -->
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/js/select2.min.js"></script>
    <!-- <script src="../plugins/select2/js/select2.full.min.js"></script> -->
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <!-- <script>$('.select2').select2()</script> -->
    <!-- Summernote -->
    <script src="../plugins/summernote/summernote-bs4.min.js"></script>
    <!-- <script src="https://cdn.jsdelivr.net/npm/@wiris/mathtype-ckeditor5@7.30.0/plugin.min.js"></script> -->
    <script>

    </script>

    <!-- Summernote -->
    <script src="../plugins/summernote/summernote-bs4.min.js"></script>
    <script src="../dist/js/examination.js?v=20260913-assessment-flow"></script>

    <script src="../dist/js/skul.js?v=w3q125sj"></script>
    <!-- date-range-picker -->
    <script src="../plugins/moment/moment.min.js"></script>
    <script src="../plugins/daterangepicker/daterangepicker.js"></script>

    <script>
        function disallow_attempt(event,assessment_id, student_id) {
            // var assessment_id = $('#assessment_id').val();
            // var student_id = $('#student_id').val();
            // return false
            $.ajax({
                url: '../controller_new.php',
                type: 'POST',
                data: {
                    action: 'disallow_attempt',
                    assessment_id: assessment_id,
                    student_id: student_id,
                    status: $(event).attr('data-status')
                },
                success:(data) => {
                    console.log('here1')
                    if(data){
                        console.log('here2')
                        // data = JSON.parse(data)
                        if(data.status == 1){
                            console.log('here3')
                            $(event).removeClass('btn-danger').addClass('btn-success').html('Allow Attempt').attr('data-status', 0)
                        }else {
                            console.log('here4')
                            $(event).removeClass('btn-success').addClass('btn-danger').html('Disallow Attempt').attr('data-status', 1)
                        }
                    }
                }
            })
        }
        $(document).ready(function() {
            // alert('h')
            $('#results-table').DataTable({
                repponsive:true,
                scrollX:true,
                pageLength: 25,
                order: [
                    [4, 'desc']
                ]
            });
        });
    </script>
</body>

</html>
