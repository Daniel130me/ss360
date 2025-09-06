<?php
session_start();
include_once("model/connect.php");
$school_id = $_SESSION['school_id'];
// $select = mysqli_query($conn, "SELECT s.id,c.classname, s.firstname,s.middlename,s.lastname,s.class_id,s.dob,s.parent_id FROM students s, class c WHERE s.class_id=c.id AND s.school_id='$school_id' AND s.parent_id='$parent_id'");
// while ($row = mysqli_fetch_array($select)) {
//     $data[] = array('id' => $row['id'], 'classname' => $row['classname'], 'firstname' => $row['firstname'], 'lastname' => $row['lastname'], 'middlename' => $row['middlename'], 'class_id' => $row['class_id'], 'dob' => $row['dob'], 'parent_id' => $row['parent_id']);
// }

?>
<thead>
    <tr>
        <th>

            <!-- <div class="icheck-primary">
                <input type="checkbox" id="checkall">
                <label for="checkall">
                </label>
            </div> -->
        </th>
        <th></th>
    </tr>
</thead>
<tbody>
    <?php
    $select = mysqli_query($conn, "SELECT s.*, c.classname, t.type FROM staff s, class c, staff_type t WHERE t.id=s.staff_type AND  s.class_id=c.id AND s.school_id='$school_id' ORDER BY s.firstname ASC");
    while ($row = mysqli_fetch_array($select)) {
    ?>
        <tr>
            <td class="w-xs-20 mr-2">
                <?php
                if (!$row['photo']) {
                ?>
                    <img src="./dist/img/avatar5.png" width="50" height="50" class="img-circle" />
                <?php
                } else {
                ?>
                    <img src="../uploads/<?= $row['photo'] ?>" width="50" height="50" class="img-circle" />
                <?php } ?>
                <!-- <div class="icheck-primary">
                    <input type="checkbox" id="check<= $row['id'] ?>">
                    <label for="check<= $row['id'] ?>">
                    </label>
                </div> -->
            </td>
            <td class="">
                <p><?= $row['firstname'] . ' ' . $row['lastname'] . ' ' . $row['middlename'] ?></p>

                <!-- // if ($row['staff_type'] == 1 or $row['staff_type'] == 2 or $row['staff_type'] == 3 or $row['staff_type'] == 4) {
                //  -->
                <!-- <p class="small accent font-weight-bold muted-text">iop<= $row['type'] ?></p> -->

                <!-- // >
                    // $classname = '<ul><li class="small">Teacher</li><li class="small">Basic 2</li></ul>'; -->
                <?php $classname = $row['classname'] == 'No Class' ? '' : ' | ' . $row['classname']; ?>


                <p class="small accent font-weight-bold muted-text"><?= $row['type'] . $classname . ' | ' . ($row['status'] == 0 ? 'Inactive' : 'Active')  ?></p>

                <div>
                    <a onclick="view_staff_info('<?= $row['id'] ?>','<?= $row['staff_type'] ?>')" class="btn p-0 text-primary mr-3">View</a>
                    <?php
                    if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                    ?>
                        <a onclick="edit_staff_info('<?= $row['id'] ?>','<?= $row['staff_type'] ?>')" class="btn p-0 text-primary mr-3">Edit</a>
                        <a onclick="get_staff_info_to_delete('<?= $row['id'] ?>')" class="btn p-0 text-danger mr-3">Delete</a>
                    <?php }
                    if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                    ?>
                        <a onclick="get_classes('<?= $row['id'] ?>')" class="btn p-0 text-primary mr-3">Assign Classes</a>
                        <a onclick="get_subjects_and_classes('<?= $row['id'] ?>')" class="btn p-0 text-primary mr-3">Assign Subjects</a>

                        <?php if ($row['staff_type'] != 1 and $row['staff_type'] != 2 and $row['staff_type'] != 3 and $row['staff_type'] != 4 ) {
                        ?>
                            <a onclick="get_priviledges('<?= $row['id'] ?>')" class="btn p-0 text-primary">Assign Priviledges</a> <?php } ?>
                    <?php } ?>
                </div>
            </td>
        </tr>
    <?php
    }
    ?>

</tbody>
<script>
    if ($.fn.DataTable.isDataTable('#staff_tables')) {
        $('#staff_tables').DataTable().destroy();
    }
    $('#staff_tables').DataTable({
        scrollY: '50vh',
        scrollX: true,
        paging: false,
        ordering: false,
        scrollCollapse: true,
    });
    $(document).ready(function() {
        $('.select2').select2()
    });
</script>
<?php
?>