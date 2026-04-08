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
$parent_id = $_SESSION['userid'];
$date = date("Y-m-d");
$school_settings = json_decode($_SESSION['skul_settings'], true);
$first_term = $school_settings['first'];
$second_term = $school_settings['second'];
$third_term = $school_settings['third'];
// $first_term_class = ($date >= $snchool_settings['first'] && $date <= $school_settings['second']) ? "active" : '';
// $second_term_class = ($date >= $school_settings['second'] && $date < $school_settings['third']) ? "active" : '';
// $third_term_class = $date >= $school_settings['third'] ? "active" : '';
// elseif($date >= $school_settings['second'] && $date <= $school_settings['third'] ) {
//     echo "second";
// }elseif($date >= $school_settings['third']) {
//     echo "third";
// }
// exit;
$data = [];
$select = mysqli_query($conn, "SELECT s.*,c.classname,p.firstname as p_firstname,p.lastname as p_lastname,p.phone as p_phone,p.email as p_email,p.city,p.state,p.address as p_address,p.country FROM students s, class c, parent p WHERE p.id=s.parent_id AND s.class_id=c.id AND s.school_id='$school_id' AND s.parent_id='$parent_id'");
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
    <title>Parent Portal | <?= $_SESSION['lastname'] . ' ' . $_SESSION['firstname'] ?></title>

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

        table.behaviour_report_table td:nth-child(2) {
            text-align: right;
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

        .btn-print-report {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 7px 18px;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.3px;
            color: #fff;
            background: linear-gradient(135deg, #1e1f20 0%, #000000 60%, #3a3a3a 100%);
            border: none;
            border-radius: 50px;
            box-shadow: 0 3px 10px rgba(0, 123, 255, 0.35);
            cursor: pointer;
            transition: transform 0.15s ease, box-shadow 0.15s ease, filter 0.15s ease;
        }

        .btn-print-report:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 18px rgba(0, 123, 255, 0.45);
            filter: brightness(1.08);
        }

        .btn-print-report:active {
            transform: translateY(0);
            box-shadow: 0 2px 6px rgba(0, 123, 255, 0.3);
            filter: brightness(0.96);
        }

        .btn-print-report i {
            font-size: 0.85em;
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
                            <!-- Menu icon for small screens -->
                            <span class="material-symbols-outlined">arrow_drop_down</span>
                            <span class="material-symbols-outlined d-inline-block d-sm-none">segment</span>

                            <!-- User panel for larger screens -->
                            <div class="d-none d-sm-flex align-items-center">
                                <!-- <span class="material-symbols-outlined">arrow_drop_down</span> -->
                                <div class="info">
                                    <p style="font-size: 14px;" class="mb-0 d-block">
                                        <?= $_SESSION['firstname'] . ' ' . $_SESSION['lastname'] ?></p>
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


            <!-- Main content -->
            <div class="content">
                <!-- do not delete the input hidden, it is used to identify the page in js file -->
                <input type="hidden" id="report_page" value="report_scores">
                <div class="container-fluid mb-2">
                    <div class="pt-3 px-15 bg-white" style="border-radius: 10px;">
                        <div class="d-flex justify-content-between align-items-center">
                            <div>
                                <h3 class="mb-0" style="font-size: 1.6rem; color: #d0d5ff; font-weight:bold;">Welcome,</h3>
                                <h3 style="font-size: 1.6rem; font-weight:bold;" class="text-primary"><?= $_SESSION['firstname'] . ' ' . $_SESSION['lastname'] ?></h3>
                            </div>
                            <!-- <div>
                                <a href="logout"><span class="material-symbols-outlined" style="background-color: #e5e8ff; padding: 7px; border-radius: 100px;">logout</span></a>
                            </div> -->
                        </div>
                        <div class="mt-4">
                            <ul class="select2selector nav nav-pills menu-scrollbar pb-sm-3" id="pills-tab" role="tablist" style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
                                <input type="hidden" id="select_student_field" style="display: none;" class="" value="<?= $data[0]['id'] ?>">
                                <input type="hidden" id="select_class_field" class="" value="<?= $data[0]['class_id'] ?>">
                                <!--<input type="hidden" id="select_session_field" class="session_value" value="<?= $_SESSION['session_id']; ?>">-->
                                <div class="d-flex">
                                    <?php
                                    foreach ($data as $eachdata) {
                                        if ($data[0] == $eachdata) {
                                            $active_class = 'active';
                                        } else {
                                            $active_class = '';
                                        }
                                    ?>
                                        <div class="btn mb-4 mb-sm-0 mr-4 select_student d-flex align-items-top justify-content-between mr-2 <?= $active_class ?>" data-lastname='<?= $eachdata['lastname'] ?>' data-firstname='<?= $eachdata['firstname'] ?>' data-middlename='<?= $eachdata['middlename'] ?>' data-class_id='<?= $eachdata['class_id'] ?>' data-studentId='<?= $eachdata['id'] ?>' data-class_id='<?= $eachdata['class_id'] ?>' data-photo='<?= $eachdata['photo'] ?>' data-dob='<?= $eachdata['dob'] ?>' data-gender='<?= $eachdata['gender'] ?>' data-email='<?= $eachdata['email'] ?>' data-phone='<?= $eachdata['phone'] ?>' data-p_firstname='<?= $eachdata['p_firstname'] ?>' data-p_lastname='<?= $eachdata['p_lastname'] ?>' data-p_email='<?= $eachdata['p_email'] ?>' data-address='<?= $eachdata['address'] ?>' onclick="selectstudent(this)" style="border: 1px solid #ededed; border-radius: 10px;">
                                            <input type="hidden" class="class_value <?= $active_class ?>" value="<?= $eachdata['class_id'] ?>">
                                            <div style="padding-top: 10px; height: 50px; object-fit: cover;">
                                                <img src="../uploads/<?= $eachdata['photo'] ?>" class="img-size-50 img-circle elevation-2 mr-2" alt="User Image">
                                            </div>
                                            <div class="d-flex flex-column justify-content-center ml-sm-3 ml-0 mt-sm-0">
                                                <div>
                                                    <p class="text-left"><?= $eachdata['lastname'] . ' ' . $eachdata['firstname'] . ' ' . $eachdata['middlename'] ?></p>
                                                </div>
                                                <div>
                                                    <p class="mb-0 small font-weight-bold accent text-left"><?= $eachdata['classname'] ?></p>
                                                </div>
                                                <div>
                                                    <p class="mb-0 small font-weight-bold muted-text text-left"><?= calculate_age($eachdata['dob']) == 'Nil' ? '' : calculate_age($eachdata['dob']) ?> yrs</p>
                                                </div>
                                            </div>
                                        </div>
                                    <?php
                                    }
                                    // }
                                    ?>
                                </div>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="row mx-0">
                    <div class="container-fluid col-12 col-md-3 mb-3" id="">
                        <div class="py-3 px-15 bg-white space_content_box" style="border-radius: 10px; position: relative">
                            <div id="billing_card_container"></div>
                            <div class="text-left float-left w-100 mb-3">
                                <img style="height:100px; object-fit: cover;" class="student_photo profile-user-img img-fluid img-circle"
                                    src="../uploads/<?= $data[0]['photo'] ?>"
                                    alt="User profile picture">
                            </div>
                            <p class="font-weight-bold muted-text">Basic Data</p>
                            <div class="d-flex justify-content-between flex-wrap mt-2" style="column-gap: 40px; row-gap: 10px;">
                                <div class="">
                                    <p class="font-weight-bold small muted-text">Name</p>
                                    <p class="name"><?= $data[0]['lastname'] . ' ' . $data[0]['firstname'] . ' ' . $data[0]['middlename'] ?></p>
                                </div>
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
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="mt-3 bg-white space_content_box" style="border-radius: 10px; position: relative">
                            <div class="card card-primary">
                                <div class="card-header border-transparent">
                                    <p class="card-title">Notice</p>

                                    <div class="card-tools">
                                        <button type="button" class="btn btn-tool" data-card-widget="maximize">
                                            <i class="fas fa-expand"></i>
                                        </button>
                                        <button type="button" class="btn btn-tool" data-card-widget="collapse">
                                            <i class="fas fa-minus"></i>
                                        </button>
                                    </div>
                                </div>
                                <!-- /.card-header -->
                                <!--<div class="card-body">-->
                                <!--    <div id="notice_comm">-->
                                <!--    </div>-->
                                <!--    <hr class="hr">-->
                                <!--    <div class="form-group">-->
                                <!--        <label for="send_message_to_teacher" class="font-weight-bold text-muted">Send message to teacher</label>-->
                                <!--        <input type="hidden" id="student_id" value="<?= $data[0]['id'] ?>">-->
                                <!--        <input type="hidden" id="class_id" value="<?= $data[0]['class_id'] ?>">-->
                                <!--        <input type="hidden" id="term_id" value="<?= $_SESSION['term_id'] ?>">-->
                                <!--        <input type="hidden" id="session_id" value="<?= $_SESSION['session_id'] ?>">-->
                                <!--        <textarea rows='2' id="send_message_to_teacher" style="background-color:aliceblue; border-radius:10px;" class="form-control"></textarea>-->
                                <!--    </div>-->
                                <!--    <div class="d-flex justify-content-between align-items-center mb-3">-->
                                <!--        <button type="button" id="send_message_to_teacher_btn" class="btn btn-primary btn-sm">Send</button>-->
                                <!--<div class="d-flex align-items-center">-->
                                <!--    <span class="material-symbols-outlined mr-2">sms</span>-->
                                <!--    <p class="mb-0 font-weight-bold text-muted">Send SMS</p>-->
                                <!--</div>-->
                                <!--    </div>-->
                                <!--</div>-->

                                <!-- /.card-footer -->
                            </div>
                        </div>
                    </div>
                    <div class="container-fluid col-12 col-md-9 px-0 mt-3">
                        <div class="input-group mb-3 align-items-md-center align-items-start pl-2" style="width: 300px;">
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
                        <div class="card p-3" id="payment_card" style="max-width: 300px;">
                            <div class="card-body p-0">
                                <div class="d-flex align-items-center mb-2">
                                    <span class="material-symbols-outlined text-danger mr-2">request_quote</span>
                                    <p class="mb-0">Amount due: <span class="font-weight-bold" id="amount_due_parent">...</span></p>
                                </div>
                                <div class="d-flex align-items-center mb-2">
                                    <span class="material-symbols-outlined text-success mr-2">price_check</span>
                                    <p class="mb-0">Amount paid: <span class="font-weight-bold" id="total_amount_paid_parent">...</span></p>
                                </div>
                                <div class="d-flex align-items-center mb-3">
                                    <span class="material-symbols-outlined text-warning mr-2">account_balance_wallet</span>
                                    <p class="mb-0">Balance: <span class="font-weight-bold" id="balance_parent">...</span></p>
                                </div>
                                <button type="button" class="btn btn-sm btn-outline-primary w-100" onclick="payment_breakdown_modal()">
                                    <span class="material-symbols-outlined" style="font-size: 1.2em; vertical-align: middle;">visibility</span>
                                    See payment breakdown
                                </button>
                            </div>
                        </div>
                        <div class="py-3 px-15 bg-white data_overlay" style="border-radius: 10px; position: relative"></div>
                        <div class="thecontentbox" style="display: none">
                            <div class="container-fluid" id="">
                                <div class="py-3 px-15 bg-white space_content_box" style="border-radius: 10px; position: relative">
                                    <!-- <div id=""> -->
                                    <div id="filterTerm" class="w-100">
                                        <ul class="menu-scrollbar px-0" id="" role="" style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
                                            <button class="btn select_btn term my-1 <?= $_SESSION['term_id'] == '1' ? 'active' : '' ?> mr-2" data-name="1" id="first" onclick="toggletermfilterClass(this)">1st Term</button>
                                            <button class="btn select_btn term my-1 <?= $_SESSION['term_id'] == '2' ? 'active' : '' ?> mr-2" data-name="2" id="second" onclick="toggletermfilterClass(this)">2nd Term</button>
                                            <button class="btn select_btn term my-1 <?= $_SESSION['term_id'] == '3' ? 'active' : '' ?> mr-2" data-name="3" id="third" onclick="toggletermfilterClass(this)">3rd Term</button>
                                            <button class="btn select_btn term my-1 mr-2" data-name="summary" id="summary" onclick="toggletermfilterClass(this)">Summary</button>
                                        </ul>
                                    </div>
                                    <div class="d-flex justify-content-between">
                                        <div id="reportLinksContainer" class="d-flex flex-wrap mt-3 mb-2" style="gap: 10px;">
                                            <!-- Custom report links will be loaded here -->
                                        </div>

                                        <div class="d-flex flex-wrap mt-3 mb-2" style="gap: 10px;">
                                            <button class="btn-print-report" id="preview-term-pdf" onclick="preview_report_card_multiple('student_page','term')">
                                                <i class="fas fa-print"></i> Term Report
                                            </button>
                                            <button class="btn-print-report" id="preview-session-pdf" onclick="preview_report_card_multiple('student_page','session')">
                                                <i class="fas fa-print"></i> Cumulative Report
                                            </button>
                                        </div>
                                    </div>
                                    <div class="">
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
                                            <div class="mr-5 general_behaviour_section">
                                                <p class="font-weight-bold text-muted">General Behaviour</p>
                                                <table class="behaviour_report_table w-100">
                                                    <thead>
                                                        <tr class="d-none">
                                                            <th></th>
                                                            <th></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <?php if (!in_array('punctuality', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Punctuality</td>
                                                                <td class="punctuality"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('classattendance', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Classroom attendance</td>
                                                                <td class="classattendance"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('resptoass', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Response to assignment</td>
                                                                <td class="resptoass"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('Neatness', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Neatness</td>
                                                                <td class="Neatness"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('Politeness', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Politeness</td>
                                                                <td class="Politeness"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('Honesty', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Honesty</td>
                                                                <td class="Honesty"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('selfcontrol', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Self control</td>
                                                                <td class="selfcontrol"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('relationship', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Relationship with others</td>
                                                                <td class="relationship"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('organizationability', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Organizational Ability</td>
                                                                <td class="organizationability"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                    </tbody>
                                                </table>
                                            </div>

                                            <div class="psychomotive_skills_section">
                                                <p class="font-weight-bold text-muted">Psychomotive Skills</p>
                                                <table class="behaviour_report_table w-100">
                                                    <thead>
                                                        <tr class="d-none">
                                                            <th></th>
                                                            <th></th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <?php if (!in_array('Obedience', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Obedience</td>
                                                                <td class="Obedience"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('Creativity', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Creativity</td>
                                                                <td class="Creativity"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('Writing', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Writing</td>
                                                                <td class="Writing"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('Fluency', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Fluency</td>
                                                                <td class="Fluency"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('Sport', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Sport</td>
                                                                <td class="Sport"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('Games', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Games</td>
                                                                <td class="Games"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('DrawingPainting', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Drawing & Painting</td>
                                                                <td class="DrawingPainting"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('Music', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Music Performance</td>
                                                                <td class="Music"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('HandlingTools', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Handling Tools</td>
                                                                <td class="HandlingTools"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                        <?php if (!in_array('Crafts', $hidden_skills)): ?>
                                                            <tr>
                                                                <td>Craft</td>
                                                                <td class="Crafts"></td>
                                                            </tr>
                                                        <?php endif; ?>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <!-- <div class="container-fluid mt-4">
                    <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                        <div class="d-sm-flex flex-column align-items-start">

                            <div class="w-100 mb-3 d-flex align-items-md-center align-items-start">
                                <div>
                                    <p class="mb-0 mr-2 text-muted">Select Term: </p>
                                </div>
                                <div id="filterTerm">
                                    <button class="btn-sm select_btn term active my-1 mr-2" data-name="1" id="first" onclick="toggletermfilterClass('1')">1st Term</button>
                                    <button class="btn-sm select_btn term my-1 mr-2" data-name="2" id="second" onclick="toggletermfilterClass('2')">2nd Term</button>
                                    <button class="btn-sm select_btn term my-1 mr-2" data-name="3" id="third" onclick="toggletermfilterClass('3')">3rd Term</button>
                                </div>
                            </div>
                            <div class="input-group mb-3 d-flex align-items-md-center align-items-start" style="width: 300px;">
                                <label for="" class="mb-0 mr-2 text-muted">Select Session:</label>
                                <select class="form-control select2" onchange="display_table()" id="select_session_field" style="width: 50%;">
                                    <?php
                                    $select = mysqli_query($conn, "SELECT id,session FROM sessions ORDER BY session ASC");
                                    while ($row = mysqli_fetch_array($select)) {
                                    ?>
                                        <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                    <?php
                                    }
                                    ?>
                                </select>
                            </div>
                        </div>
                        <table id="report_score_table" class="display nowrap" style="width:100%;">
                        </table>

                    </div>
                </div> -->

            </div>
            <!-- /.row -->
        </div><!-- /.container-fluid -->
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
    <div class="modal fade" id="preview_report_card_modal">
        <div class="modal-dialog modal-lg modal-dialog-scrollable modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body py-0">
                    <div class="bg-white" id="pdf-content"></div>
                    <div class="card-foot" id="preview_report_card_foot" style="display: none;">
                        <button type="button" class="btn btn-primary" onclick="generatePDF()">Download</button>
                        <button type="button" class="btn btn-grey" class="close" data-dismiss="modal" aria-label="Close">Cancel</button>
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
                    <!-- Example placement: Inside the modal-header or modal-footer -->
                    <div class="zoom-controls">
                        <button id="zoom-out-btn" class="btn btn-secondary btn-sm" title="Zoom Out">
                            <i class="fas fa-search-minus"></i>
                        </button>
                        <button id="zoom-in-btn" class="btn btn-secondary btn-sm" title="Zoom In">
                            <i class="fas fa-search-plus"></i>
                        </button>
                        <button id="zoom-reset-btn" class="btn btn-secondary btn-sm" title="Reset Zoom">
                            <i class="fas fa-sync-alt"></i>
                        </button>
                    </div>
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
                    <button type="button" class="btn btn-primary" onclick="generatePDF('<?= $data[0]['lastname'] . ' ' . $data[0]['firstname'] . ' ' . $data[0]['middlename'] ?>')">Download</button>

                    <button type="button" id="print-button" class="btn btn-primary" onclick="printReports()" disabled>
                        <i class="fas fa-print mr-1"></i> Print Reports
                    </button>
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>
    <!-- ./wrapper -->
    <!-- payment breakdown modal -->
    <div class="modal fade" id="payment_breakdown_modal">
        <div class="modal-dialog modal-xl modal-dialog-scrollable" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title font-weight-bold">Payment Breakdown</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div id="payment-breakdown-content" class="">
                        <!-- Payment breakdown details will be loaded here -->
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
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
                    <p class="modal-title font-weight-bold" id="paymentReceiptPreviewModalLabel"><i class="fas fa-receipt"></i> Payment
                        Receipt Preview</p>
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
                </div>
            </div>
        </div>
    </div>
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
    <script>
        var skul_settings = <?= $_SESSION['skul_settings'] ?>;
        let myschl = <?php echo $_SESSION['school_id'] ?>
    </script>
    <script src="../dist/js/accounts.js?v=113join"></script>
    <script src="../dist/js/skul.js?v=0op"></script>
    <script>
        setTimeout(get_score_data(),
            setTimeout(() => {
                get_notices('<?= $_SESSION['userid'] ?>', '0')
            }, 200), 200)

        $(document).ready(function() {
            get_billing_data();
            fetchParentPortalReports();

            // Fetch reports when session changes
            $('#select_session_field').on('change', function() {
                setTimeout(fetchParentPortalReports, 100);
            });

            // Fetch reports when term changes (hooking into toggletermfilterClass)
            $(document).on('click', '.select_btn.term', function() {
                setTimeout(fetchParentPortalReports, 100);
            });

            // Ensure listeners are attached only once, potentially using .off().on()
            $(document).off('click', '#zoom-in-btn').on('click', '#zoom-in-btn', zoomInReport);
            $(document).off('click', '#zoom-out-btn').on('click', '#zoom-out-btn', zoomOutReport);
            $(document).off('click', '#zoom-reset-btn').on('click', '#zoom-reset-btn', resetReportZoom);

            // Optional: Reset zoom when modal is closed
            $('#report_preview_modal').on('hidden.bs.modal', function() {
                resetReportZoom();
            });
        });

        function fetchParentPortalReports() {
            let session_id = $('#select_session_field').val();
            let term_id = $('.select_btn.term.active').data('name');

            if (!session_id || !term_id) return;

            $.ajax({
                url: '../report_controller.php',
                type: 'POST',
                data: {
                    action: 'fetch_reports',
                    session_id: session_id,
                    term_id: term_id
                },
                dataType: 'json',
                success: function(response) {
                    if (response.status === 'success') {
                        renderParentReportLinks(response.data);
                    }
                },
                error: function() {
                    console.error("Failed to fetch reports for parent portal.");
                }
            });
        }

        function renderParentReportLinks(reports) {
            let container = $('#reportLinksContainer');
            container.empty();

            let activeReports = reports.filter(r => r.status == 1 || r.status == '1');

            if (activeReports.length > 0) {
                activeReports.forEach(report => {
                    let linkHtml = `
                        <button type="button" class="btn-print-report report-link-btn" data-id="${report.id}">
                            <i class="fas fa-file-alt"></i> ${report.report_name}
                        </button>
                    `;
                    container.append(linkHtml);
                });
            }
        }

        $(document).on('click', '.report-link-btn', function() {
            let report_id = $(this).attr('data-id');
            preview_custom_report_card(report_id);
        });
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
