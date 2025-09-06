<?php
session_start();
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];

$select = mysqli_query($conn, "SELECT * FROM parent WHERE id='{$_SESSION['userid']}' AND school_id='$school_id'");
if ($row = mysqli_fetch_array($select)) {
?>
    <!-- <div href="" class="px-15 pt-15 border-bottom" style="padding-bottom: 30px;">
        <img src="uploads/<= $row['photo'] ?>" alt="" class="brand-image img-circle elevation-5" style="width:250px; height:250px; object-fit:cover;">
    </div> -->
    <div class="mt-4">
        <p class="font-weight-bold small muted-text">Name</p>
        <p><?= $row['firstname'] . ' ' . $row['lastname'] ?></p>
    </div>
    <!-- <div class="mt-4">
        <p class="font-weight-bold small muted-text">Role</p>
        <p><= get_staff_type_in_name($_SESSION['staff_type']) ?></p>
    </div> -->
    <!-- <div class="mt-3">
        <p class="font-weight-bold small muted-text">Gender</p>
        <p><= $row['gender'] == '' ? 'Not stated' : $row['gender'] ?></p>
    </div> -->
    <div class="mt-3">
        <p class="font-weight-bold small muted-text">Phone Number</p>
        <p><?= $row['phone'] ?></p>
    </div>
    <div class="mt-3">
        <p class="font-weight-bold small muted-text">Email Address</p>
        <p><?= $row['email'] ?></p>
    </div>
    <div class="mt-3">
        <p class="font-weight-bold small muted-text">Address</p>
        <p><?= $row['address'] == '' ? 'Nil' : $row['address'] ?></p>
    </div>
    <div class="mt-3">
        <p class="font-weight-bold small muted-text">City</p>
        <p><?= $row['city'] == '' ? 'Nil' : $row['city'] ?></p>
    </div>
    <div class="mt-3">
        <p class="font-weight-bold small muted-text">State</p>
        <p><?= $row['state'] == '' ? 'Nil' : $row['state'] ?></p>
    </div>
    <div class="mt-3">
        <p class="font-weight-bold small muted-text">Country</p>
        <p><?= $row['country'] == '' ? 'Nil' : $row['country'] ?></p>
    </div>
    <!-- <div class="mt-3">
        <p class="font-weight-bold small muted-text">Class Assigned</p>
        <php
        $class_assigned = explode(",",$row['class_id']);
        echo count($class_assigned);
        if(count($class_assigned) > 1 && $row['class_id'] != '0') {
            $classes = "<ul style='display: flex; gap: 30px; padding-left: 17px;'>";
            foreach($class_assigned as $id) {
                $classes .= "<li>".get_class_by_classid($id)."</li>";
            }
            $classes .= "</ul>";
        } elseif (count($class_assigned) == 1 && $row['class_id'] != '0') {
            echo 'i';
            $classes = get_class_by_classid($row['class_id']);
        }elseif($row['class_id'] == '') {
            $classes = 'Not assigned';
        }
        ?>
        <p><=$classes?></p>
    </div> -->
<?php 
}
if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
?>
<div class="row mt-3">
    <div class="col-12 col-md-auto mb-2 mb-md-0">
        <button class="btn btn-primary btn-block btn-md-auto" onclick="edit_parent_info('<?= $row['id'] ?>')">Edit Profile</button>
    </div>
</div>
<?php } ?>