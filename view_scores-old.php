<?php
session_start();
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>View Scores</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="dist/css/adminlte.css">
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
                            <a href="students" class="nav-link">
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
                            <a href="view_scores" class="nav-link active">
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
                                            <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>Dashboard</a>
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
                                        <!-- <div class="row"> -->
                                        <!-- <div class="col-12 col-md-12 my-md-0">
                                            <div class="form-group">
                                                <label for="" class="mb-0">Select method for viewing scores</label>
                                                <div class="w-100">
                                                    <button class="btn select_btn  mr-2" id="by_subj_btn" onclick="handleSelect('by_subj_btn','view')">View By Subject</button>
                                                    <button class="btn select_btn active  mr-2" id="by_stud_btn" onclick="handleSelect('by_stud_btn','view')">View By Student</button>
                                                    <button class="btn select_btn mr-2" id="by_class_btn" onclick="handleSelect('by_class_btn','view')"> View ByClass</button>
                                                </div>
                                            </div>
                                        </div> -->
                                        <!-- <div class="col-12 col-md-3" id="select_student" style="display: none;">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Student</label>
                                                <select class="form-control select2" onchange="display_table('student')" id="select_student_field" style="width: 100%;">
                                                </select>
                                                <span class="small text-danger" id="select_student_warning" style="display: none;">Selected class has no students</span>
                                            </div>
                                        </div> -->
                                        <div class="col-12 col-md-3" id="select_student">
                                            <!-- <div class="col-12 col-md-3" id="select_student" style="display: none;"> -->
                                            <div class="form-group align-left">
                                                <label for="select_student_field" class="mb-0">Select Student</label>
                                                <select class="form-control select2" onchange="get_score_data()" id="select_student_field" style="width: 100%;">
                                                    <!-- <option selected value="57">Kehisde</option> -->
                                                </select>
                                                <span class="small text-danger" id="select_student_warning" style="display: none;">Selected class has no students</span>
                                            </div>
                                        </div>


                                        <div class="col-12 col-md-3" id="select_class">
                                            <div class="form-group align-left">
                                                <label for="select_class_field" class="mb-0">Select Class</label>
                                                <select class="form-control select2" onchange="get_score_data()" id="select_class_field" style="width: 100%;">
                                                    <!-- <option selected value="44">bas</option> -->
                                                </select>
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
                                                <select class="form-control select2" onchange="get_score_data()" id="select_session_field" style="width: 100%;">
                                                    <!-- <option selected value="1">2013/2014</option> -->
                                                    <?php
                                                    $select = mysqli_query($conn, "SELECT id,session FROM sessions ORDER BY session ASC");
                                                    while ($row = mysqli_fetch_array($select)) {
                                                    ?>
                                                        <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                                    <?php
                                                    }
                                                    ?>
                                                </select>
                                            </div>
                                        </div>
                                    </div>


                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="container-fluid mt-4">
                    <div class="py-3 px-15 bg-white data_overlay" style="border-radius: 10px; position: relative"></div>
                </div>
                <div class="thecontentbox" style="display: none;">
                    <div class="container-fluid mt-4" id="">
                        <div class="py-3 px-15 bg-white space_content_box" style="border-radius: 10px; position: relative">
                            <!-- <div id=""> -->
                            <div id="filterTerm" class="w-100">
                                <ul class="menu-scrollbar px-0" id="" role="" style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
                                    <button class="btn select_btn term my-1 active mr-2" data-name="1" id="first" onclick="toggletermfilterClass('1')">1st Term</button>
                                    <button class="btn select_btn term my-1 mr-2" data-name="2" id="second" onclick="toggletermfilterClass('2')">2nd Term</button>
                                    <button class="btn select_btn term my-1 mr-2" data-name="3" id="third" onclick="toggletermfilterClass('3')">3rd Term</button>
                                    <button class="btn select_btn term my-1 mr-2" data-name="summary" id="summary" onclick="toggletermfilterClass('summary')">Summary</button>
                                </ul>
                            </div>
                            <div class="d-flex justify-content-between align-items-center">
                                <p class="font-weight-bold">Score Table/Chart</p>
                                <button type="button" style="padding: 4px 1px 0px 2px; border-radius: 5px; border:none;" id="table_visual_Score_toggle" class="visuals" onclick="table_visual_Score_toggle(this)">
                                    <i class="material-symbols-outlined">add_chart</i>
                                </button>
                            </div>
                            <!-- </div> -->
                            <div id="table_visuals_display" class="pt-3">

                            </div>
                            <div class="line_and_term_based_contents">
                                <div class="hr my-4" style="height: 10px; width: 100%; background-color: #ededed;"></div>
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
                                                <tr>
                                                    <td>Punctuality</td>
                                                    <td class="punctuality"></td>
                                                </tr>
                                                <tr>
                                                    <td>Classroom attendance</td>
                                                    <td class="classattendance"></td>
                                                </tr>
                                                <tr>
                                                    <td>Response to assignment</td>
                                                    <td class="resptoass"></td>
                                                </tr>
                                                <tr>
                                                    <td>Neatness</td>
                                                    <td class="Neatness"></td>
                                                </tr>
                                                <tr>
                                                    <td>Politeness</td>
                                                    <td class="Politeness"></td>
                                                </tr>
                                                <tr>
                                                    <td>Honesty</td>
                                                    <td class="Honesty"></td>
                                                </tr>
                                                <tr>
                                                    <td>Self control</td>
                                                    <td class="selfcontrol"></td>
                                                </tr>
                                                <tr>
                                                    <td>Relationship with others</td>
                                                    <td class="relationship"></td>
                                                </tr>
                                                <tr>
                                                    <td>Organizational Ability</td>
                                                    <td class="organizationability"></td>
                                                </tr>
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
                                                <tr>
                                                    <td>Obedience</td>
                                                    <td class="Obedience"></td>
                                                </tr>
                                                <tr>
                                                    <td>Creativity</td>
                                                    <td class="Creativity"></td>
                                                </tr>
                                                <tr>
                                                    <td>Writing</td>
                                                    <td class="Writing"></td>
                                                </tr>
                                                <tr>
                                                    <td>Fluency</td>
                                                    <td class="Fluency"></td>
                                                </tr>
                                                <tr>
                                                    <td>Sport</td>
                                                    <td class="Sport"></td>
                                                </tr>
                                                <tr>
                                                    <td>Games</td>
                                                    <td class="Games"></td>
                                                </tr>
                                                <tr>
                                                    <td>Drawing & Painting</td>
                                                    <td class="DrawingPainting"></td>
                                                </tr>
                                                <tr>
                                                    <td>Music Performance</td>
                                                    <td class="Music"></td>
                                                </tr>
                                                <tr>
                                                    <td>Handling Tools</td>
                                                    <td class="HandlingTools"></td>
                                                </tr>
                                                <tr>
                                                    <td>Craft</td>
                                                    <td class="Crafts"></td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                                <button class="btn accent font-weight-bold w-100 btn-md-auto" id="preview-pdf" onclick="download_report_card('student_page')">View Student Report Card</button>
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

    <div class="modal fade" id="subject_full_record">
        <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header" style="padding: 5px 45px 5px 15px !important;">
                    <div class="d-flex flex-wrap">
                        <div class="form-group m-0">
                            <select name="" id="termSubjectValue" onchange="getsingleSessionReport()" class="form-control subjectselect select2 border-0 p-0" id="">
                                <?php
                                $select = mysqli_query($conn, "SELECT id, subject FROM subjects ORDER BY subject ASC");
                                while ($row = mysqli_fetch_array($select)) {
                                ?>
                                    <option value="<?= $row['id'] ?>"><?= $row['subject'] ?></option>
                                <?php } ?>
                            </select>
                        </div>
                        <div class="form-group m-0">
                            <select name="" id="singleSessionValue" onchange="getsingleSessionReport()" class="form-control subjectselect select2 border-0 p-0" id="">
                                <?php
                                $select = mysqli_query($conn, "SELECT id, session FROM sessions ORDER BY session ASC");
                                while ($row = mysqli_fetch_array($select)) {
                                ?>
                                    <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                <?php } ?>
                            </select>
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="top: 15px;position: absolute;right: 15px;">
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
    <div class="modal fade" id="preview_report_card_modal">
        <div class="modal-dialog modal-lg modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body py-0">
                    <div class="bg-white" id="pdf-content"></div>
                    <div class="card-foot" id="preview_report_card_foot" style="display: none;">
                        <button type="button" class="btn btn-primary" onclick="generatePDF()">Download</button>
                        <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Cancel</button>
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
    <script src="plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="plugins/select2/js/select2.full.min.js"></script>
    <!-- AdminLTE App -->
    <script src="dist/js/adminlte.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <!-- Select2 -->
    <!-- jQuery Knob -->
    <script src="plugins/jquery-knob/jquery.knob.min.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>
    <script src="plugins/chart.js/Chart.min.js"></script>
    <script>
        var skul_settings = <?= $_SESSION['skul_settings'] ?>;
    </script>
    <script src="dist/js/skul.js?v=12"></script>
    <!-- <script src="dist/js/pages/dashboard3.js"></script> -->
    <script>
        // Attach click event to the button
    </script>

</body>

</html>