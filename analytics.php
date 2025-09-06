<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
// $school_id = $_SESSION['school_id'];
$sessions = mysqli_query($conn, "SELECT * FROM sessions ORDER BY id DESC");
$schools = mysqli_query($conn, "SELECT * FROM school WHERE status=1 ORDER BY school_name ASC");
$subjects = mysqli_query($conn, "SELECT * FROM subjects ORDER BY subject ASC");
function get_best_school($conn)
{
    $query = "SELECT 
                sc.school_name,
                ROUND(AVG(
                    CASE 
                        WHEN (
                            (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                        ) > 0
                        THEN (
                            (CASE WHEN sk.ca1Total > 0 THEN (sk.ca1 * 100.0 / sk.ca1Total) ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN (sk.ca2 * 100.0 / sk.ca2Total) ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN (sk.ca3 * 100.0 / sk.ca3Total) ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN (sk.pra * 100.0 / sk.praTotal) ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN (sk.exam * 100.0 / sk.examTotal) ELSE 0 END)
                        ) / (
                            (CASE WHEN sk.ca1Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca2Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.ca3Total > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.praTotal > 0 THEN 1 ELSE 0 END) +
                            (CASE WHEN sk.examTotal > 0 THEN 1 ELSE 0 END)
                        )
                        ELSE 0
                    END
                ), 2) as avg_score
              FROM skulscores sk 
              JOIN school sc ON sk.school_id = sc.id
              WHERE sc.status = 1
              GROUP BY sk.school_id
              HAVING avg_score > 0
              ORDER BY avg_score DESC
              LIMIT 1";

    $result = mysqli_query($conn, $query);
    $row = mysqli_fetch_assoc($result);

    return $row ? $row['school_name'] : 'No data available';
}
?>

<!DOCTYPE html>
<html lang="en" data-theme="light">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Performance Analytics - Admin</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />

    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">

    <style>
        body {
            /* font-family: 'Inter', sans-serif;
            background: var(--background);
            color: var(--text-color); */
            transition: all 0.3s ease;
        }

        .container-fluid {
            padding: 1rem;
            max-width: 1600px;
            margin: 0 auto;
        }


        .nav-pills {
            /* padding: 0.75rem; */
            border-radius: 1rem;
            gap: 0.5rem;
            margin-bottom: 2rem;
        }

        .nav-pills .nav-link {
            border-radius: 0.75rem;
            padding: 0.75rem 1.25rem;
            color: var(--text-color);
            font-weight: 500;
            transition: all 0.3s ease;
            border: 1px solid transparent;
        }

        .nav-pills .nav-link:hover {
            border-color: var(--border-color);
        }

        /* .nav-pills .nav-link.active {
            background: var(--primary-color);
            color: white;
        } */

        .card {
            border: 1px solid var(--border-color);
            border-radius: 1rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .card:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
        }

        .card-header {
            background: var(--card-bg);
            border-bottom: 1px solid var(--border-color);
            padding: 1.25rem;
            border-radius: 1rem 1rem 0 0;
        }

        .form-control,
        .form-select {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            color: var(--text-color);
            border-radius: 0.75rem;
            padding: 0.75rem 1rem;
            transition: all 0.3s ease;
        }

        .form-control:focus,
        .form-select:focus {
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.1);
        }

        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        /* .btn-primary {
            background: var(--primary-color);
            border: none;
        } */

        /* .btn-primary:hover {
            background: var(--secondary-color);
            transform: translateY(-1px);
        } */

        .table {
            border-radius: 0.75rem;
            overflow: hidden;
        }

        .table th {
            background: var(--background);
            color: var(--text-color);
            font-weight: 600;
            border-bottom: 2px solid var(--border-color);
        }


        /* .form-check-input:checked {
            background-color: var(--primary-color);
            border-color: var(--primary-color);
        } */

        @keyframes chartFadeIn {
            from {
                opacity: 0;
                transform: translateY(20px);
            }

            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        canvas {
            animation: chartFadeIn 0.6s ease-out;
        }

        .chart-container {
            position: relative;
            margin: 1rem 0;
            padding: 1rem;
            border-radius: 1rem;
            background: var(--card-bg);
        }

        .performance-metrics {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1rem;
            margin: 1rem 0;
        }

        .performance-insights {
            background: #fff;
            border-radius: 15px;
            padding: 25px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            margin-top: 2rem;
        }

        .performance-insights h5 {
            color: #2c3e50;
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            border-bottom: 2px solid #e9ecef;
            padding-bottom: 0.75rem;
        }

        .insight-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .insight-card {
            background: #f8f9fa;
            padding: 1.25rem;
            border-radius: 12px;
            border-left: 4px solid;
            transition: transform 0.2s ease;
        }

        .insight-card:hover {
            transform: translateY(-3px);
        }

        .insight-card.high {
            border-left-color: #28a745;
        }

        .insight-card.low {
            border-left-color: #dc3545;
        }

        .insight-card.neutral {
            border-left-color: #17a2b8;
        }

        .insight-value {
            font-size: 1.75rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .insight-label {
            color: #6c757d;
            font-size: 0.875rem;
        }

        .trend-analysis {
            margin-top: 2rem;
        }

        .trend-item {
            display: flex;
            align-items: center;
            margin-bottom: 1rem;
            padding: 1rem;
            background: #fff;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }

        .trend-indicator {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            margin-right: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .trend-up {
            background: #28a745;
        }

        .trend-down {
            background: #dc3545;
        }

        .trend-stable {
            background: #17a2b8;
        }

        .recommendations-section {
            margin-top: 2rem;
            background: #f8f9fa;
            border-radius: 12px;
            padding: 1.5rem;
        }

        .recommendation-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .recommendation-item {
            display: flex;
            align-items: flex-start;
            margin-bottom: 1rem;
            padding: 1rem;
            background: white;
            border-radius: 8px;
            border: 1px solid #e9ecef;
        }

        .recommendation-icon {
            width: 32px;
            height: 32px;
            margin-right: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #e3f2fd;
            border-radius: 8px;
            color: #1976d2;
        }

        .metrics-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin: 2rem 0;
        }

        .metric-card {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease;
        }

        .metric-card:hover {
            transform: translateY(-3px);
        }

        .metric-value {
            font-size: 2rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }

        .metric-label {
            color: #6c757d;
            font-size: 0.875rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        @media (max-width: 768px) {
            .insight-grid {
                grid-template-columns: 1fr;
            }

            .metrics-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body class="hold-transition sidebar-mini">
    <div class="wrapper">
        <nav class="main-header navbar border-bottom-0 navbar-expand justify-content-between ml-0 pt-3">
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
                        <img src="../dist/img/company_logo.png" alt="logo" class="brand-image img-circle elevation-3" style="opacity: .8">
                        <span class="brand-text font-weight-light">SchoolSuite360</span>
                    </a>
                </li>
            </ul>

            <!-- Right navbar links -->
            <ul class="navbar-nav align-items-center">
                <li class="nav-item dropdown">
                    <a class="" data-toggle="dropdown" href="#" style="height: auto;">
                        <div class="user-panel d-flex align-items-center">
                            <span class="material-symbols-outlined">arrow_drop_down</span>

                            <div class="info d-none d-sm-inline-block">
                                <p style="font-size: 14px;" class="mb-0 d-block">
                                    <?= $_SESSION['lastname'] . ' ' . $_SESSION['firstname'] ?></p>
                                <p style="font-size: 12px;" class="d-block mb-0 accent">
                                    <?= $_SESSION['email'] ?>
                                </p>
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
        <div class="content-wrapper ml-0" style="min-height: 590.4px; background-color: #f4f7fa; padding-bottom: 100px;">
            <section class="content">
                <div class="container-fluid mb-2">
                    <div class="pt-3 px-15 bg-white" style="border-radius: 10px;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="mb-0" style="font-size: 1.6rem; color: #d0d5ff; font-weight:bold;">Welcome,</h3>
                                <h3 style="font-size: 1.6rem; font-weight:bold;" class="text-primary"><?= $_SESSION['lastname'] . ' ' . $_SESSION['firstname'] ?></h3>
                            </div>
                            <!-- <div>
                                <a href="logout"><span class="material-symbols-outlined" style="background-color: #e5e8ff; padding: 7px; border-radius: 100px;">logout</span></a>
                            </div> -->
                        </div>
                        <div class="mt-4">
                            <div class="d-flex">
                                <div class="info-box align-items-center mb-3" style="min-height: 75px; box-shadow:none;">
                                    <span class="info-box-icon material-symbols-outlined pr-2"
                                        style="font-size: 30px; border-radius: 100% !Important; width: 45px; height: 45px; background-color:#FDF8F1; color:#FF7A3D; border-radius: 15px;">school</span>

                                    <div class="info-box-content" style="line-height: 1;">
                                        <span class="info-box-text muted-text">Best School</span>
                                        <span class="info-box-number"
                                            style="font-size: 24px; line-height:1; color:#343a40;"><?= get_best_school($conn) ?></span>
                                    </div>
                                </div>
                                <!-- /.info-box -->
                            </div>
                        </div>
                    </div>
                </div>
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card">
                                <div class="card-header border-transparent">
                                    <p class="card-title">Student Ranking</p>

                                    <div class="card-tools">
                                        <button type="button" class="btn btn-tool" data-card-widget="maximize">
                                            <i class="fas fa-expand"></i>
                                        </button>
                                    </div>
                                </div>
                                <div class="card-body">
                                <div class="row mb-3 align-items-center">
                                                        <div class="col-md-3">
                                                            <select class="form-control select2" onchange="loadSchoolRankings()" id="sessionSelect3">
                                                                <option value="">Select Session</option>
                                                                <?php mysqli_data_seek($sessions, 0);
                                                                while ($session = mysqli_fetch_array($sessions)): ?>
                                                                    <option value="<?php echo $session['id']; ?>"><?php echo $session['session']; ?></option>
                                                                <?php endwhile; ?>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <select class="form-control select2" onchange="loadStudentRankings()" id="subjectSelect2">
                                                                <option value="">Select Subject</option>
                                                                <?php mysqli_data_seek($subjects, 0);
                                                                while ($subject = mysqli_fetch_array($subjects)): ?>
                                                                    <option value="<?php echo $subject['id']; ?>"><?php echo $subject['subject']; ?></option>
                                                                <?php endwhile; ?>
                                                            </select>
                                                        </div>
                                                    </div>
                                                    <div class="">
                                                        <canvas id="studentRankingsChart"></canvas>
                                                    </div>
                                                    <div class="mt-3">
                                                        <div class="table-responsive">
                                                            <table class="table table-striped" id="studentRankingsTable">
                                                                <thead>
                                                                    <tr>
                                                                        <th>Rank</th>
                                                                        <th>Student</th>
                                                                        <th>School</th>
                                                                        <th>Score</th>
                                                                    </tr>
                                                                </thead>
                                                                <tbody></tbody>
                                                            </table>
                                                        </div>
                                                    </div>
                                </div>
                            </div>

                        </div>
                        <!-- Left col -->
                        <div class="col-md-8">
                            <div class="row">
                                <div class="col-md-12">
                                    <div class="card">
                                        <div class="card-header border-transparent">
                                            <p class="card-title">Performance Metrics</p>

                                            <div class="card-tools">
                                                <button type="button" class="btn btn-tool" data-card-widget="maximize">
                                                    <i class="fas fa-expand"></i>
                                                </button>
                                            </div>
                                        </div>
                                        <!-- /.card-header -->
                                        <div class="card-body">
                                            <!-- Navigation Pills -->
                                            <ul class="nav nav-pills mb-4" id="analytics-tab" role="tablist">
                                                <li class="nav-item">
                                                    <a class="nav-link active" id="rankings-tab" data-bs-toggle="pill" href="#rankings" role="tab">
                                                        <i class="fas fa-trophy me-2"></i> School Rankings
                                                    </a>
                                                </li>
                                                <li class="nav-item">
                                                    <a class="nav-link" id="subject-rankings-tab" data-bs-toggle="pill" href="#subject-rankings" role="tab">
                                                        <i class="fas fa-book me-2"></i> Subject Rankings
                                                    </a>
                                                </li>
                                                <!-- <li class="nav-item">
                                                    <a class="nav-link" id="student-rankings-tab" data-bs-toggle="pill" href="#student-rankings" role="tab">
                                                        <i class="fas fa-user-graduate me-2"></i> Top Students
                                                    </a>
                                                </li> -->
                                                <!-- <li class="nav-item">
                                                    <a class="nav-link" href="#school-performance" data-bs-toggle="pill">
                                                        <i class="fas fa-chart-line me-2"></i> Performance Metrics
                                                    </a>
                                                </li> -->
                                            </ul>

                                            <!-- Tab Content -->
                                            <div class="tab-content" id="analytics-content">
                                                <!-- Overall School Rankings -->
                                                <div class="tab-pane fade show active" id="rankings" role="tabpanel">
                                                    <div class="row mb-3 align-items-center">
                                                        <div class="col-md-3">
                                                            <select class="form-control select2" id="sessionSelect1">
                                                                <option value="">Select Session</option>
                                                                <?php mysqli_data_seek($sessions, 0);
                                                                while ($session = mysqli_fetch_array($sessions)): ?>
                                                                    <option value="<?php echo $session['id']; ?>"><?php echo $session['session']; ?></option>
                                                                <?php endwhile; ?>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <button class="btn accent font-weight-normal" id="selectSchools1"><i class="fas fa-plus"></i> Select Schools</button>
                                                        </div>
                                                    </div>
                                                    <div class="">
                                                        <canvas id="rankingsChart"></canvas>
                                                    </div>

                                                    <!-- <div class="mt-3">
                                                        <h4>Summary</h4>
                                                        <div id="rankingsSummary"></div>
                                                        <h4>Recommendations</h4>
                                                        <div id="rankingsRecommendations"></div>
                                                    </div> -->
                                                </div>

                                                <!-- Subject Rankings -->
                                                <div class="tab-pane fade" id="subject-rankings" role="tabpanel">
                                                    <div class="row mb-3 align-items-center">
                                                        <div class="col-md-3">
                                                            <select class="form-control select2" id="sessionSelect2">
                                                                <option value="">Select Session</option>
                                                                <?php mysqli_data_seek($sessions, 0);
                                                                while ($session = mysqli_fetch_array($sessions)): ?>
                                                                    <option value="<?php echo $session['id']; ?>"><?php echo $session['session']; ?></option>
                                                                <?php endwhile; ?>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-3">
                                                            <select class="form-control select2" id="subjectSelect1">
                                                                <option value="">Select Subject</option>
                                                                <?php mysqli_data_seek($subjects, 0);
                                                                while ($subject = mysqli_fetch_array($subjects)): ?>
                                                                    <option value="<?php echo $subject['id']; ?>"><?php echo $subject['subject']; ?></option>
                                                                <?php endwhile; ?>
                                                            </select>
                                                        </div>
                                                        <div class="col-md-4">
                                                            <button class="btn accent font-weight-normal" id="selectSchools2"><i class="fas fa-plus"></i> Select Schools</button>
                                                        </div>
                                                    </div>
                                                    <div class="">
                                                        <canvas id="subjectRankingsChart"></canvas>
                                                    </div>
                                                    <!-- <div class="mt-3">
                                                        <h4>Summary</h4>
                                                        <div id="subjectRankingsSummary"></div>
                                                        <h4>Recommendations</h4>
                                                        <div id="subjectRankingsRecommendations"></div>
                                                    </div> -->
                                                </div>

                                                <!-- Student Rankings -->
                                                <div class="tab-pane fade" id="student-rankings" role="tabpanel">
                                                    
                                                </div>

                                                <!-- School Performance Metrics -->
                                                <!-- <div class="tab-pane fade" id="school-performance">
                                                    <div class="card">
                                                        <div class="card-header">
                                                            <ul class="nav nav-pills">
                                                                <li class="nav-item">
                                                                    <a class="nav-link active" data-bs-toggle="pill" href="#overall-performance"><i class="fas fa-chart-line"></i> Overall Performance</a>
                                                                </li>
                                                                <li class="nav-item">
                                                                    <a class="nav-link" data-bs-toggle="pill" href="#subject-performance"><i class="fas fa-book"></i> Subject Based Performance</a>
                                                                </li>
                                                            </ul>
                                                        </div>
                                                        <div class="card-body">
                                                            <div class="tab-content">
                                                                <div class="tab-pane fade show active" id="overall-performance">
                                                                    <div class="row mb-3">
                                                                        <div class="col-md-3">
                                                                            <select class="form-control" id="overall-school-select">
                                                                                <option value="">Select School</option>
                                                                            </select>
                                                                        </div>
                                                                        <div class="col-md-3">
                                                                            <select class="form-control" id="overall-session-select">
                                                                                <option value="">Select Session</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <canvas id="overallPerformanceChart"></canvas>
                                                                </div>
                                                                <div class="tab-pane fade" id="subject-performance">
                                                                    <div class="row mb-3">
                                                                        <div class="col-md-3">
                                                                            <select class="form-control" id="subject-school-select">
                                                                                <option value="">Select School</option>
                                                                            </select>
                                                                        </div>
                                                                        <div class="col-md-3">
                                                                            <select class="form-control" id="subject-session-select">
                                                                                <option value="">Select Session</option>
                                                                            </select>
                                                                        </div>
                                                                        <div class="col-md-3">
                                                                            <select class="form-control" id="subject-select">
                                                                                <option value="">Select Subject</option>
                                                                            </select>
                                                                        </div>
                                                                    </div>
                                                                    <canvas id="subjectPerformanceChart"></canvas>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div> -->
                                            </div>
                                        </div>

                                        <!-- /.card-footer -->
                                    </div>
                                </div>
                                <!-- /.col -->
                            </div>
                            <!-- /.row -->

                        </div>
                        <!-- /.col -->


                        <!-- /.col -->
                    </div>



                    <!-- school based performance -->
                    <div>
                        <div class="card">
                            <div class="card-header border-transparent">
                                <p class="card-title">School Based Performance</p>

                                <div class="card-tools">
                                    <button type="button" class="btn btn-tool" data-card-widget="maximize">
                                        <i class="fas fa-expand"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="card-body">
                                <ul class="nav nav-pills" role="tablist">
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link active" data-toggle="tab" data-target="#overall-performance" type="button" role="tab" aria-controls="overall-performance" aria-selected="true">
                                            <i class="fas fa-chart-line"></i> Overall Performance
                                        </button>
                                    </li>
                                    <li class="nav-item" role="presentation">
                                        <button class="nav-link" data-toggle="tab" data-target="#subject-performance" type="button" role="tab" aria-controls="subject-performance" aria-selected="false">
                                            <i class="fas fa-book"></i> Subject Based Performance
                                        </button>
                                    </li>
                                </ul>
                                <div class="tab-content" id="performance-tab-content">
                                    <div class="tab-pane fade show active" id="overall-performance" role="tabpanel" aria-labelledby="overall-performance-tab">
                                        <div class="row mb-3">
                                            <div class="col-md-3">
                                                <select class="form-control select2" id="overall-school-select">
                                                    <option value="">Select School</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <select class="form-control select2" id="overall-session-select">
                                                    <option value="">Select Session</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div style="height:480px;">
                                            <canvas id="performanceTrendChart" style=""></canvas>
                                        </div>
                                        <div id="performance-insights" class="mt-4"></div>
                                        <div id="performance-summary" class="mt-3"></div>
                                        <!-- <canvas id="overallPerformanceChart"></canvas> -->
                                    </div>
                                    <div class="tab-pane fade" id="subject-performance" role="tabpanel" aria-labelledby="subject-performance-tab">
                                        <div class="row mb-3">
                                            <div class="col-md-3">
                                                <select class="form-control select2" id="subject-school-select">
                                                    <option value="">Select School</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <select class="form-control select2" id="subject-session-select">
                                                    <option value="">Select Session</option>
                                                </select>
                                            </div>
                                            <div class="col-md-3">
                                                <select class="form-control select2" id="subject-select">
                                                    <option value="">Select Subject</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div style="height:480px;">
                                        <canvas id="subjectPerformanceChart"></canvas>
                                        </div>
                                    </div>
                                    <div id="subject-performance-insights" class="mt-4"></div>
                                    <div id="subject-performance-metrics" class="mt-3"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- School Selection Modal -->
                <div class="modal fade" id="schoolSelectionModal" tabindex="-1">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title"><i class="fas fa-school"></i> Select Schools</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <div class="icheck-gray-dark mb-2">
                                    <input class="form-check-input" type="checkbox" id="selectAllSchools">
                                    <label class="form-check-label" for="selectAllSchools">Select All</label>
                                </div>
                                <hr>
                                <div id="schoolCheckboxes">
                                    <?php mysqli_data_seek($schools, 0);
                                    while ($school = mysqli_fetch_array($schools)): ?>
                                        <div class="form-check icheck-gray-dark">
                                            <input class="form-check-input school-checkbox" type="checkbox" value="<?php echo $school['id']; ?>" id="school<?php echo $school['id']; ?>">
                                            <label class="form-check-label" for="school<?php echo $school['id']; ?>">
                                                <?php echo $school['school_name']; ?>
                                            </label>
                                        </div>
                                    <?php endwhile; ?>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                <button type="button" class="btn btn-primary" id="applySchoolSelection">Apply</button>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>


    <!-- jQuery -->
    <script src="../plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- Select2 -->
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <!-- AdminLTE App -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <!-- Load the annotation plugin after Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation@latest/dist/chartjs-plugin-annotation.min.js"></script>

    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-datalabels@2"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-colorschemes"></script>
    <script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-zoom"></script>
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <script src="../dist/js/adminlte.min.js"></script>
    <script src="../dist/js/analytics.js?v=0912"></script>
    <script>
        // Initialize tooltips
        $(function() {
            $('[data-toggle="tooltip"]').tooltip();
        });
        // Initialize Select2
        $(document).ready(function() {
            $('.select2').select2({
                // theme: 'bootstrap4',
                // placeholder: 'Select an option',
                // allowClear: true
            });
        });
    </script>
</body>

</html>