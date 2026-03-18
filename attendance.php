<?php
session_start();
date_default_timezone_set('Africa/Lagos');
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
$_SESSION['location'] = explode("/", $_SERVER['REQUEST_URI'])[3];
// $school_id = $_SESSION['school_id'];
// exit;
// echo $_SESSION['term_id'];
// echo $_SESSION['session_id'];
// exit;
$school_settings = json_decode($_SESSION['skul_settings'], true);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Attendance</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Select2 -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/css/select2.min.css" rel="stylesheet" />

    <!-- <link rel="stylesheet" href="../plugins/select2/css/select2.min.css"> -->
    <!-- daterange picker -->
    <link rel="stylesheet" href="../plugins/daterangepicker/daterangepicker.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/2.3.6/css/buttons.dataTables.min.css">
    <style>
        .parent_Search_btn:hover {
            background-color: aliceblue;
        }

        table.dataTable,
        table.dataTable th,
        table.dataTable td {
            border: none !important;
            vertical-align: middle !important;
        }

        table.dataTable thead th,
        table.dataTable tfoot th {
            border-bottom: none !important;
        }

        table.dataTable.stripe tbody tr.odd,
        table.dataTable.stripe tbody tr.even {
            background-color: transparent !important;
        }

        .valid-date {
            background-color: #cce5ff !important;
            /* Highlight valid dates */
            border-radius: 50%;
        }



        .daterange+.select2-container {
            width: 100% !important;
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
                            }?>
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
                    <ul class="nav nav-pills nav-sidebar flex-column pb-5" data-widget="treeview" role="menu"
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
                            <a href="attendance" class="nav-link active">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">list</i>
                                    Attendance
                                </p>
                            </a>
                        </li>
                        <?php if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4 || $_SESSION['staff_type'] == 5) { ?>
                        <li class="nav-item">
                            <a href="staff_attendance" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">add_chart</i>
                                   Staff Attendance
                                </p>
                            </a>
                        </li>
                        <?php } ?>
                        <?php if($_SESSION['school_id'] == 27 || $_SESSION['school_id']==13){  ?>
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
                            <a href="assessment" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">app_registration</i>
                                    Assessments
                                </p>
                            </a>
                        </li>
                        <?php
                         if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4 || $_SESSION['staff_type'] == 7) {
                             ?>
                        <li class="nav-item">
                            <a href="payments" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">payments</i>
                                    Payments
                                </p>
                            </a>
                        </li>
                        <?php } ?>
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
        <div class="content-wrapper" style="background-color: #f4f7fa; padding-bottom: 100px;">


            <!-- Main content -->
            <div class="content">
                <input type="hidden" id="select_session_field" class="session_value" value="<?= $school_settings['session']; ?>">
                <input type="hidden" id="attendance_student_page" value="attendance">


                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="mb-3">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Manage Attendance</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">Manage Attendance</li>
                                    </ol>
                                </div>
                                <div>
                                    <div class="row">
                                        <div class="col-12 col-md-12 my-md-0">
                                            <p class="text-orange mb-2">Current Term: <span class="term_name font-weight-bold"><?= $_SESSION['term_id'] == 1 ? '1st' : ($_SESSION['term_id'] == 2 ? '2nd' : '3rd') ?></span></p>

                                            <div class="form-group">
                                                <div class="w-100">
                                                    <button class="btn select_btn attend take active mr-2 mb-1" onclick="att_toggle(this,'take')">Take Attendance</button>
                                                    <button class="btn select_btn attend view mb-1" onclick="att_toggle(this,'view')">View Attendance</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12 col-md-3" id="select_class">
                                            <div class="form-group align-left">
                                                <label for="select_class_field" class="mb-0">Select Class</label>
                                                <select class="form-control filter_Select select2" onchange="get_stud_byClass_attendance()" id="select_class_field" style="width: 100%;">

                                                </select>
                                            </div>
                                        </div>
                                        <!-- <div class="mr-2 col-md-3" id="select_class"> -->

                                        <!-- </div> -->
                                        <!-- <div class="col-md-3" id=""> -->
                                        <div class="form-group align-left col-md-3 col-12" id="select_date">
                                            <label for="" class="mb-0">Select Date</label>
                                            <input type="date" id="att_date" name="" value="<?= date("Y-m-d") ?>" class="form-control" onchange="get_stud_byClass_attendance()" id="select_date_field">
                                        </div>
                                    <!-- </div> -->
                                    <div class="form-group align-left col-md-3 col-12" id="select_period" style="display: none;">
                                            <label for="" class="mb-0 w-100">Select Period</label>
                                            <select class="select2 w-100 daterange form-control">
                                                <option value="today">Today</option>
                                                <option value="yesterday">Yesterday</option>
                                                <option value="last 7 days">Last 7 days</option>
                                                <option value="last 30 days">Last 30 days</option>
                                                <option value="this month">This month</option>
                                                <!-- <option value="last month">Last month</option> -->
                                                <option value="this term">This Term</option>
                                                <option value="this session">This Session</option>
                                                <option value="custom">Custom Date Range</option>
                                            </select>
                                        </div>
                                        <!-- </div>
                                    <div class="row"> -->
                                        <div id="daterange_custom" class="align-left col-md-6 col-12" style="display:none;">
                                            <div class="row">
                                                <div class="form-group col-md-6 col-12">
                                                    <label for="start_date" class="mb-0">Start date</label>
                                                    <input type="date" name="" id="custom_start" class="form-control" id="start_date">
                                                </div>
                                                <div class="form-group col-md-6 col-12">
                                                    <label for="end_date" class="mb-0">End date</label>
                                                    <input type="date" name="" id="custom_end" class="form-control" id="end_date">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <a href="scan_qr" class="font-weight-bold accent mb-2 d-flex align-items-center">
                                        <span class="material-symbols-outlined mr-1">qr_code_scanner</span>
                                        Scan an ID
                                    </a>

                                    <!-- </div> -->

                                    <!-- <php
                                        // Query to fetch dates
                                        $sql = "SELECT DISTINCT att_date FROM attendance";
                                        $result = $conn->query($sql);

                                        $dates = [];
                                        if ($result->num_rows > 0) {
                                            while ($row = $result->fetch_assoc()) {
                                                $dates[] = $row['att_date']; // Assuming the column stores dates in 'YYYY-MM-DD' format
                                            }
                                        }
                                        $conn->close();
                                        // print_r($dates);

                                        // Pass dates to JavaScript
                                        echo '<script>var dbDates = ' . json_encode($dates) . ';</script>';
                                        ?> -->
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="container-fluid mt-4 px-0">
                        <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                            <!-- <div class=""> -->
                                <div class="py-3 px-15 bg-white data_overlay" style="border-radius: 10px; position: relative; left:0;">
                                    <p class="font-weight-bold">No student in the class selected</p>
                                </div>
                                <div>
                                <div id="att_type_btn">
                                    <button type=button class="btn btn-sm mr-2 active att_type_select select_btn" data-att_type="1" onclick="toggle_att_type(this)">Daily</button>
                                    <button type=button class="btn btn-sm select_btn att_type_select" data-att_type="0" onclick="toggle_att_type(this)">One-time</button>
                                </div>
                                <div id="tbl_container" class="pt-3"></div>
                            </div>

                            <!-- <div> -->
                            <!-- </div> -->
                            <!-- <div></div> -->


                        </div>
                    </div>
                </div>
                <!-- /.row_class -->
                <div class="modal fade" id="attendanceHistoryModal" tabindex="-1" role="dialog" aria-labelledby="attendanceHistoryModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-lg modal-dialog-scrollable modal-dialog-centered" role="document">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="attendanceHistoryModalLabel">Attendance History</h5>
                                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                                </button>
                            </div>
                            <div class="modal-body">
                                <div class="mb-3">
                                    <input type="hidden" value="" id="student_att" data-student_id="" data-session_id="" data-term_id="" data-class_id="">
                                    <select class="select2 w-100 daterange_history form-control">
                                        <option value="today">Today</option>
                                        <option value="yesterday">Yesterday</option>
                                        <option value="last 7 days">Last 7 days</option>
                                        <option value="last 30 days">Last 30 days</option>
                                        <option value="this month">This month</option>
                                        <option value="this term">This Term</option>
                                        <option value="this session">This Session</option>
                                        <option value="custom">Custom Date Range</option>
                                    </select>
                                    <div id="daterange_custom_history" class="align-left col-md-6 col-12" style="display:none;">
                                        <div class="row mt-3">
                                            <div class="form-group col-md-6 col-12 pl-0">
                                                <label for="start_date" class="mb-0">Start date</label>
                                                <input type="date" name="" id="custom_start_history" class="form-control" id="start_date_history">
                                            </div>
                                            <div class="form-group col-md-6 col-12">
                                                <label for="end_date" class="mb-0">End date</label>
                                                <input type="date" name="" id="custom_end_history" class="form-control" id="end_date_history">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="">
                                    <table class="display nowrap" id="attendanceHistoryTable" style="width:100%">
                                        <thead>
                                            <tr>
                                                <th>Time</th>
                                                <th>Date</th>
                                                <th>State</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- Attendance data will be inserted here -->
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
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
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/js/select2.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <!-- <script src="https://cdn.datatables.net/buttons/2.3.6/js/dataTables.buttons.min.js"></script> -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.1.3/jszip.min.js"></script>
    <!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/pdfmake.min.js"></script> -->
    <!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.1.53/vfs_fonts.js"></script> -->
    <!-- <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.html5.min.js"></script> -->
    <!-- <script src="https://cdn.datatables.net/buttons/2.3.6/js/buttons.print.min.js"></script> -->
    <script src="../plugins/toastr/toastr.min.js"></script>
    <!-- <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script> -->

    <script src="../dist/js/skul.js?v=op"></script>
    <!-- date-range-picker -->
    <script src="../plugins/moment/moment.min.js"></script>
    <script src="../plugins/daterangepicker/daterangepicker.js"></script>

    <script>
        function get_att_inform(startdate,enddate,student_name,student_id, session_id, term_id, class_id) {
            $("#student_att").attr('data-student_id', student_id);
            $("#student_att").attr('data-session_id', session_id);
            $("#student_att").attr('data-term_id', term_id);
            $("#student_att").attr('data-class_id', class_id);
            $("#attendanceHistoryModalLabel").text(student_name);
            get_att_history('today','today',student_id, session_id, term_id, class_id);
        }
        function get_att_history(startdate,enddate,student_id, session_id, term_id, class_id) {
            $.ajax({
                url: '../controller.php',
                type: 'POST',
                data: {
                    action: 'get_att_history',
                    student_id: student_id,
                    session_id: session_id,
                    term_id: term_id,
                    class_id: class_id,
                    start_date: startdate,
                    end_date: enddate
                },
                success: function(response) {
                    var data = JSON.parse(response);
                    if ($.fn.DataTable.isDataTable('#attendanceHistoryTable')) {
                        $('#attendanceHistoryTable').DataTable().destroy();
                    }
                    var tableBody = $('#attendanceHistoryTable tbody');
                    tableBody.empty();
                    data.forEach(function(row) {
                        var state = row.state == 1 ? '<span class="badge badge-success">Check in</span>' : '<span class="badge badge-danger">Check out</span>';
                        tableBody.append('<tr><td>' + row.att_time + '</td><td>' + row.att_date + '</td><td>' + state + '</td></tr>');
                    });
                    
                    $('#attendanceHistoryTable').DataTable({
                        responsive: true,
                        pageLength: 10,
                        // order: [[1, 'desc'], [0, 'desc']], // Sort by date then time descending
                        dom: 'Bfrtip',
                        // buttons: [
                        //     'copy', 'excel', 'pdf'
                        // ],
                        language: {
                            search: "Search records:",
                            lengthMenu: "Show _MENU_ records per page",
                            zeroRecords: "No matching records found",
                            info: "Showing _START_ to _END_ of _TOTAL_ records",
                            infoEmpty: "No records available",
                            infoFiltered: "(filtered from _MAX_ total records)"
                        }
                    });
                    
                    $('#attendanceHistoryModal').modal('show');
                }
            });
        }

        $(".daterange_history").change(() => {
            calculateDateRange_history()
            if ($(".daterange_history").val() == "custom") {
                $("#daterange_custom_history").show()
            } else {
                $("#daterange_custom_history").hide()
            }
        })
        $("#daterange_custom_history").change(() => {
            if (!$("#custom_start_history").val() || !$("#custom_end_history").val()) {
                return
            }
            get_att_history($("#custom_start_history").val(), $("#custom_end_history").val(), $("#student_att").attr('data-student_id'), $("#student_att").attr('data-session_id'), $("#student_att").attr('data-term_id'), $("#student_att").attr('data-class_id'));
            // fetchSelectedDates_att($("#custom_start_history").val(), $("#custom_end_history").val());
        })
        
        function calculateDateRange_history() {
            if ($(".daterange_history").val() == "custom") {
                get_att_history($("#custom_start_history").val(), $("#custom_end_history").val(), $("#student_att").attr('data-student_id'), $("#student_att").attr('data-session_id'), $("#student_att").attr('data-term_id'), $("#student_att").attr('data-class_id'));
               
                // fetchSelectedDates_att($("#custom_start_history").val(), $("#custom_end_history").val());
                return
            } else {

                const today = new Date();
                let startDate = new Date();


                switch ($(".daterange_history").val()) {
                    case "today":
                        break;

                    case "yesterday":
                        startDate.setDate(today.getDate() - 1);
                        endDate = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 1);
                        break;

                    case "last 7 days":
                        startDate.setDate(today.getDate() - 6);
                        break;

                    case "last 30 days":
                        startDate.setDate(today.getDate() - 29);
                        break;

                    case "this month":
                        startDate = new Date(today.getFullYear(), today.getMonth(), 1);
                        break;

                    case "last month":
                        startDate = new Date(today.getFullYear(), today.getMonth() - 1, 1);
                        endDate = new Date(today.getFullYear(), today.getMonth(), 0);
                        break;

                    case "this term":
                        startDate = 'term';
                        break;
                    case "this session":
                        startDate = 'session';
                        break;

                    default:
                        throw new Error("Invalid range. Accepted values are: Today, Yesterday, Last 7 days, Last 30 days, This month, Last month.");
                }
                // console.log(endDate)

                const formatDate = (date) =>
                    `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
                if (startDate == 'term' || startDate == 'session') {
                    get_att_history(startDate, formatDate(today), $("#student_att").attr('data-student_id'), $("#student_att").attr('data-session_id'), $("#student_att").attr('data-term_id'), $("#student_att").attr('data-class_id'));
                    // fetchSelectedDates_att((startDate), formatDate(today));
                    return
                }
                // fetchSelectedDates_att(formatDate(startDate), formatDate(today));
                get_att_history(formatDate(startDate), formatDate(today), $("#student_att").attr('data-student_id'), $("#student_att").attr('data-session_id'), $("#student_att").attr('data-term_id'), $("#student_att").attr('data-class_id'));
                // return {
                //     startDate: formatDate(startDate),
                //     endDate: formatDate(today),
                // };
            }
        }

        // function fetchSelectedDates_att(startDate, endDate) {
        //     $.ajax({
        //         url: '../controller.php', // Replace with your PHP endpoint
        //         method: 'POST',
        //         data: {
        //             start_date: startDate,
        //             end_date: endDate,
        //             action: 'get_att',
        //             class_id: $("#select_class_field").val(),
        //             // student_id: $(".bulk_att_report_ids").val(),
        //         },
        //         success: function(response) {
        //             const data = JSON.parse(response);

        //             if (data.length === 0) {
        //                 $(".data_overlay").show()
        //                 $(".data_overlay").html(`
        //             <p class="font-weight-bold">No attendance data found for the selected date or class</p>
        //         `)
        //                 $("#tbl_container").html('');
        //                 // $("#att_table_report").html("<p>No attendance data found for the selected date range.</p>");
        //                 return;
        //             }
        //             $(".data_overlay").hide()



        //             // Extract unique dates and students
        //             const dates = [...new Set(data.map(item => item.att_date))].sort();
        //             const students = [...new Set(data.map(item => item.student_id))];

        //             // Generate table header
        //             let tableHeader = `
        //         <table id="att_table_report" class="display nowrap" style="width:100%;">

        //         <thead>
        //             <tr>
        //                 <th class="font-weight-normal">Names</th>`;
        //             dates.forEach(date => {
        //                 tableHeader += `<th>${moment(date).format('DD-MM')}</th>`;
        //             });
        //             tableHeader += `
        //                 <th>Present</th>
        //                 <th>Absent</th>
        //                 <th>History</th>
        //             </tr>
        //         </thead>`;

        //             // Generate table body
        //             let tableBody = "<tbody>";

        //             students.forEach(student_id => {
        //                 const studentData = data.filter(item => item.student_id === student_id);
        //                 const studentName = `${studentData[0].lastname} ${studentData[0].firstname} ${studentData[0].middlename}`.trim();
        //                 console.log(studentData)

        //                 let presentCount = 0;
        //                 let absentCount = 0;
        //                 let history = `<button type="button" onclick="get_att_history('${student_id}','${studentData[0].session_id}','${studentData[0].term_id}','${studentData[0].class_id}')"><span class="material-symbols-outlined accent">list</span></button>`

        //                 tableBody += `<tr><td>${studentName}</td>`;

        //                 dates.forEach(date => {
        //                     const attendance = studentData.find(item => item.att_date === date);
        //                     if (attendance) {
        //                         if (attendance.state === "1") {
        //                             tableBody += `<td><span class="material-symbols-outlined text-success">check</span></td>`;
        //                             presentCount++;
        //                         } else {
        //                             tableBody += `<td><span class="material-symbols-outlined text-danger">close</span></td>`;
        //                             absentCount++;
        //                         }

        //                     } else {
        //                         tableBody += `<td>-</td>`; // No data for this date
        //                     }
        //                 });

        //                 tableBody += `<td>${presentCount}</td><td>${absentCount}</td><td>${history}</td></tr>`;
        //             });

        //             tableBody += "</tbody></table>";

        //             // Combine header and body
        //             const tableHTML = `<table class="table table-bordered">${tableHeader}${tableBody}</table>`;

        //             $("#tbl_container").html(tableHTML);
        //             // if ($.fn.DataTable.isDataTable('#att_table_report')) {
        //             //     $('#att_table_report').DataTable().destroy();
        //             // }
        //             $('#att_table_report').DataTable({
        //                 scrollX: true,
        //                 paging: false,
        //                 ordering: false,
        //                 fixedColumns: {
        //                     left: 1,
        //                     right: 0
        //                 }
        //             });
        //         },
        //         error: function(error) {
        //             console.error("Error fetching data:", error);
        //         },
        //     });
        // }
    </script>



</body>

</html>