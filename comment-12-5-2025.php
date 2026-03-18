<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
// $_SESSION['session_id'];
// exit;
// $school_id = $_SESSION['school_id'];
$school_settings = json_decode($_SESSION['skul_settings'], true);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Comments</title>

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
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <style>
        .parent_Search_btn:hover {
            background-color: aliceblue;
        }

        /* table.dataTable,
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
        } */



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
                            <a href="comment" class="nav-link active">
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

                <input type="hidden" id="comment_student_page" value="comment">

                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Manage Comments</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">Manage Comments</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container-fluid mt-4">
                    <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                        <input type="hidden" name="student_id" class="student_id_for_comment" value="" />
                        <input type="hidden" name="session" class="comment_Session" value="<?= $_SESSION['session_id'] ?>">
                        <input type="hidden" name="session" class="comment_term" value="<?= $_SESSION['term_id'] ?>">


                        <p class="text-orange mb-3">Current Term: <span class="term_name font-weight-bold"><?= $_SESSION['term_id'] == 1 ? '1st' : ($_SESSION['term_id'] == 2 ? '2nd' : '3rd') ?></span></p>

                        <div class="d-flex mb-3 align-items-center">

                            <div class="">
                                <p class="muted-text mr-1">Select Class:</p>
                            </div>
                            <div>
                                <select class="form-control filter_Select comment_class select2" onchange="get_stud_byClass_comment()" id="select_class_field" style="width: 100%;">
                                    <!-- <option selected value="44">bas</option> -->
                                </select>
                                <!-- 
                                <select class="select2 filter_Select comment_class border-0 form-control" id="select_class_field_report" onchange="get_stud_byClass_comment()">
                                    <php
                                    $select_classes = mysqli_query($conn, "SELECT id, classname FROM class WHERE school_id='$school_id'");
                                    while ($class_row = mysqli_fetch_array($select_classes)) {
                                    ?>
                                        <option value="<?= $class_row['id'] ?>"><?= $class_row['classname'] ?></option>
                                    s<php
                                    }
                                    ?>
                                </select> -->
                            </div>

                        </div>
                        <div class="container-fluid mt-4">
                            <div class="py-3 px-15 bg-white data_overlay" style="border-radius: 10px; position: absolute; left:0;">
                                <p class="font-weight-bold">No student in the class selected</p>
                            </div>
                            <table id="student_table_comment" class="display nowrap" style="width:100%;">

                            </table>
                            <div class="" id="">
                                <button type="button" class="btn btn-primary" onclick="save_comment()">Save Comments</button>
                                <!-- <button type="button" class="btn btn-sm select_btn approve_disaprove" onclick="approve_disaprove_comment(this)">Approve</button> -->
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
    <!-- a modal for list of suggested comments in cards with edit and delete icons -->
    <div class="modal fade" id="suggestionModal" tabindex="-1" role="dialog" aria-labelledby="suggestionModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-scrollable modal-xl modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="suggestionModalLabel">Suggested Comments</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body p-0" style="overflow-x:hidden;">
                    <div class="container-fluid pt-3 pb-0" style="position:sticky;top:0;z-index:2;background:white;">
                        <div class="row mb-2">
                            <div class="col-sm-12">
                                <input type="text" id="searchSuggestedComments" class="form-control" placeholder="Search comments...">
                            </div>
                        </div>
                    </div>
                    <div id="suggestedCommentsScrollArea" style="">
                        <!-- Suggested Comment Cards will be dynamically added here -->
                        <div class="" style="padding-bottom: 120px; padding-top: 10px;" id="suggestedCommentsContainer">
                        </div>
                    </div>



                </div>
                <div class="modal-footer">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-sm-12">
                                <form id="newSuggestionForm">
                                    <div class="form-group mb-2">
                                        <label for="newSuggestion">Add New Suggestion:</label>
                                        <p class="small">To specify student name, type - <b>{name}</b>. Example: {name} is a good student</p>
                                        <textarea class="form-control" id="newSuggestion" rows="2" placeholder="Example: {name} is a good student"></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Submit Suggestion</button>
                                    <button type="button" class="btn btn-outline-secondary float-right" data-dismiss="modal">Close</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="comment_skill_modal">
        <div class="modal-dialog modal-dialog-scrollable modal-xl modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Behavioural & Psychomotive Skill Skills</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="mb-4 col-sm-12 col-lg-6">
                            <p class="font-weight-bold muted-text">General Behaviour</p>
                            <table>
                                <thead>
                                    <tr>
                                        <th></th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Punctuality</td>
                                        <td><input type="button" class="btn togglebtn punctuality" name="punctuality" value="5"></td>
                                        <td><input type="button" class="btn togglebtn punctuality" name="punctuality" value="4"></td>
                                        <td><input type="button" class="btn togglebtn punctuality" name="punctuality" value="3"></td>
                                        <td><input type="button" class="btn togglebtn punctuality" name="punctuality" value="2"></td>
                                        <td><input type="button" class="btn togglebtn punctuality" name="punctuality" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Classroom attendance</td>
                                        <td><input type="button" class="btn togglebtn classattendance" name="classattendance" value="5"></td>
                                        <td><input type="button" class="btn togglebtn classattendance" name="classattendance" value="4"></td>
                                        <td><input type="button" class="btn togglebtn classattendance" name="classattendance" value="3"></td>
                                        <td><input type="button" class="btn togglebtn classattendance" name="classattendance" value="2"></td>
                                        <td><input type="button" class="btn togglebtn classattendance" name="classattendance" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Response to assignment</td>
                                        <td><input type="button" class="btn togglebtn resptoass" name="resptoass" value="5"></td>
                                        <td><input type="button" class="btn togglebtn resptoass" name="resptoass" value="4"></td>
                                        <td><input type="button" class="btn togglebtn resptoass" name="resptoass" value="3"></td>
                                        <td><input type="button" class="btn togglebtn resptoass" name="resptoass" value="2"></td>
                                        <td><input type="button" class="btn togglebtn resptoass" name="resptoass" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Neatness</td>
                                        <td><input type="button" class="btn togglebtn Neatness" name="Neatness" value="5"></td>
                                        <td><input type="button" class="btn togglebtn Neatness" name="Neatness" value="4"></td>
                                        <td><input type="button" class="btn togglebtn Neatness" name="Neatness" value="3"></td>
                                        <td><input type="button" class="btn togglebtn Neatness" name="Neatness" value="2"></td>
                                        <td><input type="button" class="btn togglebtn Neatness" name="Neatness" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Politeness</td>
                                        <td><input type="button" class="btn togglebtn Politeness" name="Politeness" value="5"></td>
                                        <td><input type="button" class="btn togglebtn Politeness" name="Politeness" value="4"></td>
                                        <td><input type="button" class="btn togglebtn Politeness" name="Politeness" value="3"></td>
                                        <td><input type="button" class="btn togglebtn Politeness" name="Politeness" value="2"></td>
                                        <td><input type="button" class="btn togglebtn Politeness" name="Politeness" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Honesty</td>
                                        <td><input type="button" class="btn togglebtn Honesty" name="Honesty" value="5"></td>
                                        <td><input type="button" class="btn togglebtn Honesty" name="Honesty" value="4"></td>
                                        <td><input type="button" class="btn togglebtn Honesty" name="Honesty" value="3"></td>
                                        <td><input type="button" class="btn togglebtn Honesty" name="Honesty" value="2"></td>
                                        <td><input type="button" class="btn togglebtn Honesty" name="Honesty" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Self control</td>
                                        <td><input type="button" class="btn togglebtn selfcontrol" name="selfcontrol" value="5"></td>
                                        <td><input type="button" class="btn togglebtn selfcontrol" name="selfcontrol" value="4"></td>
                                        <td><input type="button" class="btn togglebtn selfcontrol" name="selfcontrol" value="3"></td>
                                        <td><input type="button" class="btn togglebtn selfcontrol" name="selfcontrol" value="2"></td>
                                        <td><input type="button" class="btn togglebtn selfcontrol" name="selfcontrol" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Relationship with others</td>
                                        <td><input type="button" class="btn togglebtn relationship" name="relationship" value="5"></td>
                                        <td><input type="button" class="btn togglebtn relationship" name="relationship" value="4"></td>
                                        <td><input type="button" class="btn togglebtn relationship" name="relationship" value="3"></td>
                                        <td><input type="button" class="btn togglebtn relationship" name="relationship" value="2"></td>
                                        <td><input type="button" class="btn togglebtn relationship" name="relationship" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Sense of responsibility</td>
                                        <td><input type="button" class="btn togglebtn responsibility" name="responsibility" value="5"></td>
                                        <td><input type="button" class="btn togglebtn responsibility" name="responsibility" value="4"></td>
                                        <td><input type="button" class="btn togglebtn responsibility" name="responsibility" value="3"></td>
                                        <td><input type="button" class="btn togglebtn responsibility" name="responsibility" value="2"></td>
                                        <td><input type="button" class="btn togglebtn responsibility" name="responsibility" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Organizational Ability</td>
                                        <td><input type="button" class="btn togglebtn organizationability" name="organizationability" value="5"></td>
                                        <td><input type="button" class="btn togglebtn organizationability" name="organizationability" value="4"></td>
                                        <td><input type="button" class="btn togglebtn organizationability" name="organizationability" value="3"></td>
                                        <td><input type="button" class="btn togglebtn organizationability" name="organizationability" value="2"></td>
                                        <td><input type="button" class="btn togglebtn organizationability" name="organizationability" value="1"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="col-sm-12 col-lg-6">
                            <p class="font-weight-bold muted-text">Psychomotive Skill</p>
                            <table>
                                <thead>
                                    <tr>
                                        <th></th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>Obedience</td>
                                        <td><input type="button" class="btn togglebtn Obedience" name="Obedience" value="5"></td>
                                        <td><input type="button" class="btn togglebtn Obedience" name="Obedience" value="4"></td>
                                        <td><input type="button" class="btn togglebtn Obedience" name="Obedience" value="3"></td>
                                        <td><input type="button" class="btn togglebtn Obedience" name="Obedience" value="2"></td>
                                        <td><input type="button" class="btn togglebtn Obedience" name="Obedience" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Creativity</td>
                                        <td><input type="button" class="btn togglebtn Creativity" name="Creativity" value="5"></td>
                                        <td><input type="button" class="btn togglebtn Creativity" name="Creativity" value="4"></td>
                                        <td><input type="button" class="btn togglebtn Creativity" name="Creativity" value="3"></td>
                                        <td><input type="button" class="btn togglebtn Creativity" name="Creativity" value="2"></td>
                                        <td><input type="button" class="btn togglebtn Creativity" name="Creativity" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Writing</td>
                                        <td><input type="button" class="btn togglebtn Writing" name="Writing" value="5"></td>
                                        <td><input type="button" class="btn togglebtn Writing" name="Writing" value="4"></td>
                                        <td><input type="button" class="btn togglebtn Writing" name="Writing" value="3"></td>
                                        <td><input type="button" class="btn togglebtn Writing" name="Writing" value="2"></td>
                                        <td><input type="button" class="btn togglebtn Writing" name="Writing" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Fluency</td>
                                        <td><input type="button" class="btn togglebtn Fluency" name="Fluency" value="5"></td>
                                        <td><input type="button" class="btn togglebtn Fluency" name="Fluency" value="4"></td>
                                        <td><input type="button" class="btn togglebtn Fluency" name="Fluency" value="3"></td>
                                        <td><input type="button" class="btn togglebtn Fluency" name="Fluency" value="2"></td>
                                        <td><input type="button" class="btn togglebtn Fluency" name="Fluency" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Sport</td>
                                        <td><input type="button" class="btn togglebtn Sport" name="Sport" value="5"></td>
                                        <td><input type="button" class="btn togglebtn Sport" name="Sport" value="4"></td>
                                        <td><input type="button" class="btn togglebtn Sport" name="Sport" value="3"></td>
                                        <td><input type="button" class="btn togglebtn Sport" name="Sport" value="2"></td>
                                        <td><input type="button" class="btn togglebtn Sport" name="Sport" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Games</td>
                                        <td><input type="button" class="btn togglebtn Games" name="Games" value="5"></td>
                                        <td><input type="button" class="btn togglebtn Games" name="Games" value="4"></td>
                                        <td><input type="button" class="btn togglebtn Games" name="Games" value="3"></td>
                                        <td><input type="button" class="btn togglebtn Games" name="Games" value="2"></td>
                                        <td><input type="button" class="btn togglebtn Games" name="Games" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Drawing & Painting</td>
                                        <td><input type="button" class="btn togglebtn DrawingPainting" name="DrawingPainting" value="5"></td>
                                        <td><input type="button" class="btn togglebtn DrawingPainting" name="DrawingPainting" value="4"></td>
                                        <td><input type="button" class="btn togglebtn DrawingPainting" name="DrawingPainting" value="3"></td>
                                        <td><input type="button" class="btn togglebtn DrawingPainting" name="DrawingPainting" value="2"></td>
                                        <td><input type="button" class="btn togglebtn DrawingPainting" name="DrawingPainting" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Music Performance</td>
                                        <td><input type="button" class="btn togglebtn Music" name="Music" value="5"></td>
                                        <td><input type="button" class="btn togglebtn Music" name="Music" value="4"></td>
                                        <td><input type="button" class="btn togglebtn Music" name="Music" value="3"></td>
                                        <td><input type="button" class="btn togglebtn Music" name="Music" value="2"></td>
                                        <td><input type="button" class="btn togglebtn Music" name="Music" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Handling Tools</td>
                                        <td><input type="button" class="btn togglebtn HandlingTools" name="HandlingTools" value="5"></td>
                                        <td><input type="button" class="btn togglebtn HandlingTools" name="HandlingTools" value="4"></td>
                                        <td><input type="button" class="btn togglebtn HandlingTools" name="HandlingTools" value="3"></td>
                                        <td><input type="button" class="btn togglebtn HandlingTools" name="HandlingTools" value="2"></td>
                                        <td><input type="button" class="btn togglebtn HandlingTools" name="HandlingTools" value="1"></td>
                                    </tr>
                                    <tr>
                                        <td>Craft</td>
                                        <td><input type="button" class="btn togglebtn Crafts" name="Crafts" value="5"></td>
                                        <td><input type="button" class="btn togglebtn Crafts" name="Crafts" value="4"></td>
                                        <td><input type="button" class="btn togglebtn Crafts" name="Crafts" value="3"></td>
                                        <td><input type="button" class="btn togglebtn Crafts" name="Crafts" value="2"></td>
                                        <td><input type="button" class="btn togglebtn Crafts" name="Crafts" value="1"></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
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
    <!-- Select2 -->

    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/js/select2.min.js"></script>

    <!-- <script src="../plugins/select2/js/select2.full.min.js"></script> -->
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>

    <script src="../plugins/toastr/toastr.min.js"></script>
    <!-- <script>$('.select2').select2()</script> -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>


    <script src="../dist/js/skul.js?v=009"></script>

    <script>
        // Suggested Comments Modal Logic

        var currentStudentName = '';
        var currentStudentId = '';

        // Store all loaded suggestions for search filtering
        // Pagination and search state
        var suggestionPage = 1;
        var suggestionPerPage = 3;
        var suggestionTotal = 0;
        var suggestionSearch = '';
        var suggestionStudentName = '';

        function loadSuggestedComments(page, search) {
            suggestionPage = page || 1;
            suggestionSearch = typeof search === 'string' ? search : suggestionSearch;
            suggestionStudentName = $('#suggestionModal').data('studentName') || '';
            $('#suggestedCommentsContainer').html('<div class="col-12 text-center text-muted">Loading...</div>');
            $.ajax({
                url: '../comments_controller.php',
                method: 'POST',
                data: {
                    action: 'list',
                    page: suggestionPage,
                    per_page: suggestionPerPage,
                    search: suggestionSearch
                },
                dataType: 'json',
                success: function(res) {
                    if (res.success) {
                        suggestionTotal = res.total;
                        renderSuggestedComments(res.data, suggestionStudentName);
                        renderSuggestionPagination();
                    } else {
                        $('#suggestedCommentsContainer').html('<div class="col-12 text-danger">Failed to load suggestions.</div>');
                    }
                },
                error: function() {
                    $('#suggestedCommentsContainer').html('<div class="col-12 text-danger">Failed to load suggestions.</div>');
                }
            });
        }

        // Render suggestions
        function renderSuggestedComments(data, studentName) {
            var html = `<div class="row m-0 p-2">`;
            if (data && data.length > 0) {
                data.forEach(function(item) {
                    var commentText = item.comment.replace(/\{name\}/gi, studentName ? studentName : '{name}');
                    html += `
                        <div class="card p-2 m-1 col-12">
                        <div class="card-body p-0">
                            <p class="comment-text">${commentText}</p>
                            <div>
                                <button class="btn btn-sm edit-suggested-comment mr-1" data-id="${item.id}" data-comment="${encodeURIComponent(item.comment)}"><i class="fa fa-edit mr-2"></i>Edit</button>
                                <button class="btn btn-sm text-danger delete-suggested-comment" data-id="${item.id}"><i class="fa fa-trash mr-2"></i>Delete</button>
                                <button class="btn btn-sm accent float-right use-suggested-comment" data-id="${item.id}" data-raw="${encodeURIComponent(item.comment)}"><i class="fa fa-check mr-2"></i>Use</button>
                            </div>
                        </div>
                        </div>`;
                });
                html += `</div>`;
            } else {
                html = '<div class="col-12 text-center text-muted">No suggested comments found.</div>';
            }
            $('#suggestedCommentsContainer').html(html);
        }

        // Render pagination controls
        function renderSuggestionPagination() {
            var totalPages = Math.ceil(suggestionTotal / suggestionPerPage);
            if (totalPages <= 1) {
                $('#suggestedCommentsContainer').append('');
                return;
            }
            var html = '<nav class="mt-3"><ul class="pagination justify-content-center">';
            for (var i = 1; i <= totalPages; i++) {
                html += `<li class="page-item${i === suggestionPage ? ' active' : ''}"><a class="page-link suggestion-page-link" href="#" data-page="${i}">${i}</a></li>`;
            }
            html += '</ul></nav>';
            $('#suggestedCommentsContainer').append(html);
        }

        // Pagination click event
        $(document).on('click', '.suggestion-page-link', function(e) {
            e.preventDefault();
            var page = parseInt($(this).data('page'));
            if (!isNaN(page) && page !== suggestionPage) {
                loadSuggestedComments(page, suggestionSearch);
            }
        });

        // Search input event
        $(document).on('input', '#searchSuggestedComments', function() {
            var search = $(this).val() || '';
            loadSuggestedComments(1, search);
        });

        // Track which role to fill (teacher or principal) when opening the modal
        // Use data attributes on the modal for reliability
        $(document).on('click', '.open-suggestion-modal', function() {
            var studentName = $(this).data('student_name') || '';
            var studentId = $(this).data('student_id') || '';
            var $td = $(this).closest('td');
            var commentRole = '';
            if ($td.find('.teacher_comment_comment').length) {
                commentRole = 'teacher';
            } else if ($td.find('.principal_comment_comment').length) {
                commentRole = 'principal';
            }
            // Store on modal
            $('#suggestionModal').data('studentName', studentName)
                .data('studentId', studentId)
                .data('commentRole', commentRole);
        });

        // On modal show, load suggestions (no need to set globals)
        $(document).on('show.bs.modal', '#suggestionModal', function() {
            // Add search input if not present
            if ($('#searchSuggestedComments').length === 0) {
                var searchHtml = '<div class="row mb-2"><div class="col-12"><input type="text" id="searchSuggestedComments" class="form-control" placeholder="Search suggested comments..."></div></div>';
                $(this).find('.container-fluid.pt-3').prepend(searchHtml);
            }
            loadSuggestedComments(1, '');
        });

        // Handle use suggestion button click
        $(document).on('click', '.use-suggested-comment', function() {
            var rawComment = decodeURIComponent($(this).data('raw'));
            var modal = $('#suggestionModal');
            var studentName = modal.data('studentName') || '';
            var studentId = modal.data('studentId') || '';
            var commentRole = modal.data('commentRole') || '';
            // Replace {name} with the current student's name
            var commentText = rawComment.replace(/\{name\}/gi, studentName ? studentName : '{name}');
            // Find the correct textarea for the student and role
            var row = $("#student_table_comment tr").filter(function() {
                return $(this).find('.student_id_comment').val() == studentId;
            });
            if (commentRole === 'teacher') {
                row.find('.teacher_comment_comment').val(commentText);
            } else if (commentRole === 'principal') {
                row.find('.principal_comment_comment').val(commentText);
            }
            // Optionally close the modal
            $('#suggestionModal').modal('hide');
        });

        // Handle add suggestion
        $(document).on('submit', '#newSuggestionForm', function(e) {
            e.preventDefault();
            var comment = $('#newSuggestion').val().trim();
            if (!comment) return;
            $.ajax({
                url: '../comments_controller.php',
                method: 'POST',
                data: {
                    action: 'add',
                    comment: comment
                },
                dataType: 'json',
                success: function(res) {
                    if (res.success) {
                        $('#newSuggestion').val('');
                        loadSuggestedComments();
                    } else {
                        alert(res.message || 'Failed to add comment');
                    }
                },
                error: function() {
                    alert('Failed to add comment');
                }
            });
        });

        // Handle edit button click for suggested comment
        $(document).on('click', '.edit-suggested-comment', function() {
            var card = $(this).closest('.card');
            var commentId = $(this).data('id');
            var encodedComment = $(this).data('comment');
            // Always restore {name} for editing
            var commentRaw = decodeURIComponent(encodedComment);
            // Replace the comment text with a textarea and save button
            var editHtml = `
                <textarea class="form-control edit-suggestion-textarea" rows="3">${commentRaw}</textarea>
                <button class="btn btn-sm btn-success mt-2 save-suggested-comment" data-id="${commentId}">Save</button>
                <button class="btn btn-sm btn-secondary mt-2 cancel-edit-suggested-comment">Cancel</button>
            `;
            card.find('.card-body').html(editHtml);
        });

        // Handle cancel edit
        $(document).on('click', '.cancel-edit-suggested-comment', function() {
            // Reload the suggestions to restore the original view
            loadSuggestedComments();
        });

        // Handle save button click for suggested comment
        $(document).on('click', '.save-suggested-comment', function() {
            var card = $(this).closest('.card');
            var commentId = $(this).data('id');
            var newComment = card.find('.edit-suggestion-textarea').val().trim();
            if (!newComment) return;
            // Save via AJAX
            $.ajax({
                url: '../comments_controller.php',
                method: 'POST',
                data: {
                    action: 'edit',
                    id: commentId,
                    comment: newComment
                },
                dataType: 'json',
                success: function(res) {
                    if (res.success) {
                        loadSuggestedComments();
                    } else {
                        alert(res.message || 'Failed to update comment');
                    }
                },
                error: function() {
                    alert('Failed to update comment');
                }
            });
        });

        // Handle delete button click for suggested comment (inline confirm UI)
        $(document).on('click', '.delete-suggested-comment', function() {
            var card = $(this).closest('.card');
            var commentId = $(this).data('id');
            if (!commentId) return;
            // Remove any other delete warnings
            $('.delete-warning-row').remove();
            // Hide the card body content, but keep the card
            var cardBody = card.find('.card-body');
            var originalHtml = cardBody.html();
            cardBody.data('originalHtml', originalHtml);
            var warningHtml = `
                <div class="delete-warning-row p-2 bg-warning text-dark rounded">
                    <div>Are you sure you want to delete this suggested comment?</div>
                    <button class="btn btn-sm btn-danger mt-2 confirm-delete-suggested-comment" data-id="${commentId}">Yes, Delete</button>
                    <button class="btn btn-sm btn-secondary mt-2 cancel-delete-suggested-comment ml-2">Cancel</button>
                </div>
            `;
            cardBody.html(warningHtml);
        });

        // Handle cancel delete (restore original card view)
        $(document).on('click', '.cancel-delete-suggested-comment', function() {
            var card = $(this).closest('.card');
            var cardBody = card.find('.card-body');
            var originalHtml = cardBody.data('originalHtml');
            if (originalHtml) {
                cardBody.html(originalHtml);
            } else {
                loadSuggestedComments();
            }
        });

        // Handle confirm delete (AJAX delete)
        $(document).on('click', '.confirm-delete-suggested-comment', function() {
            var commentId = $(this).data('id');
            if (!commentId) return;
            var card = $(this).closest('.card');
            var cardBody = card.find('.card-body');
            // Optionally, show a spinner or disable buttons here
            $.ajax({
                url: '../comments_controller.php',
                method: 'POST',
                data: {
                    action: 'delete',
                    id: commentId
                },
                dataType: 'json',
                success: function(res) {
                    if (res.success) {
                        loadSuggestedComments();
                    } else {
                        cardBody.html('<div class="text-danger">' + (res.message || 'Failed to delete comment') + '</div>');
                        setTimeout(loadSuggestedComments, 1500);
                    }
                },
                error: function() {
                    cardBody.html('<div class="text-danger">Failed to delete comment</div>');
                    setTimeout(loadSuggestedComments, 1500);
                }
            });
        });
    </script>


</body>

</html>