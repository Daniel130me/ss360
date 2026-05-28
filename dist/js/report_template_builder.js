(function (window, $) {
    const sectionLabels = {
        school_header: "School Header",
        student_details: "Student Details",
        performance_summary: "Performance Summary",
        score_table: "Score Table",
        behaviour_skills: "Behaviour Skills",
        psychomotor_skills: "Psychomotor Skills",
        grade_scale: "Grade Scale",
        skill_rating_indices: "Skill Rating Indices",
        comments: "Comments",
        signature_stamp: "Signature / Stamp",
    };

    const fieldLabels = {
        school_logo: "School Logo",
        school_name: "School Name",
        school_address: "School Address",
        school_phone: "Phone",
        school_email: "Email",
        student_photo: "Student Photo",
        student_name: "Student Name",
        admission_no: "Admission No",
        class: "Class",
        no_in_class: "No In Class",
        school_open: "School Opened",
        times_present: "Times Present",
        times_absent: "Times Absent",
        next_term_begins: "Next Term Begins",
        teacher_comment: "Teacher Comment",
        head_teacher_comment: "Head Teacher Comment",
    };

    const presets = {
        basic_term: {
            name: "Basic Term Report",
            columns: ["subject", "ca1", "ca2", "exam", "total", "percentage", "grade"],
        },
        first_term: {
            name: "First Term Report",
            columns: ["subject", "ca1", "ca2", "ca3", "practical", "exam", "total", "percentage", "grade"],
        },
        second_term_brought_forward: {
            name: "Second Term Brought Forward",
            columns: ["subject", "ca1", "ca2", "exam", "first_term_total", "second_term_total", "average", "grade"],
        },
        third_term_cumulative: {
            name: "Third Term Cumulative",
            columns: [
                "subject",
                "ca1",
                "ca2",
                "exam",
                "first_term_total",
                "second_term_total",
                "third_term_total",
                "grand_total",
                "average",
                "grade",
            ],
        },
        cumulative: {
            name: "Cumulative Summary",
            columns: [
                "subject",
                "first_term_total",
                "second_term_total",
                "third_term_total",
                "grand_total",
                "average",
                "percentage",
                "grade",
            ],
        },
    };

    const defaultSections = Object.keys(sectionLabels).map((key, index) => ({
        key,
        enabled: true,
        order: index + 1,
    }));

    const defaultFields = Object.keys(fieldLabels).reduce((fields, key) => {
        fields[key] = true;
        return fields;
    }, {});

    let draft = null;
    let templateList = [];

    function columnApi() {
        return window.ReportCardColumns || {
            registry: {},
            defaultColumns: ["subject", "ca1", "ca2", "ca3", "practical", "exam", "total", "percentage", "grade"],
            keys: ["subject", "ca1", "ca2", "ca3", "practical", "exam", "total", "percentage", "grade"],
            normalizeColumns: function (columns) {
                return Array.isArray(columns) && columns.length ? columns : this.defaultColumns.slice();
            },
            getColumnLabel: function (key) {
                return key;
            },
        };
    }

    function escapeHtml(value) {
        return String(value || "")
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    function setStatus(message, tone) {
        const className = tone === "error" ? "text-danger" : tone === "success" ? "text-success" : "text-muted";
        $("#reportTemplateStatusText").removeClass("text-danger text-success text-muted").addClass(className).text(message || "");
    }

    function getTermLabel(termId) {
        const labels = {
            default: "School Default",
            "1": "1st Term",
            "2": "2nd Term",
            "3": "3rd Term",
            cumulative: "Cumulative",
        };

        return labels[String(termId || "default")] || "School Default";
    }

    function isExactTemplateMatch(templateRow, termId) {
        if (!templateRow || !templateRow.id) {
            return false;
        }

        return (
            String(templateRow.term_id || "default") === String(termId || "default") &&
            String(templateRow.school_id || "0") !== "0"
        );
    }

    function defaultTemplate() {
        const columns = columnApi().defaultColumns.slice();
        return {
            version: 1,
            template_name: "Default Report Card",
            page: {
                size: "A4",
                orientation: "portrait",
                show_watermark: true,
            },
            sections: defaultSections.map((section) => Object.assign({}, section)),
            fields: Object.assign({}, defaultFields),
            score_columns: columns,
            available_cumulative_columns: (columnApi().cumulativeColumns || []).slice(),
            labels: buildDefaultLabels(),
        };
    }

    function buildColumnLabels() {
        return columnApi().keys.reduce((labels, key) => {
            labels[key] = columnApi().getColumnLabel(key);
            return labels;
        }, {});
    }

    function buildDefaultLabels() {
        return {
            columns: buildColumnLabels(),
            sections: {
                performance_summary: "Performance Summary",
                behaviour_skills: "General Behaviour",
                psychomotor_skills: "Psychomotive Skills",
                grade_scale: "Grade Scale",
                skill_rating_indices: "Skill Rating Indices",
            },
            fields: {
                student_name: "NAME",
                admission_no: "ADM. NO",
                class: "CLASS",
                no_in_class: "NO IN CLASS",
                school_open: "NO OF TIMES SCHOOL OPENED",
                times_present: "NO OF TIMES PRESENT",
                times_absent: "NO OF TIMES ABSENT",
                next_term_begins: "NEXT TERM BEGINS",
            },
            summary: {
                total_score: "TOTAL SCORE",
                total_obtainable: "TOTAL OBTAINABLE",
                percentage: "PERCENTAGE",
                grade: "GRADE",
                score_range: "Score Range",
                grade_row: "Grade",
            },
            titles: {
                term_title: "{term} TERM {session} ACADEMIC SESSION",
                custom_report_title: "{report_name} - {term} {session}",
            },
        };
    }

    function normalizeTemplateLabels(labels) {
        const defaults = buildDefaultLabels();
        const source = labels && typeof labels === "object" ? labels : {};
        const hasGroupedLabels = Object.keys(defaults).some((group) => source[group] && typeof source[group] === "object");
        const groupedSource = hasGroupedLabels ? source : { columns: source };
        const normalized = {};

        Object.keys(defaults).forEach((group) => {
            normalized[group] = Object.assign({}, defaults[group]);
            if (!groupedSource[group] || typeof groupedSource[group] !== "object") {
                return;
            }

            Object.keys(defaults[group]).forEach((key) => {
                const label = groupedSource[group][key];
                if (String(label || "").trim() !== "") {
                    normalized[group][key] = String(label).trim();
                }
            });
        });

        return normalized;
    }

    function getDraftLabel(group, key, fallback) {
        return (draft.labels && draft.labels[group] && draft.labels[group][key]) || fallback || key;
    }

    function normalizeTemplate(template) {
        const base = defaultTemplate();
        const source = template && typeof template === "object" ? template : {};
        const sourceSections = Array.isArray(source.sections) ? source.sections : [];
        const sectionByKey = {};

        sourceSections.forEach((section) => {
            if (section && sectionLabels[section.key]) {
                sectionByKey[section.key] = {
                    key: section.key,
                    enabled: section.enabled !== false,
                    order: parseInt(section.order, 10) || 0,
                };
            }
        });

        base.sections = defaultSections.map((section) => {
            return sectionByKey[section.key] || Object.assign({}, section);
        });
        base.sections.sort((first, second) => first.order - second.order);
        base.fields = Object.assign({}, defaultFields, source.fields || {});
        base.score_columns = columnApi().normalizeColumns(source.score_columns || base.score_columns);
        base.template_name = source.template_name || base.template_name;
        base.labels = normalizeTemplateLabels(source.labels || base.labels);

        return base;
    }

    function isSectionEnabled(key) {
        return draft.sections.some((section) => section.key === key && section.enabled);
    }

    function renderToggles(containerSelector, labels, checkedValues, cssClass) {
        const html = Object.keys(labels)
            .map((key) => {
                const checked = checkedValues[key] ? "checked" : "";
                return `
                    <label class="report-template-toggle" for="${cssClass}_${escapeHtml(key)}">
                        <input type="checkbox" id="${cssClass}_${escapeHtml(key)}" class="${cssClass}" value="${escapeHtml(key)}" ${checked}>
                        <span>${escapeHtml(labels[key])}</span>
                    </label>
                `;
            })
            .join("");
        $(containerSelector).html(html);
    }

    function renderSections() {
        const checked = {};
        draft.sections.forEach((section) => {
            checked[section.key] = section.enabled;
        });
        renderToggles("#reportTemplateSections", sectionLabels, checked, "report-section-toggle");
    }

    function renderFields() {
        renderToggles("#reportTemplateFields", fieldLabels, draft.fields, "report-field-toggle");
    }

    function renderLabelEditor() {
        const groups = [
            { key: "titles", title: "Titles" },
            { key: "columns", title: "Score Table Columns" },
            { key: "sections", title: "Section Headings" },
            { key: "fields", title: "Student Detail Labels" },
            { key: "summary", title: "Summary / Scale Labels" },
        ];
        const defaults = buildDefaultLabels();
        const html = groups
            .map((group) => {
                const inputs = Object.keys(defaults[group.key])
                    .map((key) => {
                        return `
                            <div class="form-group mb-2">
                                <p class="p-0 mb-0 muted-text small">${escapeHtml(defaults[group.key][key])}</p>
                                <input type="text" class="form-control form-control-sm report-label-input" data-group="${escapeHtml(group.key)}" data-key="${escapeHtml(key)}" value="${escapeHtml(getDraftLabel(group.key, key, defaults[group.key][key]))}">
                            </div>
                        `;
                    })
                    .join("");

                return `
                    <div class="report-label-group">
                        <div class="report-template-panel-title">${escapeHtml(group.title)}</div>
                        ${inputs}
                    </div>
                `;
            })
            .join("");

        $("#reportTemplateLabels").html(html);
    }

    function renderColumns() {
        const selected = draft.score_columns;
        const availableHtml = columnApi().keys
            .filter((key) => !selected.includes(key))
            .map((key) => {
                return `
                    <span class="report-column-chip">
                        ${escapeHtml(getDraftLabel("columns", key, columnApi().getColumnLabel(key)))}
                        <button type="button" class="add-report-column" data-column="${escapeHtml(key)}" title="Add column">
                            <i class="fas fa-plus"></i>
                        </button>
                    </span>
                `;
            })
            .join("");

        const selectedHtml = selected
            .map((key, index) => {
                const isRequired = key === "subject";
                const removeButton = isRequired
                    ? ""
                    : `<button type="button" class="remove-report-column" data-column="${escapeHtml(key)}" title="Remove column"><i class="fas fa-times"></i></button>`;
                return `
                    <span class="report-column-chip ${isRequired ? "is-required" : ""}">
                        ${escapeHtml(getDraftLabel("columns", key, columnApi().getColumnLabel(key)))}
                        <button type="button" class="move-report-column" data-column="${escapeHtml(key)}" data-direction="left" title="Move left" ${index === 0 ? "disabled" : ""}>
                            <i class="fas fa-chevron-left"></i>
                        </button>
                        <button type="button" class="move-report-column" data-column="${escapeHtml(key)}" data-direction="right" title="Move right" ${index === selected.length - 1 ? "disabled" : ""}>
                            <i class="fas fa-chevron-right"></i>
                        </button>
                        ${removeButton}
                    </span>
                `;
            })
            .join("");

        $("#availableReportColumns").html(availableHtml || '<span class="text-muted small">All columns selected</span>');
        $("#selectedReportColumns").html(selectedHtml);
    }

    function renderPreview() {
        const headers = draft.score_columns
            .map((key) => `<th>${escapeHtml(getDraftLabel("columns", key, columnApi().getColumnLabel(key)))}</th>`)
            .join("");

        const sampleRows = [
            {
                subject: "Mathematics",
                ca1: "8",
                ca2: "9",
                ca3: "7",
                practical: "10",
                exam: "55",
                total: "89",
                percentage: "89%",
                grade: "A",
                first_term_total: "84",
                second_term_total: "86",
                third_term_total: "89",
                grand_total: "259",
                average: "86.3",
                class_average: "72.4",
                position: "2nd",
            },
            {
                subject: "English Language",
                ca1: "7",
                ca2: "8",
                ca3: "8",
                practical: "0",
                exam: "52",
                total: "75",
                percentage: "75%",
                grade: "B",
                first_term_total: "78",
                second_term_total: "80",
                third_term_total: "75",
                grand_total: "233",
                average: "77.7",
                class_average: "70.1",
                position: "5th",
            },
        ];

        const rows = sampleRows
            .map((row) => {
                const cells = draft.score_columns.map((key) => `<td>${escapeHtml(row[key] || "")}</td>`).join("");
                return `<tr>${cells}</tr>`;
            })
            .join("");

        const header = isSectionEnabled("school_header")
            ? `<div class="text-center mb-2"><strong>${draft.fields.school_name ? "School Name" : ""}</strong><div class="small text-muted">${draft.fields.school_address ? "School Address" : ""}</div><div class="font-weight-bold mt-2">${escapeHtml(getDraftLabel("titles", "term_title", "{term} TERM {session} ACADEMIC SESSION").replace("{term}", "THIRD").replace("{session}", "2024/2025"))}</div></div>`
            : "";
        const student = isSectionEnabled("student_details")
            ? `<div class="small mb-2">${draft.fields.student_name ? `<strong>${escapeHtml(getDraftLabel("fields", "student_name", "Student"))}:</strong> Sample Student ` : ""}${draft.fields.class ? `<strong>${escapeHtml(getDraftLabel("fields", "class", "Class"))}:</strong> Basic 5 ` : ""}${draft.fields.admission_no ? `<strong>${escapeHtml(getDraftLabel("fields", "admission_no", "Adm No"))}:</strong> SS/001` : ""}</div>`
            : "";
        const footer = isSectionEnabled("comments")
            ? `<div class="small mt-2">${draft.fields.teacher_comment ? "<strong>Teacher Comment:</strong> Good performance. " : ""}${draft.fields.head_teacher_comment ? "<strong>Head Teacher:</strong> Keep it up." : ""}</div>`
            : "";

        $("#reportTemplatePreview").html(`
            ${header}
            ${student}
            <table class="table table-sm table-bordered">
                <thead><tr>${headers}</tr></thead>
                <tbody>${rows}</tbody>
            </table>
            ${footer}
        `);
    }

    function renderAll() {
        $("#reportTemplateName").val(draft.template_name);
        renderSections();
        renderFields();
        renderLabelEditor();
        renderColumns();
        renderPreview();
    }

    function applyTemplateRowToEditor(templateRow, asCopy) {
        const termId = templateRow.term_id || "default";
        const exactMatch = isExactTemplateMatch(templateRow, termId);

        $("#reportTemplateTerm").val(termId);
        draft = normalizeTemplate(templateRow.template_json);
        draft.template_name = templateRow.template_name || draft.template_name;
        $("#reportTemplateId").val(!asCopy && exactMatch ? templateRow.id || "" : "");
        $("#reportTemplateStatus").val(String(templateRow.status == null ? 1 : templateRow.status));
        $("#reportTemplateDefault").prop("checked", !asCopy && exactMatch && String(templateRow.is_default || "0") === "1");

        if (asCopy) {
            draft.template_name = `${draft.template_name} Copy`;
            $("#reportTemplateStatus").val("1");
            $("#reportTemplateDefault").prop("checked", false);
        }

        renderAll();
        setStatus(asCopy || !exactMatch ? "Loaded as a copy." : "Loaded saved format.", "success");
    }

    function renderTemplateList() {
        const html = templateList
            .map((templateRow) => {
                const statusText = String(templateRow.status || "0") === "1" ? "Active" : "Inactive";
                const statusClass = String(templateRow.status || "0") === "1" ? "" : "is-off";
                const defaultBadge = String(templateRow.is_default || "0") === "1" ? '<span class="report-template-list-badge">Default</span>' : "";
                const archiveLabel = String(templateRow.status || "0") === "1" ? "Archive" : "Restore";
                const nextStatus = String(templateRow.status || "0") === "1" ? 0 : 1;

                return `
                    <div class="report-template-list-item" data-id="${escapeHtml(templateRow.id)}">
                        <div>
                            <div class="report-template-list-title">${escapeHtml(templateRow.template_name || "Report Card")}</div>
                            <div class="report-template-list-meta">
                                <span class="report-template-list-badge">${escapeHtml(getTermLabel(templateRow.term_id))}</span>
                                <span class="report-template-list-badge">All Sessions</span>
                                <span class="report-template-list-badge ${statusClass}">${statusText}</span>
                                ${defaultBadge}
                            </div>
                        </div>
                        <div class="report-template-list-actions">
                            <button type="button" class="btn btn-sm btn-outline-primary edit-report-template" data-id="${escapeHtml(templateRow.id)}">Edit</button>
                            <button type="button" class="btn btn-sm btn-outline-danger toggle-report-template-status" data-id="${escapeHtml(templateRow.id)}" data-status="${nextStatus}">${archiveLabel}</button>
                            <button type="button" class="btn btn-sm btn-danger delete-report-template" data-id="${escapeHtml(templateRow.id)}">Delete</button>
                        </div>
                    </div>
                `;
            })
            .join("");

        $("#reportTemplateList").html(html || '<span class="text-muted small">No saved formats yet.</span>');
    }

    function fetchTemplateList() {
        $.ajax({
            url: "../report_controller.php",
            type: "POST",
            dataType: "json",
            data: {
                action: "fetch_report_templates",
            },
            success: function (response) {
                templateList = response.status === "success" && Array.isArray(response.data) ? response.data : [];
                renderTemplateList();
            },
            error: function () {
                templateList = [];
                renderTemplateList();
            },
        });
    }

    function collectDraftFromForm() {
        const sections = [];
        $(".report-section-toggle").each(function (index) {
            sections.push({
                key: $(this).val(),
                enabled: $(this).is(":checked"),
                order: index + 1,
            });
        });

        const fields = {};
        $(".report-field-toggle").each(function () {
            fields[$(this).val()] = $(this).is(":checked");
        });

        draft.template_name = $("#reportTemplateName").val().trim() || "Report Card";
        draft.sections = sections;
        draft.fields = fields;
        draft.score_columns = columnApi().normalizeColumns(draft.score_columns);
        $(".report-label-input").each(function () {
            const group = $(this).data("group");
            const key = $(this).data("key");
            if (!draft.labels[group]) {
                draft.labels[group] = {};
            }
            draft.labels[group][key] = $(this).val().trim() || buildDefaultLabels()[group][key];
        });
        draft.labels = normalizeTemplateLabels(draft.labels);

        return normalizeTemplate(draft);
    }

    function loadTemplate() {
        const termId = $("#reportTemplateTerm").val() || "default";

        setStatus("Loading format...", "");
        $.ajax({
            url: "../report_controller.php",
            type: "POST",
            dataType: "json",
            data: {
                action: "fetch_report_template",
                term_id: termId,
            },
            success: function (response) {
                if (response.status !== "success") {
                    setStatus(response.message || "Could not load format.", "error");
                    return;
                }

                const data = response.data || {};
                const isExactMatch = isExactTemplateMatch(data, termId);
                draft = normalizeTemplate(data.template_json);
                draft.template_name = data.template_name || draft.template_name;
                $("#reportTemplateId").val(isExactMatch ? data.id || "" : "");
                $("#reportTemplateStatus").val(String(data.status == null ? 1 : data.status));
                $("#reportTemplateDefault").prop("checked", isExactMatch && String(data.is_default || "0") === "1");
                renderAll();
                setStatus(isExactMatch ? "Loaded saved school-wide format." : "Loaded default format. Saving will create a school-wide format.", "success");
            },
            error: function () {
                draft = defaultTemplate();
                renderAll();
                setStatus("Could not load saved format. Default format is ready.", "error");
            },
        });
    }

    function saveTemplate() {
        const payload = collectDraftFromForm();
        setStatus("Saving format...", "");

        $.ajax({
            url: "../report_controller.php",
            type: "POST",
            dataType: "json",
            data: {
                action: "save_report_template",
                id: $("#reportTemplateId").val(),
                term_id: $("#reportTemplateTerm").val() || "default",
                template_name: payload.template_name,
                template_json: JSON.stringify(payload),
                is_default: $("#reportTemplateDefault").is(":checked") ? 1 : 0,
                status: $("#reportTemplateStatus").val() || 1,
            },
            success: function (response) {
                if (response.status === "success") {
                    $("#reportTemplateId").val(response.id || "");
                    setStatus("Format saved.", "success");
                    fetchTemplateList();
                } else {
                    setStatus(response.message || "Format could not be saved.", "error");
                }
            },
            error: function () {
                setStatus("Format could not be saved.", "error");
            },
        });
    }

    function applyPreset(presetKey) {
        const preset = presets[presetKey];
        if (!preset) {
            return;
        }

        $(".report-template-preset").removeClass("active");
        $(`.report-template-preset[data-preset="${presetKey}"]`).addClass("active");
        draft.template_name = preset.name;
        draft.score_columns = columnApi().normalizeColumns(preset.columns);
        renderAll();
        setStatus("Preset applied to draft.", "success");
    }

    function moveColumn(column, direction) {
        const index = draft.score_columns.indexOf(column);
        if (index < 0) {
            return;
        }

        const targetIndex = direction === "left" ? index - 1 : index + 1;
        if (targetIndex < 0 || targetIndex >= draft.score_columns.length) {
            return;
        }

        const nextColumns = draft.score_columns.slice();
        nextColumns[index] = nextColumns[targetIndex];
        nextColumns[targetIndex] = column;
        draft.score_columns = columnApi().normalizeColumns(nextColumns);
        renderColumns();
        renderPreview();
    }

    function bindEvents() {
        $("#reportTemplateTerm").on("change", loadTemplate);
        $("#loadReportTemplate").on("click", loadTemplate);
        $("#refreshReportTemplates").on("click", fetchTemplateList);

        $("#singleSessionValue").on("change", loadTemplate);
        $(document).on("click", ".term_setting", function () {
            const termId = $(this).data("name");
            setTimeout(function () {
                if (termId) {
                    $("#reportTemplateTerm").val(String(termId));
                }
                loadTemplate();
            }, 100);
        });
        $(document).on("click", ".report-custom-term-setting", function () {
            const termId = $(this).data("name");
            if (termId) {
                $("#reportTemplateTerm").val(String(termId));
            }
            loadTemplate();
        });

        $("#saveReportTemplate").on("click", saveTemplate);

        $("#resetReportTemplateDraft").on("click", function () {
            draft = defaultTemplate();
            $("#reportTemplateId").val("");
            $("#reportTemplateStatus").val("1");
            $("#reportTemplateDefault").prop("checked", false);
            renderAll();
            setStatus("Draft reset.", "success");
        });

        $(document).on("click", ".report-template-preset", function () {
            applyPreset($(this).data("preset"));
        });

        $(document).on("change", ".report-section-toggle, .report-field-toggle", function () {
            collectDraftFromForm();
            renderPreview();
        });

        $(document).on("input", ".report-label-input", function () {
            const group = $(this).data("group");
            const key = $(this).data("key");
            if (!draft.labels[group]) {
                draft.labels[group] = {};
            }
            draft.labels[group][key] = $(this).val().trim() || buildDefaultLabels()[group][key];
            renderColumns();
            renderPreview();
        });

        $("#reportTemplateName").on("input", function () {
            draft.template_name = $(this).val();
        });

        $(document).on("click", ".add-report-column", function () {
            const column = $(this).data("column");
            if (!draft.score_columns.includes(column)) {
                draft.score_columns.push(column);
            }
            draft.score_columns = columnApi().normalizeColumns(draft.score_columns);
            renderColumns();
            renderPreview();
        });

        $(document).on("click", ".remove-report-column", function () {
            const column = $(this).data("column");
            draft.score_columns = draft.score_columns.filter((item) => item !== column);
            draft.score_columns = columnApi().normalizeColumns(draft.score_columns);
            renderColumns();
            renderPreview();
        });

        $(document).on("click", ".move-report-column", function () {
            moveColumn($(this).data("column"), $(this).data("direction"));
        });

        $(document).on("click", ".edit-report-template", function () {
            const templateId = String($(this).data("id"));
            const templateRow = templateList.find((item) => String(item.id) === templateId);
            if (!templateRow) {
                setStatus("Could not find that saved format.", "error");
                return;
            }

            applyTemplateRowToEditor(templateRow, false);
        });

        $(document).on("click", ".toggle-report-template-status", function () {
            const templateId = $(this).data("id");
            const status = $(this).data("status");

            $.ajax({
                url: "../report_controller.php",
                type: "POST",
                dataType: "json",
                data: {
                    action: "set_report_template_status",
                    id: templateId,
                    status,
                },
                success: function (response) {
                    if (response.status === "success") {
                        setStatus(status == 1 ? "Format restored." : "Format archived.", "success");
                        fetchTemplateList();
                    } else {
                        setStatus(response.message || "Could not update format.", "error");
                    }
                },
                error: function () {
                    setStatus("Could not update format.", "error");
                },
            });
        });

        $(document).on("click", ".delete-report-template", function () {
            const templateId = $(this).data("id");
            if (!confirm("Permanently delete this report format?")) {
                return;
            }

            $.ajax({
                url: "../report_controller.php",
                type: "POST",
                dataType: "json",
                data: {
                    action: "delete_report_template",
                    id: templateId,
                },
                success: function (response) {
                    if (response.status === "success") {
                        if (String($("#reportTemplateId").val()) === String(templateId)) {
                            $("#reportTemplateId").val("");
                        }
                        setStatus("Format permanently deleted.", "success");
                        fetchTemplateList();
                        loadTemplate();
                    } else {
                        setStatus(response.message || "Could not delete format.", "error");
                    }
                },
                error: function () {
                    setStatus("Could not delete format.", "error");
                },
            });
        });
    }

    function init() {
        if (!$("#reportTemplateBuilder").length) {
            return;
        }

        const activeTerm = $(".term_setting.active").data("name");
        if (activeTerm) {
            $("#reportTemplateTerm").val(String(activeTerm));
        }

        draft = defaultTemplate();
        renderAll();
        bindEvents();
        loadTemplate();
        fetchTemplateList();
    }

    $(init);

    window.ReportTemplateBuilder = {
        defaultTemplate,
        normalizeTemplate,
        presets,
    };
})(window, jQuery);
