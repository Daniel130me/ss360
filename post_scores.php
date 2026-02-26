<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
$hidden_skills = json_decode($_SESSION['hidden_row'], true) ?? [];

// Fetch all skills
$behaviour_skills = [];
$psychomotive_skills = [];
$skills_query_all = mysqli_query($conn, "SELECT * FROM skills WHERE school_id = 0 OR school_id = '$school_id' ORDER BY id ASC");
while ($skill_row = mysqli_fetch_array($skills_query_all)) {
    if ($skill_row['category'] == 'behaviour') {
        $behaviour_skills[$skill_row['skill_key']] = $skill_row['skill_label'];
    } elseif ($skill_row['category'] == 'psychomotor') {
        $psychomotive_skills[$skill_row['skill_key']] = $skill_row['skill_label'];
    }
}
$all_skills_keys = array_merge(array_keys($behaviour_skills), array_keys($psychomotive_skills));
// print_r($hidden_skills);
// echo $_SESSION['userid'];
// exit;
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Post Scores | <?= get_staff_fullname_by_id($_SESSION['userid']) ?> </title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
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
                                <img src="../uploads/<?= $_SESSION['staff_photo'] ?>" class="img-circle elevation-2"
                                    alt="User Image">
                            </div>
                            <div class="info d-none d-sm-inline-block">
                                <p style="font-size: 14px;" class="mb-0 d-block">
                                    <?= $_SESSION['firstname'] . ' ' . $_SESSION['lastname'] ?>
                                </p>
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
                            <a href="post_scores" class="nav-link active">
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
                        <?php if ($_SESSION['school_id'] == 27 || $_SESSION['school_id'] == 13) { ?>
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
                <img src="../dist/img/company_logo.png" alt="Schoolsuite360" class="brand-image img-circle elevation-3"
                    style="opacity: .8">
                <span class="brand-text font-weight-light">Schoolsuite360</span>
            </a>
            <!-- /.sidebar -->
        </aside>
        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper" style="padding-bottom: 100px;">


            <!-- Main content -->
            <div class="content">
                <!-- do not delete the input hidden, it is used to identify the page in js file -->
                <input type="hidden" id="scores_page" value="post_scores">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="mb-3">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Post Scores</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent"
                                                style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1"
                                                    style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">Post Scores</li>
                                    </ol>
                                </div>
                                <div>
                                    <div class="row">
                                        <!-- <div class="row"> -->
                                        <!-- <div class="col-5 col-md-4">
                                                <div class="form-group align-left">
                                                    <label for="" class="">Select Session</label>
                                                    <select name="" class="form-control" id="">
                                                        <option value="">2020/2021</option>
                                                        <option value="">2021/2022</option>
                                                        <option value="">2022/2023</option>
                                                    </select>
                                                </div>
                                            </div> -->
                                        <!-- <div class="col-7 col-md-4">
                                                <div class="form-group">
                                                    <label for="">Select Term</label>
                                                    <div class="w-100">
                                                        <button class="btn select_btn active mr-2">1st</button>
                                                        <button class="btn select_btn mr-2">2nd</button>
                                                        <button class="btn select_btn">3rd</button>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-12 col-md-4 mt-3 mt-md-0">
                                                <div class="form-group">
                                                    <label for="">Select Assessment Type</label>
                                                    <div class="w-100">
                                                        <button class="btn select_btn active mr-2">All</button>
                                                        <button class="btn select_btn mr-2">CA1</button>
                                                        <button class="btn select_btn mr-2">CA2</button>
                                                        <button class="btn select_btn mr-2">Exam</button>
                                                    </div>
                                                </div>
                                            </div> -->
                                        <!-- </div> -->
                                    </div>
                                    <div class="row">
                                        <!-- <div class="row"> -->
                                        <div class="col-12 col-md-12 my-md-0">
                                            <p class="text-orange">Current Term: <span
                                                    class="term_name font-weight-bold"><?= $_SESSION['term_id'] == 1 ? '1st' : ($_SESSION['term_id'] == 2 ? '2nd' : '3rd') ?></span>
                                            </p>
                                            <div class="form-group">
                                                <label for="" class="mb-0">Select method for posting scores</label>
                                                <div class="w-100">
                                                    <button class="btn select_btn active mr-2" id="by_subj_btn"
                                                        onclick="handleSelect('by_subj_btn')">Post By Subject</button>
                                                    <button class="btn select_btn  mr-2" id="by_stud_btn"
                                                        onclick="handleSelect('by_stud_btn')">Post By Student</button>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-3" id="select_class">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Class</label>
                                                <select class="form-control select2" onchange="setfilter('student')"
                                                    id="select_class_field" style="width: 100%;">
                                                    <!-- <php
                                                    $select = mysqli_query($conn, "SELECT id,classname FROM class WHERE school_id='$school_id' ORDER BY classname ASC");
                                                    while ($row = mysqli_fetch_array($select)) {
                                                    ?>
                                                        <option value="<= $row['id'] ?>"><= $row['classname'] ?></option>
                                                    <php
                                                    }
                                                    ?> -->
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-12 col-md-3" id="select_student" style="display: none;">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Student</label>
                                                <select class="form-control select2" onchange="setfilter('student')"
                                                    id="select_student_field" style="width: 100%;">
                                                </select>
                                                <span class="small text-danger" id="select_student_warning"
                                                    style="display: none;">Selected class has no students</span>
                                            </div>
                                        </div>
                                        <div class="col-12 col-md-3" id="select_subject">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Subject</label>
                                                <select class="form-control select2" onchange="setfilter('subject')"
                                                    id="select_subject_field" style="width: 100%;">
                                                </select>
                                                <span class="small text-danger" id="select_subject_warning"
                                                    style="display: none;">Selected class has no subjects</span>
                                            </div>
                                        </div>
                                        <input type="hidden" id="select_session_field"
                                            value="<?= $_SESSION['session_id'] ?>">
                                        <input type="hidden" class="select_btn term active"
                                            data-name="<?= $_SESSION['term_id'] ?>">
                                        <!-- <div class="col-12 col-md-3"> -->
                                        <!-- <div class="form-group align-left"> -->
                                        <!-- <label for="" class="mb-0">Select Session</label> -->
                                        <!-- <select class="form-control select2" onchange="display_table()" id="select_session_field" style="width: 100%;">
                                                    <php
                                                    $select = mysqli_query($conn, "SELECT id,session FROM sessions ORDER BY session ASC");
                                                    while ($row = mysqli_fetch_array($select)) {
                                                        if($row['id'] == $_SESSION['session_id']){
                                                            ?>
                                                            <option selected value="<= $row['id'] ?>"><= $row['session'] ?></option>

                                                            <php
                                                        }
                                                    ?>
                                                        <option value="<= $row['id'] ?>"><= $row['session'] ?></option>
                                                    <php
                                                    }
                                                    ?>
                                                </select> -->
                                        <!-- </div>
                                        </div> -->
                                    </div>


                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container-fluid mt-4">
                    <div class="py-3 px-15 bg-white data_overlay" style="border-radius: 10px; position: relative">
                        <p class="font-weight-bold">Fill the form appropiately</p>
                    </div>
                </div>
                <div class="thecontentbox" style="display: none;">
                    <div class="container-fluid mt-4">
                        <div class="py-3 px-15 bg-white" style="border-radius: 10px; position: relative"">
                        
                        <div class=" d-sm-flex align-items-start" id="filt">
                        </div>
                        <p class="my-3 text-center text-muted font-weight-bold" id="post_table_title"></p>
                        <table id="post_score_table_by_student" class="display nowrap" style="width:100%;">
                        </table>
                        <!-- <button type="button" class="btn btn-primary btn-block btn-md-auto mt-2" onclick="submitScores()">Submit Scores</button> -->
                        <div class="row mt-3">
                            <div class="col-12 col-md-auto mb-2 mb-md-0">
                                <button class="btn btn-primary btn-block btn-md-auto" onclick="submitScores()">Submit
                                    Scores</button>
                            </div>
                        </div>

                    </div>
                </div>
                <div class="container-fluid mt-4" id="post_teacher_comment_container" style="display:none;">
                    <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                        <div>
                            <form class="form">
                                <div class="form-group">
                                    <label class="font-weight-bold muted-text">Teacher's Comment</label>
                                    <input name="comment"
                                        style="border-radius: 0; border-top:0; border-left:0; border-right:0;"
                                        class="form-control" id="post_teacher_comment_message"
                                        placeholder="Write comment">
                                    <input type="hidden" name="action" value="submit_comment">
                                    <input type="hidden" name="term" class="comment_term" value="">
                                    <input type="hidden" name="role_type" class="role_type" value="0">
                                    <input type="hidden" name="class_id" class="comment_class" value="">
                                    <input type="hidden" name="session" class="comment_Session" value="">
                                    <input type="hidden" name="student_id" class="student_id_for_comment" value="" />
                                </div>
                                <button type="submit" class="btn btn-primary">Submit Comment</button>
                            </form>
                        </div>
                    </div>
                </div>
                <?php
                if ($_SESSION['staff_type'] == '2' || $_SESSION['staff_type'] == '3' || $_SESSION['staff_type'] == '4') {
                    ?>
                    <div class="container-fluid mt-4" id="post_principal_comment_container">
                        <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                            <div>
                                <form class="form">
                                    <div class="form-group">
                                        <label class="font-weight-bold muted-text">Principal/Propietor's Comment</label>
                                        <input name="comment"
                                            style="border-radius: 0; border-top:0; border-left:0; border-right:0;"
                                            class="form-control" id="post_principal_comment_message"
                                            placeholder="Write comment">
                                        <input type="hidden" name="action" value="submit_comment">
                                        <input type="hidden" name="term" class="comment_term" value="">
                                        <input type="hidden" name="role_type" class="role_type" value="1">
                                        <input type="hidden" name="class_id" class="comment_class" value="">
                                        <input type="hidden" name="session" class="comment_Session" value="">
                                        <input type="hidden" name="student_id" class="student_id_for_comment" value="" />
                                    </div>
                                    <button type="submit" class="btn btn-primary">Submit Comment</button>
                                </form>
                            </div>
                        </div>
                    </div>
                    <!-- <div class="container-fluid mt-4" id="post_bursar_payment_container">
                        <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                            <div>
                                <form class="form">
                                    <div class="form-group">
                                        <label class="font-weight-bold muted-text">Outstanding Payment</label>
                                        <input name="comment" style="border-radius: 0; border-top:0; border-left:0; border-right:0;" class="form-control" id="post_principal_comment_message" placeholder="Amount to pay">
                                        <input type="hidden" name="action" value="submit_comment">
                                        <input type="hidden" name="term" class="comment_term" value="">
                                        <input type="hidden" name="role_type" class="role_type" value="1">
                                        <input type="hidden" name="class_id" class="comment_class" value="">
                                        <input type="hidden" name="session" class="comment_Session" value="">
                                        <input type="hidden" name="student_id" class="student_id_for_comment" value="" />
                                    </div>
                                    <button type="submit" class="btn btn-primary">Add</button>
                                </form>
                            </div>
                        </div>
                    </div> -->
                    <!-- <div class="container-fluid mt-4" id="post_next_term_payment_container">
                        <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                            <div>
                                <form class="form">
                                    <div class="form-group">
                                        <label class="font-weight-bold muted-text">Next Term Payment</label>
                                        <input name="comment" style="border-radius: 0; border-top:0; border-left:0; border-right:0;" class="form-control" id="post_principal_comment_message" placeholder="Amount to pay">
                                        <input type="hidden" name="action" value="submit_comment">
                                        <input type="hidden" name="term" class="comment_term" value="">
                                        <input type="hidden" name="role_type" class="role_type" value="1">
                                        <input type="hidden" name="class_id" class="comment_class" value="">
                                        <input type="hidden" name="session" class="comment_Session" value="">
                                        <input type="hidden" name="student_id" class="student_id_for_comment" value="" />
                                    </div>
                                    <button type="submit" class="btn btn-primary">Add</button>
                                </form>
                            </div>
                        </div>
                    </div> -->
                    <?php
                }
                ?>
                <div class="container-fluid mt-4" id="post_teacher_comment_gb_container" style="display:none;">
                    <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                        <div class="row">
                            <?php
                            // Skills fetched at top of file
                            
                            ?>
                            <div class="mb-4 col-sm-6">
                                <p class="font-weight-bold muted-text">General Behaviour</p>
                                <table>
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($behaviour_skills as $key => $label): ?>
                                            <?php if (!in_array($key, $hidden_skills)): ?>
                                                <tr>
                                                    <td><?= $label ?></td>
                                                    <?php for ($i = 5; $i >= 1; $i--): ?>
                                                        <td><input type="button" class="btn togglebtn <?= $key ?>"
                                                                name="<?= $key ?>" value="<?= $i ?>"></td>
                                                    <?php endfor; ?>
                                                </tr>
                                            <?php endif; ?>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
                            <div class="col-sm-6">
                                <p class="font-weight-bold muted-text">Psychomotive Skill</p>
                                <table>
                                    <thead>
                                        <tr>
                                            <th></th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <?php foreach ($psychomotive_skills as $key => $label): ?>
                                            <?php if (!in_array($key, $hidden_skills)): ?>
                                                <tr>
                                                    <td><?= $label ?></td>
                                                    <?php for ($i = 5; $i >= 1; $i--): ?>
                                                        <td><input type="button" class="btn togglebtn <?= $key ?>"
                                                                name="<?= $key ?>" value="<?= $i ?>"></td>
                                                    <?php endfor; ?>
                                                </tr>
                                            <?php endif; ?>
                                        <?php endforeach; ?>
                                    </tbody>
                                </table>
                            </div>
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
    <script>
        window.schoolHiddenSkills = <?php echo json_encode($hidden_skills); ?>;
        window.schoolSkills = <?php echo json_encode($all_skills_keys); ?>;
    </script>
    <script src="../dist/js/skul.js"></script>

</body>

</html>