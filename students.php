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
    <title>Students</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Select2 -->
    <!-- Using local Select2 for consistency -->
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <style>
        .parent_Search_btn:hover {
            background-color: aliceblue;
        }

        table.dataTable,
        table.dataTable th,
        table.dataTable td {
            border: none !important;
            vertical-align: top !important;
        }

        table.dataTable thead th,
        table.dataTable tfoot th {
            border-bottom: none !important;
        }

        table.dataTable.stripe tbody tr.odd,
        table.dataTable.stripe tbody tr.even {
            background-color: transparent !important;
        }



        .filter_Select+.select2-container {
            width: 150px !important;
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
                <img src="../..//<= $_SESSION['logo'] ?>" style="height: 200px; object-fit:cover;" alt="Logo"
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
                            <a href="students" class="nav-link active">
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
                <input type="hidden" id="student_page" value="display_students">

                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Manage Students</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">Manage Students</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container-fluid mt-4">
                            <div>
                            <select id="myselect" class="select2" style="width: 100%;">

                            </select>
                        </div>
                    <div class="py-3 px-15 bg-white" style="border-radius: 10px;">

                        <?php
                        if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4 || $_SESSION['register_student'] == 1) {
                        ?>
                            <button type="button" class="btn btn-primary mb-4 d-flex" data-toggle="modal" data-target="#add_student_modal"><span class="material-symbols-outlined mr-2">add</span>Enroll New Student</button>

                        <?php } ?>
                        <div class="d-flex mb-3 align-items-center">
                            <div class="">
                                <p class="muted-text mr-1">Filter:</p>
                            </div>
                            <div>

                                <select class="select2 filter_Select border-0 form-control" onchange="filter_stud_Class()" id="">
                                    <?php
                                    $select_classes = mysqli_query($conn, "SELECT id, classname FROM class WHERE school_id='$school_id' ORDER BY classname ASC");
                                    while ($class_row = mysqli_fetch_array($select_classes)) {
                                    ?>
                                        <option value="<?= $class_row['id'] ?>"><?= $class_row['classname'] ?></option>
                                    <?php
                                    }
                                    ?>
                                </select>
                            </div>

                        </div>
                        <div class="custom-div-after-search" style="display: none;">
                            <div style="display: flex; align-items: center;">
                                <div class="icheck-primary mr-3">
                                    <input type="checkbox" id="select_all" onchange="check_uncheck_all()">
                                    <label for="select_all" class="text-primary px-2">Select all</label>
                                </div>
                                <p class="mr-3 text-danger font-weight-normal action_btn" style="display:none; margin: 0; cursor: pointer;" onclick="get_all_checked_checkbox('multiple',null,'delete_student_modal')">Delete Students</p>
                                <p class="font-weight-normal action_btn" style="display:none; margin: 0; cursor: pointer;" onclick="get_all_checked_checkbox('multiple',null,'bulk_transfer_modal')">Transfer Students</p>
                            </div>
                        </div>
                        <table id="student_table" class="" style="width:100%;">
                        </table>
                    </div>
                </div>
            </div>
            <!-- /.row -->
        </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->

    <div class="modal fade" id="bulk_transfer_modal">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body">
                    <form class="transfer_student_modal" onsubmit="transfer_student_modal(event, 'student_table', '../display_student_table.php')" action="controller.php">
                        <div class="form-group">
                            <label for="select_class_transfer_field">Select class to transfer student(s) to</label>
                            <select class="form-control select2" name="class_id" onchange="getstudents(this.value)" id="classes_select" style="width: 100%;" required>
                                
                            </select>
                        </div>
                
                        <input type="hidden" name="action" value="transfer_students">
                        <input type="hidden" name="ids" value="" class="bulk_transfer_ids">
                        <div class="card-foot">
                            <div class="alert myalert alert-dismissible" style="display: none;">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                <p class="warning small text-danger"></p>
                            </div>
                            <p class="warning small text-danger" style="display: none;"></p>
                            <button type="submit" id="student_transfer_btn" class="btn-sm btn-primary">Transfer Now</button>
                            <button type="button" class="btn btn-grey" data-dismiss="modal" aria-label="Close">Close</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="reset_student_password_modal">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body">
                    <form class="reset_student_password_modal" onsubmit="reset_student_password_modal(event)">
                        <div class="form-group">
                            <label for="select_class_transfer_field">Set a New Password</label>
                            <input type="password" name="new_password" class="form-control" required>
                        </div>

                        <input type="hidden" name="action" value="reset_student_password">
                        <input type="hidden" name="id" value="" id="student_id_for_password_reset">
                        <div class="card-foot">
                            <div class="alert myalert alert-dismissible" style="display: none;">
                                <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                                <p class="warning small text-danger"></p>
                            </div>
                            <p class="warning small text-danger" style="display: none;"></p>
                            <button type="submit" id="reset_student_password_btn" class="btn-sm btn-primary">Reset</button>
                            <button type="button" class="btn btn-grey" data-dismiss="modal" aria-label="Close">Close</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="delete_student_modal">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body">
                    <form onsubmit="delete_student_modal(event)">
                        <p>Are you sure to delete the student information permanently</p>
                        <input type="hidden" name="action" value="delete_student_data" class="">
                        <input type="hidden" name="ids" value="" class="bulk_transfer_ids">

                        <div class="card-foot">
                            <button type="submit" class="btn-sm btn-primary">Delete Permanently</button>
                            <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Close</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="add_student_modal">
        <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Enroll New Student</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body pb-0">
                    <form id="add_student_modal_id" onsubmit="add_student_data(event)" runat="server" enctype="multipart/form-data">

                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-12">
                                    <input type="hidden" name="action" value="add_student_data">
                                    <div class="form-group mr-3" style="position:relative; max-width: 100px;">
                                        <img id="image_profile_preview" title="click to select photo" src="./../dist/img/avatar.png" alt="Photo" width="100" height="100">
                                        <input type="file" name="studentphoto" accept="image/png, image/jpg, image/jpeg" id="image_profile_add" style="display: none;" onchange="preview_image(event)" class="form-control">
                                        <label for="image_profile_add" style="position:absolute; color: transparent; width: 100%; height: 100%; left:0; top:0;">Select
                                            Photo</label>
                                        <p class="small mb-0 text-center">Click to select photo</p>
                                    </div>
                                    <p class="font-weight-bold text-muted">Basic Data</p>
                                    <div class="row flex-wrap" style="border-bottom:5px solid #f4f7fa">
                                        <div class="mb-3 col-sm-6 col-12">
                                            <label for="firstname" class="mb-0 muted-text">Firstname</label>
                                            <input id="firstname" name="firstname" type="text" placeholder="Firstname" class="form-control" required>
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <label for="lastname" class="mb-0 muted-text">Lastname</label>
                                            <input name="lastname" type="text" placeholder="Lastname" class="form-control" required>
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Middlename</p>
                                            <input type="text" name="middlename" placeholder="Middlename" class="form-control">
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Admission number</p>
                                            <input type="text" name="admissionnumber" placeholder="Admission number" class="form-control">
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Class</p>
                                            <select class="form-control select2" name="class_id" style="width: 100%;" required>
                                                <option value="">Select Class</option>
                                                <?php
                                                $selectclass = mysqli_query($conn, "SELECT id,classname FROM class WHERE school_id='$school_id'");
                                                while ($classrow = mysqli_fetch_array($selectclass)) {
                                                ?>
                                                    <option value="<?= $classrow['id'] ?>"><?= $classrow['classname'] ?></option>
                                                <?php
                                                }
                                                ?>
                                            </select>
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Gender</p>
                                            <select class="form-control select2" name="gender" style="width: 100%;" required>
                                                <option value="">Select Gender</option>
                                                <option value="Male">Male</option>
                                                <option value="Female">Female</option>
                                            </select>
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Date of Birth</p>
                                            <input type="date" name="dob" class="form-control" placeholder="Date">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 mt-3">
                                    <p class="font-weight-bold text-muted">Contact Information</p>
                                    <div class="row flex-wrap" style="border-bottom:5px solid #f4f7fa">
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Phone number</p>
                                            <input type="text" name="phone" class="form-control" placeholder="Student phone number">
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Email address</p>
                                            <input type="email" name="email" class="form-control" placeholder="Email address">
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 mt-3">
                                    <p class="font-weight-bold text-muted">Parent Information</p>

                                    <div class="w-100 mb-3">
                                        <!-- <div class="dropdown">
                                            <p class="mb-0 muted-text">Parent Phone number</p>
                                            <input type="text" name="parentphone" oninput="input_search(this)" class="form-control search_parentphone" autocomplete="tel" placeholder="Parent phone number" required>
                                            <div class="dropdown-menu parentphone_dropdown" style="top: 80%">
                                                <div class="parent_Search_result"></div>
                                            </div>
                                            <small class="text-muted">Accepted format: 08136467317</small>
                                        </div> -->

                                        <div class="">
                                            <p class="mb-0 muted-text">Parent Phone number</p>
                                            <select name="parentphone" id="add_search_parentphone" class="form-control search_parentphone" style="width: 100%;" required></select>
                                            <small class="text-muted">Accepted format: 08136467317</small>
                                        </div>


                                    </div>
                                    <div class="row flex-wrap">
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Parent First Name</p>
                                            <input type="text" name="parentfname" required class="form-control pa_firstname" autocomplete="given-name" placeholder="Parent first name">
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Parent Last Name</p>
                                            <input type="text" name="parentlname" class="form-control pa_lastname" autocomplete="family-name" placeholder="Parent last name" required>
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Email address</p>
                                            <input type="email" name="parentemail" class="pa_email form-control" autocomplete="email" placeholder="Parent email address">
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Full Address</p>
                                            <input type="text" name="address" autocomplete="address-level1" class="pa_address form-control" placeholder="5, Kingsway street, Maryland, Lagos" id="">
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">City</p>
                                            <input type="text" name="city" autocomplete="address-level1" class="pa_city form-control" placeholder="City" id="">
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">State</p>
                                            <input type="text" name="state" autocomplete="address-level1" class="pa_state form-control" placeholder="State" id="">
                                        </div>
                                        <div class="mb-3 col-sm-6 col-12">
                                            <p class="mb-0 muted-text">Country</p>
                                            <input type="text" name="country" autocomplete="address-level1" class="pa_country form-control" placeholder="Country" id="">
                                        </div>
                                    </div>
                                </div>
                                <!-- </div> -->
                                <!-- </div> -->
                            </div>
                            <div class="card-foot">
                                <div class="text-center">
                                    <small class="text-danger" id="add_student_data_warning" style="display: none;">Staff already added</small>
                                </div>
                                <button type="submit" for="add_student_modal_id" id="add_student_btn" class="btn btn-primary">Register</button>
                                <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Cancel</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="view_student_modal">
        <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">View Student Information</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body" id="view_student_modal_body">
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="edit_parent_modal">
        <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Update Parent Data</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body pb-0" id="edit_parent_modal_body">
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="edit_student_modal">
        <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
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
    </div>
    <!-- ./wrapper -->

    <!-- REQUIRED SCRIPTS -->

    <!-- jQuery -->


    <script src="../plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- Select2 (using local for consistency) -->
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>

    <!-- <script>$('.select2').select2()</script> -->
    <script src="../dist/js/skul.js"></script>
    <script>
        // Initialize select2 and load class groups via AJAX
        $(function() {
            function initClassSelect(data) {
                $('#classes_select').empty();
                $('#classes_select').select2({
                    data: data,
                    width: 'resolve'
                });
            }

            // Fetch grouped classes from the server
            $.ajax({
                url: '../controller.php',
                data: { "action":"get_current_graduate_classes" },
                type: 'POST',
                // method: 'POST',
                dataType: 'json'
            }).done(function(response) {
                // response expected to be an array of groups [{text, children: [{id,text}, ...]}, ...]
                initClassSelect(response);
            }).fail(function(jqXHR, textStatus, errorThrown) {
                console.error('Failed to load classes for select2:', textStatus, errorThrown);
                // fallback to empty select
                initClassSelect([]);
            });
        });
    </script>



</body>

</html>