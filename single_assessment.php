<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
$_SESSION['location'] = explode("/", $_SERVER['REQUEST_URI'])[3];
$school_settings = json_decode($_SESSION['skul_settings'], true);
if (isset($_GET['id'])) {
    $assessment_id = $_GET['id'];
}
if (isset($_GET['page'])) {
    $page = max(1, intval($_GET['page']));
} else {
    $page = 1;
}
$per_page = 5; // number of questions per page
$offset = ($page - 1) * $per_page;

// select assessment data
$sql = "SELECT * FROM assessment WHERE id = '$assessment_id'";
$result = mysqli_query($conn, $sql);
$assessment_data = mysqli_fetch_assoc($result);

if (!$assessment_data) {
    $assessment_data = [
        'id' => null,
        'subject_id' => null,
        'assessment_type' => 1,
        'instruction' => '',
        'duration' => 20,
        'duration_set' => 1,
        'deadline_date' => '',
        'deadline_time' => '00:00:00',
        'deadline_set' => 0,
        'class_ids' => '',
        'desired_score' => 0,
        'round_off_decimal' => 0,
        'term' => 1,
        'score_destination' => '6'
    ];
}

// total questions count for pagination
$count_sql = "SELECT COUNT(*) as cnt FROM questions WHERE ass_id = '$assessment_id' and deleted=0";
$count_res = mysqli_query($conn, $count_sql);
$total_questions = 0;
if ($count_row = mysqli_fetch_assoc($count_res)) {
    $total_questions = intval($count_row['cnt']);
}
$total_pages = max(1, ceil($total_questions / $per_page));

// fetch only the first page (or requested page) of questions
$questions_sql = "SELECT * FROM questions WHERE ass_id = '$assessment_id' and deleted=0 ORDER BY id LIMIT $offset, $per_page";
$questions_result = mysqli_query($conn, $questions_sql);
$has_questions = mysqli_num_rows($questions_result) > 0;
// echo "ll";
// exit;

