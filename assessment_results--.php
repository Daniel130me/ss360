<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}

include_once("model/connect.php");
include_once("model/functions.php");

$assessment_id = isset($_GET['id']) ? intval($_GET['id']) : 0;
$class_id = isset($_GET['class_id']) ? intval($_GET['class_id']) : 0;

// Get assessment details
$assessment_query = "SELECT a.*, s.subject FROM assessment a 
                    JOIN subjects s ON a.subject_id = s.id 
                    WHERE a.id = ?";
$stmt = $conn->prepare($assessment_query);
$stmt->bind_param("i", $assessment_id);
$stmt->execute();
$assessment = $stmt->get_result()->fetch_assoc();

// Get all students who haven't attempted
$not_attempted_query = "SELECT s.id, s.firstname, s.lastname 
                       FROM students s 
                       LEFT JOIN assessment_results ar ON s.id = ar.student_id AND ar.assessment_id = ?
                       WHERE s.class_id = ? AND ar.id IS NULL";
$stmt = $conn->prepare($not_attempted_query);
$stmt->bind_param("ii", $assessment_id, $class_id);
$stmt->execute();
$not_attempted = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Get results with filters
$where = "WHERE ar.assessment_id = ?";
$params = [$assessment_id];
$types = "i";

if (isset($_GET['score_min'])) {
    $where .= " AND ar.percentage_score >= ?";
    $params[] = $_GET['score_min'];
    $types .= "d";
}

if (isset($_GET['score_max'])) {
    $where .= " AND ar.percentage_score <= ?";
    $params[] = $_GET['score_max'];
    $types .= "d";
}

$order_by = isset($_GET['sort']) ? $_GET['sort'] : 'submitted_at DESC';

$results_query = "SELECT ar.*, s.firstname, s.lastname 
                 FROM assessment_results ar
                 JOIN students s ON ar.student_id = s.id 
                 $where
                 ORDER BY $order_by";

$stmt = $conn->prepare($results_query);
$stmt->bind_param($types, ...$params);
$stmt->execute();
$results = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);

// Calculate class average
$avg_query = "SELECT AVG(percentage_score) as avg_score 
              FROM assessment_results 
              WHERE assessment_id = ?";
$stmt = $conn->prepare($avg_query);
$stmt->bind_param("i", $assessment_id);
$stmt->execute();
$avg_score = $stmt->get_result()->fetch_assoc()['avg_score'];
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
        <nav class="main-header navbar border-bottom-0 navbar-expand justify-content-between">
            <!-- <div class=""> -->
            <!-- <div> -->

            <!-- Left navbar links -->
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
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
            <!-- </div> -->

        </nav>
        <!-- /.navbar -->
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
                            <a href="lesson_note" class="nav-link active">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">list</i>
                                    Lesson Note
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
                        <li class="nav-item">
                            <a href="reports" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">list</i>
                                    Reports
                                </p>
                            </a>
                        </li>
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
                                        <h3><?php echo number_format($avg_score, 1); ?>%</h3>
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
                          <table id="results-table" class="table table-striped">
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
                                            <td><?php echo substr_count($result['answers'], '"'); ?></td>
                                            <td><?php echo number_format($result['percentage_score'], 1); ?>%</td>
                                            <td><?php echo date('Y-m-d H:i', strtotime($result['submitted_at'])); ?></td>
                                            <td>
                                                <a href="view_student_result?id=<?php echo $result['id']; ?>"
                                                    class="btn btn-sm btn-primary">View Details</a>
                                            </td>
                                        </tr>
                                    <?php endforeach; ?>
                                </tbody>
                            </table>
                    </div>
                </div>
                <!-- <div class="container-fluid mb-2">
                    <div class="pt-3 px-15 bg-white" style="border-radius: 10px;">
                        <div class="d-flex justify-content-between align-items-center">
                          
                        </div>
                    </div>
                </div> -->
                <div class="container-fluid">

                    <!-- Filters -->
                    <!-- <div class="card mb-4">
                        <div class="card-body">
                            <form method="GET" class="row">
                                <input type="hidden" name="id" value="<?php echo $assessment_id; ?>">
                                <div class="col-md-3">
                                    <label>Min Score:</label>
                                    <input type="number" name="score_min" class="form-control" value="<?php echo $_GET['score_min'] ?? ''; ?>">
                                </div>
                                <div class="col-md-3">
                                    <label>Max Score:</label>
                                    <input type="number" name="score_max" class="form-control" value="<?php echo $_GET['score_max'] ?? ''; ?>">
                                </div>
                                <div class="col-md-3">
                                    <label>Sort By:</label>
                                    <select name="sort" class="form-control">
                                        <option value="submitted_at DESC">Latest First</option>
                                        <option value="percentage_score DESC">Highest Score</option>
                                        <option value="percentage_score ASC">Lowest Score</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-primary mt-4">Apply Filters</button>
                                </div>
                            </form>
                        </div>
                    </div> -->





                    <!-- Not Attempted List -->
                    <div class="card mt-4">
                        <div class="card-header">
                            <h5>Students Yet to Attempt</h5>
                        </div>
                        <div class="card-body">
                            <ul class="list-group">
                                <?php foreach ($not_attempted as $student): ?>
                                    <li class="list-group-item">
                                        <?php echo htmlspecialchars($student['firstname'] . ' ' . $student['lastname']); ?>
                                    </li>
                                <?php endforeach; ?>
                            </ul>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <script src="js/jquery.min.js"></script>
    <script src="js/bootstrap.bundle.min.js"></script>
    <script src="js/datatables.min.js"></script>
    <script>
        $(document).ready(function() {
            $('#results-table').DataTable({
                pageLength: 25,
                order: [
                    [4, 'desc']
                ]
            });
        });
    </script>
</body>

</html>