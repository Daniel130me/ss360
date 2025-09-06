<?php
session_start();
include_once("../model/connect.php");
// echo "d";
$url = explode("/",$_SERVER['REQUEST_URI'])[2];

$select_school_id = mysqli_query($conn, "SELECT id,back_pic,logo FROM school WHERE url='$url'");
$row_sid = mysqli_fetch_array($select_school_id);
$school_id = $row_sid['id'];

// $url = ;
$backg = $row_sid['back_pic'];
$logo = $row_sid['logo'];
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Student Enrolment</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../plugins/fontawesome-free/css/all.min.css">
    <!-- icheck bootstrap -->
    <link rel="stylesheet" href="../../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Toastr -->
    <link rel="stylesheet" href="../../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../../plugins/toastr/toastr.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../../dist/css/adminlte.css">
    <style>
        @media (max-width: 576px) {
            .photo_resize {
                height: 215px;
                width: 200px;
            }
        }
    </style>
</head>

<body class="hold-transition register-page">
    <!-- <div class="overlay" style="width: 100%;height: 100%;background-color: #0099ff;position: absolute;opacity: .1;"></div> -->
    <div style="width:100%; height: 100%; background-image: url(../../uploads/<?= $backg ?>);background-size: cover;background-repeat: no-repeat; display:flex; justify-content:center; align-items:center;">

        <!-- <div class=> -->
        <!-- <div class="register-logo">
                <p>Register</p>
            </div> -->
        <!-- <div class=""> -->
        <!-- <p class="login-box-msg">A little about your school</p> -->

        <form class="onboard_form d-flex justify-content-center align-items-center" action="../../onboard/controller.php" runat="server" enctype="multipart/form-data">
            <input type="hidden" name="action" value="enrol_student_self">
            <input type="hidden" name="school_id" value="<?=$row_sid['id']?>">
            <!-- <input type="hidden" name="school_id" value="<= $row_sid['id']; ?>"> -->

            <div class="my-5 w-75">
                <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                    <!-- <div class="form-group mb-0" title="click to change photo" style="position:relative;">
                        <img id="image_profile_preview" style="width: 200px;" title="click to select photo" src="../../dist/img/avatar.png" alt="Photo">
                        <input type="file" name="photo" accept="image/png, image/jpeg, image/jpg" id="image_profile_add" style="display: none;" onchange="preview_image(event)" class="form-control">
                        <label for="image_profile_add" style="position:absolute; color: transparent; width: 100%; height: 100%; left:0; top:0;">Select
                            Photo</label>
                        <p class="small mb-0 text-center">Click to select photo</p>
                    </div> -->
                    <div class="d-flex justify-content-center align-items-center" style="border-bottom:5px solid #f4f7fa;">
                        <img id="image_profile_preview" class="py-3" style="width: 200px;" src="../../uploads/<?=$logo?>" alt="Photo">
                    </div>
                    <p class="font-weight-bold text-muted">Basic Data</p>
                    <div class="row flex-wrap">

                        <div class="mb-3 col-sm-6 col-md-6 col-12">
                            <label for="firstname" class="mb-0 muted-text">Firstname</label>
                            <input id="firstname" autocomplete="given-name" name="firstname" title="Your first name" type="text" placeholder="Firstname" class="form-control" required>
                        </div>
                        <div class="mb-3 col-sm-6 col-md-6 col-12">
                            <label for="lastname" class="mb-0 muted-text">Lastname</label>
                            <input name="lastname" type="text" autocomplete="family-name" title="Your last name or surname" placeholder="Lastname" class="form-control" required>
                        </div>
                        <div class="mb-3 col-sm-6 col-md-6 col-12">
                            <label class="mb-0 muted-text">Middlename</label>
                            <input type="text" autocomplete="given-name" title="Your middle name" name="middlename" placeholder="Middlename" class="form-control">
                        </div>

                        <div class="mb-3 col-sm-6 col-md-6 col-12">
                            <label class="mb-0 muted-text">Gender</label>
                            <select class="form-control select2" name="gender" style="width: 100%;" required>
                                <option value="">Select Gender</option>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                        <div class="mb-3 col-sm-6 col-12">
                            <p class="mb-0 muted-text">Proposed Class</p>
                            <select class="form-control select2" name="class_id" style="width: 100%;" required>
                                <?php
                                $selectclass = mysqli_query($conn, "SELECT id,classname FROM class WHERE school_id='$school_id'");
                                while ($classrow = mysqli_fetch_array($selectclass)) {
                               
                                    ?>
                                    <option value="<?= $classrow['id'] ?>"><?= $classrow['classname'] ?></option>
                                <?php
                                }
                                ?>
                            </select>
                            <div class="mb-3 col-sm-6 col-md-4 col-12">
                            <p class="mb-0 muted-text">Date of Birth</p>
                            <input type="date" autocomplete="date" name="dob" class="form-control" placeholder="Date of Birth">
                        </div>
                        </div>
                        <!-- <div class="mb-3 col-sm-6 col-md-6 col-12"> -->
                        <!-- <input type="hidden" name="staff_type" value="8"> -->
                        <!-- <label class="mb-0 muted-text">Select your role</label>
                                        <select class="form-control select2" name="staff_type" style="width: 100%;">
                                            <option value="6">Select your role</option>
                                            <php
                                            $selectclass = mysqli_query($conn, "SELECT id,type FROM staff_type ORDER BY id ASC");
                                            while ($classrow = mysqli_fetch_array($selectclass)) {
                                            ?>
                                                <option value="<= $classrow['id'] ?>"><= $classrow['type'] ?></option>
                                            <php
                                            }
                                            ?>
                                        </select> -->
                        <!-- </div> -->
                    </div>
                </div>
                <div class="py-3 px-15 bg-white mt-3" style="border-radius: 10px;">
                    <p class="font-weight-bold text-muted">Contact Information</p>
                    <div class="row flex-wrap pb-3" style="border-bottom:5px solid #f4f7fa">
                        <div class="mb-3 col-sm-6 col-md-4 col-12">
                            <label class="mb-0 muted-text">Phone number</label>
                            <input type="text" name="phone" class="form-control" placeholder="08123456789">
                        </div>
                        <div class="mb-3 col-sm-6 col-md-4 col-12">
                            <p class="mb-0 muted-text">Email address</p>
                            <input type="email" autocomplete="email" name="email" class="form-control" placeholder="Email address">
                        </div>
                        <div class="mb-3 col-sm-6 col-md-4 col-12">
                            <p class="mb-0 muted-text">Full address</p>
                            <input type="text" name="address" class="form-control" placeholder="e.g. 10, Kings street, Lagos Island, Lagos">
                        </div>
                        <div class="mb-3 col-sm-6 col-md-4 col-12">
                            <p class="mb-0 muted-text">City</p>
                            <input type="text" name="city" class="form-control" placeholder="City">
                        </div>
                        <div class="mb-3 col-sm-6 col-md-4 col-12">
                            <p class="mb-0 muted-text">State</p>
                            <input type="text" name="state" class="form-control" placeholder="State">
                        </div>
                        <div class="mb-3 col-sm-6 col-md-4 col-12">
                            <p class="mb-0 muted-text">Country</p>
                            <input type="text" name="country" class="form-control" placeholder="Country">
                        </div>
                    </div>
                    <!-- <div class="row flex-wrap mt-3" style="">
                        <div class="mb-3 col-sm-6 col-md-4 col-12">
                            <label class="mb-0 muted-text">Password</label>
                            <input type="password" name="password" id="password" autocomplete="new-password" class="form-control" placeholder="Password" required>
                        </div>
                        <div class="mb-3 col-sm-6 col-md-4 col-12">
                            <label class="mb-0 muted-text">Confirm Password</label>
                            <input type="password" name="passwordnew" required id="password1" class="form-control" onchange="ismatched()" placeholder="Confirm Password" required>
                        </div>
                    </div> -->
                    <div class="card-foot">
                        <div class="text-center">
                            <small class="text-danger" id="add_staff_data_warning" style="display: none;">Staff already added</small>
                        </div>
                        <button type="submit" id="staff_reg_submit" class="btn btn-primary">Register</button>
                    </div>
                    <p>Already registered? <a href="../login" class="accent mb-3 font-weight-bold">Login now</a></p>
                </div>
            </div>
        </form>
        <!-- </div> -->
        <!-- </div> -->


        <!-- </div> -->
        <!-- /.form-box -->
    </div><!-- /.card -->
    <!-- </div> -->
    <!-- /.register-box -->

    <!-- jQuery -->
    <script src="../../plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="../../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../../plugins/select2/js/select2.full.min.js"></script>
    <script src="../../dist/js/adminlte.min.js"></script>
    <!-- Toastr -->
    <script src="../../plugins/toastr/toastr.min.js"></script>
    <script src="../../dist/js/onboard.js?v=12"></script>
</body>

</html>