<?php
session_start();
include_once("../model/connect.php");
?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Register</title>

  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
  <!-- icheck bootstrap -->
  <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">

  <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="../dist/css/adminlte.css">
</head>

<body class="hold-transition register-page">
  <div class="register-box">
    <div class="register-logo">
      <a><b>Registration</a>
    </div>

    <div class="card">
      <div class="card-body register-card-body">
        <!-- <p class="login-box-msg">Register a new membership</p> -->

        <form class="onboard_form" action="controller.php" enctype="multipart/form-data" method="post">
          <div class="form-group mb-3">
            <input type="text" name="firstname" class="form-control" autocomplete="given-name" placeholder="First name" required>
          </div>
          <div class="form-group mb-3">
            <input type="text" name="lastname" class="form-control" autocomplete="family-name" placeholder="Last name" required>
          </div>
          <div class="form-group mb-3">
            <select class="form-control select2" name="staff_type" style="width: 100%;" required>
              <option value="">Select your role</option>
              <?php
              $selectclass = mysqli_query($conn, "SELECT id,type FROM staff_type ORDER BY id ASC");
              while ($classrow = mysqli_fetch_array($selectclass)) {
                if($classrow['id'] == 5 || $classrow['id'] == 6){
                  continue;
                }
              ?>
                <option value="<?= $classrow['id'] ?>"><?= $classrow['type'] ?></option>
              <?php
              }
              ?>
            </select>
          </div>
          <div class="form-group mb-3">
            <input type="text" name="phone" class="form-control" autocomplete="tel" placeholder="Phone number" required>
          </div>
          <div class="form-group mb-3">
            <input type="email" name="email" class="form-control" autocomplete="email" placeholder="Email Address" required>
          </div>
          <div class="form-group mb-3">
            <input type="password" name="password" id="password" autocomplete="new-password" class="form-control" placeholder="PIN" required>
          </div>
          <div class="form-group mb-3">
            <input type="password" name="passwordnew" id="password1" class="form-control" onchange="ismatched()" placeholder="Confirm PIN" required>
            <input type="hidden" name="action" value="reg_staff">
          </div>

          <div class="row">
            <!-- /.col -->
            <div class="col-4">
              <a href="school" type="button" class="btn btn-block">Back</a>
            </div>
            <div class="col-8">
              <button type="submit" id="staff_reg_submit" class="btn btn-primary btn-block">Register</button>
            </div>
            <!-- /.col -->
          </div>
        </form>
      </div>
      <!-- /.form-box -->
    </div><!-- /.card -->
  </div>
  <!-- /.register-box -->

  <!-- jQuery -->
  <script src="../plugins/jquery/jquery.min.js"></script>
  <!-- Bootstrap 4 -->
  <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
  <!-- jquery-validation -->
  <script src="../plugins/jquery-validation/jquery.validate.min.js"></script>
  <script src="../plugins/jquery-validation/additional-methods.min.js"></script>
  <!-- AdminLTE App -->
  <script src="../plugins/select2/js/select2.full.min.js"></script>

  <script src="../dist/js/adminlte.min.js"></script>
  <script src="../plugins/toastr/toastr.min.js"></script>
  <script src="../dist/js/onboard.js?v=21"></script>
</body>

</html>