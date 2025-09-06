<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
// echo $_SESSION['userid'];
// exit;
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Communication </title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <!-- Toastr -->
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <!-- Select2 -->
    <style>
        /* th:first-child,
        td:first-child {
            width: 100px !important;
        } */

        .assess_input {
            border: 1px solid #a7a7a7;
            border-radius: 5px;
            padding-top: 5px;
            padding-bottom: 5px;
            padding-left: 6px;
            padding-right: 6px;
        }

        /* .assess_head{
            max-width: 100px !important;
        } */

        /* .assess_subject, .assess_head {
            max-width: 100px !important;
        } */

        .btn.togglebtn {
            padding: 0.25rem 0.5rem !important;
        }

        .material-symbols-outlined {
            font-variation-settings:
                'FILL' 0,
                'wght' 300,
                'GRAD' 0,
                'opsz' 20
        }

        .resize_column {
            max-width: 100px;
            overflow: hidden;
            white-space: nowrap;
            text-overflow: ellipsis;
        }

        .table-wrapper {
            display: flex;
            width: 100%;
            overflow-x: auto;
            border: 1px solid #ddd;
            /* Optional: Add border for better visual */
        }

        .table-container {
            display: flex;
        }

        .frozen-column,
        .scrollable-columns {
            border-collapse: collapse;
        }

        .frozen-column {
            background-color: #f2f2f2;
            /* Optional: Background color for frozen column */
            position: sticky;
            left: 0;
            z-index: 1;
        }

        .scrollable-container {
            overflow-x: auto;
        }

        th,
        td {
            border: none;
            padding: 5px;
            text-align: left;
        }

        th {
            border: none;
            background-color: transparent;
            color: inherit;
        }

        .scrollable-container table {
            min-width: 600px;
            /* Adjust based on your content */
        }

        .search_select2 .select2-container {
            display: none;
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
                            <a href="communication" class="nav-link active">
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
        <div class="content-wrapper" style="padding-bottom: 100px;">


            <!-- Main content -->
            <div class="content">
                <!-- do not delete the input hidden, it is used to identify the page in js file -->
                <input type="hidden" id="comm_page" value="communication">
                <div class="container-fluid">
                    <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                        <div class="mb-3">
                            <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Manage Communication</h2>
                            <ol class="breadcrumb p-0 bg-white mb-0">
                                <li class="breadcrumb-item font-14">
                                    <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                        <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>Dashboard</a>
                                </li>
                                <li class="breadcrumb-item active font-14">Manage Communication<li>
                            </ol>
                        </div>
                        <div>
                            <div class="form-group">
                                <label for="" class="mb-0">Means of communication</label>
                                <div class="w-100">
                                    <button class="btn select_btn comm active mr-2" id="email_select" onclick="comm_means_toggle(this)">Email</button>
                                    <button class="btn select_btn comm  mr-2" id="message_select" onclick="comm_means_toggle(this)">SMS</button>
                                    <button class="btn select_btn comm  mr-2" id="int_message_select" onclick="comm_means_toggle(this)">Internal Message</button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="" class="mb-0">Send To:</label>
                                <select name="" id="reciepient_type" onchange="select_receipient()" class="select2 form-control">
                                    <option value="">Select option</option>
                                    <option value="staff_specific">Specific staff</option>
                                    <option value="parent_specific">Specific parent</option>
                                    <option value="all_staff">All staff</option>
                                    <option value="all_parent">All parents</option>
                                    <option value="all_teacher">All teachers</option>
                                    <option value="all_propietors">All propietors</option>
                                    <option value="all_propietress">All propietress</option>
                                    <option value="all_principals">All principal</option>
                                    <option value="all_admin">All Admin</option>
                                </select>
                                <div class="search_select2 form-group" style="margin-top: 20px;">
                                    <select name="" id="search_parent_comm" onchange="select_receipient_specific(this)" placeholder="Search by parent name,phone number or student name" class="select2 form-control" style="display: none;">

                                    </select>
                                    <select name="" id="search_staff_comm" onchange="select_receipient_specific(this)" placeholder="Search by staff name or phone number" class="select2 form-control" style="display: none;">

                                    </select>
                                </div>
                            </div>
                            <div id="send_to_box" style="display: none; margin-bottom:20px; background-color:antiquewhite; border-radius: 10px; padding: 10px 15px;">
                                <p class="font-weight-bold">Receipients</p>
                                <div id="reciepient_list" style="display:flex; gap: 5px; flex-wrap:wrap;">
                                </div>
                            </div>
                            <input type="hidden" id="reciepient_email_list" value="">
                            <div class="form-group" id="email_subject_comm">
                                <input type="text" class="form-control" placeholder="Subject" name="" id="message_subject">
                            </div>
                            <div class="form-group">
                                <textarea class="form-control" name="" id="message_body" cols="30" rows="10" placeholder="Type your email here"></textarea>
                            </div>
                            <div class="form-group align-left">
                                <button type="button" class="btn btn-primary" id="email_comm_btn" onclick="sendEmail()">Send email</button>
                                <button type="button" class="btn btn-primary" id="message_comm_btn" style="display: none;" onclick="send_message()">Send SMS</button>
                                <button type="button" class="btn btn-primary" id="int_message_comm_btn" style="display: none;" onclick="send_internal()">Send Message</button>
                            </div>

                            <!-- <button class="btn select_btn mr-2" id="" data-toggle="modal" data-target="#select_staff_message_modal">Staff</button> -->
                        </div>
                    </div>
                </div>
               
            </div>


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
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script src="../dist/js/skul.js"></script>
</body>

</html>