<?php
// $get_staff = mysqli_query($conn, "SELECT  WHERE")
?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Waiting room</title>

  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="plugins/fontawesome-free/css/all.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="dist/css/adminlte.css">
</head>

<body class="hold-transition lockscreen">
  <!-- Automatic element centering -->
  <div class="lockscreen-wrapper" style="transform: translateY(35%); padding:20px;">
    <div class="lockscreen-logo">
      <img src="dist/img/avatar.png" alt="User Image" width="50">
      <p class="muted-text font-weight-bold" style="font-size: medium;">Demo International School</p>
      <a href="">Waiting Room</a>
    </div>
    <div class="help-block text-center mb-4">
      <i>You are here because you have not been given access yet.</i>
    </div>
    <!-- User name -->
    <div class="lockscreen-name">John Doe</div>

    <!-- START LOCK SCREEN ITEM -->
    <div class="lockscreen-item" style="max-width: 290px; width: auto;">
      <!-- lockscreen image -->
      <div class="lockscreen-image">
        <img src="dist/img/avatar.png" alt="User Image">
      </div>
      <!-- /.lockscreen-image -->

      <!-- lockscreen credentials (contains the form) -->
      <form class="lockscreen-credentials">
        <div class="input-group">
          <input type="password" class="form-control" placeholder="password" style="border: 2px solid #ffffff;">

          <div class="input-group-append">
            <button type="button" class="btn">
              <i class="fas fa-arrow-right text-muted"></i>
            </button>
          </div>
        </div>
      </form>
      <!-- /.lockscreen credentials -->

    </div>
    <!-- /.lockscreen-item -->
    <!-- <div class="help-block text-center">
    Enter your password to retrieve your session
  </div> -->
    <div class="text-center">
      <a href="login">Or sign in as a different user</a>
    </div>

  </div>
  <!-- /.center -->

  <!-- jQuery -->
  <script src="plugins/jquery/jquery.min.js"></script>
  <!-- Bootstrap 4 -->
  <script src="plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
</body>

</html>