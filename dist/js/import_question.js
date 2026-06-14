/* Import Question Feature JavaScript */

let currentImportPage = 1;
let importFilterData = { subjects: [], classes: [], exam_bodies: [], exam_years: [], topics: [] };

function escapeImportHtml(value) {
    return String(value || '').replace(/[&<>"']/g, function (char) {
        return ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#039;' })[char];
    });
}

function openImportQuestionModal() {
    $('#importQuestionModal').modal('show');
    loadImportFilters();
    $('#import-questions-list').html('<div class="alert alert-info">Please select Subject, Source Type, and Topic/Exam Body to view questions.</div>');
    $('#import-pagination').hide();

    const subjectId = $("#select_subject_field").val();
    if (subjectId) {
        $("#import_subject_filter").val(subjectId).trigger('change');
    }
}

function loadImportFilters() {
    $.ajax({
        url: '../import_question_controller.php',
        type: 'POST',
        data: { action: 'get_import_filters' },
        success: function (response) {
            try {
                const res = typeof response === 'string' ? JSON.parse(response) : response;
                if (res.status !== 'success') {
                    toastr.error(res.message || 'Unable to load import filters.');
                    return;
                }

                importFilterData = res.data;
                fillImportFilters();
                bindImportFilterEvents();

                const mainSubjectId = $("#select_subject_field").val();
                if (mainSubjectId) {
                    $('#import_subject_filter').val(mainSubjectId);
                }
                refreshImportTopicOptions();
            } catch (e) {
                console.error("Error parsing filters", e);
            }
        }
    });
}

function fillImportFilters() {
    let subjectHtml = '<option value="">Select Subject</option>';
    importFilterData.subjects.forEach(s => {
        subjectHtml += `<option value="${s.id}">${escapeImportHtml(s.subject)}</option>`;
    });
    $('#import_subject_filter').html(subjectHtml);

    let classHtml = '<option value="">Any Class/Level</option>';
    importFilterData.classes.forEach(c => {
        classHtml += `<option value="${c.id}">${escapeImportHtml(c.classname)}</option>`;
    });
    $('#import_class_filter').html(classHtml);

    let examBodyHtml = '<option value="">Select Exam Body</option>';
    importFilterData.exam_bodies.forEach(e => {
        examBodyHtml += `<option value="${e.id}">${escapeImportHtml(e.name)}</option>`;
    });
    $('#import_exam_body').html(examBodyHtml);
    refreshImportExamYearOptions();
}

function refreshImportExamYearOptions() {
    const examBodyId = $('#import_exam_body').val();
    const years = [...new Set((importFilterData.exam_years || [])
        .filter(item => !examBodyId || String(item.exam_body_id) === String(examBodyId))
        .map(item => parseInt(item.exam_year, 10))
        .filter(Boolean))]
        .sort((a, b) => b - a);

    let yearHtml = '<option value="">All Years</option>';
    years.forEach(year => {
        yearHtml += `<option value="${year}">${year}</option>`;
    });
    $('#import_exam_year').html(yearHtml);
}

function refreshImportTopicOptions() {
    const subjectId = $('#import_subject_filter').val();
    let topicHtml = '';

    importFilterData.topics.forEach(t => {
        if (!subjectId || String(t.subject_id) === String(subjectId)) {
            topicHtml += `<option value="${t.id}">${escapeImportHtml(t.topic_name)}</option>`;
        }
    });

    $('#import_topic').html(topicHtml);
}

function bindImportFilterEvents() {
    $('#import_source_type').off('change').on('change', function () {
        const type = $(this).val();
        $('#import_dynamic_filter_container').hide();
        $('#import_exam_body_container').hide();
        $('#import_exam_year_container').hide();
        $('#import_topic_container').hide();
        $('#import_soft_filter_container').hide();
        $('#bank-builder-container').hide();

        const $classFilterCol = $('#import_class_filter').closest('.col-md-4');

        if (type === 'Exam bodies') {
            $classFilterCol.hide();
            $('#import_dynamic_filter_container').show();
            $('#import_exam_body_container').show();
            $('#import_exam_year_container').show();
            $('#import_soft_filter_container').show();
            refreshImportExamYearOptions();
        } else if (type === 'Topics') {
            $classFilterCol.show();
            refreshImportTopicOptions();
            $('#import_dynamic_filter_container').show();
            $('#import_topic_container').show();
            $('#import_soft_filter_container').show();
            $('#bank-builder-container').show();
        } else {
            $classFilterCol.show();
        }

        currentImportPage = 1;
        fetchBankQuestions();
    });

    $('#import_subject_filter').off('change').on('change', function () {
        refreshImportTopicOptions();
        currentImportPage = 1;
        fetchBankQuestions();
    });

    $('#import_exam_body').off('change').on('change', function () {
        refreshImportExamYearOptions();
        currentImportPage = 1;
        fetchBankQuestions();
    });

    $('#import_class_filter, #import_exam_year, #import_topic, #import_difficulty, #import_term_tag, #import_question_category, #import_search')
        .off('input change')
        .on('input change', function () {
            currentImportPage = 1;
            fetchBankQuestions();
        });

    $('#build-bank-btn').off('click').on('click', buildFromBank);
}

