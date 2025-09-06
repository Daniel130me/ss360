<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
// exit;
// include_once("model/connect.php");
include_once("model/functions.php");
// $school_id = $_SESSION['school_id'];
// $parent_id = $_SESSION['userid'];
// $student_id = $_GET['id'];
// $date = date("Y-m-d");
// $school_settings = json_decode($_SESSION['skul_settings'], true);
// $first_term = $school_settings['first'];
// $second_term = $school_settings['second'];
// $third_term = $school_settings['third'];
// $first_term_class = ($date >= $school_settings['first'] && $date <= $school_settings['second']) ? "active" : '';
// $second_term_class = ($date >= $school_settings['second'] && $date < $school_settings['third']) ? "active" : '';
// $third_term_class = $date >= $school_settings['third'] ? "active" : '';
// elseif($date >= $school_settings['second'] && $date <= $school_settings['third'] ) {
//     echo "second";
// Helper: get lateness time as string (HH:mm)
// }elseif($date >= $school_settings['third']) {
//     echo "third";
// }
// exit;
// $data = [];
// echo $_GET['id'];
// exit;
// $select = mysqli_query($conn, "SELECT s.*,c.classname,
// p.firstname as p_firstname,p.lastname as p_lastname,
// p.phone as p_phone,p.email as p_email,p.city,p.state,
// p.address as p_address,p.country FROM students s, class c, 
// parent p WHERE p.id=s.parent_id AND s.class_id=c.id AND 
// s.school_id='$school_id' AND 
// s.id='{$_GET['id']}'");

