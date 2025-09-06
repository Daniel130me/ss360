<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
// $school_id = $_SESSION['school_id'];
$school_settings = json_decode($_SESSION['skul_settings'], true);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Reports | <?= get_staff_fullname_by_id($_SESSION['userid'])?></title>

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
                        <li class="nav-item">
                            <a href="reports" class="nav-link active">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2">list</i>
                                    Reports
                                </p>
                            </a>
                        </li>
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
                <input type="hidden" id="report_student_page" value="report_card">

                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Manage Reports</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">Manage Reports</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container-fluid mt-4">
                    <div class="py-3 px-15 bg-white" style="border-radius: 10px;">

                        <div class="d-flex mb-3 align-items-center">
                            <div class="">
                                <p class="muted-text mr-1">Filter:</p>
                            </div>
                            <div>
                                <select class="select2 filter_Select border-0 form-control" id="select_class_field_report" onchange="get_stud_byClass_report()">
                                    <?php
                                    $select_classes = mysqli_query($conn, "SELECT id, classname FROM class WHERE school_id='$school_id'");
                                    while ($class_row = mysqli_fetch_array($select_classes)) {
                                    ?>
                                        <option value="<?= $class_row['id'] ?>"><?= $class_row['classname'] ?></option>
                                    <?php
                                    }
                                    ?>
                                </select>
                            </div>

                        </div>
                        <div class="container-fluid mt-4">
                            <div class="py-3 px-15 bg-white data_overlay" style="border-radius: 10px; position: absolute; left:0;">
                                <p class="font-weight-bold">No student in the class selected</p>
                            </div>
                        </div>
                        <table id="student_table_report" class="display nowrap" style="width:100%;">
                            <thead>

                                <tr>
                                    <th colspan="2" class="">
                                        <div style="display: flex; align-items: center;">
                                            <div class="icheck-primary mr-3">
                                                <input type="checkbox" id="select_all" onchange="check_uncheck_all()">
                                                <label for="select_all" class="text-primary px-2">Select all</label>
                                            </div>
                                            <!-- <p class="mr-3 text-danger font-weight-normal action_btn" style="display:none; margin: 0; cursor: pointer;" onclick="get_all_checked_checkbox('multiple',null,'delete_student_modal')">Delete Students</p> -->
                                            <p class="font-weight-normal action_btn" style="display:none; margin: 0; cursor: pointer;" onclick="get_all_checked_checkbox_for_report('multiple',null,'report_card_modal','bulk_report_ids')">Generate Report Card</p>
                                        </div>
                                    </th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                        <div class="d-none" id="pdf-content"></div>
                    </div>
                </div>
            </div>
            <!-- /.row -->
        </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->

    <div class="modal fade" id="report_card_modal">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body">
                    <div class="form-group">
                        <label for="select_term_report_field">Select Term</label>
                        <select class="form-control select2" name="term" id="select_term_field" style="width: 100%;" required>
                            <option value="1">1st Term</option>
                            <option value="2">2nd Term</option>
                            <option value="3">3rd Term</option>
                            <option value="cum">Cumm. Report</option>
                        </select>
                        <label for="select_class_transfer_field">Select Session</label>
                        <select class="form-control select2" id="select_session_field" style="width: 100%;" required>
                            <?php
                            $select = mysqli_query($conn, "SELECT id, session FROM sessions");
                            while ($row = mysqli_fetch_array($select)) {
                                if ($school_settings['session'] == $row['id']) {
                            ?>
                                    <option selected value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                <?php
                                } else {
                                ?>
                                    <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                            <?php }
                            }
                            ?>
                        </select>
                    </div>
                    <input type="hidden" name="ids" value="" class="bulk_report_ids">
                    <!-- <input type="hidden" name="class_id" value="" class="bulk_transfer_ids"> -->
                    <div class="card-foot">
                        <div class="alert myalert alert-dismissible" style="display: none;">
                            <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                            <p class="warning small text-danger"></p>
                        </div>
                        <p class="warning small text-danger" style="display: none;"></p>
                        <!-- <button type="button" id="student_transfer_btn" class="btn-sm btn-primary" onclick="download_report_card()">Preview Report</button> -->
                        <button type="button" id="student_transfer_btn" class="btn-sm btn-primary" onclick="preview_report_card_multiple('report_page','term')">Preview Report</button>
                        <button type="button" class="btn btn-grey" data-dismiss="modal" aria-label="Close">Close</button>
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
                        <p class="mt-2 small">Generating report cards...</p>
                        <p class="loading-status small">Loading report 0 of 0...</p>
                    </div>
                    <div id="preview-content"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" id="print-button" class="btn btn-primary" onclick="printReports()" disabled>
                        <i class="fas fa-print mr-1"></i> Print Reports
                    </button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
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
    <!-- <script>$('.select2').select2()</script> -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>

    <script>
        let loadedReports = 0;
        let totalReports = 0;
        let myschl = <?php echo $_SESSION['school_id']?>
    </script>

    <script src="../dist/js/skul.js?v=010"></script>

    
</body>

</html>