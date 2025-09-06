<?php
session_start();
include_once("model/connect.php");
$school_id = $_SESSION['school_id'];
?>
<div id="tabhead">
  <ul class="subjectnavpills nav nav-pills menu-scrollbar px-15" id="pills-tab" role="tablist" style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
    <!-- <li class="nav-item px-15" role="presentation">
    <button class="pill-link link-primary active" id="pills-all_subject-tab" onclick="load_subjects_by_cat('addsubject','display_all_subject','All')" data-toggle="pill" data-target="#pills-all_subject" type="button" role="tab" aria-controls="pills-all_subject" aria-selected="true">All</button>
  </li> -->
    <?php
    $select = mysqli_query($conn, "SELECT id,category_name FROM subject_cat WHERE school_id='{$_SESSION['school_id']}'");
    $category_list = [];
    $has_categories = false;
    while ($row = mysqli_fetch_array($select)) {
      $has_categories = true;
      $catwithoutspace = str_replace(' ', '', $row['category_name']);
      $category_list[] = $catwithoutspace;
      $active = count($category_list) == 1 ? 'active' : '';
    ?>
      <li class="nav-item subject_category_tab" role="presentation">
        <button class="pill-link link-primary subjectpage <?= $active ?>"
          id="pills-<?= $catwithoutspace ?>-tab"
          onclick="load_subjects_by_cat('addsubject','display_<?= $catwithoutspace ?>','<?= $row['id'] ?>')"
          data-element="display_<?= $catwithoutspace ?>"
          data-type="<?= $row['id'] ?>" data-toggle="pill"
          data-target="#pills-<?= $catwithoutspace ?>"
          type="button" role="tab" aria-controls="pills-<?= $catwithoutspace ?>"
          aria-selected="false"><?= $row['category_name'] ?></button>
      </li>
    <?php
    }
    ?>
    <?php
    if ($_SESSION['staff_type'] == 1 || $_SESSION['staff_type'] == 2 || $_SESSION['staff_type'] == 3 || $_SESSION['staff_type'] == 4) {
    ?>
      <li class="nav-item" role="presentation">
        <button data-toggle="modal" class="btn accent font-weight-bold d-flex" href="#add_category_modal" id="add_category_button"><span class="material-symbols-outlined">add</span>Add New</button>
      </li>
    <?php } ?>
  </ul>
</div>
<div class="tab-content addsubject px-15" id="pills-tabContent">

  <?php
  if ($has_categories) {
    for ($i = 0; $i < count($category_list); $i++) {
      $active = $i == 0 ? 'show active' : ''
  ?>
      <div class="subject_tabpane tab-pane fade <?= $active ?>" id="pills-<?= $category_list[$i] ?>" role="tabpanel" aria-labelledby="pills-<?= $category_list[$i] ?>-tab">
        <div class="display_<?= $category_list[$i] ?>">
          <p class="subject_preloader" style="display: none;"><i>Processing</i></p>
        </div>
      </div>
  <?php
    }
  } else {
    echo "<div class='tab-pane fade show active d-flex justify-content-center align-items-center'><p class='p-5'>No subject category created yet!</p></div>";
  }
  ?>

</div>
<script>
  $(document).ready(function() {
    $('#add_category_button').on('click', function() {
      $('.add_sub_cat_form')[0].reset();
      $('.subject_checkbox').prop('checked', false);
    });
  });

  window.onscroll = function() {
    scrollhandler()
  }
  var tabhead = document.getElementById("tabhead");
  var sticky = tabhead.offsetTop;

  function scrollhandler() {
    // alert('ll')
    if (window.scrollY >= sticky) {
      tabhead.classList.add("sticky")
    } else {
      tabhead.classList.remove("sticky")
    }
  }
  load_subjects_by_cat('addsubject', `${$(".pill-link.subjectpage.active").attr("data-element")}`, `${$(".pill-link.subjectpage.active").attr("data-type")}`)
</script>