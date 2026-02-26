    // if ($action === 'get_stud_byClass_comment') {
    //     $school_id = $_SESSION['school_id'];
    //     $class_id = test_input($_POST['class_id']);
    //     $session = test_input($_POST['session']);
    //     $term = test_input($_POST['term']);
    //     $select = mysqli_query($conn, "SELECT c.classname,c.id as class_id,s.* FROM students s, class c WHERE s.class_id=c.id AND s.class_id='$class_id' AND s.school_id='$school_id' ORDER BY s.lastname DESC");
    //     if (mysqli_num_rows($select) < 1) {
    //         echo "nothinnow";
    //         exit;
    //     }
    // ?>
    //     <thead>
    //         <tr>
    //             <th>
    //                 Name
    //             </th>
    //             <th>
    //                 Teacher's comment
    //             </th>
    //             <th>
    //                 Skills
    //             </th>
    //             <?php
    //             if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
    //             ?>
    //                 <th>
    //                     Head Teacher's comment
    //                 </th>
    //             <?php } ?>
    //         </tr>
    //     </thead>
    //     <tbody>
    //         <?php

    //         while ($row = mysqli_fetch_array($select)) {
    //         ?>
    //             <tr class="comment_tb_row">
    //                 <!-- <td style="" class="w-xs-20 px-2">
    //                 <php if (!$row['photo']) { ?>
    //                     <img src="./dist/img/avatar5.png" width="50" height="50" class="img-circle" />
    //                 <php } else { ?>
    //                     <img src="uploads/<?= $row['photo'] ?>" width="50" height="50" class="img-circle" />
    //                 <php } ?>
    //             </td> -->
    //                 <td class="">
    //                     <div>
    //                         <p style="font-size: 16px;"><?= $row['lastname'] ?> <?= $row['firstname'] . ' ' . $row['middlename'] ?></p>

    //                     </div>
    //                 </td>
    //                 <td>
    //                     <?php
    //                     $select_teachercomment = mysqli_query($conn, "SELECT comment FROM comment WHERE role_type='0' AND school_id='$school_id' AND class_id='$class_id' AND session_id='$session' AND term_id='$term' AND comment_type='1' AND student_id='{$row['id']}'");
    //                     if (mysqli_num_rows($select_teachercomment) > 0) {
    //                         $comment_row = mysqli_fetch_array($select_teachercomment);
    //                         $comment_teacher = $comment_row['comment'];
    //                     } else {
    //                         $comment_teacher = '';
    //                     }
    //                     ?>
    //                      <textarea name="" rows="2" cols="" class="w-100 teacher_comment_comment" style="padding: 5px; border-radius:5px; margin-bottom: -5px;" placeholder="Teacher's comment"><?= $comment_teacher ?></textarea>
    //                     <a href="#suggestionModal" data-toggle="modal" data-student_id="<?= $row['id'] ?>" data-student_name="<?= htmlspecialchars($row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename']) ?>" class="accent open-suggestion-modal d-block small">Suggest Comment</a>
    //                 </td>
    //                 <td>
    //                     <button type="button" class="btn btn-primary" onclick="get_comment_skills('<?= $row['id'] ?>')">Skills</button>
    //                 </td>
    //                 <?php
    //                 $select_principal_comment = mysqli_query($conn, "SELECT comment FROM comment WHERE role_type='1' AND school_id='$school_id' AND class_id='$class_id' AND session_id='$session' AND term_id='$term' AND comment_type='1' AND student_id='{$row['id']}'");
    //                 if (mysqli_num_rows($select_principal_comment) > 0) {
    //                     $comment_row = mysqli_fetch_array($select_principal_comment);
    //                     $comment_principal = $comment_row['comment'];
    //                 } else {
    //                     $comment_principal = '';
    //                 }
    //                 ?>
    //                 <input type="hidden" name="" class="student_id_comment" value="<?= $row['id'] ?>">
    //                 <?php
    //                 if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
    //                 ?>
    //                   <td>
    //                         <textarea name="" rows="2" cols="" class="w-100 principal_comment_comment" style="padding: 5px; border-radius:5px; margin-bottom:-5px;" placeholder="Head Teacher's comment"><?= $comment_principal ?></textarea>
    //                         <a href="#suggestionModal" data-toggle="modal" data-student_id="<?= $row['id'] ?>" data-student_name="<?= htmlspecialchars($row['lastname'] . ' ' . $row['firstname'] . ' ' . $row['middlename']) ?>" class="accent open-suggestion-modal d-block small">Suggest Comment</a>
    //                     </td>
    //                 <?php } ?>
    //             </tr>
    //         <?php
    //         }
    //         ?>
    //         </body>
    //         <script>
    //             if ($.fn.DataTable.isDataTable('#student_table_comment')) {
    //                 $('#student_table_comment').DataTable().destroy();
    //             }
    //             $('#student_table_comment').DataTable({
    //                 scrollY: '50vh',
    //                 scrollX: true,
    //                 paging: false,
    //                 ordering: false,
    //             });
    //         </script>
    //         <?php
    //     }