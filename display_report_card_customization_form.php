<?php
session_start();
include_once("model/connect.php");

$school_id = $_SESSION['school_id'];
$select = mysqli_query($conn, "SELECT s.session_id as session, s.term_id as term_id FROM school s WHERE s.id='$school_id'");
$row = mysqli_fetch_array($select);
?>
<link rel="stylesheet" href="../dist/css/report_template_builder.css">
<style>
    #reportCardsContainer {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
        gap: 20px;
        margin-top: 20px;
        margin-bottom: 25px;
    }

    .premium-card {
        background: #fff;
        border: 1px solid #e2e8f0;
        border-radius: 16px;
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        display: flex;
        flex-direction: column;
        justify-content: space-between;
        min-height: 160px;
        overflow: hidden;
        padding: 20px;
        position: relative;
        transition: all 0.2s;
    }

    .premium-card:hover {
        border-color: #cbd5e1;
        box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
        transform: translateY(-3px);
    }

    .premium-card .card-status {
        border-radius: 12px;
        font-size: 10px;
        font-weight: 700;
        letter-spacing: 0.5px;
        padding: 2px 8px;
        position: absolute;
        right: 12px;
        text-transform: uppercase;
        top: 12px;
    }

    .status-on {
        background: #dcfce7;
        color: #166534;
    }

    .status-off {
        background: #fee2e2;
        color: #991b1b;
    }

    .premium-card .report-name {
        color: #1e293b;
        font-size: 1.05rem;
        font-weight: 700;
        line-height: 1.4;
        margin-bottom: 12px;
        padding-right: 40px;
    }

    .assessment-chips,
    .card-actions,
    .assessment-grid {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
    }

    .assessment-chip {
        align-items: center;
        background: #f1f5f9;
        border: 1px solid #e2e8f0;
        border-radius: 8px;
        color: #475569;
        display: flex;
        font-size: 0.75rem;
        font-weight: 600;
        padding: 3px 10px;
    }

    .assessment-chip i {
        cursor: pointer;
        font-size: 0.65rem;
        margin-left: 6px;
        opacity: 0.55;
    }

    .card-actions {
        align-items: center;
        border-top: 1px solid #f1f5f9;
        justify-content: space-between;
        margin-top: auto;
        padding-top: 12px;
    }

    .btn-premium-edit,
    .btn-premium-delete {
        border: 0;
        border-radius: 8px;
        font-weight: 600;
        padding: 5px 12px;
    }

    .btn-premium-edit {
        background: #eff6ff;
        color: #2563eb;
    }

    .btn-premium-delete {
        background: transparent;
        color: #94a3b8;
    }

    .modern-checkbox {
        align-items: center;
        background: #f8fafc;
        border: 1px solid #e2e8f0;
        border-radius: 12px;
        cursor: pointer;
        display: flex;
        padding: 12px 16px;
    }

    .modern-checkbox.active {
        background: #eff6ff;
        border-color: #3b82f6;
    }

    .modern-checkbox input {
        accent-color: #3b82f6;
        height: 18px;
        margin-right: 12px;
        width: 18px;
    }
</style>

