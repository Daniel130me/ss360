function openAIGeneratorModal() {
    // Initialize summernote on the topic textarea if not already initialized
    if (!$('#ai_topic').data('summernote-initialized')) {
        $('#ai_topic').summernote({
            height: 150,
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'underline', 'italic', 'superscript', 'subscript']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['insert', ['link', 'picture', 'mathquill']],
                ['view', ['fullscreen', 'codeview']]
            ],
            buttons: typeof _mathquill_loader !== 'undefined' && _mathquill_loader.initialized ? { mathquill: 'mathquill' } : {}
        });
        $('#ai_topic').data('summernote-initialized', true);
    }
    
    // Clear and reset the modal values
    $('#ai_topic').summernote('code', '');
    $('#ai_difficulty').val('Medium');
    $('#ai_num_questions').val(3);
    // Fetch and display current usage
    $.ajax({
        url: '../ai_question_generator_controller.php',
        type: 'POST',
        data: { action: 'get_usage_count' },
        success: function(response) {
            try {
                const res = JSON.parse(response);
                if (res.status === 'success') {
                    updateAIUsageBadge(res.usage, res.limit, res.remaining);
                    $('#ai-usage-display').show();
                    
                    if (res.usage >= res.limit) {
                        $('#ai-usage-display').removeClass('badge-info').addClass('badge-danger');
                        $('#ai-generate-btn').prop('disabled', true).text('Limit Reached');
                    } else {
                        $('#ai-usage-display').removeClass('badge-danger').addClass('badge-info');
                        $('#ai-generate-btn').prop('disabled', false).text('Generate');
                    }
                }
            } catch (e) {
                console.error("Failed to parse checking limit.", e);
            }
        }
    });

    $('#aiQuestionGeneratorModal').modal('show');
}

function updateAIUsageBadge(usage, limit, remaining) {
    const safeUsage = parseInt(usage, 10) || 0;
    const safeLimit = parseInt(limit, 10) || 0;
    const safeRemaining = remaining !== undefined ? (parseInt(remaining, 10) || 0) : Math.max(0, safeLimit - safeUsage);

    $('#ai-usage-count').text(safeUsage);
    $('#ai-usage-limit').text(safeLimit);
    $('#ai-usage-remaining').text(safeRemaining);
}

let aiRegenerateTargetBlock = null;

function getRichTextareaHtml($textarea) {
    try {
        if ($textarea.next('.note-editor').length) {
            return $textarea.summernote('code');
        }
    } catch (e) {
        // Fall back to the raw textarea value when Summernote is not active.
    }
    return $textarea.val() || '';
}

function setRichTextareaHtml($textarea, html) {
    try {
        if ($textarea.next('.note-editor').length) {
            $textarea.summernote('code', html);
            return;
        }
    } catch (e) {
        // Fall back to direct textarea assignment when Summernote is not active.
    }
    $textarea.val(html);
}

function getQuestionBlockHtml($block) {
    return getRichTextareaHtml($block.find('.question-textarea').first());
}

function setQuestionBlockHtml($block, html) {
    setRichTextareaHtml($block.find('.question-textarea').first(), html);
}

function getAssessmentSubjectLabel() {
    const $subjectField = $('#select_subject_field');
    if ($subjectField.is('select')) {
        const selectedText = $subjectField.find('option:selected').text().trim();
        if (selectedText && selectedText.toLowerCase() !== 'select subject') {
            return selectedText;
        }
    }

    const importSubjectText = $('#import_subject_filter option:selected').text().trim();
    if (importSubjectText && importSubjectText.toLowerCase() !== 'select subject') {
        return importSubjectText;
    }

    return '';
}

function collectRegenerateContext($block) {
    const questionHtml = getQuestionBlockHtml($block);
    const subjectLabel = getAssessmentSubjectLabel();
    const optionLines = [];
    $block.find('.option-group').each(function (index) {
        const letter = String.fromCharCode(65 + index);
        const optionHtml = getRichTextareaHtml($(this).find('.option-textarea').first());
        const optionText = $('<div>').html(optionHtml).text().trim() || optionHtml;
        const isCorrect = $(this).find('input[type="radio"]').is(':checked') ? ' (correct)' : '';
        optionLines.push(`${letter}. ${optionText}${isCorrect}`);
    });

    return `Assessment subject: ${subjectLabel || 'Use the current assessment subject'}\n\nCurrent question:\n${$('<div>').html(questionHtml).text().trim() || questionHtml}\n\nCurrent options:\n${optionLines.join('\n')}\n\nRewrite instruction:\nRegenerate this question while keeping the same subject and general assessment purpose.`;
}

