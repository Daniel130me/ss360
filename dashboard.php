<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}

//    echo "<script>
//       var loc = localStorage.getItem('location');
//       if (loc) {
//          window.location = loc.split('/').pop();
//       }
//    </script>";

// if(isset($_SESSION['location'])) {
//     // echo $_SESSION['location'];
// //    echo  "<script>

// //         window.location.href = '" . $_SESSION['location'] . "';
// //     </script>";
// //     exit;
// }
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
// echo $_SESSION['location'];
// exit;

// }
?>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard | <?= get_staff_fullname_by_id($_SESSION['userid'])?></title>

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
    <style>
        .each_message_notice {
            border-bottom: 1px solid lightgrey;
        }

        .btn-circle {
            width: 50px;
            height: 50px;
            padding: 10px;
            border-radius: 50%;
            text-align: center;
            font-size: 16px;
            line-height: 1.42857;
            display: inline-block;
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
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .scrollable-container table {
            min-width: 600px;
            /* Adjust based on your content */
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
                    <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu"
                        data-accordion="false">

                        <li class="nav-item">
                            <a href="dashboard" class="nav-link active">
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


            <!-- Main content -->
            <section class="content">
                <div class="container-fluid">
                    <!-- Info boxes -->
                    <div class="row">
                        <!-- <div class="col-12 col-sm-6 col-md-3">
                            <div class="info-box align-items-center" style="min-height:70px;">
                                <span class="info-box-icon bg-info elevation-1 order-2" style="width: 45px; height: 45px; border-radius: 100%;"><i class="material-symbols-outlined pr-2" style="font-size: 50px;">person</i></span>

                                <div class="info-box-content" style="line-height: 1;">
                                    <span class="info-box-text">Male Students</span>
                                    <span class="info-box-number" style="font-size: 32px; line-height:1;">
                                        <= get_male_students() ?>
                                    </span>
                                </div>
                            </div>
                        </div> -->
                        <!-- /.col -->
                        <div class="col-12 col-sm-6 col-md-3">
                            <div class="info-box align-items-center mb-3" style="min-height: 75px; box-shadow:none;">
                                <span class="info-box-icon material-symbols-outlined pr-2"
                                    style="font-size: 30px; border-radius: 100% !Important; width: 45px; height: 45px; background-color:#FDF8F1; color:#FF7A3D; border-radius: 15px;">person</span>

                                <div class="info-box-content" style="line-height: 1;">
                                    <span class="info-box-text muted-text">Male Students</span>
                                    <span class="info-box-number"
                                        style="font-size: 24px; line-height:1; color:#343a40; "><?= get_male_students() ?></span>
                                </div>
                                <!-- /.info-box-content -->
                            </div>
                            <!-- /.info-box -->
                        </div>
                        <div class="col-12 col-sm-6 col-md-3">
                            <div class="info-box align-items-center mb-3" style="min-height: 75px; box-shadow:none;">
                                <span class="info-box-icon material-symbols-outlined pr-2"
                                    style="font-size: 30px; border-radius: 100% !Important; width: 45px; height: 45px; color:#007bff; background-color:#E6EDF9; border-radius: 15px;">group</span>

                                <div class="info-box-content" style="line-height: 1;">
                                    <span class="info-box-text muted-text">Female Students</span>
                                    <span class="info-box-number"
                                        style="font-size: 24px; line-height:1; color:#343a40; "><?= get_female_students() ?></span>
                                </div>
                                <!-- /.info-box-content -->
                            </div>
                            <!-- /.info-box -->
                        </div>
                        <div class="col-12 col-sm-6 col-md-3">
                            <div class="info-box align-items-center mb-3" style="min-height: 75px; box-shadow:none;">
                                <span class="info-box-icon material-symbols-outlined pr-2"
                                    style="font-size: 30px; border-radius: 100% !Important; width: 45px; height: 45px; color:#5A247B; background-color:#F4EBF9; border-radius: 15px;">supervisor_account</span>

                                <div class="info-box-content" style="line-height: 1;">
                                    <span class="info-box-text muted-text">Total Staff</span>
                                    <span class="info-box-number"
                                        style="font-size: 24px; line-height:1; color:#343a40; "><?= get_total_staff() ?></span>
                                </div>
                                <!-- /.info-box-content -->
                            </div>
                            <!-- /.info-box -->
                        </div>
                        <div class="col-12 col-sm-6 col-md-3">
                            <div class="info-box align-items-center mb-3" style="min-height: 75px; box-shadow:none;">
                                <span class="info-box-icon material-symbols-outlined pr-2 fas fa-users"
                                    style="font-size: 25px; border-radius: 100% !Important; width: 45px; height: 45px; color:#ff8174; background-color:#ffebe9; border-radius: 15px;"></span>

                                <div class="info-box-content" style="line-height: 1;">
                                    <span class="info-box-text muted-text">Parents</span>
                                    <span class="info-box-number"
                                        style="font-size: 24px; line-height:1; color:#343a40; "><?= get_total_parent() ?></span>
                                </div>
                                <!-- /.info-box-content -->
                            </div>
                            <!-- /.info-box -->
                        </div>
                        <!-- /.col -->

                        <!-- fix for small devices only -->
                        <div class="clearfix hidden-md-up"></div>
                        <!-- 
                        <div class="col-12 col-sm-6 col-md-3">
                            <div class="info-box mb-3">
                                <span class="info-box-icon bg-danger elevation-1 material-symbols-outlined pr-2" style="font-size: 50px;">supervisor_account</span>

                                <div class="info-box-content">
                                    <span class="info-box-text">Staff</span>
                                    <span class="info-box-number"><= get_total_staff() ?></span>
                                </div>
                                <-- /.info-box-content -->
                        <!-- </div>
                            <-- /.info-box -
                        </div> -->
                        <!-- /.col -->
                        <!-- <div class="col-12 col-sm-6 col-md-3">
                            <div class="info-box mb-3">
                                <span class="info-box-icon bg-warning elevation-1"><i class="fas fa-users"></i></span>

                                <div class="info-box-content">
                                    <span class="info-box-text">Parents</span>
                                    <span class="info-box-number"><= get_total_parent() ?></span>
                                </div>
                                <-- /.info-box-content -->
                        <!-- </div>
                        </div> -->

                    </div>
                    <!-- /.row -->


                    <!-- /.row -->

                    <!-- Main row -->
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card card-primary">
                                <div class="card-header border-transparent" style="border-radius: 10px 10px; box-shadow: 0px 4px 12px -2px #adaaaa;">
                                    <p class="card-title">Notice</p>

                                    <div class="card-tools">
                                        <button type="button" class="btn btn-tool" data-card-widget="maximize">
                                            <i class="fas fa-expand"></i>
                                        </button>
                                        <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                    </div>
                                </div>
                                <!-- /.card-header -->
                                <div class="card-body">
                                    <div id="notice_comm">
                                    </div>
                                </div>

                                <!-- /.card-footer -->
                            </div>
                            <div class="card card-primary">
                                <div class="card-header border-transparent" style="border-radius: 10px 10px; box-shadow: 0px 4px 12px -2px #adaaaa;">
                                    <p class="card-title">Classes</p>

                                    <div class="card-tools">
                                        <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                    </div>
                                </div>
                                <!-- /.card-header -->
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table m-0">
                                            <thead>
                                                <tr>
                                                    <th class="bg-white">Classes</th>
                                                    <th class="bg-white">Students</th>
                                                    <th class="bg-white">Teachers</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php
                                                $select = mysqli_query($conn, "SELECT id, classname FROM class WHERE school_id='{$_SESSION['school_id']}'");
                                                while ($row = mysqli_fetch_array($select)) {
                                                ?>
                                                    <tr>
                                                        <td><?= $row['classname'] ?></td>
                                                        <td><?= get_no_of_student_by_id($row['id']) ?></td>
                                                        <td><?= get_no_of_teacher_by_id($row['id']) ?></td>
                                                    </tr>
                                                <?php } ?>
                                            </tbody>
                                        </table>
                                    </div>
                                    <!-- /.table-responsive -->
                                </div>

                                <!-- /.card-footer -->
                            </div>
                            <div class="card">
                                <div class="card-header">
                                    <p class="card-title">Quick Links</p>

                                    <div class="card-tools">
                                        <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                    </div>
                                </div>
                                <!-- /.card-header -->
                                <div class="card-body p-0">

                                    <ul class="users-list clearfix px-2">
                                        <?php
                                        if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                                        ?>
                                            <li style="width: 70px;">
                                                <a href="settings" class="btn btn-circle btn-primary mb-1">
                                                    <i class="material-symbols-outlined">tune</i>
                                                </a>
                                                <a href="settings" class="users-list-name">Settings</a>
                                            </li>
                                            <li style="width: 70px;">
                                                <a href="my_payment" class="btn btn-circle btn-primary mb-1">
                                                    <span class="material-symbols-outlined mr-2">payments</span>
                                                </a>
                                                <a href="settings" class="users-list-name">Billing</a>
                                            </li>
                                        <?php } ?>
                                        <li style="width: 78px;">
                                            <a href="profile" class="btn btn-circle btn-primary mb-1">
                                                <i class="material-symbols-outlined">person</i>
                                            </a>
                                            <a href="profile" class="users-list-name">My Profile</a>
                                        </li>
                                        <li style="width: 70px;">
                                            <a href="staff" class="btn btn-circle btn-primary mb-1">
                                                <i class="material-symbols-outlined">supervisor_account</i>
                                            </a>
                                            <a href="staff" class="users-list-name">Staff</a>
                                        </li>

                                        <li style="width: 73px;">
                                            <a href="students" class="btn btn-circle btn-primary mb-1">
                                                <i class="material-symbols-outlined">supervisor_account</i>
                                            </a>
                                            <a href="students" class="users-list-name">Students</a>
                                        </li>

                                        <li style="width: 70px;">
                                            <a href="class" class="btn btn-circle btn-primary mb-1">
                                                <i class="material-symbols-outlined">app_registration</i>
                                            </a>
                                            <a href="class" class="users-list-name">Classes</a>
                                        </li>
                                        <li style="width: 70px;">
                                            <a href="students" class="btn btn-circle btn-primary mb-1">
                                                <i class="material-symbols-outlined">responsive_layout</i>
                                            </a>
                                            <a href="students" class="users-list-name">Subjects</a>
                                        </li>
                                        <li style="width: 87px;">
                                            <a href="post_scores" class="btn btn-circle btn-primary mb-1">
                                                <i class="material-symbols-outlined">add_chart</i>
                                            </a>
                                            <a href="post_scores" class="users-list-name">Post Scores</a>
                                        </li>
                                        <li style="width: 90px;">
                                            <a href="view_scores" class="btn btn-circle btn-primary mb-1">
                                                <i class="material-symbols-outlined">signal_cellular_alt</i>
                                            </a>
                                            <a href="view_scores" class="users-list-name">View Scores</a>
                                        </li>
                                        <li style="width: 90px;">
                                            <a href="reports" class="btn btn-circle btn-primary mb-1">
                                                <i class="material-symbols-outlined">add_chart</i>
                                            </a>
                                            <a href="reports" class="users-list-name">Reports</a>
                                        </li>
                                        <li style="width: 90px;">
                                            <a href="assessment" class="btn btn-circle btn-primary mb-1">
                                                <i class="material-symbols-outlined">app_registration</i>
                                            </a>
                                            <a href="assessment" class="users-list-name">Assessments</a>
                                        </li>

                                    </ul>
                                    <!-- /.users-list -->
                                </div>
                                <!-- /.card-footer -->
                            </div>
                        </div>
                        <!-- Left col -->
                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-md-12">
                                    <!-- USERS LIST -->
                                    <div class="card">
                                        <div class="card-header">
                                            <p class="card-title">List of Staff</p>

                                            <div class="card-tools">
                                                <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                                    <i class="fas fa-minus"></i>
                                                </button>
                                            </div>
                                        </div>
                                        <!-- /.card-header -->
                                        <div class="card-body p-0">

                                            <ul class="users-list clearfix">
                                                <?php
                                                $selectstaff = mysqli_query($conn, "SELECT s.photo,s.firstname,s.lastname, c.classname, t.type FROM staff s, class c, staff_type t WHERE t.id=s.staff_type AND c.id=s.class_id AND s.school_id='{$_SESSION['school_id']}' ORDER BY s.lastname ASC LIMIT 10");
                                                while ($row = mysqli_fetch_array($selectstaff)) {
                                                ?>

                                                    <li style="width: 90px;">
                                                        <img src="../uploads/<?= $row['photo'] ?>" class="elevation-1"
                                                            style="height: 70px;" alt="User Image">
                                                        <a class="users-list-name"><?= $row['lastname'] ?></a>
                                                        <span class="users-list-date"><?= $row['type'] ?></span>
                                                    </li>
                                                <?php } ?>
                                            </ul>
                                            <!-- /.users-list -->
                                        </div>
                                        <!-- /.card-body -->
                                        <div class="card-footer text-center">
                                            <a href="staff">View All Staff</a>
                                        </div>
                                        <!-- /.card-footer -->
                                    </div>
                                    <div class="card">
                                        <div class="card-header">
                                            <p class="card-title">List of Students</p>

                                            <div class="card-tools">
                                                <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                                    <i class="fas fa-minus"></i>
                                                </button>
                                            </div>
                                        </div>
                                        <!-- /.card-header -->
                                        <div class="card-body p-0">

                                            <ul class="users-list clearfix">
                                                <?php

                                                if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {

                                                    $selectstaff = mysqli_query($conn, "SELECT s.id,s.photo,s.firstname,s.lastname, c.classname FROM students s, class c WHERE c.id=s.class_id AND s.school_id='{$_SESSION['school_id']}' ORDER BY s.lastname ASC LIMIT 10");
                                                } else {
                                                    $selectstaff = mysqli_query($conn, "SELECT s.id,s.photo,s.firstname,s.lastname, c.classname FROM students s, class c WHERE c.id=s.class_id AND class_id='{$_SESSION['class_id']}' AND s.school_id='{$_SESSION['school_id']}' ORDER BY s.lastname ASC");
                                                }
                                                while ($row = mysqli_fetch_array($selectstaff)) {
                                                ?>

                                                    <li style="width: 90px;">
                                                        <a href="students?id=<?= $row['id'] ?>">
                                                            <img src="../uploads/<?= $row['photo'] ?>" class="elevation-1"
                                                                style="height: 70px;" alt="User Image">
                                                            <a class="users-list-name"><?= $row['lastname'] ?></a>
                                                            <span class="users-list-date"><?= $row['classname'] ?></span>
                                                        </a>
                                                    </li>
                                                <?php } ?>
                                            </ul>
                                            <!-- /.users-list -->
                                        </div>
                                        <!-- /.card-body -->
                                        <!-- /.card-footer -->
                                    </div>
                                    <!--/.card -->
                                </div>
                                <!-- /.col -->
                            </div>
                            <!-- /.row -->

                        </div>
                        <!-- /.col -->


                        <!-- /.col -->
                    </div>
                    <!-- /.row -->
                </div>
                <!--/. container-fluid -->
            </section>
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
    get_notices('<?= $_SESSION['userid'] ?>', '1');
</script>

</html>