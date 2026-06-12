<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}

include_once("model/connect.php");
include_once("model/functions.php");

$school_settings = json_decode($_SESSION['skul_settings'] ?? '{}', true);
$_SESSION['location'] = explode("/", $_SERVER['REQUEST_URI'])[3] ?? 'question_bank';

function qb_page_ensure_platform_admin_schema($conn)
{
    mysqli_query($conn, "CREATE TABLE IF NOT EXISTS ss360_platform_admins (
        id INT AUTO_INCREMENT PRIMARY KEY,
        staff_id INT NOT NULL,
        school_id INT NOT NULL,
        status TINYINT(1) NOT NULL DEFAULT 1,
        datecreated DATETIME NULL,
        UNIQUE KEY uniq_ss360_platform_admin (staff_id, school_id),
        KEY idx_ss360_platform_admin_status (status)
    )");
}

function qb_page_is_platform_admin($conn)
{
    if ((int)($_SESSION['school_id'] ?? -1) === 0 || !empty($_SESSION['is_ss360_admin']) || !empty($_SESSION['platform_admin']) || !empty($_SESSION['super_admin'])) {
        return true;
    }

    qb_page_ensure_platform_admin_schema($conn);
    $staff_id = (int)($_SESSION['userid'] ?? 0);
    $school_id = (int)($_SESSION['school_id'] ?? 0);
    if ($staff_id <= 0 || $school_id <= 0) {
        return false;
    }

    $stmt = $conn->prepare("SELECT id FROM ss360_platform_admins WHERE staff_id = ? AND school_id = ? AND status = 1 LIMIT 1");
    $stmt->bind_param("ii", $staff_id, $school_id);
    $stmt->execute();
    return $stmt->get_result()->num_rows > 0;
}

$is_ss360_admin = ((int)($_SESSION['school_id'] ?? -1) === 0)
    || !empty($_SESSION['is_ss360_admin'])
    || !empty($_SESSION['platform_admin'])
    || !empty($_SESSION['super_admin'])
    || qb_page_is_platform_admin($conn);
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Question Bank</title>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.9.1/summernote-bs4.min.css" integrity="sha512-rDHV59PgRefDUbMm2lSjvf0ZhXZy3wgROFyao0JxZPGho3oOuWejq/ELx0FOZJpgaE5QovVtRN65Y3rrb7JhdQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/mathquill/0.10.1/mathquill.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <style>
        .question-bank-toolbar {
            gap: 10px;
        }

        .question-bank-card {
            border-radius: 8px;
            border: 1px solid #e7ebf0;
        }

        .question-preview {
            max-height: 140px;
            overflow-y: auto;
        }

        .option-row {
            border: 1px solid #e9edf3;
            border-radius: 8px;
            padding: 10px;
            background: #fff;
        }

        .option-row + .option-row {
            margin-top: 8px;
        }

        .structured-question {
            border: 1px solid #dfe7f3;
            border-radius: 8px;
            padding: 14px;
            background: #fff;
        }
    </style>
</head>

