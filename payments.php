<?php
session_start();
// if($_SESSION['manage_payment'] == 0) {
// 
?>
<!-- // <script>
    history.back()
</script> -->
// <?php
    // }
    if (!isset($_SESSION['userid'])) {
        header("Location: login");
        exit();
    }
    include_once("model/connect.php");
    include_once("model/functions.php");
    $school_id = $_SESSION['school_id'];
    $_SESSION['location'] = explode("/", $_SERVER['REQUEST_URI'])[2];

    $school_settings = json_decode($_SESSION['skul_settings'], true);
    ?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Payments</title>

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

        .receipt-watermark-container {
            position: relative;
        }

        .receipt-watermark-logo {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            opacity: 0.08;
            z-index: 0;
            pointer-events: none;
            width: 70%;
            max-width: 500px;
            min-width: 200px;
            min-height: 200px;
            user-select: none;
        }

        @media print {
            .receipt-watermark-logo {
                opacity: 0.12 !important;
                filter: grayscale(100%) !important;
                position: absolute !important;
                /* display: none !important; */
                transform: translate(-50%, -50%) !important;
            }
        }

        #paymentRecordModal .modal-dialog {
            max-width: 960px;
        }

        .payment-record-modal-content {
            border: 0;
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 24px 60px rgba(15, 23, 42, 0.18);
        }

        .payment-record-modal-header {
            border-bottom: 0;
            padding: 1.25rem 1.5rem 1rem;
            background: linear-gradient(135deg, #0f4c81 0%, #1d72b8 52%, #5aa9e6 100%);
        }

        .payment-record-modal-header .close {
            opacity: 1;
            text-shadow: none;
        }

        .payment-record-modal-title {
            display: flex;
            align-items: center;
            gap: 0.85rem;
        }

        .payment-record-modal-icon {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            background: rgba(255, 255, 255, 0.18);
            font-size: 1.1rem;
        }

        .payment-record-modal-kicker {
            display: block;
            margin-bottom: 0.2rem;
            font-size: 0.75rem;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: rgba(255, 255, 255, 0.72);
        }

        .payment-record-modal-title h5,
        .payment-record-modal-title p {
            margin: 0;
        }

        .payment-record-modal-subtitle {
            margin-top: 0.4rem;
            color: rgba(255, 255, 255, 0.82);
            font-size: 0.92rem;
        }

        .payment-record-modal-body {
            padding: 1.5rem;
            background:
                radial-gradient(circle at top right, rgba(90, 169, 230, 0.12), transparent 28%),
                linear-gradient(180deg, #f8fbff 0%, #f3f6fb 100%);
        }

        .payment-record-shell {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }

        .payment-record-summary {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 1rem;
        }

        .payment-record-stat {
            background: #fff;
            border: 1px solid rgba(15, 76, 129, 0.08);
            border-radius: 18px;
            padding: 1rem 1.1rem;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.05);
        }

        .payment-record-stat-label {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: #6c7a89;
            margin-bottom: 0.35rem;
        }

        .payment-record-stat-value {
            font-size: 1.35rem;
            line-height: 1.2;
            font-weight: 700;
            color: #12263f;
        }

        .payment-record-stat-note {
            font-size: 0.85rem;
            color: #667085;
            margin-top: 0.2rem;
        }

        .payment-record-list {
            position: relative;
            display: flex;
            flex-direction: column;
            gap: 1rem;
            padding-left: 1rem;
        }

        .payment-record-list::before {
            content: "";
            position: absolute;
            top: 0.4rem;
            bottom: 0.4rem;
            left: 0.45rem;
            width: 2px;
            background: linear-gradient(180deg, #8cc7f1 0%, #d3e8f8 100%);
        }

        .payment-record-day {
            margin-left: 1.4rem;
            display: inline-flex;
            align-items: center;
            align-self: flex-start;
            padding: 0.45rem 0.8rem;
            border-radius: 999px;
            background: #dff0ff;
            color: #0f4c81;
            font-weight: 700;
            font-size: 0.84rem;
            box-shadow: inset 0 0 0 1px rgba(15, 76, 129, 0.08);
        }

        .payment-record-entry {
            position: relative;
            margin-left: 1.4rem;
            background: #fff;
            border: 1px solid rgba(15, 76, 129, 0.08);
            border-radius: 22px;
            padding: 1.15rem 1.2rem;
            box-shadow: 0 18px 38px rgba(15, 23, 42, 0.06);
        }

        .payment-record-entry::before {
            content: "";
            position: absolute;
            left: -1.55rem;
            top: 1.35rem;
            width: 14px;
            height: 14px;
            border-radius: 999px;
            border: 3px solid #fff;
            box-shadow: 0 0 0 4px rgba(140, 199, 241, 0.35);
            background: var(--entry-accent, #1fa971);
        }

        .payment-record-entry-head {
            display: flex;
            justify-content: space-between;
            gap: 1rem;
            margin-bottom: 1rem;
        }

        .payment-record-entry-main {
            min-width: 0;
        }

        .payment-record-status {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            padding: 0.38rem 0.72rem;
            border-radius: 999px;
            font-size: 0.8rem;
            font-weight: 700;
            background: var(--status-bg, #ebf8f2);
            color: var(--status-color, #15803d);
            margin-bottom: 0.7rem;
        }

        .payment-record-amount {
            font-size: 1.6rem;
            line-height: 1.1;
            font-weight: 700;
            color: #12263f;
            margin-bottom: 0.35rem;
        }

        .payment-record-entry-meta {
            color: #667085;
            font-size: 0.92rem;
        }

        .payment-record-actions {
            display: flex;
            flex-wrap: wrap;
            justify-content: flex-end;
            gap: 0.55rem;
        }

        .payment-record-btn {
            border-radius: 999px;
            padding: 0.5rem 0.9rem;
            font-size: 0.82rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            text-decoration: none !important;
        }

        .payment-record-btn.btn-outline-primary {
            border-width: 1px;
        }

        .payment-record-list .time-label {
            margin-left: 1.4rem;
            position: relative;
            z-index: 1;
        }

        .payment-record-list .time-label span {
            display: inline-flex;
            align-items: center;
            padding: 0.45rem 0.8rem;
            border-radius: 999px;
            background: #dff0ff !important;
            color: #0f4c81 !important;
            font-weight: 700;
            font-size: 0.84rem;
            box-shadow: inset 0 0 0 1px rgba(15, 76, 129, 0.08);
        }

        .payment-record-list>.timeline-item,
        .payment-record-list>div>.timeline-item {
            position: relative;
            margin: 0 0 0 1.4rem !important;
            background: #fff;
            border: 1px solid rgba(15, 76, 129, 0.08);
            border-radius: 22px;
            padding: 1.15rem 1.2rem;
            box-shadow: 0 18px 38px rgba(15, 23, 42, 0.06);
        }

        .payment-record-list>div {
            position: relative;
        }

        .payment-record-list>div>i.fas {
            position: absolute;
            left: -0.1rem;
            top: 1.2rem;
            z-index: 2;
            width: 14px;
            height: 14px;
            border-radius: 999px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0;
            border: 3px solid #fff;
            box-shadow: 0 0 0 4px rgba(140, 199, 241, 0.35);
            background-image: none !important;
        }

        .payment-record-list>div>i.bg-success {
            background-color: #1fa971 !important;
        }

        .payment-record-list>div>i.bg-warning {
            background-color: #f4b740 !important;
        }

        .payment-record-list>div>i.bg-danger {
            background-color: #f97066 !important;
        }

        .payment-record-list .timeline-header {
            border-bottom: 0;
            padding: 0;
            margin: 0 0 0.8rem;
            font-size: 1.3rem;
            font-weight: 700;
            line-height: 1.2;
            color: #12263f !important;
        }

        .payment-record-list .timeline-header b {
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            margin-right: 0.55rem;
            padding: 0.38rem 0.72rem;
            border-radius: 999px;
            font-size: 0.8rem;
            font-weight: 700;
            background: #ebf8f2;
            color: #15803d;
            vertical-align: middle;
        }

        .payment-record-list .timeline-header.text-warning b {
            background: #fef3c7;
            color: #a16207;
        }

        .payment-record-list .timeline-header.text-danger b {
            background: #fee4e2;
            color: #b42318;
        }

        .payment-record-list .timeline-body {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0.8rem;
            padding: 0;
            color: #12263f;
        }

        .payment-record-list .timeline-body>div {
            background: #f8fbff;
            border: 1px solid rgba(15, 76, 129, 0.07);
            border-radius: 16px;
            padding: 0.85rem 0.95rem;
            line-height: 1.45;
        }

        .payment-record-list .timeline-body>div b {
            display: block;
            margin-bottom: 0.35rem;
            font-size: 0.78rem;
            color: #6c7a89;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .payment-record-list .float-right.d-flex.align-items-center {
            float: none !important;
            display: flex !important;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 0.55rem;
            margin-bottom: 0.9rem;
        }

        .payment-record-list .float-right.d-flex.align-items-center a,
        .payment-record-list .float-right.d-flex.align-items-center button {
            border-radius: 999px !important;
            padding: 0.5rem 0.9rem !important;
            font-size: 0.82rem !important;
            font-weight: 600;
            line-height: 1.2;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none !important;
        }

        .payment-record-list .float-right.d-flex.align-items-center a {
            border: 1px solid #1d72b8;
            color: #1d72b8;
            background: #fff;
        }

        .payment-record-list .float-right.d-flex.align-items-center a:hover {
            background: #eef7ff;
        }

        .payment-record-list .btn.btn-xs.btn-danger.ml-2 {
            margin-left: 0 !important;
        }

        .payment-record-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0.8rem;
        }

        .payment-record-card {
            background: #f8fbff;
            border: 1px solid rgba(15, 76, 129, 0.07);
            border-radius: 16px;
            padding: 0.85rem 0.95rem;
        }

        .payment-record-card-label {
            font-size: 0.78rem;
            color: #6c7a89;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.35rem;
        }

        .payment-record-card-value {
            font-size: 1rem;
            font-weight: 600;
            color: #12263f;
            word-break: break-word;
        }

        .payment-record-empty,
        .payment-record-loading,
        .payment-record-error {
            background: #fff;
            border-radius: 20px;
            padding: 2.4rem 1.2rem;
            text-align: center;
            border: 1px solid rgba(15, 76, 129, 0.08);
            box-shadow: 0 16px 35px rgba(15, 23, 42, 0.06);
        }

        .payment-record-loading i,
        .payment-record-empty i,
        .payment-record-error i {
            font-size: 2rem;
            margin-bottom: 0.85rem;
        }

        .payment-record-modal-footer {
            border-top: 1px solid rgba(15, 76, 129, 0.08);
            background: #fff;
            padding: 1rem 1.5rem 1.25rem;
        }

        @media (max-width: 767.98px) {
            .payment-record-modal-body {
                padding: 1rem;
            }

            .payment-record-summary,
            .payment-record-grid {
                grid-template-columns: 1fr;
            }

            .payment-record-entry-head {
                flex-direction: column;
            }

            .payment-record-actions {
                justify-content: flex-start;
            }

            .payment-record-amount {
                font-size: 1.35rem;
            }

            .payment-record-list .timeline-body {
                grid-template-columns: 1fr;
            }

            .payment-record-list .float-right.d-flex.align-items-center {
                justify-content: flex-start;
            }
        }

        /* Simple override for payment record modal */
        #paymentRecordModal .modal-dialog {
            max-width: 820px;
        }

        .payment-record-modal-content {
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.12);
        }

        .payment-record-modal-header {
            background: #0d6efd;
            padding: 1rem 1.25rem;
        }

        .payment-record-modal-title {
            display: block;
        }

        .payment-record-modal-icon,
        .payment-record-modal-kicker,
        .payment-record-modal-subtitle {
            display: none;
        }

        .payment-record-modal-body {
            padding: 1rem 1.25rem;
            background: #f8f9fa;
        }

        .payment-record-modal-footer {
            padding: 0.85rem 1.25rem;
            background: #fff;
            border-top: 1px solid #dee2e6;
        }

        .payment-record-summary {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 0.75rem;
            margin-bottom: 1rem;
        }

        .payment-record-summary-item {
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 0.75rem;
        }

        .payment-record-summary-label {
            display: block;
            font-size: 0.78rem;
            color: #6c757d;
            margin-bottom: 0.25rem;
        }

        .payment-record-summary-item strong {
            font-size: 1rem;
            color: #212529;
        }

        .payment-record-list {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            padding-left: 0;
        }

        .payment-record-list::before,
        .payment-record-day,
        .payment-record-entry,
        .payment-record-entry::before,
        .payment-record-shell {
            all: unset;
        }

        .payment-record-date {
            font-size: 0.82rem;
            font-weight: 700;
            color: #495057;
            margin: 0.25rem 0 0.1rem;
        }

        .payment-record-card {
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 0.9rem;
        }

        .payment-record-card-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 0.75rem;
            margin-bottom: 0.8rem;
        }

        .payment-record-amount {
            font-size: 1.15rem;
            font-weight: 700;
            color: #212529;
            margin-bottom: 0.15rem;
        }

        .payment-record-meta {
            font-size: 0.82rem;
            color: #6c757d;
        }

        .payment-record-badge {
            display: inline-block;
            padding: 0.28rem 0.55rem;
            border-radius: 999px;
            font-size: 0.75rem;
            font-weight: 600;
            white-space: nowrap;
        }

        .payment-record-badge-success {
            background: #d1e7dd;
            color: #0f5132;
        }

        .payment-record-badge-warning {
            background: #fff3cd;
            color: #664d03;
        }

        .payment-record-badge-danger {
            background: #f8d7da;
            color: #842029;
        }

        .payment-record-details {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 0.65rem 1rem;
        }

        .payment-record-details span {
            display: block;
            font-size: 0.76rem;
            color: #6c757d;
            margin-bottom: 0.15rem;
        }

        .payment-record-details strong {
            display: block;
            font-size: 0.92rem;
            color: #212529;
            word-break: break-word;
        }

        .payment-record-actions {
            display: flex;
            justify-content: flex-end;
            flex-wrap: wrap;
            gap: 0.5rem;
            margin-top: 0.9rem;
            padding-top: 0.8rem;
            border-top: 1px solid #f1f3f5;
        }

        .payment-record-state {
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 1.5rem 1rem;
            text-align: center;
        }

        .payment-record-state i {
            font-size: 1.4rem;
            margin-bottom: 0.5rem;
        }

        @media (max-width: 767.98px) {
            .payment-record-summary,
            .payment-record-details {
                grid-template-columns: 1fr;
            }

            .payment-record-card-top,
            .payment-record-actions {
                flex-direction: column;
                align-items: stretch;
            }
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
                                <a href="payments" class="nav-link active">
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

        <!-- Content Wrapper -->
        <div class="content-wrapper" style="background-color: #f4f7fa; padding-bottom: 100px;">
            <div class="content">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="mb-3">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Payments</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent"
                                                style="margin-left: -2px;">
                                                <input type="hidden" name="student_id" id="edit_student_id" value="">
                                                <input type="hidden" name="session_id" id="edit_session_id" value="">
                                                <input type="hidden" name="term_id" id="edit_term_id" value="">
                                                <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                    <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">Payments</li>
                                    </ol>
                                    <!-- add new assessment button -->
                                    <div class="d-flex align-items-center flex-wrap mb-3 mt-4" style="gap: 10px;">
                                        <div class="">
                                            <a href="#createBillTypeModal" data-toggle="modal" class="btn btn-sm btn-primary">Create New
                                                Bill Type</a>
                                        </div>
                                        <!-- Button to trigger the Create/Assign Bill Modal -->
                                        <button type="button" class="btn btn-sm" data-toggle="modal"
                                            data-target="#createAssignBillModal">
                                            Assign Bill
                                        </button>

                                    </div>
                                    <div class="row">
                                        <div class="col-12" id="bill_type_selector_container">
                                            <!-- Renamed ID for clarity -->
                                            <div class="form-group align-items-center">
                                                <!-- Added align-items-center -->
                                                <label for="" class="mb-0 mr-2">Select Bill Type:</label>
                                                <div id="bill-type-buttons" class="d-inline-flex flex-wrap"
                                                    style="gap: 0.5rem;">
                                                    <!-- Container for dynamic buttons -->
                                                    <!-- Bill type buttons will be loaded here by AJAX -->
                                                    <span class="text-muted">Loading bill types...</span>
                                                    <!-- Optional loading indicator -->
                                                </div>
                                            </div>
                                        </div>

                                        <div class="col-12 col-md-3" id="select_class_single">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Class</label>
                                                <select class="form-control select2" class="select_class_field"
                                                    id="select_class_field" onchange="" style="width: 100%;">
                                                    <option value="" selected disabled>Select Class</option>
                                                    <!-- Class options will be loaded here by JS/PHP -->
                                                </select>
                                            </div>
                                        </div>
                                        <div class="col-12 col-md-3" id="select_term_single">
                                            <label for="" class="mb-0">Select Term</label>
                                            <div class="term_type_btn d-flex flex-wrap mb-3" style="gap:15px;">
                                                <button type="button" class="btn term_btn select_btn active"
                                                    data-id="1">First</button>
                                                <button type="button" class="btn term_btn select_btn"
                                                    data-id="2">Second</button>
                                                <button type="button" class="btn term_btn select_btn"
                                                    data-id="3">Third</button>
                                            </div>
                                        </div>
                                        <div class="col-12 col-md-3" id="select_session">
                                            <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Session</label>
                                                <select class="form-control select2" onchange="handleToggleSelection()"
                                                    id="select_session_field" style="width: 100%;">
                                                    <!-- <option selected value="1">2013/2014</option> -->
                                                    <?php
                                                    $select = mysqli_query($conn, "SELECT id,session FROM sessions ORDER BY session ASC");
                                                    while ($row = mysqli_fetch_array($select)) {
                                                        if ($row['id'] == $_SESSION['session_id']) {
                                                    ?>
                                                            <option selected value="<?= $row['id'] ?>"><?= $row['session'] ?>
                                                            </option>
                                                        <?php }
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
                                <div class="hr my-4" style="height: 10px; width: 100%; background-color: #ededed;">
                                </div>
                                <div id="student_payment_record_container" class="">
                                    <div id="select-class-message" class="alert text-center p-3" style="
    background: #e2e2e2;
">Select class to
                                        see record.</div>
                                    <div id="estimated-income-section" class="mb-3"
                                        style="display:none;">
                                        <div class="row w-100">
                                            <!-- Selected Class Column -->
                                            <div class="col-md-12 mb-3">
                                                <div class="card shadow-sm h-100">
                                                    <div class="card-body text-center">
                                                        <p class="mb-1 text-left font-weight-bold">Selected Class</p>
                                                        <div class="d-flex menu-scrollbar"
                                                            style="overflow: auto; white-space: nowrap; width: 100%; column-gap:40px;">
                                                            <div class="">
                                                                <small class="text-muted">Estimated Income</small>
                                                                <h4 id="estimated-income-class"
                                                                    class="font-weight-bold mb-0">–</h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Total Paid</small>
                                                                <h4 id="total-paid-class" class="font-weight-bold mb-0">
                                                                    –</h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Amount Left</small>
                                                                <h4 id="amount-left-class"
                                                                    class="font-weight-bold mb-0">–</h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Total Students</small>
                                                                <h4 id="total-students-class"
                                                                    class="font-weight-bold mb-0">–</h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Students Paid (Any
                                                                    Amount)</small>
                                                                <h4 id="students-paid-class"
                                                                    class="font-weight-bold mb-0">–</h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Students Completed
                                                                    Payment</small>
                                                                <h4 id="students-completed-class"
                                                                    class="font-weight-bold mb-0">–</h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Students Unpaid (₦0
                                                                    Paid)</small>
                                                                <h4 id="students-unpaid-class"
                                                                    class="font-weight-bold mb-0">–</h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Students Assigned</small>
                                                                <h4 id="students-assigned-class" class="font-weight-bold mb-0">–</h4>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- All Classes Column -->
                                            <div class="col-md-12 mb-3">
                                                <div class="card shadow-sm h-100">
                                                    <div class="card-body text-center">
                                                        <p class="mb-1 text-left font-weight-bold">All Classes</p>

                                                        <div class="d-flex menu-scrollbar"
                                                            style="overflow: auto; white-space: nowrap; width:100%; column-gap: 40px;">
                                                            <div class=" mb-2">
                                                                <small class="text-muted">Estimated Income</small>
                                                                <h4 id="estimated-income-all"
                                                                    class="font-weight-bold mb-0">
                                                                    –</h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Total Paid</small>
                                                                <h4 id="total-paid-all" class="font-weight-bold mb-0">–
                                                                </h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Amount Left</small>
                                                                <h4 id="amount-left-all" class="font-weight-bold mb-0">–
                                                                </h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Total Students</small>
                                                                <h4 id="total-students-all"
                                                                    class="font-weight-bold mb-0">–
                                                                </h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Students Paid (Any
                                                                    Amount)</small>
                                                                <h4 id="students-paid-all"
                                                                    class="font-weight-bold mb-0">–
                                                                </h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Students Completed
                                                                    Payment</small>
                                                                <h4 id="students-completed-all"
                                                                    class="font-weight-bold mb-0">–</h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Students Unpaid (₦0
                                                                    Paid)</small>
                                                                <h4 id="students-unpaid-all"
                                                                    class="font-weight-bold mb-0">–
                                                                </h4>
                                                            </div>
                                                            <div class="">
                                                                <small class="text-muted">Students Assigned</small>
                                                                <h4 id="students-assigned-all" class="font-weight-bold mb-0">–</h4>
                                                            </div>
                                                        </div>

                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <!-- Student record filters -->
                                    </div>
                                </div>
                                <div id="student-record-filters" class="mb-3 menu-scrollbar" style="display:none; overflow: auto; white-space: nowrap; width:100%; column-gap: 40px;">
                                    <div class="btn-group" role="group" aria-label="Student record filters">
                                        <button type="button" class="btn btn-sm btn-secondary select_btn filter-btn active" data-filter="all">All</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary select_btn filter-btn" data-filter="assigned">Assigned</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary select_btn filter-btn" data-filter="unassigned">Unassigned</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary select_btn filter-btn" data-filter="partly_paid">Partly Paid</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary select_btn filter-btn" data-filter="unpaid">Unpaid</button>
                                        <button type="button" class="btn btn-sm btn-outline-secondary select_btn filter-btn" data-filter="paid">Paid</button>
                                    </div>
                                </div>
                                <table id="student_payment_recordTable" class="display"
                                    style="width:100%; display:none;">
                                    <thead>
                                        <tr>
                                            <th>Student Name</th>
                                            <th>Bill Type</th>
                                            <th>Amount Due</th>
                                            <th>Amount Paid</th>
                                            <th>Balance</th>
                                            <th>Status</th>
                                            <th>Last Payment</th>
                                            <th>Action</th>
                                        </tr>
                                    </thead>
                                </table>

                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Add this right after your other modals -->
    <div class="modal fade" id="editBillModal" tabindex="-1" role="dialog" aria-labelledby="editBillModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editBillModalLabel">Edit Student Bill</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- Top stepper (matching Quick Assign layout) -->
                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                        <div>
                            <div class="btn-group" role="group" aria-label="Edit Bill Steps">
                                <button type="button" class="btn btn-sm btn-primary" id="edit-step-btn-1">1. Edit</button>
                                <button type="button" class="btn btn-sm btn-secondary" id="edit-step-btn-2">2. Preview</button>
                            </div>
                        </div>
                        <div>
                            <small class="text-muted">Step-by-step bill edit</small>
                        </div>
                    </div>

                    <!-- Nav tabs (hidden) -->
                    <ul class="nav nav-pills mb-3" id="editBillTabs" role="tablist" style="display:none;">
                        <li class="nav-item" role="presentation">
                            <a class="nav-link active" id="edit-bill-tab-link" data-toggle="pill" href="#edit-bill-tab" role="tab" aria-controls="edit-bill-tab" aria-selected="true">Edit Bill</a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link" id="edit-preview-bill-tab-link" data-toggle="pill" href="#edit-preview-bill-tab" role="tab" aria-controls="edit-preview-bill-tab" aria-selected="false">Preview Bill</a>
                        </li>
                    </ul>

                    <div class="tab-content" id="editBillTabsContent">
                        <!-- Edit Bill Tab Content (Step 1) -->
                        <div class="tab-pane fade show active" id="edit-bill-tab" role="tabpanel" aria-labelledby="edit-bill-tab-link">
                            <form id="editBillForm">
                                <input type="hidden" id="edit_bill_id" name="bill_id">
                                <input type="hidden" id="edit_student_id" name="student_id">
                                <div class="row">
                                    <div class="col-md-12 form-group">
                                        <label>Student Name</label>
                                        <input type="text" class="form-control" id="edit_student_name" readonly>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 form-group">
                                        <label for="edit_bill_type">Bill Type</label>
                                        <select class="form-control select2" id="edit_bill_type" name="bill_type" style="width: 100%;"></select>
                                    </div>
                                </div>
                                <!-- Bill Breakdown Table -->
                                <div class="form-group">
                                    <label>Bill Breakdown</label>
                                    <table class="table table-bordered" id="editInvoiceBreakdownTable">
                                        <thead>
                                            <tr>
                                                <th>Description</th>
                                                <th>Amount</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <!-- Rows will be loaded dynamically -->
                                        </tbody>
                                    </table>
                                    <button type="button" class="btn btn-primary btn-sm" id="addEditBreakdownRow">Add Item</button>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 form-group">
                                        <label for="editSubtotal">Subtotal</label>
                                        <input type="number" step="0.01" class="form-control" id="editSubtotal" name="edit_subtotal" readonly>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="editDeductionPurpose">Deduction Purpose</label>
                                        <input type="text" class="form-control" id="editDeductionPurpose" name="edit_deduction_purpose" placeholder="e.g. Scholarship or Discount">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label for="editDeductionPercentage">Deduction Percentage (%)</label>
                                        <input type="number" min="0" max="100" step="0.01" class="form-control" id="editDeductionPercentage" name="edit_deduction_percentage" value="0">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-4 form-group">
                                        <label for="editTaxPercentage">Tax (%)</label>
                                        <input type="number" min="0" max="100" step="0.01" class="form-control" id="editTaxPercentage" name="edit_tax" value="0">
                                    </div>
                                    <div class="col-md-4 form-group">
                                        <label for="editTotalAmount">Total Amount</label>
                                        <input type="number" step="0.01" class="form-control" id="editTotalAmount" name="edit_total_amount" readonly required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="editNotes">Notes</label>
                                    <textarea class="form-control" id="editNotes" name="edit_notes" rows="2" placeholder="Additional notes..."></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="editTerms">Terms</label>
                                    <textarea class="form-control" id="editTerms" name="edit_terms" rows="2" placeholder="Payment terms..."></textarea>
                                </div>
                            </form>
                        </div>
                        <!-- Preview Bill Tab Content (Step 2) -->
                        <div class="tab-pane fade" id="edit-preview-bill-tab" role="tabpanel" aria-labelledby="edit-preview-bill-tab-link">
                            <div id="editPreviewBillContent">
                                <p class="text-muted">Click "Next" to see the preview here.</p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer" id="editBillModalFooter">
                    <div class="w-100 d-flex justify-content-end align-items-center">
                        <button type="button" class="btn btn-secondary mr-2" id="edit-wizard-back" style="display: none;">Back</button>
                        <button type="button" class="btn btn-primary mr-2" id="edit-wizard-next">Next</button>
                        <button type="button" class="btn btn-success" id="edit-save-changes" style="display: none;">Save Changes</button>
                        <button type="button" class="btn btn-secondary ml-2" data-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Create/Assign Bill Modal -->
    <div class="modal fade" id="createAssignBillModal" tabindex="-1" role="dialog"
        aria-labelledby="createAssignBillModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createAssignBillModalLabel">Assign Bill to Students</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="assignBillForm">
                        <!-- Stepper Navigation -->
                        <div class="d-flex justify-content-between mb-4">
                            <div class="text-center">
                                <button type="button" class="btn btn-primary rounded-circle" id="step-btn-1">1</button>
                                <p>Bill Details</p>
                            </div>
                            <div style="width: 30%; border-bottom: 2px solid #ccc; margin-bottom: 25px;"></div>
                            <div class="text-center">
                                <button type="button" class="btn btn-secondary rounded-circle" id="step-btn-2">2</button>
                                <p>Select Students</p>
                            </div>
                            <div style="width: 30%; border-bottom: 2px solid #ccc; margin-bottom: 25px;"></div>
                            <div class="text-center">
                                <button type="button" class="btn btn-secondary rounded-circle" id="step-btn-3">3</button>
                                <p>Preview & Confirm</p>
                            </div>
                        </div>

                        <!-- Step 1: Bill Details -->
                        <div id="step-1">
                            <div class="card card-body mb-3">
                                <div class="form-group">
                                    <label for="selectBillTypeModal">Select Bill Type</label>
                                    <select class="form-control select2" id="selectBillTypeModal" name="bill_type_id"
                                        style="width: 100%;" title="Select Bill Type" required>
                                        <option value="" selected disabled>Loading bill types...</option>
                                        <!-- Options will be loaded by AJAX -->
                                    </select>
                                </div>
                            </div>
                            <div class="card card-body mb-3">
                                <h5>Bill Breakdown</h5>
                                <table class="table table-bordered" id="assignInvoiceBreakdownTableAssign">
                                    <thead>
                                        <tr>
                                            <th>Description</th>
                                            <th>Amount</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td><input type="text" name="assign_breakdown_description[]"
                                                    class="form-control" placeholder="e.g. Uniform Fee" required></td>
                                            <td><input type="number" name="assign_breakdown_amount[]"
                                                    class="form-control assign-breakdown-amount" step="0.01" min="0"
                                                    required></td>
                                            <td><button type="button"
                                                    class="btn btn-danger btn-sm remove-assign-breakdown-row"
                                                    title="Remove"><i class="fas fa-trash"></i></button></td>
                                        </tr>
                                    </tbody>
                                </table>
                                <button type="button" class="btn btn-primary btn-sm" id="addAssignBreakdownRow">Add
                                    Item</button>
                            </div>
                            <div class="card card-body">
                                <h5>Adjustments & Totals</h5>
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="assignSubtotal">Subtotal</label>
                                        <input type="number" step="0.01" class="form-control" id="assignSubtotal"
                                            name="assign_subtotal" readonly>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="assignDeductionPurpose">Deduction Purpose</label>
                                        <input type="text" class="form-control" id="assignDeductionPurpose"
                                            name="assign_deduction_purpose" placeholder="e.g. Scholarship or Discount">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label for="assignDeductionPercentage">Deduction Percentage (%)</label>
                                        <input type="number" min="0" max="100" step="0.01" class="form-control"
                                            id="assignDeductionPercentage" name="assign_deduction_percentage" value="0">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="assignTaxPercentage">Tax (%)</label>
                                        <input type="number" min="0" max="100" step="0.01" class="form-control"
                                            id="assignTaxPercentage" name="assign_tax" value="0">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label for="assignTotalAmount">Total Amount</label>
                                        <input type="number" step="0.01" class="form-control" id="assignTotalAmount"
                                            name="assign_total_amount" readonly required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="assignNotes">Notes</label>
                                    <textarea class="form-control" id="assignNotes" name="assign_notes" rows="2"
                                        placeholder="Additional notes..."></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="assignTerms">Terms</label>
                                    <textarea class="form-control" id="assignTerms" name="assign_terms" rows="2"
                                        placeholder="Payment terms..."></textarea>
                                </div>
                            </div>
                        </div>

                        <!-- Step 2: Select Students -->
                        <div id="step-2" style="display: none;">
                            <div class="card card-body">
                                <div class="form-group">
                                    <label for="filterClassModal">Filter Students by Class</label>
                                    <select class="form-control select2" id="filterClassModal" name="filter_class_id"
                                        style="width: 100%;">
                                        <option value="" selected disabled>Select a class to load students...</option>
                                        <!-- Class options will be loaded by AJAX -->
                                    </select>
                                </div>
                                <label>Select Students</label>
                                <div class="table-responsive" style="max-height: 300px; overflow-y: auto;">
                                    <table class="table table-sm table-bordered" id="studentListTableModal">
                                        <thead>
                                            <tr>
                                                <th><input type="checkbox" id="selectAllStudentsCheckbox"></th>
                                                <th>Student Name</th>
                                                <th>Admission No</th>
                                                <th>Class</th>
                                            </tr>
                                        </thead>
                                        <tbody id="studentListTableBodyModal">
                                            <tr>
                                                <td colspan="4" class="text-center text-muted">Select a class to view
                                                    students.</td>
                                            </tr>
                                        </tbody>
                                    </table>
                                </div>
                                <small class="text-muted">You can select students from multiple classes. Selected students
                                    will be remembered.</small>
                            </div>
                        </div>

                        <!-- Step 3: Preview & Confirm -->
                        <div id="step-3" style="display: none;">
                            <div id="previewBillContent">
                                <p class="text-muted text-center">Preview of the bill will be shown here.</p>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-light" id="wizard-back-btn" style="display: none;">Back</button>
                    <button type="button" class="btn btn-primary" id="wizard-next-btn">Next</button>
                    <button type="button" class="btn btn-success" id="assignNowButton"
                        style="display: none;">Assign Now</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Create/Assign Bill Modal -->

    <!-- Add Edit Bill Type Modal (Similar to Create Modal) -->
    <div class="modal fade" id="editBillTypeModal" tabindex="-1" role="dialog" aria-labelledby="editBillTypeModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title font-weight-bold" id="editBillTypeModalLabel">Edit Bill Type</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="editBillTypeForm">
                        <input type="hidden" id="editBillTypeId" name="billTypeId"> <!-- Hidden field for ID -->
                        <div class="form-group">
                            <label for="editBillName">Bill Name</label>
                            <input type="text" title="Enter the name of the bill type" class="form-control"
                                id="editBillName" name="billName" required>
                        </div>
                        <!-- Bill Breakdown Table -->
                        <div class="form-group">
                            <label>Bill Breakdown</label>
                            <table class="table table-bordered" id="invoiceBreakdownTable">
                                <thead>
                                    <tr>
                                        <th>Description</th>
                                        <th>Amount</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><input type="text" name="breakdown_description[]" class="form-control"
                                                placeholder="e.g. Uniform Fee" required></td>
                                        <td><input type="number" name="breakdown_amount[]"
                                                class="form-control breakdown-amount" step="0.01" min="0" required></td>
                                        <td><button type="button" class="btn btn-danger btn-sm remove-breakdown-row"
                                                title="Remove"><i class="fas fa-trash"></i></button></td>
                                    </tr>
                                </tbody>
                            </table>
                            <button type="button" class="btn btn-primary btn-sm" id="addBreakdownRow">Add Item</button>
                        </div>
                        <div class="row">
                            <div class="col-md-12 form-group">
                                <label for="subtotal">Subtotal</label>
                                <input type="number" step="0.01" class="form-control" id="subtotal" name="subtotal"
                                    readonly>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label for="deductionPurpose">Deduction Purpose</label>
                                <input type="text" class="form-control" id="deductionPurpose" name="deduction_purpose"
                                    placeholder="e.g. Scholarship or Discount"
                                    title="Specify the purpose of the deduction for the bill type">
                            </div>
                            <div class="col-md-6 form-group">
                                <label for="deductionPercentage">Deduction Percentage (%)</label>
                                <input type="number" min="0" max="100" step="0.01" class="form-control"
                                    id="deduction_percentage" name="deduction_percentage" value="0">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label for="editBillTaxPercentage">Tax (%)</label>
                                <input type="number" min="0" max="100" step="0.01" class="form-control"
                                    id="editBillTaxPercentage" name="taxPercentage" value="0">
                            </div>
                            <div class="col-md-6 form-group">
                                <label for="totalAmountInvoice">Total Amount</label>
                                <input type="number" step="0.01" class="form-control" id="totalAmountInvoice"
                                    name="amount" readonly required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="notes">Notes</label>
                            <textarea class="form-control" id="notes" name="notes" rows="2"
                                placeholder="Additional notes..."></textarea>
                        </div>
                        <div class="form-group">
                            <label for="terms">Terms</label>
                            <textarea class="form-control" id="terms" name="terms" rows="2"
                                placeholder="Payment terms..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary" form="editBillTypeForm">Save Changes</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Add Delete Confirmation Modal -->
    <div class="modal fade" id="deleteBillTypeModal" tabindex="-1" role="dialog"
        aria-labelledby="deleteBillTypeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteBillTypeModalLabel">Confirm Deletion</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    Are you sure you want to delete the bill type: <strong id="deleteBillTypeName"></strong>? This
                    action cannot be undone.
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBillType">Delete</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Add this after your other modals -->
    <div class="modal fade" id="quickAssignBillModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Quick Assign Bill</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- Top stepper (moved from footer) -->
                    <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                        <div>
                            <div class="btn-group" role="group" aria-label="Quick Assign Steps">
                                <button type="button" class="btn btn-sm btn-primary" id="quick-step-btn-1">1. Details</button>
                                <button type="button" class="btn btn-sm btn-secondary" id="quick-step-btn-2">2. Preview</button>
                            </div>
                        </div>
                        <div>
                            <small class="text-muted">Step-by-step quick assign</small>
                        </div>
                    </div>
                    <!-- Nav tabs -->
                    <ul class="nav nav-pills mb-3" id="quickAssignBillTabs" role="tablist" style="display:none;">
                        <li class="nav-item" role="presentation">
                            <a class="nav-link active" id="quick-assign-bill-tab-link" data-toggle="pill"
                                href="#quick-assign-bill-tab" role="tab" aria-controls="quick-assign-bill-tab"
                                aria-selected="true">Assign Bill</a>
                        </li>
                        <li class="nav-item" role="presentation">
                            <a class="nav-link" id="quick-preview-bill-tab-link" data-toggle="pill"
                                href="#quick-preview-bill-tab" role="tab" aria-controls="quick-preview-bill-tab"
                                aria-selected="false">Preview Bill</a>
                        </li>
                    </ul>

                    <!-- Tab panes -->
                    <div class="tab-content" id="quickAssignBillTabsContent">
                        <!-- Assign Bill Tab Content (Step 1) -->
                        <div class="tab-pane fade show active" id="quick-assign-bill-tab" role="tabpanel"
                            aria-labelledby="quick-assign-bill-tab-link">
                            <form id="quickAssignBillForm">
                                <input type="hidden" id="quick_assign_student_id">
                                <!-- Student Info (Read-only) -->
                                <div class="form-group">
                                    <label>Student Name</label>
                                    <input type="text" class="form-control" id="quick_assign_student_name" readonly>
                                </div>
                                <!-- Bill Type Dropdown -->
                                <div class="form-group">
                                    <label for="quick_assign_bill_type">Bill Type</label>
                                    <select class="form-control select2" id="quick_assign_bill_type" name="bill_type"
                                        required>
                                        <option value="" selected disabled>Select Bill Type</option>
                                    </select>
                                </div>
                                <!-- Bill Breakdown Table -->
                                <div class="form-group">
                                    <label>Bill Breakdown</label>
                                    <table class="table table-bordered" id="quickAssignInvoiceBreakdownTable">
                                        <thead>
                                            <tr>
                                                <th>Description</th>
                                                <th>Amount</th>
                                                <th></th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr>
                                                <td><input type="text" name="quick_assign_breakdown_description[]"
                                                        class="form-control quick-assign-breakdown-description"
                                                        placeholder="e.g. Uniform Fee" required></td>
                                                <td><input type="number" name="quick_assign_breakdown_amount[]"
                                                        class="form-control quick-assign-breakdown-amount" step="0.01"
                                                        min="0" required></td>
                                                <td><button type="button"
                                                        class="btn btn-danger btn-sm remove-quick-assign-breakdown-row"
                                                        title="Remove"><i class="fas fa-trash"></i></button></td>
                                            </tr>
                                        </tbody>
                                    </table>
                                    <button type="button" class="btn btn-primary btn-sm"
                                        id="addQuickAssignBreakdownRow">Add Item</button>
                                </div>
                                <div class="row">
                                    <div class="col-md-12 form-group">
                                        <label for="quick_assign_subtotal">Subtotal</label>
                                        <input type="number" step="0.01" class="form-control" id="quick_assign_subtotal"
                                            name="quick_assign_subtotal" readonly>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="quick_assign_deduction_purpose">Deduction Purpose</label>
                                        <input type="text" class="form-control" id="quick_assign_deduction_purpose"
                                            name="quick_assign_deduction_purpose"
                                            placeholder="e.g. Scholarship or Discount">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label for="quick_assign_deduction_percentage">Deduction Percentage (%)</label>
                                        <input type="number" min="0" max="100" step="0.01" class="form-control"
                                            id="quick_assign_deduction_percentage"
                                            name="quick_assign_deduction_percentage" value="0">
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6 form-group">
                                        <label for="quick_assign_tax">Tax (%)</label>
                                        <input type="number" min="0" max="100" step="0.01" class="form-control"
                                            id="quick_assign_tax" name="quick_assign_tax" value="0">
                                    </div>
                                    <div class="col-md-6 form-group">
                                        <label for="quick_assign_total_amount">Total Amount</label>
                                        <input type="number" step="0.01" class="form-control"
                                            id="quick_assign_total_amount" name="quick_assign_total_amount" readonly
                                            required>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label for="quick_assign_notes">Notes</label>
                                    <textarea class="form-control" id="quick_assign_notes" name="quick_assign_notes"
                                        rows="2" placeholder="Additional notes..."></textarea>
                                </div>
                                <div class="form-group">
                                    <label for="quick_assign_terms">Terms</label>
                                    <textarea class="form-control" id="quick_assign_terms" name="quick_assign_terms"
                                        rows="2" placeholder="Payment terms..."></textarea>
                                </div>
                                <!-- Preview button removed: preview is part of the stepper -->
                            </form>
                        </div>
                        <!-- Preview Bill Tab Content (Step 2) -->
                        <div class="tab-pane fade" id="quick-preview-bill-tab" role="tabpanel"
                            aria-labelledby="quick-preview-bill-tab-link">
                            <div id="quickPreviewBillContent">
                                <p class="text-muted">Click the "Preview Bill" button in the Assign Bill tab to see the
                                    details here.</p>
                            </div>
                        </div>
                        <!-- Confirmation step removed -->
                    </div>
                </div>
                <div class="modal-footer" id="quickAssignModalFooter">
                    <div class="w-100 d-flex justify-content-end align-items-center">
                        <button type="button" class="btn btn-secondary mr-2" id="quick-wizard-back">Back</button>
                        <button type="button" class="btn btn-primary mr-2" id="quick-wizard-next">Next</button>
                        <button type="button" class="btn btn-secondary ml-2" data-dismiss="modal">Cancel</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="createBillTypeModal" tabindex="-1" role="dialog"
        aria-labelledby="createBillTypeModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title font-weight-bold" id="createBillTypeModalLabel">Create a New Bill Type</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="createBillTypeForm">
                        <div class="form-group">
                            <label for="billName">Bill Name</label>
                            <input type="text" title="Enter the name of the bill type" class="form-control"
                                id="billName" name="billName" required>
                        </div>
                        <!-- Bill Breakdown Table -->
                        <div class="form-group">
                            <label>Bill Breakdown</label>
                            <table class="table table-bordered" id="createInvoiceBreakdownTable">
                                <thead>
                                    <tr>
                                        <th>Description</th>
                                        <th>Amount</th>
                                        <th></th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><input type="text" name="create_breakdown_description[]"
                                                class="form-control" placeholder="e.g. Tuition Fee" required></td>
                                        <td><input type="number" name="create_breakdown_amount[]"
                                                class="form-control create-breakdown-amount" step="0.01" min="0"
                                                required></td>
                                        <td><button type="button"
                                                class="btn btn-danger btn-sm remove-create-breakdown-row"
                                                title="Remove"><i class="fas fa-trash"></i></button></td>
                                    </tr>
                                </tbody>
                            </table>
                            <button type="button" class="btn btn-primary btn-sm" id="addCreateBreakdownRow">Add
                                Item</button>
                        </div>
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label for="createSubtotal">Subtotal</label>
                                <input type="number" step="0.01" class="form-control" id="createSubtotal"
                                    name="create_subtotal" readonly>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label for="deductionPurpose">Deduction Purpose</label>
                                <input type="text" class="form-control" id="deductionPurpose" name="deduction_purpose"
                                    placeholder="e.g. Scholarship or Discount"
                                    title="Specify the purpose of the deduction for the bill type">
                            </div>
                            <div class="col-md-6 form-group">
                                <label for="deductionPercentage">Deduction Percentage (%)</label>
                                <input type="number" min="0" max="100" step="0.01" class="form-control"
                                    id="create_deduction_percentage" name="deduction_percentage" value="0">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 form-group">
                                <label for="createTax">Tax (%)</label>
                                <input type="number" step="0.01" class="form-control" id="createTax" name="create_tax"
                                    value="0">
                            </div>
                            <div class="col-md-6 form-group">
                                <label for="createTotalAmount">Total Amount</label>
                                <input type="number" step="0.01" class="form-control" id="createTotalAmount"
                                    name="create_total_amount" readonly required>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="createNotes">Notes</label>
                            <textarea class="form-control" id="createNotes" name="create_notes" rows="2"
                                placeholder="Additional notes..."></textarea>
                        </div>
                        <div class="form-group">
                            <label for="createTerms">Terms</label>
                            <textarea class="form-control" id="createTerms" name="create_terms" rows="2"
                                placeholder="Payment terms..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary" form="createBillTypeForm">Create</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Record Payment Modal -->
    <div class="modal fade" id="recordPaymentModal" tabindex="-1" role="dialog"
        aria-labelledby="recordPaymentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="recordPaymentModalLabel">Record Payment</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <form id="recordPaymentForm">
                    <div class="modal-body">
                        <input type="hidden" id="payment_student_id" name="student_id">
                        <input type="hidden" id="payment_bill_id" name="bill_id">

                        <div class="form-group">
                            <label for="payment_amount">Amount Paid</label>
                            <input type="number" class="form-control" id="payment_amount" name="amount_newly_paid"
                                min="0" step="0.01" data-current_balance="" oninput="recalculate_balance(this)" required>
                            <div class="d-flex justify-content-start flex-wrap" style="column-gap: 10px;">
                                <p class="small">Amount due = <span id="amount_due_record_payment"></span></p>
                                <p class="small text-orange" id="balance_calculate">Balance = <span id="amount_balance_record_payment"></span></p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="payment_method">Payment Method of Payment</label>
                            <select class="form-control select2" id="payment_method" name="payment_method" required>
                                <option value="">Select Method</option>
                                <?php
                                $query = "SELECT id, method FROM payment_method";
                                $result = mysqli_query($conn, $query);
                                while ($row = mysqli_fetch_assoc($result)) {
                                    echo '<option value="' . $row['id'] . '">' . $row['method'] . '</option>';
                                }
                                ?>
                            </select>
                        </div>
                        <!-- date -->
                        <div class="form-group">
                            <label for="payment_date">Payment Date</label>
                            <input type="date" value="<?= date('Y-m-d') ?>" class="form-control" id="payment_date"
                                name="payment_date" required>
                        </div>
                        <!-- <div class="form-group">
                            <label for="payment_status">Status</label>
                            <select class="form-control" id="payment_status" name="status" required>
                                <option value="1">Paid</option>
                                <option value="2">Part Paid</option>
                                <option value="0">Not Paid</option>
                            </select>
                        </div> -->
                        <div class="form-group">
                            <label for="payment_description">Description/Notes</label>
                            <textarea class="form-control" id="payment_description" name="description"
                                rows="2"></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-primary">Record Payment</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    </div>
    <!-- Payment Record Timeline Modal -->
    <div class="modal fade" id="paymentRecordModal" tabindex="-1" role="dialog"
        aria-labelledby="paymentRecordModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable" role="document">
            <div class="modal-content payment-record-modal-content">
                <div class="modal-header payment-record-modal-header text-white">
                    <div class="payment-record-modal-title">
                        <span class="payment-record-modal-icon">
                            <i class="fas fa-receipt"></i>
                        </span>
                        <div>
                            <span class="payment-record-modal-kicker">Billing Activity</span>
                            <h5 class="modal-title" id="paymentRecordModalLabel">Payment Record Timeline</h5>
                            <p class="payment-record-modal-subtitle">Review each payment entry, balance movement, and latest receipt actions.</p>
                        </div>
                    </div>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body payment-record-modal-body">
                    <div id="paymentTimelineContainer">
                        <div class="payment-record-loading text-muted">
                            <i class="fas fa-spinner fa-spin"></i>
                            <div>Loading payment records...</div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer payment-record-modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <!--<button type="button" class="btn btn-info" id="generateLastReceiptButton"><i-->
                    <!--        class="fas fa-file-invoice"></i> Generate Last Receipt</button>-->
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="confirmDeletePaymentModal" tabindex="-1" role="dialog"
        aria-labelledby="confirmDeletePaymentModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmDeletePaymentModalLabel">Delete Last Payment</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p class="mb-0">Are you sure you want to delete the most recent payment record? Earlier payment records will be recalculated automatically.</p>
                    <div id="confirmDeletePaymentAlert" class="mt-2"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" id="confirmDeletePaymentButton" class="btn btn-danger">Delete</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Payment Receipt Preview Modal -->
    <div class="modal fade" id="paymentReceiptPreviewModal" tabindex="-1" role="dialog"
        aria-labelledby="paymentReceiptPreviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header bg-success text-white">
                    <h5 class="modal-title" id="paymentReceiptPreviewModalLabel"><i class="fas fa-receipt"></i> Payment
                        Receipt Preview</h5>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" style="background-color: #f8f9fa;">
                    <div id="paymentReceiptContent">
                        <!-- Receipt content will be injected here by JS -->
                        <div class="text-center text-muted p-5">
                            <i class="fas fa-spinner fa-spin fa-2x"></i><br>
                            Loading receipt...
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-info" id="printReceiptButton"><i class="fas fa-print"></i>
                        Print</button>
                    <button type="button" class="btn btn-success" id="downloadReceiptButton"><i
                            class="fas fa-download"></i> Download</button>
                    <button type="button" class="btn btn-warning" id="shareReceiptButton"><i
                            class="fas fa-share-alt"></i> Share</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Invoice Preview Modal (for Preview Payment Invoice) -->
    <div class="modal fade" id="invoicePreviewModal" tabindex="-1" role="dialog" aria-labelledby="invoicePreviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header bg-primary text-white">
                    <p class="modal-title font-weight-bold" id="invoicePreviewModalLabel"><i class="fas fa-file-invoice"></i> Invoice Preview</p>
                    <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" id="invoicePreviewContent">
                    <div class="text-center text-muted p-4"><i class="fas fa-spinner fa-spin"></i> Loading invoice...</div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-info" id="printInvoiceButton"><i class="fas fa-print"></i> Print</button>
                    <button type="button" class="btn btn-success" id="downloadInvoiceButton"><i class="fas fa-download"></i> Download</button>
                    <button type="button" class="btn btn-warning" id="shareInvoiceButton"><i
                            class="fas fa-share-alt"></i> Share</button>
                </div>
            </div>
        </div>
    </div>
    <!-- Delete Bill Confirmation Modal -->
    <div class="modal fade" id="confirmDeleteBillModal" tabindex="-1" role="dialog" aria-labelledby="confirmDeleteBillModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-sm modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmDeleteBillModalLabel">Confirm Delete</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p class="mb-0">Are you sure you want to delete this bill record? This action will be blocked if any payments exist.</p>
                    <div id="confirmDeleteBillAlert" class="mt-2"></div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                    <button type="button" id="confirmDeleteBillButton" class="btn btn-danger">Delete</button>
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
    <script src="../dist/js/skul.js?v=w3q125sj"></script>
    <script src="../dist/js/accounts.js?v=11aj"></script>
    <!-- date-range-picker -->
    <script src="../plugins/moment/moment.min.js"></script>
    <script src="../plugins/daterangepicker/daterangepicker.js"></script>


</body>

</html>