function openRegenerateQuestionModal(button) {
    aiRegenerateTargetBlock = $(button).closest('.question-block');
    if (!aiRegenerateTargetBlock.length) {
        toastr.error('Could not find the question to regenerate.');
        return;
    }

    if (!$('#ai_regenerate_context').data('summernote-initialized')) {
        $('#ai_regenerate_context').summernote({
            height: 180,
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'underline', 'italic', 'superscript', 'subscript']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['insert', ['link', 'picture', 'mathquill']],
                ['view', ['fullscreen', 'codeview']]
            ],
            buttons: typeof _mathquill_loader !== 'undefined' && _mathquill_loader.initialized ? { mathquill: 'mathquill' } : {}
        });
        $('#ai_regenerate_context').data('summernote-initialized', true);
    }

    $('#ai_regenerate_context').summernote('code', $('<div>').text(collectRegenerateContext(aiRegenerateTargetBlock)).html().replace(/\n/g, '<br>'));
    $('#ai_regenerate_difficulty').val('Medium');
    $('#ai-regenerate-loading-indicator').hide();
    $('#ai-regenerate-btn').prop('disabled', false).text('Regenerate');
    $('#aiRegenerateQuestionModal').modal('show');
}

function generateQuestionsWithAI() {
    // Get the HTML content from Summernote
    const topicHTML = $('#ai_topic').summernote('code').trim();
    const difficulty = $('#ai_difficulty').val();
    const num_questions = parseInt($('#ai_num_questions').val());

    // Basic check to see if topic is truly empty 
    const plainTextTopic = $('<div>').html(topicHTML).text().trim();
    if (!plainTextTopic && topicHTML.indexOf('<img') === -1 && topicHTML.indexOf('math-editor-rendered') === -1) {
        toastr.warning('Please enter a topic or context.');
        return;
    }
    if (isNaN(num_questions) || num_questions < 1 || num_questions > 5) {
        toastr.warning('Number of questions must be between 1 and 5.');
        return;
    }

    // Initialize Turndown 
    const turndownService = new TurndownService();
    
    // Add custom rule to preserve MathQuill latex spans natively as HTML
    turndownService.addRule('mathquill', {
        filter: function (node) {
            return node.nodeName === 'SPAN' && node.className.indexOf('math-editor-rendered') !== -1;
        },
        replacement: function (content, node) {
            return node.outerHTML; // Keep the strict data-latex span syntax intact
        }
    });

    const markdownTopic = turndownService.turndown(topicHTML);

    $('#ai-loading-indicator').show();
    $('#ai-generate-btn').prop('disabled', true).text('Generating...');

    $.ajax({
        url: '../ai_question_generator_controller.php',
        type: 'POST',
        data: {
            action: 'generate_questions',
            topic: markdownTopic, // Send markdown payload to save tokens
            difficulty: difficulty,
            num_questions: num_questions
        },
        success: function (response) {
            $('#ai-loading-indicator').hide();
            $('#ai-generate-btn').prop('disabled', false).text('Generate');
            try {
                const res = JSON.parse(response);
                if (res.status === 'success') {
                    res.data.forEach(qData => {
                        addAIGeneratedQuestionToDOM(qData);
                    });
                    
                    // Update usage if provided in response
                    if (res.usage !== undefined) {
                        updateAIUsageBadge(res.usage, res.limit, res.remaining);
                        if (res.usage >= res.limit) {
                            $('#ai-usage-display').removeClass('badge-info').addClass('badge-danger');
                            $('#ai-generate-btn').prop('disabled', true).text('Limit Reached');
                        }
                    }
                    
                    $('#aiQuestionGeneratorModal').modal('hide');
                    toastr.success(`Successfully generated ${res.data.length} question(s).`);
                } else {
                    toastr.error(res.message || "Failed to generate questions.");
                }
            } catch (e) {
                console.error("Error parsing AI response", e);
                toastr.error("An error occurred while parsing the AI response.");
            }
        },
        error: function () {
            $('#ai-loading-indicator').hide();
            $('#ai-generate-btn').prop('disabled', false).text('Generate');
            toastr.error("Server error while communicating with AI provider.");
        }
    });
}