<body class="hold-transition sidebar-mini">
    <div class="wrapper">
        <nav class="main-header navbar border-bottom-0 navbar-expand justify-content-between bg1">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="muted-text fas fa-bars"></i></a>
                </li>
            </ul>

            <ul class="navbar-nav align-items-center">
                <li class="nav-item dropdown">
                    <a data-toggle="dropdown" href="#">
                        <div class="user-panel d-flex align-items-center">
                            <span class="material-symbols-outlined">arrow_drop_down</span>
                            <div class="image pl-0">
                                <img src="../uploads/<?= htmlspecialchars($_SESSION['staff_photo'] ?? 'avatar.png') ?>" class="img-circle elevation-2" alt="User Image">
                            </div>
                            <div class="info d-none d-sm-inline-block">
                                <p style="font-size: 14px;" class="mb-0 d-block">
                                    <?= htmlspecialchars(($_SESSION['firstname'] ?? '') . ' ' . ($_SESSION['lastname'] ?? '')) ?>
                                </p>
                                <p style="font-size: 12px;" class="d-block mb-0 accent">
                                    <?= htmlspecialchars(get_staff_type_in_name($_SESSION['staff_type'] ?? 0)) ?>
                                </p>
                            </div>
                        </div>
                    </a>
                    <div class="dropdown-menu dropdown-menu-sm dropdown-menu-right p-2" style="border-radius: 10px;">
                        <a href="profile" class="dropdown-item text-muted d-flex">
                            <i class="material-symbols-outlined mr-2 d-inline">person</i> Profile
                        </a>
                        <a href="change_password" class="dropdown-item text-muted d-flex">
                            <span class="material-symbols-outlined mr-2">lock</span> Change PIN
                        </a>
                        <a href="logout" class="dropdown-item text-muted d-flex">
                            <span class="material-symbols-outlined mr-2">logout</span> Logout
                        </a>
                    </div>
                </li>
            </ul>
        </nav>

        <aside class="main-sidebar sidebar-light-primary elevation-4">
            <a href="dashboard" class="brand-link">
                <img src="../uploads/<?= htmlspecialchars($_SESSION['logo'] ?? 'logo-placeholder-2.png') ?>" alt="<?= htmlspecialchars($_SESSION['school_name'] ?? 'School') ?>" class="brand-image" style="opacity: .8">
                <span class="brand-text font-weight-light" style="visibility: hidden;">SS360</span>
            </a>

            <div class="py-2 px-15">
                <p class="font-weight-bold text-tertiary"><?= htmlspecialchars($_SESSION['school_name'] ?? '') ?></p>
            </div>

            <div class="sidebar">
                <nav class="mt-2">
                    <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
                        <li class="nav-item">
                            <a href="dashboard" class="nav-link">
                                <p class="d-flex"><i class="material-symbols-outlined pr-2">dashboard</i> Dashboard</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="assessment" class="nav-link">
                                <p class="d-flex"><i class="material-symbols-outlined pr-2">quiz</i> Assessments</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="question_bank" class="nav-link active">
                                <p class="d-flex"><i class="material-symbols-outlined pr-2">library_books</i> Question Bank</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="subjects" class="nav-link">
                                <p class="d-flex"><i class="material-symbols-outlined pr-2">responsive_layout</i> Subjects</p>
                            </a>
                        </li>
                        <li class="nav-item">
                            <a href="class" class="nav-link">
                                <p class="d-flex"><i class="material-symbols-outlined pr-2">app_registration</i> Classes</p>
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>
        </aside>

        <div class="content-wrapper bg-light">
            <section class="content-header">
                <div class="container-fluid">
                    <div class="row mb-2">
                        <div class="col-sm-6">
                            <h2 class="mx-0 mt-0 mb-sm-1 mb-2" style="font-size: 23px;">Question Bank</h2>
                            <p class="text-muted mb-0">Create, review, update, and reuse structured questions.</p>
                        </div>
                        <div class="col-sm-6">
                            <ol class="breadcrumb float-sm-right">
                                <li class="breadcrumb-item"><a href="dashboard">Home</a></li>
                                <li class="breadcrumb-item active">Question Bank</li>
                            </ol>
                        </div>
                    </div>
                </div>
            </section>

            <section class="content">
                <div class="container-fluid">
                    <div class="row">
                        <div class="col-lg-5">
                            <div class="bg-white p-3 mb-3 question-bank-card">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="mb-0">Add or Update Question</h5>
                                    <button type="button" class="btn btn-sm btn-outline-secondary" id="reset-form-btn">
                                        <i class="fas fa-plus mr-1"></i> New
                                    </button>
                                </div>

                                <form id="question-form">
                                    <input type="hidden" id="question_id" value="">

                                    <div class="form-group">
                                        <label>Question</label>
                                        <textarea id="question_text" class="question-textarea form-control" rows="4" placeholder="Enter the question" required></textarea>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Subject</label>
                                                <select id="subject_id" class="form-control" required></select>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Difficulty</label>
                                                <select id="difficulty" class="form-control">
                                                    <option>Easy</option>
                                                    <option selected>Medium</option>
                                                    <option>Hard</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Recommended Class/Level</label>
                                                <input type="text" id="recommended_class" class="form-control" placeholder="Optional, e.g. JSS1">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group">
                                                <label>Source</label>
                                                <select id="source_type" class="form-control">
                                                    <option value="topic">Topic</option>
                                                    <option value="exam_body">Exam Body</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group" id="topic-field">
                                        <label>Topic</label>
                                        <select id="topic_id" class="form-control"></select>
                                    </div>

                                    <div class="form-group d-none" id="exam-body-field">
                                        <label>Exam Body</label>
                                        <select id="exam_body_id" class="form-control"></select>
                                    </div>

                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Term Tag</label>
                                                <input type="text" id="term_tag" class="form-control" placeholder="Optional">
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Category</label>
                                                <input type="text" id="question_category" class="form-control" placeholder="Optional, e.g. Word Problem">
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label>Review Status</label>
                                                <select id="review_status" class="form-control">
                                                    <option value="draft" selected>Draft</option>
                                                    <option value="approved">Approved</option>
                                                    <option value="rejected">Rejected</option>
                                                </select>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="form-group">
                                        <label>Explanation</label>
                                        <textarea id="explanation" class="form-control question-textarea" rows="3" placeholder="Optional explanation for the correct answer"></textarea>
                                    </div>

                                    <div class="form-group">
                                        <div class="d-flex justify-content-between align-items-center mb-2">
                                            <label class="mb-0">Options</label>
                                            <button type="button" class="btn btn-sm btn-outline-primary" id="add-option-btn">
                                                <i class="fas fa-plus mr-1"></i> Option
                                            </button>
                                        </div>
                                        <div id="options-container"></div>
                                        <small class="text-muted">Select one radio button as the correct answer.</small>
                                    </div>

                                    <button type="submit" class="btn btn-primary" id="save-question-btn">
                                        <i class="fas fa-save mr-1"></i> Save Question
                                    </button>
                                </form>
                            </div>

                            <div class="bg-white p-3 mb-3 question-bank-card">
                                <h5 class="mb-3">AI Restructure Pasted Questions</h5>
                                <div class="form-group">
                                    <label>Paste Questions</label>
                                    <textarea id="raw_questions" class="form-control rich-paste-editor" rows="7" placeholder="Paste copied questions here. Include options and answers when available."></textarea>
                                </div>
                                <button type="button" class="btn btn-outline-primary" id="restructure-btn">
                                    <i class="fas fa-magic mr-1"></i> Restructure with AI
                                </button>
                                <div id="structured-questions" class="mt-3"></div>
                            </div>

                            <div class="bg-white p-3 mb-3 question-bank-card">
                                <h5 class="mb-3">AI Generate Draft Bank Questions</h5>
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Number</label>
                                            <input type="number" id="ai_bank_count" class="form-control" min="1" max="25" value="5">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group">
                                            <label>Difficulty</label>
                                            <select id="ai_bank_difficulty" class="form-control">
                                                <option value="Mixed">Mixed</option>
                                                <option value="Easy">Easy</option>
                                                <option value="Medium" selected>Medium</option>
                                                <option value="Hard">Hard</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group">
                                    <label>Curriculum / Context</label>
                                    <textarea id="ai_curriculum_context" class="form-control" rows="3" placeholder="Optional, e.g. Nigerian Basic Education Curriculum"></textarea>
                                </div>
                                <button type="button" class="btn btn-outline-success" id="generate-bank-btn">
                                    <i class="fas fa-magic mr-1"></i> Generate Drafts
                                </button>
                                <small class="d-block text-muted mt-2">Generated questions are saved as drafts for review before teachers can import them.</small>
                            </div>
                        </div>

                        <div class="col-lg-7">
                            <div class="bg-white p-3 question-bank-card">
                                <div class="d-flex flex-wrap align-items-end question-bank-toolbar mb-3">
                                    <div class="form-group mb-0 flex-grow-1">
                                        <label>Search</label>
                                        <input type="search" id="search_filter" class="form-control" placeholder="Search question text">
                                    </div>
                                    <div class="form-group mb-0">
                                        <label>Subject</label>
                                        <select id="subject_filter" class="form-control"></select>
                                    </div>
                                    <div class="form-group mb-0">
                                        <label>Topic</label>
                                        <select id="topic_filter" class="form-control"></select>
                                    </div>
                                    <div class="form-group mb-0">
                                        <label>Source</label>
                                        <select id="source_filter" class="form-control">
                                            <option value="">All</option>
                                            <option value="topic">Topic</option>
                                            <option value="exam_body">Exam Body</option>
                                        </select>
                                    </div>
                                    <div class="form-group mb-0">
                                        <label>Difficulty</label>
                                        <select id="difficulty_filter" class="form-control">
                                            <option value="">All</option>
                                            <option value="Easy">Easy</option>
                                            <option value="Medium">Medium</option>
                                            <option value="Hard">Hard</option>
                                        </select>
                                    </div>
                                    <div class="form-group mb-0">
                                        <label>Status</label>
                                        <select id="review_status_filter" class="form-control">
                                            <option value="">All</option>
                                            <option value="draft">Draft</option>
                                            <option value="approved">Approved</option>
                                            <option value="rejected">Rejected</option>
                                        </select>
                                    </div>
                                    <div class="form-group mb-0">
                                        <label>Class Tag</label>
                                        <input type="search" id="recommended_class_filter" class="form-control" placeholder="Optional">
                                    </div>
                                    <div class="form-group mb-0">
                                        <label>Term</label>
                                        <input type="search" id="term_tag_filter" class="form-control" placeholder="Optional">
                                    </div>
                                    <div class="form-group mb-0">
                                        <label>Category</label>
                                        <input type="search" id="category_filter" class="form-control" placeholder="Optional">
                                    </div>
                                </div>

                                <div id="question-list"></div>

                                <div class="d-flex justify-content-between align-items-center mt-3">
                                    <button type="button" class="btn btn-outline-secondary btn-sm" id="prev-page-btn">
                                        <i class="fas fa-chevron-left"></i>
                                    </button>
                                    <span id="page-info" class="small text-muted">Page 1 / 1</span>
                                    <button type="button" class="btn btn-outline-secondary btn-sm" id="next-page-btn">
                                        <i class="fas fa-chevron-right"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <script src="../plugins/jquery/jquery.min.js"></script>
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.9.1/summernote-bs4.min.js" integrity="sha512-/DlF8zrT3XyUWEK7bmU1v7Q0kMXctQfqNwyzCNBB/mdUFxz87bq3X4TqadyuQBJW39g29t1tLNbHYLpXLs1zVA==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/mathquill/0.10.1/mathquill.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script src="../dist/js/adminlte.js"></script>
    <script src="../dist/js/assessment_image_buffer.js"></script>
    <script src="../dist/js/examination.js?v=90poklk"></script>
    <script>
        const controllerUrl = '../question_bank_controller.php';
        const isSS360Admin = <?= $is_ss360_admin ? 'true' : 'false' ?>;
        let questionBankMeta = { subjects: [], topics: [], exam_bodies: [], classes: [] };
        let currentPage = 1;
        let totalPages = 1;

        function escapeHtml(value) {
            return String(value || '').replace(/[&<>"']/g, function (char) {
                return ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' })[char];
            });
        }

        function plainText(value) {
            return $('<div>').html(value || '').text();
        }

        function getEditorCode($el) {
            return $el.data('summernote-initialized') ? $el.summernote('code') : $el.val();
        }

        function setEditorCode($el, value) {
            if ($el.data('summernote-initialized')) {
                $el.summernote('code', value || '');
            } else {
                $el.val(value || '');
            }
        }

        function initializeRichPasteEditor() {
            const $editor = $('#raw_questions');
            if ($editor.data('summernote-initialized')) {
                return;
            }

            $editor.summernote({
                height: 220,
                toolbar: [
                    ['style', ['style']],
                    ['font', ['bold', 'underline', 'italic', 'superscript', 'subscript']],
                    ['para', ['ul', 'ol', 'paragraph']],
                    ['insert', ['link', 'table']],
                    ['view', ['fullscreen', 'codeview']]
                ]
            });
            $editor.data('summernote-initialized', true);
        }

        function initializeQuestionBankEditors() {
            if (typeof initializeSummernote === 'function') {
                initializeSummernote();
            }
            initializeRichPasteEditor();
        }

        function applyAdminGate() {
            if (isSS360Admin) {
                return;
            }

            $('#question-form :input, #reset-form-btn, #add-option-btn, #save-question-btn, #restructure-btn, #generate-bank-btn').prop('disabled', true);
            $('#structured-questions').empty();
            $('#question-form').prepend('<div class="alert alert-info">Only SchoolSuite360 admins can create or manage global bank questions.</div>');
        }

        function fillSelect($select, rows, valueKey, labelKey, placeholder) {
            let html = `<option value="">${placeholder}</option>`;
            rows.forEach(row => {
                html += `<option value="${row[valueKey]}">${escapeHtml(row[labelKey])}</option>`;
            });
            $select.html(html);
        }

        function refreshTopicOptions() {
            const subjectId = $('#subject_id').val();
            const topics = questionBankMeta.topics.filter(topic => {
                const subjectMatches = !subjectId || String(topic.subject_id) === String(subjectId);
                return subjectMatches;
            });
            fillSelect($('#topic_id'), topics, 'id', 'topic_name', 'Select Topic');
        }

        function refreshTopicFilterOptions() {
            const subjectId = $('#subject_filter').val();
            const topics = questionBankMeta.topics.filter(topic => {
                return !subjectId || String(topic.subject_id) === String(subjectId);
            });
            fillSelect($('#topic_filter'), topics, 'id', 'topic_name', 'All Topics');
        }

        function addOptionRow(text = '', isCorrect = false) {
            const optionIndex = $('#options-container .option-row').length + 1;
            const optionId = `option_correct_${Date.now()}_${optionIndex}`;
            $('#options-container').append(`
                <div class="option-row">
                    <div class="d-flex align-items-start">
                        <div class="icheck-primary mr-2 mt-2">
                            <input type="radio" name="correct_option" id="${optionId}" ${isCorrect ? 'checked' : ''}>
                            <label for="${optionId}"></label>
                        </div>
                        <textarea class="form-control option-text option-textarea" rows="2" placeholder="Option text">${escapeHtml(text)}</textarea>
                        <button type="button" class="btn btn-sm btn-outline-danger ml-2 remove-option-btn" title="Remove option">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                </div>
            `);
        }

        function resetQuestionForm() {
            $('#question_id').val('');
            setEditorCode($('#question_text'), '');
            setEditorCode($('#explanation'), '');
            $('#difficulty').val('Medium');
            $('#recommended_class').val('');
            $('#term_tag').val('');
            $('#question_category').val('');
            $('#review_status').val('draft');
            $('#source_type').val('topic').trigger('change');
            $('#topic_id').val('');
            $('#exam_body_id').val('');
            $('#options-container').empty();
            addOptionRow('', true);
            addOptionRow('');
            addOptionRow('');
            addOptionRow('');
            initializeQuestionBankEditors();
            $('#save-question-btn').html('<i class="fas fa-save mr-1"></i> Save Question');
        }

        function loadMeta() {
            return $.post(controllerUrl, { action: 'get_meta' }, function (response) {
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to load filters.');
                    return;
                }

                questionBankMeta = response.data;
                fillSelect($('#subject_id'), questionBankMeta.subjects, 'id', 'subject', 'Select Subject');
                fillSelect($('#subject_filter'), questionBankMeta.subjects, 'id', 'subject', 'All Subjects');
                fillSelect($('#exam_body_id'), questionBankMeta.exam_bodies, 'id', 'name', 'Select Exam Body');
                refreshTopicOptions();
                refreshTopicFilterOptions();
            }, 'json');
        }

        function loadQuestions() {
            $('#question-list').html('<div class="text-center py-4"><div class="spinner-border text-primary"></div><p class="mt-2 mb-0">Loading questions...</p></div>');

            $.post(controllerUrl, {
                action: 'list_questions',
                page: currentPage,
                per_page: 10,
                search: $('#search_filter').val(),
                subject_id: $('#subject_filter').val(),
                topic_id: $('#topic_filter').val(),
                source_type: $('#source_filter').val(),
                difficulty: $('#difficulty_filter').val(),
                review_status: $('#review_status_filter').val(),
                recommended_class: $('#recommended_class_filter').val(),
                term_tag: $('#term_tag_filter').val(),
                question_category: $('#category_filter').val()
            }, function (response) {
                if (response.status !== 'success') {
                    $('#question-list').html('<div class="alert alert-danger">Unable to load questions.</div>');
                    return;
                }

                renderQuestionList(response.data);
                totalPages = response.pagination.total_pages;
                $('#page-info').text(`Page ${response.pagination.page} / ${totalPages} (${response.pagination.total} questions)`);
                $('#prev-page-btn').prop('disabled', currentPage <= 1);
                $('#next-page-btn').prop('disabled', currentPage >= totalPages);
            }, 'json');
        }

        function renderQuestionList(questions) {
            if (!questions.length) {
                $('#question-list').html('<div class="alert alert-info mb-0">No question bank records found.</div>');
                return;
            }

            const html = questions.map(question => {
                const optionsHtml = (question.options || []).map(option => `
                    <li class="${Number(option.answer) === 1 ? 'text-success font-weight-bold' : ''}">
                        ${escapeHtml(plainText(option.options))}
                    </li>
                `).join('');

                const sourceLabel = question.source_type === 'exam_body'
                    ? `Exam Body${question.exam_body_name ? ': ' + escapeHtml(question.exam_body_name) : ''}`
                    : `Topic${question.topic_name ? ': ' + escapeHtml(question.topic_name) : ''}`;
                const softTags = [
                    question.recommended_class ? `Class: ${escapeHtml(question.recommended_class)}` : '',
                    question.term_tag ? `Term: ${escapeHtml(question.term_tag)}` : '',
                    question.question_category ? `Category: ${escapeHtml(question.question_category)}` : '',
                    `Status: ${escapeHtml(question.review_status || 'approved')}`,
                    `Quality: ${Number(question.quality_score || 0)}`,
                    `Used: ${Number(question.times_used || 0)}`
                ].filter(Boolean).join(' | ');

                return `
                    <div class="border rounded p-3 mb-3">
                        <div class="d-flex justify-content-between align-items-start">
                            <div class="pr-3">
                                <div class="question-preview">${question.question || ''}</div>
                                <div class="small text-muted mt-2">
                                    ${escapeHtml(question.subject || 'No subject')} · ${escapeHtml(question.difficulty || 'Medium')} · ${sourceLabel}
                                </div>
                                <div class="small text-muted mt-1">${softTags}</div>
                            </div>
                            <div class="btn-group btn-group-sm">
                                <button type="button" class="btn btn-outline-success review-status-btn" data-id="${question.id}" data-status="approved" title="Approve">
                                    <i class="fas fa-check"></i>
                                </button>
                                <button type="button" class="btn btn-outline-secondary review-status-btn" data-id="${question.id}" data-status="draft" title="Move to draft">
                                    <i class="fas fa-undo"></i>
                                </button>
                                <button type="button" class="btn btn-outline-warning review-status-btn" data-id="${question.id}" data-status="rejected" title="Reject">
                                    <i class="fas fa-ban"></i>
                                </button>
                                <button type="button" class="btn btn-outline-primary edit-question-btn" data-question='${escapeHtml(JSON.stringify(question))}' title="Edit">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button type="button" class="btn btn-outline-danger delete-question-btn" data-id="${question.id}" title="Delete">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </div>
                        </div>
                        <ol class="mt-2 mb-0">${optionsHtml}</ol>
                    </div>
                `;
            }).join('');

            $('#question-list').html(html);
        }

        function collectOptions() {
            const options = [];
            $('#options-container .option-row').each(function () {
                const text = $(this).find('.option-text').val().trim();
                const editorText = getEditorCode($(this).find('.option-textarea')).trim();
                const finalText = editorText || text;
                if (!plainText(finalText) && finalText.indexOf('<img') === -1 && finalText.indexOf('math-editor-rendered') === -1) {
                    return;
                }

                options.push({
                    text: finalText,
                    is_correct: $(this).find('input[type="radio"]').is(':checked')
                });
            });
            return options;
        }

        function saveQuestion() {
            if (!isSS360Admin) {
                toastr.error('Only SchoolSuite360 admins can save global bank questions.');
                return;
            }

            const options = collectOptions();
            const correctCount = options.filter(option => option.is_correct).length;

            if (options.length < 2 || correctCount !== 1) {
                toastr.warning('Add at least two options and select exactly one correct answer.');
                return;
            }

            const $btn = $('#save-question-btn');
            $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Saving...');

            $.post(controllerUrl, {
                action: 'save_question',
                question_id: $('#question_id').val(),
                question: getEditorCode($('#question_text')),
                subject_id: $('#subject_id').val(),
                class_id: 0,
                source_type: $('#source_type').val(),
                topic_id: $('#topic_id').val(),
                exam_body_id: $('#exam_body_id').val(),
                difficulty: $('#difficulty').val(),
                recommended_class: $('#recommended_class').val(),
                term_tag: $('#term_tag').val(),
                question_category: $('#question_category').val(),
                explanation: getEditorCode($('#explanation')),
                review_status: $('#review_status').val(),
                options: JSON.stringify(options)
            }, function (response) {
                $btn.prop('disabled', false).html('<i class="fas fa-save mr-1"></i> Save Question');
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to save question.');
                    return;
                }

                toastr.success(response.message);
                resetQuestionForm();
                loadQuestions();
            }, 'json').fail(function () {
                $btn.prop('disabled', false).html('<i class="fas fa-save mr-1"></i> Save Question');
                toastr.error('Server error while saving question.');
            });
        }

        function editQuestion(question) {
            $('#question_id').val(question.id);
            setEditorCode($('#question_text'), question.question);
            setEditorCode($('#explanation'), question.explanation || '');
            $('#subject_id').val(question.subject_id);
            $('#difficulty').val(question.difficulty || 'Medium');
            $('#recommended_class').val(question.recommended_class || '');
            $('#term_tag').val(question.term_tag || '');
            $('#question_category').val(question.question_category || '');
            $('#review_status').val(question.review_status || 'approved');
            $('#source_type').val(question.source_type || 'topic').trigger('change');
            refreshTopicOptions();
            $('#topic_id').val(question.topic_id || '');
            $('#exam_body_id').val(question.exam_body_id || '');
            $('#options-container').empty();

            (question.options || []).forEach(option => addOptionRow(option.options, Number(option.answer) === 1));
            if (!question.options || question.options.length < 2) {
                addOptionRow('', true);
                addOptionRow('');
            }

            $('#save-question-btn').html('<i class="fas fa-save mr-1"></i> Update Question');
            initializeQuestionBankEditors();
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function deleteQuestion(questionId) {
            if (!isSS360Admin) {
                toastr.error('Only SchoolSuite360 admins can delete global bank questions.');
                return;
            }

            if (!confirm('Delete this question from the question bank?')) {
                return;
            }

            $.post(controllerUrl, { action: 'delete_question', question_id: questionId }, function (response) {
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to delete question.');
                    return;
                }

                toastr.success(response.message);
                loadQuestions();
            }, 'json');
        }

        function updateReviewStatus(questionId, reviewStatus) {
            if (!isSS360Admin) {
                toastr.error('Only SchoolSuite360 admins can update review status.');
                return;
            }

            $.post(controllerUrl, {
                action: 'update_review_status',
                question_id: questionId,
                review_status: reviewStatus
            }, function (response) {
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to update review status.');
                    return;
                }

                toastr.success(response.message);
                loadQuestions();
            }, 'json');
        }

        function generateBankQuestions() {
            if (!isSS360Admin) {
                toastr.error('Only SchoolSuite360 admins can generate global bank drafts.');
                return;
            }

            const subjectName = $('#subject_id option:selected').text();
            const topicName = $('#topic_id option:selected').text();
            const $btn = $('#generate-bank-btn');

            if (!$('#subject_id').val() || !$('#topic_id').val()) {
                toastr.warning('Select a subject and topic before generating bank questions.');
                return;
            }

            $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Generating...');
            $.post(controllerUrl, {
                action: 'generate_bank_questions',
                subject_id: $('#subject_id').val(),
                topic_id: $('#topic_id').val(),
                subject_name: subjectName,
                topic_name: topicName,
                difficulty: $('#ai_bank_difficulty').val(),
                num_questions: $('#ai_bank_count').val(),
                recommended_class: $('#recommended_class').val(),
                term_tag: $('#term_tag').val(),
                question_category: $('#question_category').val(),
                curriculum_context: $('#ai_curriculum_context').val()
            }, function (response) {
                $btn.prop('disabled', false).html('<i class="fas fa-magic mr-1"></i> Generate Drafts');
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to generate bank questions.');
                    return;
                }

                toastr.success(response.message);
                $('#review_status_filter').val('draft');
                currentPage = 1;
                loadQuestions();
            }, 'json').fail(function () {
                $btn.prop('disabled', false).html('<i class="fas fa-magic mr-1"></i> Generate Drafts');
                toastr.error('Server error while generating bank questions.');
            });
        }

        function renderStructuredQuestions(questions) {
            const html = questions.map((question, index) => {
                const options = (question.options || []).map(option => `
                    <li class="${option.is_correct ? 'text-success font-weight-bold' : ''}">${escapeHtml(option.text)}</li>
                `).join('');

                return `
                    <div class="structured-question mb-2" data-index="${index}">
                        <div class="font-weight-bold mb-2">${question.question}</div>
                        <ol>${options}</ol>
                        <button type="button" class="btn btn-sm btn-primary use-structured-btn" data-index="${index}">
                            Use This Question
                        </button>
                    </div>
                `;
            }).join('');

            $('#structured-questions').data('questions', questions).html(html);
        }

        function restructureQuestions() {
            if (!isSS360Admin) {
                toastr.error('Only SchoolSuite360 admins can restructure global bank questions.');
                return;
            }

            const subjectName = $('#subject_id option:selected').text();
            const $btn = $('#restructure-btn');
            $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Restructuring...');

            $.post(controllerUrl, {
                action: 'restructure_questions',
                raw_questions: getEditorCode($('#raw_questions')),
                subject_name: subjectName,
                difficulty: $('#difficulty').val()
            }, function (response) {
                $btn.prop('disabled', false).html('<i class="fas fa-magic mr-1"></i> Restructure with AI');
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to restructure questions.');
                    return;
                }

                renderStructuredQuestions(response.data);
                toastr.success(`AI prepared ${response.data.length} question(s). Review before saving.`);
            }, 'json').fail(function () {
                $btn.prop('disabled', false).html('<i class="fas fa-magic mr-1"></i> Restructure with AI');
                toastr.error('Server error while restructuring questions.');
            });
        }

        $(function () {
            loadMeta().then(function () {
                resetQuestionForm();
                applyAdminGate();
                loadQuestions();
            });

            $('#source_type').on('change', function () {
                const isExamBody = $(this).val() === 'exam_body';
                $('#topic-field').toggleClass('d-none', isExamBody);
                $('#exam-body-field').toggleClass('d-none', !isExamBody);
            });

            $('#subject_id').on('change', refreshTopicOptions);
            $('#subject_filter').on('change', function () {
                refreshTopicFilterOptions();
                currentPage = 1;
                loadQuestions();
            });

            $('#reset-form-btn').on('click', resetQuestionForm);
            $('#add-option-btn').on('click', function () {
                addOptionRow();
                initializeQuestionBankEditors();
            });
            $('#question-form').on('submit', function (event) {
                event.preventDefault();
                saveQuestion();
            });

            $('#options-container').on('click', '.remove-option-btn', function () {
                $(this).closest('.option-row').remove();
            });

            $('#search_filter, #topic_filter, #source_filter, #difficulty_filter, #review_status_filter, #recommended_class_filter, #term_tag_filter, #category_filter').on('input change', function () {
                currentPage = 1;
                loadQuestions();
            });

            $('#prev-page-btn').on('click', function () {
                if (currentPage > 1) {
                    currentPage--;
                    loadQuestions();
                }
            });

            $('#next-page-btn').on('click', function () {
                if (currentPage < totalPages) {
                    currentPage++;
                    loadQuestions();
                }
            });

            $('#question-list').on('click', '.edit-question-btn', function () {
                editQuestion(JSON.parse($(this).attr('data-question')));
            });

            $('#question-list').on('click', '.delete-question-btn', function () {
                deleteQuestion($(this).data('id'));
            });

            $('#question-list').on('click', '.review-status-btn', function () {
                updateReviewStatus($(this).data('id'), $(this).data('status'));
            });

            $('#restructure-btn').on('click', restructureQuestions);
            $('#generate-bank-btn').on('click', generateBankQuestions);

            $('#structured-questions').on('click', '.use-structured-btn', function () {
                const questions = $('#structured-questions').data('questions') || [];
                const question = questions[$(this).data('index')];
                if (!question) {
                    return;
                }

                $('#question_id').val('');
                setEditorCode($('#question_text'), question.question);
                $('#difficulty').val(question.difficulty || 'Medium');
                $('#question_category').val(question.question_category || $('#question_category').val());
                setEditorCode($('#explanation'), question.explanation || '');
                $('#options-container').empty();
                question.options.forEach(option => addOptionRow(option.text, option.is_correct));
                $('#save-question-btn').html('<i class="fas fa-save mr-1"></i> Save Question');
                initializeQuestionBankEditors();
                window.scrollTo({ top: 0, behavior: 'smooth' });
            });

            initializeQuestionBankEditors();
        });
    </script>
</body>

</html>
