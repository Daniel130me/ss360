// console.log("here");


function setupSecurityFeatures() {
    // Prevent right-click
    document.addEventListener('contextmenu', e => e.preventDefault());

    // Prevent tab switching
    document.addEventListener('visibilitychange', () => {
        if (document.hidden) {
            toastr.warning('Please do not switch tabs during the exam');
        }
    });

    // Prevent keyboard shortcuts
    document.addEventListener('keydown', (e) => {
        if ((e.ctrlKey || e.metaKey) &&
            (e.key === 'c' || e.key === 'v' || e.key === 'a')) {
            e.preventDefault();
        }
    });
    


    // Request fullscreen
    document.documentElement.requestFullscreen().catch(err => {
        toastr.warning('Please allow fullscreen for better experience');
    });
}

function get_all_classes_for_assessment(assess_id) {
    // alert(assess_id)
    $("#assess_classesModal").modal('show');
    // get all classes
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: {
            action: 'get_all_classes_for_assessment',
            assessment_id: assess_id
        },
        success: function(response) {
            let data = JSON.parse(response);
            let classes = data.data;
            let str = '';

            // Create checkboxes without checking them initially
            for (let id in classes) {
                str += `<div class="icheck-gray-dark mb-2">
            <input class="class-checkbox" type="checkbox" value="${id}" id="class_${id}">
            <label for="class_${id}">
                ${classes[id]}
            </label>
        </div>`;
            }
            $('#classes-list').html(str);

            // Update checkboxes based on displayed buttons
            updateModalCheckboxes();
        },
        error: function(xhr, status, error) {
            toastr.error("Error fetching classes");
        }
    });
}

function loadExistingAssessment(assessment_id) {
    $.ajax({
        url: '../controller_new.php',
        type: 'POST',
        data: {
            action: 'load_assessment',
            assessment_id: assessment_id
        },
        success: function(response) {
            // Populate form with existing data
            $('#assessment_instruction').val(response.settings.instruction);
            $('#assessment_duration').val(response.settings.duration);
            $('#set_duration_checkbox').prop('checked', response.settings.duration_set);
            $('#deadline_date').val(response.settings.deadline_date);
            $('#deadline_time').val(response.settings.deadline_time);
            $('#set_deadline_checkbox').prop('checked', response.settings.deadline_Set);
            $('#desired_score').val(response.settings.desired_score);
            $('#round_off_dec').prop('checked', response.settings.round_off_decimal);
            $('[name="ca"][value="' + response.settings.ca_type + '"]').prop('checked', true);
            // Clear existing class buttons and add saved ones
            $('.classes_container').empty();
            // Split the comma-separated class IDs string
            const classIds = response.settings.class_ids.split(',');
            const classNames = response.settings.class_names.split(',');
            
            // For each class, create a button with real name but keep ID as data attribute
            classIds.forEach((classId, index) => {
                let classButton = `
                    <button class="btn btn-sm btn-primary d-flex" onclick="remove_this_class(this)" 
                            data-class-id="${classId.trim()}">
                        <span class="material-symbols-outlined mr-1" style="font-size: 21px;">close</span>
                        ${classNames[index].trim()}
                    </button>`;
                $('.classes_container').append(classButton);
            });


            // Clear existing questions and load saved ones
            $('#questions-container').empty();
            response.questions.forEach(question => {
                addExistingQuestion(question);
            });

            toastr.info('Loaded existing assessment for editing');
        },
        error: function() {
            toastr.error('Error loading assessment data');
        }
    });
}
function checkExistingAssessment() {
    // alert('fh')
    const subject_id = $('#select_subject_field').val();
    const assessment_type = $('.assessment_btn.select_btn.active').data('id');
    const class_ids = Array.from($('.classes_container button')).map(btn => $(btn).data('class-id')).join(',');

    if (!subject_id || !assessment_type || !class_ids) {
        return; // Don't check if any required field is missing
    }

    $.ajax({
        url: '../controller_new.php',
        type: 'POST',
        data: {
            action: 'check_existing_assessment',
            subject_id: subject_id,
            assessment_type: assessment_type,
            class_ids: class_ids,
        },
        success: function(response) {
            if (response.exists) {
                // Store assessment ID for later use
                existingAssessmentId = response.assessment_id;
                // Show confirmation modal
                $('#existingAssessmentModal').modal('show');
            } else {
                existingAssessmentId = null;
                // Show empty form with single question
                showNewAssessmentForm();
                $('.assessment-settings-section, .questions-section').show();
            }
        },
        error: function() {
            toastr.error('Error checking for existing assessment');
        }
    });
}

