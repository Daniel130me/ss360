<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];

$select = mysqli_query($conn, "SELECT s.*,p.address,p.phone as pphone,p.email as pemail, p.state, p.city,p.country FROM students s, parent p WHERE p.id=s.parent_id AND s.id='{$_GET['id']}'");
$stud_row = mysqli_fetch_array($select);
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Student Profile</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="dist/css/adminlte.css">
    <link rel="stylesheet" href="plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <!-- fullCalendar -->
    <link rel="stylesheet" href="plugins/fullcalendar/main.css">
    <style>
        .sticky {
            position: fixed;
            top: 0;
            width: 100%;
            box-shadow: 0 5px 54px 0 #9ea5b538;
            padding-top: 25px;
        }

        .static {
            position: static;
            top: 0;
            z-index: 100;
            background-color: white;
        }

        #tabhead {
            overflow: hidden;
            z-index: 1;
            padding-bottom: 10px;
            background: rgb(255 255 255 / 48%);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid #ededed;
        }
    </style>
</head>

<body class="hold-transition sidebar-mini">
    <div class="wrapper">
        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper ml-0" style="background-color: #f4f7fa">
            <div class="container-fluid py-2" id="tabhead">
                <div class="pl-2">
                    <div class="d-flex">
                        <div class="p-2" style="line-height:0;">
                            <!-- <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i> -->
                            <a href="./report" class="accent" style="line-height: 1;">Back</a>
                        </div>
                        <div class="p-2" style="border-radius: 10px; line-height:1;">
                            <p class="font-weight-bold">Student's Profile</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="content mt-3">
                <div class="container-fluid">
                    <div class="card">
                        <div class="card-header">
                            <ul class="nav nav-pills menu-scrollbar" id="pills-tab" role="tablist" style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
                                <li class="nav-item" role="presentation">
                                    <button class="pill-link link-primary active" id="pills-emp-info-tab" data-toggle="pill" data-target="#pills-emp-info" type="button" role="tab" aria-controls="pills-emp-info" aria-selected="true">Biodata</button>
                                </li>
                                <li class="nav-item" role="presentation">
                                    <button class="pill-link link-primary" onclick="getsingleSessionReport('<?=$stud_row['id']?>')" id="pills-attendance-history-tab" data-toggle="pill" data-target="#pills-attendance-history" type="button" role="tab" aria-controls="pills-attendance-history" aria-selected="false">Score Report</button>
                                </li>

                            </ul>

                            <!-- /.card-tools -->
                        </div>
                        <!-- /.card-header -->
                        <div class="card-body">
                            <div class="tab-content" id="pills-tabContent">
                                <div class="tab-pane fade show active" id="pills-emp-info" role="tabpanel" aria-labelledby="pills-emp-info-tab">
                                    <div class="d-flex">

                                        <div class="d-flex first-con flex-wrap">
                                            <div>
                                                <img src="uploads/<?= $stud_row['photo'] ?>" class="emp-basic-img img-circle" alt="User Image">
                                            </div>
                                            <div class="d-flex flex-column justify-content-center ml-3">
                                                <div>
                                                    <h4><?= $stud_row['firstname'] . ' ' . $stud_row['lastname'] ?></h4>
                                                </div>
                                                <div>
                                                    <p class="mb-0 small font-weight-bold muted-text">Email Address</p>
                                                    <p class="mb-0"><?= $stud_row['email'] ?></p>
                                                </div>
                                            </div>
                                            <div class="emp-basic ml-sm-5">
                                                <p class="mb-0 small font-weight-bold muted-text">Phone Number</p>
                                                <p class="mb-0"><?= $stud_row['phone'] ?></p>
                                            </div>

                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">Gender</p>
                                                <p class="mb-0"><?= $stud_row['gender'] ?></p>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <div>
                                            <h6 class="font-weight-bold mt-5 pb-2" style="border-bottom: 1px solid #dadada;">Parent Information</h6>
                                        </div>
                                        <div class="d-flex flex-wrap">
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">Phone Number</p>
                                                <p class="mb-0"><?= $stud_row['pphone'] ?></p>
                                            </div>
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">Email address</p>
                                                <p class="mb-0"><?= $stud_row['pemail'] ?></p>
                                            </div>
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">Address</p>
                                                <p class="mb-0"><?= $stud_row['address'] ?></p>
                                            </div>
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">State</p>
                                                <p class="mb-0"><?= $stud_row['state'] ?></p>
                                            </div>
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">City</p>
                                                <p class="mb-0"><?= $stud_row['city'] ?></p>
                                            </div>
                                            <div class="emp-basic">
                                                <p class="mb-0 small font-weight-bold muted-text">Country</p>
                                                <p class="mb-0"><?= $stud_row['country'] ?></p>
                                            </div>
                                        </div>
                                    </div>
                                    <!-- <div class="mt-4">
                                        <button onclick="edit_student_info('<= $stud_row['id'] ?>')" class="btn btn-sm btn-primary">Edit Information</button>
                                    </div> -->
                                </div>
                                <div class="tab-pane fade" id="pills-attendance-history" role="tabpanel" aria-labelledby="pills-attendance-history-tab">
                                    <div style="width: 100%; overflow: auto;">
                                        <input type="hidden" id="student_id_for_general_report" name="" value="<?= $_GET['id'] ?>">
                                        <div>

                                            <!-- <div class="form-group">
                                                <label for="">Select Session:</label>
                                                <select name="" id="termSessionValue" onchange="getTermReport()" class="select2 d-inline-block form-control" style="max-width: 125px;" id="">
                                                    <option value="1">2012/2013</option>
                                                    <option value="2">2013/2014</option>
                                                </select>
                                            </div>
                                            <div class="form-group">
                                                <label for="">Select Term:</label>
                                                <button type="button" onclick="toggleSelect(this,'select_term_report','1','<?= $_GET['id'] ?>')" data-termValue="1" class="select_term_report btn select_btn active">1st Term</button>
                                                <button type="button" onclick="toggleSelect(this,'select_term_report','2','<?= $_GET['id'] ?>')" data-termValue="2" class="select_term_report btn select_btn">2nd Term</button>
                                                <button type="button" onclick="toggleSelect(this,'select_term_report','3','<?= $_GET['id'] ?>')" data-termValue="3" class="select_term_report btn select_btn">3rd Term</button>
                                            </div> -->
                                        </div>
                                        <!-- <div class="mt-4">
                                            <div id="student_term_based_report"></div>
                                        </div> -->
                                        <div class="mt-4">
                                            <div class="row">
                                                <div class="form-group col-6 col-sm-3">
                                                    <label for="" class="mb-0">Select Subject:</label>
                                                    <select name="" id="termSubjectValue" onchange="getsingleSessionReport()" class="form-control" id="">
                                                        <?php
                                                        $select = mysqli_query($conn, "SELECT id, subject FROM subjects ORDER BY subject ASC");
                                                        while ($row = mysqli_fetch_array($select)) {
                                                        ?>
                                                            <option value="<?= $row['id'] ?>"><?= $row['subject'] ?></option>
                                                        <?php } ?>
                                                    </select>
                                                </div>
                                                <div class="form-group col-6 col-sm-3">
                                                    <label for="" class="mb-0">Select Session:</label>
                                                    <select name="" id="singleSessionValue" onchange="getsingleSessionReport()" class="form-control" id="">
                                                        <?php
                                                        $select = mysqli_query($conn, "SELECT id, session FROM sessions ORDER BY session ASC");
                                                        while ($row = mysqli_fetch_array($select)) {
                                                        ?>
                                                            <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                                        <?php } ?>
                                                    </select>
                                                </div>
                                            </div>
                                            <div class="mt-4">
                                                <div class="" id="overall_performance"></div>
                                                <div class="" id="score_chart"></div>
                                                <div class="row justify-content-between">
                                                    <div class="mt-3 col-12 col-sm-3" id="student_term1_report"></div>
                                                    <div class="mt-3 col-12 col-sm-3" id="student_term2_report"></div>
                                                    <div class="mt-3 col-12 col-sm-3" id="student_term3_report"></div>
                                                </div>
                                            </div>
                                            <!-- <div class="mt-4">
                                                <div class="form-group">
                                                    <label for="">Select Term:</label>
                                                    <button type="button" data-value="1" class="select_sessions_report btn select_btn active">1st Term</button>
                                                    <button type="button" data-value="2" class="select_sessions_report btn select_btn">2nd Term</button>
                                                    <button type="button" data-value="3" class="select_sessions_report btn select_btn">3rd Term</button>
                                                </div>
                                            </div> -->
                                        </div>
                                        <!-- /.card-body -->
                                    </div>
                                </div>
                            </div>


                        </div>
                        <!-- /.card-body -->
                    </div>

                </div><!-- /.container-fluid -->
            </div>
            <!-- /.content -->
        </div>
        <!-- /.content-wrapper -->

        <!-- Main Footer -->
        <footer class="main-footer">
        </footer>
    </div>
    <!-- ./wrapper -->
    <div class="modal fade" id="edit_student_modal">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Update Student Data</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body pb-0" id="edit_student_modal_body">
                </div>
            </div>
        </div>
    </div>
    <!-- REQUIRED SCRIPTS -->

    <!-- jQuery -->
    <script src="plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- AdminLTE App -->
    <script src="dist/js/adminlte.min.js"></script>
    <script src="plugins/chart.js/Chart.min.js"></script>
    <script src="plugins/select2/js/select2.full.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="plugins/moment/moment.min.js"></script>
    <script src="plugins/fullcalendar/main.js"></script>
    <script>
        var skul_settings = <?= $_SESSION['skul_settings'] ?>;
    </script>
    <script src="dist/js/skul.js"></script>
    <script>
        var tabhead = document.getElementById("tabhead");
        var pill = document.getElementById("pills-attendance-history-tab");
        var sticky = tabhead.offsetTop;
        var offset = pill.offsetTop

        window.onscroll = function() {
            scrollhandler()
        }

        function scrollhandler() {
            console.log(sticky, window.scrollY)
            // alert('ll')
            if (window.scrollY >= 1) {
                tabhead.classList.add("sticky")
                //   tabhead.classList.remove("static")
            } else if (window.scrollY == sticky) {
                console.log("lk")
                tabhead.classList.remove("sticky")
                //   tabhead.classList.add("static")
            }
            //   else {
            //     tabhead.classList.remove("sticky")
            //     tabhead.classList.add("static")
            //   }
        }
    </script>
    <!-- <script src="dist/js/pages/dashboard3.js"></script> -->



</body>

</html>