function selectedClassName() {
    return $('#import_class_filter').val() ? ($('#import_class_filter option:selected').text() || '') : '';
}

function selectedImportTopicIds() {
    const value = $('#import_topic').val();
    if (Array.isArray(value)) {
        return value.filter(Boolean);
    }
    return value ? [value] : [];
}

function fetchBankQuestions() {
    const subject_id = $('#import_subject_filter').val();
    const class_id = $('#import_class_filter').val();
    const source_type = $('#import_source_type').val();
    const exam_body_id = $('#import_exam_body').val();
    const topicIds = selectedImportTopicIds();

    if (!subject_id || !source_type) {
        return;
    }

    if (source_type === 'Local' && !class_id) return;
    if (source_type === 'Exam bodies' && !exam_body_id) return;
    if (source_type === 'Topics' && topicIds.length === 0) return;

    $('#import-questions-list').html('<div class="text-center py-4"><div class="spinner-border text-primary" role="status"></div><p>Fetching questions...</p></div>');

    $.ajax({
        url: '../import_question_controller.php',
        type: 'POST',
        data: {
            action: 'fetch_bank_questions',
            subject_id: subject_id,
            class_id: class_id,
            source_type: source_type,
            exam_body_id: exam_body_id,
            exam_year: $('#import_exam_year').val(),
            topic_id: topicIds[0] || '',
            topic_ids: JSON.stringify(topicIds),
            difficulty: $('#import_difficulty').val(),
            term_tag: $('#import_term_tag').val(),
            question_category: $('#import_question_category').val(),
            search: $('#import_search').val(),
            recommended_class: source_type === 'Topics' ? selectedClassName() : '',
            page: currentImportPage,
            per_page: 5
        },
        success: function (response) {
            try {
                const res = typeof response === 'string' ? JSON.parse(response) : response;
                if (res.status === 'success') {
                    renderImportedQuestionsList(res.data, source_type);
                    renderImportPagination(res.pagination);
                }
            } catch (e) {
                console.error("Error fetching questions", e);
                $('#import-questions-list').html('<div class="alert alert-danger">An error occurred while fetching questions.</div>');
            }
        }
    });
}