function regenerateCurrentQuestionWithAI() {
    if (!aiRegenerateTargetBlock || !aiRegenerateTargetBlock.length) {
        toastr.error('Select a question to regenerate.');
        return;
    }

    const contextHTML = $('#ai_regenerate_context').summernote('code').trim();
    const plainTextContext = $('<div>').html(contextHTML).text().trim();
    if (!plainTextContext && contextHTML.indexOf('<img') === -1 && contextHTML.indexOf('math-editor-rendered') === -1) {
        toastr.warning('Please enter rewrite context for this question.');
        return;
    }

    const turndownService = new TurndownService();
    turndownService.addRule('mathquill', {
        filter: function (node) {
            return node.nodeName === 'SPAN' && node.className.indexOf('math-editor-rendered') !== -1;
        },
        replacement: function (content, node) {
            return node.outerHTML;
        }
    });

    $('#ai-regenerate-loading-indicator').show();
    $('#ai-regenerate-btn').prop('disabled', true).text('Regenerating...');

    $.ajax({
        url: '../ai_question_generator_controller.php',
        type: 'POST',
        data: {
            action: 'regenerate_question',
            context: turndownService.turndown(contextHTML),
            difficulty: $('#ai_regenerate_difficulty').val(),
            subject_id: $('#select_subject_field').val() || $('#import_subject_filter').val() || ''
        },
        success: function (response) {
            $('#ai-regenerate-loading-indicator').hide();
            $('#ai-regenerate-btn').prop('disabled', false).text('Regenerate');
            try {
                const res = typeof response === 'string' ? JSON.parse(response) : response;
                if (res.status !== 'success') {
                    toastr.error(res.message || 'Failed to regenerate question.');
                    return;
                }

                replaceQuestionBlockWithAI(aiRegenerateTargetBlock, res.data);
                if (res.usage !== undefined) {
                    updateAIUsageBadge(res.usage, res.limit, res.remaining);
                }
                $('#aiRegenerateQuestionModal').modal('hide');
                toastr.success('Question regenerated. Review it before saving.');
            } catch (e) {
                console.error('Error parsing regenerate response', e);
                toastr.error('An error occurred while parsing the regenerated question.');
            }
        },
        error: function () {
            $('#ai-regenerate-loading-indicator').hide();
            $('#ai-regenerate-btn').prop('disabled', false).text('Regenerate');
            toastr.error('Server error while regenerating the question.');
        }
    });
}

function replaceQuestionBlockWithAI($block, qData) {
    setQuestionBlockHtml($block, qData.question || '');
    const randomId = Math.floor(Math.random() * 1000000);

    $block.find('.option-group').each(function (index) {
        const option = qData.options && qData.options[index] ? qData.options[index] : null;
        const optionText = option ? (option.text || option.options || '') : '';
        const isCorrect = option && (option.is_correct === true || option.is_correct === 'true' || option.answer == 1);
        const radioId = `radio_regen_${randomId}_${index}`;
        const $group = $(this);
        const $radio = $group.find('input[type="radio"]');
        $radio.attr('id', radioId).prop('checked', !!isCorrect);
        $group.find('label').first().attr('for', radioId);
        setRichTextareaHtml($group.find('.option-textarea').first(), optionText);
    });

    $block.addClass('border border-success');
    if (typeof markDirty === 'function') {
        markDirty();
    }
}

function addAIGeneratedQuestionToDOM(qData) {
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
            optText = qData.options[i].text || qData.options[i].options || '';
            isChecked = (qData.options[i].is_correct === true || qData.options[i].is_correct === "true" || qData.options[i].answer == 1) ? 'checked' : '';
        }

        optionsHtml += `
            <div class="option-group col-md-6 col-12 mb-3 d-flex align-items-start">
                <div class="icheck-primary d-flex">
                    <input type="radio" id="radio_ai_${randomId}_${i}" name="question_ai_${randomId}" ${isChecked}>
                    <label for="radio_ai_${randomId}_${i}"></label>
                    <textarea class="form-control option-textarea" style="height: 100px">${escapeAssessmentTextareaValue(optText)}</textarea>
                </div>
            </div>
        `;
    }

    const template = `
        <div class="py-3 px-15 bg-white mb-3 question-block" style="border-radius: 10px;">
            <div class="form-group">
                <label>Question ${nextNumber}</label>
                <textarea class="question-textarea form-control" style="height: 200px">${escapeAssessmentTextareaValue(qData.question)}</textarea>
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
            <button type="button" class="btn btn-danger btn-sm mt-2" onclick="removeAssessmentQuestion(this)">Delete Question</button>
            <button type="button" class="btn btn-outline-success btn-sm mt-2 ml-2 regenerate-question-btn" onclick="openRegenerateQuestionModal(this)">Regenerate with AI</button>
        </div>
    `;

    $('#questions-container').append(template);

    if (typeof initializeSummernote === 'function') {
        initializeSummernote();
    }
    if (typeof markDirty === 'function') markDirty();
}
