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
    success: function (response) {
      let data = response;
      // let data = JSON.parse(response);
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
    error: function (xhr, status, error) {
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
    success: function (response) {
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
    error: function () {
      toastr.error('Error loading assessment data');
    }
  });
}
function checkExistingAssessment() {
  //   alert('fh')
  const subject_id = $("#select_subject_field").val();
  const assessment_type = $(".assessment_btn.select_btn.active").data("id");
  const term = $(".term_btn.select_btn.active").data("id");
  const class_ids = Array.from($(".classes_container button"))
    .map((btn) => $(btn).data("class-id"))
    .join(",");

  if (!subject_id || !assessment_type || !term || !class_ids) {
    return; // Don't check if any required field is missing
  }

  $.ajax({
    url: "../controller_new.php",
    type: "POST",
    data: {
      action: "check_existing_assessment",
      subject_id: subject_id,
      assessment_type: assessment_type,
      term: term,
      class_ids: class_ids,
    },
    success: function (response) {
      if (response.exists) {
        // Store assessment ID for later use
        existingAssessmentId = response.assessment_id;
        // Show confirmation modal
        $("#existingAssessmentModal").modal("show");
      } else {
        existingAssessmentId = null;
        // Show empty form with single question
        showNewAssessmentForm();
        $(".assessment-settings-section, .questions-section").show();
      }
    },
    error: function () {
      toastr.error("Error checking for existing assessment");
    },
  });
}

