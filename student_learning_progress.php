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
    <title>My Learning Progress</title>
    <link rel="icon" href="418769schoollogo.jpg" type="image/jpeg">
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <style>
        :root {
            --progress-primary: #2563eb;
            --progress-green: #16a34a;
            --progress-orange: #f59e0b;
            --progress-dark: #111827;
            --progress-muted: #6b7280;
            --progress-border: #dbe4f0;
            --progress-soft: #eef4ff;
        }

        body {
            background: #f4f7fb;
            color: var(--progress-dark);
        }

        .progress-shell {
            max-width: 1060px;
            margin: 0 auto;
            padding: 18px 14px 36px;
        }

        .progress-header,
        .progress-panel,
        .metric-card {
            background: #ffffff;
            border: 1px solid var(--progress-border);
            border-radius: 10px;
        }

        .progress-header {
            padding: 18px;
            margin-bottom: 16px;
        }

        .page-title {
            font-size: 1.55rem;
            font-weight: 800;
            margin-bottom: 4px;
        }

        .page-subtitle {
            color: var(--progress-muted);
            margin-bottom: 0;
        }

        .range-toggle {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 8px;
            margin: 16px 0;
            max-width: 360px;
        }

        .range-button {
            border: 2px solid var(--progress-border);
            background: #ffffff;
            border-radius: 8px;
            color: var(--progress-dark);
            cursor: pointer;
            font-weight: 700;
            min-height: 48px;
        }

        .range-button.active {
            background: var(--progress-soft);
            border-color: var(--progress-primary);
            color: #123f9f;
        }

        .metric-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(170px, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }

        .metric-card {
            padding: 16px;
        }

        .metric-label {
            color: var(--progress-muted);
            font-size: 0.95rem;
            margin-bottom: 8px;
        }

        .metric-value {
            font-size: 2rem;
            font-weight: 800;
            line-height: 1.05;
        }

        .metric-help {
            color: var(--progress-muted);
            font-size: 0.9rem;
            margin-top: 6px;
        }

        .progress-panel {
            padding: 18px;
            margin-bottom: 16px;
        }

        .section-title {
            font-size: 1.15rem;
            font-weight: 800;
            margin-bottom: 4px;
        }

        .topic-row {
            border-top: 1px solid #edf1f7;
            padding: 14px 0;
        }

        .topic-row:first-child {
            border-top: 0;
        }

        .topic-title {
            font-weight: 700;
        }

        .topic-meta {
            color: var(--progress-muted);
            font-size: 0.9rem;
        }

        .mastery-bar {
            background: #e5e7eb;
            border-radius: 999px;
            height: 12px;
            overflow: hidden;
        }

        .mastery-fill {
            background: var(--progress-primary);
            height: 100%;
            min-width: 2px;
        }

        .empty-state {
            background: #ffffff;
            border: 1px dashed var(--progress-border);
            border-radius: 10px;
            padding: 28px 18px;
            text-align: center;
        }

        .recommendation {
            background: #fff7ed;
            border: 1px solid #fed7aa;
            border-radius: 10px;
            color: #8a4b00;
            padding: 14px;
        }

        .hidden {
            display: none !important;
        }

        @media (max-width: 576px) {
            .page-title {
                font-size: 1.3rem;
            }

            .progress-header,
            .progress-panel,
            .metric-card {
                padding: 14px;
            }

            .metric-value {
                font-size: 1.7rem;
            }
        }
    </style>
</head>

