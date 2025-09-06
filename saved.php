<div class="head">
    <div>
        <img src="uploads/logo-placeholder.png" width="100" height="100" />
    </div>
    <div>
        <h1>CELEBRITY INTERNATION SCHOOL</h1>
        <h4>ADDRESS: 22 PHASE II, HOUSING ESTATE LOKONGOMA, 1ST GATE, LOKOJA</h4>
    </div>
</div>
<div class="biodata">
    <div class="d-flex">
        <div class="d-flex mr-2">
            <label style="width: 135px; height:21px;">NAME OF STUDENT:</label>
            <input type="text" style="width: 400px;" class="bottom_border_input" id="fullname" value="<?= $biorow['firstname'] ?>">
        </div>
        <div class="d-flex">
            <label style="width: 35px;">AGE:</label>
            <input type="text" style="width: 165px;" class="bottom_border_input" value="<?= $biorow['dob'] ?>" id="age">
        </div>
    </div>
</div>
<div class="row">
    <div class="col-8">
        <label>CLASS:</label>
        <input type="text" value="<?= get_class_by_classid($biorow['class_id']) ?>" id="class">
    </div>
    <div class="col-4">
        <label>NO OF ATTENDANCE:</label>
        <input type="text" class="form-control" id="attendance">
    </div>
    <div class="col-4">
        <label>NO OF TIMES SCHOOL OPENED:</label>
        <input type="text" class="form-control" id="open_times">
    </div>
    <div class="col-4">
        <label>NO. IN CLASS</label>
        <input type="text" class="form-control" value='25' id="classno">
    </div>
    <div class="col-4">
        <label>NEXT TERM BEGINS</label>
        <input type="text" class="form-control" value="23-12-2024" id="">
    </div>
</div>
<div>
    <table>
        <thead>
            <tr>
                <th>Subject</th>
                <th class="<?= $setrow['ca1'] == 0 ? 'd-none' : '' ?>">CA1</th>
                <th class="<?= $setrow['ca2'] == 0 ? 'd-none' : '' ?>">CA2</th>
                <th class="<?= $setrow['ca3'] == 0 ? 'd-none' : '' ?>">CA3</th>
                <th class="<?= $setrow['practical'] == 0 ? 'd-none' : '' ?>">PRACTICAL</th>
                <th class="<?= $setrow['exam'] == 0 ? 'd-none' : '' ?>">EXAM</th>
                <th>TOTAL</th>
                <th>TOTAL(%)</th>
                <th>GRADE</th>
            </tr>
        </thead>
        <tbody>
            <?php
            $select_score = mysqli_query($conn, "SELECT subject_id, ca1, ca1Total, ca2, ca2Total, ca3, ca3Total, pra, praTotal, exam, examTotal FROM skulscores WHERE school_id='$school_id' AND student_id='$student_id'");
            while ($score_row = mysqli_fetch_array($select_score)) {
            ?>
                <tr>
                    <td><?= getsubjectbyid($score_row['subject_id']) ?></td>
                    <td class="<?= $setrow['ca1'] == 0 ? 'd-none score' : 'score' ?>" data-score="<?= $score_row['ca1'] ?>" data-max-score="<?= $score_row['ca1Total'] ?>"><?= $score_row['ca1'] ?></td>
                    <td class="<?= $setrow['ca2'] == 0 ? 'd-none score' : 'score' ?>" data-score="<?= $score_row['ca2'] ?>" data-max-score="<?= $score_row['ca2Total'] ?>"><?= $score_row['ca2'] ?></td>
                    <td class="<?= $setrow['ca3'] == 0 ? 'd-none score' : 'score' ?>" data-score="<?= $score_row['ca3'] ?>" data-max-score="<?= $score_row['ca3Total'] ?>"><?= $score_row['ca3'] ?></td>
                    <td class="<?= $setrow['practical'] == 0 ? 'd-none score' : 'score' ?>" data-score="<?= $score_row['pra'] ?>" data-max-score="<?= $score_row['praTotal'] ?>"><?= $score_row['pra'] ?></td>
                    <td class="<?= $setrow['exam'] == 0 ? 'd-none score' : 'score' ?>" data-score="<?= $score_row['exam'] ?>" data-max-score="<?= $score_row['examTotal'] ?>"><?= $score_row['exam'] ?></td>
                    <td class="total-score"></td>
                    <td class="percentage"></td>
                    <td class="grade"></td>
                </tr>
            <?php
            }
            ?>
        </tbody>
    </table>
</div>
<div>
    <div class="col-4">
        <label>TOTAL MARKS SCORED</label>
        <input type="text" class="form-control" value="233" id="">
    </div>
    <div class="col-4">
        <label>PERCENTAGE</label>
        <input type="text" class="form-control" value="23%" id="">
    </div>
    <div class="col-4">
        <label>FORM MASTER'S REMARK</label>
        <input type="text" class="form-control" value="He is promising and gentle">
    </div>
    <div class="col-4">
        <label>PRINCIPAL'S REMARK</label>
        <input type="text" class="form-control" value="Very good result, promoted to the next class">
    </div>
    <div class="col-4">
        <label>FORM MASTER'S SIGNATURE</label>
        <input type="text" class="form-control">
    </div>
    <div class="col-4">
        <label>PRINCIPAL'S SIGNATURE & STAMP</label>
        <input type="text" class="form-control">
    </div>
    <div class="col-4">
        <label>NEXT TERM FEE (N):</label>
        <input type="text" class="form-control" value="23,000">
    </div>
    <div class="col-4">
        <label>OUTSTANDING FEE (N):</label>
        <input type="text" class="form-control" value="2,000">
    </div>
</div>