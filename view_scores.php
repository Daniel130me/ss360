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
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>View Scores | <?= get_staff_fullname_by_id($_SESSION['userid']) ?></title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Toastr -->
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <!-- Select2 -->
    <style>
        .knob {
            font: bold 20px Arial !important;
            /* Adjust the font size */
        }

        .subjectselect .select2-selection.select2-selection--single {
            border: none;
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
        }

        .scrollable-container table {
            min-width: 600px;
            /* Adjust based on your content */
        }

        .floating-btn {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 50%;
            cursor: pointer;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }

        .floating-btn:hover {
            background-color: #0056b3;
        }

        table.behaviour_report_table td:nth-child(2) {
            text-align: right;
        }

        .overlay {
            position: absolute;
            width: 100%;
            height: 100%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            z-index: 1000;
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
                            <a href="post_scores" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">add_chart</i>
                                    Post Scores
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="view_scores" class="nav-link active">
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
        <div class="content-wrapper" style="background-color: #f4f7fa; padding-bottom: 100px;">


            <!-- Main content -->
            <div class="content">
                <!-- do not delete the input hidden, it is used to identify the page in js file -->
                <input type="hidden" id="scores_page" value="view_scores">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="mb-3">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">View Scores</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent"
                                                style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1"
                                                    style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">View Scores</li>
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
                                        <div class="col-12 col-md-12 my-md-0">
                                            <div class="form-group">
                                                <label for="" class="mb-0">Select method for viewing scores</label>
                                                <div class="w-100">
                                                    <!-- <button class="btn select_btn  mr-2" id="by_subj_btn" onclick="handleSelect('by_subj_btn','view')">View By Subject</button> -->
                                                    <button class="btn select_btn active mr-2" id="by_class_btn"
                                                        onclick="handleSelect('by_class_btn','view')">View By
                                                        Class</button>
                                                    <button class="btn select_btn" id="by_stud_btn"
                                                        onclick="handleSelect('by_stud_btn','view')">View By
                                                        Student</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12 col-md-3" id="select_class">
                                            <div class="form-group align-left">
                                                <label for="select_class_field" class="mb-0">Select Class</label>
                                                <select class="form-control select2" onchange="handleToggleSelection()"
                                                    id="select_class_field" style="width: 100%;">
                                                    <!-- <option selected value="44">bas</option> -->
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-12 col-md-3" id="select_student" style="display: none;">
                                            <!-- <div class="col-12 col-md-3" id="select_student" style="display: none;"> -->
                                            <div class="form-group align-left">
                                                <label for="select_student_field" class="mb-0">Select Student</label>
                                                <select class="form-control select2" onchange="handleToggleSelection()"
                                                    id="select_student_field" style="width: 100%;">
                                                    <!-- <option selected value="57">Kehisde</option> -->
                                                </select>
                                                <span class="small text-danger" id="select_student_warning"
                                                    style="display: none;">Selected class has no students</span>
                                            </div>
                                        </div>



                                        <!-- <div class="col-12 col-md-3" id="select_class">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Class</label>
                                                <select class="form-control select2" onchange="getStudentSubject(this.value)" id="select_class_field" style="width: 100%;">
                                                    <php
                                                    $select = mysqli_query($conn, "SELECT id,classname FROM class WHERE school_id='$school_id'");
                                                    while ($row = mysqli_fetch_array($select)) {
                                                    ?>
                                                        <option value="<= $row['id'] ?>"><= $row['classname'] ?></option>
                                                    <php
                                                    }
                                                    ?>
                                                </select>
                                            </div>
                                        </div> -->

                                        <!-- <div class="col-12 col-md-3" id="select_subject">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Subject</label>
                                                <select class="form-control select2" onchange="display_table('subject')" id="select_subject_field" style="width: 100%;">
                                                </select>
                                                <span class="small text-danger" id="select_subject_warning" style="display: none;">Selected class has no subjects</span>
                                            </div>
                                        </div> -->
                                        <div class="col-12 col-md-3" id="select_student">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Session</label>
                                                <select class="form-control select2" onchange="handleToggleSelection()"
                                                    id="select_session_field" style="width: 100%;">
                                                    <!-- <option selected value="1">2013/2014</option> -->
                                                    <?php
                                                    $select = mysqli_query($conn, "SELECT id,session FROM sessions ORDER BY session ASC");
                                                    while ($row = mysqli_fetch_array($select)) {
                                                        if ($row['id'] == $_SESSION['session_id']) {
                                                            ?>
                                                            <option selected value="<?= $row['id'] ?>"><?= $row['session'] ?>
                                                            </option>
                                                        <?php }
                                                        ?>

                                                        <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                                        <?php
                                                    }
                                                    ?>
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-12 col-md-3 d-none">
                                            <button class="btn accent font-weight-bold w-100 btn-md-auto"
                                                onclick="check_score_changes()">Check Score Changes</button>
                                        </div>
                                    </div>


                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="by_class_filter" style="display: none;">
                    <div class="container-fluid mt-4" id="">
                        <div class="py-3 px-15 bg-white space_content_box"
                            style="border-radius: 10px; position: relative">
                            <!-- <div id=""> -->
                            <div id="filterTerm_class"
                                class="w-100 d-flex justify-content-between align-items-center flex-wrap">
                                <ul class="menu-scrollbar px-0 mb-0" id="" role=""
                                    style="flex-wrap: nowrap; overflow: auto; white-space: nowrap">
                                    <button
                                        class="btn select_btn termclass my-1 <?= $_SESSION['term_id'] == '1' ? 'active' : '' ?> mr-2"
                                        data-name="1" onclick="toggletermbyclass(this)">1st Term</button>
                                    <button
                                        class="btn select_btn termclass my-1 <?= $_SESSION['term_id'] == '2' ? 'active' : '' ?> mr-2"
                                        data-name="2" onclick="toggletermbyclass(this)">2nd Term</button>
                                    <button
                                        class="btn select_btn termclass my-1 <?= $_SESSION['term_id'] == '3' ? 'active' : '' ?> mr-2"
                                        data-name="3" onclick="toggletermbyclass(this)">3rd Term</button>
                                </ul>
                                <button type="button" class="btn btn-success my-1" id="download_excel_btn"
                                    onclick="exportClassScoreToExcel()" style="display: none;">
                                    <i class="fas fa-file-excel mr-1"></i> Download Excel
                                </button>
                            </div>
                            <div id="class_table_data"></div>
                            <?php
                            if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                                ?>
                                <ul class="menu-scrollbar px-0" id="approval_btn" role=""
                                    style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
                                    <!-- <button type="button" class="btn btn-sm select_btn approve_disaprove mt-3" data-name='ca1' onclick="approve_disaprove_comment(this)">Approve CA1</button>
                                <button type="button" class="btn btn-sm select_btn approve_disaprove mt-3" data-name='ca2' onclick="approve_disaprove_comment(this)">Approve CA2</button> -->
                                </ul>
                            <?php } ?>
                        </div>
                    </div>
                </div>
                <div class="container-fluid mt-4">
                    <div class="py-3 px-15 bg-white data_overlay" style="border-radius: 10px; position: relative">
                        <p class="font-weight-bold">Fill the forms appropiately</p>
                    </div>
                </div>
                <div class="thecontentbox" style="display: none;">
                    <div class="container-fluid mt-4" id="">
                        <div class="py-3 px-15 bg-white space_content_box"
                            style="border-radius: 10px; position: relative">
                            <!-- <div id=""> -->
                            <div id="filterTerm" class="w-100">
                                <ul class="menu-scrollbar px-0" id="" role=""
                                    style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
                                    <button
                                        class="btn select_btn term my-1 <?= $_SESSION['term_id'] == '1' ? 'active' : '' ?> mr-2"
                                        data-name="1" id="first" onclick="toggletermfilterClass(this)">1st Term</button>
                                    <button
                                        class="btn select_btn term my-1 <?= $_SESSION['term_id'] == '2' ? 'active' : '' ?> mr-2"
                                        data-name="2" id="second" onclick="toggletermfilterClass(this)">2nd
                                        Term</button>
                                    <button
                                        class="btn select_btn term my-1 <?= $_SESSION['term_id'] == '3' ? 'active' : '' ?> mr-2"
                                        data-name="3" id="third" onclick="toggletermfilterClass(this)">3rd Term</button>
                                    <button class="btn select_btn term my-1 mr-2" data-name="summary" id="summary"
                                        onclick="toggletermfilterClass(this)">Summary</button>
                                </ul>
                            </div>
                            <div class="d-flex align-items-center">
                                <button type="button"
                                    style="padding: 4px 1px 0px 2px; background-color:white; border-radius: 5px; border:none;"
                                    id="table_visual_Score_toggle" class="table_display d-flex accent"
                                    onclick="table_visual_Score_toggle(this)">
                                    <i class="material-symbols-outlined mr-1">legend_toggle</i> Show Chart
                                </button>
                            </div>
                            <!-- </div> -->
                            <div id="table_visuals_display" class="pt-3">

                            </div>
                            <div class="line_and_term_based_contents">
                                <div class="hr my-4" style="height: 10px; width: 100%; background-color: #ededed;">
                                </div>
                                <div class="d-flex flex-wrap" style="gap: 20px;">
                                    <div id="view_teacher_comment_container" class="mr-5">
                                        <p class="font-weight-bold text-muted">Teacher's Comment</p>
                                        <p class="" id="theteacher_comment"></p>
                                    </div>
                                    <div id="view_principal_comment_container" class="mr-5">
                                        <p class="font-weight-bold text-muted">Principal/Propietor's Comment</p>
                                        <p class="" id="theprincipal_comment"></p>
                                    </div>
                                    <div class="mr-5">
                                        <p class="font-weight-bold text-muted">General Behaviour</p>
                                        <table class="behaviour_report_table w-100">
                                            <thead>
                                                <tr class="d-none">
                                                    <th></th>
                                                    <th></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php if (!in_array('punctuality', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Punctuality</td>
                                                        <td class="punctuality"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('classattendance', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Classroom attendance</td>
                                                        <td class="classattendance"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('resptoass', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Response to assignment</td>
                                                        <td class="resptoass"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('Neatness', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Neatness</td>
                                                        <td class="Neatness"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('Politeness', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Politeness</td>
                                                        <td class="Politeness"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('Honesty', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Honesty</td>
                                                        <td class="Honesty"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('selfcontrol', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Self control</td>
                                                        <td class="selfcontrol"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('relationship', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Relationship with others</td>
                                                        <td class="relationship"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('organizationability', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Organizational Ability</td>
                                                        <td class="organizationability"></td>
                                                    </tr>
                                                <?php endif; ?>
                                            </tbody>
                                        </table>
                                    </div>

                                    <div>
                                        <p class="font-weight-bold text-muted">Psychomotive Skills</p>
                                        <table class="behaviour_report_table w-100">
                                            <thead>
                                                <tr class="d-none">
                                                    <th></th>
                                                    <th></th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <?php if (!in_array('Obedience', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Obedience</td>
                                                        <td class="Obedience"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('Creativity', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Creativity</td>
                                                        <td class="Creativity"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('Writing', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Writing</td>
                                                        <td class="Writing"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('Fluency', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Fluency</td>
                                                        <td class="Fluency"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('Sport', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Sport</td>
                                                        <td class="Sport"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('Games', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Games</td>
                                                        <td class="Games"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('DrawingPainting', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Drawing & Painting</td>
                                                        <td class="DrawingPainting"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('Music', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Music Performance</td>
                                                        <td class="Music"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('HandlingTools', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Handling Tools</td>
                                                        <td class="HandlingTools"></td>
                                                    </tr>
                                                <?php endif; ?>
                                                <?php if (!in_array('Crafts', $hidden_skills)): ?>
                                                    <tr>
                                                        <td>Craft</td>
                                                        <td class="Crafts"></td>
                                                    </tr>
                                                <?php endif; ?>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <button class="btn accent font-weight-bold w-100 btn-md-auto" id="preview-pdf"
                                    onclick="preview_report_card_multiple('student_page')">Print Student Report
                                    Card</button>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- <div class="container-fluid mt-4" id="">
                    <div class="py-3 px-15 bg-white space_content_box" style="border-radius: 10px; position: relative">
                        <div class="d-sm-flex align-items-start" id="filt">
                        </div>
                        <p class="my-3 text-center text-muted font-weight-bold" id="view_table_title"></p>
                        <table id="view_score_table_by_student" class="display nowrap" style="width:100%;">
                        </table>

                    </div>
                </div> -->
            </div>
            <!-- <button class="floating-btn" id="preview-pdf" onclick="preview_pdf()">Download PDF</button> -->
        </div>
        <!-- /.row -->
    </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
    <div class="modal fade" id="score_change_check_modal">
        <div class="modal-dialog modal-lg modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header" style="padding: 5px 45px 5px 15px !important;">
                    <h4 class="modal-title">Score Change History</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                        style="top: 15px;position: absolute;right: 15px;">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="change_timeline"></div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="subject_full_record">
        <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header" style="padding: 5px 45px 5px 15px !important;">
                    <div class="d-flex flex-wrap">
                        <div class="form-group m-0">
                            <select name="" id="termSubjectValue" onchange="getsingleSessionReport()"
                                class="form-control subjectselect select2 border-0 p-0" id="">
                                <?php
                                $select = mysqli_query($conn, "SELECT id, subject FROM subjects ORDER BY subject ASC");
                                while ($row = mysqli_fetch_array($select)) {
                                    ?>
                                    <option value="<?= $row['id'] ?>"><?= $row['subject'] ?></option>
                                <?php } ?>
                            </select>
                        </div>
                        <div class="form-group m-0">
                            <select name="" id="singleSessionValue" onchange="getsingleSessionReport()"
                                class="form-control subjectselect select2 border-0 p-0" id="">
                                <?php
                                $select = mysqli_query($conn, "SELECT id, session FROM sessions ORDER BY session ASC");
                                while ($row = mysqli_fetch_array($select)) {
                                    ?>
                                    <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                <?php } ?>
                            </select>
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"
                            style="top: 15px;position: absolute;right: 15px;">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                </div>
                <div class="modal-body">

                    <div class="mt-4">
                        <div class="" id="overall_performance"></div>
                        <div class="" id="score_chart"></div>
                        <!-- <div class="position-relative mb-4">
                            <canvas id="visitors-chart" height="200"></canvas>
                        </div> -->
                        <div class="row justify-content-between">
                            <div class="mt-3 col-12 col-sm-3" id="student_term1_report"></div>
                            <div class="mt-3 col-12 col-sm-3" id="student_term2_report"></div>
                            <div class="mt-3 col-12 col-sm-3" id="student_term3_report"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="report_preview_modal">
        <div class="modal-dialog modal-xl modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title font-weight-bold">Report Card Preview</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="max-height: 80vh; overflow-y: auto;">
                    <div id="preview-loading" class="text-center mb-3" style="display: none;">
                        <div class="spinner-border text-primary" role="status">
                            <span class="sr-only">Loading...</span>
                        </div>
                        <p class="mt-2">Generating report cards...</p>
                        <p class="loading-status">Loading report 0 of 0...</p>
                    </div>
                    <div id="preview-content"></div>
                </div>
                <div class="modal-footer">
                    <!--<button type="button" class="btn btn-primary"-->
                    <!--    onclick="generatePDF('<= $data[0]['lastname'] . ' ' . $data[0]['firstname'] . ' ' . $data[0]['middlename'] ?>')">Download</button>-->

                    <button type="button" id="print-button" class="btn btn-primary" onclick="printReports()" disabled>
                        <i class="fas fa-print mr-1"></i> Print Reports
                    </button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="preview_report_card_modal">
        <div class="modal-dialog modal-lg modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body py-0">
                    <div class="bg-white" id="pdf-content"></div>
                    <div class="card-foot" id="preview_report_card_foot" style="display: none;">
                        <button type="button" class="btn btn-primary" onclick="generatePDF()">Download</button>
                        <button type="button" class="btn btn-grey" class="close" data-dismiss="modal"
                            aria-label="Close">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
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
    <!-- Select2 -->
    <!-- jQuery Knob -->
    <script src="../plugins/jquery-knob/jquery.knob.min.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>
    <script src="../plugins/chart.js/Chart.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <!-- SheetJS for Excel export -->
    <script src="https://cdn.sheetjs.com/xlsx-0.20.1/package/dist/xlsx.full.min.js"></script>
    <script>
        var skul_settings = <?= $_SESSION['skul_settings'] ?>;
    </script>
    <script src="../dist/js/skul.js?v=opemi1"></script>
    <!-- <script src="../dist/js/pages/dashboard3.js"></script> -->
    <script>
        // loadSettings()

        // $('#class_score_table').DataTable({
        //     scrollX: true,
        //     paging: false,
        //     ordering: false,
        // });

        /**
         * Export class score table to Excel
         * Uses SheetJS (xlsx) library to generate proper Excel files
         */
        function exportClassScoreToExcel() {
            const table = document.getElementById("class_score_table");
            if (!table) {
                toastr.error("No table data to export");
                return;
            }

            // Get class name and term for filename
            const className = $("#select_class_field option:selected").text() || "Class";
            const termText = $(".select_btn.termclass.active").text() || "Term";
            const sessionText = $("#select_session_field option:selected").text() || "Session";

            // Create workbook
            const wb = XLSX.utils.book_new();

            // Extract data from the table, excluding hidden columns and approval button column
            const data = [];
            const thead = table.querySelector("thead");
            const tbody = table.querySelector("tbody");

            // Process header rows
            const headerRows = thead.querySelectorAll("tr");
            headerRows.forEach((tr, rowIndex) => {
                const row = [];
                const cells = tr.querySelectorAll("th");
                cells.forEach((th, cellIndex) => {
                    // Skip hidden columns
                    if (th.classList.contains("d-none") || window.getComputedStyle(th).display === "none") {
                        return;
                    }
                    // Skip the last "Approval" column header (only in second header row)
                    if (rowIndex === 1 && th.textContent.trim() === "Approval") {
                        return;
                    }
                    const colspan = parseInt(th.getAttribute("colspan")) || 1;
                    const cellValue = th.textContent.trim();
                    row.push(cellValue);
                    // Add empty cells for colspan (for proper Excel structure)
                    for (let i = 1; i < colspan; i++) {
                        row.push("");
                    }
                });
                data.push(row);
            });

            // Process body rows
            const bodyRows = tbody.querySelectorAll("tr");
            bodyRows.forEach((tr) => {
                const row = [];
                const cells = tr.querySelectorAll("td");
                cells.forEach((td, cellIndex) => {
                    // Skip hidden columns
                    if (td.classList.contains("d-none") || window.getComputedStyle(td).display === "none") {
                        return;
                    }
                    // Skip the last column (Approval button)
                    if (cellIndex === cells.length - 1) {
                        return;
                    }
                    // Get text content, stripping any HTML like links
                    let cellValue = td.textContent.trim();
                    // Try to convert numeric values
                    const numValue = parseFloat(cellValue);
                    if (!isNaN(numValue) && cellValue === numValue.toString()) {
                        row.push(numValue);
                    } else {
                        row.push(cellValue);
                    }
                });
                data.push(row);
            });

            // Create worksheet from data
            const ws = XLSX.utils.aoa_to_sheet(data);

            // Set column widths for better readability
            const colWidths = data[0] ? data[0].map(() => ({ wch: 12 })) : [];
            if (colWidths.length > 0) {
                colWidths[0] = { wch: 25 }; // Student name column wider
            }
            ws["!cols"] = colWidths;

            // Add worksheet to workbook
            XLSX.utils.book_append_sheet(wb, ws, "Class Scores");

            // Generate filename
            const sanitize = (str) => str.replace(/[^a-zA-Z0-9_-]/g, "_").substring(0, 30);
            const filename = `${sanitize(className)}_${sanitize(termText)}_${sanitize(sessionText)}_Scores.xlsx`;

            // Download the file
            XLSX.writeFile(wb, filename);

            toastr.success("Excel file downloaded successfully!");
        }

        // Auto-show download button when table is populated
        $(document).ready(function () {
            // Watch for table changes in the class_table_data container
            const tableContainer = document.getElementById('class_table_data');
            if (tableContainer) {
                const observer = new MutationObserver(function (mutations) {
                    const table = document.getElementById('class_score_table');
                    if (table && table.querySelector('tbody tr')) {
                        $('#download_excel_btn').show();
                    } else {
                        $('#download_excel_btn').hide();
                    }
                });
                observer.observe(tableContainer, { childList: true, subtree: true });
            }
        });
    </script>

</body>

</html>