function handleExistingAssessmentResponse(continueWithExisting) {
    $('#existingAssessmentModal').modal('hide');

    if (continueWithExisting) {
        // Load existing assessment
        loadExistingAssessment(existingAssessmentId);
        $('.assessment-settings-section, .questions-section').show();
    } else {
        // Clear only the assigned classes
        $('.classes_container').empty();
        // Hide assessment sections until new classes are selected
        $('.assessment-settings-section, .questions-section').hide();
        toastr.info('Please select different classes for the new assessment');
    }
}



function showNewAssessmentForm() {
    // Clear form
    $('#assessment_instruction').val('');
    $('#assessment_duration').val('');
    $('#set_duration_checkbox').prop('checked', false);
    $('#deadline_date').val('');
    $('#deadline_time').val('');
    $('#set_deadline_checkbox').prop('checked', false);

    // Clear questions and add single empty question
    $('#questions-container').empty();
    addNewQuestion();

    // toastr.info('Created new assessment form');
}

function addExistingQuestion(questionData) {
    // Similar to addNewQuestion but populates with existing data
    const template = createQuestionTemplate(questionData);
    $('#questions-container').append(template);
    initializeSummernote();
}

function initializeSummernote() {
    $('.question-textarea').summernote({
        height: 150,
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'italic', 'superscript', 'subscript']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['insert', ['link', 'picture', 'table']],
            ['view', ['fullscreen', 'codeview']]
        ]
    });

    $('.option-textarea').summernote({
        height: 100,
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'italic', 'superscript', 'subscript']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['insert', ['link', 'picture']],
            ['view', ['fullscreen', 'codeview']]
        ]
    });
}

