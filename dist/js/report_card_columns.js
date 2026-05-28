(function (window) {
    const registry = {
        subject: {
            label: "Subjects",
            group: "identity",
            required: true,
            source: "subject",
        },
        ca1: {
            label: "CA1",
            group: "assessment",
            scoreField: "CA1",
            maxField: "ca1Total",
            legacyAssessment: "ca1",
        },
        ca2: {
            label: "CA2",
            group: "assessment",
            scoreField: "CA2",
            maxField: "ca2Total",
            legacyAssessment: "ca2",
        },
        ca3: {
            label: "CA3",
            group: "assessment",
            scoreField: "CA3",
            maxField: "ca3Total",
            legacyAssessment: "ca3",
        },
        practical: {
            label: "Practical",
            group: "assessment",
            scoreField: "Practical",
            maxField: "praTotal",
            legacyAssessment: "practical",
        },
        exam: {
            label: "Exam",
            group: "assessment",
            scoreField: "Exam",
            maxField: "exaTotal",
            legacyAssessment: "exam",
        },
        total: {
            label: "Total",
            group: "summary",
            resolver: "current_term_total",
        },
        percentage: {
            label: "Total(%)",
            group: "summary",
            resolver: "percentage",
        },
        grade: {
            label: "Grade",
            group: "summary",
            resolver: "grade",
        },
        first_term_total: {
            label: "1st Term Total",
            group: "cumulative",
            resolver: "first_term_total",
        },
        second_term_total: {
            label: "2nd Term Total",
            group: "cumulative",
            resolver: "second_term_total",
        },
        third_term_total: {
            label: "3rd Term Total",
            group: "cumulative",
            resolver: "third_term_total",
        },
        grand_total: {
            label: "Grand Total",
            group: "cumulative",
            resolver: "grand_total",
        },
        average: {
            label: "Average",
            group: "cumulative",
            resolver: "average",
        },
        class_average: {
            label: "Class Average",
            group: "comparison",
            resolver: "class_average",
        },
        position: {
            label: "Position",
            group: "comparison",
            resolver: "position",
        },
    };

    const defaultColumns = [
        "subject",
        "ca1",
        "ca2",
        "ca3",
        "practical",
        "exam",
        "total",
        "percentage",
        "grade",
    ];

    const cumulativeColumns = [
        "first_term_total",
        "second_term_total",
        "third_term_total",
        "grand_total",
        "average",
        "class_average",
        "position",
    ];

    function normalizeColumns(columns) {
        const allowedColumns = Object.keys(registry);
        const normalizedColumns = [];

        if (Array.isArray(columns)) {
            columns.forEach((column) => {
                if (allowedColumns.includes(column) && !normalizedColumns.includes(column)) {
                    normalizedColumns.push(column);
                }
            });
        }

        if (normalizedColumns.length === 0) {
            return defaultColumns.slice();
        }

        return ["subject"].concat(normalizedColumns.filter((column) => column !== "subject"));
    }

    function getColumnLabel(columnKey) {
        return registry[columnKey] ? registry[columnKey].label : columnKey;
    }

    function mapLegacyAssessment(assessmentType) {
        const normalizedAssessment = String(assessmentType || "").trim().toLowerCase();
        const match = Object.keys(registry).find((key) => registry[key].legacyAssessment === normalizedAssessment);
        return match || "";
    }

    window.ReportCardColumns = {
        registry,
        defaultColumns,
        cumulativeColumns,
        keys: Object.keys(registry),
        normalizeColumns,
        getColumnLabel,
        mapLegacyAssessment,
    };
})(window);
