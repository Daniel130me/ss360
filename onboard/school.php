<?php
session_start();
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Register School</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- icheck bootstrap -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../dist/css/adminlte.css">
</head>

<body class="hold-transition register-page">
    <div class="register-box">
        <div class="register-logo">
            <a>Register Your school</a>
        </div>

        <div class="card">
            <div class="card-body register-card-body">
                <!-- <p class="login-box-msg">A little about your school</p> -->

                <form class="onboard_form" action="controller.php" runat="server" enctype="multipart/form-data">
                    <input type="hidden" name="action" value="reg_school">
                    <div class="input-group mb-3">
                        <input type="text" name="name" class="form-control" placeholder="School name" required>
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" name="address" autocomplete="address-level1" class="form-control" placeholder="e.g 15, John Doe Street" required>
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" name="city" class="form-control" placeholder="e.g Ikeja" required>
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" name="state" class="form-control" placeholder="e.g Lagos" required>
                    </div>
                    <div class="input-group mb-3">
                        <input type="text" name="country" class="form-control" placeholder="e.g Nigeria" required>
                    </div>
                    <div class="form-group mr-3" style="position:relative; max-width: 100px;">
                        <img id="image_profile_preview" title="click to select logo" src="../dist/img/logo-placeholder.png" alt="Logo" width="100" height="100">

                        <input type="file" name="logo" accept="image/png, image/jpg" id="image_profile_add" style="display: none;" onchange="preview_image(event)" class="form-control">
                        <label for="image_profile_add" style="position:absolute; color: transparent; width: 100%; height: 100%; left:0; top:0;">Select
                            Photo</label>
                        <p class="small mb-0">Click to select logo</p>
                        <!-- <p><strong>Note:</strong> Only .jpeg, .png formats allowed. Recommended size - 70 x 70 -->
                        <!-- </p> -->
                    </div>
                    <div class="row">
                        <!-- /.col -->
                        <div class="col-12">
                            <button type="submit" class="btn btn-primary btn-block">Next</button>
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
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script src="../dist/js/onboard.js"></script>
</body>

</html>