// while ($row = mysqli_fetch_array($select)) {
//     $data[] = array(
//         'photo' => $row['photo'],
//         'id' => $row['id'],
//         'classname' => $row['classname'],
//         'firstname' => $row['firstname'],
//         'lastname' => $row['lastname'],
//         'middlename' => $row['middlename'] == '' ? '' : $row['middlename'],
//         'class_id' => $row['class_id'],
//         'dob' => $row['dob'],
//         'gender' => $row['gender'] == '' ? 'Nil' : $row['gender'],
//         'phone' => $row['phone'] == '' ? 'Nil' : $row['phone'],
//         'email' => $row['email'] == '' ? 'Nil' : $row['email'],
//         'datecreated' => $row['datecreated'],
//         'parent_id' => $row['parent_id'],
//         'p_firstname' => $row['p_firstname'] == '' ? 'Nil' : $row['p_firstname'],
//         'p_lastname' => $row['p_lastname'] == '' ? 'Nil' : $row['p_lastname'],
//         'p_phone' => $row['p_phone'],
//         'p_email' => $row['p_email'],
//         'p_address' => $row['p_address'] == '' ? 'Nil' : $row['p_address'],
//     );
// }
// print_r($data);
// print_r($row);
// exit;
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Staff Attendance</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <!-- Select2 -->
    <style>
    #preview {
        height: 90vh;
        width: 100%;
        object-fit: cover;
        transform: translateZ(0);
        backface-visibility: hidden;
        will-change: transform;
        border-radius: 10px;
        /* Optimize GPU acceleration */
    }

    @media screen and (max-width: 768px) {
        #preview {
            height: 70vh;
        }
    }

    .camera-selection {
        position: absolute;
        top: 10px;
        right: 10px;
        z-index: 1000;
    }

    .flash-button {
        position: absolute;
        bottom: 20px;
        left: 50%;
        transform: translateX(-50%);
        z-index: 1000;
        padding: 10px 20px;
        border-radius: 20px;
        background: rgba(0, 0, 0, 0.5);
        color: white;
        border: none;
    }

    .scanning-animation {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 3px;
        background: linear-gradient(to right, transparent, #00ff00, transparent);
        animation: scan 3s linear infinite;
        z-index: 11;
    }

    @keyframes scan {
        0% {
            transform: translateY(0);
        }

        50% {
            transform: translateY(100%);
        }

        100% {
            transform: translateY(0);
        }
    }

    /* Add success/error message styling */
    .message {
        position: fixed;
        top: 20px;
        right: 20px;
        padding: 15px 25px;
        border-radius: 4px;
        z-index: 9999;
        display: none;
        animation: slideIn 0.5s ease-out;
    }

    /* .success-message {
            background: #4CAF50;
            color: white;
        } */

    .error-message {
        background: #f44336;
        color: white;
    }

    @keyframes slideIn {
        from {
            transform: translateX(100%);
        }

        to {
            transform: translateX(0);
        }
    }

    .duration-badge {
        font-size: 0.75rem;
        padding: 2px 6px;
        background: #e9ecef;
        border-radius: 3px;
        margin-left: 5px;
        color: #666;
    }

    .total-duration {
        font-size: 0.8rem;
        color: #28a745;
        font-weight: bold;
    }
    </style>
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
                                <img src="../uploads/<?= $_SESSION['staff_photo'] ?>" class="img-circle elevation-2"
                                    alt="User Image">
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
                <img src="../uploads/<?= $_SESSION['logo'] ?>" alt="<?= $_SESSION['school_name'] ?>" class="brand-image"
                    style="opacity: .8">
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
                            <a href="attendance" class="nav-link active">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">list</i>
                                    Attendance
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="lesson_note" class="nav-link">
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
                <img src="../dist/img/company_logo.png" alt="Schoolsuite360" class="brand-image img-circle elevation-3"
                    style="opacity: .8">
                <span class="brand-text font-weight-light">Schoolsuite360</span>
            </a>
            <!-- /.sidebar -->
        </aside>

        <div class="content-wrapper" style="background-color: #f4f7fa; padding-bottom: 100px;">
            <div class="content">
                <div class="container-fluid">
                    <div class="row mb-5">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="mb-4">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Staff Attendance</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent"
                                                style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1"
                                                    style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">Staff Attendance</li>
                                    </ol>
                                </div>
                                <div class="">
                                    <div class="row mx-0 mb-3">
                                        <button class="btn btn-primary w-100 col-md-3 col-12" data-toggle="modal"
                                            data-target="#qrScannerModal">Open QR Scanner</button>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="form-group col-12 col-md-3" style="margin-bottom: -25px;">
                                        <label for="lateness_time" class="mb-0">Set Lateness Time</label>
                                        <input type="time" class="form-control col-12" onchange="save_to_School()"
                                            id="lateness_time" placeholder="Lateness Time"
                                            value="<?php echo get_lateness_time() ?>">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row mb-3">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="row">
                                    <div class="form-group col-12 col-md-3">
                                        <label for="attendance_date" class="mb-0">Attendance date</label>
                                        <input type="date" class="form-control col-12" id="attendance_date"
                                            placeholder="Attendance Date" value="<?php echo date('Y-m-d'); ?>">
                                    </div>
                                </div>
                                <!-- </div> -->

                                <table id="att_log_scan" class="display" style="width:100%">
                                    <thead>
                                        <tr>
                                            <th>Staff</th>
                                            <th>Date</th>
                                            <th>Check-In</th>
                                            <th>Check-Out</th>
                                            <th>Status</th>
                                            <th>Mode</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Data will be loaded here using AJAX -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="row">
                                    <div class="form-group align-left col-md-3 col-12" id="select_period_staff">
                                        <label for="" class="mb-0 w-100">Select Period</label>
                                        <select id="period_selector" class="select2 w-100 daterange form-control">
                                            <option value="today">Today</option>
                                            <option value="yesterday">Yesterday</option>
                                            <option value="last 7 days">Last 7 days</option>
                                            <option value="last 30 days">Last 30 days</option>
                                            <option value="this month">This month</option>
                                            <!-- <option value="last month">Last month</option> -->
                                            <option value="custom">Custom Date Range</option>
                                        </select>
                                    </div>
                                    <div id="daterange_custom_staff" class="align-left col-md-6 col-12"
                                        style="display:none;">
                                        <div class="row">
                                            <div class="form-group col-md-6 col-12">
                                                <label for="start_date" class="mb-0">Start date</label>
                                                <input type="date" id="custom_start" class="form-control">
                                            </div>
                                            <div class="form-group col-md-6 col-12">
                                                <label for="end_date" class="mb-0">End date</label>
                                                <input type="date" id="custom_end" class="form-control">
                                            </div>
                                        </div>
                                    </div>

                                    <!-- <div class="table-responsive"> -->
                                    <!-- Staff Attendance Matrix (Date Range) -->
                                    <div class="table-responsive p-2">
                                        <table id="staff_att_report_table" class="display" width="100%">
                                            <thead id="attendance_matrix_head"></thead>
                                            <tbody id="attendance_matrix_body">
                                                <!-- Matrix will be loaded here -->
                                            </tbody>
                                        </table>
                                    </div>
                                    <!-- </div> -->
                                </div>
                            </div>
                            <!-- <div class="container">
                    </div> -->
                        </div>
                    </div>
                </div>
            </div>

            <!-- QR Scanner Modal -->
            <div class="modal fade" id="qrScannerModal" tabindex="-1" role="dialog"
                aria-labelledby="qrScannerModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-lg" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <p class="modal-title font-weight-bold" id="qrScannerModalLabel">Scan Staff QR Code
                            </p>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <div class="modal-body">
                            <div style="position: relative;">
                                <div
                                    style="position: absolute; top:0; left: 0; z-index: 1; padding: 10px; background: rgba(0,0,0,0.5); backdrop-filter: blur(5px); border-radius: 5px;">
                                    <select id="cameraSelector" class="form-control form-control-sm d-inline-block mr-2"
                                        style="width: auto; color:white; background: rgba(255,255,255,0.1);">
                                        <option value="">Loading cameras...</option>
                                    </select>
                                </div>
                                <div>
                                    <video id="preview" playsinline style="width:100%;height:60vh;"></video>
                                </div>
                                <button id="flashButton" class="flash-button d-none">
                                    <i class="fas fa-bolt"></i> Toggle Flash
                                </button>
                                <div id="qr-result"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Add message container -->
            <div id="message" class="message"></div>
            <!-- Manual Attendance Modal -->
            <div class="modal fade" id="manualAttendanceModal" tabindex="-1" role="dialog"
                aria-labelledby="manualAttendanceModalLabel" aria-hidden="true">
                <div class="modal-dialog" role="document">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="manualAttendanceModalLabel">Mark Staff Attendance</h5>
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                                <span aria-hidden="true">&times;</span>
                            </button>
                        </div>
                        <form id="manualAttendanceForm">
                            <div class="modal-body">
                                <input type="hidden" id="modal_staff_id" name="staff_id">
                                <div class="form-group">
                                    <label for="modal_staff_name">Staff</label>
                                    <input type="text" class="form-control" id="modal_staff_name" name="staff_name"
                                        readonly>
                                </div>
                                <div class="form-group">
                                    <label for="modal_date">Date</label>
                                    <input type="date" class="form-control" id="modal_date" name="date" readonly>
                                </div>
                                <div class="form-group">
                                    <label for="modal_check_in">Check-In Time</label>
                                    <input type="time" class="form-control" id="modal_check_in" name="check_in">
                                </div>
                                <div class="form-group">
                                    <label for="modal_check_out">Check-Out Time</label>
                                    <input type="time" class="form-control" id="modal_check_out" name="check_out">
                                </div>
                                <div class="form-group">
                                    <label for="modal_status">Status</label>
                                    <input type="text" class="form-control" id="modal_status" name="status" readonly>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                                <button type="submit" class="btn btn-primary">Save</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script src="../plugins/jquery/jquery.min.js"></script>
        <!-- Bootstrap 4 -->
        <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
        <script src="../plugins/select2/js/select2.full.min.js"></script>
        <!-- AdminLTE App -->
        <script src="../dist/js/adminlte.min.js"></script>
        <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
        <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
        <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
        <script src="../plugins/toastr/toastr.min.js"></script>
        <!-- Select2 -->
        <!-- Include Instascan library -->
        <script src="https://rawgit.com/schmich/instascan-builds/master/instascan.min.js"></script>
        <script src="../dist/js/staff_attendance.js?v=005"></script>
        <script>
        // $("#att_log_scan").DataTable({
        //     scrollX: true,

        // })
        </script>
</body>

</html>