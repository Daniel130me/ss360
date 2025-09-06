<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Change Pasrsword</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- icheck bootstrap -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Toastr -->
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../dist/css/adminlte.min.css">
</head>

<body class="hold-transition register-page">
    <div class="register-box">
        <div class="register-logo">
            <p>Change PIN</p>
        </div>

        <div class="card">
            <div class="card-body register-card-body">
                <!-- <p class="login-box-msg">A little about your school</p> -->


                <form class="changepass" action="">
                    <div class="form-group">
                        <label for="new_Pin">New PIN</label>
                        <input type="password" name="new_Pin" class="form-control" id="newpin" />
                        <input type="hidden" name="action" value="change_password">
                        <input type="hidden" name="type" value="staff">
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-block btn-primary">Save</button>
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
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- Toastr -->
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script src="../dist/js/skul.js?v=12"></script>
</body>

</html>