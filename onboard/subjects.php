<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>AdminLTE 3 | Registration Page</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- icheck bootstrap -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../dist/css/adminlte.min.css">
</head>

<body class="hold-transition register-page">
    <div class="register-box">
        <div class="register-logo">
            <a href="../../index2.html">Create Subjects</a>
        </div>

        <div class="card">
            <div class="card-body register-card-body">
                <!-- <p class="login-box-msg">A little about your school</p> -->

                <form class="onboard_form" action="controller.php">
                    <!-- prefill the subjects from database -->
                    <input type="hidden" name="action" value="reg_subjects">
                     <div id="subject_field">
                         <div class="form-group d-flex align-item-center flex-row mb-3">
                             <input type="text" name="mathematics" class="form-control" onblur="update_name(this)" value="Mathematics" placeholder="Subject" required>
                         </div>
                         <div class="form-group d-flex align-item-center flex-row mb-3 field">
                             <input type="text" name="english" class="form-control" value="English" onkeyup="update_name(this)" placeholder="Subject" required>
                             <button type="button" class="ml-2 bg-primary btn text-danger" onclick="remove_field()">x</button>
                         </div>
                     </div>
                    <div class="form-group mb-3">
                        <button type="button" id="add_more_btn" class="btn col-12 text-muted"><b><i>+ </i>Add More</b></button>
                    </div>
                    <div class="row">
                        <!-- /.col -->
                        <div class="col-8">
                            <button type="submit" class="btn btn-primary btn-block">Create Subject</button>
                        </div>
                        <div class="col-4">
                            <button type="submit" class="btn btn-block">Skip</button>
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
    <script src="../dist/js/onboard.js"></script>
</body>

</html>