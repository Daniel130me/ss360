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
                    $('#ai-usage-count').text(res.usage);
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
                        $('#ai-usage-count').text(res.usage);
                        if (res.usage >= 5) {
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

    if (typeof initializeSummernote === 'function') {
        initializeSummernote();
    }
}
