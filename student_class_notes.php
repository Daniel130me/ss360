<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
$_SESSION['location'] = explode("/", $_SERVER['REQUEST_URI'])[3];
// $school_id = $_SESSION['school_id'];
// $_SESSION['term_id'];
// $_SESSION['session_id'];
// exit;
$school_settings = json_decode($_SESSION['skul_settings'], true);
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Lesson Note</title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <!-- Select2 -->
    <link href="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/css/select2.min.css" rel="stylesheet" />
    <!-- summernote -->
    <link rel="stylesheet" href="../plugins/summernote/summernote-bs4.min.css">
    <!-- <link rel="stylesheet" href="../plugins/select2/css/select2.min.css"> -->
    <!-- daterange picker -->
    <link rel="stylesheet" href="../plugins/daterangepicker/daterangepicker.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.9.3/dropzone.min.css">
    <style>
        #other_select .select2-selection.select2-selection--single {
            display: none;
        }
        #other_select .select2-container {
            display:none;
        }
        body {
            background: linear-gradient(135deg, #e0e7ff 0%, #f8fafc 100%);
            min-height: 100vh;
        }
        .user-panel img {
            border: 2px solid #6366f1;
            box-shadow: 0 2px 8px rgba(99,102,241,0.15);
        }
        .hero-section {
            background: linear-gradient(120deg, #000000 0%, #818cf8 100%);
            color: #fff;
            /* border-radius: 24px; */
            padding: 40px 30px 30px 30px;
            margin-bottom: 40px;
            box-shadow: 0 8px 32px rgba(99,102,241,0.12);
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
            background: rgba(255,255,255,0.08);
            border-radius: 50%;
            z-index: 0;
        }
         .fade-in {
            opacity: 0;
            animation: fadeIn 1.2s ease-in forwards;
        }
        @keyframes fadeIn {
            to { opacity: 1; }
        }
    </style>
</head>

<body class="hold-transition sidebar-mini">
    <div class="wrapper">


      

        <!-- Content Wrapper. Contains page content -->
        <div class="content-wrapper ml-0" style="background-color: #f4f7fa; padding-bottom: 100px;">


            <!-- Main content -->
            <div class="content fade-in p-0">
                <div class="hero-section d-flex flex-column align-items-center justify-content-center" style="position: relative;">
                    <div style="position: absolute; top: 20px; right: 30px; z-index:1;">
                        <a href="logout" title="Logout" style="color: #fff;">
                            <span class="material-symbols-outlined" style="font-size: 2.2rem; vertical-align: middle;">logout</span>
                        </a>
                    </div>
                    <img src="<?php echo isset($_SESSION['photo']) ? '../uploads/'.$_SESSION['photo'] : '../dist/img/avatar.png'; ?>" alt="Profile" style="width: 80px; height: 80px; object-fit: cover; border-radius: 50%; box-shadow: 0 2px 8px rgba(99,102,241,0.15); margin-bottom: 18px; border: 3px solid #fff;">
                    <h1>Notes</h1>
                    <p>Find all class notes here.</p>
                </div>
                <input type="hidden" id="select_session_field" class="session_value" value="<?= $school_settings['session']; ?>">
                <input type="hidden" id="lesson_note_page" value="lesson_note">


                <div class="container-fluid">
                    <div class="row">
                        <div class="col-sm-12">
                            <div class="py-2 px-15 bg-white" style="border-radius: 10px;">
                                <div>
                                    <div class="">
                                        <input type="hidden" value="<?=$_SESSION['class_id']?>" id="select_class_student">
                                        <!-- <div class="col-12 col-md-3" id="select_class_single">
                                            <div class="form-group align-left">
                                                <label for="select_class_field" class="mb-0">Select Class</label>
                                                <select class="form-control filter_Select select2" id="select_class_field" onchange="get_lesson_note(false)" style="width: 100%;">
                                                </select>
                                            </div>
                                        </div> -->
                                        <p class="mb-2">Select Subject</p>
                                        <div class="d-flex flex-wrap" style="gap:15px" id="select_class">
                                            <?php
                                            // Render subject buttons for the logged-in student.
                                            // Flow: students -> class.id -> class.subject_cat -> subject_cat.subject_ids -> subjects
                                            $student_id = intval($_SESSION['userid']);
                                            // $student_q = mysqli_query($conn, "SELECT class_id FROM students WHERE id='$student_id' AND school_id='" . intval($school_id) . "' LIMIT 1");
                                            $student_q = $_SESSION['class_id'];
                                            $subject_buttons_html = '';
                                            if ($student_q) {
                                                $class_id = intval($student_q);
                                                if ($class_id > 0) {
                                                    $class_q = mysqli_query($conn, "SELECT s.subject_ids FROM class c LEFT JOIN subject_cat s ON c.subject_cat=s.id WHERE c.id='" . $class_id . "' AND c.school_id='" . intval($school_id) . "'");
                                                    $subject_ids_raw = '';
                                                    if ($class_q && mysqli_num_rows($class_q) > 0) {
                                                        $crow = mysqli_fetch_assoc($class_q);
                                                        $subject_ids_raw = $crow['subject_ids'] ?? '';
                                                    }

                                                    $subject_ids = array_filter(array_map('trim', explode(',', $subject_ids_raw)));
                                                    $subject_ids = array_unique($subject_ids);
                                                    if (count($subject_ids) > 0) {
                                                        $ids = implode(',', array_map('intval', $subject_ids));
                                                        $sub_q = mysqli_query($conn, "SELECT id, subject FROM subjects WHERE id IN ($ids) ORDER BY subject ASC");
                                                        if ($sub_q && mysqli_num_rows($sub_q) > 0) {
                                                            while ($sub = mysqli_fetch_assoc($sub_q)) {
                                                                $sid = intval($sub['id']);
                                                                $sname = htmlspecialchars($sub['subject']);
                                                                $subject_buttons_html .= "<button type=\"button\" class=\"btn subject_btn select_btn\" data-id=\"$sid\" onclick=\"toggle_subject_btn(this, false)\">$sname</button>";
                                                            }
                                                        }
                                                    } else {
                                                        $subject_buttons_html = '<small class="text-muted">No subjects assigned to your class.</small>';
                                                    }
                                                } else {
                                                    $subject_buttons_html = '<small class="text-muted">You are not assigned to a class.</small>';
                                                }
                                            } else {
                                                $subject_buttons_html = '<small class="text-muted">Student record not found.</small>';
                                            }

                                            echo $subject_buttons_html;
                                            ?>

                                            <!-- <div class="form-group align-left">
                                                <label for="" class="mb-0">Select Subject</label>
     s
                                                </select>
                                            </div> -->
                                        </div>

                                        <div class="mt-4" id="week_btns_container">

                                        </div>

                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div id="note_container_topic"></div>
                    <div id="note_container_body"></div>

                </div>
                <!-- /.row_class -->
            </div><!-- /.container-fluid -->
        </div>
        <!-- /.content -->
    </div>
    <!-- /.content-wrapper -->



    </div>
    <!-- ./wrapper -->

    <!-- REQUIRED SCRIPTS -->

    <!-- jQuery -->


    <script src="../plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <!-- Select2 -->

    <script src="https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/js/select2.min.js"></script>

    <!-- <script src="../plugins/select2/js/select2.full.min.js"></script> -->
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <!-- <script>$('.select2').select2()</script> -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/dropzone/5.9.3/dropzone.min.js"></script>
    <!-- Summernote -->
    <script src="../plugins/summernote/summernote-bs4.min.js"></script>
    <script src="https://cdn.ckeditor.com/ckeditor5/39.0.1/classic/ckeditor.js"></script>
    <!-- <script src="https://cdn.jsdelivr.net/npm/@wiris/mathtype-ckeditor5@7.30.0/plugin.min.js"></script> -->

    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>

    <script src="../dist/js/skul.js?v=w3q125"></script>
    <!-- date-range-picker -->
    <script src="../plugins/moment/moment.min.js"></script>
    <script src="../plugins/daterangepicker/daterangepicker.js"></script>

    <script>
        // get_notes_week_view()
        get_note_week_create(false)

        function get_class_note_week() {
            console.log("Getting class notes");
            $("#week_btns_container").html(
                `
        <label for="" class="mb-0">Select Week</label>
            <div class="week_btns d-flex flex-wrap" style="gap:15px;">
                <button type="button" class="btn week_btn select_btn active" data-id="1" onclick="toggle_week_btn(this, false)">Week 1</button>
                <button type="button" class="btn week_btn select_btn" data-id="2" onclick="toggle_week_btn(this)">2</button>
                <button type="button" class="btn week_btn select_btn" data-id="3" onclick="toggle_week_btn(this)">3</button>
                <button type="button" class="btn week_btn select_btn" data-id="4" onclick="toggle_week_btn(this)">4</button>
                <button type="button" class="btn week_btn select_btn" data-id="5" onclick="toggle_week_btn(this)">5</button>
                <button type="button" class="btn week_btn select_btn" data-id="6" onclick="toggle_week_btn(this)">6</button>
                <button type="button" class="btn week_btn select_btn" data-id="7" onclick="toggle_week_btn(this)">7</button>
                <button type="button" class="btn week_btn select_btn" data-id="8" onclick="toggle_week_btn(this)">8</button>
                <button type="button" class="btn week_btn select_btn" data-id="9" onclick="toggle_week_btn(this)">9</button>
                <button type="button" class="btn week_btn select_btn" data-id="10" onclick="toggle_week_btn(this)">10</button>
                <button type="button" class="btn week_btn select_btn" data-id="11" onclick="toggle_week_btn(this)">11</button>
                <button type="button" class="btn week_btn select_btn" data-id="12" onclick="toggle_week_btn(this)">12</button>
                <button type="button" class="btn week_btn select_btn" data-id="13" onclick="toggle_week_btn(this)">13</button>
                <button type="button" class="btn week_btn select_btn" data-id="14" onclick="toggle_week_btn(this)">14</button>
                <button type="button" class="btn week_btn select_btn" data-id="15" onclick="toggle_week_btn(this)">15</button>
                <button type="button" class="btn week_btn select_btn" data-id="16" onclick="toggle_week_btn(this)">16</button>
                <button type="button" class="btn week_btn select_btn" data-id="17" onclick="toggle_week_btn(this)">17</button>
        </div>
        `
            )
            setTimeout(get_notes_week_view, 100)
            setTimeout(()=>{get_lesson_note(false)}, 100)
        }
    </script>



</body>

</html>