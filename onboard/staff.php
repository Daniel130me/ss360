<?php
session_start();
include_once("../model/connect.php");
?>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Registration</title>

  <!-- Google Font: Source Sans Pro -->
  <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
  <!-- icheck bootstrap -->
  <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
  <!-- Toastr -->
  <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
  <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="../dist/css/adminlte.css">
  <style>
    /* Background image for the onboard pages */
    body.register-page {
      background-image: url('../dist/img/school_bg.jpg');
      background-size: cover;
      background-position: center center;
      background-repeat: no-repeat;
      position: relative;
    }

    /* Optional dark overlay to improve contrast */
    body.register-page::before {
      content: "";
      position: absolute;
      inset: 0;
      background: rgba(0,0,0,0.45);
      z-index: 0;
    }

    /* Make the container and cards appear above the overlay */
    .container,
    .register-logo,
    .card,
    .register-box {
      position: relative;
      z-index: 1;
    }
  </style>
  <style>
    @media (max-width: 576px) {
      .photo_resize {
        height: 215px;
        width: 200px;
      }
    }
  </style>
</head>

<body class="hold-transition register-page mt-5">
  <div class="container" style="">
  <div class="container">
    <!-- <div class="register-box" style="max-width: 60%; width:auto;"> -->


    <div class=>
      <div class="register-logo">
        <p>Register</p>
      </div>
      <div class="">
        <!-- <p class="login-box-msg">A little about your school</p> -->

        <form class="onboard_form" action="controller.php" runat="server" enctype="multipart/form-data">
          <input type="hidden" name="action" value="reg_staff">
          
          <input type="hidden" name="school_id" value="<?= $_SESSION['school_id'] ?>">
          <div class="container-fluid row">
            <div class="mx-0 mt-4 col-sm-4 col-md-3 col-12">
              <!-- <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                <label for="" class="mb-0">Select School</label>
                <select class="select2 form-control" name="school_id" required>
                  <option value="">Select school</option>
                  <?php {
                    $select = mysqli_query($conn, "SELECT id, school_name FROM school ORDER BY school_name ASC");
                    while ($school_row = mysqli_fetch_array($select)) {
                  ?>
                      <option value="<?= $school_row['id'] ?>"><?= $school_row['school_name'] ?></option>
                  <?php
                    }
                  }
                  ?>
                </select>
              </div> -->
              <div class="py-3 px-15 bg-white photo_resize" style="border-radius: 10px;">
                <div class="form-group mb-0" title="click to change photo" style="position:relative;">
                  <img id="image_profile_preview" style="width: 100%;" title="click to select photo" src="../dist/img/avatar.png" alt="Photo">

                  <input type="file" name="photo" accept="image/png, image/jpeg, image/jpg" id="image_profile_add" style="display: none;" onchange="preview_image(event)" class="form-control">
                  <label for="image_profile_add" style="position:absolute; color: transparent; width: 100%; height: 100%; left:0; top:0;">Select
                    Photo</label>
                  <p class="small mb-0 text-center">Click to select photo</p>
                </div>
              </div>
            </div>
            <div class="mx-0 mt-4 col-sm-8 col-md-9 col-12">
              <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
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
                  <div class="mb-3 col-sm-6 col-md-6 col-12">
                    <label class="mb-0 muted-text">Select your role</label>
                    <select class="form-control select2" name="staff_type" style="width: 100%;">
                      <option value="6">Select your role</option>
                      <?php
                      $selectclass = mysqli_query($conn, "SELECT id,type FROM staff_type ORDER BY id ASC");
                      while ($classrow = mysqli_fetch_array($selectclass)) {
                      ?>
                        <option value="<?= $classrow['id'] ?>"><?= $classrow['type'] ?></option>
                      <?php
                      }
                      ?>
                    </select>
                  </div>
                </div>
              </div>
              <div class="py-3 px-15 bg-white mt-3" style="border-radius: 10px;">
                <p class="font-weight-bold text-muted">Contact Information</p>
                <div class="row flex-wrap" style="border-bottom:5px solid #f4f7fa">
                  <div class="mb-3 col-sm-6 col-md-4 col-12">
                    <label class="mb-0 muted-text">Phone</label>
                    <input type="text" name="phone" class="form-control" placeholder="Phone number">
                  </div>
                  <div class="mb-3 col-sm-6 col-md-4 col-12">
                    <p class="mb-0 muted-text">Email address</p>
                    <input type="email" autocomplete="email" name="email" class="form-control" placeholder="Email address">
                  </div>
                  <div class="mb-3 col-sm-6 col-md-4 col-12">
                    <p class="mb-0 muted-text">Full address</p>
                    <input type="text" name="address" autocomplete="address-level1" class="form-control" placeholder="e.g. 10, Kings street, Lagos Island, Lagos">
                  </div>
                  <div class="mb-3 col-sm-6 col-md-4 col-12">
                    <p class="mb-0 muted-text">City</p>
                    <input type="text" name="city" autocomplete="address-level1" class="form-control" placeholder="City">
                  </div>
                  <div class="mb-3 col-sm-6 col-md-4 col-12">
                    <p class="mb-0 muted-text">State</p>
                    <input type="text" name="state" autocomplete="address-level1" class="form-control" placeholder="State">
                  </div>
                  <div class="mb-3 col-sm-6 col-md-4 col-12">
                    <p class="mb-0 muted-text">Country</p>
                    <input type="text" name="country" autocomplete="address-level1" class="form-control" placeholder="Country">
                  </div>
                </div>
                <div class="row flex-wrap" style="border-bottom:5px solid #f4f7fa">
                  <div class="mb-3 col-sm-6 col-md-4 col-12">
                    <label class="mb-0 muted-text">PIN</label>
                    <input type="password" name="password" id="password" autocomplete="new-password" class="form-control" placeholder="PIN" required>
                  </div>
                  <div class="mb-3 col-sm-6 col-md-4 col-12">
                    <label class="mb-0 muted-text">Confirm PIN</label>
                    <input type="password" name="passwordnew" required id="password1" class="form-control" onchange="ismatched()" placeholder="Confirm PIN" required>
                  </div>
                </div>
                <div class="card-foot">
                  <div class="text-center">
                    <small class="text-danger" id="add_staff_data_warning" style="display: none;">Staff already added</small>
                  </div>
                  <button type="submit" id="staff_reg_submit" class="btn btn-primary">Register</button>
                </div>
                <p>Already registered? <a href="login" class="accent mb-3 font-weight-bold">Login now</a></p>
              </div>
            </div>
          </div>

        </form>
      </div>
      <!-- </div> -->


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
  <script src="../plugins/select2/js/select2.full.min.js"></script>
  <script src="../dist/js/adminlte.min.js"></script>
  <!-- Toastr -->
  <script src="../plugins/toastr/toastr.min.js"></script>
  <script src="../dist/js/onboard.js"></script>
</body>

</html>