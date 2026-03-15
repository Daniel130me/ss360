/* Import Question Feature JavaScript */

let currentImportPage = 1;

function openImportQuestionModal() {
    $('#importQuestionModal').modal('show');
    loadImportFilters();
    $('#import-questions-list').empty();
    $('#import-pagination').hide();

    // Set default values if Subject and Class are already selected in the main form
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
                const res = JSON.parse(response);
                if (res.status === 'success') {
                    // Populate Subjects
                    let subjectHtml = '<option value="">Select Subject</option>';
                    res.data.subjects.forEach(s => {
                        subjectHtml += `<option value="${s.id}">${s.subject}</option>`;
                    });
                    $('#import_subject_filter').html(subjectHtml);

                    // Populate Classes
                    let classHtml = '<option value="">Select Class</option>';
                    res.data.classes.forEach(c => {
                        classHtml += `<option value="${c.id}">${c.classname}</option>`;
                    });
                    $('#import_class_filter').html(classHtml);

                    // Attach event listener for Source Type
                    $('#import_source_type').off('change').on('change', function () {
                        const type = $(this).val();
                        $('#import_dynamic_filter_container').hide();
                        $('#import_exam_body_container').hide();
                        $('#import_topic_container').hide();
                        
                        const $classFilterCol = $('#import_class_filter').closest('.col-md-4');

                        if (type === 'Exam bodies') {
                            $classFilterCol.hide();
                            let ebHtml = '<option value="">Select Exam Body</option>';
                            res.data.exam_bodies.forEach(e => {
                                ebHtml += `<option value="${e.id}">${e.name}</option>`;
                            });
                            $('#import_exam_body').html(ebHtml);
                            $('#import_dynamic_filter_container').show();
                            $('#import_exam_body_container').show();
                        } else if (type === 'Topics') {
                            $classFilterCol.hide();
                            const subId = $('#import_subject_filter').val();
                            
                            let tHtml = '<option value="">Select Topic</option>';
                            res.data.topics.forEach(t => {
                                if (!subId || t.subject_id == subId) {
                                    tHtml += `<option value="${t.id}">${t.topic_name}</option>`;
                                }
                            });
                            $('#import_topic').html(tHtml);
                            $('#import_dynamic_filter_container').show();
                            $('#import_topic_container').show();
                        } else {
                            $classFilterCol.show();
                        }
                        
                        currentImportPage = 1;
                        fetchBankQuestions();
                    });

                    // Automatically select if the assessment form already has values
                    const mainSubjectId = $("#select_subject_field").val();
                    if (mainSubjectId) $('#import_subject_filter').val(mainSubjectId);

                    // Trigger form change manually
                    $('#import_subject_filter, #import_class_filter, #import_exam_body, #import_topic').off('change').on('change', function () {
                        if ($(this).attr('id') === 'import_subject_filter' || $(this).attr('id') === 'import_class_filter') {
                            if ($('#import_source_type').val() === 'Topics') {
                                $('#import_source_type').trigger('change');
                            }
                        }
                        currentImportPage = 1;
                        fetchBankQuestions();
                    });

                }
            } catch (e) {
                console.error("Error parsing filters", e);
            }
        }
    });
}

function fetchBankQuestions() {
    const subject_id = $('#import_subject_filter').val();
    const class_id = $('#import_class_filter').val();
    const source_type = $('#import_source_type').val();
    const exam_body_id = $('#import_exam_body').val();
    const topic_id = $('#import_topic').val();

    if(!subject_id || !source_type) {
        return; // Don't fetch if minimal criteria are not met
    }
    
    if(source_type === 'Local' && !class_id) return;
    if(source_type === 'Exam bodies' && !exam_body_id) return;
    if(source_type === 'Topics' && !topic_id) return;

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
            topic_id: topic_id,
            page: currentImportPage,
            per_page: 5
        },
        success: function (response) {
            try {
                const res = JSON.parse(response);
                if (res.status === 'success') {
                    renderImportedQuestionsList(res.data);
                    renderImportPagination(res.pagination);
                }
            } catch (e) {
                console.error("Error fetching questions", e);
                $('#import-questions-list').html('<div class="alert alert-danger">An error occurred while fetching questions.</div>');
            }
        }
    });
}

function renderImportedQuestionsList(questions) {
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

            html += `
                <div class="card mb-3 shadow-sm question-import-item">
                    <div class="card-body">
                        <div class="d-flex align-items-start">
                            <div class="icheck-primary mr-3 mt-1">
                                <input type="checkbox" id="import_q_${q.id}" class="import-question-checkbox" value="${q.id}">
                                <label for="import_q_${q.id}"></label>
                            </div>
                            <div style="flex-grow: 1; max-height: 250px; overflow-y: auto;">
                                <div>${q.question}</div>
                                ${optionsHtml}
                            </div>
                        </div>
                    </div>
                </div>
            `;
        });
    }
    $('#import-questions-list').html(html);
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
                const res = JSON.parse(response);
                if (res.status === 'success') {
                    // Add items to DOM
                    res.data.forEach(qData => {
                        addImportedQuestionToDOM(qData);
                    });
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

function addImportedQuestionToDOM(qData) {
    // Determine next question number by scanning existing labels like "Question 6"
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

    // Add padded options if they are fewer than 4 (for consistency)
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
            </div>
        `;
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
        </div>
    `;

    $('#questions-container').append(template);

    // Re-initialize summernote plugins only on uninitialized elements
    if (typeof initializeSummernote === 'function') {
        initializeSummernote();
    }
}
