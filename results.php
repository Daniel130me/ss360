<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
$hidden_skills = json_decode($_SESSION['hidden_row'], true) ?? [];
// echo $_SESSION['userid'];
// echo $_SESSION['class_id'];
// exit;
?>
<!DOCTYPE html>
<!--
This is a starter template page. Use this page to start your new project from
scratch. This page gets rid of all links and provides the needed markup only.
-->
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Result</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet"
        href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Select2 -->
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <!-- Add the new sidebar CSS -->
    <!-- <link rel="stylesheet" href="../css/sidebar.css"> -->
    <style>
        #other_select .select2-selection.select2-selection--single {
            display: none;
        }

        #other_select .select2-container {
            display: none;
        }

        body {
            background: linear-gradient(135deg, #e0e7ff 0%, #f8fafc 100%);
            min-height: 100vh;
        }

        .user-panel img {
            border: 2px solid #6366f1;
            box-shadow: 0 2px 8px rgba(99, 102, 241, 0.15);
        }

        .hero-section {
            background: linear-gradient(120deg, #000000 0%, #818cf8 100%);
            color: #fff;
            /* border-radius: 24px; */
            padding: 40px 30px 30px 30px;
            margin-bottom: 40px;
            box-shadow: 0 8px 32px rgba(99, 102, 241, 0.12);
            text-align: center;
            position: relative;
            overflow: hidden;
        }

        .hero-section h1 {
            font-size: 2.5rem;
            font-weight: 700;
            margin-bottom: 10px;
            letter-spacing: 1px;
        }

        .hero-section p {
            font-size: 1.2rem;
            opacity: 0.95;
        }

        .hero-section::after {
            content: '';
            position: absolute;
            right: -60px;
            top: -60px;
            width: 180px;
            height: 180px;
            background: rgba(255, 255, 255, 0.08);
            border-radius: 50%;
            z-index: 0;
        }

        .fade-in {
            opacity: 0;
            animation: fadeIn 1.2s ease-in forwards;
        }

        @keyframes fadeIn {
            to {
                opacity: 1;
            }
        }
    </style>
</head>

<body class="hold-transition sidebar-mini">
    <div class="wrapper">
        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper ml-0"
            style="min-height: 590.4px; background-color: #f4f7fa; padding-bottom: 100px;">
            <div id="other_select">

                <input type="hidden" id="report_page" value="report_scores">
                <!--<input type="hidden" name="session_id" id="select_session_field" value="<= $_SESSION['session_id'] ?>">-->
                <input type="hidden" name="class_id" id="select_class_field" value="<?= $_SESSION['class_id'] ?>">
                <input type="hidden" name="term_id" id="select_term_field" value="<?= $_SESSION['term_id'] ?>">
                <input type="hidden" name="student_id" id="select_student_field" value="<?= $_SESSION['userid'] ?>">
            </div>

            <!-- Main content -->
            <div class="content fade-in p-0">
                <div class="hero-section d-flex flex-column align-items-center justify-content-center"
                    style="position: relative;">
                    <div style="position: absolute; top: 20px; right: 30px; z-index:1;">
                        <a href="logout" title="Logout"
                            style="color: #fff; display: inline-block; text-decoration: none;">
                            <span class="material-symbols-outlined"
                                style="font-size: 2.2rem; vertical-align: middle; cursor: pointer;">logout</span>
                        </a>
                    </div>
                    <img src="<?php echo isset($_SESSION['photo']) ? '../uploads/' . $_SESSION['photo'] : '../dist/img/avatar.png'; ?>"
                        alt="Profile"
                        style="width: 80px; height: 80px; object-fit: cover; border-radius: 50%; box-shadow: 0 2px 8px rgba(99,102,241,0.15); margin-bottom: 18px; border: 3px solid #fff;">
                    <h1>Results</h1>
                    <p>Your personalized space for all results.</p>
                </div>
                <!--/. container-fluid -->
                <div class="container-fluid">
                    <div id="session_select"
                        class="input-group mb-3 d-flex align-items-md-center align-items-start pl-2"
                        style="width: 300px;">
                        <label for="" class="mb-0 mr-2 text-muted">Select Session:</label>
                        <select class="form-control select2" onchange="get_score_data()" id="select_session_field"
                            style="width: 50%;">
                            <?php
                            $select = mysqli_query($conn, "SELECT id,session FROM sessions ORDER BY session ASC");
                            while ($row = mysqli_fetch_array($select)) {
                                if ($row['id'] == $_SESSION['session_id']) {
                                    echo '<option value="' . $row['id'] . '" selected>' . $row['session'] . '</option>';
                                } else {
                                    ?>
                                    <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                    <?php
                                }
                            }
                            ?>
                        </select>
                    </div>
                    <div class="py-3 px-15 bg-white data_overlay" style="border-radius: 10px; position: relative"></div>
                    <div class="thecontentbox" style="display: none">
                        <div class="container-fluid" id="">
                            <div class="py-3 px-15 bg-white space_content_box"
                                style="border-radius: 10px; position: relative">
                                <!-- <div id=""> -->
                                <div id="filterTerm" class="w-100">
                                    <ul class="menu-scrollbar px-0" id="" role=""
                                        style="flex-wrap: nowrap; overflow: auto; width: 100%; white-space: nowrap">
                                        <button
                                            class="btn select_btn term my-1 <?= $_SESSION['term_id'] == '1' ? 'active' : '' ?> mr-2"
                                            data-name="1" id="first" onclick="toggletermfilterClass(this)">1st
                                            Term</button>
                                        <button
                                            class="btn select_btn term my-1 <?= $_SESSION['term_id'] == '2' ? 'active' : '' ?> mr-2"
                                            data-name="2" id="second" onclick="toggletermfilterClass(this)">2nd
                                            Term</button>
                                        <button
                                            class="btn select_btn term my-1 <?= $_SESSION['term_id'] == '3' ? 'active' : '' ?> mr-2"
                                            data-name="3" id="third" onclick="toggletermfilterClass(this)">3rd
                                            Term</button>
                                        <button class="btn select_btn term my-1 mr-2" data-name="summary" id="summary"
                                            onclick="toggletermfilterClass(this)">Summary</button>
                                    </ul>
                                </div>
                                <div class="d-flex align-items-center">
                                    <button type="button"
                                        style="padding: 4px 1px 0px 2px; background-color:white; border-radius: 5px; border:none;"
                                        id="table_visual_Score_toggle" class="table_display d-flex accent"
                                        onclick="table_visual_Score_toggle(this)">
                                        <i class="material-symbols-outlined mr-1">legend_toggle</i> Show Chart
                                    </button>
                                </div>
                                <!-- </div> -->
                                <div id="table_visuals_display" class="pt-3">

                                </div>
                                <div class="line_and_term_based_contents">
                                    <div class="hr my-4" style="height: 10px; width: 100%; background-color: #ededed;">
                                    </div>
                                    <div class="d-flex flex-wrap" style="gap: 20px;">
                                        <div id="view_teacher_comment_container" class="mr-5">
                                            <p class="font-weight-bold text-muted">Teacher's Comment</p>
                                            <p class="" id="theteacher_comment"></p>
                                        </div>
                                        <div id="view_principal_comment_container" class="mr-5">
                                            <p class="font-weight-bold text-muted">Principal/Propietor's Comment</p>
                                            <p class="" id="theprincipal_comment"></p>
                                        </div>
                                        <div class="mr-5">
                                            <p class="font-weight-bold text-muted">General Behaviour</p>
                                            <table class="behaviour_report_table w-100">
                                                <thead>
                                                    <tr class="d-none">
                                                        <th></th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <?php if (!in_array('punctuality', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Punctuality</td>
                                                            <td class="punctuality"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('classattendance', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Classroom attendance</td>
                                                            <td class="classattendance"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('resptoass', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Response to assignment</td>
                                                            <td class="resptoass"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('Neatness', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Neatness</td>
                                                            <td class="Neatness"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('Politeness', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Politeness</td>
                                                            <td class="Politeness"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('Honesty', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Honesty</td>
                                                            <td class="Honesty"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('selfcontrol', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Self control</td>
                                                            <td class="selfcontrol"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('relationship', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Relationship with others</td>
                                                            <td class="relationship"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('organizationability', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Organizational Ability</td>
                                                            <td class="organizationability"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                </tbody>
                                            </table>
                                        </div>

                                        <div>
                                            <p class="font-weight-bold text-muted">Psychomotive Skills</p>
                                            <table class="behaviour_report_table w-100">
                                                <thead>
                                                    <tr class="d-none">
                                                        <th></th>
                                                        <th></th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <?php if (!in_array('Obedience', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Obedience</td>
                                                            <td class="Obedience"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('Creativity', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Creativity</td>
                                                            <td class="Creativity"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('Writing', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Writing</td>
                                                            <td class="Writing"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('Fluency', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Fluency</td>
                                                            <td class="Fluency"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('Sport', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Sport</td>
                                                            <td class="Sport"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('Games', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Games</td>
                                                            <td class="Games"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('DrawingPainting', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Drawing & Painting</td>
                                                            <td class="DrawingPainting"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('Music', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Music Performance</td>
                                                            <td class="Music"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('HandlingTools', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Handling Tools</td>
                                                            <td class="HandlingTools"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                    <?php if (!in_array('Crafts', $hidden_skills)): ?>
                                                        <tr>
                                                            <td>Craft</td>
                                                            <td class="Crafts"></td>
                                                        </tr>
                                                    <?php endif; ?>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                    <!-- <button class="btn accent font-weight-bold w-100 btn-md-auto" id="preview-pdf" onclick="download_report_card('student_page')">View Student Report Card</button> -->
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!-- /.row -->
        </div><!-- /.container-fluid -->
    </div>

    <!-- REQUIRED SCRIPTS -->

    <!-- jQuery -->
    <script src="../plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- Select2 -->
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <script src="../dist/js/skul.js"></script>
    <script>
        var skul_settings = <?= $_SESSION['skul_settings'] ?>;
        let myschl = <?php echo $_SESSION['school_id'] ?>;
        // get_notices('<?= $_SESSION['userid'] ?>', '1');
        loadSettings().done(() => {

            get_score_data()
        });
        // Add this after existing scripts
        $(document).ready(function () {
            loadAssignments();
        });

        function loadAssignments() {
            $.ajax({
                url: '../controller_new.php',
                type: 'POST',
                data: {
                    action: 'get_student_assignments',
                    class_id: '<?= $_SESSION['class_id'] ?>',
                    student_id: '<?= $_SESSION['userid'] ?>'
                },
                success: function (response) {
                    if (response.success) {
                        let html = '';
                        if (response.assignments.length === 0) {
                            html = '<div class="alert alert-info">No assignments available</div>';
                        } else {
                            response.assignments.forEach(function (assignment) {
                                html += `
                                <div class="card mb-3">
                                    <div class="card-body">
                                        <h5 class="card-title">${assignment.subject}</h5>
                                        <div class="card-text">
                                            ${assignment.instruction ?
                                        `<p><strong>Instructions:</strong> ${assignment.instruction}</p>` :
                                        '<p class="text-muted">No instructions provided</p>'
                                    }
                                            
                                            <div class="row">
                                                <div class="col-md-6">
                                                    ${assignment.duration_set ?
                                        `<p><i class="fas fa-clock"></i> Duration: ${assignment.duration} minutes</p>` :
                                        '<p class="text-muted">No time limit</p>'
                                    }
                                                </div>
                                                <div class="col-md-6">
                                                    ${assignment.deadline_Set ?
                                        `<p><i class="fas fa-calendar"></i> Deadline: ${formatDateTime(assignment.deadline_date, assignment.deadline_time)}</p>` :
                                        '<p class="text-muted">No deadline set</p>'
                                    }
                                                </div>
                                            </div>
                                            
                                            <div class="mt-3">
                                                <button onclick="takeAssessment(${assignment.id})" class="btn btn-primary">
                                                    Take Assessment
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            `;
                            });
                        }
                        $('#assignment').html(html);
                    } else {
                        toastr.error('Error loading assignments');
                    }
                }
            });
        }

        function formatDateTime(date, time) {
            let dateObj = new Date(date + ' ' + time);
            return dateObj.toLocaleString();
        }

        function takeAssessment(id) {
            window.location.href = 'take_assessment?id=' + id;
        }
    </script>
</body>

</html>