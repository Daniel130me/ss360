<?php
session_start();
include_once("model/connect.php");
$school_id = $_SESSION['school_id'];
$select = mysqli_query($conn, "SELECT s.session_id as session,s.term_id as term_id, t.* FROM skul_settings t, school s WHERE t.school_id='$school_id' AND s.id=t.school_id AND t.session_id=s.session_id AND s.term_id=t.term_id");

// $select = mysqli_query($conn, "SELECT s.session_id as session,s.term_id as term_id, t.* FROM skul_settings t, school s WHERE t.school_id='$school_id' AND s.id=t.school_id AND t.session_id=s.session_id");
$row = mysqli_fetch_array($select);
?>
<input type="hidden" name="action" value="settings">
<div class="info-container mt-4 mb-4">
    <div class="form-group mb-4">
        <p class="p-0 mb-0 muted-text">Select Session</p>
        <select name="session_id" id="singleSessionValue" class="form-control select2" id="" style="max-width: 120px;">
            <?php
            $select_session = mysqli_query($conn, "SELECT id, session FROM sessions ORDER BY session ASC");

            while ($row_session = mysqli_fetch_array($select_session)) {
                if ($row['session'] === $row_session['id']) {
            ?>
                    <option selected value="<?= $row_session['id'] ?>"><?= $row_session['session'] ?></option>
                <?php
                } else {
                ?>
                    <option value="<?= $row_session['id'] ?>"><?= $row_session['session'] ?></option>
            <?php }
            } ?>
        </select>
    </div>

    <!-- <div class="info-container mb-4">
        <p class="font-weight-bold">Grade setting</p>
        <div id="">
            <a class="btn select_btn grade_type active my-1 mr-2" data-name="" id="sentence" onclick="toggle_grade_type(this)">Sentence Type</a>
            <a class="btn select_btn grade_type my-1 mr-2" data-name="2" id="letter" onclick="toggle_grade_type(this)">Letter Type</a>
        </div>
        <div>

        </div>
    </div> -->
    <div class="info-container mb-4">
        <p class="font-weight-bold">Assessment setting</p>
        <div class="d-flex flex-wrap mt-2">
            <div class="icheck-primary mr-4">
                <input type="checkbox" name="ca1" id="ca1" <?= $row['ca1'] == '1' ? 'checked' : '' ?>>
                <label for="ca1">CA1
                </label>
            </div>
            <div class="icheck-primary mr-4">
                <input type="checkbox" name="ca2" id="ca2" <?= $row['ca2'] == '1' ? 'checked' : '' ?>>
                <label for="ca2">CA2
                </label>
            </div>
            <div class="icheck-primary mr-4">
                <input type="checkbox" name="ca3" id="ca3" <?= $row['ca3'] == '1' ? 'checked' : '' ?>>
                <label for="ca3">CA3
                </label>
            </div>
            <div class="icheck-primary mr-4">
                <input type="checkbox" name="practical" id="practical" <?= $row['practical'] == '1' ? 'checked' : '' ?>>
                <label for="practical">Practical
                </label>
            </div>
            <div class="icheck-primary">
                <input type="checkbox" name="exam" id="exam" <?= $row['exam'] == '1' ? 'checked' : '' ?>>
                <label for="exam">Exam
                </label>
            </div>
        </div>
    </div>
    <p class="font-weight-bold">Term setting</p>
    <div id="">
        <p class="p-0 mb-0 muted-text">Select Current Term</p>
        <a class="btn select_btn term_setting <?= $row['term_id'] == '1' ? 'active' : ''?> my-1 mr-2" data-name="1" onclick="toggle_term_setting(this)">1st Term</a>
        <a class="btn select_btn term_setting <?= $row['term_id'] == '2' ? 'active' : ''?> my-1 mr-2" data-name="2" onclick="toggle_term_setting(this)">2nd Term</a>
        <a class="btn select_btn term_setting <?= $row['term_id'] == '3' ? 'active' : ''?> my-1 mr-2" data-name="3" onclick="toggle_term_setting(this)">3rd Term</a>
    </div>
    <div class="row mb-2">
        <!--<div class="form-group col-6 col-sm-4 ml-0 mt-2">-->
        <!--    <p class="p-0 mb-0 muted-text">1st Term commences</p>-->
        <!--    <input type="date" name="first_term_date" value="<= $row['first'] ?>" class="form-control">-->
        <!--</div>-->
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">2nd Term commences</p>
            <input type="date" name="second_term_date" value="<?= $row['second'] ?>" class="form-control">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">3rd Term commences</p>
            <input type="date" name="third_term_date" value="<?= $row['third'] ?>" class="form-control">
        </div>
        <div class="form-group col-6 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 muted-text">1st Term commences[new session]</p>
            <input type="date" name="first_term_date" value="<?= $row['first'] ?>" class="form-control">
        </div>
    </div>
    <div class="row mb-3">
        <div class="form-group col-12 col-sm-4 ml-0 mt-2">
            <p class="p-0 mb-0 font-weight-bold">No of Times School Open</p>
            <input type="number" placeholder="90" title="number of times school opens" name="school_open" value="<?=$row['school_open']?>" id="school_open" class="form-control">
        </div>
    </div>
    <p class="font-weight-bold">Grade setting</p>
    <?php
    $skul_setting = json_decode($_SESSION['skul_settings'],true);
    $grade = json_decode($skul_setting['grading'],true);
    foreach($grade as $key => $value) {
    ?>
    <div class="d-flex align-items-center">
        <div class="form-group mr-2">
            <p class="p-0 mb-0 muted-text small">Grade</p>
            <input style="max-width: 100px;" type="text" name="" value="<?=$key?>" class="form-control grade_letter">
        </div>
        <div class="form-group">
            <p class="p-0 mb-0 muted-text small">Start from</p>
            <input style="max-width: 100px;" type="number" name="" value="<?=$value?>" class="form-control grade_value">
        </div>
    </div>
    <?php } ?>

</div>
<div class="row">
    <div class="col-12 col-md-auto mb-2 mb-md-0">
        <button type="submit" class="btn btn-primary btn-block btn-md-auto">Save Settings</button>
    </div>
</div>
<script>
    const gvalue = document.querySelectorAll(".grade_value")[document.querySelectorAll(".grade_value").length-1].disabled = true
</script>