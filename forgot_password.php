<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Company | Forgot Password</title>

  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
  <!-- icheck bootstrap -->
  <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="../dist/css/adminlte.min.css">
</head>

<body class="hold-transition login-page">
  <div class="login-box">
    <div class="card card-outline card-primary">
      <div class="card-header text-center">
        <a href="index.php" class="h1"><b>Company</b></a>
      </div>
      <div class="card-body">
        <p class="login-box-msg">Forgot your password? No problem. You can easily request a new password here.</p>

        <ul class="nav nav-pills nav-justified mb-3" id="pills-tab" role="tablist">
          <li class="nav-item">
            <a class="nav-link active" id="pills-email-tab" data-toggle="pill" href="#pills-email" role="tab" aria-controls="pills-email" aria-selected="true">Email</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" id="pills-phone-tab" data-toggle="pill" href="#pills-phone" role="tab" aria-controls="pills-phone" aria-selected="false">Phone Number</a>
          </li>
        </ul>

        <form id="forgotPasswordForm" method="post">
          <div class="tab-content" id="pills-tabContent">
            <div class="tab-pane fade show active" id="pills-email" role="tabpanel" aria-labelledby="pills-email-tab">
              <div class="input-group mb-3">
                <input type="email" class="form-control" placeholder="Email" name="email">
                <div class="input-group-append">
                  <div class="input-group-text">
                    <span class="fas fa-envelope"></span>
                  </div>
                </div>
              </div>
            </div>
            <div class="tab-pane fade" id="pills-phone" role="tabpanel" aria-labelledby="pills-phone-tab">
              <div class="input-group mb-3">
                <input type="tel" class="form-control" placeholder="Phone Number" name="phone">
                <div class="input-group-append">
                  <div class="input-group-text">
                    <span class="fas fa-phone"></span>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="row mt-3">
            <div class="col-12">
              <button type="submit" id="getOtpBtn" class="btn btn-primary btn-block">Get OTP</button>
            </div>
          </div>
        </form>
        <p class="mt-3 mb-1">
          <a href="login.php">Login</a>
        </p>
      </div>
      <!-- /.login-card-body -->
    </div>
  </div>
  <!-- /.login-box -->

  <!-- jQuery -->
  <script src="../plugins/jquery/jquery.min.js"></script>
  <!-- Bootstrap 4 -->
  <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
  <!-- AdminLTE App -->
  <script src="../dist/js/adminlte.min.js"></script>
  <script>
    $(document).ready(function() {
      $('#forgotPasswordForm').on('submit', function(e) {
        e.preventDefault();

        var email = $('input[name="email"]').val();
        var phone = $('input[name="phone"]').val();
        var activeTab = $('.nav-pills .nav-link.active').attr('id');
        var submitBtn = $('#getOtpBtn');

        // We are only handling email for now as requested
        if (activeTab === 'pills-email-tab') {
          if (email === '') {
            alert('Please enter your email address.');
            return;
          }

          submitBtn.html('<i class="fas fa-spinner fa-spin"></i> Sending...').prop('disabled', true);

          $.ajax({
            url: '../handle_forgot_password.php', // Corrected path
            type: 'POST',
            dataType: 'json',
            data: {
              email: email
            },
            success: function(response) {
              if (response.status === 'success') {
                window.location.href = 'enter_otp';
              } else {
                alert('Error: ' + response.message + (response.smtp_debug_output ? '\n\nSMTP Debug:\n' + response.smtp_debug_output : ''));
                submitBtn.html('Get OTP').prop('disabled', false);
              }
            },
            error: function() {
              alert('An unexpected error occurred. Please try again.');
              submitBtn.html('Get OTP').prop('disabled', false);
            }
          });
        } else {
          alert('Phone number recovery is not yet implemented.');
        }
      });
    });
  </script>
</body>

</html>