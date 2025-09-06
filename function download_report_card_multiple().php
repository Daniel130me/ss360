function download_report_card_multiple() {
    // alert('jjjjj')
    // document.getElementById('preview-pdf').addEventListener('click', function() {
    $.ajax({
        url: 'single_report_card.php',
        type: 'POST',
        data: {
            "studentid": $("#select_student_field").val(),
            "classid": $("#select_class_field").val(),
            "sessionid": $("#select_session_field").val(),
            "termid": $(".select_btn.term.active").attr("data-name"),
            // "data": student_score_data,
            // settingsData,
        },
        beforeSend: () => {
            $("#preview_report_card_modal").modal("show")
            $("#pdf-content").html(
                `<div id="skeleton-loader" class="skeleton-loader align-items-center">
                <div class="skeleton-line skeleton-photo"></div>
                <div class="skeleton-line skeleton-input w-75"></div>
                <div class="skeleton-line skeleton-input"></div>
                <div class="skeleton-line skeleton-input"></div>
                <div class="skeleton-line skeleton-input"></div>
                <div class="skeleton-line skeleton-button"></div>
            </div>`)
        },
        success: (data) => {
            data = data.trim();
            $("#pdf-content").html(data)
            $("#preview_report_card_foot").show()
            format_student_table_report(student_score_data, $(".select_btn.term.active").attr("data-name"), $("#select_session_field").val(), $("#select_class_field").val())

            setTimeout(() => {
                set_behaviour_comment($(".select_btn.term.active").attr("data-name"), $("#select_session_field").val(), $("#select_student_field").val(),  $("#select_class_field").val(), 'view');
                setTimeout(() => {
                    const element = document.querySelector('.report-card');
                    const opt = {
                        margin: 3, // Set margins [top, left, bottom, right]
                        filename: 'Report_Card.pdf',
                        image: {
                            type: 'jpeg',
                            quality: 0.98
                        },
                        html2canvas: {
                            scale: 2
                        }, // Scale can be adjusted (2 is default; lower values reduce the size)
                        jsPDF: {
                            unit: 'mm',
                            format: 'a4',
                            orientation: 'portrait'
                        }
                    };
                    html2pdf().from(element).set(opt).save();
                    alert("ll")
                }, 200);
            }, 200)


        }
    })
    // Select the section of the page you want to convert to PDF
    // });
}