// Store questions and their options (only current page)
$questions_data = array();
// For question numbering
$start_question_num = $offset + 1;
$q_index = 0;
while ($question = mysqli_fetch_assoc($questions_result)) {
    $question_id = $question['id'];
    $options_sql = "SELECT * FROM options WHERE question_id = '$question_id' and deleted=0";
    $options_result = mysqli_query($conn, $options_sql);
    $options = array();
    while ($option = mysqli_fetch_assoc($options_result)) {
        $options[] = $option;
    }
    $questions_data[] = array(
        'question' => $question,
        'options' => $options,
        'number' => $start_question_num + $q_index
    );
    $q_index++;
}
// var_dump($questions_data)
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Assessment</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Select2 -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/css/select2.min.css" rel="stylesheet" />
    <!-- summernote -->
    <!--<link rel="stylesheet" href="../plugins/summernote/summernote-bs4.min.css">-->
    <!--<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">-->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.9.1/summernote-bs4.min.css" integrity="sha512-rDHV59PgRefDUbMm2lSjvf0ZhXZy3wgROFyao0JxZPGho3oOuWejq/ELx0FOZJpgaE5QovVtRN65Y3rrb7JhdQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mathquill/0.10.1/mathquill.min.css" rel="stylesheet">
    <!-- <link rel="stylesheet" href="../plugins/select2/css/select2.min.css"> -->

    <!-- daterange picker -->
    <link rel="stylesheet" href="../plugins/daterangepicker/daterangepicker.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <!--<link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">-->
    <!--<link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">-->
    <!--<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.9.3/dropzone.min.css">-->
    <style>
        .accent_active {
            background-color: #007bff;
            color: white;
        }

        .select2-container {
            display: none !important;
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
                            <a href="staff_attendance" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">add_chart</i>
                                    Staff Attendance
                                </p>
                            </a>
                        </li>
                        <?php if ($_SESSION['school_id'] == 27 || $_SESSION['school_id'] == 13) {  ?>
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
                            <a href="assessment" class="nav-link active">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">app_registration</i>
                                    Assessments
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="question_bank" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">library_books</i>
                                    Question Bank
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="payments" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">payments</i>
                                    Payments
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
                <input type="hidden" id="select_session_field" class="session_value" value="<?= $school_settings['session']; ?>">
                <input type="hidden" id="assessment_page" value="assessment">
                <input type="hidden" name="subject_id" id="select_subject_field" class="subject_value" value="<?= $assessment_data['subject_id'] ?>">


                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="mb-3">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Assessment</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">Assessment</li>
                                    </ol>
                                </div>
                                <div>
                                    <div class="row">
                                        <!-- <div class="col-12 col-md-3" id="select_subject_single">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Subject</label>
                                                <select class="form-control select2" class="select_subject_field2" id="select_subject_fiel" onchange="" style="width: 100%;">
                                                    <option selected value="1">Activate</option>
                                                </select>
                                            </div>
                                        </div> -->
                                        <div class="col-12" id="select_assessment_single">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Assessment</label>
                                                <div class="assessment_type_btn d-flex flex-wrap" style="gap:15px;">
                                                    <button type="button" class="btn assessment_btn select_btn <?= $assessment_data['assessment_type'] == 1 ? 'active' : '' ?>" data-id="1" onclick="toggle_assessment_btn(this)">Assignment</button>
                                                    <button type="button" class="btn assessment_btn select_btn <?= $assessment_data['assessment_type'] == 2 ? 'active' : '' ?>" data-id="2" onclick="toggle_assessment_btn(this)">CA</button>
                                                    <button type="button" class="btn assessment_btn select_btn <?= $assessment_data['assessment_type'] == 3 ? 'active' : '' ?>" data-id="3" onclick="toggle_assessment_btn(this)">Exam</button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-12" id="select_term_single">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Term</label>
                                                <div class="assessment_term_btn d-flex flex-wrap" style="gap:10px;">
                                                    <button type="button" class="btn term_btn select_btn <?= $assessment_data['term'] == 1 ? 'active' : '' ?>" data-id="1" onclick="toggle_term_btn(this)">First</button>
                                                    <button type="button" class="btn term_btn select_btn <?= $assessment_data['term'] == 2 ? 'active' : '' ?>" data-id="2" onclick="toggle_term_btn(this)">Second</button>
                                                    <button type="button" class="btn term_btn select_btn <?= $assessment_data['term'] == 3 ? 'active' : '' ?>" data-id="3" onclick="toggle_term_btn(this)">Third</button>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-12">
                                            <div class="form-group align-left">
                                                <p class="mb-0 btn accent" onclick="get_all_classes_for_assessment('<?= $assessment_id ?>')">+ Assign Classes</p>
                                                <div class="col-12 classes_container d-flex flex-wrap" style="gap:10px">
                                                    <?php
                                                    // Split the class_ids string into an array
                                                    $class_ids = explode(',', $assessment_data['class_ids']);

                                                    // Loop through each class ID
                                                    foreach ($class_ids as $class_id) {
                                                        if (!empty($class_id)) { // Check if class_id is not empty
                                                    ?>
                                                            <button class="btn btn-sm btn-primary d-flex" onclick="remove_this_class(this)"
                                                                data-class-id="<?= $class_id ?>">
                                                                <span class="material-symbols-outlined mr-1" style="font-size: 21px;">close</span>
                                                                <?= get_class_by_classid($class_id) ?>
                                                            </button>
                                                    <?php
                                                        }
                                                    }
                                                    ?>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="container-fluid mt-4 px-0">
                        <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                            <!-- <div class=""> -->
                            <!-- <div class="py-3 px-15 bg-white data_overlay" style="border-radius: 10px; position: relative; left:0;">
                                <p class="font-weight-bold">No student in the class selected</p>
                            </div> -->
                            <div class="form-group col-12 ml-0 p-0">
                                <p class="p-0 mb-0 muted-text">Instruction/Description</p>
                                <p class="p-0 mb-0 small">What do you want the student to know before starting the assessment</p>
                                <textarea name="description" class="form-control" id="assessment_instruction" cols="4" rows="2"><?= htmlspecialchars($assessment_data['instruction']) ?></textarea>
                            </div>
                            <div class="row">
                                <div class="form-group mb-0 col-12 col-sm-4">
                                    <div class="input-group mb-3 d-flex align-items-center">
                                        <label for="" class="mb-0">Duration:</label>
                                        <input type="number" min='1' class="form-control" id="assessment_duration" value="<?= $assessment_data['duration'] ?>" placeholder="20">
                                        <div class="input-group-prepend">
                                            <select class="form-control" id="duration_unit">
                                                <option value="1">Minutes</option>
                                                <option value="2">Hours</option>
                                            </select>
                                        </div>
                                        <!--<div class="input-group-prepend icheck-gray-dark ml-2">-->
                                        <!--    <input <?= $assessment_data['duration_set'] ? 'checked' : '' ?> class="class-checkbox" type="checkbox" id="set_duration_checkbox">-->
                                        <!--    <label for="set_duration_checkbox">Set Duration</label>-->
                                        <!--</div>-->
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group mb-0 col-12 col-sm-4">
                                    <div class="input-group mb-3 d-flex align-items-center">
                                        <label for="" class="mb-0">Deadline Date:</label>
                                        <input type="date" class="form-control" id="deadline_date" value="<?= $assessment_data['deadline_date'] ?>">
                                        <input type="time" class="form-control" id="deadline_time" value="<?= $assessment_data['deadline_time'] ?>">
                                        <!--<div class="input-group-prepend icheck-gray-dark ml-2">-->
                                        <!--    <input <?= $assessment_data['deadline_Set'] ? 'checked' : '' ?> class="class-checkbox" type="checkbox" id="set_deadline_checkbox">-->
                                        <!--    <label for="set_deadline_checkbox">Set Deadline</label>-->
                                        <!--</div>-->
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group mb-0 col-12 col-sm-4">
                                    <div class="input-group mb-3 d-flex align-items-center">
                                        <label for="" class="mb-0">Desired Score:</label>
                                        <input type="number" min='0' class="form-control" id="desired_score" value="<?= $assessment_data['desired_score'] ?>" placeholder="Enter desired score">
                                        <div class="input-group-prepend icheck-gray-dark ml-2">
                                            <input <?= $assessment_data['round_off_decimal'] ? 'checked' : '' ?> class="class-checkbox" type="checkbox" id="round_off_dec">
                                            <label for="round_off_dec">Round off decimal</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="form-group mb-0 col-12 col-sm-4">
                                    <label for="" class="mb-0">Which assessment is this score for?</label>
                                    <div class="d-flex" style="flex-wrap: wrap; gap: 15px;">
                                        <?php if ($school_settings['ca1'] == 1): ?>
                                            <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                                <input type="radio" name="ca" id="ca_1" value="1" <?= $assessment_data['score_destination'] == '1' ? 'checked' : '' ?>>
                                                <label for="ca_1" class="mb-0">CA1</label>
                                            </div>
                                        <?php endif; ?>
                                        <?php if ($school_settings['ca2'] == 1): ?>
                                            <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                                <input type="radio" name="ca" id="ca_2" value="2" <?= $assessment_data['score_destination'] == '2' ? 'checked' : '' ?>>
                                                <label for="ca_2" class="mb-0">CA2</label>
                                            </div>
                                        <?php endif; ?>
                                        <?php if ($school_settings['ca3'] == 1): ?>
                                            <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                                <input type="radio" name="ca" id="ca_3" value="3" <?= $assessment_data['score_destination'] == '3' ? 'checked' : '' ?>>
                                                <label for="ca_3" class="mb-0">CA3</label>
                                            </div>
                                        <?php endif; ?>
                                        <?php if ($school_settings['practical'] == 1): ?>
                                            <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                                <input type="radio" name="ca" id="practical" value="4" <?= $assessment_data['score_destination'] == '4' ? 'checked' : '' ?>>
                                                <label for="practical" class="mb-0">Practical</label>
                                            </div>
                                        <?php endif; ?>
                                        <!-- exam -->
                                        <?php if ($school_settings['exa'] == 1): ?>
                                            <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                                <input type="radio" name="ca" id="exam" value="5" <?= $assessment_data['score_destination'] == '5' ? 'checked' : '' ?>>
                                                <label for="exam" class="mb-0">Exam</label>
                                            </div>
                                        <?php endif; ?>
                                        <!-- else check  radio button "none"  -->
                                        <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                            <input type="radio" name="ca" id="none" value="6" <?= $assessment_data['score_destination'] == '6' ? 'checked' : '' ?>>
                                            <label for="none" class="mb-0">None</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="container-fluid mt-4 px-0">

                        <!-- <php if (!$has_questions): ?>
                            <div class="alert alert-info">
                                No questions available for this assessment yet. Add your first question below.
                            </div>
                        <php endif; ?> -->

                        <!-- Loading spinner for AJAX pagination -->
                        <div id="questions-loading-spinner" style="display:none; text-align:center; padding:40px 0;">
                            <div class="spinner-border text-primary" role="status" style="width:3rem; height:3rem;">
                                <span class="sr-only">Loading...</span>
                            </div>
                        </div>
                        <div id="questions-container">
                            <?php foreach ($questions_data as $index => $qdata): ?>
                                <div class="py-3 px-15 bg-white mb-3 question-block" style="border-radius: 10px;" data-question-id="<?= $qdata['question']['id'] ?>">
                                    <div class="form-group">
                                        <label>Question <?= $qdata['number'] ?></label>
                                        <textarea class="question-textarea form-control" style="height: 200px"><?= htmlspecialchars($qdata['question']['question']) ?></textarea>
                                    </div>
                                    <div class="options-container mt-3">
                                        <div class="form-group">
                                            <label>Options</label>
                                            <p class="text-muted small">Select the radio button for the correct answer</p>
                                            <div class="row">
                                                <?php foreach ($qdata['options'] as $opt_index => $option): ?>
                                                    <div class="option-group col-md-6 col-12 mb-3 d-flex align-items-start">
                                                        <div class="icheck-primary d-flex">
                                                            <input type="radio"
                                                                id="radio_<?= $qdata['question']['id'] ?>_<?= $option['id'] ?>"
                                                                name="question_<?= $qdata['question']['id'] ?>"
                                                                <?= $option['answer'] ? 'checked' : '' ?>>
                                                            <label for="radio_<?= $qdata['question']['id'] ?>_<?= $option['id'] ?>"></label>
                                                            <textarea class="form-control option-textarea" data-option-id="<?= $option['id'] ?>" style="height: 100px"><?= htmlspecialchars($option['options']) ?></textarea>
                                                        </div>
                                                    </div>
                                                <?php endforeach; ?>
                                            </div>
                                        </div>
                                    </div>
                                    <button type="button" class="btn btn-danger btn-sm mt-2" onclick="deleteQuestion(<?= $qdata['question']['id'] ?>)">Delete Question</button>
                                </div>
                            <?php endforeach; ?>
                        </div>
                        <div class="d-flex align-items-center mt-3 flex-wrap" style="gap:10px">
                            <button type="button" class="btn btn-secondary" id="prev-page-btn">Previous</button>
                            <span>Page <span id="current-page"><?= $page ?></span> / <span id="total-pages"><?= $total_pages ?></span></span>
                            <button type="button" class="btn btn-secondary" id="next-page-btn">Next</button>
                            <!-- Add New Question: only visible on last page or when there is a single page -->
                            <button type="button" class="btn btn-primary" id="add-question-btn" <?= ($page != $total_pages) ? 'style="display:none"' : '' ?>>Add New Question</button>
                            <button type="button" class="btn btn-info" id="import-question-btn" onclick="openImportQuestionModal()" <?= ($page != $total_pages) ? 'style="display:none"' : '' ?>>Import Question</button>
                            <button type="button" class="btn btn-success" id="ai-question-btn" onclick="openAIGeneratorModal()" <?= ($page != $total_pages) ? 'style="display:none"' : '' ?>>Generate Question with AI</button>
                            <!-- <button type="button" class="btn btn-success ml-auto" id="save-page-btn">Save Page</button> -->
                            <button type="button" class="btn btn-primary d-block" id="save-all-btn">Save Assessment</button>
                        </div>
                        <div>
                        </div>
                    </div>

                </div>

                <!-- /.row_class -->
            </div><!-- /.container-fluid -->
        </div>
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->



    </div>

    <div class="modal fade" id="removeClassModal" tabindex="-1" role="dialog" aria-labelledby="removeClassModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="removeClassModalLabel">Remove Class</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    Are you sure you want to remove this class?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" onclick="confirmRemoveClass()">Remove</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Add modal for existing assessment warning -->
    <div class="modal fade" id="existingAssessmentModal" tabindex="-1" role="dialog" aria-labelledby="existingAssessmentModalLabel" aria-hidden="true" data-backdrop="static" data-keyboard="false">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title" id="existingAssessmentModalLabel">Existing Assessment Found</p>
                </div>
                <div class="modal-body">
                    An assessment already exists for the selected class(es). Select another class(es).
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="handleExistingAssessmentResponse(false)">Reassign classes</button>
                    <!-- <button type="button" class="btn btn-primary" onclick="handleExistingAssessmentResponse(true)">Continue</button> -->
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="assess_classesModal" tabindex="-1" role="dialog" aria-labelledby="classesModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="classesModalLabel">Select Classes</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="classes-list">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="saveSelectedClasses()">Save changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Import Question Modal -->
    <div class="modal fade" id="importQuestionModal" tabindex="-1" role="dialog" aria-labelledby="importQuestionModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header bg-info text-white">
                    <h5 class="modal-title" id="importQuestionModalLabel">Import Question from Bank</h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body bg-light">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group border bg-white p-2 rounded">
                                <label>Subject</label>
                                <select class="form-control" id="import_subject_filter"></select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group border bg-white p-2 rounded">
                                <label>Source Type</label>
                                <select class="form-control" id="import_source_type">
                                    <option value="">Select Type</option>
                                    <option value="Local">Local (School)</option>
                                    <option value="Exam bodies">Exam Bodies (WAEC/JAMB)</option>
                                    <option value="Topics">Topics</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group border bg-white p-2 rounded">
                                <label>Class</label>
                                <select class="form-control" id="import_class_filter"></select>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="import_dynamic_filter_container" style="display:none;">
                        <div class="col-md-12">
                            <div class="form-group border bg-white p-2 rounded" id="import_exam_body_container" style="display:none;">
                                <label>Exam Body</label>
                                <select class="form-control" id="import_exam_body"></select>
                            </div>
                            <div class="form-group border bg-white p-2 rounded" id="import_topic_container" style="display:none;">
                                <label>Topic(s)</label>
                                <select class="form-control" id="import_topic" multiple size="5"></select>
                                <small class="text-muted">Select one or more topics. Hold Ctrl to select multiple topics.</small>
                            </div>
                        </div>
                    </div>

                    <div class="row" id="import_soft_filter_container" style="display:none;">
                        <div class="col-md-4">
                            <div class="form-group border bg-white p-2 rounded">
                                <label>Difficulty</label>
                                <select class="form-control" id="import_difficulty">
                                    <option value="">All</option>
                                    <option value="Easy">Easy</option>
                                    <option value="Medium">Medium</option>
                                    <option value="Hard">Hard</option>
                                </select>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group border bg-white p-2 rounded">
                                <label>Term Tag</label>
                                <input type="text" class="form-control" id="import_term_tag" placeholder="Optional">
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group border bg-white p-2 rounded">
                                <label>Category</label>
                                <input type="text" class="form-control" id="import_question_category" placeholder="Optional">
                            </div>
                        </div>
                    </div>

                    <div class="bg-white border rounded p-3 mb-3" id="bank-builder-container" style="display:none;">
                        <div class="d-flex justify-content-between align-items-center mb-2">
                            <h6 class="font-weight-bold mb-0">Build from Bank</h6>
                            <button type="button" class="btn btn-sm btn-info" id="build-bank-btn">Build Questions</button>
                        </div>
                        <div class="row">
                            <div class="col-md-4">
                                <label>Easy</label>
                                <input type="number" min="0" max="50" value="4" class="form-control" id="build_easy_count">
                            </div>
                            <div class="col-md-4">
                                <label>Medium</label>
                                <input type="number" min="0" max="50" value="4" class="form-control" id="build_medium_count">
                            </div>
                            <div class="col-md-4">
                                <label>Hard</label>
                                <input type="number" min="0" max="50" value="2" class="form-control" id="build_hard_count">
                            </div>
                        </div>
                        <small class="text-muted d-block mt-2">Uses approved topic questions first, sorted by quality and usage balance.</small>
                    </div>

                    <div class="form-group border bg-white p-2 rounded">
                        <label>Search Questions / Options</label>
                        <input type="search" class="form-control" id="import_search" placeholder="Search question text or option text">
                    </div>

                    <hr>
                    <h6 class="font-weight-bold">Questions</h6>
                    <div id="import-questions-list" style="max-height: 400px; overflow-y:auto;" class="mb-3">
                        <div class="alert alert-info">Please select Subject, Class, and Source Type to view questions.</div>
                    </div>

                    <div id="import-pagination" class="d-flex justify-content-between align-items-center bg-white p-2 rounded shadow-sm" style="display:none !important;">
                        <button type="button" class="btn btn-outline-secondary btn-sm" id="import-prev-btn" disabled>Previous</button>
                        <span id="import-page-info" class="font-weight-bold text-muted">Page 1 / 1</span>
                        <button type="button" class="btn btn-outline-secondary btn-sm" id="import-next-btn" disabled>Next</button>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-info" id="import-submit-btn" onclick="importSelectedQuestions()">Import Selected Questions</button>
                </div>
            </div>
        </div>
    </div>

    <!-- AI Question Generator Modal -->
    <div class="modal fade" id="aiQuestionGeneratorModal" tabindex="-1" role="dialog" aria-labelledby="aiQuestionGeneratorModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl" role="document">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="aiQuestionGeneratorModalLabel">Generate Questions with AI</h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body bg-light">
                    <div class="form-group border bg-white p-2 rounded">
                        <label>Topic / Context</label>
                        <textarea class="form-control ai-summernote" id="ai_topic" rows="3" placeholder="E.g., Newton's laws of motion, Photosynthesis..."></textarea>
                    </div>
                    <div class="form-group border bg-white p-2 rounded">
                        <label>Level of Difficulty</label>
                        <select class="form-control" id="ai_difficulty">
                            <option value="Easy">Easy</option>
                            <option value="Medium" selected>Medium</option>
                            <option value="Hard">Hard</option>
                        </select>
                    </div>
                    <div class="form-group border bg-white p-2 rounded">
                        <label>Number of Questions</label>
                        <input type="number" class="form-control" id="ai_num_questions" value="3" min="1" max="5">
                        <small class="text-muted">Maximum 5 questions per generation.</small>
                    </div>
                    <div id="ai-loading-indicator" style="display:none; text-align:center; padding:10px;">
                        <div class="spinner-border text-success" role="status">
                            <span class="sr-only">Loading...</span>
                        </div>
                        <p class="mt-2 mb-0">Generating questions with AI. This may take a moment...</p>
                    </div>
                </div>
                <div class="modal-footer d-flex justify-content-between">
                    <div>
                        <span id="ai-usage-display" class="badge badge-info p-2" style="display:none; font-size: 14px;">Daily AI Use: <span id="ai-usage-count">0</span> / <span id="ai-usage-limit">5</span> (<span id="ai-usage-remaining">5</span> left)</span>
                    </div>
                    <div>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-success" id="ai-generate-btn" onclick="generateQuestionsWithAI()">Generate</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Unsaved changes modal -->
    <div class="modal fade" id="unsavedChangesModal" tabindex="-1" role="dialog" aria-labelledby="unsavedChangesModalLabel" aria-hidden="true" data-backdrop="static">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="unsavedChangesModalLabel">Unsaved changes</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    You have unsaved changes on this page. What would you like to do?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" id="cancel-continue-btn" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="discard-continue-btn">Discard changes</button>
                    <button type="button" class="btn btn-primary" id="save-continue-btn">Save and continue</button>
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
    <!--<script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>-->
    <!--<script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>-->
    <script src="../plugins/toastr/toastr.min.js"></script>
    <!-- <script>$('.select2').select2()</script> -->
    <!--<script src="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.9.3/dropzone.min.js"></script>-->
    <!-- Summernote -->
    <!--<script src="../plugins/summernote/summernote-bs4.min.js"></script>-->
    <!--<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>-->

    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.9.1/summernote-bs4.min.js" integrity="sha512-/DlF8zrT3XyUWEK7bmU1v7Q0kMXctQfqNwyzCNBB/mdUFxz87bq3X4TqadyuQBJW39g29t1tLNbHYLpXLs1zVA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mathquill/0.10.1/mathquill.min.js"></script>
    <!--<script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>-->
    <!-- <script src="https://cdn.jsdelivr.net/npm/@wiris/mathtype-ckeditor5@7.30.0/plugin.min.js"></script> -->
    <script>

    </script>

    <!--<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>-->
    <!-- Summernote -->
    <!--<script src="../plugins/summernote/summernote-bs4.min.js"></script>-->
    <script src="../dist/js/skul.js"></script>
    <!-- date-range-picker -->
    <script src="../plugins/moment/moment.min.js"></script>
    <script src="../plugins/daterangepicker/daterangepicker.js"></script>
    <script>
        var existingAssessmentId = <?= $_GET['id'] ?>;
        var classElementToRemove = null;
    </script>
    <script src="../dist/js/assessment_image_buffer.js"></script>
    <script src="../dist/js/examination.js?v=90poklk"></script>
    <script src="../dist/js/import_question.js?v=001"></script>
    <script src="https://unpkg.com/turndown/dist/turndown.js"></script>
    <script src="../dist/js/ai_question_generator.js?v=001"></script>
    <script>
        // alert("mkm")
        // Add event listeners for form changes
        $(document).ready(function() {
            // initialize summernote
            initializeSummernote();


            // Hide assessment sections initially
            // $('.assessment-settings-section, .questions-section').hide();

            // Check for existing assessment when required fields change
            // $('#select_subject_field').change(checkExistingAssessment);
            // $('.assessment_btn').click(checkExistingAssessment);

            // Check after saving selected classes
            const originalSaveSelectedClasses = saveSelectedClasses;
            saveSelectedClasses = function() {
                originalSaveSelectedClasses();
                // checkExistingAssessment();
            };

            // addNewQuestion();
        });

        // Pagination helpers
        var currentPage = <?= $page ?>;
        var totalPages = <?= $total_pages ?>;
        var perPage = <?= $per_page ?>;

        function renderResponseHtml(html) {
            $('#questions-container').html(html);
            // re-init editors
            initializeSummernote();
        }

        function loadPage(page) {
            // Show spinner, hide questions
            $('#questions-container').hide();
            $('#questions-loading-spinner').show();
            $.ajax({
                url: '../controller_new.php',
                type: 'POST',
                data: {
                    action: 'load_questions_page',
                    assessment_id: existingAssessmentId,
                    page: page,
                    per_page: perPage
                },
                success: function(resp) {
                    try {
                        var data = typeof resp === 'string' ? JSON.parse(resp) : resp;
                    } catch (e) {
                        var data = resp;
                    }
                    if (data.success) {
                        renderResponseHtml(data.html);
                        currentPage = data.page;
                        totalPages = data.total_pages;
                        // restore pagination UI label and add-question visibility
                        $('#current-page').text(currentPage);
                        $('#total-pages').text(totalPages);
                        if (currentPage === totalPages) $('#add-question-btn').show();
                        else $('#add-question-btn').hide();
                    }
                    // Hide spinner, show questions
                    $('#questions-loading-spinner').hide();
                    $('#questions-container').show();
                },
                error: function() {
                    $('#questions-loading-spinner').hide();
                    $('#questions-container').show();
                    toastr.error('Failed to load questions');
                }
            });
        }

        $('#next-page-btn').click(function() {
            if (currentPage < totalPages) {
                loadPage(currentPage + 1);
            }
        });

        $('#prev-page-btn').click(function() {
            if (currentPage > 1) {
                loadPage(currentPage - 1);
            }
        });

        // collect question + option data for the currently displayed page and save via save_all_questions
        function collectCurrentPageQuestions() {
            var questions = [];
            $('.question-block').each(function() {
                var $q = $(this);
                var qid = $q.data('question-id') || null;
                var questionText = $q.find('.question-textarea').val();
                var options = [];
                $q.find('.option-group').each(function() {
                    var $opt = $(this);
                    var optId = $opt.find('.option-textarea').data('option-id') || null;
                    var optText = $opt.find('.option-textarea').val();
                    var isAnswer = $opt.find('input[type="radio"]').is(':checked');
                    options.push({
                        id: optId,
                        text: optText,
                        isAnswer: isAnswer
                    });
                });
                questions.push({
                    id: qid,
                    question: questionText,
                    options: options
                });
            });
            return questions;
        }
        // Dirty tracking: true when user edits any textarea or option
        var isDirty = false;

        function markDirty() {
            isDirty = true;
        }

        function clearDirty() {
            isDirty = false;
        }

        // mark dirty on edits
        $(document).on('input change', '.question-textarea, .option-textarea, input[type=radio]', function() {
            markDirty();
        });

        // Save current page function (reusable)
        function saveCurrentPage(onSuccess) {
            var questions = collectCurrentPageQuestions();
            $.ajax({
                url: '../controller_new.php',
                type: 'POST',
                data: {
                    action: 'save_all_questions',
                    assessment_id: existingAssessmentId,
                    questions: JSON.stringify(questions)
                },
                success: function(resp) {
                    try {
                        var data = typeof resp === 'string' ? JSON.parse(resp) : resp;
                    } catch (e) {
                        var data = resp;
                    }
                    if (data.success) {
                        toastr.success('Page saved');
                        // update any new question ids
                        if (data.question_ids && data.question_ids.length) {
                            $('.question-block').each(function(i) {
                                var qid = $(this).data('question-id');
                                if (!qid && data.question_ids[i]) {
                                    $(this).attr('data-question-id', data.question_ids[i]);
                                }
                            });
                        }
                        clearDirty();
                        if (typeof onSuccess === 'function') onSuccess();
                    } else {
                        toastr.error(data.message || 'Save failed');
                    }
                },
                error: function() {
                    toastr.error('Save failed');
                }
            });
        }

        $('#save-page-btn').off('click').on('click', function() {
            saveCurrentPage();
        });

        // Intercept navigation: attempt to navigate to newPage via loadPage(newPage)
        var pendingPage = null;

        function handleNavigationRequest(newPage) {
            if (isDirty) {
                pendingPage = newPage;
                $('#unsavedChangesModal').modal('show');
            } else {
                loadPage(newPage);
            }
        }

        $('#next-page-btn').off('click').on('click', function() {
            if (currentPage < totalPages) {
                handleNavigationRequest(currentPage + 1);
            }
        });

        $('#prev-page-btn').off('click').on('click', function() {
            if (currentPage > 1) {
                handleNavigationRequest(currentPage - 1);
            }
        });

        // Modal buttons
        $('#save-continue-btn').off('click').on('click', function() {
            $('#unsavedChangesModal').modal('hide');
            saveCurrentPage(function() {
                if (pendingPage) {
                    loadPage(pendingPage);
                    pendingPage = null;
                }
            });
        });

        $('#discard-continue-btn').off('click').on('click', function() {
            $('#unsavedChangesModal').modal('hide');
            clearDirty();
            if (pendingPage) {
                loadPage(pendingPage);
                pendingPage = null;
            }
        });

        $('#save-all-btn').click(function() {
            saveEntireAssessment();
        });

        // show/hide add-question on initial load
        $(function() {
            if (currentPage === totalPages) $('#add-question-btn').show();
            else $('#add-question-btn').hide();
        });

        // bind add new question to the existing function
        $(document).on('click', '#add-question-btn', function() {
            // call existing addNewQuestion implementation
            if (typeof addNewQuestion === 'function') {
                addNewQuestion();
                // after adding a new question (which appends to DOM), ensure save behavior applies
            } else {
                toastr.error('Add question function not available');
            }
        });





        // $(document).ready(function() {
        //     // Initialize existing textareas with Summernote
        //     initializeSummernote();

        //     $('#add-question-btn').click(function() {
        //         addNewQuestion();
        //     });
        // });



        // function getOptionsFromBlock(questionBlock) {
        //     const options = [];
        //     $(questionBlock).find('.option-group').each(function() {
        //         options.push({
        //             id: $(this).find('.option-textarea').data('option-id'),
        //             text: $(this).find('.option-textarea').val(),
        //             isAnswer: $(this).find('input[type="radio"]').is(':checked')
        //         });
        //     });
        //     return options;
        // }

        // function updateQuestionIds(questionIds) {
        //     $('.question-block').each(function(index) {
        //         if (!$(this).data('question-id') && questionIds[index]) {
        //             $(this).attr('data-question-id', questionIds[index]);
        //         }
        //     });
        // }
    </script>



</body>

</html>