function renderImportedQuestionsList(questions, sourceType, checkedByDefault = false) {
    let html = '';
    if (questions.length === 0) {
        html = '<div class="alert alert-info">No questions found matching the selected filters.</div>';
    } else {
        questions.forEach(q => {
            let optionsHtml = '';
            if (q.options && q.options.length > 0) {
                optionsHtml = '<div class="mt-2 pl-3 border-left">';
                q.options.forEach((opt, idx) => {
                    const isChecked = opt.answer == 1 ? 'checked' : '';
                    const optionId = `import_opt_${q.id}_${idx}`;
                    optionsHtml += `
                        <div class="icheck-primary mb-1">
                            <input type="radio" id="${optionId}" name="preview_opt_${q.id}" ${isChecked} onclick="event.preventDefault()">
                            <label for="${optionId}" class="font-weight-normal" style="cursor: default;">
                                <small>${opt.options}</small>
                            </label>
                        </div>`;
                });
                optionsHtml += '</div>';
            }

            const meta = [
                q.difficulty ? escapeImportHtml(q.difficulty) : '',
                q.recommended_class ? `Class: ${escapeImportHtml(q.recommended_class)}` : '',
                q.exam_year > 0 ? `Year: ${escapeImportHtml(q.exam_year)}` : '',
                q.term_tag ? `Term: ${escapeImportHtml(q.term_tag)}` : '',
                q.question_category ? `Category: ${escapeImportHtml(q.question_category)}` : '',
                q.quality_score !== undefined ? `Quality: ${parseInt(q.quality_score, 10) || 0}` : ''
            ].filter(Boolean).join(' | ');

            const feedbackHtml = sourceType === 'Local' ? '' : `
                <div class="mt-2">
                    <button type="button" class="btn btn-xs btn-outline-success bank-feedback-btn" data-id="${q.id}" data-feedback="useful">Useful</button>
                    <button type="button" class="btn btn-xs btn-outline-secondary bank-feedback-btn" data-id="${q.id}" data-feedback="too_easy">Too Easy</button>
                    <button type="button" class="btn btn-xs btn-outline-secondary bank-feedback-btn" data-id="${q.id}" data-feedback="too_hard">Too Hard</button>
                    <button type="button" class="btn btn-xs btn-outline-warning bank-feedback-btn" data-id="${q.id}" data-feedback="wrong_answer">Wrong Answer</button>
                    <button type="button" class="btn btn-xs btn-outline-warning bank-feedback-btn" data-id="${q.id}" data-feedback="poorly_worded">Poorly Worded</button>
                    <button type="button" class="btn btn-xs btn-outline-danger bank-feedback-btn" data-id="${q.id}" data-feedback="not_relevant">Not Relevant</button>
                </div>`;

            html += `
                <div class="card mb-3 shadow-sm question-import-item">
                    <div class="card-body">
                        <div class="d-flex align-items-start">
                            <div class="icheck-primary mr-3 mt-1">
                                <input type="checkbox" id="import_q_${q.id}" class="import-question-checkbox" value="${q.id}" ${checkedByDefault ? 'checked' : ''}>
                                <label for="import_q_${q.id}"></label>
                            </div>
                            <div style="flex-grow: 1; max-height: 250px; overflow-y: auto;">
                                <div>${q.question}</div>
                                <div class="small text-muted mt-2">${meta}</div>
                                ${optionsHtml}
                                ${feedbackHtml}
                            </div>
                        </div>
                    </div>
                </div>`;
        });
    }
    $('#import-questions-list').html(html);
    $('.bank-feedback-btn').off('click').on('click', function () {
        recordBankFeedback($(this).data('id'), $(this).data('feedback'));
    });
}

function recordBankFeedback(questionId, feedbackType) {
    $.post('../question_bank_controller.php', {
        action: 'record_feedback',
        question_id: questionId,
        feedback_type: feedbackType
    }, function (response) {
        const res = typeof response === 'string' ? JSON.parse(response) : response;
        if (res.status === 'success') {
            toastr.success(res.message);
            fetchBankQuestions();
        } else {
            toastr.error(res.message || 'Unable to record feedback.');
        }
    }).fail(function () {
        toastr.error('Server error while recording feedback.');
    });
}

function renderImportPagination(pagination) {
    if (pagination.total_pages <= 1) {
        $('#import-pagination').hide();
        return;
    }

    $('#import-pagination').show();
    $('#import-page-info').text(`Page ${pagination.page} / ${pagination.total_pages}`);

    $('#import-prev-btn').prop('disabled', pagination.page <= 1).off('click').on('click', function () {
        if (currentImportPage > 1) {
            currentImportPage--;
            fetchBankQuestions();
        }
    });

    $('#import-next-btn').prop('disabled', pagination.page >= pagination.total_pages).off('click').on('click', function () {
        if (currentImportPage < pagination.total_pages) {
            currentImportPage++;
            fetchBankQuestions();
        }
    });
}

function importSelectedQuestions() {
    const selectedIds = [];
    $('.import-question-checkbox:checked').each(function () {
        selectedIds.push($(this).val());
    });

    if (selectedIds.length === 0) {
        toastr.warning("Please select at least one question to import.");
        return;
    }

    const source_type = $('#import_source_type').val();
    const $btn = $('#import-submit-btn');
    $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Importing...');

    $.ajax({
        url: '../import_question_controller.php',
        type: 'POST',
        data: {
            action: 'get_questions_details',
            question_ids: selectedIds,
            source_type: source_type
        },
        success: function (response) {
            $btn.prop('disabled', false).html('Import Selected Questions');
            try {
                const res = typeof response === 'string' ? JSON.parse(response) : response;
                if (res.status === 'success') {
                    res.data.forEach(qData => addImportedQuestionToDOM(qData));
                    $('#importQuestionModal').modal('hide');
                    toastr.success(`Successfully imported ${res.data.length} question(s).`);
                }
            } catch (e) {
                console.error("Error importing questions details", e);
                toastr.error("An error occurred while importing the questions.");
            }
        },
        error: function () {
            $btn.prop('disabled', false).html('Import Selected Questions');
            toastr.error("Server error while importing the questions.");
        }
    });
}