<div class="info-container mt-4 mb-4">
    <div class="d-flex flex-wrap justify-content-between align-items-start mb-4">
        <div>
            <p class="font-weight-bold mb-1">Report Card Customization</p>
            <p class="p-0 mb-0 muted-text">Create custom report formats and term-specific report card layouts.</p>
        </div>
        <div class="form-group mb-0" style="min-width: 180px;">
            <p class="p-0 mb-0 muted-text">Select Session</p>
            <select id="reportTemplateSessionValue" class="form-control select2">
                <?php
                $select_session = mysqli_query($conn, "SELECT id, session FROM sessions ORDER BY session ASC");
                while ($row_session = mysqli_fetch_array($select_session)) {
                    $selected = $row['session'] === $row_session['id'] ? 'selected' : '';
                ?>
                    <option <?= $selected ?> value="<?= $row_session['id'] ?>"><?= $row_session['session'] ?></option>
                <?php } ?>
            </select>
        </div>
    </div>

    <div class="mb-3" id="reportCustomizationTermFilter">
        <p class="p-0 mb-0 muted-text">Select Term</p>
        <button type="button" class="btn select_btn report-custom-term-setting <?= $row['term_id'] == '1' ? 'active' : '' ?> my-1 mr-2" data-name="1">1st Term</button>
        <button type="button" class="btn select_btn report-custom-term-setting <?= $row['term_id'] == '2' ? 'active' : '' ?> my-1 mr-2" data-name="2">2nd Term</button>
        <button type="button" class="btn select_btn report-custom-term-setting <?= $row['term_id'] == '3' ? 'active' : '' ?> my-1 mr-2" data-name="3">3rd Term</button>
    </div>

    <div class="report-template-panel mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center">
            <div>
                <div class="report-template-panel-title">Custom Assessment Reports</div>
                <p class="p-0 mb-0 muted-text">Optional report cards based on selected assessment components.</p>
            </div>
            <button type="button" id="addMoreReports" class="btn btn-sm btn-outline-success">
                <i class="fas fa-plus mr-1"></i> Add More Report
            </button>
        </div>
        <div id="reportCardsContainer"></div>
    </div>

    <div class="report-template-builder" id="reportTemplateBuilder">
        <div class="d-flex flex-wrap justify-content-between align-items-center mb-3">
            <div>
                <p class="font-weight-bold mb-1">Report card format</p>
                <p class="p-0 mb-0 muted-text">Configure layout by term without changing score calculations.</p>
            </div>
            <div class="report-template-status small text-muted mt-2 mt-sm-0" id="reportTemplateStatusText"></div>
        </div>

        <div class="row">
            <div class="form-group col-12 col-md-4">
                <p class="p-0 mb-0 muted-text">Template Name</p>
                <input type="text" class="form-control" id="reportTemplateName" value="Default Report Card">
                <input type="hidden" id="reportTemplateId" value="">
            </div>
            <div class="form-group col-6 col-md-3">
                <p class="p-0 mb-0 muted-text">Applies To</p>
                <select class="form-control" id="reportTemplateTerm">
                    <option value="default">School Default</option>
                    <option value="1" <?= $row['term_id'] == '1' ? 'selected' : '' ?>>1st Term</option>
                    <option value="2" <?= $row['term_id'] == '2' ? 'selected' : '' ?>>2nd Term</option>
                    <option value="3" <?= $row['term_id'] == '3' ? 'selected' : '' ?>>3rd Term</option>
                    <option value="cumulative">Cumulative</option>
                </select>
            </div>
            <div class="form-group col-6 col-md-3">
                <p class="p-0 mb-0 muted-text">Availability</p>
                <select class="form-control" id="reportTemplateStatus">
                    <option value="1">Active</option>
                    <option value="0">Inactive</option>
                </select>
            </div>
            <div class="form-group col-12 col-md-2 d-flex align-items-end">
                <div class="icheck-primary">
                    <input type="checkbox" id="reportTemplateDefault" value="1">
                    <label for="reportTemplateDefault">Default</label>
                </div>
            </div>
        </div>

        <div class="report-template-panel mb-3">
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-2">
                <div class="report-template-panel-title mb-0">Saved Formats</div>
                <button type="button" class="btn btn-sm btn-outline-secondary" id="refreshReportTemplates">Refresh</button>
            </div>
            <div id="reportTemplateList" class="report-template-list"></div>
        </div>

        <div class="report-template-grid">
            <div class="report-template-panel">
                <div class="report-template-panel-title">Preset</div>
                <button type="button" class="report-template-preset" data-preset="basic_term">Basic Term</button>
                <button type="button" class="report-template-preset" data-preset="first_term">First Term</button>
                <button type="button" class="report-template-preset" data-preset="second_term_brought_forward">Second Term With B/F</button>
                <button type="button" class="report-template-preset" data-preset="third_term_cumulative">Third Term Cumulative</button>
                <button type="button" class="report-template-preset" data-preset="cumulative">Cumulative Summary</button>
            </div>
            <div class="report-template-panel">
                <div class="report-template-panel-title">Sections</div>
                <div class="report-toggle-grid" id="reportTemplateSections"></div>
            </div>
            <div class="report-template-panel">
                <div class="report-template-panel-title">Fields</div>
                <div class="report-toggle-grid" id="reportTemplateFields"></div>
            </div>
        </div>

        <div class="report-template-panel mt-3">
            <div class="report-template-panel-title">Labels</div>
            <p class="p-0 mb-3 muted-text">Rename titles, section headings, field labels, and score table columns without changing calculations.</p>
            <div class="report-label-editor" id="reportTemplateLabels"></div>
        </div>

        <div class="report-template-panel mt-3">
            <div class="report-template-panel-title">Score Table Columns</div>
            <div class="report-column-picker">
                <div>
                    <p class="p-0 mb-2 muted-text">Available Columns</p>
                    <div class="report-column-list" id="availableReportColumns"></div>
                </div>
                <div>
                    <p class="p-0 mb-2 muted-text">Selected Columns</p>
                    <div class="report-column-list" id="selectedReportColumns"></div>
                </div>
            </div>
            <div class="report-template-preview" id="reportTemplatePreview"></div>
        </div>

        <div class="d-flex flex-wrap justify-content-end mt-3">
            <button type="button" class="btn btn-light mr-2 mb-2" id="resetReportTemplateDraft">Reset Draft</button>
            <button type="button" class="btn btn-outline-primary mr-2 mb-2" id="loadReportTemplate">Load Format</button>
            <button type="button" class="btn btn-primary mb-2" id="saveReportTemplate">Save Format</button>
        </div>
    </div>