function updateModalCheckboxes() {
    // Get all currently displayed class IDs from the buttons
    let displayedClassIds = [];
    $('.classes_container button').each(function() {
        displayedClassIds.push($(this).data('class-id').toString());
    });

    // Update checkboxes in modal
    $('.class-checkbox').each(function() {
        $(this).prop('checked', displayedClassIds.includes($(this).val()));
    });
}
function saveSelectedClasses() {
    // Get all checked checkboxes
    let selectedClasses = [];
    $('.class-checkbox:checked').each(function() {
        selectedClasses.push({
            id: $(this).val(),
            name: $(this).next('label').text().trim()
        });
    });

    if (selectedClasses.length === 0) {
        toastr.warning('Please select at least one class');
        return;
    }

    // Clear existing classes
    $('.classes_container').empty();

    // Add new class buttons
    selectedClasses.forEach(function(classItem) {
        let classButton = `
    <button class="btn btn-sm btn-primary d-flex" onclick="remove_this_class(this)" 
            data-class-id="${classItem.id}">
        <span class="material-symbols-outlined mr-1" style="font-size: 21px;">close</span>
        ${classItem.name}
    </button>`;
        $('.classes_container').append(classButton);
    });

    // Close the modal
    $('#assess_classesModal').modal('hide');
    // toastr.success('Classes assigned successfully');
}
function addNewQuestion() {
    const questionCount = $('.question-block').length + 1;
    const template = `
        <div class="py-3 px-15 bg-white mb-3 question-block" style="border-radius: 10px;">
            <div class="form-group">
                <label>Question ${questionCount}</label>
                <textarea class="question-textarea form-control" style="height: 200px"></textarea>
            </div>

            <div class="options-container mt-3">
                <div class="form-group">
                    <label>Options</label>
                    <p class="text-muted small">Select the radio button for the correct answer</p>
                    <div class="row">
                        ${Array(4).fill().map((_, i) => `
                            <div class="option-group col-md-6 col-12 mb-3 d-flex align-items-start">
                                <div class="icheck-primary d-flex">
                                    <input type="radio" id="radio_new_${questionCount}_${i}" name="question_new_${questionCount}">
                                    <label for="radio_new_${questionCount}_${i}"></label>
                                    <textarea class="form-control option-textarea" style="height: 100px"></textarea>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            </div>
            <button type="button" class="btn btn-danger btn-sm mt-2" onclick="$(this).closest('.question-block').remove()">Delete Question</button>
        </div>
    `;

    $('#questions-container').append(template);
    initializeSummernote();
}
$('#add-question-btn').click(function() {
    addNewQuestion();
});
function confirmRemoveClass() {
    if (classElementToRemove) {
        // Remove the button element from UI
        $(classElementToRemove).remove();
        classElementToRemove = null;
        setTimeout(checkExistingAssessment, 500); // Check for existing assessment after removing class

        // Close the modal
        $('#removeClassModal').modal('hide');

        // Update modal checkboxes if modal is open
        if ($('#assess_classesModal').is(':visible')) {
            updateModalCheckboxes();
        }

        toastr.success('Class removed successfully');
    }
}

function createQuestionTemplate(questionData) {
    const questionCount = $('.question-block').length + 1;
    const questionId = questionData.question.id;
    const questionText = questionData.question.question;
    const options = questionData.options;

    return `
        <div class="py-3 px-15 bg-white mb-3 question-block" style="border-radius: 10px;" data-question-id="${questionId}">
            <div class="form-group">
                <label>Question ${questionCount}</label>
                <textarea class="question-textarea form-control" style="height: 200px">${questionText}</textarea>
            </div>

            <div class="options-container mt-3">
                <div class="form-group">
                    <label>Options</label>
                    <p class="text-muted small">Select the radio button for the correct answer</p>
                    <div class="row">
                        ${options.map((option, index) => `
                            <div class="option-group col-md-6 col-12 mb-3 d-flex align-items-start">
                                <div class="icheck-primary d-flex">
                                    <input type="radio" 
                                        id="radio_${questionId}_${option.id}"
                                        name="question_${questionId}"
                                        ${option.answer == '1' ? 'checked' : ''}>
                                    <label for="radio_${questionId}_${option.id}"></label>
                                    <textarea class="form-control option-textarea" 
                                        data-option-id="${option.id}"
                                        style="height: 100px">${option.options}</textarea>
                                </div>
                            </div>
                        `).join('')}
                    </div>
                </div>
            </div>
            <button type="button" class="btn btn-danger btn-sm mt-2" onclick="deleteQuestion(<?= $qdata['question']['id'] ?>)">Delete Question</button>
        </div>
    `;
}

function deleteQuestion(questionId) {
    if (confirm('Are you sure you want to delete this question?')) {
        $.post('../controller_new.php', {
            action: 'delete_question',
            question_id: questionId
        }, function(response) {
            if (response.success) {
                $(`[data-question-id="${questionId}"]`).remove();
                toastr.success('Question deleted successfully');
            } else {
                toastr.error('Error deleting question');
            }
        });
    }
}

function initExam() {
    // Load question IDs first
    $.ajax({
        url: '../controller_new.php',
        method: 'POST',
        data: {
            action: 'getQuestionIds',
            assessment_id: $('#assessmentId').val()
        },
        success: function (response) {
            questionIds = response.question_ids;
            loadQuestion(1);
            initTimer();
            setupNavigation();
            setupAutoSave();
            setupAnswerHandling();
        },
        error: function () {
            console.error('Failed to load question IDs');
        }
    });
}

function setupSecurityFeatures() {
    // Prevent right-click
    document.addEventListener('contextmenu', e => e.preventDefault());

    // Prevent tab switching
    document.addEventListener('visibilitychange', () => {
        if (document.hidden) {
            toastr.warning('Please do not switch tabs during the exam');
        }
    });

    // Prevent keyboard shortcuts
    document.addEventListener('keydown', (e) => {
        if ((e.ctrlKey || e.metaKey) &&
            (e.key === 'c' || e.key === 'v' || e.key === 'a')) {
            e.preventDefault();
        }
    });

    // Request fullscreen
    document.documentElement.requestFullscreen().catch(err => {
        toastr.warning('Please allow fullscreen for better experience');
    });
}
function saveEntireAssessment() {
    // Validate required fields

    if (!$('#select_subject_field').val()) {
        toastr.error('Please select a subject');
        return;
    }

    if (!$('.assessment_btn.select_btn.active').length) {
        toastr.error('Please select an assessment type');
        return;
    }

    if ($('.classes_container button').length === 0) {
        toastr.error('Please assign at least one class');
        return;
    }

    if ($('.question-block').length === 0) {
        toastr.error('Please add at least one question');
        return;
    }

    let hasError = false;
    $('.question-block').each(function(index) {
        const questionText = $(this).find('.question-textarea').summernote('code');
        const hasCheckedAnswer = $(this).find('input[type="radio"]:checked').length > 0;

        if (!questionText.trim()) {
            toastr.error(`Question ${index + 1} cannot be empty`);
            hasError = true;
            return false;
        }

        if (!hasCheckedAnswer) {
            toastr.error(`Please select correct answer for Question ${index + 1}`);
            hasError = true;
            return false;
        }

        // Validate all options have content
        $(this).find('.option-textarea').each(function(optIndex) {
            if (!$(this).summernote('code').trim()) {
                toastr.error(`Option ${optIndex + 1} in Question ${index + 1} cannot be empty`);
                hasError = true;
                return false;
            }
        });
    });

    if (hasError) return;

    // Collect settings data
    const settingsData = {
        assessment_id: existingAssessmentId,
        subject_id: $('#select_subject_field').val(),
        instruction: $('#assessment_instruction').val(),
        duration_set: $('#set_duration_checkbox').is(':checked') ? 1 : 0,
        duration: $('#assessment_duration').val() || 0,
        deadline_set: $('#set_deadline_checkbox').is(':checked') ? 1 : 0,
        deadline_date: $('#deadline_date').val() || '',
        deadline_time: $('#deadline_time').val() || '',
        desired_score: $('#desired_score').val() || 0,
        round_off_decimal: $('#round_off_dec').is(':checked') ? 1 : 0,
        ca_type: $('[name="ca"]:checked').val() || 0,
        class_ids: Array.from($('.classes_container button')).map(btn => $(btn).data('class-id')).join(','),
        assessment_type: $('.assessment_btn.select_btn.active').data('id')
    };

    // Collect questions data
    const questions = [];
    $('.question-block').each(function() {
        const questionData = {
            id: $(this).data('question-id') || null,
            question: $(this).find('.question-textarea').summernote('code'),
            options: []
        };

        $(this).find('.option-group').each(function() {
            questionData.options.push({
                id: $(this).find('.option-textarea').data('option-id') || null,
                text: $(this).find('.option-textarea').summernote('code'),
                isAnswer: $(this).find('input[type="radio"]').is(':checked')
            });
        });

        questions.push(questionData);
    });

    // Show loading state
    const saveBtn = $('.btn-primary:contains("Save Assessment")');
    const originalText = saveBtn.text();
    saveBtn.prop('disabled', true).text('Saving...');

    // Send to server
    $.ajax({
        url: '../controller_new.php',
        type: 'POST',
        data: {
            action: 'save_update_entire_assessment',
            settings: JSON.stringify(settingsData),
            questions: JSON.stringify(questions)
        },
        success: function(response) {
                // console.log(response);
            if (response.success) {
                toastr.success(response.message);
                if (response.assessment_id) {
                    existingAssessmentId = response.assessment_id;
                }
                // setTimeout(() => {
                //     window.location.href = 'assessment';
                // }, 1500);
            } else {
                toastr.error(response.message || 'Error saving assessment');
            }
        },
        error: function() {
            toastr.error('Network error occurred');
        },
        complete: function() {
            saveBtn.prop('disabled', false).text(originalText);
        }
    });
}
function saveExamProgress() {
    $.ajax({
        url: '../save_exam_progress.php',
        method: 'POST',
        data: {
            assessment_id: $('#assessmentId').val(),
            time_remaining: timeLeft,
            last_question: currentQuestion,
            answers: JSON.stringify(answers),
            flagged_questions: JSON.stringify(flaggedQuestions)
        },
        success: function (response) {
            if (response.success) {
                console.log('Progress saved');
            } else {
                toastr.error('Failed to save progress');
            }
        },
        error: function () {
            toastr.error('Failed to save progress');
        }
    });
}

function initTimer() {
    $.ajax({
        url: '../get_attempt_status.php',
        method: 'POST',
        data: {
            assessment_id: $('#assessmentId').val()
        },
        success: function (response) {
            if (response.success) {
                timeLeft = parseInt(response.time_remaining);
                currentQuestion = parseInt(response.last_question) || 1;

                if (response.answers) {
                    answers = JSON.parse(response.answers);
                }
                if (response.flagged_questions) {
                    flaggedQuestions = JSON.parse(response.flagged_questions);
                }

                loadQuestion(currentQuestion);
                startTimer();
                updateNavigationPanel();
            } else {
                toastr.error('Assessment expired');
                processSubmission()
            }
        },
        error: function () {
            toastr.error('Failed to load exam status');
        }
    });
}

function startTimer() {
    const timerInterval = setInterval(() => {
        timeLeft--;
        updateTimer();

        // Save progress every 10 seconds
        if (timeLeft % 10 === 0) {
            saveExamProgress();
        }

        // Check if time expired
        if (timeLeft <= 0) {
            clearInterval(timerInterval);
            submitExam(true); // Auto-submit
        }
    }, 1000);
}

function updateTimer() {
    const hours = Math.floor(timeLeft / 3600);
    const minutes = Math.floor((timeLeft % 3600) / 60);
    const seconds = timeLeft % 60;

    const formattedTime = [
        hours > 0 ? hours : null,
        minutes.toString().padStart(2, '0'),
        seconds.toString().padStart(2, '0')
    ]
        .filter(x => x !== null)
        .join(':');

    document.getElementById('timer').textContent = formattedTime;
}

function remove_this_class(element) {
    classElementToRemove = element;
    $('#removeClassModal').modal('show');
}

function loadQuestion(num) {
    if (num < 1 || num > totalQuestions) {
        toastr.warning("You have reached the end of the questions.");
        return;
    }

    currentQuestion = num;

    $.ajax({
        type: 'POST',
        url: '../get_question.php',
        data: {
            assessment_id: document.getElementById('assessmentId').value,
            question_num: num
        },
        success: function (response) {
            displayQuestion(response);
            updateNavigationPanel();

            // Update flag button appearance
            if (flaggedQuestions.includes(response.id)) {
                $('#flagBtn').removeClass('btn-info').addClass('btn-warning').text('Unflag Question');
            } else {
                $('#flagBtn').removeClass('btn-warning').addClass('btn-info').text('Flag Question');
            }
        }
    });
}

let optionsSeed = null;

function displayQuestion(questionData) {
    const container = document.getElementById('questionContainer');
    const savedAnswer = answers[questionData.id];

    // Get or create attempt seed from sessionStorage
    let attemptSeed = sessionStorage.getItem('examAttemptSeed');
    if (!attemptSeed) {
        // Create a new seed based on student ID, assessment ID and timestamp
        const studentId = document.querySelector('[data-student-id]')?.dataset.studentId || '';
        const assessmentId = document.getElementById('assessmentId').value;
        attemptSeed = studentId + assessmentId + Date.now();
        sessionStorage.setItem('examAttemptSeed', attemptSeed);
    }

    // Use seeded random number generator
    const seededShuffle = (array, seed) => {
        // Improved LCG parameters
        const a = 1664525;
        const c = 1013904223;
        const m = Math.pow(2, 32);

        let rand = seed;
        let shuffled = array.slice();
        for (let i = shuffled.length - 1; i > 0; i--) {
            rand = (a * rand + c) % m;
            const j = Math.floor(rand % (i + 1));
            [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
        }
        return shuffled;
    };

    // Use the attemptSeed directly for shuffling options
    const randomizedOptions = seededShuffle(
        questionData.options.map((opt, index) => ({ ...opt, originalIndex: index })),
        parseInt(attemptSeed.slice(-8), 16) // Use the last 8 characters of the seed
    );

    container.innerHTML = `
        <div data-question-id="${questionData.id}">
            <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 style="font-weight:200;">Question ${currentQuestion}</h4>
            <button class="btn btn-warning" id="submit-btn" onclick="submitExam()">Submit</button>
            </div>
            <p>${questionData.question}</p>
            <div class="options d-flex flex-column">
                ${randomizedOptions.map(opt => `
                    <div class="icheck-gray-dark" style="width: 100%; background-color: white;">
                        <input type="radio" id="option${opt.originalIndex}" class="form-check-input" 
                               name="answer" value="${opt.id}" 
                               ${savedAnswer === opt.id.toString() ? 'checked' : ''}>
                        <label style="width: 100%; padding: 15px; margin-left: 10px;" for="option${opt.originalIndex}" class="form-check-label">${opt.text}</label>
                        ${opt.image ? `<img src="${opt.image}" class="option-image">` : ''}
                    </div>

                `).join('')}
            </div>
        </div>
    `;
}

function setupNavigation() {
    const prevBtn = document.getElementById('prevBtn');
    const nextBtn = document.getElementById('nextBtn');
    const flagBtn = document.getElementById('flagBtn');

    if (prevBtn) {
        prevBtn.onclick = () => {
            if (currentQuestion > 1) loadQuestion(--currentQuestion);
        };
    }

    if (nextBtn) {
        nextBtn.onclick = () => {
            if (currentQuestion < totalQuestions) {
                loadQuestion(++currentQuestion);
            } else {
                alert('end of question');
            }
        };
    }

    if (flagBtn) {
        flagBtn.onclick = toggleFlagQuestion;
    }
}

function toggle_assessment_btn(event) {
    $(".assessment_btn.select_btn").removeClass("active")
    $(event).addClass("active")
}

function setupAutoSave() {
    autoSaveInterval = setInterval(saveProgress, 30 * 1000); // Every 30 seconds
}

function saveProgress() {
    console.log('Saving progress:', {
        assessment_id: $('#assessmentId').val(),
        answers: answers,
        flaggedQuestions: flaggedQuestions
    });

    $.ajax({
        url: '../save_progress.php',
        method: 'POST',
        data: {
            assessment_id: $('#assessmentId').val(),
            answers: JSON.stringify(answers),
            flagged: JSON.stringify(flaggedQuestions)

        },
        success: function (response) {
            if (response.success) {
                toastr.success('Progress saved');
            } else {
                toastr.error('Error saving progress');
            }
        },
        error: function () {
            toastr.error('Failed to save progress');
        }
    });
}

function submitExam(isAutoSubmit = false) {
    if (isAutoSubmit) {
        processSubmission();
    } else {
        $('#submitConfirmModal').modal('show');
    }
}

function processSubmission() {
    clearInterval(autoSaveInterval);

    $.ajax({
        url: '../submit_assessment.php',
        method: 'POST',
        data: {
            assessment_id: $('#assessmentId').val(),
            answers: JSON.stringify(answers),
            time_remaining: timeLeft
        },
        success: function (response) {
            if (response.success) {
                // Update attempt status
                $.ajax({
                    url: '../update_attempt_status.php',
                    method: 'POST',
                    data: {
                        assessment_id: $('#assessmentId').val(),
                        status: 'completed'
                    }
                });
                window.location.href = 'assessment_status?id=' + $('#assessmentId').val() + '&type=completed';
            } else {
                toastr.error('Failed to submit assessment: ' + response.message);
            }
        },
        error: function () {
            toastr.error('Network error occurred. Please try again.');
        }
    });
}

function handleTimeExpired() {
    $.ajax({
        url: '../update_attempt_status.php',
        method: 'POST',
        data: {
            assessment_id: $('#assessmentId').val(),
            status: 'expired'
        }
    });
    processSubmission();
}

function updateNavigationPanel() {
    const questionNav = $('#questionNav');
    questionNav.empty();

    for (let i = 1; i <= totalQuestions; i++) {
        let btnClass = 'btn-default';
        if (i === currentQuestion) {
            btnClass = 'current';
        }

        // Get the question ID for the current question number from questionIds
        const questionId = questionIds[i - 1]; // Adjust index because arrays are 0-based

        // Check if the question ID exists in the answers object
        if (questionId && answers[questionId]) {
            btnClass = 'btn-primary answered';
        }

        if (flaggedQuestions.includes(i)) {
            btnClass += ' flagged';
        }

        const btn = $(`<button class="btn ${btnClass}" onclick="loadQuestion(${i})">${i}</button>`);
        questionNav.append(btn);
    }
}

function toggleFlagQuestion() {
    // Get the current question ID
    let questionId = null;
    let questionElement = $(`#questionContainer [data-question-id]`);
    if (questionElement.length > 0) {
        questionId = questionElement.data('question-id');
    }

    if (questionId) {
        const index = flaggedQuestions.indexOf(parseInt(currentQuestion));
        if (index > -1) {
            flaggedQuestions.splice(index, 1);
            $('#flagBtn').removeClass('btn-warning').addClass('btn-info').text('Flag Question');
        } else {
            flaggedQuestions.push(parseInt(currentQuestion));
            $('#flagBtn').removeClass('btn-info').addClass('btn-warning').text('Unflag Question');
        }
        updateNavigationPanel();

        // Auto-save when flagging changes
        saveProgress();
    }
}

function setupAnswerHandling() {
    // Handle answer selection
    $(document).on('change', 'input[name="answer"]', function () {
        const selectedValue = $(this).val();
        const questionId = $(this).closest('[data-question-id]').data('question-id'); // Get the real question ID
        answers[questionId] = selectedValue; // Use the real question ID as the key
        updateNavigationPanel();
        saveProgress();
    });
}
function showNotification(message) {
    toastr.success(message);
}