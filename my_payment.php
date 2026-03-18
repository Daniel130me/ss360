<?php
session_start();
// if($_SESSION['payment_data']){
//     echo $_SESSION['payment_data'];
// }else {
//     echo 'no';
// }
// exit;
date_default_timezone_set('Africa/Lagos');
if (! isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once "model/connect.php";
include_once "model/functions.php";
// Fetch payment history
$school_id = $_SESSION['school_id'];
$payment_history = mysqli_query($conn, "SELECT * FROM payments WHERE school_id='$school_id' ORDER BY payment_date DESC");
// $amount = get_school_amount();
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billings</title>
    <!-- <link href="../css/bootstrap.css" rel="stylesheet"> -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/css/select2.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/@ttskch/select2-bootstrap4-theme@x.x.x/dist/select2-bootstrap4.min.css"
        rel="stylesheet" />
    <link href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css" rel="stylesheet">
<!-- Theme style -->
<link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <style>
        .alert {
            margin-bottom: 20px;
            padding: 15px;
            border-radius: 4px;
        }

        .alert-success {
            background-color: #f1fff4;
            border: 2px solid #c3e6cb;
            color: #155724;
        }

        .alert-danger {
            background-color: #f8d7da;
            border-color: #f5c6cb;
            color: #721c24;
        }

        .payment-history {
            margin-top: 50px;
            padding: 20px;
            background: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
        }

        #loading {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            z-index: 9999;
            text-align: center;
            padding-top: 200px;
        }

        .amount-info {
            font-size: 0.9em;
            color: #666;
            margin-top: 5px;
        }

        .badge-success {
            background-color: #28a745;
        }

        .badge-danger {
            background-color: #dc3545;
        }

        .badge-warning {
            background-color: #ffc107;
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
                                <img src="../uploads/<?php echo $_SESSION['staff_photo'] ?>"
                                    class="img-circle elevation-2" alt="User Image">
                            </div>
                            <div class="info d-none d-sm-inline-block">
                                <p style="font-size: 14px;" class="mb-0 d-block">
                                    <?php echo $_SESSION['firstname'] . ' ' . $_SESSION['lastname'] ?></p>
                                <p style="font-size: 12px;" class="d-block mb-0 accent">
                                    <?php echo get_staff_type_in_name($_SESSION['staff_type']) ?>
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
            <!-- </div> -->

        </nav>
        <!-- /.navbar -->

        <!-- Main Sidebar Container -->
        <aside class="main-sidebar sidebar-light-primary elevation-4">
            <!-- Brand Logo -->
            <a href="" class="brand-link">
                <img src="../uploads/<?php echo $_SESSION['logo'] ?>" alt="<?php echo $_SESSION['school_name'] ?>"
                    class="brand-image" style="opacity: .8">
                <span class="brand-text font-weight-light" style="visibility: hidden;">Rus</span>
            </a>


            <!-- <div href="" class="px-15 pt-15 border-bottom" style="padding-bottom: 30px;">
                <img src="../uploads/<= $_SESSION['logo'] ?>" style="height: 200px; object-fit:cover;" alt="Logo"
                    class="brand-image img-circle elevation-5 w-100">
            </div> -->
            <div href="" class="py-2 px-15">
                <p class="font-weight-bold"><?php echo $_SESSION['school_name'] ?></p>
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
        <div class="content-wrapper" style="background-color: #f4f7fa; padding-bottom: 100px;">


            <!-- Main content -->
            <div class="content">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-md-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div class="">
                                    <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">My Payments</h2>
                                    <ol class="breadcrumb p-0 bg-white mb-0">
                                        <li class="breadcrumb-item font-14">
                                            <a href="dashboard" class="d-flex align-items-center accent"
                                                style="margin-left: -2px;">
                                                <i class="material-symbols-outlined mr-1"
                                                    style="font-size: 19px;">dashboard</i>Dashboard</a>
                                        </li>
                                        <li class="breadcrumb-item active font-14">My Payments</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                        <div class="row mt-4 w-100 m-0">
                            <div class="col-12 col-md-4 mb-4 mb-md-0">
                                <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                                    <div class="payment-form">
                                        <?php if (isset($_GET['message'])): ?>
                                            <div
                                                class="alert alert-<?php echo $_GET['status'] === 'success' ? 'success' : 'danger'; ?>">
                                                <?php echo htmlspecialchars($_GET['message']); ?>
                                            </div>
                                            <!--<div-->
                                            <!--    class="alert alert-success">-->
                                            <!--    We are reviewing your payment, a confirmation email will be sent to you shortly.-->
                                            <!--</div>-->
                                        <?php endif; ?>

                                        <form id="paymentForm" class="payment-form">
                                            <input type="hidden" name="email" value="<?php echo $_SESSION['email']; ?>">
                                            <input type="hidden" name="school_name"
                                                value="<?php echo $_SESSION['school_name']; ?>">
                                            <input type="hidden" name="school_id"
                                                value="<?php echo $_SESSION['school_id']; ?>">
                                            <input type="hidden" name="phone"
                                                value="<?php echo $_SESSION['phone']; ?>">



                                            <div class="form-group">
                                                <label for="session_id">Academic Session:</label>
                                                <select class="form-control select2" id="session_id" name="session_id"
                                                    required style="width: 100%;">
                                                    <option value="1">2023/2024</option>
                                                    <option value="2">2024/2025</option>
                                                    <option value="3" selected>2025/2026</option>
                                                </select>
                                            </div>

                                            <div class="form-group">
                                                <label for="term_id">Term:</label>
                                                <select class="form-control select2" id="term_id" name="term_id"
                                                    required style="width: 100%;">
                                                     <option <?=$_SESSION['term_id'] == 1 ? 'selected' : ''?> value="1">First Term</option>
                                                    <option <?=$_SESSION['term_id'] == 2 ? 'selected' : ''?> value="2">Second Term</option>
                                                    <option <?=$_SESSION['term_id'] == 3 ? 'selected' : ''?> value="3">Third Term</option>            
                                                </select>
                                            </div>

                                            <div class="form-group">
                                                <label for="student_number">Number of Students:</label>
                                                <input type="number" class="form-control" id="student_number"
                                                    name="student_number" required min="1" max="10000">
                                                <div class="amount-info">Cost per student: ₦<?= $_SESSION['sub_amount'] ?> (7.5% VAT excluded)</div>
                                            </div>

                                            <div class="form-group">
                                                <label for="amount">Total Amount (₦) + VAT</label>
                                                <input type="text" class="form-control" id="amount" name="amount"
                                                    readonly>
                                            </div>

                                            <button type="submit" class="btn btn-primary btn-block" id="submitBtn">Pay
                                                Now</button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 col-md-8">
                                <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                                    <div id="payment_summary_card"></div>
                                    <table class="table display nowrap" style="width: 100%;" id="paymentHistoryTable">
                                        <thead>
                                            <tr>
                                                <th>Date</th>
                                                <th>Reference</th>
                                                <th>Session</th>
                                                <th>Term</th>
                                                <th>Students</th>
                                                <th>Amount</th>
                                                <th>Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <?php while ($row = mysqli_fetch_array($payment_history)): ?>
                                                <tr>
                                                    <td><?php echo date('jS M Y | h:ia', strtotime($row['payment_date'])); ?>
                                                    </td>
                                                    <td><?php echo $row['tx_ref']; ?></td>
                                                    <td>
                                                        <?php
                                                        switch ($row['session_id']) {
                                                            case 1:
                                                                echo '2023/2024';
                                                                break;
                                                            case 2:
                                                                echo '2024/2025';
                                                                break;
                                                            case 3:
                                                                echo '2025/2026';
                                                                break;
                                                        }
                                                        ?></td>
                                                    <td><?php
                                                        switch ($row['term_id']) {
                                                            case 1:
                                                                echo 'First Term';
                                                                break;
                                                            case 2:
                                                                echo 'Second Term';
                                                                break;
                                                            case 3:
                                                                echo 'Third Term';
                                                                break;
                                                        }
                                                        ?></td>
                                                    <td><?php echo $row['student_number']; ?></td>
                                                    <td>₦<?php echo number_format($row['amount'], 2); ?></td>
                                                    <td><span
                                                            class="badge badge-<?php echo $row['payment_status'] === 'successful' ? 'success' : 'danger'; ?>">
                                                            <?php echo ucfirst($row['payment_status']); ?>
                                                        </span></td>
                                                </tr>
                                            <?php endwhile; ?>
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
       <!-- Activate Students Modal -->
    <div class="modal fade" id="activateStudentsModal" tabindex="-1" role="dialog" aria-labelledby="activateStudentsModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <p class="modal-title font-weight-bold" id="activateStudentsModalLabel">Activate Students</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <!-- Class Filter Dropdown -->
                    <!-- <div class="form-group">
                    <label for="classFilterSelect">Filter by Class:</label>
                    <select class="form-control" id="classFilterSelect" name="class_filter" style="width: 100%;">
                        <option value="">-- Select a Class --</option>
                        < Options will be loaded via AJAX -
                    </select>
                </div> -->
                    <!-- <hr> -->
                    <!-- Student List -->
                    <!-- <form id="activateStudentsForm"> -->
                    <p>Select students to activate (Max: <span id="activationLimit">0</span>):</p>
                    <div id="studentListContainer" style="max-height: 400px; overflow-y: auto;">
                        <!-- Student checkboxes will be loaded here -->
                        <p>Loading students...</p>
                    </div>
                    <input type="hidden" name="action" value="activate_selected_students">
                    <!-- Add other necessary hidden fields if needed for the activation PHP script -->
                    <!-- </form> -->
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" id="activateSelectedBtn">Activate Selected</button>
                </div>
            </div>
        </div>
    </div>
    <!-- End Activate Students Modal -->

    <script src="../plugins/jquery/jquery.min.js"></script>
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>
    <script src="../dist/js/adminlte.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-rc.0/dist/js/select2.min.js"></script>
    <script>
        $(document).ready(function() {
            fetchPaymentSummary();
            const AMOUNT_PER_STUDENT = <?= $_SESSION['sub_amount'] ?>;
            $('.select2').select2({
                theme: 'bootstrap4',
                width: '100%',
                dropdownAutoWidth: true,
                minimumResultsForSearch: -1 // Disable search box
            });
            // Initialize DataTable
            $('#paymentHistoryTable').DataTable({
                scrollX: true,
                order: [
                    [0, 'desc']
                ],
                pageLength: 10,
                language: {
                    search: "Search payments:",
                    lengthMenu: "Show _MENU_ payments per page",
                }
            });

            // Form validation and submission
            $('#student_number').on('input', function() {
                const studentCount = parseInt($(this).val()) || 0;
                const subAmount = studentCount * AMOUNT_PER_STUDENT;
                const tax = subAmount * 0.075;
                const totalAmount = subAmount + tax;
                $('#amount').val(totalAmount.toFixed(2));

                // Validate student count
                if (studentCount < 1) {
                    $(this).addClass('is-invalid');
                    $('#submitBtn').prop('disabled', true);
                } else {
                    $(this).removeClass('is-invalid');
                    $('#submitBtn').prop('disabled', false);
                }
            });



            $('#paymentForm').on('submit', function(e) {
                e.preventDefault();

                // Additional validation before submission
                if (!$('#student_number').val() || parseInt($('#student_number').val()) < 1) {
                    toastr.warning('Please enter a valid number of students');
                    return false;
                }

                // Show loading spinner
                $('#loading').show();
                $('#submitBtn').prop('disabled', true);

                $.ajax({
                    type: 'POST',
                    url: '../payment_processing.php',
                    data: $(this).serialize(),
                    dataType: 'json',
                    success: function(response) {
                        if (response.status === 'success') {
                            // alert(response.payment_link);
                            window.location.href = response.payment_link;
                        } else {
                            toastr.info(response.message ||
                                'Payment initiation failed. Please try again.');
                            $('#loading').hide();
                            $('#submitBtn').prop('disabled', false);
                        }
                    },
                    error: function() {
                        toastr.error('An error occurred. Please try again.');
                        $('#loading').hide();
                        $('#submitBtn').prop('disabled', false);
                    }
                });
            });

            // Check for existing session data
            if (sessionStorage.getItem('paymentFormData')) {
                const formData = JSON.parse(sessionStorage.getItem('paymentFormData'));

                $('#session_id').val(formData.session_id);
                $('#term_id').val(formData.term_id);
                $('#student_number').val(formData.student_number).trigger('input');
                sessionStorage.removeItem('paymentFormData');
            }
        });

        function fetchPaymentSummary() {
            $.ajax({
                url: '../payment_controller.php', // Correct path
                type: 'POST',
                data: {
                    action: 'fetch_payment_summary'
                },
                dataType: 'json',
                beforeSend: function() {
                    $('#payment_summary_card').html('<p>Loading summary...</p>');
                },
                success: function(response) {
                    if (response && typeof response.total_paid !== 'undefined' && typeof response.activated !== 'undefined' && typeof response.not_activated !== 'undefined') {

                        // Calculate how many *more* can be activated based on payment limit
                        activationLimit = response.total_paid - response.activated;
                        let activateButtonHtml = '';

                        // --- Build HTML for individual cards ---
                        const cardPaidHtml = `
                                    <div class="col-lg-3 col-md-6 col-sm-6 mb-3">
                                        <div class="card mb-0">
                                            <div class="card-body d-flex justify-content-between align-items-center">
                                                <p class="text-muted font-weight-bold">Students <br>Paid For</p>
                                                <p class="card-text display-4 font-weight-bold text-primary" style="font-size:3.0rem !important;">${response.total_paid}</p>
                                            </div>
                                        </div>
                                    </div>
                                `;

                        const cardActivatedHtml = `
                                    <div class="col-lg-3 col-md-6 col-sm-6 mb-3">
                                        <div class="card mb-0">
                                            <div class="card-body d-flex justify-content-between align-items-center">
                                                <p class="text-muted font-weight-bold">Activated <br>Students</p>
                                                <p class="card-text display-4 font-weight-bold text-primary" style="font-size:3.0rem !important;">${response.activated}</p>
                                            </div>
                                        </div>
                                    </div>
                                `;

                        const cardPendingHtml = `
                                    <div class="col-lg-3 col-md-6 col-sm-6 mb-3">
                                        <div class="card mb-0">
                                            <div class="card-body d-flex justify-content-between align-items-center">
                                                <p class="text-muted font-weight-bold">Pending <br>Activation</p>
                                                <p class="card-text display-4 font-weight-bold text-primary" style="font-size:3.0rem !important;">${response.not_activated}</p>
                                            </div>
                                        </div>
                                    </div>
                                `;

                        const cardAvailableHtml = `
                                    <div class="col-lg-3 col-md-6 col-sm-6 mb-3">
                                        <div class="card mb-0">
                                            <div class="card-body d-flex justify-content-between align-items-center">
                                                <p class="text-muted font-weight-bold">Available <br>Slots</p>
                                                <p class="card-text display-4 font-weight-bold text-primary" style="font-size:3.0rem !important;">${activationLimit > 0 ? activationLimit : 0}</p>
                                            </div>
                                        </div>
                                    </div>
                                `;

                        // --- Conditional Activate Button ---
                        // Show button only if there's a positive difference AND there are actually students with status=0
                        let activateRowHtml = '<div class="col-12 mb-3">'; // Start a new row for the button/message
                        if (activationLimit > 0 && response.not_activated > 0) {
                            // Ensure we don't offer to activate more than actually exist with status=0
                            const displayDifference = Math.min(activationLimit, response.not_activated);
                            activateRowHtml += `
                                        <button class="btn btn-primary btn-sm" id="activateMoreBtn" data-limit="${activationLimit}">
                                            <i class="fas fa-user-plus mr-2"></i> Activate ${displayDifference} More Student(s)
                                        </button>
                                    `;
                        } else if (activationLimit <= 0 && response.not_activated > 0) {
                            activateRowHtml += `
                                        <div class="alert alert-warning text-center" role="alert" style="background-color: #fffcf1">
                                            All paid slots are currently active. (${response.not_activated} student(s) pending activation require further payment).
                                        </div>
                                    `;
                        } else if (response.not_activated <= 0 && response.total_paid > 0) {
                            activateRowHtml += `
                                         <div class="alert alert-info text-center" role="alert">
                                            All students are currently active.
                                        </div>
                                    `;
                        } else {
                            // No pending, no paid slots available - maybe initial state or error
                            activateRowHtml += `
                                         <div class="alert alert-secondary text-center" role="alert">
                                            No pending students to activate or payment slots available.
                                        </div>
                                    `;
                        }
                        activateRowHtml += '</div>'; // End button/message column


                        // --- Combine all HTML parts ---
                        // Wrap cards in a Bootstrap row
                        const summaryHtml = `
                                    <div class="row">
                                        ${cardPaidHtml}
                                        ${cardActivatedHtml}
                                        ${cardPendingHtml}
                                        ${cardAvailableHtml}
                                    </div>
                                    <div class="row">
                                         ${activateRowHtml}
                                    </div>
                                `;

                        // Update the content of the div
                        $('#payment_summary_card').html(summaryHtml);

                    } else {
                        // Handle cases where the response might be malformed or missing data
                        $('#payment_summary_card').html('<p class="text-danger">Could not load payment summary. Invalid response received.</p>');
                        console.error("Invalid response structure:", response);
                    }
                },

                error: function(jqXHR, textStatus, errorThrown) {
                    $('#payment_summary_card').html('<p class="text-danger">Failed to load payment summary. Please try again later.</p>');
                    console.error("AJAX Error:", textStatus, errorThrown);
                }
            });
        }

        // function loadStudentsForActivation(classId = null) {
        //     $('#studentListContainer').html('<p>Loading students...</p>'); // Show loading indicator
        //     $.ajax({
        //         url: '../payment_controller.php', // Correct path
        //         type: 'POST',
        //         data: {
        //             action: 'fetch_students_for_activation',
        //             class_id: classId // Send null or the actual class ID
        //         },
        //         dataType: 'json',
        //         success: function(response) {
        //             let studentHtml = '<p>No inactive students found matching the criteria.</p>'; // Default message
        //             if (response && response.students && response.students.length > 0) {
        //                 studentHtml = ''; // Start list
        //                 response.students.forEach(student => {
        //                     const studentName = `${student.firstname} ${student.lastname}`.trim();
        //                     const admissionNo = student.admission_no ? ` | ${student.admission_no}` : '';
        //                     const classname = student.classname.trim();
        //                     studentHtml += `
        //                         <div class="icheck-primary mb-3">
        //                             <input class="form-check-input student-activate-checkbox" type="checkbox" name="student_ids[]" value="${student.id}" id="student_${student.id}">
        //                             <label class="form-check-label w-100" for="student_${student.id}">
        //                                 <p>${studentName}</p>
        //                                 <p class="small muted-text">${classname}${admissionNo}</p>
        //                             </label>
        //                         </div>`;
        //                 });
        //                 // studentHtml += '</ul>'; // End list
        //             } else if (response && response.error) {
        //                 studentHtml = `<p class="text-danger">Error loading students: ${response.error}</p>`;
        //             }
        //             $('#studentListContainer').html(studentHtml);
        //             updateCheckboxState(); // Disable checkboxes if limit reached
        //         },
        //         error: function(jqXHR, textStatus, errorThrown) {
        //             $('#studentListContainer').html('<p class="text-danger">Failed to load students. Please try again.</p>');
        //             console.error("AJAX Error loading students:", textStatus, errorThrown);
        //         }
        //     });
        // }
   function loadStudentsForActivation(classId = null) {
            // --- Pagination state ---
            window.studentActivationPagination = window.studentActivationPagination || { page: 1, per_page: 10 };
            const page = window.studentActivationPagination.page;
            const per_page = window.studentActivationPagination.per_page;

            $('#studentListContainer').html('<p>Loading students...</p>');
            $.ajax({
                url: '../payment_controller.php',
                type: 'POST',
                data: {
                    action: 'fetch_students_for_activation',
                    class_id: classId,
                    page: page,
                    per_page: per_page
                },
                dataType: 'json',
                success: function(response) {
                    let studentHtml = '<p>No inactive students found matching the criteria.</p>';
                    if (response && response.students && response.students.length > 0) {
                        studentHtml = '';
                        response.students.forEach(student => {
                            const studentName = `${student.firstname} ${student.lastname}`.trim();
                            const admissionNo = student.admission_no ? ` | ${student.admission_no}` : '';
                            const classname = student.classname ? student.classname.trim() : '';
                            studentHtml += `
                                <div class="icheck-primary mb-3">
                                    <input class="form-check-input student-activate-checkbox" type="checkbox" name="student_ids[]" value="${student.id}" id="student_${student.id}" data-class-id="${student.class_id}">
                                    <label class="form-check-label w-100" for="student_${student.id}">
                                        <p>${studentName}</p>
                                        <p class="small muted-text">${classname}${admissionNo}</p>
                                    </label>
                                </div>`;
                        });
                        // --- Pagination controls ---
                        if (response.total_pages > 1) {
                            studentHtml += '<nav aria-label="Student pagination"><ul class="pagination justify-content-center">';
                            // Previous button
                            studentHtml += `<li class="page-item${response.page === 1 ? ' disabled' : ''}"><a class="page-link" href="#" data-page="${response.page - 1}">Previous</a></li>`;
                            // Page numbers
                            for (let i = 1; i <= response.total_pages; i++) {
                                studentHtml += `<li class="page-item${response.page === i ? ' active' : ''}"><a class="page-link" href="#" data-page="${i}">${i}</a></li>`;
                            }
                            // Next button
                            studentHtml += `<li class="page-item${response.page === response.total_pages ? ' disabled' : ''}"><a class="page-link" href="#" data-page="${response.page + 1}">Next</a></li>`;
                            studentHtml += '</ul></nav>';
                        }
                    } else if (response && response.error) {
                        studentHtml = `<p class="text-danger">Error loading students: ${response.error}</p>`;
                    }
                    $('#studentListContainer').html(studentHtml);
                    updateCheckboxState();
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    $('#studentListContainer').html('<p class="text-danger">Failed to load students. Please try again.</p>');
                    console.error("AJAX Error loading students:", textStatus, errorThrown);
                }
            });
        }
         // --- NEW: Event listener for pagination controls ---
        $(document).on('click', '#studentListContainer .pagination .page-link', function(e) {
            e.preventDefault();
            const page = parseInt($(this).data('page'));
            // Get total pages from the pagination controls
            const totalPages = $('#studentListContainer .pagination .page-link[data-page]').map(function() {
                return parseInt($(this).text());
            }).get().filter(n => !isNaN(n));
            const maxPage = totalPages.length ? Math.max(...totalPages) : 1;
            if (!isNaN(page) && page > 0 && page <= maxPage) {
                window.studentActivationPagination.page = page;
                loadStudentsForActivation();
            }
        });
        // --- NEW: Function to update checkbox states based on limit ---
        function updateCheckboxState() {
            const selectedCount = $('.student-activate-checkbox:checked').length;
            $('#activateSelectedBtn').prop('disabled', selectedCount === 0); // Disable button if none selected

            if (selectedCount >= activationLimit) {
                // Disable all unchecked checkboxes
                $('.student-activate-checkbox:not(:checked)').prop('disabled', true);
            } else {
                // Enable all checkboxes
                $('.student-activate-checkbox').prop('disabled', false);
            }
        }


        // --- NEW: Event listener for the "Activate More Students" button ---
        // Use event delegation since the button is added dynamically
        $(document).on('click', '#activateMoreBtn', function() {
            // activationLimit = parseInt($(this).data('limit')) || 0; // Get limit from data attribute
            $('#activationLimit').text(activationLimit); // Update limit display in modal

            // Reset modal state
            // $('#classFilterSelect').val(null).trigger('change'); // Clear class filter
            $('#studentListContainer').html('<p>Loading classes...</p>'); // Clear student list initially
            $('#activateSelectedBtn').prop('disabled', true); // Disable activate button initially

            // 1. Load Classes into the filter dropdown
            $.ajax({
                url: '../payment_controller.php', // Correct path
                type: 'POST',
                data: {
                    action: 'fetch_classes_for_activation'
                },
                dataType: 'json',
                success: function(response) {
                    // const classSelect = $('#classFilterSelect');
                    // // response = JSON.parse(response); // Parse JSON response
                    // classSelect.empty().append('<option value="">-- Show All Inactive --</option>'); // Reset and add default
                    // if (response && response.classes && response.classes.length > 0) {
                    //     response.classes.forEach(cls => {
                    //         classSelect.append(new Option(cls.class_name, cls.id));
                    //     });
                    // } else if (response && response.error) {
                    //      $('#studentListContainer').html(`<p class="text-danger">Error loading classes: ${response.error}</p>`);
                    //      return; // Stop if classes failed to load
                    // }
                    // Trigger select2 update
                    // classSelect.trigger('change.select2');

                    // 2. Load initial list of ALL non-activated students
                    loadStudentsForActivation(); // Load all initially

                    // 3. Show the modal
                    $('#activateStudentsModal').modal('show');

                },
                error: function(jqXHR, textStatus, errorThrown) {
                    $('#studentListContainer').html('<p class="text-danger">Failed to load class filter options.</p>');
                    console.error("AJAX Error loading classes:", textStatus, errorThrown);
                    $('#activateStudentsModal').modal('show'); // Still show modal, but with error
                }
            });
        });



        // --- NEW: Event listener for checkbox changes within the modal ---
   $(document).on('change', '.student-activate-checkbox', function(event) {
            // Prevent modal from closing due to focus loss or bubbling
            event.preventDefault();
            event.stopPropagation();
            updateCheckboxState();
        });


        // --- NEW: Event listener for the "Activate Selected" button in the modal ---
          $('#activateSelectedBtn').on('click', function() {
            // Collect selected students and their class IDs
            const selectedStudents = [];
            $('.student-activate-checkbox:checked').each(function() {
                selectedStudents.push({
                    id: $(this).val(),
                    class_id: $(this).data('class-id')
                });
            });

            if (selectedStudents.length === 0) {
                toastr.warning('Please select at least one student to activate.');
                return;
            }

            if (selectedStudents.length > activationLimit) {
                toastr.error(`You can only activate up to ${activationLimit} student(s). You have selected ${selectedStudents.length}.`);
                return;
            }

            // Disable button to prevent double clicks
            $(this).prop('disabled', true).text('Activating...');

            // AJAX call to activate students
            $.ajax({
                url: '../payment_controller.php', // Correct path
                type: 'POST',
                data: {
                    action: 'activate_selected_students',
                    students: selectedStudents,
                    activation_limit: activationLimit // Send the limit for server-side check
                },
                dataType: 'json',
                success: function(response) {
                    if (response && response.status === 'success') {
                        toastr.success(response.message || 'Students activated successfully!');
                        $('#activateStudentsModal').modal('hide'); // Close modal on success
                        fetchPaymentSummary(); // Refresh the summary card
                    } else {
                        toastr.error(response.message || 'An error occurred during activation.');
                        $('#activateSelectedBtn').prop('disabled', false).text('Activate Selected'); // Re-enable button on error
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    toastr.error('Failed to send activation request. Please try again.');
                    console.error("AJAX Error activating students:", textStatus, errorThrown);
                    $('#activateSelectedBtn').prop('disabled', false).text('Activate Selected'); // Re-enable button on error
                }
            });
        });
    </script>
</body>

</html>