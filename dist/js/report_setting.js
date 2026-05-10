$(document).ready(function () {
    let currentReportCard = null;
    let isNewReport = false;

    function getSelectedSessionId() {
        return $('#reportTemplateSessionValue').val() || $('#singleSessionValue').val();
    }

    function getSelectedTermId() {
        return $('#reportCustomizationTermFilter .report-custom-term-setting.active').data('name') || $('.term_setting.active').data('name');
    }

    // Fetch reports on page load (if session and term are set)
    fetchReports();

    // Trigger fetch when session changes
    $('#singleSessionValue, #reportTemplateSessionValue').on('change', function () {
        fetchReports();
    });

    // Trigger fetch when term changes
    // Note: toggle_term_setting is global, we need to hook into it or the buttons
    $(document).on('click', '.term_setting', function () {
        // Wait for active class to be applied by the existing function
        setTimeout(fetchReports, 100);
    });

    $(document).on('click', '.report-custom-term-setting', function () {
        $('.report-custom-term-setting').removeClass('active');
        $(this).addClass('active');
        fetchReports();
    });

    function fetchReports() {
        let session_id = getSelectedSessionId();
        let term_id = getSelectedTermId();

        if (!session_id || !term_id) return;

        $.ajax({
            url: '../report_controller.php',
            type: 'POST',
            data: {
                action: 'fetch_reports',
                session_id: session_id,
                term_id: term_id
            },
            dataType: 'json',
            success: function (response) {
                if (response.status === 'success') {
                    renderReportCards(response.data);
                }
            }
        });
    }

    function renderReportCards(reports) {
        let container = $('#reportCardsContainer');
        container.empty();

        if (reports.length === 0) {
            container.append('<p class="text-muted mt-2"><i class="fas fa-info-circle mr-1"></i> No reports configured for this term.</p>');
            return;
        }

        reports.forEach(report => {
            let chips = "";
            if (report.assessment_type && Array.isArray(report.assessment_type)) {
                chips = report.assessment_type.map(a =>
                    `<span class="assessment-chip" data-value="${a}">${a} <i class="fas fa-times remove-chip"></i></span>`
                ).join('');
            }

            const statusClass = report.status == 1 ? 'status-on' : 'status-off';
            const statusText = report.status == 1 ? 'Active' : 'Off';

            let cardHtml = `
                <div class="premium-card report-card" data-id="${report.id}" data-status="${report.status}">
                    <span class="card-status ${statusClass}">${statusText}</span>
                    <p class="report-name">${report.report_name}</p>
                    <div class="assessment-chips reportAssessmentContainer">
                        ${chips}
                    </div>
                    <div class="card-actions">
                        <button type="button" class="btn-premium-edit updateReportAssessments">
                            <i class="fas fa-pen mr-1" style="font-size:0.75rem;"></i> Edit
                        </button>
                        <button type="button" class="btn-premium-delete delete-report" title="Delete">
                            <i class="fas fa-trash-alt"></i>
                        </button>
                    </div>
                </div>
            `;
            container.append(cardHtml);
        });
    }

    // Modal Opening
    $(document).on('click', '.updateReportAssessments', function () {
        currentReportCard = $(this).closest('.report-card');
        isNewReport = false;

        let reportName = currentReportCard.find('.report-name').text().trim();
        $('#modalReportName').val(reportName);

        // Pre-fill status switch
        let status = currentReportCard.data('status');
        $('#reportStatusSwitch').prop('checked', status == 1);

        // Reset checkboxes
        $('.assessment-checkbox').prop('checked', false);
        $('.modern-checkbox').removeClass('active');

        // Check boxes that match current chips
        currentReportCard.find('.assessment-chip').each(function () {
            let val = $(this).data('value');
            let cb = $(`.assessment-checkbox[value="${val}"]`);
            cb.prop('checked', true);
            cb.closest('.modern-checkbox').addClass('active');
        });
        $('#assessmentModal').modal('show');
    });

    // Add More Report
    $('#addMoreReports').on('click', function () {
        isNewReport = true;
        currentReportCard = null;
        $('#modalReportName').val('');
        $('.assessment-checkbox').prop('checked', false);
        $('.modern-checkbox').removeClass('active');
        $('#reportStatusSwitch').prop('checked', true);
        $('#assessmentModal').modal('show');
    });

    // Toggle active class on modern checkboxes
    $(document).on('change', '.assessment-checkbox', function () {
        $(this).closest('.modern-checkbox').toggleClass('active', this.checked);
    });

    // Save Changes (AJAX)
    $('#saveAssessmentChanges').on('click', function () {
        let newName = $('#modalReportName').val().trim();
        if (newName === "") {
            alert("Please enter a report name");
            return;
        }

        let selectedAssessments = [];
        $('.assessment-checkbox:checked').each(function () {
            selectedAssessments.push($(this).val());
        });

        let session_id = getSelectedSessionId();
        let term_id = getSelectedTermId();
        let status = $('#reportStatusSwitch').is(':checked') ? 1 : 0;
        let report_id = currentReportCard ? currentReportCard.data('id') : null;

        $.ajax({
            url: '../report_controller.php',
            type: 'POST',
            data: {
                action: 'save_report',
                id: report_id,
                report_name: newName,
                assessment_type: selectedAssessments,
                status: status,
                session_id: session_id,
                term_id: term_id
            },
            dataType: 'json',
            success: function (response) {
                if (response.status === 'success') {
                    $('#assessmentModal').modal('hide');
                    fetchReports(); // Refresh cards
                } else {
                    alert('Error saving report: ' + response.message);
                }
            }
        });
    });

    // Delete Report (AJAX)
    $(document).on('click', '.delete-report', function () {
        let card = $(this).closest('.report-card');
        let id = card.data('id');

        if (!id) {
            card.remove();
            return;
        }

        if (confirm('Are you sure you want to delete this report?')) {
            $.ajax({
                url: '../report_controller.php',
                type: 'POST',
                data: {
                    action: 'delete_report',
                    id: id
                },
                dataType: 'json',
                success: function (response) {
                    if (response.status === 'success') {
                        card.remove();
                    } else {
                        alert('Error deleting report: ' + response.message);
                    }
                }
            });
        }
    });

    // Remove individual assessment chip
    $(document).on('click', '.remove-chip', function () {
        let chip = $(this).closest('.assessment-chip');
        let card = chip.closest('.report-card');
        chip.remove();
        saveCardState(card);
    });

    function saveCardState(card) {
        let id = card.data('id');
        let report_name = card.find('.report-name').text().trim();
        let assessments = [];
        card.find('.assessment-chip').each(function () {
            assessments.push($(this).data('value'));
        });

        let session_id = getSelectedSessionId();
        let term_id = getSelectedTermId();

        $.ajax({
            url: '../report_controller.php',
            type: 'POST',
            data: {
                action: 'save_report',
                id: id,
                report_name: report_name,
                assessment_type: assessments,
                status: 1, // Assume active if visible
                session_id: session_id,
                term_id: term_id
            },
            dataType: 'json'
        });
    }
});
