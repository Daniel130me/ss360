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
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
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
    <script>
        window.schoolHiddenSkills = <?php echo json_encode($hidden_skills); ?>;
        window.schoolSkills = <?php echo json_encode($all_skills_keys); ?>;
    </script>
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

                <input type="hidden" id="comment_student_page" value="comment">

                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Manage Comments</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent"
                                                style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1"
                                                    style="font-size: 19px;">dashboard</i>Dashboard</a>
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
                        <input type="hidden" name="session" class="comment_Session"
                            value="<?= $_SESSION['session_id'] ?>">
                        <input type="hidden" name="session" class="comment_term" value="<?= $_SESSION['term_id'] ?>">


                        <p class="text-orange mb-3">Current Term: <span
                                class="term_name font-weight-bold"><?= $_SESSION['term_id'] == 1 ? '1st' : ($_SESSION['term_id'] == 2 ? '2nd' : '3rd') ?></span>
                        </p>

                        <div class="d-flex mb-3 align-items-center">

                            <div class="">
                                <p class="muted-text mr-1">Select Class:</p>
                            </div>
                            <div>
                                <select class="form-control filter_Select comment_class select2"
                                    onchange="get_stud_byClass_comment()" id="select_class_field" style="width: 100%;">
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
                            <div class="py-3 px-15 bg-white data_overlay"
                                style="border-radius: 10px; position: absolute; left:0;">
                                <p class="font-weight-bold">No student in the class selected</p>
                            </div>
                            <table id="student_table_comment" class="display nowrap" style="width:100%;">

                            </table>
                            <div class="" id="">
                                <button type="button" class="btn btn-primary" onclick="save_comment()">Save
                                    Comments</button>
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
    <div class="modal fade" id="suggestionModal" tabindex="-1" role="dialog" aria-labelledby="suggestionModalLabel"
        aria-hidden="true">
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
                                <input type="text" id="searchSuggestedComments" class="form-control"
                                    placeholder="Search comments...">
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
                                        <p class="small">To specify student name, type - <b>{name}</b>. Example: {name}
                                            is a good student</p>
                                        <textarea class="form-control" id="newSuggestion" rows="2"
                                            placeholder="Example: {name} is a good student"></textarea>
                                    </div>
                                    <div class="form-group mb-2">
                                        <label>Score Range:</label>
                                        <div class="d-flex align-items-center">
                                            <label class="mr-2 mb-0">From:</label>
                                            <input type="number" id="newSuggestionFrom" class="form-control mr-3"
                                                style="width: 80px;" min="0" max="100" value="0">
                                            <label class="mr-2 mb-0">To:</label>
                                            <input type="number" id="newSuggestionTo" class="form-control"
                                                style="width: 80px;" min="0" max="100" value="100">
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Submit Suggestion</button>
                                    <button type="button" class="btn btn-outline-secondary float-right"
                                        data-dismiss="modal">Close</button>
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
                                <?php
                                // Skills fetched at top of file
                                
                                ?>
                                <?php foreach ($behaviour_skills as $key => $label): ?>
                                    <?php if (!in_array($key, $hidden_skills)): ?>
                                        <tr>
                                            <td><?= $label ?></td>
                                            <?php for ($i = 5; $i >= 1; $i--): ?>
                                                <td><input type="button" class="btn togglebtn <?= $key ?>" name="<?= $key ?>"
                                                        value="<?= $i ?>"></td>
                                            <?php endfor; ?>
                                        </tr>
                                    <?php endif; ?>
                                <?php endforeach; ?>
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
                                    <?php foreach ($psychomotive_skills as $key => $label): ?>
                                        <?php if (!in_array($key, $hidden_skills)): ?>
                                            <tr>
                                                <td><?= $label ?></td>
                                                <?php for ($i = 5; $i >= 1; $i--): ?>
                                                    <td><input type="button" class="btn togglebtn <?= $key ?>" name="<?= $key ?>"
                                                            value="<?= $i ?>"></td>
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
                success: function (res) {
                    if (res.success) {
                        suggestionTotal = res.total;
                        renderSuggestedComments(res.data, suggestionStudentName);
                        renderSuggestionPagination();
                    } else {
                        $('#suggestedCommentsContainer').html('<div class="col-12 text-danger">Failed to load suggestions.</div>');
                    }
                },
                error: function () {
                    $('#suggestedCommentsContainer').html('<div class="col-12 text-danger">Failed to load suggestions.</div>');
                }
            });
        }

        // Render suggestions
        function renderSuggestedComments(data, studentName) {
            var html = `<div class="row m-0 p-2">`;
            if (data && data.length > 0) {
                data.forEach(function (item) {
                    var commentText = item.comment.replace(/\{name\}/gi, studentName ? studentName : '{name}');
                    var scoreFrom = item.score_from || 0;
                    var scoreTo = item.score_to || 100;
                    var commentByName = item.commentby_name || 'Unknown';
                    html += `
                    <div class="card p-2 m-1 col-12">
                    <div class="card-body p-0">
                        <p class="comment-text">${commentText}</p>
                        <div class="mb-2">
                            <small class="text-muted">
                                <strong>Score range:</strong> ${scoreFrom} - ${scoreTo} | 
                                <strong>By:</strong> ${commentByName}
                            </small>
                        </div>
                        <div>
                            <button class="btn btn-sm edit-suggested-comment mr-1" data-id="${item.id}" data-comment="${encodeURIComponent(item.comment)}" data-from="${scoreFrom}" data-to="${scoreTo}"><i class="fa fa-edit mr-2"></i>Edit</button>
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
        $(document).on('click', '.suggestion-page-link', function (e) {
            e.preventDefault();
            var page = parseInt($(this).data('page'));
            if (!isNaN(page) && page !== suggestionPage) {
                loadSuggestedComments(page, suggestionSearch);
            }
        });

        // Search input event
        $(document).on('input', '#searchSuggestedComments', function () {
            var search = $(this).val() || '';
            loadSuggestedComments(1, search);
        });

        // Track which role to fill (teacher or principal) when opening the modal
        // Use data attributes on the modal for reliability
        $(document).on('click', '.open-suggestion-modal', function () {
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
        $(document).on('show.bs.modal', '#suggestionModal', function () {
            // Add search input if not present
            if ($('#searchSuggestedComments').length === 0) {
                var searchHtml = '<div class="row mb-2"><div class="col-12"><input type="text" id="searchSuggestedComments" class="form-control" placeholder="Search suggested comments..."></div></div>';
                $(this).find('.container-fluid.pt-3').prepend(searchHtml);
            }
            loadSuggestedComments(1, '');
        });

        // Handle use suggestion button click
        $(document).on('click', '.use-suggested-comment', function () {
            var rawComment = decodeURIComponent($(this).data('raw'));
            var modal = $('#suggestionModal');
            var studentName = modal.data('studentName') || '';
            var studentId = modal.data('studentId') || '';
            var commentRole = modal.data('commentRole') || '';
            // Replace {name} with the current student's name
            var commentText = rawComment.replace(/\{name\}/gi, studentName ? studentName : '{name}');
            // Find the correct textarea for the student and role
            var row = $("#student_table_comment tr").filter(function () {
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
        $(document).on('submit', '#newSuggestionForm', function (e) {
            e.preventDefault();
            var comment = $('#newSuggestion').val().trim();
            var scoreFrom = parseInt($('#newSuggestionFrom').val()) || 0;
            var scoreTo = parseInt($('#newSuggestionTo').val()) || 100;
            if (!comment) return;
            $.ajax({
                url: '../comments_controller.php',
                method: 'POST',
                data: {
                    action: 'add',
                    comment: comment,
                    score_from: scoreFrom,
                    score_to: scoreTo
                },
                dataType: 'json',
                success: function (res) {
                    if (res.success) {
                        $('#newSuggestion').val('');
                        $('#newSuggestionFrom').val('0');
                        $('#newSuggestionTo').val('100');
                        loadSuggestedComments();
                    } else {
                        alert(res.message || 'Failed to add comment');
                    }
                },
                error: function () {
                    alert('Failed to add comment');
                }
            });
        });

        // Handle edit button click for suggested comment
        $(document).on('click', '.edit-suggested-comment', function () {
            var card = $(this).closest('.card');
            var commentId = $(this).data('id');
            var encodedComment = $(this).data('comment');
            var scoreFrom = $(this).data('from') || 0;
            var scoreTo = $(this).data('to') || 100;
            // Always restore {name} for editing
            var commentRaw = decodeURIComponent(encodedComment);
            // Replace the comment text with a textarea and save button
            var editHtml = `
        <textarea class="form-control edit-suggestion-textarea" rows="3">${commentRaw}</textarea>
        <div class="mt-2">
            <label class="mr-2">From:</label>
            <input type="number" class="edit-score-from" style="width: 80px;" min="0" max="100" value="${scoreFrom}">
            <label class="ml-3 mr-2">To:</label>
            <input type="number" class="edit-score-to" style="width: 80px;" min="0" max="100" value="${scoreTo}">
        </div>
        <button class="btn btn-sm btn-success mt-2 save-suggested-comment" data-id="${commentId}">Save</button>
        <button class="btn btn-sm btn-secondary mt-2 cancel-edit-suggested-comment">Cancel</button>
    `;
            card.find('.card-body').html(editHtml);
        });

        // Handle cancel edit
        $(document).on('click', '.cancel-edit-suggested-comment', function () {
            // Reload the suggestions to restore the original view
            loadSuggestedComments();
        });

        // Handle save button click for suggested comment
        $(document).on('click', '.save-suggested-comment', function () {
            var card = $(this).closest('.card');
            var commentId = $(this).data('id');
            var newComment = card.find('.edit-suggestion-textarea').val().trim();
            var scoreFrom = parseInt(card.find('.edit-score-from').val()) || 0;
            var scoreTo = parseInt(card.find('.edit-score-to').val()) || 100;
            if (!newComment) return;
            // Save via AJAX
            $.ajax({
                url: '../comments_controller.php',
                method: 'POST',
                data: {
                    action: 'edit',
                    id: commentId,
                    comment: newComment,
                    score_from: scoreFrom,
                    score_to: scoreTo
                },
                dataType: 'json',
                success: function (res) {
                    if (res.success) {
                        loadSuggestedComments();
                    } else {
                        alert(res.message || 'Failed to update comment');
                    }
                },
                error: function () {
                    alert('Failed to update comment');
                }
            });
        });
        // Handle delete button click for suggested comment (inline confirm UI)
        $(document).on('click', '.delete-suggested-comment', function () {
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
        $(document).on('click', '.cancel-delete-suggested-comment', function () {
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
        $(document).on('click', '.confirm-delete-suggested-comment', function () {
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
                success: function (res) {
                    if (res.success) {
                        loadSuggestedComments();
                    } else {
                        cardBody.html('<div class="text-danger">' + (res.message || 'Failed to delete comment') + '</div>');
                        setTimeout(loadSuggestedComments, 1500);
                    }
                },
                error: function () {
                    cardBody.html('<div class="text-danger">Failed to delete comment</div>');
                    setTimeout(loadSuggestedComments, 1500);
                }
            });
        });
    </script>



    <script>
        // Auto-comment generation function
        function generateAutoComment(button) {
            var $btn = $(button);
            var studentId = $btn.data("student-id");
            var classId = $btn.data("class-id");
            var commentType = $btn.data("comment-type");
            var sessionId = $(".comment_Session").val();
            var termId = $(".comment_term").val();

            // Validate required fields
            if (!sessionId || !termId) {
                showNotification("Please select session and term first", "error");
                return;
            }

            // Check if we already have comments cached for this student
            var commentPool = $btn.data('comment-pool');
            var currentIndex = $btn.data('current-index');

            if (commentPool && commentPool.length > 0) {
                // We have cached comments - cycle through them
                var comment = commentPool[currentIndex];

                // Find the appropriate textarea
                var $textarea;
                if (commentType === "teacher") {
                    $textarea = $btn.closest("td").find(".teacher_comment_comment");
                } else {
                    $textarea = $btn.closest("td").find(".principal_comment_comment");
                }

                // Personalize and set comment
                var firstName = $btn.data('student-firstname');
                var personalizedComment = comment.comment.replace(/{name}/g, firstName);
                $textarea.val(personalizedComment);

                // Update index for next click (with loop using modulo)
                var nextIndex = (currentIndex + 1) % commentPool.length;
                $btn.data('current-index', nextIndex);

                // Show which comment in cycle
                var position = currentIndex + 1;
                var total = commentPool.length;
                var percentage = $btn.data('percentage');

                if (total > 1) {
                    showNotification("Comment " + position + " of " + total + " (" + percentage + "%)", "success");
                } else {
                    showNotification("Auto-comment generated (" + percentage + "%)", "success");
                }

                return; // Don't make AJAX call
            }

            // No cached comments - make AJAX request (first click)
            var originalHtml = $btn.html();
            $btn.prop("disabled", true).html('<i class="fa fa-spinner fa-spin"></i> Loading...');

            $.ajax({
                url: "../controller.php",
                type: "POST",
                dataType: "json",
                data: {
                    action: "get_auto_comment",
                    student_id: studentId,
                    class_id: classId,
                    session_id: sessionId,
                    term_id: termId
                },
                success: function (response) {
                    if (response.status === "1" && response.comments && response.comments.length > 0) {
                        // Store all comments in button's data
                        $btn.data('comment-pool', response.comments);
                        $btn.data('current-index', 0);
                        $btn.data('percentage', response.percentage);
                        $btn.data('student-firstname', response.student_firstname);

                        // Display first comment
                        var firstComment = response.comments[0];
                        var personalizedComment = firstComment.comment.replace(/{name}/g, response.student_firstname);

                        var $textarea;
                        if (commentType === "teacher") {
                            $textarea = $btn.closest("td").find(".teacher_comment_comment");
                        } else {
                            $textarea = $btn.closest("td").find(".principal_comment_comment");
                        }

                        $textarea.val(personalizedComment);

                        // Set index to 1 for next click
                        $btn.data('current-index', 1);

                        // Show notification
                        var total = response.comments.length;
                        var message;
                        if (total > 1) {
                            message = "Comment 1 of " + total + " (" + response.percentage + "%) - Click again for more";
                        } else {
                            message = "Auto-comment generated (" + response.percentage + "%)";
                        }
                        showNotification(message, "success");
                    } else {
                        showNotification(response.error || "No comments found", "error");
                    }
                },
                error: function () {
                    showNotification("Error connecting to server", "error");
                },
                complete: function () {
                    // Re-enable button
                    $btn.prop("disabled", false).html(originalHtml);
                }
            });
        }

        function showNotification(message, type) {
            // Simple toast notification
            var bgClass = type === "success" ? "bg-success" : "bg-danger";
            var toast = $(
                '<div class="toast-notification ' +
                bgClass +
                ' text-white p-3 rounded position-fixed" style="top: 80px; right: 20px; z-index: 9999; min-width: 250px;">' +
                message +
                "</div>"
            );
            $("body").append(toast);
            setTimeout(function () {
                toast.fadeOut(function () {
                    $(this).remove();
                });
            }, 4000);
        }

        /**
         * Fetches and displays a student's total score as a percentage.
         * Hides the trigger button once the score is shown.
         *
         * @param {string} studentId  - The student's database ID
         * @param {string} classId    - The class ID
         * @param {string} sessionId  - The session ID
         * @param {string} termId     - The term ID
         * @param {HTMLElement} button - The clicked button element (used for DOM scoping)
         */
        function show_student_percent_score(studentId, classId, sessionId, termId, button) {
            var $btn = $(button);

            // Disable button and show loading state
            $btn.prop('disabled', true).text('Loading...');

            $.ajax({
                url: '../controller.php',
                type: 'POST',
                dataType: 'json',
                data: {
                    action: 'get_student_percent_score',
                    student_id: studentId,
                    class_id: classId,
                    session_id: sessionId,
                    term_id: termId
                },
                success: function (response) {
                    if (response.status == '1') {
                        // Use siblings() for direct sibling lookup — avoids DataTable DOM issues
                        var $scoreDisplay = $btn.siblings('.student_score_display');

                        $scoreDisplay.find('.student_total_score_in_percentage').text(response.percentage);
                        $scoreDisplay.css('display', 'inline'); // Explicitly set display for inline <i> element
                        $btn.hide();
                    } else {
                        showNotification("Could not retrieve score", "error");
                        $btn.prop('disabled', false).text('Show score');
                    }
                },
                error: function (xhr, status, error) {
                    console.log('Score fetch error:', status, error, xhr.responseText);
                    showNotification("Error connecting to server", "error");
                    $btn.prop('disabled', false).text('Show score');
                }
            });
        }
    </script>

</body>

</html>