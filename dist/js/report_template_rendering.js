(function (window, $) {
    const standardColumns = [
        { key: "subject", label: "Subjects" },
        { key: "ca1", label: "CA1" },
        { key: "ca2", label: "CA2" },
        { key: "ca3", label: "CA3" },
        { key: "practical", label: "Practical" },
        { key: "exam", label: "Exam" },
        { key: "total", label: "Total" },
        { key: "percentage", label: "Total(%)" },
        { key: "grade", label: "Grade" },
    ];

    const cumulativeColumns = [
        { key: "subject", label: "Subjects" },
        { key: "ca1", label: "CA1" },
        { key: "ca2", label: "CA2" },
        { key: "ca3", label: "CA3" },
        { key: "practical", label: "Practical" },
        { key: "exam", label: "Exam" },
        { key: "first_term_total", label: "1st Term Total" },
        { key: "second_term_total", label: "2nd Term Total" },
        { key: "third_term_total", label: "3rd Term Total" },
        { key: "grand_total", label: "Grand Total" },
        { key: "average", label: "Average" },
        { key: "percentage", label: "Total(%)" },
        { key: "grade", label: "Grade" },
    ];
    const cumulativeColumnKeys = [
        "first_term_total",
        "second_term_total",
        "third_term_total",
        "grand_total",
        "average",
        "class_average",
        "position",
    ];

    function escapeHtml(value) {
        return String(value || "")
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }

    function parseTemplateColumns(reportCard) {
        let columns = reportCard.attr("data-template-columns") || "[]";
        try {
            columns = JSON.parse(columns);
        } catch (error) {
            columns = [];
        }

        return Array.isArray(columns) && columns.length ? columns : standardColumns.map((column) => column.key);
    }

    function parseTemplateLabels(reportCard) {
        let labels = reportCard.attr("data-template-labels") || "{}";
        try {
            labels = JSON.parse(labels);
        } catch (error) {
            labels = {};
        }
        if (!labels || typeof labels !== "object") {
            return {};
        }

        const hasGroupedLabels = ["columns", "sections", "fields", "summary", "titles"].some((group) => labels[group] && typeof labels[group] === "object");
        return hasGroupedLabels ? labels : { columns: labels };
    }

    function templateColumnLabel(labels, key, fallback) {
        if (labels.columns && labels.columns[key]) {
            return labels.columns[key];
        }
        return fallback || key;
    }

    function templateHasCumulativeColumns(reportCard) {
        return parseTemplateColumns($(reportCard)).some((column) => cumulativeColumnKeys.includes(column));
    }

    function getReportTemplateTableMode(reportCard, termId, sessionOrTerm) {
        if (!templateHasCumulativeColumns(reportCard)) {
            return "standard";
        }

        if (sessionOrTerm === "session" || String(termId) === "3" || String(termId) === "cum") {
            return "full_cumulative";
        }

        if (String(termId) === "2") {
            return "second_term_cumulative";
        }

        return "standard";
    }

    function templateOrder(columns, availableColumns) {
        const availableKeys = availableColumns.map((column) => column.key);
        const ordered = columns.filter((key) => availableKeys.includes(key));
        return ordered.length ? ordered : availableKeys;
    }

    function rebuildRows(table, orderedColumns, sourceColumns) {
        const indexByKey = {};
        sourceColumns.forEach((column, index) => {
            indexByKey[column.key] = index;
        });

        table.find("tbody tr").each(function () {
            const row = $(this);
            const cells = row.children("td").detach();
            orderedColumns.forEach((key) => {
                const sourceIndex = indexByKey[key];
                if (sourceIndex !== undefined && cells.eq(sourceIndex).length) {
                    row.append(cells.eq(sourceIndex));
                }
            });
        });
    }

    function rebuildSimpleTable(table, columns, sourceColumns, labels) {
        const orderedColumns = templateOrder(columns, sourceColumns);
        const indexByKey = {};
        sourceColumns.forEach((column, index) => {
            indexByKey[column.key] = index;
        });

        const headRow = table.find("thead tr").first();
        const headings = headRow.children("th").detach();
        orderedColumns.forEach((key) => {
            const sourceIndex = indexByKey[key];
            if (sourceIndex !== undefined && headings.eq(sourceIndex).length) {
                const heading = headings.eq(sourceIndex);
                const column = sourceColumns.find((item) => item.key === key);
                heading.text(templateColumnLabel(labels, key, column ? column.label : heading.text()));
                headRow.append(heading);
            }
        });
        rebuildRows(table, orderedColumns, sourceColumns);
    }

    function rebuildCumulativeTable(table, columns, labels) {
        const sourceColumns = [{ key: "subject", label: "Subjects" }];
        const leafHeaders = table
            .find("thead tr:last th")
            .map(function () {
                return $(this).text().trim();
            })
            .get();
        const leafColumnMap = {
            CA1: "ca1",
            CA2: "ca2",
            CA3: "ca3",
            Practical: "practical",
            Exam: "exam",
            "1st": "first_term_total",
            "2nd": "second_term_total",
            "3rd": "third_term_total",
        };

        leafHeaders.forEach((label) => {
            const key = leafColumnMap[label];
            const column = cumulativeColumns.find((item) => item.key === key);
            if (column) {
                sourceColumns.push(column);
            }
        });
        ["grand_total", "average", "percentage", "grade"].forEach((key) => {
            const column = cumulativeColumns.find((item) => item.key === key);
            if (column) {
                sourceColumns.push(column);
            }
        });
        const orderedColumns = templateOrder(columns, sourceColumns);
        const headerHtml = orderedColumns
            .map((key) => {
                const column = sourceColumns.find((item) => item.key === key);
                return column ? `<th>${escapeHtml(templateColumnLabel(labels, key, column.label))}</th>` : "";
            })
            .join("");

        table.find("thead").html(`<tr>${headerHtml}</tr>`);
        rebuildRows(table, orderedColumns, sourceColumns);
    }

    function applyReportTemplateToRenderedTable(reportCard) {
        const card = $(reportCard);
        if (!card.length) {
            return;
        }

        const columns = parseTemplateColumns(card);
        const labels = parseTemplateLabels(card);
        card.find("#view_student_score_table").each(function () {
            rebuildSimpleTable($(this), columns, standardColumns, labels);
        });
        card.find("[id^='cumulative_student_score_table_']").each(function () {
            rebuildCumulativeTable($(this), columns, labels);
        });
    }

    window.applyReportTemplateToRenderedTable = applyReportTemplateToRenderedTable;
    window.getReportTemplateTableMode = getReportTemplateTableMode;
    window.reportTemplateHasCumulativeColumns = templateHasCumulativeColumns;
})(window, jQuery);
