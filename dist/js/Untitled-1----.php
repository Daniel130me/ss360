<?php
session_start();
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
    <title>Student Profile</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="dist/css/adminlte.css">
    <link rel="stylesheet" href="plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <!-- fullCalendar -->
    <link rel="stylesheet" href="plugins/fullcalendar/main.css">
    <!-- <style>

    </style> -->
</head>

<body class="hold-transition sidebar-mini">
    <div class="wrapper">

        <!-- Navbar -->
        <nav class="main-header navbar border-bottom-0 navbar-expand justify-content-between bg1">
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
                                <img src="uploads/<?= $_SESSION['staff_photo'] ?>" class="img-circle elevation-2" alt="User Image">
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
                <img src="dist/img/company_logo.png" alt="AdminLTE Logo" class="brand-image img-circle elevation-3" style="opacity: .8">
                <span class="brand-text font-weight-light">Skulz</span>
            </a>
            <div href="" class="px-15 pt-15 border-bottom" style="padding-bottom: 30px;">
                <img src="uploads/<?= $_SESSION['logo'] ?>" style="height: 200px; object-fit:cover;" alt="Logo"
                    class="brand-image img-circle elevation-5 w-100">
            </div>
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
                            <a href="students" class="nav-link active">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">supervisor_account</i>
                                    Students
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
                            <a href="subjects" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">responsive_layout</i>
                                    Subjects
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



                    </ul>
                </nav>
                <!-- /.sidebar-menu -->
            </div>
            <!-- /.sidebar -->
        </aside>

        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper" style="background-color: #f4f7fa">
            <!-- Content Header (Page header) -->

            <!-- /.content-header -->

            <!-- Main content -->
            <div class="container-fluid">
                <div class="row m-0">
                    <div class="col-sm-6 row ml-0">
                        <div class="mr-2">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <a href="students" class="accent">Back</a>
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
                                        <li class="breadcrumb-item active font-14"><a href="students">Students</a></li>
                                        <li class="breadcrumb-item active font-14">Profile</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="content mt-3">
                <div class="container-fluid">
                    <div class="card">
                        <div class="card-header">
                            <ul class="nav nav-pills menu-scrollbar" id="pills-tab" role="tablist" style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
                                <li class="nav-item" role="presentation">
                                    <button class="pill-link link-primary active" id="pills-emp-info-tab" data-toggle="pill" data-target="#pills-emp-info" type="button" role="tab" aria-controls="pills-emp-info" aria-selected="true">Biodata</button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="pill-link link-primary" onclick="getsingleSessionReport()" id="pills-attendance-history-tab" data-toggle="pill" data-target="#pills-attendance-history" type="button" role="tab" aria-controls="pills-attendance-history" aria-selected="false">Score Report</button>
                                </li>

                            </ul>

                            <!-- /.card-tools -->
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">

                            <div class="tab-content" id="pills-tabContent">
                                <div class="tab-pane fade show active" id="pills-emp-info" role="tabpanel" aria-labelledby="pills-emp-info-tab">

                                    <div class="d-flex">
                                        <?php
                                        $select = mysqli_query($conn, "SELECT s.*,p.address,p.phone as pphone,p.email as pemail, p.state, p.city,p.country FROM students s, parent p WHERE p.id=s.parent_id AND s.id='{$_GET['id']}'");
                                        $stud_row = mysqli_fetch_array($select)
                                        ?>
                                        <div class="d-flex first-con flex-wrap">
                                            <div>
                                                <img src="uploads/<?= $stud_row['photo'] ?>" class="emp-basic-img img-circle" alt="User Image">
                                            </div>
                                            <div class="d-flex flex-column justify-content-center ml-3">
                                                <div>
                                                    <h4><?= $stud_row['firstname'] . ' ' . $stud_row['lastname'] ?></h4>
                                                </div>
                                                <div>
                                                    <p class="mb-0 small font-weight-bold muted-text">Email Address</p>
                                                    <p class="mb-0"><?= $stud_row['email'] ?></p>
                                                </div>
                                            </div>
                                            <div class="emp-basic ml-sm-5">
                                                <p class="mb-0 small font-weight-bold muted-text">Phone Number</p>
                                                <p class="mb-0"><?= $stud_row['phone'] ?></p>
                                            </div>

                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">Gender</p>
                                                <p class="mb-0"><?= $stud_row['gender'] ?></p>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <div>
                                            <h6 class="font-weight-bold mt-5 pb-2" style="border-bottom: 1px solid #dadada;">Parent Information</h6>
                                        </div>
                                        <div class="d-flex flex-wrap">
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">Phone Number</p>
                                                <p class="mb-0"><?= $stud_row['pphone'] ?></p>
                                            </div>
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">Email address</p>
                                                <p class="mb-0"><?= $stud_row['pemail'] ?></p>
                                            </div>
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">Address</p>
                                                <p class="mb-0"><?= $stud_row['address'] ?></p>
                                            </div>
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">State</p>
                                                <p class="mb-0"><?= $stud_row['state'] ?></p>
                                            </div>
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">City</p>
                                                <p class="mb-0"><?= $stud_row['city'] ?></p>
                                            </div>
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">Country</p>
                                                <p class="mb-0"><?= $stud_row['country'] ?></p>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- <div class="mt-4">
                                        <button onclick="edit_student_info('<= $stud_row['id'] ?>')" class="btn btn-sm btn-primary">Edit Information</button>
                                    </div> -->
                                </div>
                                <div class="tab-pane fade" id="pills-attendance-history" role="tabpanel" aria-labelledby="pills-attendance-history-tab">

                                    <div style="width: 100%; overflow: auto;">
                                        <input type="hidden" id="student_id_for_general_report" name="" value="<?= $_GET['id'] ?>">
                                        <div>

                                            <!-- <div class="form-group">
                                                <label for="">Select Session:</label>
                                                <select name="" id="termSessionValue" onchange="getTermReport()" class="select2 d-inline-block form-control" style="max-width: 125px;" id="">
                                                    <option value="1">2012/2013</option>
                                                    <option value="2">2013/2014</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="">Select Term:</label>
                                                <button type="button" onclick="toggleSelect(this,'select_term_report','1','<?= $_GET['id'] ?>')" data-termValue="1" class="select_term_report btn select_btn active">1st Term</button>
                                                <button type="button" onclick="toggleSelect(this,'select_term_report','2','<?= $_GET['id'] ?>')" data-termValue="2" class="select_term_report btn select_btn">2nd Term</button>
                                                <button type="button" onclick="toggleSelect(this,'select_term_report','3','<?= $_GET['id'] ?>')" data-termValue="3" class="select_term_report btn select_btn">3rd Term</button>
                                            </div> -->
                                        </div>
                                        <!-- <div class="mt-4">
                                            <div id="student_term_based_report"></div>
                                        </div> -->
                                        <div class="mt-4">
                                            <div class="row">
                                                <div class="form-group col-6 col-sm-3">
                                                    <label for="" class="mb-0">Select Subject:</label>
                                                    <select name="" id="termSubjectValue" onchange="getsingleSessionReport()" class="form-control" id="">
                                                        <?php
                                                        $select = mysqli_query($conn, "SELECT id, subject FROM subjects ORDER BY subject ASC");
                                                        while ($row = mysqli_fetch_array($select)) {
                                                        ?>
                                                            <option value="<?= $row['id'] ?>"><?= $row['subject'] ?></option>
                                                        <?php } ?>
                                                    </select>
                                                </div>
                                                <div class="form-group col-6 col-sm-3">
                                                    <label for="" class="mb-0">Select Session:</label>
                                                    <select name="" id="singleSessionValue" onchange="getsingleSessionReport()" class="form-control" id="">
                                                        <?php
                                                        $select = mysqli_query($conn, "SELECT id, session FROM sessions ORDER BY session ASC");
                                                        while ($row = mysqli_fetch_array($select)) {
                                                        ?>
                                                            <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                                        <?php } ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="mt-4">

                                                <div class="" id="overall_performance"></div>
                                                <div class="" id="score_chart">
                                                    <!-- <div class="position-relative mb-4">
                                                        <canvas id="visitors-chart" height="200"></canvas>
                                                    </div> -->
                                                
                                                </div>
                                                <div class="row justify-content-between">
                                                    <div class="mt-3 col-12 col-sm-3" id="student_term1_report"></div>
                                                    <div class="mt-3 col-12 col-sm-3" id="student_term2_report"></div>
                                                    <div class="mt-3 col-12 col-sm-3" id="student_term3_report"></div>
                                                </div>
                                            </div>
                                            <!-- <div class="mt-4">
                                                <div class="form-group">
                                                    <label for="">Select Term:</label>
                                                    <button type="button" data-value="1" class="select_sessions_report btn select_btn active">1st Term</button>
                                                    <button type="button" data-value="2" class="select_sessions_report btn select_btn">2nd Term</button>
                                                    <button type="button" data-value="3" class="select_sessions_report btn select_btn">3rd Term</button>
                                                </div>
                                            </div> -->
                                        </div>
                                        <!-- /.card-body -->
                                    </div>
                                </div>
                            </div>


                        </div>
                        <!-- /.card-body -->
                    </div>

                </div><!-- /.container-fluid -->
            </div>
            <!-- /.content -->
        </div>
        <!-- /.content-wrapper -->

        <!-- Main Footer -->

    </div>
    <!-- ./wrapper -->
    <div class="modal fade" id="edit_student_modal">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Update Student Data</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body pb-0" id="edit_student_modal_body">
                </div>
            </div>
        </div>
    </div>
    <!-- REQUIRED SCRIPTS -->

    <!-- jQuery -->
    <script src="plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- AdminLTE App -->
    <script src="dist/js/adminlte.min.js"></script>
    <script src="plugins/chart.js/Chart.min.js"></script>
    <script src="plugins/select2/js/select2.full.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="plugins/moment/moment.min.js"></script>
    <script src="plugins/fullcalendar/main.js"></script>
    <script>
        var skul_settings = <?= $_SESSION['skul_settings'] ?>;
    </script>
    <script src="dist/js/skul.js?v=10"></script>
    <script>
        // display_chart1('22', '45', '90')
    </script>

    <!-- <script src="dist/js/pages/dashboard3.js"></script> -->
</body>

</html>