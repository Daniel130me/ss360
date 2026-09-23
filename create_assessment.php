<?php
if (session_status() !== PHP_SESSION_ACTIVE) {
    session_start();
}
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
include_once("model/assessment_editor.php");
$school_id = $_SESSION['school_id'];
try {
    assessment_editor_require_staff();
} catch (Throwable $error) {
    http_response_code(403);
    exit('You are not authorized to manage assessments.');
}
$_SESSION['location'] = explode("/", $_SERVER['REQUEST_URI'])[3];
$school_settings = json_decode($_SESSION['skul_settings'], true);
// var_dump($school_settings);
$assessment_id = isset($_GET['id']) ? (int)$_GET['id'] : null;
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

if ($assessment_id) {
    $stmt = $conn->prepare(
        'SELECT a.*, s.subject AS subject_name
         FROM assessment a
         LEFT JOIN subjects s ON s.id = a.subject_id
         WHERE a.id = ? AND a.school_id = ? LIMIT 1'
    );
    $stmt->bind_param('ii', $assessment_id, $school_id);
    $stmt->execute();
    $assessment_data = $stmt->get_result()->fetch_assoc();
    $stmt->close();
    if (!$assessment_data) {
        http_response_code(404);
        exit('Assessment not found.');
    }
}
$questions_data = [];
if ($assessment_id) {
    $stmt = $conn->prepare('SELECT * FROM questions WHERE ass_id = ? AND deleted = 0 ORDER BY id');
    $stmt->bind_param('i', $assessment_id);
    $stmt->execute();
    $q_res = $stmt->get_result();
    $questionsById = [];
    while ($q_row = mysqli_fetch_assoc($q_res)) {
        $questionsById[(int)$q_row['id']] = [
            'question' => $q_row,
            'options' => [],
        ];
    }
    $stmt->close();

    if ($questionsById) {
        $questionIds = implode(',', array_keys($questionsById));
        $optionsResult = $conn->query(
            "SELECT * FROM options WHERE deleted = 0 AND question_id IN ({$questionIds}) ORDER BY id"
        );
        while ($option = $optionsResult->fetch_assoc()) {
            $questionsById[(int)$option['question_id']]['options'][] = $option;
        }
    }
    $questions_data = array_values($questionsById);
}
$assessment_save_token = bin2hex(random_bytes(16));
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
    <link rel="stylesheet" href="../plugins/summernote/summernote-bs4.min.css">
    <!-- <link rel="stylesheet" href="../plugins/select2/css/select2.min.css"> -->
    <!-- daterange picker -->
    <link rel="stylesheet" href="../plugins/daterangepicker/daterangepicker.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.9.3/dropzone.min.css">
    <style>
        .accent_active {
            background-color: #007bff;
            color: white;
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
                        <!-- <li class="nav-item">
                            <a href="question_bank" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">library_books</i>
                                    Question Bank
                                </p>
                            </a>
                        </li> -->
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



        <div class="content-wrapper" style="background-color: #f4f7fa; padding-bottom: 100px;">
            <div class="content">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="mb-3">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Create Assessment</h2>
                                    <div class="row mt-4">
                                        <div class="col-12 col-md-3" id="select_subject_single">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Subject</label>
                                                <select class="form-control select2" id="select_subject_field" style="width: 100%;">
                                                    <?php if (!empty($assessment_data['subject_id'])): ?>
                                                        <option value="<?= (int)$assessment_data['subject_id'] ?>" selected>
                                                            <?= htmlspecialchars((string)($assessment_data['subject_name'] ?? 'Selected subject')) ?>
                                                        </option>
                                                    <?php endif; ?>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-3" id="select_term_single">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Term</label>
                                                <div class="assessment_term_btn d-flex flex-wrap" style="gap:10px;">
                                                    <button type="button" class="btn term_btn select_btn <?= $assessment_data['term'] == 1 ? 'active' : '' ?>" data-id="1" onclick="toggle_term_btn(this)">First</button>
                                                    <button type="button" class="btn term_btn select_btn <?= $assessment_data['term'] == 2 ? 'active' : '' ?>" data-id="2" onclick="toggle_term_btn(this)">Second</button>
                                                    <button type="button" class="btn term_btn select_btn <?= $assessment_data['term'] == 3 ? 'active' : '' ?>" data-id="3" onclick="toggle_term_btn(this)">Third</button>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-6" id="select_assessment_single">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Assessment</label>
                                                <div class="assessment_type_btn d-flex flex-wrap" style="gap:15px;">
                                                    <button type="button" class="btn assessment_btn select_btn <?= $assessment_data['assessment_type'] == 1 ? 'active' : '' ?>" data-id="1" onclick="toggle_assessment_btn(this)">Assignment</button>
                                                    <button type="button" class="btn assessment_btn select_btn <?= $assessment_data['assessment_type'] == 2 ? 'active' : '' ?>" data-id="2" onclick="toggle_assessment_btn(this)">CA</button>
                                                    <button type="button" class="btn assessment_btn select_btn <?= $assessment_data['assessment_type'] == 3 ? 'active' : '' ?>" data-id="3" onclick="toggle_assessment_btn(this)">Exam</button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <div class="col-12">
                                            <div class="form-group align-left">
                                                <p class="mb-0 btn accent" onclick="get_all_classes_for_assessment('new')">+ Assign Classes</p>
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
                                    <div class="container-fluid mt-4 px-0">
                                        <div class="py-3 px-15 bg-white assessment-settings-section" style="border-radius: 10px;">


                                            <div class="form-group col-12 ml-0 p-0">
                                                <p class="p-0 mb-0 muted-text">Instruction/Description</p>
                                                <p class="p-0 mb-0 small">What do you want the student to know before starting the assessment</p>
                                                <textarea name="description" class="form-control" id="assessment_instruction" cols="4" rows="2"><?= htmlspecialchars($assessment_data['instruction']) ?></textarea>
                                            </div>
                                            <div class="row">
                                                <div class="form-group mb-0 col-12 col-sm-4">
                                                    <div class="input-group mb-3 d-flex align-items-center">
                                                        <label for="" class="mb-0">Duration:</label>
                                                        <input required type="number" min='1' class="form-control" id="assessment_duration" value="<?= $assessment_data['duration'] ?>" placeholder="20">
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
                                                        <!--    <input <?= $assessment_data['deadline_set'] ? 'checked' : '' ?> class="class-checkbox" type="checkbox" id="set_deadline_checkbox">-->
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
                                                        <?php if (($school_settings['ca1'] ?? 0) == 1): ?>
                                                            <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                                                <input type="radio" name="ca" id="ca_1" value="1" <?= $assessment_data['score_destination'] == '1' ? 'checked' : '' ?>>
                                                                <label for="ca_1" class="mb-0">CA1</label>
                                                            </div>
                                                        <?php endif; ?>
                                                        <?php if (($school_settings['ca2'] ?? 0) == 1): ?>
                                                            <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                                                <input type="radio" name="ca" id="ca_2" value="2" <?= $assessment_data['score_destination'] == '2' ? 'checked' : '' ?>>
                                                                <label for="ca_2" class="mb-0">CA2</label>
                                                            </div>
                                                        <?php endif; ?>
                                                        <?php if (($school_settings['ca3'] ?? 0) == 1): ?>
                                                            <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                                                <input type="radio" name="ca" id="ca_3" value="3" <?= $assessment_data['score_destination'] == '3' ? 'checked' : '' ?>>
                                                                <label for="ca_3" class="mb-0">CA3</label>
                                                            </div>
                                                        <?php endif; ?>
                                                        <?php if (($school_settings['practical'] ?? 0) == 1): ?>
                                                            <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                                                <input type="radio" name="ca" id="practical" value="4" <?= $assessment_data['score_destination'] == '4' ? 'checked' : '' ?>>
                                                                <label for="practical" class="mb-0">Practical</label>
                                                            </div>
                                                        <?php endif; ?>
                                                        <?php if (($school_settings['exa'] ?? 0) == 1): ?>
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
                                        <div class="container-fluid mt-4 px-0">

                                            <!-- <php if (!$has_questions): ?>
                                            <div class="alert alert-info">
                                                No questions available for this assessment yet. Add your first question below.
                                            </div>
                                        <php endif; ?> -->

                                            <div id="questions-container" class="questions-section">
                                                <?php foreach ($questions_data as $index => $qdata): ?>
                                                    <div class="py-3 px-15 bg-white mb-3 question-block" style="border-radius: 10px;" data-question-id="<?= $qdata['question']['id'] ?>">
                                                        <div class="form-group">
                                                            <label>Question <?= $index + 1 ?></label>
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
                                                        <!-- <button type="button" class="btn btn-success btn-sm mt-2 mr-2" onclick="saveQuestion(this.closest('.question-block'))">Save Question</button> -->
                                                        <button type="button" class="btn btn-danger btn-sm mt-2" onclick="removeAssessmentQuestion(this)">Delete Question</button>
                                                        <button type="button" class="btn btn-outline-success btn-sm mt-2 ml-2 regenerate-question-btn" onclick="openRegenerateQuestionModal(this)">Regenerate with AI</button>
                                                    </div>
                                                <?php endforeach; ?>
                                            </div>
                                            <div class="d-flex mt-3 mb-3" style="gap:10px;">
                                                <button type="button" class="btn btn-primary" id="add-question-btn">Add New Question</button>
                                                <button type="button" class="btn btn-info" onclick="openImportQuestionModal()">Import Question</button>
                                                <button type="button" class="btn btn-success" onclick="openAIGeneratorModal()">Generate Question with AI</button>
                                            </div>
                                            <div class="d-flex justify-content-end mb-3">
                                                <button type="button" class="btn btn-primary" onclick="saveEntireAssessment_for_create_assessment()">Save Assessment</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
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

        <!-- Add modal for selecting classes -->
        <div class="modal fade" id="assess_classesModal" tabindex="-1" role="dialog" aria-labelledby="assess_classesModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="assess_classesModalLabel">Select Classes</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div id="classes-list">
                            <!-- Classes will be loaded here dynamically -->
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" onclick="saveSelectedClasses()">Save</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add remove class confirmation modal -->
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
                                <div class="col-md-6">
                                    <div class="form-group border bg-white p-2 rounded" id="import_exam_body_container" style="display:none;">
                                        <label>Exam Body</label>
                                        <select class="form-control" id="import_exam_body"></select>
                                    </div>
                                    <div class="form-group border bg-white p-2 rounded" id="import_exam_year_container" style="display:none;">
                                        <label>Exam Year</label>
                                        <select class="form-control" id="import_exam_year">
                                            <option value="">All Years</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
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
                                    <input type="number" min="0" max="50" value="0" class="form-control" id="build_easy_count">
                                </div>
                                <div class="col-md-4">
                                    <label>Medium</label>
                                    <input type="number" min="0" max="50" value="0" class="form-control" id="build_medium_count">
                                </div>
                                <div class="col-md-4">
                                    <label>Hard</label>
                                    <input type="number" min="0" max="50" value="0" class="form-control" id="build_hard_count">
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

        <!-- AI Regenerate Single Question Modal -->
        <div class="modal fade" id="aiRegenerateQuestionModal" tabindex="-1" role="dialog" aria-labelledby="aiRegenerateQuestionModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl" role="document">
                <div class="modal-content">
                    <div class="modal-header bg-success text-white">
                        <h5 class="modal-title" id="aiRegenerateQuestionModalLabel">Regenerate Question with AI</h5>
                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body bg-light">
                        <div class="form-group border bg-white p-2 rounded">
                            <label>Rewrite Context</label>
                            <textarea class="form-control ai-summernote" id="ai_regenerate_context" rows="6" placeholder="Describe how you want this question rewritten."></textarea>
                        </div>
                        <div class="form-group border bg-white p-2 rounded">
                            <label>Level of Difficulty</label>
                            <select class="form-control" id="ai_regenerate_difficulty">
                                <option value="Easy">Easy</option>
                                <option value="Medium" selected>Medium</option>
                                <option value="Hard">Hard</option>
                            </select>
                        </div>
                        <div id="ai-regenerate-loading-indicator" style="display:none; text-align:center; padding:10px;">
                            <div class="spinner-border text-success" role="status">
                                <span class="sr-only">Loading...</span>
                            </div>
                            <p class="mt-2 mb-0">Regenerating this question with AI...</p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-success" id="ai-regenerate-btn" onclick="regenerateCurrentQuestionWithAI()">Regenerate</button>
                    </div>
                </div>
            </div>
        </div>
        </div>

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
        <!-- <script>$('.select2').select2()</script> -->
        <script src="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.9.3/dropzone.min.js"></script>
        <!-- Summernote -->
        <script src="../plugins/summernote/summernote-bs4.min.js"></script>
        <script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
        <!-- <script src="https://cdn.jsdelivr.net/npm/@wiris/mathtype-ckeditor5@7.30.0/plugin.min.js"></script> -->
        <script>

        </script>

        <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>
        <!-- Summernote -->
        <script src="../plugins/summernote/summernote-bs4.min.js"></script>
        <script src="../dist/js/skul.js"></script>
        <!-- date-range-picker -->
        <script src="../plugins/moment/moment.min.js"></script>
        <script src="../plugins/daterangepicker/daterangepicker.js"></script>

        <script>
            var existingAssessmentId = <?= json_encode($assessment_id) ?>;
            var assessmentSaveToken = <?= json_encode($assessment_save_token) ?>;
            var classElementToRemove = null;
        </script>
        <script src="../dist/js/assessment_image_buffer.js"></script>
        <script src="../dist/js/examination.js?v=20260915-question-delete"></script>
        <script src="../dist/js/import_question.js?v=001"></script>
        <script src="https://unpkg.com/turndown/dist/turndown.js"></script>
        <script src="../dist/js/ai_question_generator.js?v=001"></script>
        <script>
            // Add event listeners for form changes
            $(document).ready(function() {
                // Existing assessments are immediately editable; new ones wait for required selections.
                $('.assessment-settings-section, .questions-section').toggle(Number(existingAssessmentId) > 0);

                // Check for existing assessment when required fields change
                $('#select_subject_field').change(checkExistingAssessment);
                $('.assessment_btn').click(checkExistingAssessment);

                // Check after saving selected classes
                const originalSaveSelectedClasses = saveSelectedClasses;
                saveSelectedClasses = function() {
                    originalSaveSelectedClasses();
                    checkExistingAssessment();
                };
                $('#add-question-btn').click(function() {
                    addNewQuestion();
                });
                // addNewQuestion();
            });
        </script>

</body>

</html>