<body>
    <main class="progress-shell">
        <div class="progress-header">
            <div class="d-flex flex-wrap justify-content-between align-items-center">
                <div>
                    <div class="page-title">My Learning Progress</div>
                    <p class="page-subtitle">See what you have practiced and what to try next.</p>
                </div>
                <div class="mt-3 mt-sm-0">
                    <a href="student_practice" class="btn btn-primary mr-2 mb-2">Practice Now</a>
                    <a href="student_portal" class="btn btn-outline-secondary mb-2">Back</a>
                </div>
            </div>
        </div>

        <div class="range-toggle" aria-label="Progress range">
            <button type="button" class="range-button active" data-range="week">This week</button>
            <button type="button" class="range-button" data-range="all">All time</button>
        </div>

        <section id="loadingState" class="progress-panel">
            Loading your progress...
        </section>

        <section id="emptyState" class="empty-state hidden">
            <h3 class="mb-2">Start practicing to see your progress here.</h3>
            <p class="text-muted">Your scores, best subject, and topics will appear after you finish practice.</p>
            <a href="student_practice" class="btn btn-primary btn-lg">Practice Now</a>
        </section>

        <section id="dashboardContent" class="hidden">
            <div class="metric-grid">
                <div class="metric-card">
                    <div class="metric-label">Questions practiced</div>
                    <div class="metric-value" id="questionsAttempted">0</div>
                    <div class="metric-help">Completed practice questions</div>
                </div>
                <div class="metric-card">
                    <div class="metric-label">Correct answers</div>
                    <div class="metric-value text-success" id="correctAnswers">0</div>
                    <div class="metric-help">Questions you got right</div>
                </div>
                <div class="metric-card">
                    <div class="metric-label">Average score</div>
                    <div class="metric-value text-primary" id="averageScore">0%</div>
                    <div class="metric-help" id="weeklyChange">Keep practicing each week</div>
                </div>
                <div class="metric-card">
                    <div class="metric-label">Time spent learning</div>
                    <div class="metric-value" id="timeSpent">0 min</div>
                    <div class="metric-help">Practice time completed</div>
                </div>
            </div>

            <div class="metric-grid">
                <div class="metric-card">
                    <div class="metric-label">Best subject</div>
                    <div class="metric-value" id="bestSubject">-</div>
                    <div class="metric-help" id="bestSubjectHelp">Your strongest area</div>
                </div>
                <div class="metric-card">
                    <div class="metric-label">Needs more practice</div>
                    <div class="metric-value" id="weakestSubject">-</div>
                    <div class="metric-help" id="weakestSubjectHelp">Try a few more questions here</div>
                </div>
            </div>

            <div id="recommendationBox" class="recommendation mb-3 hidden"></div>

            <section class="progress-panel">
                <div class="section-title">Topic progress</div>
                <p class="text-muted mb-3">These bars show topics to practice more. Lower bars need more attention.</p>
                <div id="topicList"></div>
            </section>
        </section>
    </main>

    <script src="../plugins/jquery/jquery.min.js"></script>
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script>
        const controllerUrl = '../student_learning_progress_controller.php';
        let selectedRange = 'week';

        function escapeHtml(value) {
            return $('<div>').text(value || '').html();
        }

        function formatTime(seconds) {
            const totalMinutes = Math.round(Number(seconds || 0) / 60);
            if (totalMinutes < 60) {
                return `${totalMinutes} min`;
            }

            const hours = Math.floor(totalMinutes / 60);
            const minutes = totalMinutes % 60;
            return minutes > 0 ? `${hours} hr ${minutes} min` : `${hours} hr`;
        }

        function showState(state) {
            $('#loadingState, #emptyState, #dashboardContent').addClass('hidden');
            $(state).removeClass('hidden');
        }

        function loadDashboard() {
            showState('#loadingState');
            $.post(controllerUrl, {
                action: 'get_dashboard',
                range: selectedRange
            }, function (response) {
                if (response.status !== 'success') {
                    toastr.error(response.message || 'Unable to load progress.');
                    showState('#emptyState');
                    return;
                }

                renderDashboard(response.data);
            }, 'json').fail(function () {
                toastr.error('Network error while loading progress.');
                showState('#emptyState');
            });
        }

        function renderDashboard(data) {
            const summary = data.summary || {};
            const hasProgress = Number(summary.questions_attempted || 0) > 0;

            if (!hasProgress) {
                showState('#emptyState');
                return;
            }

            $('#questionsAttempted').text(summary.questions_attempted || 0);
            $('#correctAnswers').text(summary.correct_answers || 0);
            $('#averageScore').text(`${summary.average_score || 0}%`);
            $('#timeSpent').text(formatTime(summary.time_spent_seconds));

            renderSubjectCard(data.best_subject, '#bestSubject', '#bestSubjectHelp');
            renderSubjectCard(data.weakest_subject, '#weakestSubject', '#weakestSubjectHelp');
            renderWeeklyChange(data.weekly_change);
            renderRecommendation(data.weakest_subject, data.topics || []);
            renderTopics(data.topics || []);
            showState('#dashboardContent');
        }

        function renderSubjectCard(subject, nameSelector, helpSelector) {
            if (!subject) {
                $(nameSelector).text('-');
                $(helpSelector).text('Practice more to unlock this.');
                return;
            }

            $(nameSelector).text(subject.subject || '-');
            $(helpSelector).text(`${subject.mastery_percent || 0}% from ${subject.answered_questions || 0} answered`);
        }

        function renderWeeklyChange(changeData) {
            if (!changeData || changeData.change === null || selectedRange !== 'week') {
                $('#weeklyChange').text('Keep practicing each week');
                return;
            }

            const change = Number(changeData.change);
            if (change > 0) {
                $('#weeklyChange').text(`Up ${change}% from last week`);
            } else if (change < 0) {
                $('#weeklyChange').text(`${Math.abs(change)}% lower than last week`);
            } else {
                $('#weeklyChange').text('Same as last week');
            }
        }

        function renderRecommendation(weakestSubject, topics) {
            if (!weakestSubject) {
                $('#recommendationBox').addClass('hidden').empty();
                return;
            }

            const weakestTopic = topics.length > 0 ? topics[0] : null;
            const topicText = weakestTopic ? `: ${escapeHtml(weakestTopic.topic_name)}` : '';
            $('#recommendationBox')
                .removeClass('hidden')
                .html(`Try more <strong>${escapeHtml(weakestSubject.subject)}${topicText}</strong> practice next.`);
        }

        function renderTopics(topics) {
            const $topicList = $('#topicList').empty();
            if (topics.length === 0) {
                $topicList.html('<p class="text-muted mb-0">Finish more practice to see topic progress.</p>');
                return;
            }

            topics.forEach(function (topic) {
                const percent = Number(topic.mastery_percent || 0);
                $topicList.append(`
                    <div class="topic-row">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <div>
                                <div class="topic-title">${escapeHtml(topic.topic_name)}</div>
                                <div class="topic-meta">${escapeHtml(topic.subject)} - ${topic.correct_answers || 0}/${topic.answered_questions || 0} correct</div>
                            </div>
                            <strong>${percent}%</strong>
                        </div>
                        <div class="mastery-bar">
                            <div class="mastery-fill" style="width: ${Math.max(0, Math.min(100, percent))}%"></div>
                        </div>
                    </div>
                `);
            });
        }

        $('.range-button').on('click', function () {
            selectedRange = $(this).data('range');
            $('.range-button').removeClass('active');
            $(this).addClass('active');
            loadDashboard();
        });

        loadDashboard();
    </script>
</body>

</html>
