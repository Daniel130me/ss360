<?php
// echo $_SESSION['url'];
// echo "here";
// exit;
$select = mysqli_query($conn, "SELECT id,back_pic,logo,phone1,parent_email_login_enabled FROM school WHERE url='{$_SESSION['url']}'");
$row = mysqli_fetch_assoc($select);
$parent_email_login_enabled = (int)($row['parent_email_login_enabled'] ?? 0) === 1;
// print_r($row);
// exit;
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Login</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- icheck bootstrap -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Toastr -->
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../dist/css/adminlte.css">

</head>

<body class="hold-transition register-page">
    <div class="overlay" style="width: 100%;height: 100%;background-color: #0099ff;position: absolute;opacity: .1;"></div>
    <div style="width:100%; height: 100%; background-image: url(../uploads/<?=$row['back_pic']?>);background-size: cover;background-repeat: no-repeat; display:flex; justify-content:center; align-items:center;">
        <div class="register-box">
            <!-- <div class="register-logo">
                <p>Login</p>
            </div> -->
    
            <div class="card">
                <div class="card-body register-card-body" style="border-radius: 20px;">
                    <!-- <p class="login-box-msg">A little about your school</p> -->
                    <!-- <div class="alert alert-warning alert-dismissible" id="login-access-alert" style="background-color:#fff9e5;">
                        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">×</button>
                        <p>You have not been giving access yet, call admin.</p>
                    </div> -->
                   <form class="loginform" action="../controller_new.php">
                     <?php if (!empty($row['logo']) && $row['logo'] !== 'logo-placeholder.jpg') : ?>
                            <div class="d-flex justify-content-center align-items-center">
                                <img id="image_profile_preview" class="py-3" style="width: 200px;" src="../uploads/<?= $row['logo'] ?>" alt="Photo">
                            </div>
                        <?php endif; ?>   
                    <input type="hidden" name="action" value="login">
                        <div class="form-group mb-3">
                            <label for="login_identifier"><?= $parent_email_login_enabled ? 'Login ID' : 'Phone number' ?><span class="text-danger">*</span></label>
                            <input type="text" name="phone" id="login_identifier" class="form-control"
                                placeholder="<?= $parent_email_login_enabled ? 'Phone, admission number, or parent email' : 'e.g 08136467317' ?>"
                                autocomplete="username" required>
                            <small class="text-muted">
                                <?= $parent_email_login_enabled
                                    ? 'Parents should enter their registered email address.'
                                    : 'Accepted format: ' . ($row['id'] == '27' ? '07055527775' : '08160127318') ?>
                            </small>
                        </div>
                        <div class="form-group mb-3">
                            <div class="row justify-content-between">
                                <label for="login_password" class="col-6"><?= $parent_email_login_enabled ? 'PIN / Password' : 'PIN' ?><span class="text-danger">*</span></label>
                                <a href="forgot_password" class="col-6 text-right accent">Forgot <?= $parent_email_login_enabled ? 'password' : 'PIN' ?>?</a>
                            </div>
                            <input type="password" name="password" id="login_password" class="form-control"
                                placeholder="<?= $parent_email_login_enabled ? 'Enter your PIN or password' : 'Enter your pin' ?>"
                                autocomplete="current-password" required>
                        </div>
                        <div class="form-group mb-3">
                            <button type="submit" class="staff_login_btn btn btn-primary btn-block" disabled>Login</button>
                        </div>
                    </form>
                    <!-- <a href="onboard/register_staff_self" class="accent btn-block mb-3">Register as a staff</a>
                    <a href="onboard" class="accent">Register your school</a> -->
                </div>
                <!-- /.form-box -->
            </div><!-- /.card -->
        </div>
    </div>
    <!-- /.register-box -->

    <!-- jQuery -->
    <script src="../plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- Toastr -->
    <script src="../plugins/toastr/toastr.min.js"></script>
    <!-- Select2 -->
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <script src="../dist/js/skul.js"></script>
        <script>
        $(window).on('load', function() {
            $('.staff_login_btn').prop('disabled', false);
        });
    </script>
</body>

</html>
