<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
// echo $_SESSION['photo'];
// // echo $_SESSION['userid'];
// // echo $_SESSION['class_id'];
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
    <title>Student Portal</title>
    <!-- Favicon -->
    <link rel="icon" href="418769schoollogo.jpg" type="image/jpeg">

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
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <!-- Add the new sidebar CSS -->
    <!-- <link rel="stylesheet" href="../css/sidebar.css"> -->
    <style>
        body {
            background: linear-gradient(135deg, #e0e7ff 0%, #f8fafc 100%);
            min-height: 100vh;
        }
        .user-panel img {
            border: 2px solid #6366f1;
            box-shadow: 0 2px 8px rgba(99,102,241,0.15);
        }
        .hero-section {
            background: linear-gradient(120deg, #000000 0%, #818cf8 100%);
            color: #fff;
            /* border-radius: 24px; */
            padding: 40px 30px 30px 30px;
            margin-bottom: 40px;
            box-shadow: 0 8px 32px rgba(99,102,241,0.12);
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        .hero-section h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }
        .hero-section p {
            font-size: 1.2rem;
            opacity: 0.95;
        }
        .hero-section::after {
            content: '';
            position: absolute;
            right: -60px;
            top: -60px;
            width: 180px;
            height: 180px;
            background: rgba(255,255,255,0.08);
            border-radius: 50%;
            z-index: 0;
        }
        .portal-cards {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 32px;
            margin-top: 30px;
        }
        .portal-card {
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 4px 24px rgba(99,102,241,0.10);
            width: 260px;
            min-height: 220px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 32px 20px 24px 20px;
            transition: transform 0.18s cubic-bezier(.4,2,.6,1), box-shadow 0.18s;
            position: relative;
            overflow: hidden;
        }
        .portal-card:hover {
            transform: translateY(-8px) scale(1.04);
            box-shadow: 0 8px 32px rgba(99,102,241,0.18);
        }
        .portal-card .material-symbols-outlined {
            font-size: 3.5rem;
            /* color: #6366f1; */
            margin-bottom: 18px;
            /* background: linear-gradient(135deg, #6366f1 60%, #818cf8 100%); */
            border-radius: 50%;
            padding: 18px;
            box-shadow: 0 2px 8px rgba(99,102,241,0.10);
        }
        .portal-card-title {
            font-size: 1.25rem;
            font-weight: 600;
            /* color: #3730a3; */
            margin-bottom: 8px;
        }
        .portal-card-link {
            /* color: #6366f1; */
            font-weight: 500;
            text-decoration: none;
            margin-top: 10px;
            transition: color 0.15s;
        }
        .portal-card-link:hover {
            color: #3730a3;
            text-decoration: underline;
        }
        @media (max-width: 900px) {
            .portal-cards {
                flex-direction: column;
                align-items: center;
            }
        }
        /* Subtle fade-in animation */
        .fade-in {
            opacity: 0;
            animation: fadeIn 1.2s ease-in forwards;
        }
        @keyframes fadeIn {
            to { opacity: 1; }
        }
    </style>
</head>

<body class="hold-transition sidebar-mini">
    <div class="wrapper">

        <!-- Main content -->

        <div class="content fade-in">
            <div class="container-fluid p-0">
                <div class="hero-section d-flex flex-column align-items-center justify-content-center" style="position: relative;">
                    <div style="position: absolute; top: 20px; right: 30px; z-index:1;">
                        <a href="logout" title="Logout" style="color: #fff;">
                            <span class="material-symbols-outlined" style="font-size: 2.2rem; vertical-align: middle;">logout</span>
                        </a>
                    </div>
                    <img src="<?php echo isset($_SESSION['photo']) ? '../uploads/'.$_SESSION['photo'] : '../dist/img/avatar.png'; ?>" alt="Profile" style="width: 80px; height: 80px; object-fit: cover; border-radius: 50%; box-shadow: 0 2px 8px rgba(99,102,241,0.15); margin-bottom: 18px; border: 3px solid #fff;">
                    <h1>Welcome, <?= $_SESSION['firstname'] ?>!</h1>
                    <p>Your personalized student portal. Access assignments, results, and more in one beautiful place.</p>
                </div>
                <div class="portal-cards pb-5">
                    <div class="portal-card">
                        <span class="text-white bg-primary material-symbols-outlined">task_alt</span>
                        <div class="portal-card-title">My Assignments</div>
                        <div style="text-align: center;margin-bottom: 10px; color: #64748b; font-size: 0.98rem;">View and complete your latest assignments.</div>
                        <a href="assignments" class="portal-card-link">Go to Assignments &rarr;</a>
                    </div>
                    <div class="portal-card">
                        <span class="text-white bg-primary material-symbols-outlined">emoji_events</span>
                        <div class="portal-card-title">My Results</div>
                        <div style="text-align: center; margin-bottom: 10px; color: #64748b; font-size: 0.98rem;">Check your academic performance and grades.</div>
                        <a href="results" class="portal-card-link">View Results &rarr;</a>
                    </div>
                    <div class="portal-card">
                        <span class="text-white bg-primary material-symbols-outlined">menu_book</span>
                        <div class="portal-card-title">Notes</div>
                        <div style="text-align: center; margin-bottom: 10px; color: #64748b; font-size: 0.98rem;">Access all class notes here</div>
                        <a href="student_class_notes" class="portal-card-link">View Notes &rarr;</a>
                    </div>
                    <div class="portal-card">
                        <span class="text-white bg-primary material-symbols-outlined">quiz</span>
                        <div class="portal-card-title">Practice Questions</div>
                        <div style="text-align: center; margin-bottom: 10px; color: #64748b; font-size: 0.98rem;">Practice by subject, topic, and difficulty.</div>
                        <a href="student_practice" class="portal-card-link">Start Practice &rarr;</a>
                    </div>
                    <div class="portal-card">
                        <span class="text-white bg-primary material-symbols-outlined">person</span>
                        <div class="portal-card-title">My Profile</div>
                        <div style="text-align: center; margin-bottom: 10px; color: #64748b; font-size: 0.98rem;">Update your personal information and settings.</div>
                        <a href="student_portal_profile" class="portal-card-link">Edit Profile &rarr;</a>
                    </div>
                    <!--<div class="portal-card">-->
                    <!--    <span class="text-white bg-primary material-symbols-outlined">account_balance_wallet</span>-->
                    <!--    <div class="portal-card-title">Billing</div>-->
                    <!--    <div style="text-align: center; margin-bottom: 10px; color: #64748b; font-size: 0.98rem;">View your payment history and bills.</div>-->
                    <!--    <a href="" class="portal-card-link">View Billing &rarr;</a>-->
                    <!--</div>-->
                    <div class="portal-card">
                        <span class="text-white bg-primary material-symbols-outlined">logout</span>
                        <div class="portal-card-title">Logout</div>
                        <div style="text-align: center; margin-bottom: 10px; color: #64748b; font-size: 0.98rem;">End the session</div>
                        <a href="logout" class="portal-card-link">Logout &rarr;</a>
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
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <script src="../dist/js/skul.js"></script>
    <script src="../dist/js/report_template_rendering.js"></script>
</body>


</html>