</div>

<div class="modal fade" id="assessmentModal" tabindex="-1" role="dialog" aria-labelledby="assessmentModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="assessmentModalLabel">Configure Report</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true" style="font-size: 1.5rem;">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <div class="form-group mb-4">
                    <label class="font-weight-bold" for="modalReportName">Report Name</label>
                    <input type="text" class="form-control" id="modalReportName" placeholder="e.g. Mid-term Report">
                </div>
                <label class="font-weight-bold">Select Assessments</label>
                <div class="assessment-grid mb-4">
                    <label class="modern-checkbox" for="checkCA1"><input type="checkbox" id="checkCA1" class="assessment-checkbox" value="CA1"><span>CA1</span></label>
                    <label class="modern-checkbox" for="checkCA2"><input type="checkbox" id="checkCA2" class="assessment-checkbox" value="CA2"><span>CA2</span></label>
                    <label class="modern-checkbox" for="checkCA3"><input type="checkbox" id="checkCA3" class="assessment-checkbox" value="CA3"><span>CA3</span></label>
                    <label class="modern-checkbox" for="checkPractical"><input type="checkbox" id="checkPractical" class="assessment-checkbox" value="Practical"><span>Practical</span></label>
                    <label class="modern-checkbox" for="checkExam"><input type="checkbox" id="checkExam" class="assessment-checkbox" value="Exam"><span>Exam</span></label>
                </div>
                <label class="font-weight-bold">Availability</label>
                <div class="d-flex justify-content-between align-items-center p-3 border rounded">
                    <span>Visible to Parents</span>
                    <div class="custom-control custom-switch">
                        <input type="checkbox" class="custom-control-input" id="reportStatusSwitch" checked>
                        <label class="custom-control-label" for="reportStatusSwitch"></label>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-light" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="saveAssessmentChanges">Save Report</button>
            </div>
        </div>
    </div>
</div>

<script src="../dist/js/report_card_columns.js"></script>
<script src="../dist/js/report_template_builder.js"></script>
<script src="../dist/js/report_setting.js"></script>
