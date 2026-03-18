<?php
session_start();
include_once("model/connect.php");
$school_id = $_SESSION['school_id'];

$select = mysqli_query($conn, "SELECT hidden_skills FROM school WHERE id='$school_id'");
$row = mysqli_fetch_array($select);
$hidden_skills = json_decode($row['hidden_skills'], true) ?? [];

$behaviour_skills = [];
$psychomotive_skills = [];

// Fetch skills from database (Global default 0 + current school specific)
$skills_query = mysqli_query($conn, "SELECT * FROM skills WHERE school_id = 0 OR school_id = '$school_id' ORDER BY id ASC");
while ($skill_row = mysqli_fetch_array($skills_query)) {
    if ($skill_row['category'] == 'behaviour') {
        $behaviour_skills[$skill_row['skill_key']] = $skill_row['skill_label'];
    } elseif ($skill_row['category'] == 'psychomotor') {
        $psychomotive_skills[$skill_row['skill_key']] = $skill_row['skill_label'];
    }
}
?>
<form id="skills_config_form" class="settingsform" onsubmit="update_hidden_skills(event)">
    <input type="hidden" name="action" value="update_hidden_skills">

    <div class="mb-4 mt-4 info-container">
        <p class="font-weight-bold">General Behaviour</p>
        <p class="small text-muted">Select skills to HIDE from report cards and rating interface.</p>
        <div class="row">
            <?php foreach ($behaviour_skills as $key => $label): ?>
                <div class="col-md-4 mb-2">
                    <div class="icheck-primary d-inline">
                        <input type="checkbox" id="skill_<?= $key ?>" name="hidden_skills[]" value="<?= $key ?>"
                            <?= in_array($key, $hidden_skills) ? 'checked' : '' ?>>
                        <label for="skill_<?= $key ?>">
                            <?= $label ?>
                        </label>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    </div>

    <div class="mb-4 info-container">
        <p class="font-weight-bold">Psychomotive Skills</p>
        <p class="small text-muted">Select skills to HIDE from report cards and rating interface.</p>
        <div class="row">
            <?php foreach ($psychomotive_skills as $key => $label): ?>
                <div class="col-md-4 mb-2">
                    <div class="icheck-primary d-inline">
                        <input type="checkbox" id="skill_<?= $key ?>" name="hidden_skills[]" value="<?= $key ?>"
                            <?= in_array($key, $hidden_skills) ? 'checked' : '' ?>>
                        <label for="skill_<?= $key ?>">
                            <?= $label ?>
                        </label>
                    </div>
                </div>
            <?php endforeach; ?>
        </div>
    </div>

    <div class="row">
        <div class="col-12 col-md-auto mb-2 mb-md-0">
            <button type="submit" class="btn btn-primary btn-block btn-md-auto" title="Save skills configuration">Save
                Configuration</button>
        </div>
    </div>
</form>