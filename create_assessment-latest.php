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
                            <a href="assessment" class="nav-link active">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">app_registration</i>
                                    Assessments
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
                                                <select class="form-control select2" class="select_subject_field" id="select_subject_field" onchange="" style="width: 100%;">

                                                </select>
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-9" id="select_assessment_single">
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
                                                        <input type="number" min='1' class="form-control" id="assessment_duration" value="<?= $assessment_data['duration'] ?>" placeholder="20">
                                                        <div class="input-group-prepend">
                                                            <select class="form-control" id="duration_unit">
                                                                <option value="1">Minutes</option>
                                                                <option value="2">Hours</option>
                                                            </select>
                                                        </div>
                                                        <div class="input-group-prepend icheck-gray-dark ml-2">
                                                            <input <?= $assessment_data['duration_set'] ? 'checked' : '' ?> class="class-checkbox" type="checkbox" id="set_duration_checkbox">
                                                            <label for="set_duration_checkbox">Set Duration</label>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <div class="form-group mb-0 col-12 col-sm-4">
                                                    <div class="input-group mb-3 d-flex align-items-center">
                                                        <label for="" class="mb-0">Deadline Date:</label>
                                                        <input type="date" class="form-control" id="deadline_date" value="<?= $assessment_data['deadline_date'] ?>">
                                                        <input type="time" class="form-control" id="deadline_time" value="<?= $assessment_data['deadline_time'] ?>">
                                                        <div class="input-group-prepend icheck-gray-dark ml-2">
                                                            <input <?= $assessment_data['deadline_Set'] ? 'checked' : '' ?> class="class-checkbox" type="checkbox" id="set_deadline_checkbox">
                                                            <label for="set_deadline_checkbox">Set Deadline</label>
                                                        </div>
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
                                                                <input type="radio" name="ca" id="practical" value="4" <?= $assessment_data['score_destination'] == '4' ? 'checked' : '' ?>>>
                                                                <label for="practical" class="mb-0">Practical</label>
                                                            </div>
                                                        <?php endif; ?>
                                                        <?php if ($school_settings['exa'] == 1): ?>
                                                            <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                                                <input type="radio" name="ca" id="exam" value="5" <?= $assessment_data['score_destination'] == '5' ? 'checked' : '' ?>>
                                                                <label for="exam" class="mb-0">Exam</label>
                                                            </div>
                                                        <?php endif; ?>
                                                        <!-- else check  radio button "none"  -->
                                                        <div class="input-group d-flex align-items-center icheck-gray-dark" style="width: auto;">
                                                            <input type="radio" name="ca" id="none" value="6" checked>
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
                                                        <button type="button" class="btn btn-danger btn-sm mt-2" onclick="deleteQuestion(<?= $qdata['question']['id'] ?>)">Delete Question</button>
                                                    </div>
                                                <?php endforeach; ?>
                                            </div>
                                            <button type="button" class="btn btn-primary mt-3" id="add-question-btn">Add New Question</button>
                                            <div class="d-flex justify-content-end mb-3">
                                                <button type="button" class="btn btn-primary" onclick="saveEntireAssessment()">Save Assessment</button>
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
            var existingAssessmentId = null;
            var classElementToRemove = null;
        </script>
        <script src="../dist/js/assessment_image_buffer.js"></script>
        <script src="../dist/js/examination.js"></script>
        <script>
            // Add event listeners for form changes
            $(document).ready(function() {
                // Hide assessment sections initially
                $('.assessment-settings-section, .questions-section').hide();

                // Check for existing assessment when required fields change
                $('#select_subject_field').change(checkExistingAssessment);
                $('.assessment_btn').click(checkExistingAssessment);

                // Check after saving selected classes
                const originalSaveSelectedClasses = saveSelectedClasses;
                saveSelectedClasses = function() {
                    originalSaveSelectedClasses();
                    checkExistingAssessment();
                };

                // addNewQuestion();
            });
        </script>

</body>

</html>