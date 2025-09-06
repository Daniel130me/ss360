<?php
    session_start();
    date_default_timezone_set('Africa/Lagos');
    if (! isset($_SESSION['userid'])) {
        header("Location: login");
        exit();
    }
    include_once "model/connect.php";
    include_once "model/functions.php";
    // Fetch payment history
    $school_id       = $_SESSION['school_id'];
    $payment_history = mysqli_query($conn, "SELECT * FROM payments WHERE school_id='$school_id' ORDER BY payment_date DESC");
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>SS360 Payment</title>
    <!-- <link href="../css/bootstrap.css" rel="stylesheet"> -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/css/select2.min.css" rel="stylesheet" />
    <link href="https://cdn.datatables.net/1.10.24/css/dataTables.bootstrap4.min.css" rel="stylesheet">

    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <style>
        .payment-form {
            max-width: 500px;
            margin: 50px auto;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .alert {
            margin-bottom: 20px;
            padding: 15px;
            border-radius: 4px;
        }
        .alert-success {
            background-color: #d4edda;
            border-color: #c3e6cb;
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
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        #loading {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255,255,255,0.8);
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
                                <img src="../uploads/<?php echo $_SESSION['staff_photo']?>" class="img-circle elevation-2" alt="User Image">
                            </div>
                            <div class="info d-none d-sm-inline-block">
                                <p style="font-size: 14px;" class="mb-0 d-block">
                                    <?php echo $_SESSION['firstname'] . ' ' . $_SESSION['lastname']?></p>
                                <p style="font-size: 12px;" class="d-block mb-0 accent">
                                    <?php echo get_staff_type_in_name($_SESSION['staff_type'])?>
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
                <img src="../uploads/<?php echo $_SESSION['logo']?>" alt="<?php echo $_SESSION['school_name']?>" class="brand-image" style="opacity: .8">
                <span class="brand-text font-weight-light" style="visibility: hidden;">Rus</span>
            </a>


            <!-- <div href="" class="px-15 pt-15 border-bottom" style="padding-bottom: 30px;">
                <img src="../uploads/<= $_SESSION['logo'] ?>" style="height: 200px; object-fit:cover;" alt="Logo"
                    class="brand-image img-circle elevation-5 w-100">
            </div> -->
            <div href="" class="py-2 px-15">
                <p class="font-weight-bold text-tertiary"><?php echo $_SESSION['school_name']?></p>
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
                            <a href="attendance" class="nav-link active">
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
        <div class="content-wrapper" style="background-color: #f4f7fa; padding-bottom: 100px;">


            <!-- Main content -->
            <div class="content">
            <div class="container-fluid">
    <div id="loading">
        <div class="spinner-border text-primary" role="status">
            <span class="sr-only">Loading...</span>
        </div>
        <p>Processing payment...</p>
    </div>

    <div class="container">
        <div class="payment-form">
            <h2 class="text-center mb-4">School Subscription Payment</h2>

            <?php if (isset($_GET['message'])): ?>
                <div class="alert alert-<?php echo $_GET['status'] === 'success' ? 'success' : 'danger'; ?>">
                    <?php echo htmlspecialchars($_GET['message']); ?>
                </div>
            <?php endif; ?>

            <form id="paymentForm" class="payment-form">
                <input type="hidden" name="email" value="<?php echo $_SESSION['email']; ?>">
                <input type="hidden" name="school_name" value="<?php echo $_SESSION['school_name']; ?>">
                <input type="hidden" name="school_id" value="<?php echo $_SESSION['school_id']; ?>">

                <div class="form-group">
                    <label for="phone">Phone (Optional):</label>
                    <input type="text" class="form-control" id="phone" name="phone" pattern="[0-9]{11}" title="Please enter a valid phone number">
                </div>

                <div class="form-group">
                    <label for="session_id">Academic Session:</label>
                    <select class="form-control" id="session_id" name="session_id" required>
                        <option value="1">2023/2024</option>
                        <option value="2" selected>2024/2025</option>
                        <option value="3">2025/2026</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="term_id">Term:</label>
                    <select class="form-control" id="term_id" name="term_id" required>
                        <option value="1">First Term</option>
                        <option value="2">Second Term</option>
                        <option value="3">Third Term</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="student_number">Number of Students:</label>
                    <input type="number" class="form-control" id="student_number" name="student_number" required min="1" max="10000">
                    <div class="amount-info">Cost per student: ₦500</div>
                </div>

                <div class="form-group">
                    <label for="amount">Total Amount (₦):</label>
                    <input type="text" class="form-control" id="amount" name="amount" readonly>
                </div>

                <button type="submit" class="btn btn-primary btn-block" id="submitBtn">Pay Now</button>
            </form>
        </div>

        <!-- Payment History Section -->
        <div class="payment-history">
            <h3 class="mb-4">Payment History</h3>
            <div class="table-responsive">
                <table class="table table-striped" id="paymentHistoryTable">
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
                            <td><?php echo date('d M Y H:i', strtotime($row['payment_date'])); ?></td>
                            <td><?php echo $row['tx_ref']; ?></td>
                            <td><?php
                                    switch ($row['session_id']) {
                                        case 1:echo '2023/2024';
                                            break;
                                        case 2:echo '2024/2025';
                                            break;
                                        case 3:echo '2025/2026';
                                            break;
                                }
                                ?></td>
                            <td><?php
                                    switch ($row['term_id']) {
                                        case 1:echo 'First Term';
                                            break;
                                        case 2:echo 'Second Term';
                                            break;
                                        case 3:echo 'Third Term';
                                            break;
                                }
                                ?></td>
                            <td><?php echo $row['student_number']; ?></td>
                            <td>₦<?php echo number_format($row['amount'], 2); ?></td>
                            <td><span class="badge badge-<?php echo $row['payment_status'] === 'successful' ? 'success' : 'danger'; ?>">
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

    <script src="../plugins/jquery/jquery.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/1.10.24/js/dataTables.bootstrap4.min.js"></script>
    <script src="../dist/js/adminlte.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script>
    $(document).ready(function() {
        const AMOUNT_PER_STUDENT = 500;

        // Initialize DataTable
        $('#paymentHistoryTable').DataTable({
            order: [[0, 'desc']],
            pageLength: 10,
            language: {
                search: "Search payments:",
                lengthMenu: "Show _MENU_ payments per page",
            }
        });

        // Form validation and submission
        $('#student_number').on('input', function() {
            const studentCount = parseInt($(this).val()) || 0;
            const totalAmount = studentCount * AMOUNT_PER_STUDENT;
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

        // Phone number validation
        $('#phone').on('input', function() {
            const phoneRegex = /^[0-9]{11}$/;
            if (this.value && !phoneRegex.test(this.value)) {
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
                        window.location.href = response.payment_link;
                    } else {
                        toastr.info(response.message || 'Payment initiation failed. Please try again.');
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
            $('#phone').val(formData.phone);
            $('#session_id').val(formData.session_id);
            $('#term_id').val(formData.term_id);
            $('#student_number').val(formData.student_number).trigger('input');
            sessionStorage.removeItem('paymentFormData');
        }
    });
    </script>
</body>
</html>