function handleExistingAssessmentResponse(continueWithExisting) {
  $("#existingAssessmentModal").modal("hide");

  if (continueWithExisting) {
    // Load existing assessment
    loadExistingAssessment(existingAssessmentId);
    $(".assessment-settings-section, .questions-section").show();
  } else {
    // Clear only the assigned classes
    $(".classes_container").empty();
    // Hide assessment sections until new classes are selected
    $(".assessment-settings-section, .questions-section").hide();
    toastr.info("Please select different classes for the new assessment");
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

  toastr.info('Created new assessment form');
}

function addExistingQuestion(questionData) {
  // Similar to addNewQuestion but populates with existing data
  const template = createQuestionTemplate(questionData);
  $('#questions-container').append(template);
  initializeSummernote();
}
// --- MathQuill + Summernote integration helpers ---
var _mathquill_loader = {
  loaded: false,
  initialized: false,
  MQ: null
};

function loadMathQuillResources(callback) {
  if (_mathquill_loader.loaded) {
    if (callback) callback();
    return;
  }

  // Add CSS
  var link = document.createElement('link');
  link.rel = 'stylesheet';
  link.href = 'https://cdnjs.cloudflare.com/ajax/libs/mathquill/0.10.1/mathquill.min.css';
  document.head.appendChild(link);

  // Add script
  var script = document.createElement('script');
  script.src = 'https://cdnjs.cloudflare.com/ajax/libs/mathquill/0.10.1/mathquill.min.js';
  script.onload = function () {
    try {
      _mathquill_loader.MQ = MathQuill.getInterface(2);
    } catch (e) {
      console.warn('MathQuill loaded but interface init failed', e);
    }
    _mathquill_loader.loaded = true;
    if (callback) callback();
  };
  script.onerror = function () {
    console.warn('Failed to load MathQuill script');
    if (callback) callback();
  };
  document.head.appendChild(script);
}

function renderEquationsIn($editable) {
  if (!$editable || $editable.length === 0) return;
  // Only proceed if MathQuill is available
  if (!_mathquill_loader.loaded || !_mathquill_loader.MQ) return;

  $editable.find('span.math-editor-rendered').each(function () {
    var $span = $(this);
    var latex = $span.attr('data-latex') || '';
    if (!latex) return; // nothing to render

    // Always re-render from data-latex to normalize display (clear any saved MathQuill DOM)
    try {
      // Ensure the span is visible and treated as a block for MathQuill
      try { $span.css({ display: 'inline-block', margin: '0 4px', 'line-height': '1.2', 'vertical-align': 'middle' }); } catch (e) { }
      // Clear existing nested MathQuill DOM if present
      $span.empty();
      var mq = _mathquill_loader.MQ.StaticMath($span[0]);
      mq.latex(latex);
    } catch (e) {
      // If render fails, log and leave the existing content
      console.warn('MathQuill render failed for latex="' + latex + '"', e);
    }
  });
}

function handleEditEquation($target) {
  if (!$target || $target.length === 0) return;
  // Trigger the modal provided by the plugin by setting the global target
  window.__summernoteMathEditTarget = $target;
  $('#mathQuillModal').modal('show');
}

// Register Summernote plugin once (safe to call multiple times)
// function ensureMathQuillPluginRegistered() {
//     if (_mathquill_loader.initialized) return;
//     _mathquill_loader.initialized = true;

//     // $.extend($.summernote.plugins, {
//     //     'mathquill': function(context) {
//     //         var ui = $.summernote.ui;
//     //         var self = this;
//     //         var mathFieldInstance = null;

//     //         self.createModal = function() {
//     //             var modalId = 'mathQuillModal';
//     //             if ($('#' + modalId).length === 0) {
//     //                 var modalHtml = '\n                        <div class="modal fade" id="' + modalId + '" tabindex="-1" role="dialog" aria-hidden="true">\n                            <div class="modal-dialog modal-lg" role="document">\n                                <div class="modal-content">\n                                    <div class="modal-header bg-primary text-white">\n                                        <h5 class="modal-title">Insert/Edit Equation</h5>\n                                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">\n                                            <span aria-hidden="true">&times;</span>\n                                        </button>\n                                    </div>\n                                    <div class="modal-body">\n                                        <p class="text-muted small">Type your LaTeX equation below:</p>\n                                        <div id="math-input-field" class="mathquill-editable" style="min-height:50px;font-size:18px;padding:6px;border:1px solid #e5e7eb;border-radius:4px;background:#fff"></div>\n                                        <div class="mt-3">\n                                            <small class="text-muted">Live LaTeX:</small> <code id="latex-output" style="display:block;white-space:pre-wrap;margin-top:6px"></code>\n                                        </div>\n                                    </div>\n                                    <div class="modal-footer">\n                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>\n                                        <button type="button" id="insert-equation-btn" class="btn btn-primary">Insert/Update</button>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                    ';
//     //                 $('body').append(modalHtml);
//     //             }
//     //         };

//     //         self.initialize = function() {
//     //             self.createModal();

//     //             $('#mathQuillModal').on('shown.bs.modal', function() {
//     //                 // Ensure MathQuill resources are loaded
//     //                 loadMathQuillResources(function() {
//     //                     var $inputField = $('#math-input-field');
//     //                     if (mathFieldInstance) {
//     //                         try { mathFieldInstance.revert(); } catch (e) {}
//     //                         mathFieldInstance = null;
//     //                     }
//     //                     $inputField.empty();
//     //                     if (_mathquill_loader.MQ) {
//     //                         mathFieldInstance = _mathquill_loader.MQ.MathField($inputField[0], {
//     //                             spaceBehavesLikeTab: true,
//     //                             handlers: {
//     //                                 edit: function() {
//     //                                     try { $('#latex-output').text(mathFieldInstance.latex()); } catch (e) {}
//     //                                 }
//     //                             }
//     //                         });

//     //                         // expose the current field globally for the insert handler
//     //                         try { window.__summernoteMathCurrentField = mathFieldInstance; } catch (e) {}

//     //                         // If there is a target being edited, load its latex
//     //                         var $target = window.__summernoteMathEditTarget || null;
//     //                         if ($target && $target.length) {
//     //                             var latex = $target.attr('data-latex') || '';
//     //                             try { mathFieldInstance.latex(latex); } catch (e) {}
//     //                         } else {
//     //                             try { mathFieldInstance.latex(''); } catch (e) {}
//     //                         }

//     //                         try { $('#latex-output').text(mathFieldInstance.latex()); } catch (e) {}
//     //                         mathFieldInstance.focus();
//     //                     }
//     //                 });
//     //             });

//     //             $('#mathQuillModal').on('hidden.bs.modal', function() {
//     //                 // Clear edit target
//     //                 window.__summernoteMathEditTarget = null;
//     //                 // Clear current math field reference
//     //                 try { window.__summernoteMathCurrentField = null; } catch (e) {}
//     //             });

//     //             // Insert/update button: register once globally to avoid multiple handlers and ensure target editor
//     //             if (!window.__summernoteMathInsertHandlerRegistered) {
//     //                 window.__summernoteMathInsertHandlerRegistered = true;
//     //                 $(document).on('click', '#insert-equation-btn', function() {
//     //                     // The mathFieldInstance used inside shown.bs.modal is stored on window for cross-scope access
//     //                     var mathField = window.__summernoteMathCurrentField || mathFieldInstance || null;
//     //                     if (!mathField) { $('#mathQuillModal').modal('hide'); return; }
//     //                     var latex = '';
//     //                     try { latex = mathField.latex(); } catch (e) { latex = ''; }
//     //                     if (!latex) { $('#mathQuillModal').modal('hide'); return; }

//     //                     var $target = window.__summernoteMathEditTarget || null;
//     //                     // If an explicit editable was stored when opening modal, prefer that as the insertion target
//     //                     var editableElem = window.__summernoteMathEditorEditable || null;
//     //                     if ($target && $target.length) {
//     //                         $target.attr('data-latex', latex);
//     //                         $target.empty();
//     //                         var $editable = $target.closest('.note-editable');
//     //                         renderEquationsIn($editable);
//     //                     } else if (editableElem) {
//     //                         try {
//     //                             var nodeHtml = '<span contenteditable="false" class="math-editor-rendered" data-latex="' + latex.replace(/"/g,'&quot;') + '"></span>';
//     //                             // insert directly into the editable DOM
//     //                             $(editableElem).append(nodeHtml);
//     //                             renderEquationsIn($(editableElem));
//     //                         } catch (e) {
//     //                             // fall through to context-based insertion
//     //                             editableElem = null;
//     //                         }
//     //                     }

//     //                     if (!($target && $target.length) && !editableElem) {
//     //                         // Prefer context-based insertion (the context was stored when button was clicked)
//     //                         var inserted = false;
//     //                         try {
//     //                             if (window.__summernoteMathEditorContext && typeof window.__summernoteMathEditorContext.invoke === 'function') {
//     //                                 var nodeHtml = '<span contenteditable="false" class="math-editor-rendered" data-latex="' + latex.replace(/"/g,'&quot;') + '"></span>';
//     //                                 window.__summernoteMathEditorContext.invoke('editor.insertNode', $(nodeHtml)[0]);
//     //                                 try {
//     //                                     var $editable = $(window.__summernoteMathEditorContext.layoutInfo.editable);
//     //                                     renderEquationsIn($editable);
//     //                                 } catch (e) {}
//     //                                 inserted = true;
//     //                             }
//     //                         } catch (e) {}

//     //                         // Fallback: try to use stored textarea element's summernote instance
//     //                         if (!inserted && window.__summernoteMathEditorElement) {
//     //                             try {
//     //                                 var nodeHtml = '<span contenteditable="false" class="math-editor-rendered" data-latex="' + latex.replace(/"/g,'&quot;') + '"></span>';
//     //                                 window.__summernoteMathEditorElement.summernote('insertNode', $(nodeHtml)[0]);
//     //                                 try {
//     //                                     var $editable = window.__summernoteMathEditorElement.closest('.note-editor').find('.note-editable');
//     //                                     renderEquationsIn($editable);
//     //                                 } catch (e) {}
//     //                                 inserted = true;
//     //                             } catch (e) {}
//     //                         }
//     //                     }

//     //                     // clear stored pointers
//     //                     window.__summernoteMathEditTarget = null;
//     //                     window.__summernoteMathEditorContext = null;
//     //                     window.__summernoteMathEditorElement = null;

//     //                     $('#mathQuillModal').modal('hide');
//     //                 });
//     //             }
//     //         };

//     //         // Define the toolbar button
//     //         context.memo('button.mathquill', function() {
//     //             var button = ui.button({
//     //                 contents: '<i class="fas fa-square-root-alt"></i>',
//     //                 tooltip: 'Insert Equation',
//     //                 click: function() {
//     //                     // clear previous inline edit target
//     //                     window.__summernoteMathEditTarget = null;
//     //                     // store this summernote context so the modal insert targets this editor
//     //                     try {
//     //                         window.__summernoteMathEditorContext = context;
//     //                         // attempt to find originating textarea as fallback
//     //                         var $editable = $(context.layoutInfo.editable);
//     //                         // store the editable element explicitly so insertions target the correct editor
//     //                         window.__summernoteMathEditorEditable = context.layoutInfo.editable;
//     //                         var $textarea = $editable.closest('.note-editor').prev('textarea');
//     //                         if ($textarea && $textarea.length) window.__summernoteMathEditorElement = $textarea;
//     //                     } catch (e) {
//     //                         window.__summernoteMathEditorContext = null;
//     //                         window.__summernoteMathEditorElement = null;
//     //                     }
//     //                     $('#mathQuillModal').modal('show');
//     //                 }
//     //             });
//     //             return button.render();
//     //         });
//     //     }
//     // });
// }
function ensureMathQuillPluginRegistered() {
  if (_mathquill_loader.initialized) return;

  var registerPlugin = function () {
    if (typeof window.jQuery === 'undefined') return false;
    var $ = window.jQuery;
    if (!$.summernote || !$.summernote.plugins) return false;

    // Register the plugin
    $.extend($.summernote.plugins, {
      'mathquill': function (context) {
        var ui = $.summernote.ui;
        var self = this;
        var mathFieldInstance = null;

        self.createModal = function () {
          var modalId = 'mathQuillModal';
          if ($('#' + modalId).length === 0) {
            var modalHtml = '\n                        <div class="modal fade" id="' + modalId + '" tabindex="-1" role="dialog" aria-hidden="true">\n                            <div class="modal-dialog modal-lg" role="document">\n                                <div class="modal-content">\n                                    <div class="modal-header bg-primary text-white">\n                                        <h5 class="modal-title">Insert/Edit Equation</h5>\n                                        <button type="button" class="close text-white" data-dismiss="modal" aria-label="Close">\n                                            <span aria-hidden="true">&times;</span>\n                                        </button>\n                                    </div>\n                                    <div class="modal-body">\n                                        <p class="text-muted small">Type your LaTeX equation below:</p>\n                                        <div id="math-input-field" class="mathquill-editable" style="min-height:50px;font-size:18px;padding:6px;border:1px solid #e5e7eb;border-radius:4px;background:#fff"></div>\n                                        <div class="mt-3">\n                                            <small class="text-muted">Live LaTeX:</small> <code id="latex-output" style="display:block;white-space:pre-wrap;margin-top:6px"></code>\n                                        </div>\n                                    </div>\n                                    <div class="modal-footer">\n                                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>\n                                        <button type="button" id="insert-equation-btn" class="btn btn-primary">Insert/Update</button>\n                                    </div>\n                                </div>\n                            </div>\n                        </div>\n                    ';
            $('body').append(modalHtml);
          }
        };

        self.initialize = function () {
          self.createModal();

          $('#mathQuillModal').on('shown.bs.modal', function () {
            // Ensure MathQuill resources are loaded
            loadMathQuillResources(function () {
              var $inputField = $('#math-input-field');
              if (mathFieldInstance) {
                try { mathFieldInstance.revert(); } catch (e) { }
                mathFieldInstance = null;
              }
              $inputField.empty();
              if (_mathquill_loader.MQ) {
                mathFieldInstance = _mathquill_loader.MQ.MathField($inputField[0], {
                  spaceBehavesLikeTab: true,
                  handlers: {
                    edit: function () {
                      try { $('#latex-output').text(mathFieldInstance.latex()); } catch (e) { }
                    }
                  }
                });

                // expose the current field globally for the insert handler
                try { window.__summernoteMathCurrentField = mathFieldInstance; } catch (e) { }

                // If there is a target being edited, load its latex
                var $target = window.__summernoteMathEditTarget || null;
                if ($target && $target.length) {
                  var latex = $target.attr('data-latex') || '';
                  try { mathFieldInstance.latex(latex); } catch (e) { }
                } else {
                  try { mathFieldInstance.latex(''); } catch (e) { }
                }

                try { $('#latex-output').text(mathFieldInstance.latex()); } catch (e) { }
                mathFieldInstance.focus();
              }
            });
          });

          $('#mathQuillModal').on('hidden.bs.modal', function () {
            // Clear edit target
            window.__summernoteMathEditTarget = null;
            // Clear current math field reference
            try { window.__summernoteMathCurrentField = null; } catch (e) { }
          });

          // Insert/update button: register once globally to avoid multiple handlers and ensure target editor
          if (!window.__summernoteMathInsertHandlerRegistered) {
            window.__summernoteMathInsertHandlerRegistered = true;
            $(document).on('click', '#insert-equation-btn', function () {
              // The mathFieldInstance used inside shown.bs.modal is stored on window for cross-scope access
              var mathField = window.__summernoteMathCurrentField || mathFieldInstance || null;
              if (!mathField) { $('#mathQuillModal').modal('hide'); return; }
              var latex = '';
              try { latex = mathField.latex(); } catch (e) { latex = ''; }
              if (!latex) { $('#mathQuillModal').modal('hide'); return; }

              var $target = window.__summernoteMathEditTarget || null;
              // If an explicit editable was stored when opening modal, prefer that as the insertion target
              var editableElem = window.__summernoteMathEditorEditable || null;
              if ($target && $target.length) {
                $target.attr('data-latex', latex);
                $target.empty();
                var $editable = $target.closest('.note-editable');
                renderEquationsIn($editable);
              } else if (editableElem) {
                try {
                  var nodeHtml = '<span contenteditable="false" class="math-editor-rendered" data-latex="' + latex.replace(/"/g, '&quot;') + '"></span>';
                  // insert directly into the editable DOM
                  $(editableElem).append(nodeHtml);
                  renderEquationsIn($(editableElem));
                } catch (e) {
                  // fall through to context-based insertion
                  editableElem = null;
                }
              }

              if (!($target && $target.length) && !editableElem) {
                // Prefer context-based insertion (the context was stored when button was clicked)
                var inserted = false;
                try {
                  if (window.__summernoteMathEditorContext && typeof window.__summernoteMathEditorContext.invoke === 'function') {
                    var nodeHtml = '<span contenteditable="false" class="math-editor-rendered" data-latex="' + latex.replace(/"/g, '&quot;') + '"></span>';
                    window.__summernoteMathEditorContext.invoke('editor.insertNode', $(nodeHtml)[0]);
                    try {
                      var $editable = $(window.__summernoteMathEditorContext.layoutInfo.editable);
                      renderEquationsIn($editable);
                    } catch (e) { }
                    inserted = true;
                  }
                } catch (e) { }

                // Fallback: try to use stored textarea element's summernote instance
                if (!inserted && window.__summernoteMathEditorElement) {
                  try {
                    var nodeHtml = '<span contenteditable="false" class="math-editor-rendered" data-latex="' + latex.replace(/"/g, '&quot;') + '"></span>';
                    window.__summernoteMathEditorElement.summernote('insertNode', $(nodeHtml)[0]);
                    try {
                      var $editable = window.__summernoteMathEditorElement.closest('.note-editor').find('.note-editable');
                      renderEquationsIn($editable);
                    } catch (e) { }
                    inserted = true;
                  } catch (e) { }
                }
              }

              // clear stored pointers
              window.__summernoteMathEditTarget = null;
              window.__summernoteMathEditorContext = null;
              window.__summernoteMathEditorElement = null;

              $('#mathQuillModal').modal('hide');
            });
          }
        };

        // Define the toolbar button
        context.memo('button.mathquill', function () {
          var button = ui.button({
            contents: '<i class="fas fa-square-root-alt"></i>',
            tooltip: 'Insert Equation',
            click: function () {
              // clear previous inline edit target
              window.__summernoteMathEditTarget = null;
              // store this summernote context so the modal insert targets this editor
              try {
                window.__summernoteMathEditorContext = context;
                // attempt to find originating textarea as fallback
                var $editable = $(context.layoutInfo.editable);
                // store the editable element explicitly so insertions target the correct editor
                window.__summernoteMathEditorEditable = context.layoutInfo.editable;
                var $textarea = $editable.closest('.note-editor').prev('textarea');
                if ($textarea && $textarea.length) window.__summernoteMathEditorElement = $textarea;
              } catch (e) {
                window.__summernoteMathEditorContext = null;
                window.__summernoteMathEditorElement = null;
              }
              $('#mathQuillModal').modal('show');
            }
          });
          return button.render();
        });
      }
    });

    _mathquill_loader.initialized = true;
    return true;
  };

  // Try immediate registration; if Summernote isn't available yet, retry on DOMContentLoaded and window load
  if (!registerPlugin()) {
    document.addEventListener('DOMContentLoaded', registerPlugin);
    window.addEventListener('load', registerPlugin);
    // Small retry loop in case Summernote is inserted dynamically
    var attempts = 0;
    var retry = function () { attempts++; if (!registerPlugin() && attempts < 20) setTimeout(retry, 200); };
    setTimeout(retry, 200);
  }
}

// --- Updated initializeSummernote using the mathquill plugin ---
function initializeSummernote() {
  // Ensure plugin registered
  ensureMathQuillPluginRegistered();

  // Load MathQuill resources in background (non-blocking)
  loadMathQuillResources();

  $('.question-textarea').each(function () {
    var $el = $(this);
    if ($el.data('summernote-initialized')) return;
    $el.summernote({
      height: 150,
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'italic', 'superscript', 'subscript']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['insert', ['link', 'picture', 'table', 'mathquill']],
        ['view', ['fullscreen', 'codeview']]
      ],
      buttons: {
        mathquill: 'mathquill'
      },
      callbacks: {
        onInit: function () {
          var $editable = $(this).data('summernote').layoutInfo.editable;
          // render any existing equations
          renderEquationsIn($editable);
          // double-click to edit
          $($editable).off('dblclick', '.math-editor-rendered');
          $($editable).on('dblclick', '.math-editor-rendered', function (e) {
            e.preventDefault(); e.stopPropagation();
            // set edit target and store originating editable element
            window.__summernoteMathEditorEditable = $editable[0];
            handleEditEquation($(this));
          });
        },
        onChange: function () {
          var $editable = $(this).data('summernote').layoutInfo.editable;
          renderEquationsIn($editable);
        },
        onKeyup: function () {
          var $editable = $(this).data('summernote').layoutInfo.editable;
          renderEquationsIn($editable);
        }
      }
    });
    $el.data('summernote-initialized', true);
  });

  $('.option-textarea').each(function () {
    var $el = $(this);
    if ($el.data('summernote-initialized')) return;
    $el.summernote({
      height: 100,
      toolbar: [
        ['style', ['style']],
        ['font', ['bold', 'underline', 'italic', 'superscript', 'subscript']],
        ['para', ['ul', 'ol', 'paragraph']],
        ['insert', ['link', 'picture', 'mathquill']],
        ['view', ['fullscreen', 'codeview']]
      ],
      buttons: {
        mathquill: 'mathquill'
      },
      callbacks: {
        onInit: function () {
          var $editable = $(this).data('summernote').layoutInfo.editable;
          renderEquationsIn($editable);
          $($editable).off('dblclick', '.math-editor-rendered');
          $($editable).on('dblclick', '.math-editor-rendered', function (e) {
            e.preventDefault(); e.stopPropagation();
            // store originating editable element for correct insertion
            window.__summernoteMathEditorEditable = $editable[0];
            handleEditEquation($(this));
          });
        },
        onChange: function () {
          var $editable = $(this).data('summernote').layoutInfo.editable;
          renderEquationsIn($editable);
        },
        onKeyup: function () {
          var $editable = $(this).data('summernote').layoutInfo.editable;
          renderEquationsIn($editable);
        }
      }
    });
    $el.data('summernote-initialized', true);
  });
}

function updateModalCheckboxes() {
  // Get all currently displayed class IDs from the buttons
  let displayedClassIds = [];
  $('.classes_container button').each(function () {
    displayedClassIds.push($(this).data('class-id').toString());
  });

  // Update checkboxes in modal
  $('.class-checkbox').each(function () {
    $(this).prop('checked', displayedClassIds.includes($(this).val()));
  });
}
function saveSelectedClasses() {
  // Get all checked checkboxes
  let selectedClasses = [];
  $('.class-checkbox:checked').each(function () {
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
  selectedClasses.forEach(function (classItem) {
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
  toastr.success('Classes assigned successfully');
}
// function addNewQuestion() {
//     const questionCount = $('.question-block').length + 1;
//     const template = `
//         <div class="py-3 px-15 bg-white mb-3 question-block" style="border-radius: 10px;">
//             <div class="form-group">
//                 <label>Question ${questionCount}</label>
//                 <textarea class="question-textarea form-control" style="height: 200px"></textarea>
//             </div>

//             <div class="options-container mt-3">
//                 <div class="form-group">
//                     <label>Options</label>
//                     <p class="text-muted small">Select the radio button for the correct answer</p>
//                     <div class="row">
//                         ${Array(4).fill().map((_, i) => `
//                             <div class="option-group col-md-6 col-12 mb-3 d-flex align-items-start">
//                                 <div class="icheck-primary d-flex">
//                                     <input type="radio" id="radio_new_${questionCount}_${i}" name="question_new_${questionCount}">
//                                     <label for="radio_new_${questionCount}_${i}"></label>
//                                     <textarea class="form-control option-textarea" style="height: 100px"></textarea>
//                                 </div>
//                             </div>
//                         `).join('')}
//                     </div>
//                 </div>
//             </div>
//             <button type="button" class="btn btn-danger btn-sm mt-2" onclick="$(this).closest('.question-block').remove()">Delete Question</button>
//         </div>
//     `;

//     $('#questions-container').append(template);
//     initializeSummernote();
// }
function addNewQuestion() {
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
  const template = `
        <div class="py-3 px-15 bg-white mb-3 question-block" style="border-radius: 10px;">
            <div class="form-group">
                <label>Question ${nextNumber}</label>
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
                                    <input type="radio" id="radio_new_${nextNumber}_${i}" name="question_new_${nextNumber}">
                                    <label for="radio_new_${nextNumber}_${i}"></label>
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
// $('#add-question-btn').click(function() {
//     addNewQuestion();
// });
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
    }, function (response) {
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
function saveEntireAssessment_for_create_assessment() {
  // Validate required fields
  console.log("lll");
  if (!$("#select_subject_field").val()) {
    toastr.error("Please select a subject");
    return;
  }

  if (!$(".assessment_btn.select_btn.active").length) {
    toastr.error("Please select an assessment type");
    return;
  }

  if (!$(".term_btn.select_btn.active").length) {
    toastr.error("Please select a term");
    return;
  }

  if ($(".classes_container button").length === 0) {
    toastr.error("Please assign at least one class");
    return;
  }

  if ($(".question-block").length === 0) {
    toastr.error("Please add at least one question");
    return;
  }

  let hasError = false;
  $(".question-block").each(function (index) {
    const questionText = $(this).find(".question-textarea").summernote("code");
    const hasCheckedAnswer =
      $(this).find('input[type="radio"]:checked').length > 0;

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
    $(this)
      .find(".option-textarea")
      .each(function (optIndex) {
        if (!$(this).summernote("code").trim()) {
          toastr.error(
            `Option ${optIndex + 1} in Question ${index + 1} cannot be empty`,
          );
          hasError = true;
          return false;
        }
      });
  });

  if (hasError) return;

  // Collect settings data
  const settingsData = {
    assessment_id: existingAssessmentId,
    subject_id: $("#select_subject_field").val(),
    instruction: $("#assessment_instruction").val(),
    duration_set: $("#set_duration_checkbox").is(":checked") ? 1 : 0,
    duration: $("#assessment_duration").val() || 0,
    deadline_set: $("#set_deadline_checkbox").is(":checked") ? 1 : 0,
    deadline_date: $("#deadline_date").val() || "",
    deadline_time: $("#deadline_time").val() || "",
    desired_score: $("#desired_score").val() || 0,
    round_off_decimal: $("#round_off_dec").is(":checked") ? 1 : 0,
    ca_type: $('[name="ca"]:checked').val() || 0,
    class_ids: Array.from($(".classes_container button"))
      .map((btn) => $(btn).data("class-id"))
      .join(","),
    assessment_type: $(".assessment_btn.select_btn.active").data("id"),
    term: $(".term_btn.select_btn.active").data("id"),
  };

  // Collect questions data
  const questions = [];
  $(".question-block").each(function () {
    const questionData = {
      id: $(this).data("question-id") || null,
      question: $(this).find(".question-textarea").summernote("code"),
      options: [],
    };

    $(this)
      .find(".option-group")
      .each(function () {
        questionData.options.push({
          id: $(this).find(".option-textarea").data("option-id") || null,
          text: $(this).find(".option-textarea").summernote("code"),
          isAnswer: $(this).find('input[type="radio"]').is(":checked"),
        });
      });

    questions.push(questionData);
  });

  // Show loading state
  const saveBtn = $('.btn-primary:contains("Save Assessment")');
  const originalText = saveBtn.text();
  saveBtn.prop("disabled", true).text("Saving...");

  // Send to server
  $.ajax({
    url: "../controller_new.php",
    type: "POST",
    data: {
      action: "save_update_entire_assessment_create",
      settings: JSON.stringify(settingsData),
      questions: JSON.stringify(questions),
    },
    success: function (response) {
      // console.log(response);
      if (response.success) {
        toastr.success(response.message);
        if (response.assessment_id) {
          existingAssessmentId = response.assessment_id;
        }
        // If server returned mapping of created/updated IDs, sync them into the DOM
        if (response.mapping && Array.isArray(response.mapping)) {
          $(".question-block").each(function (qIndex) {
            const map = response.mapping[qIndex];
            if (!map) return;
            // set question id attribute
            $(this)
              .attr("data-question-id", map.question_id)
              .data("question-id", map.question_id);

            // set option ids in order (positionally)
            $(this)
              .find(".option-group")
              .each(function (optIndex) {
                const optId =
                  map.options && map.options[optIndex]
                    ? map.options[optIndex]
                    : null;
                if (optId) {
                  $(this)
                    .find(".option-textarea")
                    .attr("data-option-id", optId)
                    .data("option-id", optId);
                } else {
                  $(this)
                    .find(".option-textarea")
                    .removeAttr("data-option-id")
                    .data("option-id", null);
                }
              });
          });
        }
        // setTimeout(() => {
        //     window.location.href = 'assessment';
        // }, 1500);
      } else {
        toastr.error(response.message || "Error saving assessment");
      }
    },
    error: function () {
      toastr.error("Network error occurred");
    },
    complete: function () {
      saveBtn.prop("disabled", false).text(originalText);
    },
  });
}
function saveEntireAssessment() {
  // Validate required fields

  if (!$("#select_subject_field").val()) {
    toastr.error("Please select a subject");
    return;
  }

  if (!$(".assessment_btn.select_btn.active").length) {
    toastr.error("Please select an assessment type");
    return;
  }

  if (!$(".term_btn.select_btn.active").length) {
    toastr.error("Please select a term");
    return;
  }

  if ($(".classes_container button").length === 0) {
    toastr.error("Please assign at least one class");
    return;
  }

  if ($(".question-block").length === 0) {
    toastr.error("Please add at least one question");
    return;
  }

  let hasError = false;
  $(".question-block").each(function (index) {
    const questionText = $(this).find(".question-textarea").summernote("code");
    const hasCheckedAnswer =
      $(this).find('input[type="radio"]:checked').length > 0;

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
    $(this)
      .find(".option-textarea")
      .each(function (optIndex) {
        if (!$(this).summernote("code").trim()) {
          toastr.error(
            `Option ${optIndex + 1} in Question ${index + 1} cannot be empty`,
          );
          hasError = true;
          return false;
        }
      });
  });

  if (hasError) return;

  // Collect settings data
  const settingsData = {
    assessment_id: existingAssessmentId,
    subject_id: $("#select_subject_field").val(),
    instruction: $("#assessment_instruction").val(),
    duration_set: $("#set_duration_checkbox").is(":checked") ? 1 : 0,
    duration: $("#assessment_duration").val() || 0,
    deadline_set: $("#set_deadline_checkbox").is(":checked") ? 1 : 0,
    deadline_date: $("#deadline_date").val() || "",
    deadline_time: $("#deadline_time").val() || "",
    desired_score: $("#desired_score").val() || 0,
    round_off_decimal: $("#round_off_dec").is(":checked") ? 1 : 0,
    ca_type: $('[name="ca"]:checked').val() || 0,
    class_ids: Array.from($(".classes_container button"))
      .map((btn) => $(btn).data("class-id"))
      .join(","),
    assessment_type: $(".assessment_btn.select_btn.active").data("id"),
    term: $(".term_btn.select_btn.active").data("id"),
  };

  // Collect questions data
  const questions = [];
  $(".question-block").each(function () {
    const questionData = {
      id: $(this).data("question-id") || null,
      question: $(this).find(".question-textarea").summernote("code"),
      options: [],
    };

    $(this)
      .find(".option-group")
      .each(function () {
        questionData.options.push({
          id: $(this).find(".option-textarea").data("option-id") || null,
          text: $(this).find(".option-textarea").summernote("code"),
          isAnswer: $(this).find('input[type="radio"]').is(":checked"),
        });
      });

    questions.push(questionData);
  });

  // Show loading state
  const saveBtn = $('.btn-primary:contains("Save Assessment")');
  const originalText = saveBtn.text();
  saveBtn.prop("disabled", true).text("Saving...");

  // Send to server
  $.ajax({
    url: "../controller_new.php",
    type: "POST",
    data: {
      action: "save_update_entire_assessment",
      settings: JSON.stringify(settingsData),
      questions: JSON.stringify(questions),
    },
    success: function (response) {
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
        toastr.error(response.message || "Error saving assessment");
      }
    },
    error: function () {
      toastr.error("Network error occurred");
    },
    complete: function () {
      saveBtn.prop("disabled", false).text(originalText);
    },
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
  // If there are no existing MathQuill spans, convert raw $$...$$ LaTeX to math spans.
  // This avoids running the regex over already-existing MathQuill DOM (which contains literal "$$" markers)
  try {
    var hasMathSpan = container.querySelector && container.querySelector('span.math-editor-rendered, .mq-root, .mq-selectable');
    if (!hasMathSpan) {
      // Only convert if there are plain $$ markers in the HTML
      if (/\$\$/.test(container.innerHTML)) {
        convertDollarLatexToSpans(container);
      }
    }
  } catch (e) {
    console.warn('convertDollarLatexToSpans check failed', e);
  }

  // Ensure MathQuill resources are loaded and then render math in the container
  loadMathQuillResources(function () {
    try {
      renderEquationsIn($(container));
    } catch (e) {
      console.warn('renderEquationsIn failed', e);
    }
  });

  // Post-render: some stored option HTML may have an empty <p><br></p> before the math span,
  // which can collapse the visible area. Make sure option wrappers are visible if they contain math spans.
  try {
    $(container).find('.options .icheck-gray-dark, .option-group').each(function () {
      var $this = $(this);
      var text = $this.text().trim();
      var hasMath = $this.find('span.math-editor-rendered').length > 0;
      if (hasMath && text.length === 0) {
        // Make sure the math span (and container) is visible
        $this.find('span.math-editor-rendered').css({ display: 'inline-block' });
        $this.css({ minHeight: '30px' });
      }
    });
  } catch (e) {
    console.warn('post-render visibility fix failed', e);
  }
}

// Convert occurrences of $$latex$$ in a container's innerHTML to
// <span class="math-editor-rendered" data-latex="..."></span>
function convertDollarLatexToSpans(containerElement) {
  if (!containerElement) return;
  // Operate on innerHTML string
  var html = containerElement.innerHTML;
  // Replace all $$...$$ blocks (non-greedy)
  var replaced = html.replace(/\$\$([\s\S]*?)\$\$/g, function (match, latex) {
    // Trim, remove zero-width and non-breaking spaces, and escape double quotes
    var clean = latex.replace(/\u200B/g, '').replace(/&nbsp;/g, ' ').trim().replace(/"/g, '&quot;');
    return '<span contenteditable="false" class="math-editor-rendered" data-latex="' + clean + '"></span>';
  });
  if (replaced !== html) {
    containerElement.innerHTML = replaced;
  }
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

function toggle_term_btn(btn) {
  $(".term_btn").removeClass("active");
  $(btn).addClass("active");
  checkExistingAssessment();
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
        // toastr.success('Progress saved');
        console.log('Progress saved')
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



function launch_modal_reset_assessment(assessment_id, student_id) {
  $('#assessment_id').val(assessment_id);
  $('#student_id').val(student_id);
  $('#reset_assessment_modal').modal('show');
}

function reset_assessment() {
  var assessment_id = $('#assessment_id').val();
  var student_id = $('#student_id').val();
  $.ajax({
    url: '../controller_new.php',
    type: 'POST',
    data: {
      action: 'reset_assessment',
      assessment_id: assessment_id,
      student_id: student_id
    },
    beforeSend: () => {
      $("#reset_assessment_modal_btn").html('Processing...').attr('disabled', true)
    },
    success: function (response) {
      console.log(response)
      // var res = JSON.parse(response);
      if (response.success) {
        toastr.success('Assessment has been reset successfully.');
        $('#reset_assessment_modal').modal('hide');
        // reload the page
        location.reload();
      }
    },
    complete: () => {
      $("#reset_assessment_modal_btn").html('Reset Assessment').attr('disabled', false)
    },
    error: function () {
      toastr.error('An error occurred while processing your request.');
    }
  });
}