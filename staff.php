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
    <title>Staff</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <style>
        /* CSS code here */
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


        #priviledges_table tr {
            vertical-align: top;
            border-bottom: 1px solid #e8e8e8;
        }

        #priviledges_table tr:last-child {
            border-bottom: none;
        }

        #priviledges_table tr td {
            padding-bottom: 10px;
            padding-top: 10px;
        }

        @media (max-width: 576px) {
            .modal-content {
                box-shadow: 0px 10px 54px rgb(174 174 174 / 50%);
                width: 90%;
                /* box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.5); */
            }
        }

        /* .modal-backdrop.show {
            opacity: 0 !important;
        } */
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
                            <a href="staff" class="nav-link active">
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
                            <a href="bus_tracking" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">directions_bus</i>
                                    Bus Tracking
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
                <input type="hidden" id="staff_page" value="display_staff">

                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Manage Staff</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">Manage Staff</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container-fluid mt-4">
                    <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                        <?php
                        if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                        ?>
                            <button type="button" id="add_new_stffbt" class="btn btn-primary mb-4 d-flex" data-toggle="modal" data-target="#add_staff_modal"><span class="material-symbols-outlined mr-2">add</span>Register New Staff</button>
                        <?php } ?>
                        <table id="staff_tables" class="" style="width:100%;">
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
    <div class="modal fade" id="delete_staff_modal">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body">
                    <p class="mb-3">Are you sure to delete the student information permanently?</p>
                    <div class="d-flex">
                        <button type="button" id="delete_staff_modal_btn" onclick="delete_staff_modal(this)" data-id="" class="btn btn-primary">Delete Permanently</button>
                        <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Close</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="add_staff_modal">
        <div class="modal-dialog modal-lg modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Register New Staff</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body pb-0">
                    <form onsubmit="add_staff_data(event)" runat="server" enctype="multipart/form-data" title="Register New Staff Form">

                        <div class="container-fluid">
                            <div class="row">
                                <div class="col-12">
                                    <input type="hidden" name="action" value="add_staff_data">
                                    <div class="form-group mr-3" title="Click to change photo" style="position:relative; max-width: 100px;">
                                        <img id="image_profile_preview" title="Click to select photo" src="./../dist/img/avatar.png" alt="Photo" width="100" height="100">

                                        <input type="file" name="photo" accept="image/png, image/jpeg, image/jpg" id="image_profile_add" style="display: none;" onchange="preview_image(event)" class="form-control">
                                        <label for="image_profile_add" style="position:absolute; color: transparent; width: 100%; height: 100%; left:0; top:0;">Select
                                            Photo</label>
                                        <p class="small mb-0 text-center">Click to select photo</p>
                                    </div>
                                    <p class="font-weight-bold text-muted">Basic Data</p>
                                    <div class="row flex-wrap" style="border-bottom:5px solid #f4f7fa">

                                        <div class="mb-3 col-sm-4 col-12">
                                            <label for="firstname" class="mb-0 muted-text">Firstname</label>
                                            <input id="firstname" autocomplete="given-name" name="firstname" title="Staff first name" type="text" placeholder="Enter Firstname" class="form-control" required>
                                        </div>
                                        <div class="mb-3 col-sm-4 col-12">
                                            <label for="lastname" class="mb-0 muted-text">Lastname</label>
                                            <input name="lastname" type="text" autocomplete="family-name" title="Staff last name or surname" placeholder="Enter Lastname" class="form-control" required>
                                        </div>
                                        <div class="mb-3 col-sm-4 col-12">
                                            <label class="mb-0 muted-text">Middlename</label>
                                            <input type="text" autocomplete="given-name" title="Staff middle name" name="middlename" placeholder="Enter Middlename" class="form-control">
                                        </div>

                                        <div class="mb-3 col-sm-4 col-12">
                                            <label class="mb-0 muted-text">Gender</label>
                                            <select class="form-control select2" name="gender" style="width: 100%;" required title="Select Gender">
                                                <option value="">Select Gender</option>
                                                <option value="Male">Male</option>
                                                <option value="Female">Female</option>
                                            </select>
                                        </div>

                                        <!-- <div class="mb-3 col-sm-4 col-12">
                                            <label class="mb-0 muted-text">Assign class</label>
                                            <select class="form-control select2" name="class_id" style="width: 100%;" title="Select Class">
                                                <option value="0">Select Class</option>
                                                <php
                                                $selectclass = mysqli_query($conn, "SELECT id,classname FROM class WHERE school_id='$school_id'");
                                                while ($classrow = mysqli_fetch_array($selectclass)) {
                                                ?>
                                                    <option value="<= $classrow['id'] ?>"><= $classrow['classname'] ?></option>
                                                <php
                                                }
                                                ?>
                                            </select>
                                        </div> -->
                                        <div class="mb-3 col-sm-4 col-12">
                                            <label class="mb-0 muted-text">Staff Role</label>
                                            <select class="form-control select2" name="staff_role" style="width: 100%;" required title="Select Staff Role">
                                                <option value="">Select role</option>
                                                <?php
                                                $selectclass = mysqli_query($conn, "SELECT id,type FROM staff_type ORDER BY id ASC");
                                                while ($classrow = mysqli_fetch_array($selectclass)) {
                                                ?>
                                                    <option value="<?= $classrow['id'] ?>"><?= $classrow['type'] ?></option>
                                                <?php
                                                }
                                                ?>
                                            </select>
                                            <small class="text-muted">For bus drivers, choose the Driver role here, then assign the staff member to a bus on Bus Tracking.</small>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-12 mt-3">
                                    <p class="font-weight-bold text-muted">Contact Information</p>
                                    <div class="row flex-wrap">
                                        <div class="mb-3 col-sm-4 col-12">
                                            <label class="mb-0 muted-text">Phone</label>
                                            <input type="text" name="phone" class="form-control" required placeholder="Enter Phone number" title="Phone number">
                                        </div>
                                        <div class="mb-3 col-sm-4 col-12">
                                            <p class="mb-0 muted-text">Email address</p>
                                            <input type="email" autocomplete="email" required name="email" class="form-control" placeholder="Enter Email address" title="Email address">
                                        </div>
                                        <div class="mb-3 col-sm-4 col-12">
                                            <p class="mb-0 muted-text">Full Address</p>
                                            <input type="text" name="address" autocomplete="address-level1" class="form-control" placeholder="Enter Full Address" title="Full Address">
                                        </div>
                                        <div class="mb-3 col-sm-4 col-12">
                                            <p class="mb-0 muted-text">City</p>
                                            <input type="text" name="city" autocomplete="address-level1" class="form-control" placeholder="Enter City" title="City">
                                        </div>
                                        <div class="mb-3 col-sm-4 col-12">
                                            <p class="mb-0 muted-text">State</p>
                                            <input type="text" name="state" autocomplete="address-level1" class="form-control" placeholder="Enter State" title="State">
                                        </div>
                                        <div class="mb-3 col-sm-4 col-12">
                                            <p class="mb-0 muted-text">Country</p>
                                            <input type="text" name="country" autocomplete="address-level1" class="form-control" placeholder="Enter Country" title="Country">
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card-foot">
                            <div class="d-flex w-100">
                                <small class="text-danger myalert p-2 mb-2 w-100" id="add_staff_data_warning" style="text-align:center; display:none;">Staff data already exist.</small>
                            </div>
                            <button type="submit" id="add_new_staff_submit_btn" class="btn btn-primary">Register</button>
                            <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="view_staff_modal">
        <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">View Staff Data</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body" id="view_staff_modal_body">
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="edit_staff_modal">
        <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Update Staff Data</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body pb-0" id="edit_staff_modal_body">
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="staff_priviledges_modal">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content" id="staff_priviledges_modal_content">

            </div>
        </div>
    </div>
    <div class="modal fade" id="staff_subjectsbyclasses_modal">
        <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content" id="staff_subjectsbyclasses_modal_content">
                <div class="modal-header">
                    <div>
                        <input type="hidden" id="staff_id" name="staff_id" class="staff_id" value="${id}">
                        <p class="modal-title">Assign Subjects by Classes</p>
                    </div>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body" id="staff_subjectsbyclasses_modal_body">
                    <!-- <div class="accordion" id="accordionExample">
                        <div class="card">
                            <div class="card-header" id="headingOne">
                                <h2 class="mb-0">
                                    <button class="btn btn-link btn-block text-left" type="button" data-toggle="collapse" data-target="#collapseOne" aria-expanded="true" aria-controls="collapseOne">
                                        JSS1
                                    </button>
                                </h2>
                            </div>

                            <div id="collapseOne" class="collapse show" aria-labelledby="headingOne" data-parent="#accordionExample">
                                <div class="card-body">
                                    <div class="btn-group-toggle" data-toggle="buttons">
                                        <label class="btn btn-outline-primary">
                                            <input type="checkbox" name="options" id="all_none"> All
                                        </label>
                                        <label class="btn btn-outline-primary">
                                            <input type="checkbox" name="options" id="option1"> Radio
                                        </label>
                                        <label class="btn btn-outline-primary">
                                            <input type="checkbox" name="options" id="option2"> Radio
                                        </label>
                                        <label class="btn btn-outline-primary">
                                            <input type="checkbox" name="options" id="option3"> Radio
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-header" id="headingTwo">
                                <h2 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseTwo" aria-expanded="false" aria-controls="collapseTwo">
                                        JSS2
                                    </button>
                                </h2>
                            </div>
                            <div id="collapseTwo" class="collapse" aria-labelledby="headingTwo" data-parent="#accordionExample">
                                <div class="card-body">
                                   <div class="btn-group-toggle" data-toggle="buttons">

                                       <label class="btn btn-outline-primary">
                                           <input type="checkbox" name="options" id="all_none"> All
                                       </label>
                                       <label class="btn btn-outline-primary">
                                           <input type="checkbox" name="options" id="option2"> Radio
                                       </label>
                                       <label class="btn btn-outline-primary">
                                           <input type="checkbox" name="options" id="option3"> Radio
                                       </label>
                                   </div>
                                </div>
                            </div>
                        </div>
                        <div class="card">
                            <div class="card-header" id="headingThree">
                                <h2 class="mb-0">
                                    <button class="btn btn-link btn-block text-left collapsed" type="button" data-toggle="collapse" data-target="#collapseThree" aria-expanded="false" aria-controls="collapseThree">
                                        JSS3
                                    </button>
                                </h2>
                            </div>
                            <div id="collapseThree" class="collapse" aria-labelledby="headingThree" data-parent="#accordionExample">
                                <div class="card-body">
                                    <div class="btn-group-toggle" data-toggle="buttons">

                                        <label class="btn btn-outline-primary">
                                            <input type="checkbox" name="options" id="all_none"> All
                                        </label>
                                        <label class="btn btn-outline-primary">
                                            <input type="checkbox" name="options" id="option2"> Radio
                                        </label>
                                        <label class="btn btn-outline-primary">
                                            <input type="checkbox" name="options" id="option3"> Radio
                                        </label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div> -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" id="assign_staff_subjects_by_classes_btn" onclick="assign_staff_subjects_by_classes()">Assign Subjects</button>
                    <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Close</button>
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
    <!-- Select2 -->
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <script src="../dist/js/skul.js"></script>
</body>
<script>
    // function preview_image12(event) {
    //                     alert('kin')
    //                     var reader = new FileReader();
    //                     reader.onload = function () {
    //                         var img = event.target.previousElementSibling;
    //                         event.target.nextElementSibling.nextElementSibling.innerHTML =
    //                             event.target.value.split("\\").pop();
    //                         img.src = reader.result;
    //                     };
    //                     reader.readAsDataURL(event.target.files[0]);
    //                 }
</script>

</html>
