<?php
session_start();
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
$is_g_table = filter_input(INPUT_GET, 'is_g_table', FILTER_SANITIZE_STRING);
if($is_g_table !== null ) {
    $where = 'and is_graduate = 1';
} else {
    $where = 'and is_graduate = 0';
}
// $select = mysqli_query($conn, "SELECT s.id,c.classname, s.firstname,s.middlename,s.lastname,s.class_id,s.dob,s.parent_id FROM students s, class c WHERE s.class_id=c.id AND s.school_id='$school_id' AND s.parent_id='$parent_id'");
// while ($row = mysqli_fetch_array($select)) {
//     $data[] = array('id' => $row['id'], 'classname' => $row['classname'], 'firstname' => $row['firstname'], 'lastname' => $row['lastname'], 'middlename' => $row['middlename'], 'class_id' => $row['class_id'], 'dob' => $row['dob'], 'parent_id' => $row['parent_id']);
// }

?>
<thead>
    <tr class="d-none">
        <th class=""></th>
    </tr>
</thead>
<tbody>
    <?php
    $select = mysqli_query($conn, "SELECT * FROM class WHERE school_id='$school_id' $where ORDER BY classname Asc");
   
    while ($row = mysqli_fetch_array($select)) {
    ?>
        <tr>

            <td style="font-size: 16px;">
                <p><?= $row['classname'] ?></p>
                <p class="small accent font-weight-bold"><?= get_total_student_in_class($row['id']) == 0 ? 'No' : get_total_student_in_class($row['id']) ?> students</p>
                <?php
                if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
                ?>
                    <div>
                        <a onclick="edit_class_info('<?= $row['id'] ?>')" class="btn p-0 text-primary mr-3">Edit</a>
                        <a onclick="get_class_info_to_delete('<?= $row['id'] ?>')" class="btn p-0 text-danger">Delete</a>
                    </div>
                <?php } ?>
            </td>
        </tr>
    <?php
    }
    ?>

</tbody>
<script>
    if ($.fn.DataTable.isDataTable('#class_table')) {
        $('#class_table').DataTable().destroy();
    }
    $('#class_table').DataTable({
        scrollY: '50vh',
        scrollX: true,
        ordering: false,
        paging: false,
    });
    $(document).ready(function() {
        $('.select2').select2()
    });
</script>
<?php
?>