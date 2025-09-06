<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
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
    <title>Profile</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <style>
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

<body class="hold-transition sidebar-mini">
    <div class="wrapper">

        <!-- Navbar -->
        <nav class="main-header navbar border-bottom-0 navbar-expand justify-content-between bg1 ml-0 pt-3">
            <!-- <div class=""> -->
            <!-- <div> -->

            <!-- Left navbar links -->
            <!-- <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
                </li>
            </ul> -->
            <ul class="navbar-nav">
                <li class="nav-item">
                <a href="" class="brand-link py-1">
                <img src="../dist/img/company_logo.png" alt="" class="brand-image img-circle elevation-3" style="opacity: .8">
                <span class="brand-text font-weight-light">Skulz</span>
            </a>
                </li>
            </ul>

            <!-- Right navbar links -->
            <ul class="navbar-nav align-items-center">
                <li class="nav-item dropdown">
                    <a class="" data-toggle="dropdown" href="#" style="height: auto;">
                        <div class="user-panel d-flex align-items-center">
                            <!-- Menu icon for small screens -->
                            <span class="material-symbols-outlined">arrow_drop_down</span>
                            <span class="material-symbols-outlined d-inline-block d-sm-none">segment</span>
                            
                            <!-- User panel for larger screens -->
                            <div class="d-none d-sm-flex align-items-center">
                                <!-- <span class="material-symbols-outlined">arrow_drop_down</span> -->
                                <div class="info">
                                    <p style="font-size: 14px;" class="mb-0 d-block">
                                        <?= $_SESSION['lastname'] . ' ' . $_SESSION['firstname'] ?></p>
                                    <p style="font-size: 12px;" class="d-block mb-0 accent">
                                        <?= $_SESSION['email'] ?>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </a>
                    <div class="dropdown-menu dropdown-menu-sm dropdown-menu-right p-2" style="border-radius: 10px;">
                        <a href="parent_profile" class="dropdown-item text-muted d-flex">
                            <i class="material-symbols-outlined mr-2 d-inline">person</i> Profile
                        </a>
                        <a href="change_password_parent" class="dropdown-item text-muted d-flex">
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
     

        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper ml-0" style="background-color: #f4f7fa; padding-bottom: 100px;">

        <div class="container-fluid mb-3">
                <div class="row m-0">
                    <div class="col-sm-6 row ml-0">
                        <div class="mr-2">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <a href="parent_portal" class="accent">Back</a>
                                <!-- <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i></a> -->
                            </div>
                        </div>
                        <div class="">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="">
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="parent_portal" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">Home</i>
                                            </a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">Profile</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Main content -->
            <div class="content">
                <input type="hidden" id="profile_page" value="display_parent_profile">

                <!-- <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Profile</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">Profile</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div> -->
                <div class="container-fluid">
                    <div class="py-3 px-15 bg-white" id="profile_placeholder" style="border-radius: 10px;">

                    </div>
                </div>
            </div>
            <!-- /.row -->
        </div><!-- /.container-fluid -->
    </div>
    <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->
    <div class="modal fade" id="edit_parent_modal">
        <div class="modal-dialog modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title">Update Parent Data</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">×</span>
                    </button>
                </div>
                <div class="modal-body pb-0" id="edit_parent_modal_body">

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
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <script src="../dist/js/skul.js?v=21r"></script>
</body>
<script>

</script>

</html>