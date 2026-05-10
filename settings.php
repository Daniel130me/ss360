<?php
session_start();
if (!isset($_SESSION['userid'])) {
  header("Location: login");
  exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
$_SESSION['location'] = explode("/", $_SERVER['REQUEST_URI'])[2];
// exit;
?>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Settings</title>

  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet"
    href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <link rel="stylesheet"
    href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
  <!-- Font Awesome Icons -->
  <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
  <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="../dist/css/adminlte.css">
  <!-- iCheck for checkboxes and radio inputs -->
  <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
  <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
  <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
  <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
    integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
  <link rel="stylesheet" href="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.css" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/leaflet.locatecontrol/dist/L.Control.Locate.min.css" />


  <style>
    .sticky {
      position: fixed;
      top: 0;
      width: 100%;
      box-shadow: 0 5px 54px 0 #9ea5b538;
      padding-top: 25px;
    }

    #tabhead {
      overflow: hidden;
      z-index: 1;
      padding-bottom: 10px;
      background: rgb(255 255 255 / 48%);
      backdrop-filter: blur(12px);
      border-bottom: 1px solid #ededed;
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
      border: 1px solid #ddd;
      padding: 8px;
      text-align: left;
    }

    th {
      background-color: #f2f2f2;
    }

    .scrollable-container table {
      min-width: 600px;
      /* Adjust based on your content */
    }
  </style>
</head>

<body class="hold-transition sidebar-mini layout-fixed">

  <div class="wrapper">

    <!-- Navbar -->
    <nav class="main-header navbar border-bottom-0 navbar-expand justify-content-between bg1">
      <!-- <div class=""> -->

      <!-- Left navbar links -->
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="muted-text fas fa-bars"></i></a>
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
          <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">

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
                <a href="settings" class="nav-link active">
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
        <input type="hidden" id="settings_page" value="view_Settings">

        <div class="container-fluid">
          <div class="row">
            <div class="col-sm-12">
              <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                <div class="">
                  <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Settings</h2>
                  <ol class="breadcrumb p-0 bg-white mb-0">
                    <li class="breadcrumb-item font-14">
                      <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                        <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>Dashboard</a>
                    </li>
                    <li class="breadcrumb-item active font-14">School settings</li>
                  </ol>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>
      <div class="container-fluid mt-4">
        <div class="py-3 px-0 bg-white" style="border-radius: 10px;">
          <div id="tabhead">
            <ul class="nav nav-pills menu-scrollbar" id="pills-tab" role="tablist"
              style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
              <li class="nav-item px-15" role="presentation">
                <button class="pill-link link-primary active" id="pills-school-info-tab" data-toggle="pill"
                  data-target="#pills-school-info" type="button" role="tab" aria-controls="pills-school-info"
                  aria-selected="true">Update School Info</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="pill-link link-primary" id="pills-settings-tab" data-toggle="pill"
                  data-target="#pills-settings" type="button" role="tab" aria-controls="pills-settings"
                  aria-selected="false">Settings</button>
              </li>
              <li class="nav-item" role="presentation">
                <button class="pill-link link-primary" id="pills-report-card-tab" data-toggle="pill"
                  data-target="#pills-report-card" type="button" role="tab" aria-controls="pills-report-card"
                  aria-selected="false">Report Card Customization</button>
              </li>
              <li class="nav-item d-none" role="presentation">
                <button class="pill-link link-primary" id="pills-skills-tab" data-toggle="pill"
                  data-target="#pills-skills" type="button" role="tab" aria-controls="pills-skills"
                  aria-selected="false">Skills/Ratings Setup</button>
              </li>
            </ul>
          </div>
          <div class="tab-content px-15" id="pills-tabContent">
            <div class="tab-pane fade show active" id="pills-school-info" role="tabpanel"
              aria-labelledby="pills-school-info-tab">
              <div>
                <form id="school_info_placeholder_form" class="settingsform">
                </form>
              </div>
              <form action="../controller.php" class="mt-5 url_upadter">
                <p class="font-weight-bold">School Url</p>
                <div class="input-group">
                  <div class="input-group-prepend">
                    <span class="input-group-text">schoolsuite360.com/</span>
                  </div>
                  <input type="text" name="url" value="<?= $_SESSION['url'] ?>" class="form-control"
                    title="e.g ris, phs, sic" placeholder="preffered URL">
                  <input type="hidden" name="action" value="update_url">

                </div>
                <input type="submit" id="url_update_btn" class="btn btn-primary mt-2" title="click to submit url"
                  value="Update URL">
              </form>
            </div>
            <div class="tab-pane fade" id="pills-settings" role="tabpanel" aria-labelledby="pills-settings-tab">
              <form id="school_setting_placeholder_form" class="settingsform">
              </form>
            </div>
            <div class="tab-pane fade" id="pills-report-card" role="tabpanel" aria-labelledby="pills-report-card-tab">
              <div id="report_card_customization_placeholder">
              </div>
            </div>
            <div class="tab-pane fade" id="pills-skills" role="tabpanel" aria-labelledby="pills-skills-tab">
              <div id="skills_config_placeholder">
                  <?php include "display_skills_config_form.php"; ?>
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
  <!-- AdminLTE App -->
  <script src="../dist/js/adminlte.min.js"></script>
  <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
  <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
  <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
  <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
    integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
  <script src="https://unpkg.com/leaflet-control-geocoder/dist/Control.Geocoder.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/leaflet.locatecontrol/dist/L.Control.Locate.min.js"
    charset="utf-8"></script>
  <script src="../plugins/toastr/toastr.min.js"></script>
  <script src="../dist/js/skul.js"></script>
  <script>
    //  localStorage.setItem("settings", "first,second,third")
    window.onscroll = function () {
      scrollhandler()
    }
    var tabhead = document.getElementById("tabhead");
    var sticky = tabhead.offsetTop;

    function scrollhandler() {
      // alert('ll')
      if (window.scrollY >= sticky) {
        tabhead.classList.add("sticky")
      } else {
        tabhead.classList.remove("sticky")
      }
    }
  </script>
</body>

</html>
