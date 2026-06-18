<?php
session_start();

if (!isset($_SESSION['userid']) || ($_SESSION['user_type'] ?? '') !== 'student') {
    header("Location: login");
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Practice Questions</title>
    <link rel="icon" href="418769schoollogo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="../plugins/icheck-bootstrap/icheck-bootstrap.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <style>
        :root {
            --practice-primary: #2563eb;
            --practice-dark: #111827;
            --practice-muted: #6b7280;
            --practice-border: #dbe4f0;
            --practice-soft: #eef4ff;
        }

        body {
            background: #f4f7fb;
            color: var(--practice-dark);
        }

        .practice-shell {
            max-width: 980px;
            margin: 0 auto;
            padding: 18px 14px 36px;
        }

        .practice-header {
            background: #ffffff;
            border: 1px solid var(--practice-border);
            border-radius: 10px;
            padding: 18px;
            margin-bottom: 16px;
        }

        .practice-title {
            font-size: 1.55rem;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .practice-subtitle {
            color: var(--practice-muted);
            margin-bottom: 0;
        }

        .practice-panel {
            background: #ffffff;
            border: 1px solid var(--practice-border);
            border-radius: 10px;
            padding: 18px;
        }

        .practice-step {
            border-bottom: 1px solid #edf1f7;
            padding: 16px 0;
        }

        .practice-step:first-child {
            padding-top: 0;
        }

        .practice-step:last-child {
            border-bottom: 0;
            padding-bottom: 0;
        }

        .step-label {
            display: block;
            font-size: 1rem;
            font-weight: 700;
            margin-bottom: 8px;
        }

        .help-text {
            color: var(--practice-muted);
            font-size: 0.95rem;
            margin-bottom: 10px;
        }

        .large-select {
            min-height: 52px;
            font-size: 1.05rem;
            border-radius: 8px;
        }

        .choice-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(130px, 1fr));
            gap: 10px;
        }

        .choice-button,
        .answer-option {
            border: 2px solid var(--practice-border);
            background: #ffffff;
            border-radius: 8px;
            color: var(--practice-dark);
            cursor: pointer;
            min-height: 54px;
            padding: 12px;
            text-align: center;
            width: 100%;
        }

        .choice-button.active,
        .answer-option.active {
            background: var(--practice-soft);
            border-color: var(--practice-primary);
            color: #123f9f;
            font-weight: 700;
        }

        .answer-option {
            display: block;
            font-size: 1.05rem;
            margin-bottom: 12px;
            text-align: left;
        }

        .answer-option p {
            margin-bottom: 0;
        }

        .question-card {
            background: #ffffff;
            border: 1px solid var(--practice-border);
            border-radius: 10px;
            padding: 18px;
        }

        .question-meta {
            color: var(--practice-muted);
            font-size: 0.95rem;
        }

        .question-text {
            font-size: 1.12rem;
            line-height: 1.65;
            margin: 18px 0;
        }

        .practice-progress {
            background: #e5e7eb;
            border-radius: 999px;
            height: 10px;
            overflow: hidden;
        }

        .practice-progress-bar {
            background: var(--practice-primary);
            height: 100%;
            transition: width 0.2s ease;
            width: 0;
        }

        .practice-timer {
            background: #111827;
            border-radius: 999px;
            color: #ffffff;
            display: none;
            font-size: 1rem;
            font-weight: 700;
            padding: 8px 14px;
        }

        .summary-score {
            color: var(--practice-primary);
            font-size: 3rem;
            font-weight: 800;
            line-height: 1;
        }

        .review-item {
            border: 1px solid var(--practice-border);
            border-radius: 8px;
            margin-bottom: 10px;
            padding: 12px;
        }

        .hidden {
            display: none !important;
        }

        @media (max-width: 576px) {
            .practice-title {
                font-size: 1.3rem;
            }

            .practice-panel,
            .question-card,
            .practice-header {
                padding: 14px;
            }

            .choice-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
    <main class="practice-shell">
        <div class="practice-header">
            <div class="d-flex flex-wrap justify-content-between align-items-center">
                <div>
                    <div class="practice-title">Practice Questions</div>
                    <p class="practice-subtitle">Choose a few simple options, then start learning at your own pace.</p>
                </div>
                <a href="student_portal" class="btn btn-outline-secondary mt-3 mt-sm-0">
                    <i class="fas fa-arrow-left mr-1"></i> Back
                </a>
            </div>
        </div>

        <section id="setupScreen" class="practice-panel">
            <div class="practice-step">
                <label for="subjectSelect" class="step-label">1. What do you want to practice?</label>
                <p class="help-text">Pick one subject, or choose all subjects for mixed practice.</p>
                <select id="subjectSelect" class="form-control large-select">
                    <option value="">Loading subjects...</option>
                </select>
            </div>

            <div class="practice-step" id="topicStep">
                <label for="topicSelect" class="step-label">2. Pick a topic</label>
                <p class="help-text">You can also leave this as any topic.</p>
                <select id="topicSelect" class="form-control large-select">
                    <option value="">Any topic in this subject</option>
                </select>
            </div>

            <div class="practice-step">
                <span class="step-label">3. Choose difficulty</span>
                <div class="choice-grid" id="difficultyButtons">
                    <button type="button" class="choice-button" data-value="Easy">Easy</button>
                    <button type="button" class="choice-button active" data-value="Mixed">Mixed</button>
                    <button type="button" class="choice-button" data-value="Medium">Medium</button>
                    <button type="button" class="choice-button" data-value="Hard">Hard</button>
                </div>
            </div>

            <div class="practice-step">
                <span class="step-label">4. How many questions?</span>
                <div class="choice-grid" id="countButtons">
                    <button type="button" class="choice-button active" data-value="10">10</button>
                    <button type="button" class="choice-button" data-value="20">20</button>
                    <button type="button" class="choice-button" data-value="50">50</button>
                    <button type="button" class="choice-button" data-value="100">100</button>
                </div>
            </div>

            <div class="practice-step">
                <span class="step-label">5. Timer</span>
                <div class="choice-grid" id="timerButtons">
                    <button type="button" class="choice-button active" data-value="0">No timer</button>
                    <button type="button" class="choice-button" data-value="1">Use timer</button>
                </div>
            </div>

            <div class="mt-4">
                <button type="button" id="startPracticeBtn" class="btn btn-primary btn-lg btn-block">
                    Start Practice
                </button>
            </div>
        </section>

        <section id="practiceScreen" class="hidden">
            <div class="question-card">
                <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
                    <div>
                        <strong id="questionCounter">Question 1 of 10</strong>
                        <div id="questionTopic" class="question-meta"></div>
                    </div>
                    <div id="timerDisplay" class="practice-timer">15:00</div>
                </div>
                <div class="practice-progress mb-3">
                    <div id="progressBar" class="practice-progress-bar"></div>
                </div>
                <div id="questionText" class="question-text">Loading question...</div>
                <div id="answerOptions"></div>
                <div class="d-flex flex-wrap justify-content-between mt-4">
                    <button type="button" id="previousBtn" class="btn btn-outline-secondary mb-2">Previous</button>
                    <div>
                        <button type="button" id="nextBtn" class="btn btn-primary mb-2">Next</button>
                        <button type="button" id="finishBtn" class="btn btn-success mb-2">Finish</button>
                    </div>
                </div>
            </div>
        </section>

        <section id="summaryScreen" class="practice-panel hidden">
            <div class="text-center mb-4">
                <div class="summary-score" id="summaryScore">0%</div>
                <h3 class="mt-2 mb-1">Your Score</h3>
                <p id="summaryText" class="text-muted mb-0"></p>
            </div>
            <div id="reviewList"></div>
            <div class="d-flex flex-wrap justify-content-center mt-4">
                <button type="button" id="tryAgainBtn" class="btn btn-primary btn-lg mr-sm-2 mb-2">Try Again</button>
                <a href="student_portal" class="btn btn-outline-secondary btn-lg mb-2">Back to Portal</a>
            </div>
        </section>
    </main>

    <script src="../plugins/jquery/jquery.min.js"></script>
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script>
        const controllerUrl = '../student_practice_controller.php';
        const practiceState = {
            subjects: [],
            topics: [],
            sessionId: 0,
            totalQuestions: 0,
            currentPosition: 1,
            timed: false,
            secondsLeft: 0,
            timerHandle: null,
            answers: {}
        };

        function escapeHtml(value) {
            return $('<div>').text(value || '').html();
        }

        function setActiveChoice(container, value) {
            $(container).find('.choice-button').removeClass('active');
            $(container).find(`[data-value="${value}"]`).addClass('active');
        }

        function selectedChoice(container) {
            return $(container).find('.choice-button.active').data('value');
        }

        function renderMathFallback($root) {
            $root.find('.math-editor-rendered').each(function () {
                const latex = $(this).attr('data-latex') || '';
                if (!$(this).text().trim() && latex) {
                    $(this).text(latex).css({
                        display: 'inline-block',
                        padding: '2px 4px',
                        background: '#f3f4f6',
                        borderRadius: '4px'
                    });
                }
            });
        }

        function showScreen(screenId) {
            $('#setupScreen, #practiceScreen, #summaryScreen').addClass('hidden');
            $(screenId).removeClass('hidden');
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }

        function loadFilters() {
            $.post(controllerUrl, { action: 'get_filters' }, function (response) {
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to load practice options.');
                    return;
                }

                practiceState.subjects = response.data.subjects || [];
                practiceState.topics = response.data.topics || [];
                renderSubjectOptions();
                renderTopicOptions();
            }, 'json').fail(function () {
                toastr.error('Network error while loading practice options.');
            });
        }

        function renderSubjectOptions() {
            const $select = $('#subjectSelect');
            $select.empty();
            $select.append('<option value="all">All subjects mixed together</option>');

            practiceState.subjects.forEach(function (subject) {
                const label = `${subject.subject} (${subject.question_count})`;
                $select.append(`<option value="${subject.id}">${escapeHtml(label)}</option>`);
            });

            if (practiceState.subjects.length > 0) {
                $select.val(practiceState.subjects[0].id);
            }
        }

        function renderTopicOptions() {
            const subjectId = $('#subjectSelect').val();
            const $topicSelect = $('#topicSelect');
            $topicSelect.empty().append('<option value="">Any topic in this subject</option>');

            if (subjectId === 'all') {
                $('#topicStep').addClass('hidden');
                return;
            }

            $('#topicStep').removeClass('hidden');
            practiceState.topics
                .filter(topic => String(topic.subject_id) === String(subjectId))
                .forEach(function (topic) {
                    const label = `${topic.topic_name} (${topic.question_count})`;
                    $topicSelect.append(`<option value="${topic.id}">${escapeHtml(label)}</option>`);
                });
        }

        function buildPracticePayload() {
            const subjectId = $('#subjectSelect').val();
            const topicId = $('#topicSelect').val();
            let scope = 'mixed_topic';

            if (subjectId === 'all') {
                scope = 'mixed_subject';
            } else if (topicId) {
                scope = 'topic';
            }

            return {
                action: 'start_session',
                practice_scope: scope,
                subject_id: subjectId === 'all' ? 0 : subjectId,
                topic_id: topicId || 0,
                difficulty: selectedChoice('#difficultyButtons'),
                question_count: selectedChoice('#countButtons'),
                timed: selectedChoice('#timerButtons')
            };
        }

        function startPractice() {
            const payload = buildPracticePayload();
            $('#startPracticeBtn').prop('disabled', true).text('Starting...');

            $.post(controllerUrl, payload, function (response) {
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to start practice.');
                    return;
                }

                practiceState.sessionId = response.data.session_id;
                practiceState.totalQuestions = response.data.total_questions;
                practiceState.currentPosition = 1;
                practiceState.timed = Number(response.data.timed) === 1;
                practiceState.secondsLeft = Number(response.data.duration_seconds || 0);
                practiceState.answers = {};

                if (response.message) {
                    toastr.info(response.message);
                }

                showScreen('#practiceScreen');
                loadQuestion(1);
                setupTimer();
            }, 'json').fail(function () {
                toastr.error('Network error while starting practice.');
            }).always(function () {
                $('#startPracticeBtn').prop('disabled', false).text('Start Practice');
            });
        }

        function setupTimer() {
            clearInterval(practiceState.timerHandle);
            $('#timerDisplay').toggle(practiceState.timed);

            if (!practiceState.timed) {
                return;
            }

            updateTimerDisplay();
            practiceState.timerHandle = setInterval(function () {
                practiceState.secondsLeft -= 1;
                updateTimerDisplay();

                if (practiceState.secondsLeft <= 0) {
                    clearInterval(practiceState.timerHandle);
                    toastr.info('Time is up. Your practice will be finished now.');
                    finishPractice();
                }
            }, 1000);
        }

        function updateTimerDisplay() {
            const minutes = Math.floor(practiceState.secondsLeft / 60);
            const seconds = practiceState.secondsLeft % 60;
            $('#timerDisplay').text(`${minutes}:${String(seconds).padStart(2, '0')}`);
        }

        function loadQuestion(position) {
            if (position < 1 || position > practiceState.totalQuestions) {
                return;
            }

            practiceState.currentPosition = position;
            $('#questionText').html('Loading question...');
            $('#answerOptions').empty();

            $.post(controllerUrl, {
                action: 'get_question',
                session_id: practiceState.sessionId,
                position: position
            }, function (response) {
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to load question.');
                    return;
                }

                renderQuestion(response.data);
            }, 'json').fail(function () {
                toastr.error('Network error while loading question.');
            });
        }

        function renderQuestion(data) {
            const question = data.question;
            practiceState.answers[question.id] = Number(data.selected_option_id || 0);

            $('#questionCounter').text(`Question ${data.position} of ${data.total_questions}`);
            $('#questionTopic').text([question.subject, question.topic_name, question.difficulty].filter(Boolean).join(' - '));
            $('#progressBar').css('width', `${(data.position / data.total_questions) * 100}%`);
            $('#questionText').html(question.question);

            const $options = $('#answerOptions').empty();
            data.options.forEach(function (option) {
                const selected = Number(option.id) === Number(data.selected_option_id);
                const $button = $(`
                    <button type="button" class="answer-option ${selected ? 'active' : ''}" data-option-id="${option.id}">
                        ${option.text}
                    </button>
                `);
                $button.on('click', function () {
                    chooseAnswer(question.id, option.id);
                });
                $options.append($button);
            });

            renderMathFallback($('#questionText, #answerOptions'));
            $('#previousBtn').prop('disabled', data.position === 1);
            $('#nextBtn').toggle(data.position < data.total_questions);
            $('#finishBtn').toggle(data.position === data.total_questions);
        }

        function chooseAnswer(questionId, optionId) {
            $('.answer-option').removeClass('active');
            $(`.answer-option[data-option-id="${optionId}"]`).addClass('active');
            practiceState.answers[questionId] = Number(optionId);

            $.post(controllerUrl, {
                action: 'save_answer',
                session_id: practiceState.sessionId,
                question_id: questionId,
                option_id: optionId
            }, function (response) {
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to save answer.');
                }
            }, 'json').fail(function () {
                toastr.error('Network error while saving answer.');
            });
        }

        function finishPractice() {
            clearInterval(practiceState.timerHandle);
            $('#finishBtn').prop('disabled', true).text('Finishing...');

            $.post(controllerUrl, {
                action: 'finish_session',
                session_id: practiceState.sessionId
            }, function (response) {
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to finish practice.');
                    return;
                }

                renderSummary(response.data);
                showScreen('#summaryScreen');
            }, 'json').fail(function () {
                toastr.error('Network error while finishing practice.');
            }).always(function () {
                $('#finishBtn').prop('disabled', false).text('Finish');
            });
        }

        function renderSummary(data) {
            $('#summaryScore').text(`${data.percentage}%`);
            $('#summaryText').text(`You got ${data.score} out of ${data.total_questions} question(s) correct.`);

            const $review = $('#reviewList').empty();
            data.review.forEach(function (item, index) {
                const selected = item.options.find(option => Number(option.id) === Number(item.selected_option_id));
                const wasCorrect = Number(item.selected_option_id) === Number(item.correct_option_id);
                $review.append(`
                    <div class="review-item">
                        <strong>Question ${index + 1}</strong>
                        <div class="mt-2">${item.question}</div>
                        <div class="mt-2 ${wasCorrect ? 'text-success' : 'text-danger'}">
                            ${wasCorrect ? 'Correct' : 'Not correct'}
                        </div>
                        <div class="small text-muted mt-1">Your answer: ${selected ? selected.text : 'No answer selected'}</div>
                        <div class="small text-muted">Correct answer: ${item.correct_option_text}</div>
                    </div>
                `);
            });

            renderMathFallback($review);
        }

        $('#subjectSelect').on('change', renderTopicOptions);
        $('#difficultyButtons, #countButtons, #timerButtons').on('click', '.choice-button', function () {
            setActiveChoice(`#${$(this).parent().attr('id')}`, $(this).data('value'));
        });
        $('#startPracticeBtn').on('click', startPractice);
        $('#previousBtn').on('click', function () {
            loadQuestion(practiceState.currentPosition - 1);
        });
        $('#nextBtn').on('click', function () {
            loadQuestion(practiceState.currentPosition + 1);
        });
        $('#finishBtn').on('click', finishPractice);
        $('#tryAgainBtn').on('click', function () {
            showScreen('#setupScreen');
        });

        loadFilters();
    </script>
</body>

</html>
