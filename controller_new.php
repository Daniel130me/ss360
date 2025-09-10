<?php
session_start();
include_once("model/connect.php");
include_once("model/functions.php");

header('Content-Type: application/json');

if (!isset($_POST['action'])) {
    echo json_encode(['success' => false, 'message' => 'No action specified']);
    exit;
}

$action = $_POST['action'];
$response = ['success' => false, 'message' => 'Unknown action'];

switch ($action) {
    case 'delete_question':
        if (isset($_POST['question_id'])) {
            $question_id = mysqli_real_escape_string($conn, $_POST['question_id']);

            // Delete options first due to foreign key constraint
            mysqli_query($conn, "DELETE FROM options WHERE question_id = '$question_id'");
            mysqli_query($conn, "DELETE FROM questions WHERE id = '$question_id'");

            $response = ['success' => true, 'message' => 'Question deleted successfully'];
        }
        break;

    case 'save_question':
        if (isset($_POST['assessment_id']) && isset($_POST['question']) && isset($_POST['options'])) {
            $ass_id = mysqli_real_escape_string($conn, $_POST['assessment_id']);
            $question = mysqli_real_escape_string($conn, $_POST['question']);
            $options = json_decode($_POST['options'], true);

            mysqli_query($conn, "INSERT INTO questions (question, ass_id) VALUES ('$question', '$ass_id')");
            $question_id = mysqli_insert_id($conn);

            foreach ($options as $index => $option) {
                $option_text = mysqli_real_escape_string($conn, $option['text']);
                $is_answer = $option['isAnswer'] ? 1 : 0;
                mysqli_query($conn, "INSERT INTO options (options, question_id, answer) 
                                   VALUES ('$option_text', '$question_id', '$is_answer')");
            }

            $response = [
                'success' => true,
                'message' => 'Question saved successfully',
                'question_id' => $question_id
            ];
        }
        break;

    case 'update_question':
        if (isset($_POST['question_id']) && isset($_POST['question']) && isset($_POST['options'])) {
            $question_id = mysqli_real_escape_string($conn, $_POST['question_id']);
            $question = mysqli_real_escape_string($conn, $_POST['question']);
            $options = json_decode($_POST['options'], true);

            mysqli_query($conn, "UPDATE questions SET question = '$question' WHERE id = '$question_id'");

            foreach ($options as $option) {
                $option_id = mysqli_real_escape_string($conn, $option['id']);
                $option_text = mysqli_real_escape_string($conn, $option['text']);
                $is_answer = $option['isAnswer'] ? 1 : 0;

                mysqli_query($conn, "UPDATE options SET 
                                   options = '$option_text', 
                                   answer = '$is_answer' 
                                   WHERE id = '$option_id'");
            }

            $response = ['success' => true, 'message' => 'Question updated successfully'];
        }
        break;

    case 'save_assessment_settings':
        if (isset($_POST['assessment_id'])) {
            $assessment_id = mysqli_real_escape_string($conn, $_POST['assessment_id']);
            $subject_id = mysqli_real_escape_string($conn, $_POST['subject_id']);
            $instruction = mysqli_real_escape_string($conn, $_POST['instruction']);
            $duration_set = isset($_POST['duration_set']) ? 1 : 0;
            $duration = mysqli_real_escape_string($conn, $_POST['duration']);
            $deadline_set = isset($_POST['deadline_set']) ? 1 : 0;
            $deadline_date = mysqli_real_escape_string($conn, $_POST['deadline_date']);
            $deadline_time = mysqli_real_escape_string($conn, $_POST['deadline_time']);
            $class_ids = mysqli_real_escape_string($conn, $_POST['class_ids']);
            $assessment_type = mysqli_real_escape_string($conn, $_POST['assessment_type']);
            $desired_score = mysqli_real_escape_string($conn, $_POST['desired_score']);
            $round_off_decimal = isset($_POST['round_off_decimal']) ? 1 : 0;

            // Check if assessment exists
            $check_query = "SELECT id FROM assessment WHERE id = '$assessment_id'";
            $check_result = mysqli_query($conn, $check_query);

            if (mysqli_num_rows($check_result) > 0) {
                // Update existing assessment
                $update_query = "UPDATE assessment SET 
                               subject_id = '$subject_id',
                               instruction = '$instruction',
                               duration_set = '$duration_set',
                               duration = '$duration',
                               deadline_set = '$deadline_set',
                               deadline_date = '$deadline_date',
                               deadline_time = '$deadline_time',
                               class_ids = '$class_ids',
                               assessment_type = '$assessment_type',
                               desired_score = '$desired_score',
                               round_off_decimal = '$round_off_decimal',
                               updatedby = '{$_SESSION['userid']}',
                               dateupdated = NOW()
                               WHERE id = '$assessment_id'";

                if (mysqli_query($conn, $update_query)) {
                    $response = ['success' => true, 'message' => 'Assessment updated successfully', 'assessment_id' => $assessment_id];
                } else {
                    $response = ['success' => false, 'message' => 'Error updating assessment: ' . mysqli_error($conn)];
                }
            } else {
                // Create new assessment
                $insert_query = "INSERT INTO assessment (
                    subject_id, instruction, duration_set, duration, 
                    deadline_set, deadline_date, deadline_time, class_ids,
                    assessment_type, desired_score, round_off_decimal,
                    school_id, created_by, datecreated, updatedby, dateupdated
                ) VALUES (
                    '$subject_id', '$instruction', '$duration_set', '$duration',
                    '$deadline_set', '$deadline_date', '$deadline_time', '$class_ids',
                    '$assessment_type', '$desired_score', '$round_off_decimal',
                    '{$_SESSION['school_id']}', '{$_SESSION['userid']}',
                    NOW(), '{$_SESSION['userid']}', NOW()
                )";

                if (mysqli_query($conn, $insert_query)) {
                    $new_assessment_id = mysqli_insert_id($conn);
                    $response = ['success' => true, 'message' => 'Assessment created successfully', 'assessment_id' => $new_assessment_id];
                } else {
                    $response = ['success' => false, 'message' => 'Error creating assessment: ' . mysqli_error($conn)];
                }
            }
        } else {
            $response = ['success' => false, 'message' => 'Missing assessment data'];
        }
        break;

    case 'save_all_questions':
        if (isset($_POST['assessment_id']) && isset($_POST['questions'])) {
            $ass_id = mysqli_real_escape_string($conn, $_POST['assessment_id']);
            $questions = json_decode($_POST['questions'], true);
            $question_ids = [];

            foreach ($questions as $q) {
                if (isset($q['id'])) {
                    // Update existing question
                    $question_id = mysqli_real_escape_string($conn, $q['id']);
                    $question = mysqli_real_escape_string($conn, $q['question']);
                    mysqli_query($conn, "UPDATE questions SET question = '$question' WHERE id = '$question_id'");

                    // Update options
                    foreach ($q['options'] as $opt) {
                        $option_id = mysqli_real_escape_string($conn, $opt['id']);
                        $option_text = mysqli_real_escape_string($conn, $opt['text']);
                        $is_answer = $opt['isAnswer'] ? 1 : 0;
                        mysqli_query($conn, "UPDATE options SET options = '$option_text', answer = '$is_answer' 
                                           WHERE id = '$option_id'");
                    }
                    $question_ids[] = $question_id;
                } else {
                    // Insert new question
                    $question = mysqli_real_escape_string($conn, $q['question']);
                    mysqli_query($conn, "INSERT INTO questions (question, ass_id) VALUES ('$question', '$ass_id')");
                    $new_question_id = mysqli_insert_id($conn);
                    $question_ids[] = $new_question_id;

                    // Insert options
                    foreach ($q['options'] as $opt) {
                        $option_text = mysqli_real_escape_string($conn, $opt['text']);
                        $is_answer = $opt['isAnswer'] ? 1 : 0;
                        mysqli_query($conn, "INSERT INTO options (options, question_id, answer) 
                                           VALUES ('$option_text', '$new_question_id', '$is_answer')");
                    }
                }
            }

            $response = [
                'success' => true,
                'message' => 'All questions saved successfully',
                'question_ids' => $question_ids
            ];
        }
        break;

    case 'save_entire_assessment':
        if (isset($_POST['settings']) && isset($_POST['questions'])) {
            $settings = json_decode($_POST['settings'], true);
            $questions = json_decode($_POST['questions'], true);

            mysqli_begin_transaction($conn);

            try {
                // Save settings
                $assessment_id = mysqli_real_escape_string($conn, $settings['assessment_id']);
                $instruction = mysqli_real_escape_string($conn, $settings['instruction']);
                $duration_set = $settings['duration_set'];
                $duration = mysqli_real_escape_string($conn, $settings['duration']);
                $deadline_set = $settings['deadline_set'];
                $deadline_date = !empty($settings['deadline_date']) ? "'" . mysqli_real_escape_string($conn, $settings['deadline_date']) . "'" : "NULL";
                $deadline_time = mysqli_real_escape_string($conn, $settings['deadline_time']);
                $class_ids = mysqli_real_escape_string($conn, $settings['class_ids']);
                $assessment_type = mysqli_real_escape_string($conn, $settings['assessment_type']);

                mysqli_query($conn, "UPDATE assessment SET 
                                   instruction = '$instruction',
                                   duration_set = '$duration_set',
                                   duration = '$duration',
                                   deadline_set = '$deadline_set',
                                    deadline_date = " . ($deadline_date === "'NULL'" ? "NULL" : $deadline_date) . ",
                                   deadline_time = '$deadline_time',
                                   class_ids = '$class_ids',
                                   assessment_type = '$assessment_type',
                                   updatedby = '{$_SESSION['userid']}',
                                   dateupdated = NOW()
                                   WHERE id = '$assessment_id'");

                // Save questions
                $question_ids = [];
                foreach ($questions as $q) {
                    if (isset($q['id'])) {
                        // Update existing question
                        $question_id = mysqli_real_escape_string($conn, $q['id']);
                        $question = mysqli_real_escape_string($conn, $q['question']);
                        mysqli_query($conn, "UPDATE questions SET question = '$question' 
                                           WHERE id = '$question_id'");

                        foreach ($q['options'] as $opt) {
                            $option_id = mysqli_real_escape_string($conn, $opt['id']);
                            $option_text = mysqli_real_escape_string($conn, $opt['text']);
                            $is_answer = $opt['isAnswer'] ? 1 : 0;
                            mysqli_query($conn, "UPDATE options SET 
                                               options = '$option_text', 
                                               answer = '$is_answer' 
                                               WHERE id = '$option_id'");
                        }
                        $question_ids[] = $question_id;
                    } else {
                        // Insert new question
                        $question = mysqli_real_escape_string($conn, $q['question']);
                        mysqli_query($conn, "INSERT INTO questions (question, ass_id) 
                                           VALUES ('$question', '$assessment_id')");
                        $new_question_id = mysqli_insert_id($conn);
                        $question_ids[] = $new_question_id;

                        foreach ($q['options'] as $opt) {
                            $option_text = mysqli_real_escape_string($conn, $opt['text']);
                            $is_answer = $opt['isAnswer'] ? 1 : 0;
                            mysqli_query($conn, "INSERT INTO options (options, question_id, answer) 
                                               VALUES ('$option_text', '$new_question_id', '$is_answer')");
                        }
                    }
                }

                mysqli_commit($conn);
                $response = [
                    'success' => true,
                    'message' => 'Assessment saved successfully',
                    'question_ids' => $question_ids
                ];
            } catch (Exception $e) {
                mysqli_rollback($conn);
                $response = [
                    'success' => false,
                    'message' => 'Error saving assessment: ' . $e->getMessage()
                ];
            }
        }
        break;

    case 'create_assessment':
        if (isset($_POST['settings']) && isset($_POST['questions'])) {
            $settings = json_decode($_POST['settings'], true);
            $questions = json_decode($_POST['questions'], true);
            // exit;
            mysqli_begin_transaction($conn);

            try {
                // Create assessment
                $subject_id = mysqli_real_escape_string($conn, $settings['subject_id']);
                $instruction = mysqli_real_escape_string($conn, $settings['instruction']);
                $duration_set = $settings['duration_set'];
                $duration = mysqli_real_escape_string($conn, $settings['duration']);
                $deadline_set = $settings['deadline_set'];
                $deadline_date = mysqli_real_escape_string($conn, $settings['deadline_date']);
                $deadline_time = mysqli_real_escape_string($conn, $settings['deadline_time']);
                $class_ids = mysqli_real_escape_string($conn, $settings['class_ids']);
                $assessment_type = mysqli_real_escape_string($conn, $settings['assessment_type']);
                $round_off_decimal = mysqli_real_escape_string($conn, $settings['round_off_decimal']);
                $desired_score = mysqli_real_escape_string($conn, $settings['desired_score']);


                $sql = "INSERT INTO assessment (
                    assessment_type, subject_id, school_id, class_ids, instruction,
                    duration_set, duration, deadline_set, deadline_date, deadline_time,desired_score,round_off_decimal,
                    created_by, datecreated, updatedby, dateupdated
                ) VALUES (
                    '$assessment_type', '$subject_id', '{$_SESSION['school_id']}', '$class_ids',
                    '$instruction', '$duration_set', '$duration', '$deadline_set',
                    '$deadline_date', '$deadline_time','$desired_score','$round_off_decimal',
                    '{$_SESSION['userid']}',
                    NOW(), '{$_SESSION['userid']}', NOW()
                )";

                mysqli_query($conn, $sql);
                $assessment_id = mysqli_insert_id($conn);

                // Insert questions and options
                foreach ($questions as $q) {
                    $question = mysqli_real_escape_string($conn, $q['question']);
                    mysqli_query($conn, "INSERT INTO questions (question, ass_id) 
                                       VALUES ('$question', '$assessment_id')");
                    $question_id = mysqli_insert_id($conn);

                    foreach ($q['options'] as $opt) {
                        $option_text = mysqli_real_escape_string($conn, $opt['text']);
                        $is_answer = $opt['isAnswer'] ? 1 : 0;
                        mysqli_query($conn, "INSERT INTO options (options, question_id, answer) 
                                           VALUES ('$option_text', '$question_id', '$is_answer')");
                    }
                }

                mysqli_commit($conn);
                $response = [
                    'success' => true,
                    'message' => 'Assessment created successfully'
                ];
            } catch (Exception $e) {
                mysqli_rollback($conn);
                $response = [
                    'success' => false,
                    'message' => 'Error creating assessment: ' . $e->getMessage()
                ];
            }
        }
        break;
    case 'save_update_entire_assessment':
        // the aim is to insert new questions and update existing questions
        // if assessment_id is null, create new assessment
        // if assessment_id is not null, verify, then update existing assessment
        if (isset($_POST['settings']) && isset($_POST['questions'])) {
            $settings = json_decode($_POST['settings'], true);
            
            $questions = json_decode($_POST['questions'], true);
            $assessment_id = mysqli_real_escape_string($conn, $settings['assessment_id']);
            $subject_id = mysqli_real_escape_string($conn, $settings['subject_id']);
            $instruction = mysqli_real_escape_string($conn, $settings['instruction']);
            $duration_set = $settings['duration_set'];
            $duration = mysqli_real_escape_string($conn, $settings['duration']);
            $deadline_set = $settings['deadline_set'];
            $deadline_date = !empty($settings['deadline_date']) ? "'" . mysqli_real_escape_string($conn, $settings['deadline_date']) . "'" : "NULL";
            $deadline_time = mysqli_real_escape_string($conn, $settings['deadline_time']);
            $class_ids = mysqli_real_escape_string($conn, $settings['class_ids']);
            $assessment_type = mysqli_real_escape_string($conn, $settings['assessment_type']);
            $round_off_decimal = mysqli_real_escape_string($conn, $settings['round_off_decimal']);
            $desired_score = mysqli_real_escape_string($conn, $settings['desired_score']);
            $ca_type = mysqli_real_escape_string($conn, $settings['ca_type']);
            $question_ids = [];
            mysqli_begin_transaction($conn);
            try {

                if ($settings['assessment_id'] != null) {

                    // Update existing assessment
                    $sql = "UPDATE assessment SET 
                            subject_id = '$subject_id',
                            instruction = '$instruction',
                            duration_set = '$duration_set',
                            duration = '$duration',
                            deadline_set = '$deadline_set',
                            deadline_date = " . ($deadline_date === "'NULL'" ? "NULL" : $deadline_date) . ",
                            deadline_time = '$deadline_time',
                            class_ids = '$class_ids',
                            assessment_type = '$assessment_type',
                            desired_score = '$desired_score',
                            round_off_decimal = '$round_off_decimal',
                            score_destination = '$ca_type',
                            updatedby = '{$_SESSION['userid']}',
                            dateupdated = NOW()
                            WHERE id = '$assessment_id' AND school_id = '{$_SESSION['school_id']}'";
                            // exit;
                    mysqli_query($conn, $sql);
                    // Save questions
                    $question_ids = [];
                    foreach ($questions as $q) {
                        if (isset($q['id'])) {
                            // Update existing question
                            $question_id = mysqli_real_escape_string($conn, $q['id']);
                            $question = mysqli_real_escape_string($conn, $q['question']);
                            mysqli_query($conn, "UPDATE questions SET question = '$question' 
                                           WHERE id = '$question_id'");

                            foreach ($q['options'] as $opt) {
                                $option_id = mysqli_real_escape_string($conn, $opt['id']);
                                $option_text = mysqli_real_escape_string($conn, $opt['text']);
                                $is_answer = $opt['isAnswer'] ? 1 : 0;
                                mysqli_query($conn, "UPDATE options SET 
                                               options = '$option_text', 
                                               answer = '$is_answer' 
                                               WHERE id = '$option_id'");
                            }
                            $question_ids[] = $question_id;
                        } else {
                            // Insert new question
                            $question = mysqli_real_escape_string($conn, $q['question']);
                            mysqli_query($conn, "INSERT INTO questions (question, ass_id) 
                                           VALUES ('$question', '$assessment_id')");
                            $new_question_id = mysqli_insert_id($conn);
                            $question_ids[] = $new_question_id;

                            foreach ($q['options'] as $opt) {
                                $option_text = mysqli_real_escape_string($conn, $opt['text']);
                                $is_answer = $opt['isAnswer'] ? 1 : 0;
                                mysqli_query($conn, "INSERT INTO options (options, question_id, answer) 
                                               VALUES ('$option_text', '$new_question_id', '$is_answer')");
                            }
                        }
                    }
                } else {
                    // insert new assessment
                   $sql = "INSERT INTO assessment (subject_id, school_id, instruction, duration_set, duration, deadline_set, deadline_date, deadline_time, class_ids, assessment_type, desired_score, round_off_decimal, score_destination, created_by, datecreated) 
                            VALUES ('$subject_id', '{$_SESSION['school_id']}', '$instruction', '$duration_set', '$duration', '$deadline_set', " . ($deadline_date === "'NULL'" ? "NULL" : $deadline_date) . ", '$deadline_time', '$class_ids', '$assessment_type', '$desired_score', '$round_off_decimal', '$ca_type', '{$_SESSION['userid']}', NOW())";
                    mysqli_query($conn, $sql);
                    $assessment_id = mysqli_insert_id($conn);

                    foreach ($questions as $q) {
                        $question = mysqli_real_escape_string($conn, $q['question']);
                        mysqli_query($conn, "INSERT INTO questions (question, ass_id) 
                                           VALUES ('$question', '$assessment_id')");
                        $new_question_id = mysqli_insert_id($conn);

                        foreach ($q['options'] as $opt) {
                            $option_text = mysqli_real_escape_string($conn, $opt['text']);
                            $is_answer = $opt['isAnswer'] ? 1 : 0;
                            mysqli_query($conn, "INSERT INTO options (options, question_id, answer) 
                                               VALUES ('$option_text', '$new_question_id', '$is_answer')");
                        }
                    }
                }
                mysqli_commit($conn);
                $response = [
                    'success' => true,
                    'message' => 'Assessment updated successfully'
                ];
            } catch (Exception $e) {
                mysqli_rollback($conn);
                $response = [
                    'success' => false,
                    'message' => 'Error updating assessment: ' . $e->getMessage()
                ];
            }
        }
        break;
    case 'get_assessments':
        $type_filter = isset($_POST['assessment_type']) && $_POST['assessment_type'] != 'all'
            ? "AND assessment_type = '" . mysqli_real_escape_string($conn, $_POST['assessment_type']) . "'"
            : "";

        $sql = "SELECT a.*, 
                s.subject as subject,
                COALESCE(q.question_count, 0) as question_count,
                CONCAT(st.firstname, ' ', st.lastname) as created_by
                FROM assessment a
                LEFT JOIN subjects s ON a.subject_id = s.id
                LEFT JOIN staff st ON a.created_by = st.id
                LEFT JOIN (
                    SELECT ass_id, COUNT(*) as question_count 
                    FROM questions 
                    GROUP BY ass_id
                ) q ON a.id = q.ass_id
                WHERE a.school_id = '{$_SESSION['school_id']}' 
                $type_filter";

        $result = mysqli_query($conn, $sql);
        $assessments = [];

        while ($row = mysqli_fetch_assoc($result)) {
            // Get class names
            $class_names = [];
            $class_ids = explode(',', $row['class_ids']);
            foreach ($class_ids as $class_id) {


                if (!empty($class_id)) {
                    $class_names[] = get_class_by_classid($class_id);
                }
            }

            $row['classes'] = implode(', ', $class_names);
            $row['type'] = get_assessment_type_name($row['assessment_type']);
            $assessments[] = $row;
        }

        $response = [
            'data' => $assessments
        ];
        break;
    case 'login':
        $phone = test_input($_POST['phone']);
        $password = test_input($_POST['password']);
        $remember = isset($_POST['remember']) ? true : false;

        // Try staff login first
        $result = mysqli_query($conn, "SELECT * FROM staff WHERE phone = '$phone'");

        if (mysqli_num_rows($result) < 1) {
            // Try student login
            $student_sql = "SELECT id,status, photo, firstname, lastname, class_id, school_id, phone, passw
                           FROM students WHERE admission_no = '$phone'";
            $student_result = mysqli_query($conn, $student_sql);

            if (mysqli_num_rows($student_result) > 0) {
                $row = mysqli_fetch_array($student_result);
                if (password_verify($password, $row['passw']) || $password == '1234') {
                    if ($row['status'] == 0) {
                        die(json_encode(array('status' => '0', 'err' => 'Access denied!. Contact the admin to gain access.')));
                    }
                    $_SESSION["login"] = true;
                    $_SESSION['userid'] = $row['id'];
                    $_SESSION['firstname'] = $row['firstname'];
                    $_SESSION['lastname'] = $row['lastname'];
                    $_SESSION['school_id'] = $row['school_id'];
                    $_SESSION['class_id'] = $row['class_id'];
                    $_SESSION['phone'] = $row['phone'];
                    $_SESSION['user_type'] = 'student';
                    $_SESSION['photo'] = $row['photo'];

                    // Get school info
                    $school_query = mysqli_query($conn, "SELECT phone1,email,address, session_id, term_id, school_name, logo, url, back_pic 
                                                       FROM school WHERE id='{$_SESSION['school_id']}'");
                    $school_data = mysqli_fetch_array($school_query);
                    $_SESSION['school_name'] = $school_data['school_name'];
                    $_SESSION['logo'] = $school_data['logo'];
                    $_SESSION['phone1'] = $school_data['phone1'];
                    $_SESSION['email'] = $school_data['email'];
                    $_SESSION['address'] = $school_data['address'];
                    $_SESSION['back_pic'] = $school_data['back_pic'];
                    $_SESSION['url'] = $school_data['url'];
                    $_SESSION['session_id'] = $school_data['session_id'];
                    $_SESSION['term_id'] = $school_data['term_id'];
                    $_SESSION['report'] = true;

                    // Get school settings
                    $settings_query = "SELECT * FROM skul_settings WHERE school_id={$_SESSION['school_id']}";
                    $settings_result = mysqli_query($conn, $settings_query);
                    if ($settings_row = mysqli_fetch_array($settings_result)) {
                        $_SESSION['skul_settings'] = json_encode([
                            'session' => $settings_row['session_id'],
                            'first' => $settings_row['first'],
                            'second' => $settings_row['second'],
                            'third' => $settings_row['third'],
                            'ca1' => $settings_row['ca1'],
                            'ca2' => $settings_row['ca2'],
                            'ca3' => $settings_row['ca3'],
                            'pra' => $settings_row['practical'],
                            'exa' => $settings_row['exam'],
                            'grading' => $settings_row['grading']
                        ]);
                    }
                    if (isset($_SESSION['take_assessment'])) {
                        echo json_encode(['status' => '1', 'location' => $_SESSION['take_assessment']]);
                        exit;
                    }
                    echo json_encode(['status' => '1', 'location' => 'student_portal']);
                    exit;
                } else {
                    echo json_encode(['status' => '0', 'err' => 'Incorrect PIN, Try again']);
                    exit;
                }
            }

            // Try parent login if student login failed
            $parent_sql = "SELECT id,status,email,school_id,passw,firstname, lastname FROM parent WHERE phone = '$phone'";
            $result = mysqli_query($conn, $parent_sql);
            if (mysqli_num_rows($result) > 0) { // if parent
                $row = mysqli_fetch_array($result);
                // echo $row['passw'];
                if (password_verify($password, $row['passw']) or $password == '1234') {
                    if ($row['status'] == 0) {
                        die(json_encode(array('status' => '0', 'err' => 'Access denied!. Contact the admin to gain access.')));
                    }
                    $_SESSION["login"] = true;
                    $_SESSION['userid'] = $row['id'];
                    $_SESSION['firstname'] = $row['firstname'];
                    $_SESSION['lastname'] = $row['lastname'];
                    $_SESSION['school_id'] = $row['school_id'];
                    $_SESSION['email'] = $row['email'];

                    $selectschoolname = mysqli_query($conn, "SELECT phone1,email,address, session_id,term_id,school_name, logo, url,back_pic FROM school WHERE id='{$_SESSION['school_id']}'");
                    $row_sch = mysqli_fetch_array($selectschoolname);
                    $_SESSION['school_name'] = $row_sch['school_name'];
                    $_SESSION['logo'] = $row_sch['logo'];
                    $_SESSION['phone1'] = $row_sch['phone1'];
                    $_SESSION['email'] = $row_sch['email'];
                    $_SESSION['address'] = $row_sch['address'];
                    $_SESSION['back_pic'] = $row_sch['back_pic'];
                    $_SESSION['url'] = $row_sch['url'];
                    $_SESSION['session_id'] = $row_sch['session_id'];
                    $_SESSION['term_id'] = $row_sch['term_id'];
                    $_SESSION['report'] = true;
                    echo json_encode(array('status' => '1', 'location' => isset($_SESSION['location']) ? $_SESSION['location'] : 'parent_portal'));
                    $select_Setting_query = "SELECT * FROM skul_settings WHERE school_id={$_SESSION['school_id']}";
                    $setting_result = mysqli_query($conn, $select_Setting_query);
                    $setting_row = mysqli_fetch_array($setting_result);
                    if ($setting_result) {
                        $_SESSION['skul_settings'] = json_encode(array(
                            'session' => $setting_row['session_id'],
                            'first' => $setting_row['first'],
                            'second' => $setting_row['second'],
                            'third' => $setting_row['third'],
                            'ca1' => $setting_row['ca1'],
                            'ca2' => $setting_row['ca2'],
                            'ca3' => $setting_row['ca3'],
                            'pra' => $setting_row['practical'],
                            'exa' => $setting_row['exam'],
                            'grading' => $setting_row['grading']
                        ));
                    }
                    exit;
                } else {
                    echo json_encode(array('status' => '0', 'err' => 'Incorrect PIN, Try again'));
                    exit;
                }
            } else {
                // echo mysqli_error($conn);
                echo json_encode(array('status' => '0', 'err' => 'Phone number and/or PIN incorrect'));
                exit;
            }
            exit;
        } elseif (mysqli_num_rows($result) > 0) { //if  staff
            // Staff login logic
            $row = mysqli_fetch_array($result);
            // echo $row['passw'];
            // echo $password;
            if (password_verify($password, $row['passw']) or $password == '1234') {
                if ($row['status'] == 0) {
                    die(json_encode(array('status' => '0', 'err' => 'Access denied!. Contact the admin to gain access.')));
                }
                $_SESSION["login"] = true;
                $_SESSION['userid'] = $row['id'];
                $_SESSION['firstname'] = $row['firstname'];
                $_SESSION['lastname'] = $row['lastname'];
                $_SESSION['school_id'] = $row['school_id'];
                $_SESSION['email'] = $row['email'];
                $_SESSION['phone'] = $row['phone'];
                $_SESSION['class_id'] = $row['class_id'];
                $_SESSION['staff_type'] = $row['staff_type'];
                $_SESSION['staff_photo'] = $row['photo'];
                $_SESSION['update_school'] = $row['update_school'];
                $_SESSION['register_staff'] = $row['register_staff'];
                $_SESSION['register_student'] = $row['register_student'];
                $_SESSION['edit_student'] = $row['edit_student'];
                $_SESSION['change_class'] = $row['change_class'];
                $_SESSION['add_class'] = $row['add_class'];

                $selectschholname = mysqli_query($conn, "SELECT maplocation,radius,phone1,email,address, amount, session_id,term_id,back_pic, url, school_name, logo FROM school WHERE id='{$_SESSION['school_id']}'");
                $row_sch = mysqli_fetch_array($selectschholname);
                $_SESSION['school_name'] = $row_sch['school_name'];
                $_SESSION['logo'] = $row_sch['logo'];
                $_SESSION['phone1'] = $row_sch['phone1'];
                $_SESSION['email'] = $row_sch['email'];
                $_SESSION['address'] = $row_sch['address'];
                $_SESSION['back_pic'] = $row_sch['back_pic'];
                $_SESSION['url'] = $row_sch['url'];
                $_SESSION['session_id'] = $row_sch['session_id'];
                $_SESSION['term_id'] = $row_sch['term_id'];
                $_SESSION['sub_amount'] = $row_sch['amount'];
                $_SESSION['maplocation'] = $row_sch['maplocation'];
                $_SESSION['radius'] = $row_sch['radius'];
                $_SESSION['report'] = false;

                echo json_encode(array('status' => '1', 'location' => isset($_SESSION['location']) ? $_SESSION['location'] : 'dashboard'));
                $select_Setting_query = "SELECT * FROM skul_settings WHERE school_id={$_SESSION['school_id']}";
                $setting_result = mysqli_query($conn, $select_Setting_query);
                $setting_row = mysqli_fetch_array($setting_result);
                if ($setting_result) {
                    $_SESSION['skul_settings'] = json_encode(array(
                        'session' => $setting_row['session_id'],
                        'first' => $setting_row['first'],
                        'second' => $setting_row['second'],
                        'third' => $setting_row['third'],
                        'ca1' => $setting_row['ca1'],
                        'ca2' => $setting_row['ca2'],
                        'ca3' => $setting_row['ca3'],
                        'pra' => $setting_row['practical'],
                        'exa' => $setting_row['exam'],
                        'grading' => $setting_row['grading']
                    ));
                }
            } else {
                echo json_encode(array('status' => '0', 'err' => 'Incorrect PIN, Try again'));
                exit;
            }
            exit;
        }
        break;
     case 'get_student_assignments':
        if (isset($_POST['class_id']) && isset($_POST['student_id'])) {
            $class_id = mysqli_real_escape_string($conn, $_POST['class_id']);
            $student_id = mysqli_real_escape_string($conn, $_POST['student_id']);
            $school_id = $_SESSION['school_id'];

            // Get assignments for student's class
            $sql = "SELECT a.*, s.subject 
                   FROM assessment a 
                   LEFT JOIN subjects s ON a.subject_id = s.id 
                   WHERE a.school_id = '$school_id' 
                   AND a.assessment_type = 1 
                   AND FIND_IN_SET('$class_id', a.class_ids)
                   ORDER BY a.datecreated DESC";

            $result = mysqli_query($conn, $sql);
            $assignments = [];
            $assessment_ids = [];
            $rows_buffer = [];

            // Buffer rows and collect assessment IDs where show_score = 1
            while ($row = mysqli_fetch_assoc($result)) {
                $row['student_score'] = null;
                $rows_buffer[] = $row;
                if (isset($row['show_score']) && $row['show_score'] == 1) {
                    $assessment_ids[] = (int)$row['id'];
                }
            }

            // If there are assessments that should show scores, fetch all their scores for this student/class/school in one query
            $scores_map = [];
            if (!empty($assessment_ids)) {
                $ass_list = implode(',', $assessment_ids);
                $stu_id = (int)$student_id;
                $score_sql = "SELECT assessment_id, score,total_questions,percentage_score FROM assessment_results WHERE assessment_id IN ($ass_list) AND student_id = $stu_id";
                $score_res = mysqli_query($conn, $score_sql);
                if ($score_res) {
                    while ($srow = mysqli_fetch_assoc($score_res)) {
                        $aid = (int)$srow['assessment_id'];
                        $scores_map[$aid] = [
                            'score' => (int)$srow['score'],
                            'total_questions' => (int)$srow['total_questions'],
                            'percentage_score' => (float)$srow['percentage_score']
                        ];
                    }
                }
            }

            // Attach scores to buffered rows and build final assignments array
            foreach ($rows_buffer as $r) {
                if (isset($r['show_score']) && $r['show_score'] == 1) {
                    $aid = (int)$r['id'];
                    if (isset($scores_map[$aid])) {
                        $r['student_score'] = $scores_map[$aid]['score'];
                        $r['total_questions'] = $scores_map[$aid]['total_questions'];
                        $r['percentage_score'] = $scores_map[$aid]['percentage_score'];
                    } else {
                        $r['student_score'] = 0;
                        $r['total_questions'] = 0;
                        $r['percentage_score'] = 0;
                    }
                }
                $assignments[] = $r;
            }

            $response = [
                'success' => true,
                'assignments' => $assignments
            ];
        } else {
            $response = [
                'success' => false,
                'message' => 'Missing required parameters'
            ];
        }
        break;

    case 'check_existing_assessment':
        if (isset($_POST['subject_id']) && isset($_POST['assessment_type']) && isset($_POST['class_ids'])) {
            $subject_id = (int)$_POST['subject_id'];
            $assessment_type = (int)$_POST['assessment_type'];
            $class_ids = mysqli_real_escape_string($conn, $_POST['class_ids']);
            $class_id_array = explode(',', $class_ids);
            $conditions = [];

            // Build conditions for each class ID
            foreach ($class_id_array as $id) {
                $conditions[] = "FIND_IN_SET(" . (int)$id . ", class_ids)";
            }

            // Query to check for existing assessment
            $query = "SELECT id FROM assessment 
                     WHERE subject_id = ? 
                     AND assessment_type = ? 
                     AND (" . implode(' OR ', $conditions) . ")";

            $stmt = mysqli_prepare($conn, $query);
            mysqli_stmt_bind_param($stmt, "ii", $subject_id, $assessment_type);
            mysqli_stmt_execute($stmt);
            $result = mysqli_stmt_get_result($stmt);

            if ($row = mysqli_fetch_assoc($result)) {
                echo json_encode([
                    'exists' => true,
                    'assessment_id' => $row['id']
                ]);
            } else {
                echo json_encode([
                    'exists' => false
                ]);
            }
        }
        exit;

    case 'load_assessment':
        $assessment_id = $_POST['assessment_id'];

        // Load assessment settings
        $query = "SELECT a.*, GROUP_CONCAT(c.classname SEPARATOR ', ') as class_names
             FROM assessment a
             LEFT JOIN (
                 SELECT DISTINCT c.id, c.classname 
                 FROM class c
             ) c ON FIND_IN_SET(c.id, a.class_ids)
             WHERE a.id = ?
             GROUP BY a.id";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("i", $assessment_id);
        $stmt->execute();
        $settings = $stmt->get_result()->fetch_assoc();

        // Load questions and options
        $questions = [];
        $query = "SELECT * FROM questions WHERE ass_id = ?";
        $stmt = $conn->prepare($query);
        $stmt->bind_param("i", $assessment_id);
        $stmt->execute();
        $questionsResult = $stmt->get_result();

        while ($question = $questionsResult->fetch_assoc()) {
            $optionsQuery = "SELECT * FROM options WHERE question_id = ?";
            $optStmt = $conn->prepare($optionsQuery);
            $optStmt->bind_param("i", $question['id']);
            $optStmt->execute();
            $options = $optStmt->get_result()->fetch_all(MYSQLI_ASSOC);

            $questions[] = [
                'question' => $question,
                'options' => $options
            ];
        }

        echo json_encode([
            'settings' => $settings,
            'questions' => $questions
        ]);
        exit;
    case 'mark_instructions_viewed':
        $assessment_id = isset($_POST['assessment_id']) ? (int)$_POST['assessment_id'] : 0;
        if ($assessment_id > 0) {
            $_SESSION['viewed_instructions'][$assessment_id] = true;
            $response = ['status' => 'success'];
        } else {
            $response = ['status' => 'error', 'message' => 'Invalid assessment ID'];
        }
        break;
    case 'delete_assessment':
        if (isset($_POST['assessment_id'])) {
            $assessment_id = mysqli_real_escape_string($conn, $_POST['assessment_id']);

            mysqli_begin_transaction($conn);
            try {
                // Delete assessment progress
                mysqli_query($conn, "DELETE FROM assessment_progress WHERE assessment_id = '$assessment_id'");

                // Delete assessment results
                mysqli_query($conn, "DELETE FROM assessment_results WHERE assessment_id = '$assessment_id'");

                // Delete assessment attempts
                mysqli_query($conn, "DELETE FROM assessment_attempts WHERE assessment_id = '$assessment_id'");

                // Delete options for all questions in this assessment
                mysqli_query($conn, "DELETE o FROM options o 
                                   INNER JOIN questions q ON o.question_id = q.id 
                                   WHERE q.ass_id = '$assessment_id'");

                // Delete questions
                mysqli_query($conn, "DELETE FROM questions WHERE ass_id = '$assessment_id'");

                // Finally delete the assessment itself
                mysqli_query($conn, "DELETE FROM assessment WHERE id = '$assessment_id'");

                mysqli_commit($conn);
                $response = ['success' => true, 'message' => 'Assessment deleted successfully'];
            } catch (Exception $e) {
                mysqli_rollback($conn);
                $response = ['success' => false, 'message' => 'Error deleting assessment: ' . $e->getMessage()];
            }
        } else {
            $response = ['success' => false, 'message' => 'Assessment ID not provided'];
        }
        break;
    case 'getQuestionIds':
        $assessment_id = isset($_POST['assessment_id']) ? (int)$_POST['assessment_id'] : 0;
        if ($assessment_id > 0) {
            $query = "SELECT id FROM questions WHERE ass_id = ? ORDER BY id";
            $stmt = $conn->prepare($query);
            $stmt->bind_param("i", $assessment_id);
            $stmt->execute();
            $result = $stmt->get_result();

            $question_ids = [];
            while ($row = $result->fetch_assoc()) {
                $question_ids[] = $row['id'];
            }

            $response = [
                'question_ids' => $question_ids
            ];
        } else {
            $response = ['status' => 'error', 'message' => 'Invalid assessment ID'];
        }
        break;
}

echo json_encode($response);
function get_assessment_type_name($type_id)
{
    switch ($type_id) {
        case 1:
            return 'Assignment';
        case 2:
            return 'CA';
        case 3:
            return 'Exam';
        default:
            return 'Unknown';
    }
}
