<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
// exit;
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
// $parent_id = $_SESSION['userid'];
$student_id = $_GET['id'];
$date = date("Y-m-d");
$school_settings = json_decode($_SESSION['skul_settings'], true);
$first_term = $school_settings['first'];
$second_term = $school_settings['second'];
$third_term = $school_settings['third'];
// $first_term_class = ($date >= $school_settings['first'] && $date <= $school_settings['second']) ? "active" : '';
// $second_term_class = ($date >= $school_settings['second'] && $date < $school_settings['third']) ? "active" : '';
// $third_term_class = $date >= $school_settings['third'] ? "active" : '';
// elseif($date >= $school_settings['second'] && $date <= $school_settings['third'] ) {
//     echo "second";
// }elseif($date >= $school_settings['third']) {
//     echo "third";
// }
// exit;
$data = [];
// echo $_GET['id'];
// exit;

$select = mysqli_query($conn, "SELECT s.*,c.classname,
p.firstname as p_firstname,p.lastname as p_lastname,
p.phone as p_phone,p.email as p_email,p.city,p.state,
p.address as p_address,p.country FROM students s, class c, 
parent p WHERE p.id=s.parent_id AND s.class_id=c.id AND 
s.school_id='$school_id' AND 
s.id='{$_GET['id']}'");

while ($row = mysqli_fetch_array($select)) {
    $data[] = array(
        'photo' => $row['photo'],
        'id' => $row['id'],
        'classname' => $row['classname'],
        'firstname' => $row['firstname'],
        'lastname' => $row['lastname'],
        'middlename' => $row['middlename'] == '' ? '' : $row['middlename'],
        'class_id' => $row['class_id'],
        'dob' => $row['dob'],
        'gender' => $row['gender'] == '' ? 'Nil' : $row['gender'],
        'phone' => $row['phone'] == '' ? 'Nil' : $row['phone'],
        'email' => $row['email'] == '' ? 'Nil' : $row['email'],
        'datecreated' => $row['datecreated'],
        'parent_id' => $row['parent_id'],
        'p_firstname' => $row['p_firstname'] == '' ? 'Nil' : $row['p_firstname'],
        'p_lastname' => $row['p_lastname'] == '' ? 'Nil' : $row['p_lastname'],
        'p_phone' => $row['p_phone'],
        'p_email' => $row['p_email'],
        'p_address' => $row['p_address'] == '' ? 'Nil' : $row['p_address'],
    );
}
// print_r($data);
// print_r($row);
// exit;
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= $data[0]['lastname'] . ' ' . $data[0]['firstname'] ?></title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <!-- Select2 -->
    <style>
        .select2selector .select2-container {
            display: none !important;
        }

        .knob {
            font: bold 20px Arial !important;
            /* Adjust the font size */
        }

        .subjectselect .select2-selection.select2-selection--single {
            border: none;
        }

        .select_student.active {
            box-shadow: 7px 10px 10px #eaeaea !important;
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
            border: none;
            padding: 5px;
            text-align: left;
        }

        th {
            border: none;
            background-color: transparent;
        }

        .scrollable-container table {
            min-width: 600px;
            /* Adjust based on your content */
        }

        .floating-btn {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 15px;
            border-radius: 50%;
            cursor: pointer;
            box-shadow: 0px 4px 6px rgba(0, 0, 0, 0.1);
        }

        .floating-btn:hover {
            background-color: #0056b3;
        }

        .overlay {
            position: absolute;
            width: 100%;
            height: 100%;
            background: white;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 16px;
            z-index: 1000;
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
                            <a href="students" class="nav-link active">
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
                            <a href="communication" class="nav-link">
                                <p class="d-flex">
                                    <i class="material-symbols-outlined pr-2" style="font-size: 20px;">hub</i>
                                    Communication
                                </p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="reports" class="nav-link">
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
        <!-- Main Sidebar Container -->


        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper" style="background-color: #f4f7fa; padding-bottom: 100px;">

            <!-- <div class="container-fluid">
                <div class="row m-0">
                    <div class="col-sm-6 row ml-0">
                        <div class="mr-2">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <a href="students" class="accent">Back</a>
                            </div>
                        </div>
                        <div class="">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="">
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>
                                            </a>
                                        </li>
                                        <li class="breadcrumb-item active font-14"><a href="students">Students</a></li>
                                        <li class="breadcrumb-item active font-14">Profile</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div> -->
            <!-- Main content -->
            <div class="container-fluid">
                <div class="row m-0">
                    <div class="col-sm-6 row ml-0">
                        <div class="mr-2">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <a href="javascript:history.back()" class="accent">Back</a>
                                <!-- <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i></a> -->
                            </div>
                        </div>
                        <div class="">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="">
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent" style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1" style="font-size: 19px;">dashboard</i>
                                            </a>
                                        </li>
                                        <li class="breadcrumb-item active font-14"><a href="students">Students</a></li>
                                        <li class="breadcrumb-item active font-14">Profile</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="content">
                <!-- do not delete the input hidden, it is used to identify the page in js file -->
                <input type="hidden" id="report_page" value="report_scores">
                <div class="d-none">
                    <ul class="select2selector nav nav-pills menu-scrollbar pb-sm-3" id="pills-tab" role="tablist" style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
                        <input type="hidden" id="select_student_field" style="display: none;" class="" value="<?= $_GET['id'] ?>">
                        <input type="hidden" id="select_class_field" class="" value="<?= $data[0]['class_id'] ?>">
                        <!--<input type="hidden" id="select_session_field" class="session_value" value="<?= $school_settings['session']; ?>">-->
                    </ul>
                </div>
                <!-- <div class="container-fluid mb-2">
                    <div class="pt-3 px-15 bg-white" style="border-radius: 10px;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 style="font-size: 1.6rem; font-weight:bold;" class="text-primary"><?= $_SESSION['lastname'] . ' ' . $_SESSION['firstname'] ?></h3>
                            </div>
                        </div>
                    </div>
                </div> -->
                <div class="row mx-0 mt-3">
                    <div class="container-fluid col-12 col-md-3 mb-3" id="">
                        <div class="py-3 px-15 bg-white space_content_box" style="border-radius: 10px; position: relative">
                            <div class="text-left float-left w-100 mb-3">
                                <img class="profile-user-img img-fluid img-circle"
                                    src="../uploads/<?= $data[0]['photo'] ?>"
                                    alt="User profile picture">
                            </div>
                            <div>
                                <h3 style="font-size: 1.3rem; font-weight:bold;" class="text-primary"><?= $data[0]['lastname'] . ' ' . $data[0]['firstname'] . ' ' . $data[0]['middlename'] ?></h3>
                                <!-- <h3 style="font-size: 1.6rem; font-weight:bold;" class="text-primary"><?= $data[0]['lastname'] . ' ' . $data[0]['firstname'] . ' ' . $data[0]['middlename'] ?></h3> -->
                            </div>
                            <p class="font-weight-bold muted-text">Basic Data</p>
                            <div class="d-flex justify-content-between flex-wrap mt-2" style="column-gap: 40px; row-gap: 10px;">
                                <!-- <div class="">
                                    <p class="font-weight-bold small muted-text">Name</p>
                                    <p class="name"><?= $data[0]['lastname'] . ' ' . $data[0]['firstname'] . ' ' . $data[0]['middlename'] ?></p>
                                </div> -->
                                <div class="">
                                    <p class="font-weight-bold small muted-text">Class</p>
                                    <p class="classname"><?= $data[0]['classname'] ?></p>
                                </div>
                                <div class="">
                                    <p class="font-weight-bold small muted-text">Gender</p>
                                    <p class="gender"><?= $data[0]['gender'] ?></p>
                                </div>
                                <div class="">
                                    <p class="font-weight-bold small muted-text">Date of Birth</p>
                                    <p class="dob"><?= $data[0]['dob'] == '0000-00-00' ? 'Not stated' : $data[0]['dob'] ?></p>
                                </div>
                                <!-- /.card-body -->
                            </div>
                            <!-- /.card -->
                            <div class="accordion" id="accordhead">
                                <div class="card" style="box-shadow: none;">
                                    <div class="card-header p-0 w-100 border-0">
                                        <button onclick="toggle_accordion(this)" class="btn btn-link accent text-left w-100 px-0 pb-3 py-0" type="button" data-toggle="collapse" data-target="#accordone">Show more<i class="ml-2 fas fa-plus"></i></button>
                                    </div>
                                    <div id="accordone" class="collapse" data-parent="#accordhead">
                                        <div class="card-body p-0">
                                            <p class="font-weight-bold muted-text">Contact Information</p>
                                            <div class="d-flex justify-content-between flex-wrap mt-2" style="column-gap: 40px; row-gap: 10px;">
                                                <div class="">
                                                    <p class="font-weight-bold small muted-text">Email address</p>
                                                    <p class="email"><?= $data[0]['email'] ?></p>
                                                </div>
                                                <div class="">
                                                    <p class="font-weight-bold small muted-text">Phone number</p>
                                                    <p class="phone"><?= $data[0]['phone'] ?></p>
                                                </div>
                                            </div>
                                            <div class="hr mt-3" style="height: 10px; width: 100%; background-color: #ededed;"></div>
                                            <p class="font-weight-bold muted-text mt-3">Parent Information</p>
                                            <div class="d-flex justify-content-between flex-wrap mt-2" style="column-gap: 40px; row-gap: 20px;">
                                                <div class="">
                                                    <p class="font-weight-bold small muted-text">Parent name</p>
                                                    <p class="p_name"><?= $data[0]['p_firstname'] . ' ' . $data[0]['p_lastname'] ?></p>
                                                </div>
                                                <div class="">
                                                    <p class="font-weight-bold small muted-text">Phone number</p>
                                                    <p class="p_phone"><?= $data[0]['p_phone'] ?></p>
                                                </div>
                                                <div class="">
                                                    <p class="font-weight-bold small muted-text">Email address</p>
                                                    <p class="p_email"><?= $data[0]['p_email'] ?></p>
                                                </div>
                                                <div class="">
                                                    <p class="font-weight-bold small muted-text">Address</p>
                                                    <p class="p_address"><?= $data[0]['p_address'] ?></p>
                                                </div>
                                            </div>
                                            <div class="hr mt-3" style="height: 10px; width: 100%; background-color: #ededed;"></div>
                                            <div id="qrcode_image" class="mt-5"></div>
                                            <div class="mt-2 d-flex gap-2">
                                                <button id="download_qr_btn" class="btn select_btn mr-3" style="display: none;" title="Download QR Code">
                                                    <i class="fas fa-download"></i>
                                                </button>
                                                <button id="share_qr_btn" class="btn select_btn" style="display: none;" title="Share QR Code">
                                                    <i class="fas fa-share-alt"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="container-fluid col-md-9">
                        <div class="py-3 px-15 bg-white data_overlay" style="height:300px; border-radius: 10px; position: relative">
                            <p class="font-weight-bold">Loading...</p>
                        </div>
                        <div class="thecontentbox" style="display: none;">
                            <div class="container-fluid" id="">
                                <div class="py-3 px-15 bg-white space_content_box" style="border-radius: 10px; position: relative">
                                    <!-- <div id=""> -->
                                    <div class="input-group mb-3 d-flex align-items-md-center align-items-start" style="width: 300px;">
                                        <label for="" class="mb-0 mr-2 text-muted">Select Session:</label>
                                        <select class="form-control select2" onchange="get_score_data()" id="select_session_field" style="width: 50%;">
                                            <?php
                                            $select = mysqli_query($conn, "SELECT id,session FROM sessions ORDER BY session ASC");
                                            while ($row = mysqli_fetch_array($select)) {
                                                if ($row['id'] == $_SESSION['session_id']) {
                                                    echo '<option value="' . $row['id'] . '" selected>' . $row['session'] . '</option>';
                                                } else {
                                            ?>
                                                    <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                            <?php
                                                }
                                            }
                                            ?>
                                        </select>
                                    </div>
                                    <div id="filterTerm" class="w-100">
                                        <ul class="menu-scrollbar px-0" id="" role="" style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
                                            <button class="btn select_btn term my-1 <?= $_SESSION['term_id'] == '1' ? 'active' : '' ?> mr-2" data-name="1" id="first" onclick="toggletermfilterClass(this)">1st Term</button>
                                            <button class="btn select_btn term my-1 <?php echo ($_SESSION['term_id'] == '2') ? 'active' : ''; ?> mr-2" data-name="2" id="second" onclick="toggletermfilterClass(this)">2nd Term</button>
                                            <button class="btn select_btn term my-1 <?php echo ($_SESSION['term_id'] == '3') ? 'active' : ''; ?> mr-2" data-name="3" id="third" onclick="toggletermfilterClass(this)">3rd Term</button>
                                            <button class="btn select_btn term my-1 mr-2" data-name="summary" id="summary" onclick="toggletermfilterClass(this)">Summary</button>
                                        </ul>
                                    </div>
                                    <div class="d-flex align-items-center">
                                        <button type="button" style="padding: 4px 1px 0px 2px; background-color:white; border-radius: 5px; border:none;"
                                            id="table_visual_Score_toggle" class="table_display d-flex accent"
                                            onclick="table_visual_Score_toggle(this)">
                                            <i class="material-symbols-outlined mr-1">legend_toggle</i> Show Chart
                                        </button>

                                    </div>
                                    <!-- </div> -->
                                    <div id="table_visuals_display" class="pt-3">

                                    </div>
                                    <div class="line_and_term_based_contents">
                                        <div class="hr my-4" style="height: 10px; width: 100%; background-color: #ededed;"></div>
                                        <div class="d-flex flex-wrap" style="gap: 20px;">
                                            <div id="view_teacher_comment_container" class="mr-5">
                                                <p class="font-weight-bold text-muted">Teacher's Comment</p>
                                                <p class="" id="theteacher_comment"></p>
                                            </div>
                                            <div id="view_principal_comment_container" class="mr-5">
                                                <p class="font-weight-bold text-muted">Principal/Propietor's Comment</p>
                                                <p class="" id="theprincipal_comment"></p>
                                            </div>
                                            <div class="mr-5">
                                                <p class="font-weight-bold text-muted">General Behaviour</p>
                                                <table class="behaviour_report_table w-100">
                                                    <thead>
                                                        <tr class="d-none">
                                                            <th></th>
                                                            <th></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>Punctuality</td>
                                                            <td class="punctuality"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Classroom attendance</td>
                                                            <td class="classattendance"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Response to assignment</td>
                                                            <td class="resptoass"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Neatness</td>
                                                            <td class="Neatness"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Politeness</td>
                                                            <td class="Politeness"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Honesty</td>
                                                            <td class="Honesty"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Self control</td>
                                                            <td class="selfcontrol"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Relationship with others</td>
                                                            <td class="relationship"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Organizational Ability</td>
                                                            <td class="organizationability"></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <div>
                                                <p class="font-weight-bold text-muted">Psychomotive Skills</p>
                                                <table class="behaviour_report_table w-100">
                                                    <thead>
                                                        <tr class="d-none">
                                                            <th></th>
                                                            <th></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr>
                                                            <td>Obedience</td>
                                                            <td class="Obedience"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Creativity</td>
                                                            <td class="Creativity"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Writing</td>
                                                            <td class="Writing"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Fluency</td>
                                                            <td class="Fluency"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Sport</td>
                                                            <td class="Sport"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Games</td>
                                                            <td class="Games"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Drawing & Painting</td>
                                                            <td class="DrawingPainting"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Music Performance</td>
                                                            <td class="Music"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Handling Tools</td>
                                                            <td class="HandlingTools"></td>
                                                        </tr>
                                                        <tr>
                                                            <td>Craft</td>
                                                            <td class="Crafts"></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                         <button class="btn accent font-weight-bold w-100 btn-md-auto" id="preview-pdf" onclick="preview_report_card_multiple('student_page','term')">Print Student Report Card</button>
                                        <button class="btn accent font-weight-bold w-100 btn-md-auto" id="preview-pdf" onclick="preview_report_card_multiple('student_page','session')">Print Student Cumulative Report Card</button>
                                  
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
             

            </div>
            <!-- /.row -->
        </div>
    </div>
    <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->


    </div>
    <div class="modal fade" id="subject_full_record">
        <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header" style="padding: 5px 45px 5px 15px !important;">
                    <div class="d-flex flex-wrap">
                        <div class="form-group m-0">
                            <select name="" id="termSubjectValue" onchange="getsingleSessionReport()" class="form-control subjectselect select2 border-0 p-0" id="">
                                <?php
                                $select = mysqli_query($conn, "SELECT id, subject FROM subjects ORDER BY subject ASC");
                                while ($row = mysqli_fetch_array($select)) {
                                ?>
                                    <option value="<?= $row['id'] ?>"><?= $row['subject'] ?></option>
                                <?php } ?>
                            </select>
                        </div>
                        <div class="form-group m-0">
                            <select name="" id="singleSessionValue" onchange="getsingleSessionReport()" class="form-control subjectselect select2 border-0 p-0" id="">
                                <?php
                                $select = mysqli_query($conn, "SELECT id, session FROM sessions ORDER BY session ASC");
                                while ($row = mysqli_fetch_array($select)) {
                                ?>
                                    <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                <?php } ?>
                            </select>
                        </div>
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close" style="top: 15px;position: absolute;right: 15px;">
                            <span aria-hidden="true">×</span>
                        </button>
                    </div>
                </div>
                <div class="modal-body">

                    <div class="mt-4">
                        <div class="" id="overall_performance"></div>
                        <div class="" id="score_chart"></div>
                        <!-- <div class="position-relative mb-4">
                            <canvas id="visitors-chart" height="200"></canvas>
                        </div> -->
                        <div class="row justify-content-between">
                            <div class="mt-3 col-12 col-sm-3" id="student_term1_report"></div>
                            <div class="mt-3 col-12 col-sm-3" id="student_term2_report"></div>
                            <div class="mt-3 col-12 col-sm-3" id="student_term3_report"></div>
                        </div>
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
                        <p class="mt-2">Generating report cards...</p>
                        <p class="loading-status">Loading report 0 of 0...</p>
                    </div>
                    <div id="preview-content"></div>
                </div>
                <div class="modal-footer">
                    
                    <!-- <button type="button" class="btn btn-primary" onclick="generatePDF('<= $data[0]['lastname'] . ' ' . $data[0]['firstname'] . ' ' . $data[0]['middlename'] ?>')">Download</button> -->

                    <button type="button" id="print-button" class="btn btn-primary" onclick="printReports()" disabled>
                        <i class="fas fa-print mr-1"></i> Print Reports
                    </button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <!--<div class="modal fade" id="preview_report_card_modal">-->
    <!--    <div class="modal-dialog modal-xl modal-dialog-scrollable modal-dialog-centered">-->
    <!--        <div class="modal-content">-->
    <!--            <div class="modal-body py-0">-->
    <!--                <div class="bg-white" id="pdf-content"></div>-->
    <!--                <div class="card-foot" id="preview_report_card_foot" style="display: none;">-->
    <!--                    <button type="button" class="btn btn-primary" onclick="generatePDF()">Download</button>-->
    <!--                    <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Cancel</button>-->
    <!--                </div>-->
    <!--            </div>-->
    <!--        </div>-->
    <!--    </div>-->
    <!--</div>-->
    <!-- ./wrapper -->

    <!-- REQUIRED SCRIPTS -->

    <!-- jQuery -->
    <script src="../plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <!-- Select2 -->
    <!-- jQuery Knob -->
    <script src="../plugins/jquery-knob/jquery.knob.min.js"></script>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>
    <script src="../plugins/chart.js/Chart.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js" integrity="sha512-CNgIRecGo7nphbeZ04Sc13ka07paqdeTu0WR1IM4kNcpmBAUSHSQX0FslNhTDadL4O5SAGapGt4FodqL8My0mA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script>
        var skul_settings = <?= $_SESSION['skul_settings'] ?>;
        let loadedReports = 0;
        let totalReports = 0;
        // alert("l")
        // get_score_data()
    </script>
    <script src="../dist/js/skul.js?v=033"></script>
    <script>
        let class_id = <?= $data[0]['class_id'] ?>;
        let student_id = <?= $data[0]['id'] ?>;
        let school_id = <?= $_SESSION['school_id'] ?>;
        let myschl = school_id;
        let photo = '<?= $data[0]['photo'] ?>';
        let firstname = '<?= $data[0]['firstname'] ?>';
        let lastname = '<?= $data[0]['lastname'] ?>';
        let classname = '<?= $data[0]['classname'] ?>';

        // Generate QR code content in JSON format
        const studentData = {
            id: student_id,
            firstname: firstname,
            lastname: lastname,
            class: classname,
            photo: photo,
            school_id: school_id,
            class_id: class_id
        };

        // Create QR code with the JSON data
        const qrcode = new QRCode(document.getElementById("qrcode_image"), {
            text: JSON.stringify(studentData),
            width: 256, // Increased size for better readability
            height: 256,
            colorDark: "#000000",
            colorLight: "#ffffff",
            correctLevel: QRCode.CorrectLevel.L // Changed to Low for better detection
        });

        // Optional: Add a download button for the QR code
        // document.getElementById("qrcode_image").addEventListener("click", function() {
        //     const qrImage = document.querySelector("#qrcode_image img");
        //     if (qrImage) {
        //         const link = document.createElement("a");
        //         link.download = `qr_${lastname}_${firstname}.png`;
        //         link.href = qrImage.src;
        //         link.click();
        //     }
        // });
        
        // Show download button once QR code is generated
        setTimeout(() => {
            document.getElementById("download_qr_btn").style.display = "block";
            document.getElementById("share_qr_btn").style.display = "block";
        }, 500);

        // Handle download button click
        document.getElementById("download_qr_btn").addEventListener("click", function() {
            const qrImage = document.querySelector("#qrcode_image img");
            if (qrImage) {
                const link = document.createElement("a");
                link.download = `qr_${lastname}_${firstname}.png`;
                link.href = qrImage.src;
                link.click();
            }
        });
        // Handle share button click
        document.getElementById("share_qr_btn").addEventListener("click", async function() {
            const qrImage = document.querySelector("#qrcode_image img");
            if (qrImage) {
                try {
                    // Convert the QR code image to a blob
                    const response = await fetch(qrImage.src);
                    const blob = await response.blob();
                    const file = new File([blob], `qr_${lastname}_${firstname}.png`, { type: 'image/png' });

                    // Check if Web Share API is supported
                    if (navigator.share) {
                        await navigator.share({
                            title: `QR Code for ${firstname} ${lastname}`,
                            text: 'Student QR Code',
                            files: [file]
                        });
                    } else {
                        alert('Web Share API is not supported in your browser. You can download the QR code instead.');
                    }
                } catch (error) {
                    console.error('Error sharing:', error);
                    alert('Unable to share the QR code. You can download it instead.');
                }
            }
        });
        
        //  function printdocument() {
        //     // Get the content to print
        //     const contentToPrint = document.getElementById('pdf-content');
            
        //     // Create a new window for printing
        //     const printWindow = window.open('', '', 'height=600,width=1200');
            
        //     // Add the content and necessary styles to the new window
        //     printWindow.document.write('<html><head><title>Report Card</title>');
        //     printWindow.document.write('<link rel="stylesheet" href="../dist/css/adminlte.css">');
        //     printWindow.document.write('<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">');
        //     printWindow.document.write('<style>@media print { body { padding: 0; margin: 0; } }</style>');
        //     printWindow.document.write('</head><body>');
        //     printWindow.document.write(contentToPrint.innerHTML);
        //     printWindow.document.write('</body></html>');
            
        //     printWindow.document.close();
            
        //     // Wait for the styles to load
        //     printWindow.onload = function() {
        //         printWindow.focus();
        //         printWindow.print();
        //         printWindow.close();
        //     };
        // }
    </script>

    <!-- <script>
        $(document).ready(function() {
            $(document).ready(function() {
                $('#user_table').DataTable({
                    // scrollY: 200,
                    // scrollX: true,
                });
            });
            $('#attendance_table').DataTable({
                scrollY: '50vh',
                scrollX: true,
                scrollCollapse: true,
                paging: false,
                fixedColumns: {
                    left: 2,
                    right: 0
                }
            });
        });
    </script> -->
</body>

</html>