function buildFromBank() {
    const subjectId = $('#import_subject_filter').val();
    const topicIds = selectedImportTopicIds();
    const $btn = $('#build-bank-btn');

    if (!subjectId || topicIds.length === 0) {
        toastr.warning('Select a subject and at least one topic before building from the bank.');
        return;
    }

    $btn.prop('disabled', true).html('<span class="spinner-border spinner-border-sm"></span> Building...');
    $.post('../import_question_controller.php', {
        action: 'build_from_bank',
        subject_id: subjectId,
        topic_ids: JSON.stringify(topicIds),
        easy_count: $('#build_easy_count').val(),
        medium_count: $('#build_medium_count').val(),
        hard_count: $('#build_hard_count').val()
    }, function (response) {
        $btn.prop('disabled', false).text('Build Questions');
        try {
            const res = typeof response === 'string' ? JSON.parse(response) : response;
            if (res.status !== 'success') {
                toastr.error(res.message || 'Unable to build from bank.');
                return;
            }
            renderImportedQuestionsList(res.data, 'Topics', true);
            renderImportPagination({ page: 1, total_pages: 1, total_count: res.data.length });
            $('#import-questions-list')[0]?.scrollIntoView({ behavior: 'smooth', block: 'start' });
            toastr.success(`Prepared ${res.data.length} question(s). Review them, then click Import Selected Questions.`);
        } catch (e) {
            toastr.error('Unable to parse bank builder response.');
        }
    }).fail(function () {
        $btn.prop('disabled', false).text('Build Questions');
        toastr.error('Server error while building from bank.');
    });
}

function addImportedQuestionToDOM(qData) {
    let maxNum = 0;
    $('#questions-container .question-block').each(function () {
        const labelText = $(this).find('.form-group > label').first().text().trim();
        const m = labelText.match(/Question\s*(\d+)/i);
        if (m && m[1]) {
            const n = parseInt(m[1], 10);
            if (!isNaN(n) && n > maxNum) maxNum = n;
        }
    });
    const nextNumber = (maxNum > 0) ? maxNum + 1 : ($('.question-block').length + 1);
    const randomId = Math.floor(Math.random() * 1000000);

    let optionsHtml = '';
    for (let i = 0; i < 4; i++) {
        let optText = '';
        let isChecked = '';
        if (qData.options && qData.options[i]) {
            optText = qData.options[i].options || '';
            isChecked = (qData.options[i].answer == 1) ? 'checked' : '';
        }

        optionsHtml += `
            <div class="option-group col-md-6 col-12 mb-3 d-flex align-items-start">
                <div class="icheck-primary d-flex">
                    <input type="radio" id="radio_imported_${randomId}_${i}" name="question_imported_${randomId}" ${isChecked}>
                    <label for="radio_imported_${randomId}_${i}"></label>
                    <textarea class="form-control option-textarea" style="height: 100px">${optText}</textarea>
                </div>
            </div>`;
    }

    const template = `
        <div class="py-3 px-15 bg-white mb-3 question-block" style="border-radius: 10px;">
            <div class="form-group">
                <label>Question ${nextNumber}</label>
                <textarea class="question-textarea form-control" style="height: 200px">${qData.question || ''}</textarea>
            </div>

            <div class="options-container mt-3">
                <div class="form-group">
                    <label>Options</label>
                    <p class="text-muted small">Select the radio button for the correct answer</p>
                    <div class="row">
                        ${optionsHtml}
                    </div>
                </div>
            </div>
            <button type="button" class="btn btn-danger btn-sm mt-2" onclick="$(this).closest('.question-block').remove()">Delete Question</button>
            <button type="button" class="btn btn-outline-success btn-sm mt-2 ml-2 regenerate-question-btn" onclick="openRegenerateQuestionModal(this)">Regenerate with AI</button>
        </div>`;

    $('#questions-container').append(template);

    if (typeof initializeSummernote === 'function') {
        initializeSummernote();
    }
}
