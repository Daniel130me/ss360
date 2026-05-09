// var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
// (function(){
// var s1=document.createElement("script"),s0=document.getElementsByTagName("script")[0];
// s1.async=true;
// s1.src='https://embed.tawk.to/67b7c05426ddae190981fa83/1ikiseijf';
// s1.charset='UTF-8';
// s1.setAttribute('crossorigin','*');
// s0.parentNode.insertBefore(s1,s0);
// })();

// ;(function registerServiceWorker(){
//   if (!('serviceWorker' in navigator)) return;
//   // Avoid registering multiple times in noisy environments
//   if (window.__SS360_SW_REGISTERED) return;
//   window.__SS360_SW_REGISTERED = true;

//   navigator.serviceWorker.register('/sw.js?v=4').then(reg => {
//     console.log('SS360: Service Worker registered', reg);

//     // After registration, request the service worker to precache common CDN assets
//     // but do this during idle time to avoid impacting page load.
//     const cdnAssets = [
//       'https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback',
//       'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200',
//       'https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/css/select2.min.css',
//       'https://cdn.jsdelivr.net/npm/select2@4.1.0-beta.1/dist/js/select2.min.js',
//       'https://cdnjs.cloudflare.com/ajax/libs/summernote/0.9.1/summernote-bs4.min.css',
//       'https://cdnjs.cloudflare.com/ajax/libs/summernote/0.9.1/summernote-bs4.min.js',
//       'https://cdnjs.cloudflare.com/ajax/libs/mathquill/0.10.1/mathquill.min.css',
//       'https://cdnjs.cloudflare.com/ajax/libs/mathquill/0.10.1/mathquill.min.js'
//     ];


//     function sendPrecacheMessage() {
//       try {
//         if (navigator.serviceWorker.controller) {
//           navigator.serviceWorker.controller.postMessage({type: 'precache', urls: cdnAssets});
//         } else if (reg.waiting) {
//           reg.waiting.postMessage({type: 'precache', urls: cdnAssets});
//         } else if (reg.installing) {
//           // Wait until installed/activated
//           const track = setInterval(() => {
//             if (navigator.serviceWorker.controller) {
//               navigator.serviceWorker.controller.postMessage({type: 'precache', urls: cdnAssets});
//               clearInterval(track);
//             }
//           }, 500);
//           setTimeout(() => clearInterval(track), 10000);
//         }
//       } catch (e) {
//         console.warn('SS360: precache message failed', e);
//       }
//     }

//     // Schedule precache during idle time, fallback to setTimeout
//     if ('requestIdleCallback' in window) {
//       requestIdleCallback(sendPrecacheMessage, {timeout: 5000});
//     } else {
//       // Give the page 3s to finish loading critical tasks, then prefetch
//       setTimeout(sendPrecacheMessage, 3000);
//     }

//   }).catch(err => {
//     console.warn('SS360: SW register failed', err);
//   });
// })();
function get_billing_data() {
    let student_id = $('#select_student_field').val();
    let term_id = $('.term.select_btn.active').attr('data-name');
    let session_id = $('#select_session_field').val();
    let class_id = $('#select_class_field').val();
    // show a lightweight loading state inside the existing payment card
    var $body = $('#payment_card').find('.card-body');
    if ($body.length === 0) {
        // fallback: try to replace entire card if inner wrapper missing
        $body = $('#payment_card');
    }
    $body.html('<div class="text-center p-3"><i class="fas fa-spinner fa-spin"></i><p class="mb-0 mt-2">Loading billing information&hellip;</p></div>');

    $.ajax({
        url: '../billing_controller.php',
        type: 'POST',
        data: {
            action: 'get_parent_billing',
            student_id,
            term_id,
            session_id,
            class_id
        },
        dataType: 'json',
        success: function (response) {
            if (response && response.success) {
                // Safely parse numbers and format with thousand separators
                var due = parseFloat(response.amount_due) || 0;
                var paid = parseFloat(response.total_amount_paid) || 0;
                var balance = isNaN(parseFloat(response.balance)) ? (due - paid) : parseFloat(response.balance);

                var fmt = function (n) {
                    try {
                        return Number(n).toLocaleString('en-US', { minimumFractionDigits: 0, maximumFractionDigits: 0 });
                    } catch (e) {
                        return n;
                    }
                };

                var html = '';
                html += '<div class="d-flex align-items-center mb-2">';
                html += '    <span class="material-symbols-outlined text-danger mr-2">request_quote</span>';
                html += '    <p class="mb-0">Amount due: <span class="font-weight-bold">' + fmt(due) + '</span></p>';
                html += '</div>';
                html += '<div class="d-flex align-items-center mb-2">';
                html += '    <span class="material-symbols-outlined text-success mr-2">price_check</span>';
                html += '    <p class="mb-0">Amount paid: <span class="font-weight-bold">' + fmt(paid) + '</span></p>';
                html += '</div>';
                html += '<div class="d-flex align-items-center mb-3">';
                html += '    <span class="material-symbols-outlined text-warning mr-2">account_balance_wallet</span>';
                html += '    <p class="mb-0">Balance: <span class="font-weight-bold">' + fmt(balance) + '</span></p>';
                html += '</div>';
                html += '<button type="button" class="btn btn-sm btn-outline-primary w-100" onclick="payment_breakdown_modal()">';
                html += '    <span class="material-symbols-outlined" style="font-size: 1.2em; vertical-align: middle;">visibility</span>';
                html += '    See payment breakdown';
                html += '</button>';

                $body.html(html);
            } else {
                var msg = (response && response.message) ? response.message : 'No billing data available.';
                $body.html('<p class="text-muted text-center p-3">' + msg + '</p>');
            }
        },
        error: function (xhr, status, err) {
            $body.html('<p class="text-danger text-center p-3">Error fetching billing data.</p>');
            console.error('get_billing_data error:', status, err, xhr && xhr.responseText);
        }
    });
}
// alert("cats")
// function payment_breakdown_modal() {
//     // Show modal and loading state
//     $('#payment-breakdown-content').html('<div class="text-center py-4"><div class="spinner-border" role="status" aria-hidden="true"></div><div class="mt-2">Loading payment details&hellip;</div></div>');
//     $('#payment_breakdown_modal').modal('show');

//     // gather selection
//     let student_id = $('#select_student_field').val();
//     let term_id = $('.term.select_btn.active').attr('data-name') || '';
//     let session_id = $('#select_session_field').val() || '';
//     let class_id = $('#select_class_field').val() || '';

//     if (!student_id || !term_id || !session_id) {
//         $('#payment-breakdown-content').html('<p class="text-danger">Please select student, term and session.</p>');
//         return;
//     }

//     function escapeHtml(str) {
//         if (str === null || str === undefined) return '';
//         return String(str).replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&#39;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
//     }

//     $.ajax({
//         url: '../billing_controller.php',
//         type: 'POST',
//         dataType: 'json',
//         data: {
//             action: 'get_payment_breakdown',
//             student_id: student_id,
//             term_id: term_id,
//             session_id: session_id,
//             class_id: class_id
//         },
//         success: function (resp) {
//             if (!resp || !resp.success) {
//                 $('#payment-breakdown-content').html('<p class="text-danger">Failed to load payment breakdown.</p>');
//                 return;
//             }

//             const data = resp.data || [];
//             if (data.length === 0) {
//                 $('#payment-breakdown-content').html('<p>No payments or bills found for the selected filters.</p>');
//                 return;
//             }

//             // Group by bill_id to create a timeline per bill
//             const grouped = {};
//             data.forEach(item => {
//                 const bid = item.bill_id || 'no-bill';
//                 if (!grouped[bid]) grouped[bid] = { bill_name: item.bill_name || ('Bill ' + bid), entries: [] };
//                 grouped[bid].entries.push(item);
//             });

//             let html = '';
//             Object.keys(grouped).forEach(bid => {
//                 const group = grouped[bid];
//                 html += `<div class="mb-4 p-3 border rounded">`;
//                 html += `<div class="d-flex justify-content-between align-items-start mb-2">`;
//                 html += `<div><strong>${escapeHtml(group.bill_name)}</strong></div>`;
//                 html += `</div>`;

//                 // timeline list
//                 html += '<ul class="list-unstyled mb-0">';
//                 // entries are expected ordered by date desc from server; normalize to desc
//                 group.entries.sort((a, b) => (b.date_paid || '') > (a.date_paid || '') ? 1 : -1);
//                 group.entries.forEach(entry => {
//                     const date = entry.date_paid || entry.datecreated || '';
//                     const amount = Number(entry.amount_newly_paid || 0);
//                     const total_paid = Number(entry.total_amount_paid || 0);
//                     const balance = Number(entry.balance || 0);
//                     const method = entry.payment_method || '';
//                     const desc = entry.description || '';

//                     html += `<li class="mb-2">`;
//                     html += `<div class="p-2 border rounded">`;
//                     html += `<div class="d-flex justify-content-between">`;
//                     html += `<div>`;
//                     html += `<div><strong>₦${amount.toLocaleString()}</strong></div>`;
//                     html += `<div class="small text-muted">${escapeHtml(desc)}${method ? ' — ' + escapeHtml(method) : ''}</div>`;
//                     html += `</div>`;
//                     html += `<div class="text-right small text-muted">${escapeHtml(date)}<div>Balance: ₦${balance.toLocaleString()}</div><div>Paid to date: ₦${total_paid.toLocaleString()}</div><a href="#paymentReceiptPreviewModal" class="float-right" data-toggle="modal" aria-expanded="false" data-bill_id="${entry.bill_id}" data-paymentid="${entry.id}" aria-controls="paymentReceiptPreviewModal">Preview Payment Receipt</a></div>`;
//                     html += `</div>`;
//                     html += `</div>`;
//                     html += `</li>`;
//                 });
//                 html += '</ul>';
//                 html += `</div>`;
//             });

//             $('#payment-breakdown-content').html(html);
//         },
//         error: function (xhr, status, err) {
//             console.error(err);
//             $('#payment-breakdown-content').html('<p class="text-danger">Error fetching payment breakdown.</p>');
//         }
//     });
// }
var student_score_data = [];
// get_score_data()

// function toggle_grade_type(event) {
//     alert('lll')
//     $(".select_btn.grade_type").removeClass("active")
//     $(event).addClass("active")
// }

function toggle_term_setting(event) {
    $(".select_btn.term_setting").removeClass("active")
    $(event).addClass("active")

    if ($("#settings_page").val() == "view_Settings") {
        $.ajax({
            url: "../controller.php",
            type: "post",
            data: { 'action': 'get_no_of_times_school_open', term_id: $(event).attr("data-name"), session_id: $("#singleSessionValue").val() },
            success: (data) => {
                data = JSON.parse(data)
                if (data.status == '1') {
                    $("#school_open").val(data.school_open || 0)
                }
            }
        })
    }
}
$(".url_upadter").submit(function (event) {

    event.preventDefault();
    var $form = $(this);
    let $btn = $form.find("#url_update_btn")
    let $btntext = $btn.html()
    var $url = $form.attr("action");
    let formdata = new FormData(this);
    $.ajax({
        url: $url,
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $($btn).attr("disabled", true)
            $($btn).html("Processing")
        },
        success: (data) => {
            $($btn).attr("disabled", false)
            $($btn).html($btntext)
            data = JSON.parse(data)
            if (data.status == '1') {
                // alert(data)
                toastr.success("Updated succesfully")
                // window.location = `./${data.location}`
            }
            else {
                toastr.error(data.err)
            }
        },
        error: (xhr, status, error) => {
            console.error('Error: ' + error);
        }
    });
})

function comm_means_toggle(event) {
    $(".select_btn.comm").removeClass("active")
    $(event).addClass("active")
    $("#send_to_box").hide()
    $("#reciepient_list").empty()
    $("#reciepient_email_list").val('')
    $("#reciepient_type").val('').trigger('change')
    if ($("#email_select").hasClass("active")) {
        $("#email_comm_btn").show()
        $("#message_comm_btn").hide()
        $("#email_subject_comm").show()
        $("#int_message_comm_btn").hide()
    } else if ($("#message_select").hasClass("active")) {
        $("#email_comm_btn").hide()
        $("#message_comm_btn").show()
        $("#email_subject_comm").hide()
        $("#int_message_comm_btn").hide()
    }
    else if ($("#int_message_select").hasClass("active")) {
        $("#email_comm_btn").hide()
        $("#message_comm_btn").hide()
        $("#int_message_comm_btn").show()
        $("#email_subject_comm").hide()
    }
}

function get_notices(userid, usertype) {
    let str = '';
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: { action: 'get_msg', usertype, userid, },
        success: (resp) => {
            console.log(resp)
            resp = JSON.parse(resp)
            if (resp.status == '1') {
                data = resp.data
                console.log(data)
                data.map(item => {
                    Object.entries(item).forEach(([key, value]) => {
                        str += `
                        <div class="each_message_notice">
                            <p>${value}</p>
                            <a class="small btn btn-sm" style="color:#e74c3c;" onclick="remove_msg(${key},'${userid}','${usertype}')"><i class="fas fa-minus mr-2"> Remove</i></a>
                        </div>`
                    })
                })
                // console.log(str)
                $("#notice_comm").html(str)
            } else {
                $("#notice_comm").html('<i>No messages yet</i>')

            }
        }
    })
}
function remove_msg(id, userid, usertype) {
    // alert(userid,usertype)
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: { action: 'delete_int_msg', id, },
        success: (data) => {
            get_notices(userid, usertype)
        }
    })
}

// document.querySelectorAll('tbody tr').forEach(row => {
//     let totalScore = 0;
//     let totalPossible = 0;

//     row.querySelectorAll('.score').forEach(cell => {
//         if (!cell.classList.contains('d-none')) {
//             const score = parseInt(cell.dataset.score);
//             const maxScore = parseInt(cell.dataset.maxScore);

//             if (!isNaN(score) && !isNaN(maxScore)) {
//                 totalScore += score;
//                 totalPossible += maxScore;
//             }
//         }
//     });
//     let percentage_cal = (totalScore / totalPossible) * 100
//     const percentage = percentage_cal > 0 ? percentage_cal : 0;
//     console.log("Calculating grade for percentage:", percentage);
//     const grade = calculateGrade_database(percentage, gradingSystem);
//     console.log("Assigned Grade:", grade);

//     const totalScoreElement = row.querySelector('.total-score');
//     const percentageElement = row.querySelector('.percentage');
//     const gradeElement = row.querySelector('.gradeclass');

//     if (totalScoreElement) totalScoreElement.textContent = totalScore;
//     if (percentageElement) percentageElement.textContent = percentage.toFixed(0);
//     if (gradeElement) gradeElement.textContent = grade;
// });

// async function format_student_table_report(student_score_data, student_id, term, session_id, class_id, gradingSystem, generateit) {
//     // gradingSystem = JSON.parse(gradingSystem)
//     console.log("grade", gradingSystem)
//     let formattedString = gradingSystem.replace(/([A-Z]):/g, '"$1":').replace(/:/g, ': ');
//     gradingSystem = JSON.parse(formattedString)
//     // return
//     // student_score_data = JSON.parse(student_score_data)
//     // console.log("student", student_score_data)
//     // const nwdata1 = Object.entries(student_score_data).filter(item => item.term_id == term && item.session_id == session_id && item.class_id == class_id)
//     function calculateGrade1(percentage, gradingSystem) {
//         for (const grade in gradingSystem) {
//             console.log(grade)
//             if (percentage >= gradingSystem[grade]) {
//                 return grade;
//             }
//         }
//         return 'F'; // Default to 'F' if no grade matches
//     }



//     const nwdata = student_score_data.filter(item => item.term_id == term && item.session_id == session_id && item.class_id == class_id)
//     console.log("nw", nwdata)
//     let str = ''
//     if (nwdata.length > 0) {
//         str = `
// <table id="view_student_score_table" class="display nowrap" style="width:100%;">
//   <thead>
//       <tr>
//           <th>Subjects</th>
//           <th class="${settingsData.ca1 == 0 ? 'd-none' : ''}">CA1</th>
//           <th class="${settingsData.ca1 == 0 ? 'd-none' : ''}">CA2</th>
//           <th class="${settingsData.ca3 == 0 ? 'd-none' : ''}">CA3</th>
//           <th class="${settingsData.pra == 0 ? 'd-none' : ''}">Practical</th>
//           <th class="${settingsData.exa == 0 ? 'd-none' : ''}">Exam</th>
//       <th>Total</th>         
//           <th>Total(%)</th>
//           <th>Grade</th>
//       </tr>
//   </thead>
//   <tbody class="report_tbody">
// `;

//         // if () {
//         nwdata.forEach(item => {
//             console.log('subj', item.subject_id)
//             str += `
//   <tr>
//       <td>${item.subject}</td>
//       <td class="score ${settingsData.ca1 == 0 ? 'd-none' : ''}">${item.CA1}</td>
//       <td class="score ${settingsData.ca2 == 0 ? 'd-none' : ''}">${item.CA2}</td>
//       <td class="score ${settingsData.ca3 == 0 ? 'd-none' : ''}">${item.CA3}</td>
//       <td class="score ${settingsData.pra == 0 ? 'd-none' : ''}">${item.Practical}</td>
//       <td class="score ${settingsData.exa == 0 ? 'd-none' : ''}">${item.Exam}</td>
//       <td class="total-score">${item.Total}</td>
//       <td class="percentage">${get_subject_percentage(item.subject_id, term, session_id, class_id)}</td>
//       <td>${calculateGrade1(get_subject_percentage(item.subject_id, term, session_id, class_id), gradingSystem)}</td>
//   </tr>
// `
//             // }
//         });

//         str += `</tbody>
// </table>`;
//     }

//     document.querySelectorAll('tbody.report_tbody tr').forEach(row => {
//         let totalScore = 0;
//         let totalPossible = 0;
//         console.log(row)

//         row.querySelectorAll('tbody.report_tbody td.score').forEach(cell => {
//             console.log("the cell", cell)
//             if (!cell.classList.contains('d-none')) {
//                 const score = parseInt(cell.dataset.score);
//                 const maxScore = parseInt(cell.dataset.maxScore);

//                 if (!isNaN(score) && !isNaN(maxScore)) {
//                     totalScore += score;
//                     totalPossible += maxScore;
//                 }
//             }
//         });
//         let percentage_cal = (totalScore / totalPossible) * 100
//         const percentage = percentage_cal > 0 ? percentage_cal : 0;
//         console.log("Calculating grade for percentage:", percentage);
//         const grade = calculateGrade1(percentage, gradingSystem);
//         console.log("Assigned Grade:", grade);

//         const totalScoreElement = row.querySelector('.total-score');
//         const percentageElement = row.querySelector('.percentage');
//         const gradeElement = row.querySelector('.gradeclass');

//         if (totalScoreElement) totalScoreElement.textContent = totalScore;
//         if (percentageElement) percentageElement.textContent = percentage.toFixed(0);
//         if (gradeElement) gradeElement.textContent = grade;
//     });

//     $("#table_visuals_display_report").html(str);
//     // console.log($("#table_visuals_display_report").html())

//     await set_behaviour_comment(term, session_id, student_id, class_id, 'view')
//     setTimeout(generateit,5000)
// }
// alert("kkkk")

function calculateGrade1(percentage, gradingSystem) {
    for (const grade in gradingSystem) {
        if (percentage == 100) {
            return 'A';
        }
        else if (percentage >= gradingSystem[grade]) {
            return grade; // Return the matching key, no matter its name
        }

    }
    return Object.keys(gradingSystem).pop();
}
function format_grade(gradingSystem) {
    let formattedString = gradingSystem.replace(/([A-Z]):/g, '"$1":').replace(/:/g, ': ');
    return JSON.parse(formattedString)
}


function send_subject_info_to_modal(subjectId, sessionId) {
    // Set the value for the subject dropdown using the subjectId
    $('#termSubjectValue').val(subjectId).trigger('change');

    // Set the value for the session dropdown using the sessionId
    $('#singleSessionValue').val(sessionId).trigger('change');

    // Refresh Select2 to reflect the changes in the dropdowns
    $('#termSubjectValue').select2();
    $('#singleSessionValue').select2();
}

function check_result_toggle() {
    if ($("#table_visual_Score_toggle").hasClass("visuals")) {
        display_visual_score(student_score_data, $(".term.select_btn.active").attr("data-name"), $("#select_session_field").val(), $("#select_class_field").val())
    } else {
        format_student_table(student_score_data, $(".term.select_btn.active").attr("data-name"), $("#select_session_field").val(), $("#select_class_field").val())
    }
}
function table_visual_Score_toggle(event) {
    let btn = $(event)
    if (btn.hasClass("visuals")) {
        // let icon = $(element).find(".material-symbols-outlined").html()
        // if (icon == 'add_chart') {
        $(btn).removeClass("visuals").addClass("table_display")
        btn.html(`<i class="material-symbols-outlined mr-1">legend_toggle</i> Show Chart`)
        format_student_table(student_score_data, $(".term.select_btn.active").attr("data-name"), $("#select_session_field").val(), $("#select_class_field").val())
    } else {
        $(btn).removeClass("table_display").addClass("visuals")
        btn.html(`<i class="material-symbols-outlined mr-1">menu_open</i>Show Table`)
        display_visual_score(student_score_data, $(".term.select_btn.active").attr("data-name"), $("#select_session_field").val(), $("#select_class_field").val())
    }
}
// }
// $(document).ready(function() {
function comment_writing(greaterPercentage, lesserPercentage, term) {
    let icon, value, comment;
    value = Math.abs(greaterPercentage - lesserPercentage)
    if ((greaterPercentage - lesserPercentage) < 0) {
        icon = '<span class="text-danger"><i class="fas fa-arrow-down"></i></span>'
        return comment = icon + ' ' + value + '% less than ' + term;
    } else {
        icon = '<span class="text-success"><i class="fas fa-arrow-up"></i></span>'
        return comment = icon + ' ' + value + '% greater than ' + term;
    }
}
function display_session_charts(term1Percentage, term2Percentage, term3Percentage, sessionPercentage) {
    let comment1 = '';
    let color1, color = '';
    //first term
    if (term1Percentage >= 60 && term1Percentage <= 100) {
        comment1 = '<p>Excellent Perfomance</p>'
        color1 = '#198754';
    } else if (term1Percentage >= 40 && term1Percentage <= 60) {
        comment1 = '<p>Average Performance</p>'
        color1 = '#FF803D';
    } else if (term1Percentage >= 60 && term1Percentage <= 100) {
        comment1 = '<p>Needs Improvement</p>'
        color1 = '#FC5A5A';
    }

    // update_knob("knob1_value", term1Percentage)
    // $("#term1_percentage_based_comment").html(comment)
    $(".sessional_percentage_placeholder").html(sessionPercentage + "%")

    let str =
        `<div class="mb-3" style="width:163px;">
    <p>Session Perfomance</p>
    <h3 class="mb-0 sessional_percentage_placeholder" id="sessional_percentage_placeholder">${sessionPercentage}%</h3>
    </div>
    <div class="" id="score_chart-summary"></div>
    <div class="d-flex flex-wrap" style="column-gap: 45px;">
        <div class="mb-3 d-flex justify-content-between">
            <div class="mr-3">
                <p class="font-weight-bold">1st Term</p>
                ${comment1}
            </div>
            <input type="text" class="knob" data-thickness="0.1" value="${term1Percentage}" data-width="50" data-height="50" data-fgColor="${getScoreColorCode(term1Percentage)}" data-readonly="true">
        </div>
        <div class="mb-3 d-flex justify-content-between">
            <div class="mr-3">
                <p class="font-weight-bold">2nd Term</p>
                <p>${comment_writing(term2Percentage, term1Percentage, '1st term')}</p>
            </div>
            <input type="text" class="knob" data-thickness="0.1" value="${term2Percentage}" data-width="50" data-height="50" data-fgColor="${getScoreColorCode(term2Percentage)}"
                data-readonly="true">
        </div>
        <div class="mb-3 d-flex justify-content-between">
            <div class="mr-3">
                <p class="font-weight-bold">3rd Term</p>
                <p>${comment_writing(term3Percentage, term2Percentage, '2nd term')}</p>
            </div>
            <input type="text" class="knob" data-thickness="0.1" value="${term3Percentage}" data-width="50" data-height="50" data-fgColor="${getScoreColorCode(term3Percentage)}"
                data-readonly="true">
        </div>
    </div>
    
    `
    setTimeout(() => {
        trigger_knob()
    }, 200)
    setTimeout(() => {
        display_chart(term1Percentage, term2Percentage, term3Percentage)
    }, 200)
    return $("#table_visuals_display").html(str)
}
// alert("kkkk")
function display_visual_score(student_score_data, term, session_id, class_id) {
    // console.log("kkkk",student_score_data, term, session_id, class_id)
    let totals = calculate_Percentages_and_totals(student_score_data);
    if ($(".term.select_btn.active").attr("data-name") == "summary") {
        display_session_charts(totals.term1Percentage, totals.term2Percentage, totals.term3Percentage, totals.sessionPercentage)
        $(".line_and_term_based_contents").hide()
        return
    }
    const nwdata = student_score_data.filter(item => item.term_id == term && item.session_id == session_id && item.class_id == class_id)
    let str = ''
    if (term == 1) {
        str += `<div class="mb-3 d-flex">
                <div>
                <h1 style="background-color: #f3f3f3;padding: 0px 4px 0px 4px;margin-right: 10px; border-radius: 5px">${totals.term1Percentage}%</h1>
                </div>
                <div class="mr-3">
                    <p class="font-weight-bold">1st Term</p>
                    <p>A good way to start</p>
                </div>
            </div>`
    } else if (term == 2) {
        str += `<div class="mb-3 d-flex">
            <div>
            <h1 style="background-color: #f3f3f3;padding: 0px 4px 0px 4px;margin-right: 10px; border-radius: 5px">${totals.term2Percentage}%</h1>        
            </div>
            <div class="mr-3">
                    <p class="font-weight-bold">2nd Term</p>
                    <p>${comment_writing(totals.term2Percentage, totals.term1Percentage, '1st term')}</p>
                </div>
            </div>`
    } else if (term == 3) {
        str += `<div class="mb-3 d-flex">
        <div>
            <h1 style="background-color: #f3f3f3;padding: 0px 4px 0px 4px;margin-right: 10px; border-radius: 5px">${totals.term3Percentage}%</h1>        
            </div>
            <div class="mr-3">
                    <p class="font-weight-bold">3rd Term</p>
                    <p>${comment_writing(totals.term3Percentage, totals.term2Percentage, '2nd term')}</p>
                </div>
            </div>`
    }
    if (nwdata.length > 0) {
        str += `<div id="visual_score" class="d-flex flex-wrap" style="gap: 40px;">`;
        console.log("theitem", nwdata)
        nwdata.forEach(item => {
            console.log("subj", item.subject)
            let maxObtainable = safeParseFloat(item.ca1Total) + safeParseFloat(item.ca2Total) + safeParseFloat(item.ca3Total) + safeParseFloat(item.praTotal) + safeParseFloat(item.exaTotal)
            let total = safeParseFloat(item.Total)
            if (maxObtainable > 0) {
                percentage = (safeParseFloat(total / maxObtainable) * 100).toFixed(0)
            } else {
                percentage = '0'
            }
            function getCApercentage(score, total) {
                if (total > 0) {
                    return ((safeParseFloat(score) / safeParseFloat(total)) * 100).toFixed(0)
                } else {
                    return '0';
                }
            }
            str += `
                <div class="dropdown" style="width: 250px;">
                    <div class="progress-group dropdown-toggle d-flex align-items-center" data-toggle="dropdown">
                        <div class="w-100">
                            <div class="d-flex justify-content-between">
                                <p class="progress-text">${item.subject}</p>
                                <p class="float-right"><b>${item.Total}</b>/${maxObtainable}</p>
                            </div>
                            <div class="progress progress-sm">
                                <div class="progress-bar ${getScoreColor(percentage, 'bg')}" style="width: ${percentage}%"></div>
                            </div>
                        </div>
                    </div>
                    <div class="dropdown-menu w-100">
                        <div class="progress-group dropdown-item ${settingsData.ca1 == 0 ? 'd-none' : ''}">
                            <span class="progress-text">CA1</span>
                            <span class="float-right"><b>${item.CA1}</b>/${item.ca1Total}</span>
                            <div class="progress progress-xs">
                                <div class="progress-bar ${getScoreColor(getCApercentage(item.CA1, item.ca1Total), 'bg')}" style="width: ${getCApercentage(item.CA1, item.ca1Total)}%"></div>
                            </div>
                        </div>
                        <div class="progress-group dropdown-item ${settingsData.ca2 == 0 ? 'd-none' : ''}"">
                            <span class="progress-text">CA2</span>
                            <span class="float-right"><b>${item.CA2}</b>/${item.ca2Total}</span>
                            <div class="progress progress-xs">
                                <div class="progress-bar ${getScoreColor(getCApercentage(item.CA2, item.ca2Total), 'bg')}" style="width: ${getCApercentage(item.CA2, item.ca2Total)}%"></div>
                            </div>
                        </div>
                        <div class="progress-group dropdown-item ${settingsData.ca3 == 0 ? 'd-none' : ''}"">
                            <span class="progress-text">CA3</span>
                            <span class="float-right"><b>${item.CA3}</b>/${item.ca3Total}</span>
                            <div class="progress progress-xs">
                                <div class="progress-bar ${getScoreColor(getCApercentage(item.CA3, item.ca3Total), 'bg')}" style="width: ${getCApercentage(item.CA3, item.ca3Total)}%"></div>
                            </div>
                        </div>
                        <div class="progress-group dropdown-item ${settingsData.pra == 0 ? 'd-none' : ''}"">
                            <span class="progress-text">Practical</span>
                            <span class="float-right"><b>${item.Practical}</b>/${item.praTotal}</span>
                            <div class="progress progress-xs">
                                <div class="progress-bar ${getScoreColor(getCApercentage(item.Practical, item.praTotal), 'bg')}" style="width: ${getCApercentage(item.Practical, item.praTotal)}%"></div>
                            </div>
                        </div>
                        <div class="progress-group dropdown-item ${settingsData.exa == 0 ? 'd-none' : ''}"">
                            <span class="progress-text">Exam</span>
                            <span class="float-right"><b>${item.Exam}</b>/${item.exaTotal}</span>
                            <div class="progress progress-xs">
                                <div class="progress-bar ${getScoreColor(getCApercentage(item.Exam, item.exaTotal), 'bg')}" style="width: ${getCApercentage(item.Exam, item.exaTotal)}%"></div>
                            </div>
                        </div>
                        <a class="dropdown-item" href="#subject_full_record" onclick="send_subject_info_to_modal('${item.subject_id}','${$("#select_session_field").val()}')" data-toggle="modal">View session record</a>
                    </div>
                </div>
        `
        })
        str += `</div>`
        $(".line_and_term_based_contents").show()
    } else {
        str = `<div class="d-flex justify-content-center align-items-center"><p class="p-5 font-weight-bold">No score recorded yet</p></div>`
    }
    $("#table_visuals_display").html(str)
    get_teacher_comment(term, session_id, $("#select_student_field").val(), class_id, 'view')
    set_behaviour_comment(term, session_id, $("#select_student_field").val(), class_id, 'view')

}

function display_chart1(term1percent, term2percent, term3percent) {
    console.log("termspercentage", term1percent, term2percent, term3percent)
    $("#score_chart").html(`
                <div class="position-relative mb-4">
                <canvas id="visitors-chart" height="200"></canvas>
            </div>
        `)
    var ticksStyle = {
        fontColor: '#495057',
        fontStyle: 'bold'
    }

    let mode = 'index'
    let intersect = true
    let $visitorsChart = $('#visitors-chart')
    // eslint-disable-next-line no-unused-vars
    let visitorsChart = new Chart($visitorsChart, {
        data: {
            labels: ['1st Term', '2nd Term', '3rd term'],
            datasets: [{
                type: 'line',
                data: [term1percent, term2percent, term3percent],
                backgroundColor: 'transparent',
                borderColor: '#007bff',
                pointBorderColor: '#007bff',
                pointBackgroundColor: '#007bff',
                fill: false,
                pointHoverBackgroundColor: '#007bff',
                pointHoverBorderColor: '#007bff'
            },]
        },
        options: {
            maintainAspectRatio: false,
            tooltips: {
                mode: mode,
                intersect: intersect
            },
            hover: {
                mode: mode,
                intersect: intersect
            },
            legend: {
                display: false
            },
            scales: {
                yAxes: [{
                    // display: false,
                    gridLines: {
                        display: true,
                        lineWidth: '4px',
                        color: 'rgba(0, 0, 0, .2)',
                        zeroLineColor: 'transparent'
                    },
                    ticks: $.extend({
                        beginAtZero: true,
                        suggestedMax: 100
                    }, ticksStyle)
                }],
                xAxes: [{
                    display: true,
                    gridLines: {
                        display: false
                    },
                    ticks: ticksStyle
                }]
            }
        }
    })

}
function display_chart(term1percent, term2percent, term3percent) {
    $("#score_chart-summary").html(`
        <div class="position-relative mb-4">
    <canvas id="visitors-chart-summary" height="200"></canvas>
    </div>`)
    var ticksStyle = {
        fontColor: '#495057',
        fontStyle: 'bold'
    }

    let mode = 'index'
    let intersect = true
    let $visitorsChart_summary = $('#visitors-chart-summary')
    // eslint-disable-next-line no-unused-vars
    let visitorsChart_summary = new Chart($visitorsChart_summary, {
        data: {
            labels: ['1st Term', '2nd Term', '3rd term'],
            datasets: [{
                type: 'line',
                data: [term1percent, term2percent, term3percent],
                backgroundColor: 'transparent',
                borderColor: '#007bff',
                pointBorderColor: '#007bff',
                pointBackgroundColor: '#007bff',
                fill: false,
                pointHoverBackgroundColor: '#007bff',
                pointHoverBorderColor: '#007bff'
            },]
        },
        options: {
            maintainAspectRatio: false,
            tooltips: {
                mode: mode,
                intersect: intersect
            },
            hover: {
                mode: mode,
                intersect: intersect
            },
            legend: {
                display: false
            },
            scales: {
                yAxes: [{
                    // display: false,
                    gridLines: {
                        display: true,
                        lineWidth: '4px',
                        color: 'rgba(0, 0, 0, .2)',
                        zeroLineColor: 'transparent'
                    },
                    ticks: $.extend({
                        beginAtZero: true,
                        suggestedMax: 100
                    }, ticksStyle)
                }],
                xAxes: [{
                    display: true,
                    gridLines: {
                        display: false
                    },
                    ticks: ticksStyle
                }]
            }
        }
    })
}
// function update_knob(htmlid, percentage_value) {
//     $("#" + htmlid)
//         .val(percentage_value)
//         .trigger('change');
//     $("#" + htmlid).trigger('configure', {
//         fgColor: getScoreColorCode(percentage_value)
//     }).trigger('change');
//     $("#" + htmlid).css('color', getScoreColorCode(percentage_value));
// }
function trigger_knob() {
    /* jQueryKnob */
    // function get_knob() {
    $('.knob').knob({
        /*change : function (value) {
         //console.log("change : " + value);
         },
         release : function (value) {
         console.log("release : " + value);
         },
         cancel : function () {
         console.log("cancel : " + this.value);
         },*/
        draw: function () {

            // "tron" case
            if (this.$.data('skin') == 'tron') {

                var a = this.angle(this.cv) // Angle
                    ,
                    sa = this.startAngle // Previous start angle
                    ,
                    sat = this.startAngle // Start angle
                    ,
                    ea // Previous end angle
                    ,
                    eat = sat + a // End angle
                    ,
                    r = true

                this.g.lineWidth = this.lineWidth

                this.o.cursor &&
                    (sat = eat - 0.3) &&
                    (eat = eat + 0.3)

                if (this.o.displayPrevious) {
                    ea = this.startAngle + this.angle(this.value)
                    this.o.cursor &&
                        (sa = ea - 0.3) &&
                        (ea = ea + 0.3)
                    this.g.beginPath()
                    this.g.strokeStyle = this.previousColor
                    this.g.arc(this.xy, this.xy, this.radius - this.lineWidth, sa, ea, false)
                    this.g.stroke()
                }

                this.g.beginPath()
                this.g.strokeStyle = r ? this.o.fgColor : this.fgColor
                this.g.arc(this.xy, this.xy, this.radius - this.lineWidth, sat, eat, false)
                this.g.stroke()

                this.g.lineWidth = 2
                this.g.beginPath()
                this.g.strokeStyle = this.o.fgColor
                this.g.arc(this.xy, this.xy, this.radius - this.lineWidth + 1 + this.lineWidth * 2 / 3, 0, 2 * Math.PI, false)
                this.g.stroke()

                return false
            }
        }
    })
    /* END JQUERY KNOB */
}
// get_score_data()

function get_score_data() {
    let student_id = $("#select_student_field").val() || $("#select_student_field.active").val()
    let class_id = $("#select_class_field").val()
    let session_id = $("#select_session_field").val()
    let term_id = $(".term.select_btn.active").attr("data-name")

    if (!student_id || !class_id) {
        $(".data_overlay").html(`
            <p class="font-weight-bold">Fill the forms appropiately</p>
        `)
        $(".data_overlay").show()
        $(".thecontentbox, .by_class_filter").hide()
        return
    }
    // loadSettings().done(function (response) {
    // console.log("mmm", settingsData)
    // console.log(student_id, class_id, session_id, term_id)
    // console.log(student_id, class_id, session_id, term_id)
    if ($("#report_page").val() === 'report_scores') {
        setTimeout(get_billing_data, 100)
    }
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: {
            // remove the student_id condition if you are calling by session but leave it if you are fetching data for the whole class
            // 'action': 'get_student_score_data_by_class',
            'action': 'getsinglesessionreport_view',
            class_id,
            term_id,
            session_id,
            student_id
        },
        beforeSend: () => {
            $(".data_overlay").html(`
                <p class="font-weight-bold">Loading...</p>
            `)
            $(".thecontentbox").hide()
            $(".data_overlay").show()
        },
        success: (data) => {
            console.log(data)
            // console.log('l', )
            // alert(data.length)
            // if(data.length == 0){
            // }
            student_score_data = JSON.parse(data)
            if (student_score_data.length <= 1) {
                $(".data_overlay").html(`
                        <p class="font-weight-bold">No score record for this student</p>
                        `)
                // $(".thecontentbox").show()
                return
            }
            $(".thecontentbox").show()
            $(".data_overlay").hide()
            $(".data_overlay").html(`
                <p class="font-weight-bold">Fill the forms appropiately</p>
            `)
            console.log('socredata', student_score_data)
            // format_student_table(student_score_data,term_id,session_id,class_id)
            let totals = calculate_Percentages_and_totals(student_score_data);
            // display_session_charts(totals.term1Percentage, totals.term2Percentage, totals.term3Percentage, totals.sessionPercentage)
            check_result_toggle()


            // get_teacher_comment(term_id, session_id, student_id, class_id, 'view')
            // set_behaviour_comment(term_id, session_id, student_id, class_id, 'view')


            // get_knob()
            // Output the results
            console.log("Term 1 Total:", totals.term1Total);
            console.log("Term 1 Max:", totals.term1Max);
            console.log("Term 2 Total:", totals.term2Total);
            console.log("Term 2 Max:", totals.term2Max);
            console.log("Term 3 Total:", totals.term3Total);
            console.log("Term 3 Max:", totals.term3Max);
            console.log("Term 1 Percentage:", totals.term1Percentage);
            console.log("Term 2 Percentage:", totals.term2Percentage);
            console.log("Term 3 Percentage:", totals.term3Percentage);
            console.log("Session Percentage:", totals.sessionPercentage);

        }
    })
    // })
}
// alert('llll')
// alert(settingsData)
function generateSessionSummary(data, session_id, student_id, class_id) {
    // console.log("teeeeeeeeeee",data)
    // Filter data based on session_id, student_id, and class_id
    // console.log('meee',data)
    // alert(data)
    let grader = format_grade(skul_settings['grading'])
    const filteredData = data.filter(record =>
        record.session_id === session_id.toString() &&
        record.student_id === student_id.toString() &&
        record.class_id === class_id.toString()
    );
    // alert(filteredData)

    // Helper function to get term data for a subject
    function getTermData(subjectData, term, type) {
        const termData = subjectData.find(record => record.Term === term.toString());
        return termData ? termData[type] : '-';
    }

    // Get a unique list of subjects
    const subjects = [...new Set(filteredData.map(record => record.subject))];
    // console.log(subjects)
    // Initialize HTML for the table
    let str = `
        <table id="sessional_summary_table" class="display nowrap" style="width:100%;">
            <thead>
                <tr>
                    <th style="border:1px solid lightgray"></th>
                    <th colspan="3" class="text-center ${settingsData.ca1 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">CA1</th>
                    <th colspan="3" class="text-center ${settingsData.ca2 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">CA2</th>
                    <th colspan="3" class="text-center ${settingsData.ca3 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">CA3</th>
                    <th colspan="3" class="text-center ${settingsData.pra == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">Practical</th>
                    <th colspan="3" class="text-center ${settingsData.exa == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">Exam</th>
                    <th colspan="6" class="text-center" style="border:1px solid lightgray"></th>
                </tr>
                <tr>
                    <th style="border:1px solid lightgray">Subjects</th>
                    <th class="${settingsData.ca1 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">1st</th>
                    <th class="${settingsData.ca1 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">2nd</th>
                    <th class="${settingsData.ca1 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">3rd</th>
                    <th class="${settingsData.ca2 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">1st</th>
                    <th class="${settingsData.ca2 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">2nd</th>
                    <th class="${settingsData.ca2 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">3rd</th>
                    <th class="${settingsData.ca3 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">1st</th>
                    <th class="${settingsData.ca3 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">2nd</th>
                    <th class="${settingsData.ca3 == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">3rd</th>
                    <th class="${settingsData.pra == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">1st</th>
                    <th class="${settingsData.pra == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">2nd</th>
                    <th class="${settingsData.pra == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">3rd</th>
                    <th class="${settingsData.exa == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">1st</th>
                    <th class="${settingsData.exa == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">2nd</th>
                    <th class="${settingsData.exa == 0 ? 'd-none' : ''}" style="border:1px solid lightgray">3rd</th>
                    <th style="border:1px solid lightgray">1st Total</th>
                    <th style="border:1px solid lightgray">2nd Total</th>
                    <th style="border:1px solid lightgray">3rd Total</th>
                    <th style="border:1px solid lightgray">Cumulative</th>
                    <th style="border:1px solid lightgray">Average</th>
                    <th style="border:1px solid lightgray">Percentage</th>
                    <th style="border:1px solid lightgray">Grade</th>
                </tr>
            </thead>
            <tbody>
    `;

    // Generate table rows for each subject
    // console.log(subjects)
    // alert(subjects)
    subjects.forEach(subject => {
        // Get data for the current subject
        const subjectData = filteredData.filter(record => record.subject === subject);

        // Calculate totals for each term
        const term1Total = subjectData.find(record => record.Term === '1')?.Total || 0;
        const term2Total = subjectData.find(record => record.Term === '2')?.Total || 0;
        const term3Total = subjectData.find(record => record.Term === '3')?.Total || 0;

        // Calculate cumulative, average, and percentage
        const cumulative = parseFloat(term1Total) + parseFloat(term2Total) + parseFloat(term3Total);
        const numberOfTerms = [term1Total, term2Total, term3Total].filter(total => total > 0).length;
        const average = numberOfTerms > 0 ? (cumulative / numberOfTerms).toFixed(0) : 0;
        const percentage = (average / 100 * 100).toFixed(0);

        // Add table row for the current subject
        str += `
            <tr>
                <td style="border:1px solid lightgray">${subject}</td>
                <td class="${settingsData.ca1 == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 1, 'CA1')}</td>
                <td class="${settingsData.ca1 == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 2, 'CA1')}</td>
                <td class="${settingsData.ca1 == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 3, 'CA1')}</td>
                <td class="${settingsData.ca2 == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 1, 'CA2')}</td>
                <td class="${settingsData.ca2 == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 2, 'CA2')}</td>
                <td class="${settingsData.ca2 == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 3, 'CA2')}</td>
                <td class="${settingsData.ca3 == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 1, 'CA3')}</td>
                <td class="${settingsData.ca3 == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 2, 'CA3')}</td>
                <td class="${settingsData.ca3 == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 3, 'CA3')}</td>
                <td class="${settingsData.pra == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 1, 'Practical')}</td>
                <td class="${settingsData.pra == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 2, 'Practical')}</td>
                <td class="${settingsData.pra == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 3, 'Practical')}</td>
                <td class="${settingsData.exa == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 1, 'Exam')}</td>
                <td class="${settingsData.exa == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 2, 'Exam')}</td>
                <td class="${settingsData.exa == 0 ? 'd-none' : ''}" style="border: 1px solid lightgray">${getTermData(subjectData, 3, 'Exam')}</td>
                <td style="border: 1px solid lightgray">${term1Total}</td>
                <td style="border: 1px solid lightgray">${term2Total}</td>
                <td style="border: 1px solid lightgray">${term3Total}</td>
                <td style="border: 1px solid lightgray">${cumulative}</td>
                <td style="border: 1px solid lightgray">${average}</td>
                <td style="border: 1px solid lightgray">${percentage}</td>
                <td style="border: 1px solid lightgray">${calculateGrade1(percentage, grader)}</td>
            </tr>
        `;
    });

    // Close the table HTML
    str += `
            </tbody>
        </table>
    `;

    // Display or return the generated table HTML
    // document.getElementById('tableContainer').innerHTML = str;
    $("#table_visuals_display").html(str);
    $('#sessional_summary_table').DataTable({
        scrollX: true,
        paging: false,
        ordering: false,
        fixedColumns: {
            left: 1,
            right: 0
        }
    });
}


function get_subject_percentage(subject_id, term, session_id, class_id) {
    console.log(subject_id)
    // remove the student_id condition if you are calling by session but leave it if you are fetching data for the whole class
    let subjectData = student_score_data.find(item => item.subject_id == subject_id && item.term_id == term && item.session_id == session_id && item.class_id == class_id)
    if (subjectData) {
        const CA1 = parseFloat(subjectData.CA1) || 0;
        const CA2 = parseFloat(subjectData.CA2) || 0;
        const CA3 = parseFloat(subjectData.CA3) || 0;
        const Practical = parseFloat(subjectData.Practical) || 0;
        const Exam = parseFloat(subjectData.Exam) || 0;

        const ca1Total = parseFloat(subjectData.ca1Total) || 0;
        const ca2Total = parseFloat(subjectData.ca2Total) || 0;
        const ca3Total = parseFloat(subjectData.ca3Total) || 0;
        const praTotal = parseFloat(subjectData.praTotal) || 0;
        const exaTotal = parseFloat(subjectData.exaTotal) || 0;

        const totalScore = CA1 + CA2 + CA3 + Practical + Exam;
        console.log("subtota", totalScore)
        const totalMaxScore = ca1Total + ca2Total + ca3Total + praTotal + exaTotal;

        if (totalMaxScore > 0) {
            const percentage = (totalScore / totalMaxScore) * 100;
            return percentage.toFixed(0); // Return percentage formatted to 2 decimal places
        }
    }
    return "0.00"; // Default to 0 if no data or invalid
}

function GetGrade(subject_id, term, session_id, class_id) {
    let percentage = get_subject_percentage(subject_id, term, session_id, class_id)

    // Convert the percentage string to a float for comparison
    percentage = parseFloat(percentage);

    if (percentage >= 70) {
        return "A";
    } else if (percentage >= 60) {
        return "B";
    } else if (percentage >= 50) {
        return "C";
    } else if (percentage >= 45) {
        return "D";
    } else if (percentage >= 40) {
        return "E";
    } else {
        return "F"; // For percentage below 40
    }
}

// alert('k')
function format_student_table(student_score_data, term, session_id, class_id) {
    // alert('k')
    console.log("grad", skul_settings['grading'])
    // alert(skul_settings['grading'])
    let formattedString = skul_settings['grading'].replace(/([A-Z]):/g, '"$1":').replace(/:/g, ': ');
    grader = JSON.parse(formattedString)
    console.log(grader)
    // return

    if ($(".term.select_btn.active").attr("data-name") == "summary") {
        generateSessionSummary(student_score_data, session_id, $("#select_student_field").val(), class_id)
        $(".line_and_term_based_contents").hide()
        return
    }
    const nwdata = student_score_data.filter(item => item.term_id == term && item.session_id == session_id && item.class_id == class_id)
    console.log("nw", nwdata)
    let str = ''
    if (nwdata.length > 0) {
        str = `
    <table id="view_student_score_table" class="display nowrap" style="width:100%;">
        <thead>
            <tr>
                <th>Subjects</th>
                <th class="${settingsData.ca1 == 0 ? 'd-none' : ''}">CA1</th>
                <th class="${settingsData.ca1 == 0 ? 'd-none' : ''}">CA2</th>
                <th class="${settingsData.ca3 == 0 ? 'd-none' : ''}">CA3</th>
                <th class="${settingsData.pra == 0 ? 'd-none' : ''}">Practical</th>
                <th class="${settingsData.exa == 0 ? 'd-none' : ''}">Exam</th>
            <th>Total</th>         
                <th>Total(%)</th>
                <th>Grade</th>
            </tr>
        </thead>
        <tbody>
    `;

        // if () {
        nwdata.forEach(item => {
            // let Total = safeParseFloat(item.CA1) + safeParseFloat(item.CA2) + safeParseFloat(item.CA3) + safeParseFloat(item.Practical) + safeParseFloat(item.Exam)
            console.log('subj', item.subject_id)
            str += `
        <tr>
            <td>${item.subject}</td>
             <td class="${settingsData.ca1 == 0 ? 'd-none' : ''}">${safeParseFloat(item.CA1)}</td>
            <td class="${settingsData.ca2 == 0 ? 'd-none' : ''}">${safeParseFloat(item.CA2)}</td>
            <td class="${settingsData.ca3 == 0 ? 'd-none' : ''}">${safeParseFloat(item.CA3)}</td>
            <td class="${settingsData.pra == 0 ? 'd-none' : ''}">${safeParseFloat(item.Practical)}</td>
            <td class="${settingsData.exa == 0 ? 'd-none' : ''}">${safeParseFloat(item.Exam)}</td>
            <td>${safeParseFloat(item.Total)}</td>
            <td>${get_subject_percentage(item.subject_id, term, session_id, class_id)}</td>
            <td>${calculateGrade1(get_subject_percentage(item.subject_id, term, session_id, class_id), grader)}</td>
        </tr>
    `
            // }
        });

        str += `</tbody>
    </table>`;
        $(".line_and_term_based_contents").show()
    } else {
        str = `<div class="d-flex justify-content-center align-items-center"><p class="p-5 font-weight-bold">No score recorded yet</p></div>`
    }
    $("#table_visuals_display").html(str);
    get_teacher_comment(term, session_id, $("#select_student_field").val(), class_id, 'view')
    set_behaviour_comment(term, session_id, $("#select_student_field").val(), class_id, 'view')

    if ($.fn.DataTable.isDataTable('#view_student_score_table')) {
        $('#view_student_score_table').DataTable().destroy();
    }
    $('#view_student_score_table').DataTable({
        scrollX: true,
        paging: false,
        ordering: false,
        // fixedColumns: {
        //     left: 1,
        //     right: 0
        // }
    });
}

function select_receipient_specific(event) {
    let email = $(event).val();
    let dataarray = email.split("/")
    let id;
    // console.log(email)
    email = dataarray[0]
    if (!dataarray[1]) {
        isMessage = false
    } else {
        id = dataarray[1]
        isMessage = true
    }
    const recipientList = $("#reciepient_list");
    const hiddenInput = $("#reciepient_email_list");


    // Check if the email is already in the list
    // console.log(Array.from(document.querySelectorAll("#reciepient_list li").innerHTML))
    if (recipientList.find("li").filter(function () { return $(this).text() === email + ','; }).length === 0) {
        // Add the email to the visible list
        recipientList.append(`<li style="list-style:none;">${email},</li>`);

        // Get the current list of emails from the hidden input and split into an array
        let emails = hiddenInput.val() ? hiddenInput.val().split(",") : [];

        // Add the new email to the array and update the hidden input value
        if (isMessage) {
            emails.push(id)
        } else {
            emails.push(email);
        }
        hiddenInput.val(emails.join(","));
        $("#send_to_box").show()
    }
}

function init_staff_search() {

    $('#search_staff_comm').select2({
        ajax: {
            url: '../controller.php', // Replace with your PHP file URL
            type: 'POST',
            dataType: 'json',
            minimumInputLength: 2,
            delay: 250,
            cache: true,
            data: function (params) {
                return {
                    action: 'get_staff_data_for_search_comm',
                    search_terms: params.term
                };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
                        let theid
                        if ($("#email_select").hasClass("active")) {
                            theid = item.email
                        } else if ($("#message_select").hasClass("active")) {
                            theid = item.phone
                        } else if ($("#int_message_select").hasClass("active")) {
                            theid = item.staff_name + '/' + item.userid
                        }
                        return {
                            id: theid,
                            text: item.staff_name, // This is required but will be hidden in the dropdown
                            phone: item.phone,
                        };
                    })
                };
            }
        },
        placeholder: 'Search by staff name or phone number',
        templateResult: function (data) {
            if (!data.id) {
                return data.text;
            }

            return $(
                `<div class="parent_Search_btn w-100 btn p-2 text-left">
                        <p>${data.text}</p>
                        <p class="mb-0 small">${data.phone}</p>
                    </div>`
            );
        },
        templateSelection: function (data) {
            return data.text;
        }
    });
}
function init_parent_search() {
    $('#search_parent_comm').select2({
        ajax: {
            url: '../controller.php', // Replace with your PHP file URL
            type: 'POST',
            dataType: 'json',
            minimumInputLength: 2,
            delay: 250,
            cache: true,
            data: function (params) {
                return {
                    action: 'get_parent_data_for_search_comm',
                    search_terms: params.term
                };
            },
            processResults: function (data) {
                return {
                    results: $.map(data, function (item) {
                        let theid
                        if ($("#email_select").hasClass("active")) {
                            theid = item.email
                        } else if ($("#message_select").hasClass("active")) {
                            theid = item.phone
                        } else if ($("#int_message_select").hasClass("active")) {
                            theid = item.parent_name + '/' + item.userid
                        }
                        return {
                            id: theid,
                            text: item.parent_name, // This is required but will be hidden in the dropdown
                            parent_name: item.parent_name,
                            student_name: item.student_name,
                            phone: item.phone
                        };
                    })
                };
            }
        },
        placeholder: 'Search by parent name, phone number or student name',
        templateResult: function (data) {
            if (!data.id) {
                return data.text;
            }

            return $(
                `<div class="parent_Search_btn w-100 btn p-2 text-left">
                        <p class="mb-0">${data.text}</p>
                        <p class="mb-0 small">Child - ${data.student_name} &nbsp Phone Number - ${data.phone}</p>
                    </div>`
            );
        },
        templateSelection: function (data) {
            return data.text;
        }
    });
}

function select_receipient() {
    let data_type;
    if ($("#email_select").hasClass("active")) {
        data_type = 'email'
    }
    else if ($("#message_select").hasClass("active")) {
        data_type = 'phone'
    }
    else {
        data_type = 'name'
    }
    const reciepientType = $('#reciepient_type').val();
    if (reciepientType == '') {
        $("#send_to_box").hide()
        $("#reciepient_list").empty()
        $("#reciepient_email_list").val('')
        return
    }
    $("#send_to_box").show()
    if ($("#reciepient_type").val() == 'staff_specific') {

        init_staff_search()
        $("#search_staff_comm").next(".select2-container").show()
        $("#search_parent_comm").next(".select2-container").hide()
        $('#reciepient_list').empty();
        $('#reciepient_email_list').val('');
        $("#send_to_box").hide()
        return
    } else if ($("#reciepient_type").val() == 'parent_specific') {
        // $("#search_parent_comm").show()
        init_parent_search()
        $("#search_staff_comm").next(".select2-container").hide()
        $("#search_parent_comm").next(".select2-container").show()
        $('#reciepient_list').empty();
        $('#reciepient_email_list').val('');
        $("#send_to_box").hide()
        return
    }
    $("#search_staff_comm").next(".select2-container").hide()
    $("#search_parent_comm").next(".select2-container").hide()

    // AJAX request to get emails based on selected recipient type
    $.ajax({
        type: "POST",
        url: "../controller.php", // Replace with your PHP file URL
        data: { action: 'get_reciepients', reciepient_type: reciepientType, data_type, },
        dataType: "json",
        success: function (data) {
            $('#reciepient_list').empty();

            if (Array.isArray(data)) {
                if (data.length > 0) {
                    if (typeof data[0] === "string") {
                        console.log("Array of strings");
                        // Remove duplicates
                        const uniquedata = [...new Set(data)];
                        // Update DOM for emails
                        uniquedata.forEach(email => {
                            $('#reciepient_list').append(`<li style="list-style:none;">${email},</li>`);
                        });
                        $('#reciepient_email_list').val(uniquedata.join(','));
                    } else if (typeof data[0] === "object" && data[0] !== null) {
                        console.log("Array of objects");
                        // Extract and deduplicate names
                        const names = data.map(item => item.name);
                        const uniqueNames = [...new Set(names)];
                        // Update DOM for names
                        uniqueNames.forEach(name => {
                            $('#reciepient_list').append(`<li style="list-style:none;">${name},</li>`);
                        });

                        // Extract and deduplicate IDs
                        const ids = data.map(item => item.id);
                        const uniqueIds = [...new Set(ids)];
                        $('#reciepient_email_list').val(uniqueIds.join(','));
                    }
                } else {
                    toastr.info("No data for user type selected");
                }
            } else {
                console.log("Data is not an array:", data);
            }

            // if (typeof data === "string") {
            //     data = JSON.parse tab(data); // Parse it
            // }

            // console.log("After parsing:");
            // console.log(Array.isArray(data) ? "It's an array" : "It's not an array");
            // console.log(data);
            // console.log(data.includes("name"))
            // return

            // data = JSON.parse(data)
            // Remove any previous data
            // Remove duplicates
            // const uniqueids = [...new Set(data)];

            // Display data in #reciepient_list as list items


            // Set the unique data as comma-separated values in #reciepient_email_list

        },
        error: function (xhr, status, error) {
            console.error("Error fetching data:", error);
        }
    });
}


function calculate_Percentages_and_totals(data) {
    // Initialize variables for storing totals and maximum scores for each term and session
    let term1Total = 0,
        term1Max = 0;
    let term2Total = 0,
        term2Max = 0;
    let term3Total = 0,
        term3Max = 0;

    // Iterate through the data array to sum up totals and max values for each term
    data.forEach(item => {
        // Parse item values as numbers to avoid type issues
        const total = parseFloat(item.Total) || 0;
        const ca1Total = parseFloat(item.ca1Total) || 0;
        const ca2Total = parseFloat(item.ca2Total) || 0;
        const ca3Total = parseFloat(item.ca3Total) || 0;
        const praTotal = parseFloat(item.praTotal) || 0;
        const exaTotal = parseFloat(item.exaTotal) || 0;
        const maxPossibleTotal = ca1Total + ca2Total + ca3Total + praTotal + exaTotal;

        // Calculate the totals and max scores for each term
        if (item.term_id === "1") {
            term1Total += total;
            term1Max += maxPossibleTotal;
        } else if (item.term_id === "2") {
            term2Total += total;
            term2Max += maxPossibleTotal;
        } else if (item.term_id === "3") {
            term3Total += total;
            term3Max += maxPossibleTotal;
        }
    });

    // Calculate percentages for each term
    const term1Percentage = term1Max ? (term1Total / term1Max) * 100 : 0;
    const term2Percentage = term2Max ? (term2Total / term2Max) * 100 : 0;
    const term3Percentage = term3Max ? (term3Total / term3Max) * 100 : 0;

    // Calculate the session percentage by averaging the term percentages
    const sessionPercentage = (term1Percentage + term2Percentage + term3Percentage) / 3;

    // Return an object containing all the calculated percentages
    return {
        term1Total,
        term1Max,
        term2Total,
        term2Max,
        term3Total,
        term3Max,
        term1Percentage: term1Percentage.toFixed(),
        term2Percentage: term2Percentage.toFixed(),
        term3Percentage: term3Percentage.toFixed(),
        sessionPercentage: sessionPercentage.toFixed()
    };

}
// get_score_data()


// alert("llk")
$(document).ready(function () {
    $('#select_student_field').select2({
        placeholder: "Search by name or class",
        minimumInputLength: 2, // Minimum characters to start searching
        ajax: {
            url: '../controller.php',
            type: 'POST',
            dataType: 'json',
            delay: 250, // Delay in milliseconds before making the request
            data: function (params) {
                return {
                    action: 'get_student_data_for_search',
                    search_terms: params.term // The search term
                };
            },
            processResults: function (data) {
                // Transform the data into Select2's expected format
                return {
                    results: data.map(function (item) {
                        return {
                            id: item.student_id, // Using student_id as the ID
                            text: `${item.firstname} ${item.middlename} ${item.lastname}`.trim(), // Display full name, including middle name
                            classname: item.classname // Keep classname for displaying in the dropdown
                        };
                    })
                };
            },
            cache: true
        },
        templateResult: formatStudentResult, // Function to format the dropdown display
        templateSelection: formatStudentSelection // Function to format the selected item display
    });

    // function init_parentse(){



    // }
    $('#select_class_field').select2({
        placeholder: "Search class",
        minimumInputLength: 2, // Minimum characters to start searching
        ajax: {
            url: '../controller.php',
            type: 'POST',
            dataType: 'json',
            delay: 250, // Delay in milliseconds before making the request
            data: function (params) {
                return {
                    action: 'get_class_data_for_search',
                    search_terms: params.term // The search term
                };
            },
            processResults: function (data) {
                // Transform the data into Select2's expected format
                return {
                    results: data.map(function (item) {
                        return {
                            id: item.id, // Using student_id as the ID
                            classname: item.classname // Keep classname for displaying in the dropdown
                        };
                    })
                };
            },
            cache: true
        },
        templateResult: formatClassResult, // Function to format the dropdown display
        templateSelection: formatClassSelection // Function to format the selected item display
    });
    // $('#select_subject_field').select2({
    //     placeholder: "Search by subject name",
    //     minimumInputLength: 2, // Minimum characters to start searching
    //     ajax: {
    //         url: '../controller.php',
    //         type: 'POST',
    //         dataType: 'json',
    //         delay: 250, // Delay in milliseconds before making the request
    //         data: function (params) {
    //             return {
    //                 action: 'get_subject_data_for_search',
    //                 search_terms: params.term // The search term
    //             };
    //         },
    //         processResults: function (data) {
    //             // Transform the data into Select2's expected format
    //             return {
    //                 results: data.map(function (item) {
    //                     return {
    //                         id: item.id, // Using student_id as the ID
    //                         subjectname: item.subject // Keep classname for displaying in the dropdown
    //                     };
    //                 })
    //             };
    //         },
    //         cache: true
    //     },
    //     templateResult: formatSubjectResult, // Function to format the dropdown display
    //     templateSelection: formatSubjectSelection // Function to format the selected item display
    // });
    $('#select_subject_field').select2({
        //  alert( $("#select_class_field").val())
        placeholder: "Search by subject name",
        minimumInputLength: 2, // Minimum characters to start searching
        ajax: {
            url: '../controller.php',
            type: 'POST',
            dataType: 'json',
            delay: 250, // Delay in milliseconds before making the request
            data: function (params) {
                return {
                    action: 'get_subject_data_for_search',
                    search_terms: params.term, // The search term
                    class_id: $("#select_class_field").val()
                };
            },
            processResults: function (data) {
                return {
                    results: data.map(function (item) {
                        if (item.id == '0') {
                            return {
                                id: '0', // Placeholder for no class selected
                                subjectname: 'Please select a class', // Placeholder text
                                disabled: true
                            };
                        }
                        return {
                            id: item.id, // Using student_id as the ID
                            subjectname: item.subject // Keep classname for displaying in the dropdown
                        };
                    })
                };
            },
            cache: true
        },
        templateResult: formatSubjectResult, // Function to format the dropdown display
        templateSelection: formatSubjectSelection // Function to format the selected item display
    });
});

// Function to format the display in the dropdown
function formatClassResult(item) {
    if (!item.id) {
        return item.classname; // Placeholder text for search input
    }
    return $(`
        <div class="parent_Search_btn w-100 btn p-2 text-left">
            <p>${item.classname}</p>
        </div>
    `);
}



function formatStudentResult(item) {
    if (!item.id) {
        return item.text; // Placeholder text for search input
    }
    return $(`
        <div class="parent_Search_btn w-100 btn p-2 text-left">
            <p>${item.text}</p>
            <p class="mb-0 small">${item.classname}</p>
        </div>
    `);
}
function formatSubjectResult(item) {
    if (!item.id) {
        return item.subjectname; // Placeholder text for search input
    }
    return $(`
        <div class="parent_Search_btn w-100 btn p-2 text-left">
            <p>${item.subjectname}</p>
        </div>
    `);
}

function formatStudentSelection(item) {
    if (!item.id) {
        return item.text;
    }
    return item.text; // Only display the student's full name when selected
}
function formatSubjectSelection(item) {
    if (!item.id) {
        return item.subjectname;
    }
    return item.subjectname; // Only display the student's full name when selected
}

function formatClassSelection(item) {
    if (!item.id) {
        return item.classname;
    }
    return item.classname; // Only display the student's full name when selected
}

// Initialize Select2 for the Add Modal
function initializeParentSearchAdd() {
    $('#add_search_parentphone').select2({
        placeholder: "Search by phone number",
        minimumInputLength: 2,
        ajax: {
            url: '../controller.php',
            type: 'POST',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    action: 'get_parent_search_result',
                    phone: params.term
                };
            },
            processResults: function (data, params) {
                const results = data.map(function (item) {
                    return {
                        id: item.phone,
                        text: item.phone,
                        firstname: item.firstname,
                        lastname: item.lastname,
                        email: item.email,
                        address: item.address,
                        city: item.city,
                        state: item.state,
                        country: item.country,
                        isNew: false
                    };
                });

                results.push({
                    id: params.term,
                    text: `Add new parent with phone: ${params.term}`,
                    isNew: true
                });

                return {
                    results: results
                };
            },
            cache: true
        },
        templateResult: formatParentResult,
        templateSelection: formatParentSelection
    });

    $('#add_search_parentphone').on('select2:select', function (e) {
        const selectedData = e.params.data;
        const parentElement = $(this).closest('form');
        // handleParentSelection(selectedData, parentElement);
    });
}

// Initialize Select2 for the Update Modal
function initializeParentSearchUpdate() {
    $('#update_search_parentphone').select2({
        placeholder: "Search by phone number",
        minimumInputLength: 2,
        ajax: {
            url: '../controller.php',
            type: 'POST',
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    action: 'get_parent_search_result',
                    phone: params.term
                };
            },
            processResults: function (data, params) {
                const results = data.map(function (item) {
                    return {
                        id: item.phone,
                        text: item.phone,
                        firstname: item.firstname,
                        lastname: item.lastname,
                        email: item.email,
                        address: item.address,
                        city: item.city,
                        state: item.state,
                        country: item.country,
                        isNew: false
                    };
                });

                results.push({
                    id: params.term,
                    text: `Add new parent with phone: ${params.term}`,
                    isNew: true
                });

                return {
                    results: results
                };
            },
            cache: true
        },
        templateResult: formatParentResult,
        templateSelection: formatParentSelection
    });

    $('#update_search_parentphone').on('select2:select', function (e) {
        const selectedData = e.params.data;
        const parentElement = $(this).closest('form');
        // handleParentSelection(selectedData, parentElement);
    });
}

// Handle showing and hiding the modals and initializing Select2
$('#add_student_modal').on('shown.bs.modal', function () {
    initializeParentSearchAdd(); // Initialize for Add Modal
});

$('#edit_student_modal').on('shown.bs.modal', function () {
    initializeParentSearchUpdate(); // Initialize for Update Modal
});

function formatParentResult(item) {
    if (!item.id) {
        return item.text;
    }
    return $(`
        <div class="parent_Search_btn w-100 btn p-2 text-left">
            <p class="mb-0 small font-weight-bold">${item.id}</p>
            <p class="small">${item.isNew ? 'Add a new parent' : item.firstname + ' ' + item.lastname}</p>
        </div>
    `);
}

function formatParentSelection(item) {
    if (!item.id) {
        return item.text;
    }
    return item.isNew ? `Add new: ${item.id}` : `${item.id}`;
}

function handleParentSelection(selectedData, parentElement) {
    if (selectedData.isNew) {
        parentElement.find(".pa_firstname").val('').prop("disabled", false);
        parentElement.find(".pa_lastname").val('').prop("disabled", false);
        // parentElement.find(".pa_email").val('').prop("disabled", false);
        parentElement.find(".pa_address").val('').prop("disabled", false);
        parentElement.find(".pa_city").val('').prop("disabled", false);
        parentElement.find(".pa_state").val('').prop("disabled", false);
        parentElement.find(".pa_country").val('').prop("disabled", false);
        parentElement.find(".search_parentphone").val(selectedData.id);
    } else {
        parentElement.find(".pa_firstname").val(selectedData.firstname).prop("disabled", true);
        parentElement.find(".pa_lastname").val(selectedData.lastname).prop("disabled", true);
        // parentElement.find(".pa_email").val(selectedData.email).prop("disabled", true);
        parentElement.find(".pa_address").val(selectedData.address).prop("disabled", true);
        parentElement.find(".pa_city").val(selectedData.city).prop("disabled", true);
        parentElement.find(".pa_state").val(selectedData.state).prop("disabled", true);
        parentElement.find(".pa_country").val(selectedData.country).prop("disabled", true);
    }
}




function get_parent_search_result(parent_element, phone) {
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: {
            'action': 'get_parent_search_result',
            phone
        },
        beforeSend: () => {
            parent_element.find(".parent_Search_result").html(
                '<p class="px-2">Processing...</p>'
            );
        },
        success: (data) => {
            data = JSON.parse(data);
            let str = '';
            // Use data attribute to identify parent element
            const parentId = parent_element.attr('id');

            if (data.length > 0) {
                data.map((item) => {
                    str += `<div onclick="fill_fields('#${parentId}', '${item.phone}', '${item.email}', '${item.firstname}', '${item.lastname}', '${item.address}', '${item.city}', '${item.state}', '${item.country}')" class="parent_Search_btn w-100 btn p-2 text-left">
                                <p class="mb-0 small font-weight-bold">${item.phone}</p>
                                <p class="small">${item.firstname + ' ' + item.lastname}</p>
                            </div>`;
                });

                parent_element.find(".parent_Search_result").html(str);
                parent_element.find(".pa_firstname").attr("disabled", true);
                parent_element.find(".pa_lastname").attr("disabled", true);
                parent_element.find(".pa_address").attr("disabled", true);
                parent_element.find(".pa_city").attr("disabled", true);
                parent_element.find(".pa_state").attr("disabled", true);
                parent_element.find(".pa_country").attr("disabled", true);
            } else {
                str = `<div class="w-100 px-2">
                        <div class="d-flex justify-content-between align-items-baseline">
                        <p class="mb-0 small font-weight-bold">No record found</p>
                        <button type="button" class="btn font-weight-bold text-muted" onclick="close_dropdown()">x</button>
                        </div>
                        <p class="small text-muted">Fill the form below to register this parent newly</p>
                        </div>`;
                parent_element.find(".parent_Search_result").html(str);
                parent_element.find(".pa_firstname").attr("disabled", false);
                parent_element.find(".pa_lastname").attr("disabled", false);
                parent_element.find(".pa_address").attr("disabled", false);
                parent_element.find(".pa_city").attr("disabled", false);
                parent_element.find(".pa_state").attr("disabled", false);
                parent_element.find(".pa_country").attr("disabled", false);
            }
        }
    });
}


function close_dropdown() {
    $(".parentphone_dropdown").toggle()
}

function fill_fields(parent_selector, phone, email, firstname, lastname, address, city, state, country) {
    const parent_element = $(parent_selector);

    parent_element.find(".pa_firstname").val(firstname).attr("disabled", true);
    parent_element.find(".pa_lastname").val(lastname).attr("disabled", true);
    parent_element.find(".search_parentphone").val(phone);
    parent_element.find(".pa_email").val(email);
    parent_element.find(".pa_address").val(address).attr("disabled", true);
    parent_element.find(".pa_city").val(city).attr("disabled", true);
    parent_element.find(".pa_state").val(state).attr("disabled", true);
    parent_element.find(".pa_country").val(country).attr("disabled", true);
    close_dropdown();
}


function input_search(event) {
    let element = $(event)
    let parent_element = element.parents("form")
    let query = element.val()
    if (query.length >= 2) {
        parent_element.find(".parentphone_dropdown").show()
        get_parent_search_result(parent_element, query)
    } else {
        parent_element.find(".parentphone_dropdown").hide()
    }
}

function toggleSelect(event, classelement, termValue, student_id) {
    $("." + classelement).removeClass("active")
    $(event).addClass('active')
    getTermReport()
}
function safeParseFloat(value) {
    return isNaN(parseFloat(value)) || value == Infinity ? 0 : parseFloat(value);
}

function getScoreColor(percentage, classElement) {
    switch (true) {
        case (percentage >= 60 && percentage <= 100): return `${classElement}-success`;
        case (percentage >= 40 && percentage <= 60): return `${classElement}-warning`;
        case (percentage >= 0 && percentage <= 40): return `${classElement}-danger`;
    }
}
function getScoreColorCode(percentage) {
    switch (true) {
        case (percentage >= 60 && percentage <= 100): return '#198754';
        case (percentage >= 40 && percentage <= 60): return '#FF803D';
        case (percentage >= 0 && percentage <= 40): return '#FC5A5A';
    }
}

function getTermReport() {
    let student_id = $("#student_id_for_general_report").val()
    let termValue = $(".select_term_report.active").attr('data-termValue')
    let sessionValue = $("#termSessionValue").val()
    let subjectValue = $("#termSubjectValue").val()
    // alert(subjectValue)
    // return
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: { 'action': 'gettermreport', subjectValue, termValue, sessionValue, student_id },
        beforeSend: () => {
            $("#student_term_based_report").html(
                `<div id="skeleton-loader" class="skeleton-loader">
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                </div>`)
        },
        success: (data) => {
            data = JSON.parse(data)
            multiplier = data.length <= 2 ? 2 : 1

            let ca1Score = ca2Score = ca3Score = Practical = Exam = 0;
            let ca1total = ca2total = ca3total = pratotal = examtotal = 0;
            data.map((item) => {
                ca1Score = ca1Score + safeParseFloat(item.CA1)
                ca1total = ca1total + safeParseFloat(item.ca1Total)
                ca2Score = ca2Score + safeParseFloat(item.CA2)
                ca2total = ca2total + safeParseFloat(item.ca2Total)
                ca3Score = ca3Score + safeParseFloat(item.CA3)
                ca3total = ca3total + safeParseFloat(item.ca3Total)
                Practical = Practical + safeParseFloat(item.Practical)
                pratotal = pratotal + safeParseFloat(item.praTotal)
                Exam = Exam + safeParseFloat(item.Exam)
                examtotal = examtotal + safeParseFloat(item.exaTotal)
            })
            let averageca1 = safeParseFloat(ca1Score / 2)
            let averageca1total = safeParseFloat(ca1total / 2)
            let averageca2 = safeParseFloat(ca2Score / 2)
            let averageca2total = safeParseFloat(ca2total / 2)
            let averageca3 = safeParseFloat(ca3Score / 2)
            let averageca3total = safeParseFloat(ca3total / 2)
            let averagepra = safeParseFloat(Practical / 2)
            let averagepratotal = safeParseFloat(pratotal / 2)
            let averageexa = safeParseFloat(Exam / 2)
            let averageexamtotal = safeParseFloat(examtotal / 2)
            let ca1percentage = safeParseFloat((averageca1 / averageca1total) * 100)
            let ca2percentage = safeParseFloat((averageca2 / averageca2total) * 100)
            let ca3percentage = safeParseFloat((averageca3 / averageca3total) * 100)
            let prapercentage = safeParseFloat((averagepra / averagepratotal) * 100)
            let exapercentage = safeParseFloat((averageexa / averageexamtotal) * 100)

            $("#student_term_based_report").html(`
            <p class="text-center">
                <strong>${$(".select_term_report.active").html()}</strong>
            </p>
            <div class="progress-group ${ca1total == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA1</span>
                <span class="float-right"><b>${averageca1 * multiplier}</b>/${averageca1total * multiplier}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca1percentage, 'bg')}" style="width: ${ca1percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${ca2total == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA2</span>
                <span class="float-right"><b>${averageca2 * multiplier}</b>/${averageca2total * multiplier}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca2percentage, 'bg')}" style="width: ${ca2percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${ca3total == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA3</span>
                <span class="float-right"><b>${averageca3 * multiplier}</b>/${averageca3total * multiplier}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca3percentage, 'bg')}" style="width: ${ca3percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${pratotal == 0 ? 'd-none' : ''}">
                <span class="progress-text">Practical</span>
                <span class="float-right"><b>${averagepra * multiplier}</b>/${averagepratotal * multiplier} </span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(prapercentage, 'bg')}" style="width: ${prapercentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${examtotal == 0 ? 'd-none' : ''}">
                <span class="progress-text">Exam</span>
                <span class="float-right"><b>${averageexa * multiplier}</b>/${averageexamtotal * multiplier}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar  ${getScoreColor(exapercentage, 'bg')}" style="width: ${exapercentage}%"></div>
                </div>
            </div>
            `)
        }
    })

}

function getmultipleSessions() {
    let student_id = $("#student_id_for_general_report").val()
    let sessionValue = Array.from(document.querySelectorAll('.select_sessions_report.active'))
    let subjectValue = $("#termSubjectValue").val()
    sessions = []
    sessionValue.map((item) => {
        console.log(item.dataset.value)
    })
    // return
    // alert(subjectValue)
    // // return
    // $.ajax({
    //     url: '../controller.php',
    //     type: 'POST',
    //     data: { 'action': 'getsinglesessionreport', subjectValue, sessionValue, student_id },
    //     beforeSend: () => {
    //         $("#student_single_session_based_report").html(
    //             `<div id="skeleton-loader" class="skeleton-loader">
    //                 <div class="skeleton-line skeleton-input"></div>
    //                 <div class="skeleton-line skeleton-input"></div>
    //                 <div class="skeleton-line skeleton-input"></div>
    //             </div>`)
    //     },
    //     success: (data) => {
    //         data = JSON.parse(data)
    //         let ca1total = ca2total = ca3total = pratotal = examtotal = 0;
    //         let term1ObTotal = term2ObTotal = term3ObTotal = 0;
    //         let term1Total = term2Total = term3Total = 0;
    //         data.map((item) => {
    //             if(item.Term) {
    //                 ca1total = safeParseFloat(item.ca1Total)
    //                 ca2total = safeParseFloat(item.ca2Total)
    //                 ca3total = safeParseFloat(item.ca3Total)
    //                 pratotal = safeParseFloat(item.praTotal)
    //                 examtotal = safeParseFloat(item.exaTotal)
    //                 console.log(item.Term)
    //                 term1ObTotal += item.Term == "1" ? ca1total + ca2total + ca3total + pratotal + examtotal : 0
    //                 term1Total += item.Term == "1" ? safeParseFloat(item.Total): 0
    //                 term2ObTotal += item.Term == "2" ? ca1total + ca2total + ca3total + pratotal + examtotal : 0
    //                 term2Total += item.Term == "2" ? safeParseFloat(item.Total): 0
    //                 term3ObTotal += item.Term == "3" ? ca1total + ca2total + ca3total + pratotal + examtotal : 0
    //                 term3Total += item.Term == "3" ? safeParseFloat(item.Total): 0
    //             }
    //         })
    //         console.log(term1Total,term1ObTotal,term2Total,term2ObTotal,term3Total)
    //         // alert(term1Total)
    //         console.log(ca1total,ca2total,ca3total,pratotal,examtotal)

    //         let term1percentage = safeParseFloat((term1Total / term1ObTotal) * 100)
    //         let term2percentage = safeParseFloat((term2Total / term2ObTotal) * 100)
    //         let term3percentage = safeParseFloat((term3Total / term3ObTotal) * 100)

    //         $("#student_single_session_based_report").html(`

    //         <div class="progress-group">
    //             <span class="progress-text">1st Term</span>
    //             <span class="float-right"><b>${term1Total}</b>/${term1ObTotal}</span>
    //             <div class="progress progress-sm">
    //                 <div class="progress-bar ${getScoreColor(term1percentage)}" style="width: ${term1percentage}%"></div>
    //             </div>
    //         </div>
    //         <div class="progress-group">
    //             <span class="progress-text">2nd Term</span>
    //             <span class="float-right"><b>${term2Total}</b>/${term2ObTotal}</span>
    //             <div class="progress progress-sm">
    //                 <div class="progress-bar ${getScoreColor(term2percentage)}" style="width: ${term2percentage}%"></div>
    //             </div>
    //         </div>
    //         <div class="progress-group">
    //             <span class="progress-text">3rd Term</span>
    //             <span class="float-right"><b>${term3Total}</b>/${term3ObTotal}</span>
    //             <div class="progress progress-sm">
    //                 <div class="progress-bar ${getScoreColor(term3percentage)}" style="width: ${term3percentage}%"></div>
    //             </div>
    //         </div>
    //         `)
    //     }
    // })

}

$(".select_sessions_report").click(function (event) {
    if ($(this).hasClass("active")) {
        $(this).removeClass("active")
    } else {
        $(this).addClass("active")
    }
    getmultipleSessions()
})


function getsingleSessionReport() {
    let student_id = $("#student_id_for_general_report").val() || $("#select_student_field").val()
    let sessionValue = $("#singleSessionValue").val()
    let subjectValue = $("#termSubjectValue").val()
    // alert(student_id)
    // return
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: { 'action': 'getsinglesessionreport', subjectValue, sessionValue, student_id },
        beforeSend: () => {
            $("#student_term1_report").html(
                `<div id="skeleton-loader" class="skeleton-loader">
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                </div>`)
        },
        success: (data) => {
            data = JSON.parse(data)
            let ca1T1Score = ca2T2Score = ca3TScore = Practical = Exam = 0;
            let ca1total = ca2total = ca3total = pratotal = examtotal = 0;
            let term1ObTotal = term2ObTotal = term3ObTotal = 0;
            let term1Total = term2Total = term3Total = 0;
            let examT1total = examT2total = examT3total = examT1 = examT2 = examT3 = 0;
            let ca1T1 = ca1T2 = ca1T3 = ca2T1 = ca2T2 = ca2T3 = ca3T1 = ca3T2 = ca3T3 = 0;
            let ca1T1total = ca1T2total = ca1T3total = ca2T1total = ca2T2total = ca2T3total = ca3T1total = ca3T2total = ca3T3total = 0;
            let praT1total = praT2total = praT3total = praT1 = praT2 = praT3 = 0;
            data.map((item) => {
                console.log(data)
                if (item.Term) {
                    if (item.Term == '1') {
                        ca1T1 = safeParseFloat(item.CA1)
                        ca2T1 = safeParseFloat(item.CA2)
                        ca3T1 = safeParseFloat(item.CA3)
                        praT1 = safeParseFloat(item.Practical)
                        examT1 = safeParseFloat(item.Exam)
                        ca1T1total = safeParseFloat(item.ca1Total)

                        ca2T1total = safeParseFloat(item.ca2Total)
                        ca3T1total = safeParseFloat(item.ca3Total)
                        praT1total = safeParseFloat(item.praTotal)

                        examT1total = safeParseFloat(item.exaTotal)
                        term1ObTotal = ca1T1total + ca2T1total + ca3T1total + praT1total + examT1total
                        term1Total = safeParseFloat(item.Total)
                    }
                    if (item.Term == '2') {
                        ca1T2 = safeParseFloat(item.CA1)
                        ca2T2 = safeParseFloat(item.CA2)
                        ca3T2 = safeParseFloat(item.CA3)
                        praT2 = safeParseFloat(item.Practical)
                        examT2 = safeParseFloat(item.Exam)
                        ca1T2total = safeParseFloat(item.ca1Total)
                        ca2T2total = safeParseFloat(item.ca2Total)
                        ca3T2total = safeParseFloat(item.ca3Total)
                        praT2total = safeParseFloat(item.praTotal)

                        examT2total = safeParseFloat(item.exaTotal)
                        term2ObTotal = ca1T2total + ca2T2total + ca3T2total + praT2total + examT2total
                        term2Total = safeParseFloat(item.Total)
                    }
                    if (item.Term == '3') {
                        ca1T3 = safeParseFloat(item.CA1)
                        ca2T3 = safeParseFloat(item.CA2)
                        ca3T3 = safeParseFloat(item.CA3)
                        praT3 = safeParseFloat(item.Practical)
                        examT3 = safeParseFloat(item.Exam)
                        ca1T3total = safeParseFloat(item.ca1Total)
                        ca2T3total = safeParseFloat(item.ca2Total)
                        ca3T3total = safeParseFloat(item.ca3Total)
                        praT3total = safeParseFloat(item.praTotal)
                        examT3total = safeParseFloat(item.exaTotal)
                        term3ObTotal = ca1T3total + ca2T3total + ca3T3total + praT3total + examT3total
                        term3Total = safeParseFloat(item.Total)
                    }
                    // ca1Score = item.Term == safeParseFloat(item.CA1)
                    // ca1total = safeParseFloat(item.ca1Total)
                    // ca2Score = safeParseFloat(item.CA2)
                    // ca2total = safeParseFloat(item.ca2Total)
                    // ca3Score = safeParseFloat(item.CA3)
                    // ca3total = safeParseFloat(item.ca3Total)
                    // Practical = safeParseFloat(item.Practical)
                    // pratotal = safeParseFloat(item.praTotal)
                    // Exam = safeParseFloat(item.Exam)
                    // examtotal = safeParseFloat(item.exaTotal)
                    // console.log(item.Term)
                    // term1ObTotal += item.Term == "1" ? ca1total + ca2total + ca3total + pratotal + examtotal : 0
                    // term1Total += item.Term == "1" ? safeParseFloat(item.Total): 0
                    // term2ObTotal += item.Term == "2" ? ca1total + ca2total + ca3total + pratotal + examtotal : 0
                    // term2Total += item.Term == "2" ? safeParseFloat(item.Total): 0
                    // term3ObTotal += item.Term == "3" ? ca1total + ca2total + ca3total + pratotal + examtotal : 0
                    // term3Total += item.Term == "3" ? safeParseFloat(item.Total): 0
                }
            })

            console.log('ca1t1-', ca1T1)
            console.log('ca1t2-', ca1T2)
            console.log('ca1t2-', ca1T3)

            // console.log('ca1-',ca1T1,term1Total,term1ObTotal,term2Total,term2ObTotal,term3Total)
            // alert(term1Total)
            // console.log(ca1total,ca2total,ca3total,pratotal,examtotal)
            let ca1T1percentage = safeParseFloat(ca1T1 / ca1T1total) * 100
            let ca1T2percentage = safeParseFloat(ca1T2 / ca1T2total) * 100
            let ca1T3percentage = safeParseFloat(ca1T3 / ca1T3total) * 100

            let ca2T1percentage = safeParseFloat(ca2T1 / ca2T1total) * 100
            let ca2T2percentage = safeParseFloat(ca2T2 / ca2T2total) * 100
            console.log("ca2T2percentage", ca2T2percentage)
            let ca2T3percentage = safeParseFloat(ca2T3 / ca2T3total) * 100

            let ca3T1percentage = safeParseFloat(ca3T1 / ca3T1total) * 100
            let ca3T2percentage = safeParseFloat(ca3T2 / ca3T2total) * 100
            let ca3T3percentage = safeParseFloat(ca3T3 / ca3T3total) * 100

            let term1percentage = Math.round(safeParseFloat(term1Total / term1ObTotal) * 100)
            let term2percentage = Math.round(safeParseFloat(term2Total / term2ObTotal) * 100)
            let term3percentage = Math.round(safeParseFloat(term3Total / term3ObTotal) * 100)
            termtotal_array = [term1percentage, term2percentage, term3percentage]
            termobtainableTotals = [term1ObTotal, term2ObTotal, term3ObTotal]
            sumtotal = 0;
            sumObtainabletotal = 0;
            termtotal_array.map((item) => {
                sumtotal += item
            })
            termobtainableTotals.map((item) => {
                sumObtainabletotal += item
            })
            console.log(termtotal_array.length)
            term_average_score = sumtotal / termtotal_array.length
            term_obtainabletotal_score_average = sumObtainabletotal / termobtainableTotals.length

            console.log('avr obtain', term_obtainabletotal_score_average)
            session_percentage = Math.round(safeParseFloat(term_average_score / term_obtainabletotal_score_average) * 100)
            console.log('termperce', session_percentage)

            var ticksStyle = {
                fontColor: '#495057',
                fontStyle: 'bold'
            }

            $("#overall_performance").html(`
                <div class="mb-3" style="width:163px;">
                <h3 class="mb-0">${session_percentage}%</h3>
                <p>Session Perfomance</p>
            </div>
            `)

            setTimeout(() => {
                display_chart1(term1percentage, term2percentage, term3percentage)
            }, 200)
            // setTimeout(checkinp,200)
            // alert($("#visitors-chart").attr("height"))
            // if ($("#visitors-chart").attr("height") != "0") {
            //     alert('no')
            // } else {
            //     display_chart1(term1percentage, term2percentage, term3percentage)
            //     alert('yes')
            // }
            // $("#score_chart").html(`
            //     <div class="position-relative mb-4">
            //       <canvas id="visitors-chart" height="200"></canvas>
            //     </div>
            // `)
            // let mode = 'index'
            // let intersect = true
            // let $visitorsChart = $('#visitors-chart')
            // // eslint-disable-next-line no-unused-var
            // let visitorsChart = new Chart($visitorsChart, {
            //     data: {
            //         labels: ['1st Term', '2nd Term', '3rd term'],
            //         datasets: [{
            //             type: 'line',
            //             data: [term1percentage, term2percentage, term3percentage],
            //             backgroundColor: 'transparent',
            //             borderColor: '#007bff',
            //             pointBorderColor: '#007bff',
            //             pointBackgroundColor: '#007bff',
            //             fill: false,
            //             pointHoverBackgroundColor: '#007bff',
            //             pointHoverBorderColor: '#007bff'
            //         },
            //         ]
            //     },
            //     options: {
            //         maintainAspectRatio: false,
            //         tooltips: {
            //             mode: mode,
            //             intersect: intersect
            //         },
            //         hover: {
            //             mode: mode,
            //             intersect: intersect
            //         },
            //         legend: {
            //             display: false
            //         },
            //         scales: {
            //             yAxes: [{
            //                 // display: false,
            //                 gridLines: {
            //                     display: true,
            //                     lineWidth: '4px',
            //                     color: 'rgba(0, 0, 0, .2)',
            //                     zeroLineColor: 'transparent'
            //                 },
            //                 ticks: $.extend({
            //                     beginAtZero: true,
            //                     suggestedMax: 100
            //                 }, ticksStyle)
            //             }],
            //             xAxes: [{
            //                 display: true,
            //                 gridLines: {
            //                     display: false
            //                 },
            //                 ticks: ticksStyle
            //             }]
            //         }
            //     }
            // })



            console.log("praT1total", praT1total)
            console.log(typeof (praT1total))
            $("#student_term1_report").html(`
                <p class="text-center">
                <strong>1st Term</strong>
            </p>
             <div class="my-2 text-center" style="padding: 5px;">
            <p>Overall Perfomance - ${term1percentage}%</p>
            </div>
            <div class="progress-group ${skul_settings['ca1'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA1</span>
                <span class="float-right"><b>${ca1T1}</b>/${ca1T1total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca1T1percentage, 'bg')}" style="width: ${ca1T1percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['ca2'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA2</span>
                <span class="float-right"><b>${ca2T1}</b>/${ca2T1total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca2T1percentage, 'bg')}" style="width: ${ca2T1percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['ca3'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA3</span>
                <span class="float-right"><b>${ca3T1}</b>/${ca3T1total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca3T1percentage, 'bg')}" style="width: ${ca3T1percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['pra'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">Practical</span>
                <span class="float-right"><b>${praT1}</b>/${praT1total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(safeParseFloat(praT1 / praT1total) * 100, 'bg')}" style="width: ${safeParseFloat(praT1 / praT1total) * 100}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['exa'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">Exam</span>
                <span class="float-right"><b>${examT1}</b>/${examT1total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(safeParseFloat(examT1 / examT1total) * 100, 'bg')}" style="width: ${safeParseFloat(examT1 / examT1total) * 100}%"></div>
                </div>
            </div>
           
            `)

            if (ca1T2total == 0 && ca2T2total == 0 && ca2T2total == 0) {
                htmltag = '', comment = '', value =
                    comparativeComment = ''
            } else {
                if ((term2percentage - term1percentage) < 0) {
                    htmltag = '<span class="text-danger"><i class="fas fa-arrow-down"></i>'
                    value = Math.abs(term2percentage - term1percentage)
                    comment = 'less than'
                    comparativeComment = htmltag + ' ' + value + '%' + ' ' + comment + ' 1st term'
                } else {
                    htmltag = '<span class="text-success"><i class="fas fa-arrow-up"></i>'
                    value = Math.abs(term2percentage - term1percentage)
                    comment = 'higher than'
                    comparativeComment = htmltag + ' ' + value + '%' + ' ' + comment + ' 1st term'
                }
            }
            $("#student_term2_report").html(`
                  <p class="text-center">
                <strong>2nd Term</strong>
            </p>
            <div class="my-2 text-center" style="padding: 5px;">
            <p>Overall Perfomance - ${term2percentage}%</p>
            <p>${comparativeComment}</p>
            </div>
            <div class="progress-group ${skul_settings['ca1'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA1</span>
                <span class="float-right"><b>${ca1T2}</b>/${ca1T2total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca1T2percentage, 'bg')}" style="width: ${ca1T2percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['ca2'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA2</span>
                <span class="float-right"><b>${ca2T2}</b>/${ca2T2total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca2T2percentage, 'bg')}" style="width: ${ca2T2percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['ca3'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA3</span>
                <span class="float-right"><b>${ca3T2}</b>/${ca3T2total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca3T2percentage, 'bg')}" style="width: ${ca3T2percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['pra'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">Practical</span>
                <span class="float-right"><b>${praT2}</b>/${praT2total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(safeParseFloat(praT2 / praT2total) * 100, 'bg')}" style="width: ${safeParseFloat(praT2 / praT2total) * 100}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['exa'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">Exam</span>
                <span class="float-right"><b>${examT2}</b>/${examT2total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(safeParseFloat(examT2 / examT2total) * 100, 'bg')}" style="width: ${safeParseFloat(examT2 / examT2total) * 100}%"></div>
                </div>
            </div>
            
            `)
            if (ca1T3total == 0 && ca2T3total == 0 && ca2T3total == 0) {
                htmltag = '', comment = '', value =
                    comparativeComment = ''
            } else {
                if ((term3percentage - term2percentage) < 0) {
                    htmltag = '<span class="text-danger"><i class="fas fa-arrow-down"></i>'
                    value = Math.abs(term3percentage - term2percentage)
                    comment = 'less than'
                    comparativeComment = htmltag + ' ' + value + '%' + ' ' + comment + ' 2nd term'
                } else {
                    htmltag = '<span class="text-success"><i class="fas fa-arrow-up"></i>'
                    value = Math.abs(term3percentage - term2percentage)
                    comment = 'higher than'
                    comparativeComment = htmltag + ' ' + value + '%' + ' ' + comment + ' 2nd term'
                }
            }
            console.log("term3percentage", htmltag)
            $("#student_term3_report").html(`
                  <p class="text-center">
                <strong>3rd Term</strong>
            </p>
             <div class="my-2 text-center" style="padding: 5px;">
            <p>Overall Perfomance - ${term3percentage}%</p>
            <p>${comparativeComment}</p>
            </div>
            <div class="progress-group ${skul_settings['ca1'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA1</span>
                <span class="float-right"><b>${ca1T3}</b>/${ca1T3total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca1T3percentage, 'bg')}" style="width: ${ca1T3percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['ca2'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA2</span>
                <span class="float-right"><b>${ca2T3}</b>/${ca2T3total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca2T3percentage, 'bg')}" style="width: ${ca2T3percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['ca3'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">CA3</span>
                <span class="float-right"><b>${ca3T3}</b>/${ca3T3total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(ca3T3percentage, 'bg')}" style="width: ${ca3T3percentage}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['pra'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">Practical</span>
                <span class="float-right"><b>${praT3}</b>/${praT3total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(safeParseFloat(praT3 / praT3total) * 100, 'bg')}" style="width: ${safeParseFloat(praT3 / praT3total) * 100}%"></div>
                </div>
            </div>
            <div class="progress-group ${skul_settings['exa'] == 0 ? 'd-none' : ''}">
                <span class="progress-text">Exam</span>
                <span class="float-right"><b>${examT3}</b>/${examT3total}</span>
                <div class="progress progress-sm">
                    <div class="progress-bar ${getScoreColor(safeParseFloat(examT3 / examT3total) * 100, 'bg')}" style="width: ${safeParseFloat(examT3 / examT3total) * 100}%"></div>
                </div>
            </div>
           
            `)
        }
    })
}

function toggle_accordion(event) {
    let parent_element = $(event).parents(".accordion")
    if ((parent_element).find(".collapse").hasClass("show")) {
        // alert('open')
        $(event).html("Show more")

    } else {
        // alert('closed')
        $(event).html("Show less")
    }

}
// alert('kk')
function selectstudent(event) {
    $(".select_student").removeClass('active');
    $('.class_value').removeClass('active');
    $(event).find('.class_value').toggleClass('active');
    $(event).toggleClass('active');
    // display_table()
    $("#select_student_field").val($(event).attr("data-studentId"))
    $("#select_class_field").val($(event).attr("data-class_id"))
    // alert("lll")
    let path = "../uploads/"
    $(".name").html($(event).attr("data-lastname") + ' ' + $(event).attr("data-firstname") + ' ' + $(event).attr("data-middlename"))
    $(".classname").html($(event).attr("data-classname"))
    $(".student_photo").attr("src", path + $(event).attr("data-photo"))
    $(".gender").html($(event).attr("data-gender"))
    $(".dob").html($(event).attr("data-dob"))
    $(".email").html($(event).attr("data-email"))
    $(".phone").html($(event).attr("data-phone"))
    $(".p_name").html($(event).attr("data-p_lastname") + ' ' + $(event).attr("data-p_firstname"))
    $(".p_phone").html($(event).attr("data-p_phone"))
    $(".p_email").html($(event).attr("data-p_email"))
    $(".p_address").html($(event).attr("data-p_address"))
    get_score_data()

}
// alert('kk')
function load_subjects_by_cat(parentclass, elementId, element) {

    let sentdata;
    if ($("#class_page").val() === 'display_class') {
        sentdata = { "action": "get_subject_by_category_for_class", "datatype": element }
    } else {
        sentdata = { "action": "get_subject_by_category", "datatype": element };
    }
    $.ajax({
        url: "../controller.php",
        type: "POST",
        data: sentdata,
        beforeSend: () => {
            $("." + parentclass).find('p.subject_preloader').hide()
        },
        success: (data) => {
            data = data.trim()
            $("." + parentclass).find('.' + elementId).html(data)
            $("." + elementId).find('p.subject_preloader').hide()
        }
    })
}

function update_subject_category(id) {
    $("#update_subject_category").modal('show')
    $.ajax({
        url: '../controller.php',
        type: "POST",
        data: { 'action': 'getallsubforupdate', id, },
        beforeSend: () => {
            $("#update_category_modal_body").html(
                `<div id="skeleton-loader" class="skeleton-loader">
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-button"></div>
                </div>`)
        },
        success: (data) => {
            data = data.trim()
            $("#update_category_modal_body").html(data)

        }
    })
}


function checkbtn(event) {
    event.preventDefault();
    let button = $(event.target);
    let nameattr = button.attr("name");

    if (button.hasClass(nameattr) && button.hasClass('active')) {
        $(`.togglebtn.${nameattr}`).removeClass('active');
    } else {
        $(`.togglebtn.${nameattr}`).removeClass('active');
        button.addClass('active');
    }

    console.log($(".togglebtn.punctuality.active").val())
    let beahvedata = {
        punctuality: !$(".togglebtn.punctuality.active").val() ? 0 : $(".togglebtn.punctuality.active").val(),
        classattendance: !$(".togglebtn.classattendance.active").val() ? 0 : $(".togglebtn.classattendance.active").val(),
        resptoass: !$(".togglebtn.resptoass.active").val() ? 0 : $(".togglebtn.resptoass.active").val(),
        Neatness: !$(".togglebtn.Neatness.active").val() ? 0 : $(".togglebtn.Neatness.active").val(),
        Politeness: !$(".togglebtn.Politeness.active").val() ? 0 : $(".togglebtn.Politeness.active").val(),
        Honesty: !$(".togglebtn.Honesty.active").val() ? 0 : $(".togglebtn.Honesty.active").val(),
        selfcontrol: !$(".togglebtn.selfcontrol.active").val() ? 0 : $(".togglebtn.selfcontrol.active").val(),
        relationship: !$(".togglebtn.relationship.active").val() ? 0 : $(".togglebtn.relationship.active").val(),
        responsibility: !$(".togglebtn.responsibility.active").val() ? 0 : $(".togglebtn.responsibility.active").val(),
        organizationability: !$(".togglebtn.organizationability.active").val() ? 0 : $(".togglebtn.organizationability.active").val(),
        Obedience: !$(".togglebtn.Obedience.active").val() ? 0 : $(".togglebtn.Obedience.active").val(),


        // psychomotive skills
        Creativity: !$(".togglebtn.Creativity.active").val() ? 0 : $(".togglebtn.Creativity.active").val(),
        Writing: !$(".togglebtn.Writing.active").val() ? 0 : $(".togglebtn.Writing.active").val(),
        Fluency: !$(".togglebtn.Fluency.active").val() ? 0 : $(".togglebtn.Fluency.active").val(),
        Sport: !$(".togglebtn.Sport.active").val() ? 0 : $(".togglebtn.Sport.active").val(),
        Games: !$(".togglebtn.Games.active").val() ? 0 : $(".togglebtn.Games.active").val(),
        DrawingPainting: !$(".togglebtn.DrawingPainting.active").val() ? 0 : $(".togglebtn.DrawingPainting.active").val(),
        Music: !$(".togglebtn.Music.active").val() ? 0 : $(".togglebtn.Music.active").val(),
        Games: !$(".togglebtn.Games.active").val() ? 0 : $(".togglebtn.Games.active").val(),
        HandlingTools: !$(".togglebtn.HandlingTools.active").val() ? 0 : $(".togglebtn.HandlingTools.active").val(),
        Crafts: !$(".togglebtn.Crafts.active").val() ? 0 : $(".togglebtn.Crafts.active").val(),
    }
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: {
            action: "submit_behaviour_comment",
            beahvedata,
            studentId: $(".student_id_for_comment").val(),
            term: $(".comment_term").val(),
            session: $(".comment_Session").val(),
            class: $(".comment_class").val()
        },
        success: function (response) {
            console.log(response); // Handle the server response here
        },
        error: function (jqXHR, textStatus, errorThrown) {
            console.error('Error:', errorThrown);
        }
    });
}

// Attach event listeners to each button
$('.togglebtn').on('click', function (event) {
    checkbtn(event);
});
// alert('pp')
function handleSelect(clickedButton) {
    // alert(viewOrPost)
    $("#by_stud_btn, #by_subj_btn, #by_class_btn").removeClass('active');
    // const classValue = $("#select_class_field").val()
    if (clickedButton === "by_stud_btn") {
        $('#' + clickedButton).addClass('active');
        $('#select_student').show();
        // $('#select_subject').empty();
        $("#select_subject_field").empty()
        $('#select_subject').hide();
        $(".thecontentbox, .by_class_filter").hide()
        $(".data_overlay").show()
        get_score_data()

        // getstudents(classValue);
        // setfilter('student');
    } else if (clickedButton === "by_subj_btn") {
        $('#' + clickedButton).addClass('active');
        $("#select_subject").show()
        $('#select_student').hide();
        $("#select_student_field").empty()
        $(".thecontentbox").hide()
        $(".data_overlay").show()
        // getstudents(classValue);
        // setfilter('subject');
    }
    else if (clickedButton === "by_class_btn") {
        $('#' + clickedButton).addClass('active');
        $('#select_class, #select_subject').show();
        $('#select_student').hide();
        $(".thecontentbox, .by_class_filter").hide()
        $(".data_overlay").show()
        by_class_view_content()
        // getstudents(classValue);
        // setfilter('subject');
    }
}

// alert("jjj")
// function by_class_view_content() {
//     const term_id = $(".select_btn.termclass.active").attr("data-name");
//     const class_id = $("#select_class_field").val();
//     const session_id = $("#select_session_field").val();

//     if (!class_id) {
//         $(".data_overlay").html(`
//             <p class="font-weight-bold">Fill the forms appropiately</p>
//         `)
//         $(".data_overlay").show()
//         $(".thecontentbox, .by_class_filter").hide()
//         return
//     }

//     $.ajax({
//         url: "../controller.php",
//         type: "post",
//         data: { 'action': 'get_score_data_by_class_term', term_id, class_id, session_id },
//         beforeSend: () => {
//             $(".data_overlay").html(`
//             <p class="font-weight-bold">Loading...</p>
//             `)
//             $(".thecontentbox, .by_class_filter").hide()
//             // $(".thecontentbox").hide()
//             $(".data_overlay").show()
//         },
//         success: (data) => {
//             data = JSON.parse(data)
//             let grader = format_grade(skul_settings['grading'])
//             if (data.length <= 1) {
//                 $(".data_overlay").html(`
//                 <p class="font-weight-bold">No record for the class selected</p>
//             `)
//                 return
//             }
//             $(".by_class_filter").show()
//             $(".data_overlay").hide()
//             $(".data_overlay").html(`
//             <p class="font-weight-bold">Fill the forms appropiately</p>
//         `)
//             const colspan_lenght = parseInt(settingsData.ca1) + parseInt(settingsData.ca2) + parseInt(settingsData.ca3) + parseInt(settingsData.pra) + parseInt(settingsData.exa);

//             const subjects = {};

//             // Group data by subject
//             data.forEach((record) => {
//                 if (!subjects[record.subject]) subjects[record.subject] = [];
//                 subjects[record.subject].push(record);
//             });

//             // Table header construction
//             let str = `
//             <table id="class_score_table" class="display nowrap" style="width:100%;">
//                 <thead>
//                     <tr>
//                         <th></th>`;

//             // Loop through subjects to create subject-specific headers
//             Object.keys(subjects).forEach((subject) => {
//                 str += `<th colspan="${colspan_lenght + 2}">${subject}</th>`;
//             });

//             str += `
//                     </tr>
//                     <tr>
//                         <th>Students</th>`;

//             // Add score components for each subject
//             Object.keys(subjects).forEach(() => {
//                 str += `
//                     <th class="score_head ${settingsData.ca1 == 0 ? 'd-none' : ''}">CA1</th>
//                     <th class="score_head ${settingsData.ca2 == 0 ? 'd-none' : ''}">CA2</th>
//                     <th class="score_head ${settingsData.ca3 == 0 ? 'd-none' : ''}">CA3</th>
//                     <th class="score_head ${settingsData.pra == 0 ? 'd-none' : ''}">Practical</th>
//                     <th class="${settingsData.exa == 0 ? 'd-none' : ''}">Exam</th>
//                     <th>Total</th>
//                     <th>Total(%)</th>`;
//             });
//             str += `</tr>
//                 </thead>
//                 <tbody>`;

//             // Construct table rows for each student
//             const students = {};
//             data.forEach((record) => {
//                 if (!students[record.student_id]) students[record.student_id] = {};
//                 students[record.student_id][record.subject] = record;
//             });

//             // Fill each student row with data for each subject
//             Object.keys(students).forEach((studentId) => {
//                 const studentSubjects = students[studentId];
//                 const studentName = studentSubjects[Object.keys(studentSubjects)[0]].student_name;

//                 str += `<tr><td>${studentName}</td>`;

//                 Object.keys(subjects).forEach((subject) => {
//                     const record = studentSubjects[subject];

//                     if (record) {
//                         // console.log("record",record)
//                         const total = safeParseFloat(record.CA1) + safeParseFloat(record.CA2) + safeParseFloat(record.CA3) + safeParseFloat(record.Practical) + safeParseFloat(record.Exam);
//                         const totalMax = safeParseFloat(record.ca1Total) + safeParseFloat(record.ca2Total) + safeParseFloat(record.ca3Total) + safeParseFloat(record.praTotal) + safeParseFloat(record.exaTotal);
//                         const percentage = totalMax > 0 ? ((total / totalMax) * 100).toFixed(0) : 0

//                         str += `
//                             <td class="${settingsData.ca1 == 0 ? 'd-none' : ''}">${record.CA1}</td>
//                             <td class="${settingsData.ca2 == 0 ? 'd-none' : ''}">${record.CA2}</td>
//                             <td class="${settingsData.ca3 == 0 ? 'd-none' : ''}">${record.CA3}</td>
//                             <td class="${settingsData.pra == 0 ? 'd-none' : ''}">${record.Practical}</td>
//                             <td class="${settingsData.exa == 0 ? 'd-none' : ''}">${record.Exam}</td>
//                             <td>${total}</td>
//                             <td>${percentage}</td>`;
//                     } else {
//                         str += `<td colspan="${colspan_lenght + 2}">0</td>`;
//                     }
//                 });

//                 str += `</tr>`;
//             });

//             str += `</tbody></table>`;

//             $("#class_table_data").html(str);
//             $('#class_score_table').DataTable({
//                 scrollX: true,
//                 paging: false,
//                 ordering: false,
//                 fixedColumns: {
//                     left: 1,
//                     right: 0
//                 }
//             });
//         }
//     });
//     get_approval_btn(class_id, term_id, session_id)
// }
function by_class_view_content() {
    const term_id = $(".select_btn.termclass.active").attr("data-name");
    const class_id = $("#select_class_field").val();
    const session_id = $("#select_session_field").val();

    if (!class_id) {
        $(".data_overlay").html(`
            <p class="font-weight-bold">Fill the forms appropiately</p>
        `);
        $(".data_overlay").show();
        $(".thecontentbox, .by_class_filter").hide();
        return;
    }

    $.ajax({
        url: "../controller.php",
        type: "post",
        data: {
            action: "get_score_data_by_class_term",
            term_id,
            class_id,
            session_id,
        },
        beforeSend: () => {
            $(".data_overlay").html(`
            <p class="font-weight-bold">Loading...</p>
            `);
            $(".thecontentbox, .by_class_filter").hide();
            // $(".thecontentbox").hide()
            $(".data_overlay").show();
        },
        success: (data) => {
            data = JSON.parse(data);
            let grader = format_grade(skul_settings["grading"]);
            if (data.length <= 1) {
                $(".data_overlay").html(`
                <p class="font-weight-bold">No record for the class selected</p>
            `);
                return;
            }
            $(".by_class_filter").show();
            $(".data_overlay").hide();
            $(".data_overlay").html(`
            <p class="font-weight-bold">Fill the forms appropiately</p>
        `);
            // compute component count safely (avoid NaN if settingsData entries are missing)
            const ca1Flag = Number(settingsData.ca1) || 0;
            const ca2Flag = Number(settingsData.ca2) || 0;
            const ca3Flag = Number(settingsData.ca3) || 0;
            const praFlag = Number(settingsData.pra) || 0;
            const exaFlag = Number(settingsData.exa) || 0;
            const colspan_lenght = ca1Flag + ca2Flag + ca3Flag + praFlag + exaFlag;

            const subjects = {};

            // Group data by subject
            data.forEach((record) => {
                if (!subjects[record.subject]) subjects[record.subject] = [];
                subjects[record.subject].push(record);
            });

            // Table header construction
            let str = `
            <table id="class_score_table" class="display nowrap" style="width:100%;">
                <thead>
                    <tr>
                        <th></th>`;

            // Loop through subjects to create subject-specific headers
            Object.keys(subjects).forEach((subject) => {
                str += `<th colspan="${colspan_lenght + 3}">${subject}</th>`;
            });

            str += `
                    <th colspan="3">Summary</th></tr>
                    <tr>
                        <th>Students</th>`;

            // Add score components for each subject
            Object.keys(subjects).forEach(() => {
                str += `
                    <th class="score_head ${settingsData.ca1 == 0 ? "d-none" : ""
                    }">CA1</th>
                    <th class="score_head ${settingsData.ca2 == 0 ? "d-none" : ""
                    }">CA2</th>
                    <th class="score_head ${settingsData.ca3 == 0 ? "d-none" : ""
                    }">CA3</th>
                    <th class="score_head ${settingsData.pra == 0 ? "d-none" : ""
                    }">Practical</th>
                    <th class="${settingsData.exa == 0 ? "d-none" : ""
                    }">Exam</th>
                    <th>Total</th>
                    <th>Total(%)</th>
                    <th>Grade</th>`;
            });
            str += `
                    <th>Overall Total</th>
                    <th>Overall Percentage</th>
                    <th>Approval</th></tr>
                </thead>
                <tbody>`;

            // Construct table rows for each student
            const students = {};
            data.forEach((record) => {
                if (!students[record.student_id]) students[record.student_id] = {};
                students[record.student_id][record.subject] = record;
            });

            // Fill each student row with data for each subject
            Object.keys(students).forEach((studentId) => {
                const studentSubjects = students[studentId];
                const studentName =
                    studentSubjects[Object.keys(studentSubjects)[0]].student_name;

                str += `<tr><td><a href="students?id=${studentId}">${studentName}</a></td>`;

                let overallTotal = 0;
                let subjectsWithScoreCount = 0;

                Object.keys(subjects).forEach((subject) => {
                    const record = studentSubjects[subject];

                    if (record) {
                        // console.log("record",record)
                        const total =
                            safeParseFloat(record.CA1) +
                            safeParseFloat(record.CA2) +
                            safeParseFloat(record.CA3) +
                            safeParseFloat(record.Practical) +
                            safeParseFloat(record.Exam);

                        // Use Total from DB if available, otherwise use calculated total
                        const dbTotal =
                            record.Total !== undefined ? safeParseFloat(record.Total) : total;

                        const totalMax =
                            safeParseFloat(record.ca1Total) +
                            safeParseFloat(record.ca2Total) +
                            safeParseFloat(record.ca3Total) +
                            safeParseFloat(record.praTotal) +
                            safeParseFloat(record.exaTotal);
                        const percentage =
                            totalMax > 0 ? ((dbTotal / totalMax) * 100).toFixed(0) : 0;
                        const grade = calculateGrade1(percentage, grader);

                        if (totalMax > 0) {
                            overallTotal += dbTotal;
                            if (dbTotal > 0) {
                                subjectsWithScoreCount++;
                            }
                        }

                        str += `
                            <td class="${settingsData.ca1 == 0 ? "d-none" : ""
                            }">${safeParseFloat(record.CA1)}</td>
                            <td class="${settingsData.ca2 == 0 ? "d-none" : ""
                            }">${safeParseFloat(record.CA2)}</td>
                            <td class="${settingsData.ca3 == 0 ? "d-none" : ""
                            }">${safeParseFloat(record.CA3)}</td>
                            <td class="${settingsData.pra == 0 ? "d-none" : ""
                            }">${safeParseFloat(record.Practical)}</td>
                            <td class="${settingsData.exa == 0 ? "d-none" : ""
                            }">${safeParseFloat(record.Exam)}</td>
                            <td>${dbTotal}</td>
                            <td>${percentage}</td>
                            <td>${grade}</td>`;
                    } else {
                        // When a student has no record for this subject, emit the same number of <td>
                        // cells as the header (one per component + Total + Total(%)). Using a single
                        // colspan in the body can break DataTables; emitting individual cells keeps
                        // the column count stable.
                        // CA1
                        str += `<td class="${ca1Flag == 0 ? "d-none" : ""}">0</td>`;
                        // CA2
                        str += `<td class="${ca2Flag == 0 ? "d-none" : ""}">0</td>`;
                        // CA3
                        str += `<td class="${ca3Flag == 0 ? "d-none" : ""}">0</td>`;
                        // Practical
                        str += `<td class="${praFlag == 0 ? "d-none" : ""}">0</td>`;
                        // Exam
                        str += `<td class="${exaFlag == 0 ? "d-none" : ""}">0</td>`;
                        // Total
                        str += `<td>0</td>`;
                        // Total(%)
                        str += `<td>0</td>`;
                        // Grade
                        str += `<td>-</td>`;
                    }
                });

                // Calculate overall percentage
                const overallObtainable = subjectsWithScoreCount * 100;
                const overallPercentage =
                    overallObtainable > 0
                        ? ((overallTotal / overallObtainable) * 100).toFixed(1)
                        : 0;
                str += `<td>${overallTotal}</td><td>${overallPercentage}%</td>`;

                // Get the first record for this student to check status
                const firstRecord = studentSubjects[Object.keys(studentSubjects)[0]];
                str += `<td>
    <button type="button" class="btn btn-sm btn-${firstRecord.status == 1 ? "success" : "warning"
                    }" onclick="toggleApproval(${studentId}, ${term_id}, ${session_id},${class_id}, this)">
        ${firstRecord.status == 1 ? "Approved" : "Approve"}
    </button>
</td></tr>`;
            });

            str += `</tbody></table>`;

            $("#class_table_data").html(str);
            $("#class_score_table").DataTable({
                scrollX: true,
                paging: false,
                ordering: true,
                fixedColumns: {
                    left: 1,
                    right: 0,
                },
            });
        },
    });
    get_approval_btn(class_id, term_id, session_id);
}
// function by_class_view_content() {
//     const term_id = $(".select_btn.termclass.active").attr("data-name");
//     const class_id = $("#select_class_field").val();
//     const session_id = $("#select_session_field").val();

//     if (!class_id) {
//         $(".data_overlay").html(`
//             <p class="font-weight-bold">Fill the forms appropiately</p>
//         `)
//         $(".data_overlay").show()
//         $(".thecontentbox, .by_class_filter").hide()
//         return
//     }

//     $.ajax({
//         url: "../controller.php",
//         type: "post",
//         data: { 'action': 'get_score_data_by_class_term', term_id, class_id, session_id },
//         beforeSend: () => {
//             $(".data_overlay").html(`
//             <p class="font-weight-bold">Loading...</p>
//             `)
//             $(".thecontentbox, .by_class_filter").hide()
//             // $(".thecontentbox").hide()
//             $(".data_overlay").show()
//         },
//         success: (data) => {
//             data = JSON.parse(data)
//             let grader = format_grade(skul_settings['grading'])
//             if (data.length <= 1) {
//                 $(".data_overlay").html(`
//                 <p class="font-weight-bold">No record for the class selected</p>
//             `)
//                 return
//             }
//             $(".by_class_filter").show()
//             $(".data_overlay").hide()
//             $(".data_overlay").html(`
//             <p class="font-weight-bold">Fill the forms appropiately</p>
//         `)
//             const colspan_lenght = parseInt(settingsData.ca1) + parseInt(settingsData.ca2) + parseInt(settingsData.ca3) + parseInt(settingsData.pra) + parseInt(settingsData.exa);

//             const subjects = {};

//             // Group data by subject
//             data.forEach((record) => {
//                 if (!subjects[record.subject]) subjects[record.subject] = [];
//                 subjects[record.subject].push(record);
//             });

//             // Table header construction
//             let str = `
//             <table id="class_score_table" class="display nowrap" style="width:100%;">
//                 <thead>
//                     <tr>
//                         <th></th>`;

//             // Loop through subjects to create subject-specific headers
//             Object.keys(subjects).forEach((subject) => {
//                 str += `<th colspan="${colspan_lenght + 2}">${subject}</th>`;
//             });

//             str += `
//                     <th></th></tr>
//                     <tr>
//                         <th>Students</th>`;

//             // Add score components for each subject
//             Object.keys(subjects).forEach(() => {
//                 str += `
//                     <th class="score_head ${settingsData.ca1 == 0 ? 'd-none' : ''}">CA1</th>
//                     <th class="score_head ${settingsData.ca2 == 0 ? 'd-none' : ''}">CA2</th>
//                     <th class="score_head ${settingsData.ca3 == 0 ? 'd-none' : ''}">CA3</th>
//                     <th class="score_head ${settingsData.pra == 0 ? 'd-none' : ''}">Practical</th>
//                     <th class="${settingsData.exa == 0 ? 'd-none' : ''}">Exam</th>
//                     <th>Total</th>
//                     <th>Total(%)</th>`;
//             });
//             str += `
//                     <th>Approval</th></tr>
//                 </thead>
//                 <tbody>`;

//             // Construct table rows for each student
//             const students = {};
//             data.forEach((record) => {
//                 if (!students[record.student_id]) students[record.student_id] = {};
//                 students[record.student_id][record.subject] = record;
//             });

//             // Fill each student row with data for each subject
//             Object.keys(students).forEach((studentId) => {
//                 const studentSubjects = students[studentId];
//                 const studentName = studentSubjects[Object.keys(studentSubjects)[0]].student_name;

//                 str += `<tr><td><a href="students?id=${studentId}">${studentName}</a></td>`;

//                 Object.keys(subjects).forEach((subject) => {
//                     const record = studentSubjects[subject];

//                     if (record) {
//                         // console.log("record",record)
//                         const total = safeParseFloat(record.CA1) + safeParseFloat(record.CA2) + safeParseFloat(record.CA3) + safeParseFloat(record.Practical) + safeParseFloat(record.Exam);
//                         const totalMax = safeParseFloat(record.ca1Total) + safeParseFloat(record.ca2Total) + safeParseFloat(record.ca3Total) + safeParseFloat(record.praTotal) + safeParseFloat(record.exaTotal);
//                         const percentage = totalMax > 0 ? ((total / totalMax) * 100).toFixed(0) : 0

//                         str += `
//                             <td class="${settingsData.ca1 == 0 ? 'd-none' : ''}">${record.CA1}</td>
//                             <td class="${settingsData.ca2 == 0 ? 'd-none' : ''}">${record.CA2}</td>
//                             <td class="${settingsData.ca3 == 0 ? 'd-none' : ''}">${record.CA3}</td>
//                             <td class="${settingsData.pra == 0 ? 'd-none' : ''}">${record.Practical}</td>
//                             <td class="${settingsData.exa == 0 ? 'd-none' : ''}">${record.Exam}</td>
//                             <td>${total}</td>
//                             <td>${percentage}</td>`;
//                     } else {
//                         str += `<td colspan="${colspan_lenght + 2}">0</td>`;
//                     }
//                 });
// // Get the first record for this student to check status
// const firstRecord = studentSubjects[Object.keys(studentSubjects)[0]];
// str += `<td>
//     <button type="button" class="btn btn-sm btn-${firstRecord.status == 1 ? 'success' : 'warning'}" onclick="toggleApproval(${studentId}, ${term_id}, ${session_id},${class_id}, this)">
//         ${firstRecord.status == 1 ? 'Approved' : 'Approve'}
//     </button>
// </td></tr>`;
//             });

//             str += `</tbody></table>`;

//             $("#class_table_data").html(str);
//             $('#class_score_table').DataTable({
//                 scrollX: true,
//                 paging: false,
//                 ordering: false,
//                 fixedColumns: {
//                     left: 1,
//                     right: 0
//                 }
//             });
//         }
//     });
//     get_approval_btn(class_id, term_id, session_id)
// }
// function by_class_view_content() {
//     const term_id = $(".select_btn.termclass.active").attr("data-name");
//     const class_id = $("#select_class_field").val();
//     const session_id = $("#select_session_field").val();

//     if (!class_id) {
//         $(".data_overlay").html(`
//             <p class="font-weight-bold">Fill the forms appropiately</p>
//         `)
//         $(".data_overlay").show()
//         $(".thecontentbox, .by_class_filter").hide()
//         return
//     }

//     $.ajax({
//         url: "../controller.php",
//         type: "post",
//         data: { 'action': 'get_score_data_by_class_term', term_id, class_id, session_id },
//         beforeSend: () => {
//             $(".data_overlay").html(`
//             <p class="font-weight-bold">Loading...</p>
//             `)
//             $(".thecontentbox, .by_class_filter").hide()
//             // $(".thecontentbox").hide()
//             $(".data_overlay").show()
//         },
//         success: (data) => {
//             data = JSON.parse(data)
//             let grader = format_grade(skul_settings['grading'])
//             if (data.length <= 1) {
//                 $(".data_overlay").html(`
//                 <p class="font-weight-bold">No record for the class selected</p>
//             `)
//                 return
//             }
//             $(".by_class_filter").show()
//             $(".data_overlay").hide()
//             $(".data_overlay").html(`
//             <p class="font-weight-bold">Fill the forms appropiately</p>
//         `)
//             // compute component count safely (avoid NaN if settingsData entries are missing)
//             const ca1Flag = Number(settingsData.ca1) || 0;
//             const ca2Flag = Number(settingsData.ca2) || 0;
//             const ca3Flag = Number(settingsData.ca3) || 0;
//             const praFlag = Number(settingsData.pra) || 0;
//             const exaFlag = Number(settingsData.exa) || 0;
//             const colspan_lenght = ca1Flag + ca2Flag + ca3Flag + praFlag + exaFlag;

//             const subjects = {};

//             // Group data by subject
//             data.forEach((record) => {
//                 if (!subjects[record.subject]) subjects[record.subject] = [];
//                 subjects[record.subject].push(record);
//             });

//             // Table header construction
//             let str = `
//             <table id="class_score_table" class="display nowrap" style="width:100%;">
//                 <thead>
//                     <tr>
//                         <th></th>`;

//             // Loop through subjects to create subject-specific headers
//             Object.keys(subjects).forEach((subject) => {
//                 str += `<th colspan="${colspan_lenght + 2}">${subject}</th>`;
//             });

//             str += `
//                     <th></th></tr>
//                     <tr>
//                         <th>Students</th>`;

//             // Add score components for each subject
//             Object.keys(subjects).forEach(() => {
//                 str += `
//                     <th class="score_head ${settingsData.ca1 == 0 ? 'd-none' : ''}">CA1</th>
//                     <th class="score_head ${settingsData.ca2 == 0 ? 'd-none' : ''}">CA2</th>
//                     <th class="score_head ${settingsData.ca3 == 0 ? 'd-none' : ''}">CA3</th>
//                     <th class="score_head ${settingsData.pra == 0 ? 'd-none' : ''}">Practical</th>
//                     <th class="${settingsData.exa == 0 ? 'd-none' : ''}">Exam</th>
//                     <th>Total</th>
//                     <th>Total(%)</th>`;
//             });
//             str += `
//                     <th>Approval</th></tr>
//                 </thead>
//                 <tbody>`;

//             // Construct table rows for each student
//             const students = {};
//             data.forEach((record) => {
//                 if (!students[record.student_id]) students[record.student_id] = {};
//                 students[record.student_id][record.subject] = record;
//             });

//             // Fill each student row with data for each subject
//             Object.keys(students).forEach((studentId) => {
//                 const studentSubjects = students[studentId];
//                 const studentName = studentSubjects[Object.keys(studentSubjects)[0]].student_name;

//                 str += `<tr><td><a href="students?id=${studentId}">${studentName}</a></td>`;

//                 Object.keys(subjects).forEach((subject) => {
//                     const record = studentSubjects[subject];

//                     if (record) {
//                         // console.log("record",record)
//                         const total = safeParseFloat(record.CA1) + safeParseFloat(record.CA2) + safeParseFloat(record.CA3) + safeParseFloat(record.Practical) + safeParseFloat(record.Exam);
//                         const totalMax = safeParseFloat(record.ca1Total) + safeParseFloat(record.ca2Total) + safeParseFloat(record.ca3Total) + safeParseFloat(record.praTotal) + safeParseFloat(record.exaTotal);
//                         const percentage = totalMax > 0 ? ((total / totalMax) * 100).toFixed(0) : 0

//                         str += `
//                             <td class="${settingsData.ca1 == 0 ? 'd-none' : ''}">${safeParseFloat(record.CA1)}</td>
//                             <td class="${settingsData.ca2 == 0 ? 'd-none' : ''}">${safeParseFloat(record.CA2)}</td>
//                             <td class="${settingsData.ca3 == 0 ? 'd-none' : ''}">${safeParseFloat(record.CA3)}</td>
//                             <td class="${settingsData.pra == 0 ? 'd-none' : ''}">${safeParseFloat(record.Practical)}</td>
//                             <td class="${settingsData.exa == 0 ? 'd-none' : ''}">${safeParseFloat(record.Exam)}</td>
//                             <td>${total}</td>
//                             <td>${percentage}</td>`;
//                     } else {
//                         // When a student has no record for this subject, emit the same number of <td>
//                         // cells as the header (one per component + Total + Total(%)). Using a single
//                         // colspan in the body can break DataTables; emitting individual cells keeps
//                         // the column count stable.
//                         // CA1
//                         str += `<td class="${ca1Flag == 0 ? 'd-none' : ''}">0</td>`;
//                         // CA2
//                         str += `<td class="${ca2Flag == 0 ? 'd-none' : ''}">0</td>`;
//                         // CA3
//                         str += `<td class="${ca3Flag == 0 ? 'd-none' : ''}">0</td>`;
//                         // Practical
//                         str += `<td class="${praFlag == 0 ? 'd-none' : ''}">0</td>`;
//                         // Exam
//                         str += `<td class="${exaFlag == 0 ? 'd-none' : ''}">0</td>`;
//                         // Total
//                         str += `<td>0</td>`;
//                         // Total(%)
//                         str += `<td>0</td>`;
//                     }
//                 });
// // Get the first record for this student to check status
// const firstRecord = studentSubjects[Object.keys(studentSubjects)[0]];
// str += `<td>
//     <button type="button" class="btn btn-sm btn-${firstRecord.status == 1 ? 'success' : 'warning'}" onclick="toggleApproval(${studentId}, ${term_id}, ${session_id},${class_id}, this)">
//         ${firstRecord.status == 1 ? 'Approved' : 'Approve'}
//     </button>
// </td></tr>`;
//             });

//             str += `</tbody></table>`;

//             $("#class_table_data").html(str);
//             $('#class_score_table').DataTable({
//                 scrollX: true,
//                 paging: false,
//                 ordering: false,
//                 fixedColumns: {
//                     left: 1,
//                     right: 0
//                 }
//             });
//         }
//     });
//     get_approval_btn(class_id, term_id, session_id)
// }

function toggleApproval(studentId, termId, sessionId, classId, button) {
    const currentStatus = $(button).hasClass('btn-success') ? 0 : 1;
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: {
            action: 'toggle_approval',
            studentId: studentId,
            termId: termId,
            sessionId: sessionId,
            classId: classId,
            status: currentStatus
        },
        success: function (response) {
            if (response.trim() === 'success') {
                if (currentStatus === 1) {
                    $(button).removeClass('btn-warning').addClass('btn-success').text('Approved');
                } else {
                    $(button).removeClass('btn-success').addClass('btn-warning').text('Approve');
                }
            }
        }
    });
}

function get_approval_btn(class_id, term_id, session_id) {
    // alert('kki')
    let str = '';
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: { 'action': 'get_approval', class_id, term_id, session_id, },
        success: (data) => {
            data = JSON.parse(data) //{ca1:1,ca2:0}
            console.log(data)
            // Object.entries(data[0]).forEach(([key,value]) => {
            str += settingsData.ca1 == 1 ? `<button type="button" class="btn btn-sm mr-2 select_btn approve_disaprove ${data[0].ca1 == '1' ? 'active' : ''} mt-3" data-name='ca1' onclick="approve_disaprove_comment(this)">Approve CA1</button>` : ''
            str += settingsData.ca2 == 1 ? `<button type="button" class="btn btn-sm mr-2 select_btn approve_disaprove ${data[0].ca2 == '1' ? 'active' : ''} mt-3" data-name='ca2' onclick="approve_disaprove_comment(this)">Approve CA2</button>` : ''
            str += settingsData.ca3 == 1 ? `<button type="button" class="btn btn-sm mr-2 select_btn approve_disaprove ${data[0].ca3 == '1' ? 'active' : ''} mt-3" data-name='ca3' onclick="approve_disaprove_comment(this)">Approve CA3</button>` : ''
            str += settingsData.pra == 1 ? `<button type="button" class="btn btn-sm mr-2 select_btn approve_disaprove ${data[0].practical == '1' ? 'active' : ''} mt-3" data-name='practical' onclick="approve_disaprove_comment(this)">Approve Practical</button>` : ''
            str += settingsData.exa == 1 ? `<button type="button" class="btn btn-sm select_btn approve_disaprove ${data[0].exam == '1' ? 'active' : ''} mt-3" data-name='exam' onclick="approve_disaprove_comment(this)">Approve Exam</button>` : ''
            // })
            $("#approval_btn").html(str)
        }
    })
}
// alert("")
function handleToggleSelection() {
    if ($("#by_class_btn").hasClass("active")) {
        by_class_view_content()
    } else if ($("#by_stud_btn").hasClass("active")) {
        get_score_data()
    }
}


// alert('jj')
var settingsData;
// alert('jh')
const loadSettings = () => {
    // alert('kkkk')
    let session_id = $("#select_session_field").val()
    return $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: {
            'action': 'getsettings',
            'session_id': session_id
        },
        success: (data) => {
            settingsData = JSON.parse(data);
            // settingsData = data;
            // if ($("#report_page").val() === 'report_scores') {
            //     callback('student');
            //     // alert('lsc')
            // }
            // else {
            //     alert('ccal student')
            //     callback('subject');
            // }
        }
    });
};
// alert(clickedButton)
function report_setfilter(clickedButton) {
    const btnFilter = clickedButton === "student" ? 'student' : 'subject'
    console.log("repot" + btnFilter)
    // alert('file')
    let str;
    str = `<div class="form-group align-left">
                                    <label for="" class="">Select Session</label>
                                    <select class="form-control select2" onchange="display_table()" id="select_session_field" style="width: 100%;">
                                        <?php
                                        $select = mysqli_query($conn, "SELECT id,session FROM sessions WHERE school_id='$school_id' ORDER BY session ASC");
                                        while ($row = mysqli_fetch_array($select)) {
                                        ?>
                                            <option value="<?= $row['id'] ?>"><?= $row['session'] ?></option>
                                        <?php
                                        }
                                        ?>
                                    </select>
                                </div>
    <div class="w-100 mb-3 d-flex align-items-md-center align-items-start">
                <div>
                    <p class="mb-0 mr-2 text-muted">Select Term: </p>
                </div>
                <div id="filterTerm">
                    <button class="btn-sm select_btn term active my-1 mr-2" data-name="1" id="first" onclick="toggletermfilterClass('1')">1st Term</button>
                    <button class="btn-sm select_btn term my-1 mr-2" data-name="2" id="second" onclick="toggletermfilterClass('2')">2nd Term</button>
                    <button class="btn-sm select_btn term my-1 mr-2" data-name="3" id="third" onclick="toggletermfilterClass('3')">3rd Term</button>
                </div>
            </div>`;

    $("#fil").html(str);
    display_table('student')
    // getstudents($("#select_class_field").val())

    // display_table(btnFilter);
};
function setfilter(clickedButton) {
    const btnFilter = clickedButton === "student" ? 'student' : 'subject'
    console.log("clicke" + btnFilter)
    // alert('filter')
    let str;
    str = `<div class="w-100 mb-3 d-flex align-items-md-center align-items-start">
                <div>
                    <p class="mb-0 mr-2 text-muted">Assessment Type: </p>
                </div>
                <div id="filterAss">
                <button class="btn-sm select_btn active my-1 mr-2" id="by_all" onclick="togglepostfilterClass('all','${btnFilter}')">All</button>
                ${settingsData.ca1 == 1 ? `<button class="btn-sm select_btn my-1 mr-2" id="by_ca1" onclick="togglepostfilterClass('ca1','${btnFilter}')">CA1</button>` : ''}
                ${settingsData.ca2 == 1 ? `<button class="btn-sm select_btn my-1 mr-2" id="by_ca2" onclick="togglepostfilterClass('ca2','${btnFilter}')">CA2</button>` : ''}
                ${settingsData.ca3 == 1 ? `<button class="btn-sm select_btn my-1 mr-2" id="by_ca3" onclick="togglepostfilterClass('ca3','${btnFilter}')">CA3</button>` : ''}                
                ${settingsData.pra == 1 ? `<button class="btn-sm select_btn my-1 mr-2" id="by_pra" onclick="togglepostfilterClass('pra','${btnFilter}')">Practical</button>` : ''}
                ${settingsData.exa == 1 ? `<button class="btn-sm select_btn my-1 mr-2" id="by_exam" onclick="togglepostfilterClass('exam','${btnFilter}')">Exam</button>` : ''}
                </div>
            </div>`;

    $("#filt").html(str);
    // alert('kkkkk')
    getstudents($("#select_class_field").val())

    // display_table(btnFilter);
};
function view_setfilter(clickedButton) {
    const btnFilter = clickedButton === "student" ? 'student' : 'subject'
    console.log("clicke" + btnFilter)

    let str;
    str = `<div class="w-100 mb-3 d-flex align-items-md-center align-items-start">
                <div>
                    <p class="mb-0 mr-2 text-muted">Assessment Type: </p>
                </div>
                <div id="filterAss">
                <button class="btn-sm select_btn active my-1 mr-2" id="by_all" onclick="togglepostfilterClass('all','${btnFilter}')">All</button>
                ${settingsData.ca1 == 1 ? `<button class="btn-sm select_btn my-1 mr-2" id="by_ca1" onclick="togglepostfilterClass('ca1','${btnFilter}')">CA1</button>` : ''}
                ${settingsData.ca2 == 1 ? `<button class="btn-sm select_btn my-1 mr-2" id="by_ca2" onclick="togglepostfilterClass('ca2','${btnFilter}')">CA2</button>` : ''}
                ${settingsData.ca3 == 1 ? `<button class="btn-sm select_btn my-1 mr-2" id="by_ca3" onclick="togglepostfilterClass('ca3','${btnFilter}')">CA3</button>` : ''}                
                ${settingsData.pra == 1 ? `<button class="btn-sm select_btn my-1 mr-2" id="by_pra" onclick="togglepostfilterClass('pra','${btnFilter}')">Practical</button>` : ''}
                ${settingsData.exa == 1 ? `<button class="btn-sm select_btn my-1 mr-2" id="by_exam" onclick="togglepostfilterClass('exam','${btnFilter}')">Exam</button>` : ''}
                </div>
            </div>
            <div class="w-100 mb-3 d-flex align-items-md-center align-items-start">
                <div>
                    <p class="mb-0 mr-2 text-muted">Select Term: </p>
                </div>
                <div id="filterTerm">
                    <button class="btn-sm select_btn term active my-1 mr-2" data-name="1" id="first" onclick="toggletermfilterClass('1')">1st Term</button>
                    <button class="btn-sm select_btn term my-1 mr-2" data-name="2" id="second" onclick="toggletermfilterClass('2')">2nd Term</button>
                    <button class="btn-sm select_btn term my-1 mr-2" data-name="3" id="third" onclick="toggletermfilterClass('3')">3rd Term</button>
                </div>
            </div>`;

    $("#filt").html(str);
    getstudents($("#select_class_field").val())

    // display_table(btnFilter);
};
// alert("kk")
function preview_image(event) {
    const fileInput = event.target; // The input element being interacted with
    const container = fileInput.closest('.form-group'); // Find the closest container
    const img = container.querySelector('img'); // Get the image element in the container
    const label = container.querySelector('label'); // Get the label in the container

    if (fileInput.files && fileInput.files[0]) {
        const reader = new FileReader();
        reader.onload = function () {
            img.src = reader.result; // Update the image preview
        };
        reader.readAsDataURL(fileInput.files[0]);

        // Update the label text to show the file name
        label.innerHTML = fileInput.files[0].name;
    }
}





// function view_staff_info(id, staff_type) {
//     $.ajax({
//         url: '../controller.php',
//         type: 'post',
//         data: { 'action': 'get_staff_data_by_id', id, staff_type },
//         beforeSend: function () {
//             $("#view_staff_modal").modal("show")
//             $("#view_staff_modal_body").html(
//                 `<div id="skeleton-loader" class="skeleton-loader">
//                     <div class="skeleton-line skeleton-photo"></div>
//                     <div class="skeleton-line skeleton-input"></div>
//                     <div class="skeleton-line skeleton-input"></div>
//                     <div class="skeleton-line skeleton-input"></div>
//                     <div class="skeleton-line skeleton-input"></div>
//                 </div>`)
//         },
//         success: (data) => {
//             // do this in controller
//             data = JSON.parse(data)
//             // console.log(data)
//             let add = data.address == '' ? 'Nil' : data.address
//             let city = data.city == '' ? 'Nil' : data.city
//             let state = data.state == '' ? 'Nil' : data.state
//             let country = data.country == '' ? 'Nil' : data.country
//             let photo = data.photo == '' ? 'avatar.png' : data.photo
//             let classname = data.classname == 'No Class' ? 'Not assigned' : data.classname
//             if (data.staff_type == '1' || data.staff_type == '2' || data.staff_type == '3' || data.staff_type == '4') {
//                 classname = 'Not assigned'
//             }
//             let str = `
//             <div class="container-fluid">
//                         <div class="row">
//                             <div class="col-12">
//                                 <img title="${data.lastname}" class="img-circle elevation-2 mb-4" src="../uploads/${photo}" alt="Photo" width="100" height="100">
//                                 <p class="font-weight-bold text-muted">Basic Data</p>
//                                 <div class="d-flex flex-wrap" style="border-bottom:5px solid #f4f7fa">
//                                     <div class="mb-3 mr-5">
//                                         <p class="font-weight-bold small muted-text">FullName</p>
//                                         <p class="">${data.firstname + " " + data.lastname + " " + data.middlename}</p>
//                                     </div>
//                                     <div class="mb-3 mr-5">
//                                         <p class="font-weight-bold small muted-text">Role</p>
//                                         <p class="">${data.type}</p>
//                                     </div>
//                                     <div class="mb-3 mr-5">
//                                         <p class="font-weight-bold small muted-text">Class Assigned</p>
//                                         <p class="">${classname}</p>
//                                     </div>
//                                     <div class="mb-3 mr-5">
//                                         <p class="font-weight-bold small muted-text">Gender</p>
//                                         <p class="">${!data.gender ? 'Nil' : data.gender}</p>
//                                     </div>
//                                 </div>
//                             </div>
//                             <div class="col-12 mt-3">
//                                 <p class="font-weight-bold text-muted">Contact Information</p>
//                                 <div class="d-flex flex-wrap">
//                                     <div class="mb-3 mr-5">
//                                         <p class="font-weight-bold small muted-text">Phone</p>
//                                         <p class="">${data.phone == '' ? 'Nil' : data.phone}</p>
//                                     </div>
//                                     <div class="mb-3 mr-5">
//                                         <p class="font-weight-bold small muted-text">Email</p>
//                                         <p class="">${data.email == '' ? 'Nil' : data.email}</p>
//                                     </div>
//                                     <div class="mb-3 mr-5">
//                                         <p class="font-weight-bold small muted-text">Address</p>
//                                         <p class="">${add}</p>
//                                     </div>

//                                     </div>
//                                 </div>
//                             </div>
//                         </div>
//                     </div>`
//             $("#view_staff_modal_body").html(str)
//         }
//     })
// }
function view_staff_info(id, staff_type) {
    $.ajax({
        url: '../controller.php',
        type: 'post',
        data: { 'action': 'get_staff_data_by_id', id, staff_type },
        beforeSend: function () {
            $("#view_staff_modal").modal("show")
            $("#view_staff_modal_body").html(
                `<div id="skeleton-loader" class="skeleton-loader">
                    <div class="skeleton-line skeleton-photo"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                </div>`)
        },
        success: (data) => {
            data = JSON.parse(data)
            let add = data.address == '' ? 'Nil' : data.address
            let city = data.city == '' ? 'Nil' : data.city
            let state = data.state == '' ? 'Nil' : data.state
            let country = data.country == '' ? 'Nil' : data.country
            let photo = data.photo == '' ? 'avatar.png' : data.photo
            let classname = data.classname == 'No Class' ? 'Not assigned' : data.classname
            if (data.staff_type == '1' || data.staff_type == '2' || data.staff_type == '3' || data.staff_type == '4') {
                classname = 'Not assigned'
            }
            let str = `
            <div class="container-fluid">
                <div class="row">
                    <div class="col-12">
                        <img title="${data.lastname}" class="img-circle elevation-2 mb-4" src="../uploads/${photo}" alt="Photo" width="100" height="100">
                        <p class="font-weight-bold text-muted">Basic Data</p>
                        <div class="d-flex flex-wrap" style="border-bottom:5px solid #f4f7fa">
                            <div class="mb-3 mr-5">
                                <p class="font-weight-bold small muted-text">FullName</p>
                                <p class="">${data.firstname + " " + data.lastname + " " + data.middlename}</p>
                            </div>
                            <div class="mb-3 mr-5">
                                <p class="font-weight-bold small muted-text">Role</p>
                                <p class="">${data.type}</p>
                            </div>
                            <div class="mb-3 mr-5">
                                <p class="font-weight-bold small muted-text">Class Assigned</p>
                                <p class="">${classname}</p>
                            </div>
                            <div class="mb-3 mr-5">
                                <p class="font-weight-bold small muted-text">Gender</p>
                                <p class="">${!data.gender ? 'Nil' : data.gender}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 mt-3">
                        <p class="font-weight-bold text-muted">Contact Information</p>
                        <div class="d-flex flex-wrap">
                            <div class="mb-3 mr-5">
                                <p class="font-weight-bold small muted-text">Phone</p>
                                <p class="">${data.phone == '' ? 'Nil' : data.phone}</p>
                            </div>
                            <div class="mb-3 mr-5">
                                <p class="font-weight-bold small muted-text">Email</p>
                                <p class="">${data.email == '' ? 'Nil' : data.email}</p>
                            </div>
                            <div class="mb-3 mr-5">
                                <p class="font-weight-bold small muted-text">Address</p>
                                <p class="">${add}</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-12 mt-4">
                        <div id="staff_qrcode_image"></div>
                        <button id="download_staff_qr_btn" class="btn btn-sm btn-primary mt-2" style="display:none;">Download QR</button>
                        <button id="share_staff_qr_btn" class="btn btn-sm btn-secondary mt-2" style="display:none;">Share QR</button>
                    </div>
                </div>
            </div>`
            $("#view_staff_modal_body").html(str)

            // Generate QR code for staff
            const staffQRData = {
                staff_id: data.id,
                firstname: data.firstname,
                lastname: data.lastname
            };
            if (window.QRCode) {
                const qrcode = new QRCode(document.getElementById("staff_qrcode_image"), {
                    text: JSON.stringify(staffQRData),
                    width: 200,
                    height: 200,
                    colorDark: "#000000",
                    colorLight: "#ffffff",
                    correctLevel: QRCode.CorrectLevel.L
                });
                setTimeout(() => {
                    document.getElementById("download_staff_qr_btn").style.display = "inline-block";
                    document.getElementById("share_staff_qr_btn").style.display = "inline-block";
                }, 500);
                // Download button
                document.getElementById("download_staff_qr_btn").onclick = function () {
                    const qrImage = document.querySelector("#staff_qrcode_image img");
                    if (qrImage) {
                        const link = document.createElement("a");
                        link.download = `qr_staff_${data.lastname}_${data.firstname}.png`;
                        link.href = qrImage.src;
                        link.click();
                    }
                };
                // Share button (basic, for modern browsers)
                document.getElementById("share_staff_qr_btn").onclick = async function () {
                    const qrImage = document.querySelector("#staff_qrcode_image img");
                    if (qrImage && navigator.share) {
                        try {
                            const response = await fetch(qrImage.src);
                            const blob = await response.blob();
                            const file = new File([blob], `qr_staff_${data.lastname}_${data.firstname}.png`, { type: blob.type });
                            await navigator.share({ files: [file], title: 'Staff QR Code', text: 'Scan to log staff attendance.' });
                        } catch (e) {
                            alert('Share failed.');
                        }
                    } else {
                        alert('Sharing not supported on this browser.');
                    }
                };
            }
        }
    })
}
function view_student_info(id) {
    $.ajax({
        url: '../controller.php',
        type: 'post',
        data: { 'action': 'get_student_data_by_id', id, },
        beforeSend: function () {
            $("#view_student_modal").modal("show")
            $("#view_student_modal_body").html(
                `<div id="skeleton-loader" class="skeleton-loader">
                    <div class="skeleton-line skeleton-photo"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-button"></div>
                </div>`
            )
        },
        success: (data) => {
            // do this in controller
            data = JSON.parse(data)
            let add = data.address == '' ? 'Nil' : data.address
            let photo = data.photo == '' ? 'avatar.png' : data.photo
            let str = `
            <div class="container-fluid">
                        <div class="row">
                            <div class="col-12">
                                <img title="${data.lastname}" class="img-circle elevation-2 mb-4" src="../uploads/${photo}" alt="Photo" width="100" height="100">
                                <p class="font-weight-light" style="font-weight:20px">${data.admission_no}</p>
                                <p class="font-weight-bold text-muted">Basic Data</p>
                                <div class="d-flex flex-wrap" style="border-bottom:5px solid #f4f7fa">
                                    <div class="mb-3 mr-5">
                                        <p class="font-weight-bold small muted-text">Name</p>
                                        <p class="">${data.firstname + " " + data.lastname + " " + data.middlename}</p>
                                    </div>
                                    <div class="mb-3 mr-5">
                                        <p class="font-weight-bold small muted-text">Class</p>
                                        <p class="">${data.classname}</p>
                                    </div>
                                    <div class="mb-3 mr-5">
                                        <p class="font-weight-bold small muted-text">Gender</p>
                                        <p class="">${data.gender == '' ? 'Nil' : data.gender}</p>
                                    </div>
                                    <div class="mb-3 mr-5">
                                        <p class="font-weight-bold small muted-text">Date of Birth</p>
                                        <p class="">${data.dob == '' ? 'Nil' : data.dob}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 mt-3">
                                <p class="font-weight-bold text-muted">Contact Information</p>
                                <div class="d-flex flex-wrap" style="border-bottom:5px solid #f4f7fa">
                                    <div class="mb-3 mr-5">
                                        <p class="font-weight-bold small muted-text">Phone</p>
                                        <p class="">${data.phone == '' ? 'Nil' : data.phone}</p>
                                    </div>
                                    <div class="mb-3 mr-5">
                                        <p class="font-weight-bold small muted-text">Email</p>
                                        <p class="">${data.email == '' ? 'Nil' : data.email}</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12 mt-3">
                                <p class="font-weight-bold text-muted">Parent Information</p>
                                <div class="d-flex flex-wrap">
                                    <div class="mb-3 mr-5">
                                        <p class="font-weight-bold small muted-text">Phone</p>
                                        <p class="">${data.parentphone == '' ? 'Nil' : data.parentphone}</p>
                                    </div>
                                    <div class="mb-3 mr-5">
                                        <p class="font-weight-bold small muted-text">Email</p>
                                        <p class="">${data.parentemail == '' ? 'Nil' : data.parentemail}</p>
                                    </div>
                                    <div class="mb-3 mr-5">
                                        <p class="font-weight-bold small muted-text">Address</p>
                                        <p class="">${add}</p>
                                    </div>
                                    
                                </div>
                            </div>
                        </div>
                        <a href="?id=${id}" class="font-weight-bold accent">View Full Student Profile</a>
                    </div>`
            $("#view_student_modal_body").html(str)
        }
    })
}
// alert('ll')
function edit_class_info(id) {
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: { "action": "get_class_data_for_update", id, },
        beforeSend: function () {
            $("#edit_class_modal").modal("show")
            $("#edit_class_modal_body").html(
                `<div id="skeleton-loader" class="skeleton-loader">
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-button"></div>
                </div>`)
            $("#update_class_btn").html("Processing")
            $("#update_class_btn").attr("disabled", true)
        },
        success: (data) => {
            $("#update_class_btn").html("Update Class")
            $("#update_class_btn").attr("disabled", false)
            data = (data).trim()
            $("#edit_class_modal_body").html(data)
        }
    })
}
// alert('kk')
function edit_staff_info(id, staff_type) {
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: { "action": "get_staff_data_for_update", id, staff_type },
        beforeSend: () => {
            $("#edit_staff_modal").modal("show");
            $("#edit_staff_modal_body").html(`
                <div id="skeleton-loader" class="skeleton-loader">
                    <div class="skeleton-line skeleton-photo"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-button"></div>
                </div>
            `);
        },
        success: (data) => {
            data = (data).trim();
            $("#edit_staff_modal_body").html(data);
        }
    });
}
function edit_parent_info(id, student_id = null) {
    $.ajax({
        url: "../controller.php",
        type: "POST",
        data: {
            action: "get_parent_data_for_update",
            id: id,
            student_id: student_id,
        },
        beforeSend: () => {
            $("#edit_parent_modal").modal("show");
            $("#edit_parent_modal_body").html(`
                <div id="skeleton-loader" class="skeleton-loader">
                    <div class="skeleton-line skeleton-photo"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-button"></div>
                </div>
            `);
        },
        success: (data) => {
            data = data.trim();
            $("#edit_parent_modal_body").html(data);
        },
    });
}

function edit_student_info(id) {
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: { "action": "get_student_data_for_update", id },
        beforeSend: function () {
            $("#edit_student_modal").modal("show")
        },
        success: (data) => {
            $("#edit_student_modal_body").html(data);
            // initializeParentSearch();
        }
    });
}

function delete_subject_category(id) {

    setTimeout($("#delete_subject_category_modal").modal("hide"), 200)
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: { "action": "delete_subject_category", id, },
        success: (data) => {
            data = JSON.parse(data)
            if (data.status == '1') {
                $("#subject_category_container").load('../display_subject_category.php')
                toastr.success("Deleted Successfully")
            }
        }
    })
}
function delete_staff_modal(event) {
    const id = $(event).attr("data-id")
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: { "action": "delete_staff_data", id, },
        beforeSend: function () {
            $("#delete_staff_modal_btn").html("Processing")
            $("#delete_staff_modal_btn").attr("disabled", true)
        },
        success: (data) => {
            $("#delete_staff_modal_btn").html("Delete Permanently")
            $("#delete_staff_modal_btn").attr("disabled", false)
            data = JSON.parse(data)
            if (data.status == '1') {
                $("#staff_tables").load('../display_staff_table.php')
                setTimeout($("#delete_staff_modal").modal("hide"), 200)
                toastr.success("Deleted Successfully")
            }
        }
    })
}

function assign_staff_subjects_by_classes() {
    // Find all class cards
    var assignments = [];
    $(".card").each(function () {
        var classid = $(this).find(".all-none-toggle").data("classid");
        // Get all checked subject ids for this class
        var subjectIds = [];
        $(this).find(".subject-toggle:checked").each(function () {
            var id = $(this).attr("id");
            // id format: subject_{subject_id}_{classid}
            var parts = id.split("_");
            if (parts.length >= 3) {
                subjectIds.push(parts[1]);
            }
        });
        if (subjectIds.length > 0) {
            assignments.push(classid + ": " + subjectIds.join(","));
        }
    });
    // Format: '44: 1,2,65, 45: 65'
    var result = assignments.join(", ");
    // Send 'result' to the backend via AJAX
    var staff_id = $("#staff_id").val(); // Get staff id from global or input
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: {
            action: 'assign_staff_subjects_by_classes',
            assignments: result,
            staff_id: staff_id
        },
        success: function (data) {
            // Optionally handle response
            try {
                var resp = JSON.parse(data);
                if (resp.status == '1') {
                    toastr.success('Subjects assigned successfully!');
                } else {
                    alert('Failed to assign subjects.');
                }
            } catch (e) {
                console.log('Unexpected response: ' + data);
            }
        },
        error: function (xhr, status, error) {
            console.log('Error: ' + error);
        }
    });
}

function get_subjects_and_classes(id) {
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: { action: 'get_subjects_and_classes', staff_id: id },
        beforeSend: function () {
            $("#staff_subjectsbyclasses_modal_body").html('<p>Loading...</p>');
        },
        success: function (data) {
            data = typeof data === "string" ? JSON.parse(data) : data;
            // data is array of {class_id, classname, class_subjects: [{id, name, assigned_to_staff}]}
            $("#staff_id").val(id);
            let cardsHtml = '';
            data.forEach(function (cls) {
                // Determine if all subjects are assigned to staff
                let allAssigned = cls.class_subjects.length > 0 && cls.class_subjects.every(subj => subj.assigned_to_staff);
                cardsHtml += `
                    <div class="card mb-3">
                        <div class="card-header">
                            <p class="mb-0 font-weight-bold">${cls.classname}</p>
                        </div>
                        <div class="card-body">
                            <div class="btn-group-toggle d-flex flex-wrap" style="gap: 10px;" data-toggle="buttons">
                                <label class="btn btn-sm btn-outline-primary all-none-label" data-classid="${cls.class_id}">
                                    <input type="checkbox" name="options" class="all-none-toggle" data-classid="${cls.class_id}" ${allAssigned ? 'checked' : ''}> <span class="all-none-text">${allAssigned ? 'None' : 'All'}</span>
                                </label>
                                ${cls.class_subjects.map((subj, i) => `
                                    <label class="btn btn-sm btn-outline-primary${subj.assigned_to_staff ? ' active' : ''}">
                                        <input type="checkbox" name="options" class="subject-toggle" data-classid="${cls.class_id}" id="subject_${subj.id}_${cls.class_id}" ${subj.assigned_to_staff ? 'checked' : ''}> ${subj.name}
                                    </label>
                                `).join('')}
                            </div>
                        </div>
                    </div>
                `;
            });
            $("#staff_subjectsbyclasses_modal_body").html(cardsHtml);
            $("#staff_subjectsbyclasses_modal").modal("show");

            // Add event handler for all-none toggle
            $(".all-none-toggle").off("change").on("change", function () {
                var classid = $(this).data("classid");
                var checked = $(this).prop("checked");
                // Toggle all subject checkboxes for this class
                var subjectCheckboxes = $(".subject-toggle[data-classid='" + classid + "']");
                subjectCheckboxes.each(function () {
                    $(this).prop("checked", checked);
                    if (checked) {
                        $(this).closest("label").addClass("active");
                    } else {
                        $(this).closest("label").removeClass("active");
                    }
                });
                // Change label text
                var label = $(this).closest('.all-none-label').find('.all-none-text');
                if (checked) {
                    label.text('None');
                } else {
                    label.text('All');
                }
            });
            // Sync all-none toggle if user manually checks/unchecks all subjects
            $(".subject-toggle").off("change").on("change", function () {
                var classid = $(this).data("classid");
                var allSubjects = $(".subject-toggle[data-classid='" + classid + "']");
                var allChecked = allSubjects.length === allSubjects.filter(":checked").length;
                var allNoneToggle = $(".all-none-toggle[data-classid='" + classid + "']");
                allNoneToggle.prop("checked", allChecked);
                var label = allNoneToggle.closest('.all-none-label').find('.all-none-text');
                if (allChecked) {
                    label.text('None');
                } else {
                    label.text('All');
                }
            });
        },
        error: function () {
            $("#staff_subjectsbyclasses_modal_body").html('<p>Error loading subjects and classes.</p>');
            $("#staff_subjectsbyclasses_modal").modal("show");
        }
    });
}

function get_priviledges(id) {
    $.ajax({
        url: "../controller.php",
        type: 'POST',
        data: { "action": "get_priviledges", id },
        beforeSend: () => {
            $("#staff_priviledges_modal").modal("show")
            $("#staff_priviledges_modal_content").html(
                `<div id="skeleton-loader" class="skeleton-loader">
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                </div>`)
        },
        success: (data) => {
            $("#staff_priviledges_modal_content").html(data)
        }
    })
}
function get_classes(id) {
    $.ajax({
        url: "../controller.php",
        type: 'POST',
        data: { "action": "get_classes", id },
        beforeSend: () => {
            $("#staff_priviledges_modal").modal("show")
            $("#staff_priviledges_modal_content").html(
                `<div id="skeleton-loader" class="p-2 skeleton-loader">
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                </div>`)
        },
        success: (data) => {
            $("#staff_priviledges_modal_content").html(data)
        }
    })
}


function sendEmail() {
    let recipients = $('#reciepient_email_list').val()
    let subject = $('#message_subject').val()
    // get plain text from summernote (strip HTML)
    let bodyHtml = $('#message_body').summernote('code')
    let bodyText = $('<div>').html(bodyHtml).text()

    let mailtoLink = `mailto:${recipients}?subject=${encodeURIComponent(
        subject
    )}&body=${encodeURIComponent(bodyText)}`
    window.location.href = mailtoLink
}

function send_message() {
    let recipients = $('#reciepient_email_list').val()
    let bodyHtml = $('#message_body').summernote('code')
    let bodyText = $('<div>').html(bodyHtml).text()

    let smsLink = `sms:${recipients}?body=${encodeURIComponent(bodyText)}`
    window.location.href = smsLink
}

function send_internal() {
    let recievers = $('#reciepient_email_list').val()
    // For internal messages we send the HTML content so formatting is preserved
    let message = $('#message_body').summernote('code')
    let usertype =
        $('#reciepient_type').val() == 'parent_specific' ||
            $('#reciepient_type').val() == 'all_parent'
            ? '0'
            : '1'
    $("#int_message_comm_btn").html("Processing").attr("disabled", true)
    $.ajax({
        url: '../controller.php',
        type: 'post',
        dataType: 'json',
        data: {
            action: 'send_internal',
            recievers,
            message,
            usertype
        },
        success: data => {
            console.log(data)
            if (data && data.status == '1') {
                toastr.success('Sent successfully')
                $("#int_message_comm_btn").html("Send Message").attr("disabled", false)
                try {
                    if (typeof fetchSentInternalMessages === 'function') {
                        // refresh using current search and go to first page
                        const search = (typeof $('#internal_search').val === 'function') ? $('#internal_search').val().trim() : '';
                        fetchSentInternalMessages(1, search);
                    }
                } catch (e) {
                    console.error('refresh messages failed', e)
                }
            } else {
                toastr.error(data && data.err ? data.err : 'Failed to send')
            }
        },
        error: function (xhr, status, err) {
            console.error(xhr.responseText)
            toastr.error('Failed to send (network)')
        }
    })
}

function get_staff_table(id) {
    $.ajax({
        url: "../controller.php",
        type: 'POST',
        data: { "action": "get_staff_table", id },
        beforeSend: () => {
            $("#select_staff_message_modal").modal("show")
            $("#select_staff_message_modal_content").html(
                `<div id="skeleton-loader" class="p-2 skeleton-loader">
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                    <div class="skeleton-line skeleton-input"></div>
                </div>`)
        },
        success: (data) => {
            $("#select_staff_message_modal_content").html(data)
        }
    })
}

function submit_staff_class_assign(staff_id) {
    let checkedbox = $(".modal-body .table_checkbox:checked")
    let box = []
    checkedbox.map((item) => {
        box.push(checkedbox[item].value)
    })
    let ids = box.join(",")
    let formdata = {
        "action": "submit_staff_assigned_classes",
        "ids": ids,
        "staff_id": staff_id
    }
    console.log(formdata)
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: formdata,
        beforeSend: () => {
            $("#staff_priviledges_modal").modal("hide")
        },
        success: (data) => {
            data = JSON.parse(data);
            if (data.status == '1') {
                $("#staff_tables").load('../display_staff_table.php')
                toastr.success(data.msg);
            }
        },
        error: (err) => {
            console.log(err)
        }
    })
}

function submit_priviledge_form(event) {
    event.preventDefault()
    let formData = new FormData(event.target);
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: formData,
        processData: false,
        contentType: false,
        beforeSend: () => {
            $("#staff_priviledges_modal").modal("hide")
        },
        success: (data) => {
            data = JSON.parse(data);
            if (data.status == '1') {
                toastr.success(data.msg);
            }
        },

    })
}

function filter_stud_Class() {
    $.ajax({
        url: "../controller.php",
        type: "POST",
        data: { 'action': 'filter_stud_Class', 'class_id': $(".filter_Select").val() },
        success: (data) => {
            data = data.trim()
            $("#student_table").html(data)
        }
    })
}
function get_stud_byClass_report() {
    $.ajax({
        url: "../controller.php",
        type: "POST",
        data: { 'action': 'get_stud_byClass_report', 'class_id': $(".filter_Select").val() },
        success: (data) => {
            data = data.trim()
            if (data.includes("nothinnow")) {
                // alert("yes")
                $(".data_overlay").show()
                $("#student_table_report").hide()
                // $("#student_table_report").html('')
            } else {
                $(".data_overlay").hide()
                $("#student_table_report").show()
                $("#student_table_report tbody").html(data)
            }
        }
    })
}
// alert("jj")
function att_toggle(event, type) {
    $(".select_btn.attend").removeClass("active")
    $(event).addClass("active")
    if (type == 'take') {
        get_stud_byClass_attendance()
        $("#select_date").show()
        $("#select_period").hide()
        $("#daterange_custom").hide()
        $("#save_attendance_btn").show()
        $("#att_type_btn").show()
    } else {
        // $("#daterange_custom").show()
        calculateDateRange()
        $("#select_period").show()
        // $("#select_class").hide()
        $("#select_date").hide()
        $("#save_attendance_btn").hide()
        $("#att_type_btn").hide()
    }
    // type == 'take' ? get_stud_byClass_attendance() : get_class_attendance();
}


function toggle_att_type(event) {
    $(".att_type_select").removeClass("active")
    console.log($(event).html())
    $(event).addClass("active")
    get_stud_byClass_attendance();
    console.log("no")

}



// function get_stud_byClass_attendance() {
//     if ($(".select_btn.attend.view").hasClass("active")) {
//         calculateDateRange()
//         return
//     }
//     let str = '';
//     $.ajax({
//         url: "../controller.php",
//         type: "POST",
//         data: { 'action': 'get_stud_byClass_attendance', 'class_id': $(".filter_Select").val(), att_date: $("#att_date").val() },
//         success: (data) => {
//             data = data.trim()
//             if (data.includes("nothinnow")) {
//                 // alert("yes")
//                 $(".data_overlay").show()
//                 $(".data_overlay").html(`
//                     <p class="font-weight-bold">No student in the class selected</p>
//                 `)
//                 // $("#student_table_attendance").hide()
//                 // $("#student_table_attendance").html('')
//                 $("#tbl_container").html('')
//             } else {
//                 $(".data_overlay").hide()
//                 str += `
//                     <table id="student_table_attendance" class="display nowrap" style="width:100%;">
//                         <thead>
//                             <tr>
//                                 <th colspan="2" class="">
//                                     <div style="display: flex; align-items: center;">
//                                         <div class="icheck-primary mr-3">
//                                             <input type="checkbox" id="select_all" onchange="check_uncheck_all()">
//                                             <label for="select_all" class="text-primary px-2 font-weight-bold">Mark all present</label>
//                                         </div>
//                                         <!-- <p class="mr-3 text-danger font-weight-normal action_btn" style="display:none; margin: 0; cursor: pointer;" onclick="get_all_checked_checkbox('multiple',null,'delete_student_modal')">Delete Students</p> -->
//                                         <!-- <p class="font-weight-normal action_btn" style="display:none; margin: 0; cursor: pointer;" onclick="get_all_checked_checkbox_for_report('multiple',null,'report_card_modal')">Generate Report Card</p> -->
//                                     </div>
//                                 </th>
//                             </tr>
//                         </thead>
//                         <tbody>${data}</tbody>
//                     </table>
//                 `

//                 // $("#student_table_attendance").show()
//                 $("#tbl_container").html(str)
//                 $("#save_attendance_btn").show()
//                 // if ($.fn.DataTable.isDataTable('#student_table_attendance')) {
//                 //     $('#student_table_attendance').DataTable().destroy();
//                 // }
//                 // $('#student_table_attendance').DataTable({
//                 //     scrollY: '5vh',
//                 //     scrollX: true,
//                 //     paging: false,
//                 //     ordering: false,
//                 // });



//             }
//         }
//     })
// }
// alert("ll")
// function toggle_att_type(event){
//     $(".att_type_select").removeClass("active")
//     console.log($(event).html())
//     $(event).addClass("active")
//     get_stud_byClass_attendance();
//     console.log("no")

// }

function get_stud_byClass_attendance() {
    // console.log($(".att_type_select.active").attr("data-att_type"))
    // if($(".att_type_select.active").attr("data-att_type") == '0'){
    //     return
    // }
    // return
    if ($(".select_btn.attend.view").hasClass("active")) {
        calculateDateRange()
        return
    }
    let str = '';
    $.ajax({
        url: "../controller.php",
        type: "POST",
        data: { 'action': 'get_stud_byClass_attendance', 'class_id': $(".filter_Select").val(), att_date: $("#att_date").val(), att_type: $(".att_type_select.active").attr("data-att_type") },
        success: (data) => {
            data = data.trim()
            if (data.includes("nothinnow")) {
                // alert("yes")
                $("#att_type_btn").hide()
                $(".data_overlay").show()
                $(".data_overlay").html(`
                    <p class="font-weight-bold">No student in the class selected</p>
                `)
                // $("#student_table_attendance").hide()
                // $("#student_table_attendance").html('')
                $("#tbl_container").html('')
            } else {
                $(".data_overlay").hide()

                str += `
               ${data}
                <button type="button" style="display: none;" id="save_attendance_btn" onclick="save_attendance('${$(".att_type_select.active").attr("data-att_type")}')" class="btn btn-primary mt-3">Save Attendance</button>`

                // $("#student_table_attendance").show()
                $("#tbl_container").html(str)
                $("#save_attendance_btn").show()

                $("#att_type_btn").show()
                // if ($.fn.DataTable.isDataTable('#student_table_attendance')) {
                //     $('#student_table_attendance').DataTable().destroy();
                // }
                // $('#student_table_attendance').DataTable({
                //     scrollY: '5vh',
                //     scrollX: true,
                //     paging: false,   
                //     ordering: false,
                // });



            }
        }
    })
}
function get_stud_byClass_comment() {
    $.ajax({
        url: "../controller.php",
        type: "POST",
        data: { 'action': 'get_stud_byClass_comment', 'class_id': $(".filter_Select").val(), 'session': $(".comment_Session").val(), 'term': $(".comment_term").val() },
        success: (data) => {
            data = data.trim()
            // console.log(data)
            if (data.includes("nothinnow")) {
                $(".data_overlay").show()
                $("#student_table_comment").hide()
            } else {
                $(".data_overlay").hide()
                $("#student_table_comment").show()
                $("#student_table_comment").html(data)
            }
        }
    })
}
// alert("l")

function get_comment_skills(student_id) {
    $(".student_id_for_comment").val(student_id)
    $("#comment_skill_modal").modal('show')
    set_behaviour_comment($(".comment_term").val(), $(".comment_Session").val(), $(".student_id_for_comment").val(), $(".comment_class").val(), 'post')
    // get_teacher_comment($(".comment_term").val(),$(".comment_Session").val(),$(".student_id_for_comment").val(),$(".comment_class").val(), 'post')
}

function save_comment() {
    let commentsData = [];
    $('.comment_tb_row').each(function () {
        let studentId = $(this).find('.student_id_comment').val();
        let teacherComment = $(this).find('.teacher_comment_comment').val();
        let principalComment = $(this).find('.principal_comment_comment').val();
        // alert(studentId)
        // Escape single quotes to prevent errors
        function escapeQuotes(str) {
            return typeof str === 'string' ? str.replace(/'/g, '&#39;') : str;
        }
        commentsData.push({
            student_id: studentId,
            teacher_comment: escapeQuotes(teacherComment),
            principal_comment: escapeQuotes(principalComment)
        });
    });
    console.log("comdata", commentsData)

    // Send comments data to the server using AJAX
    $.ajax({
        url: '../controller.php',  // PHP script to handle saving comments
        type: 'POST',
        data: {
            'action': 'save_comment',
            'comments': commentsData,
            'class_id': $(".filter_Select").val(),
            'session_id': $(".comment_Session").val(),
            'term_id': $(".comment_term").val()
        },
        success: function (data) {
            data = JSON.parse(data)
            if (data.status == 1) {
                toastr.success("Comment saved")
            }
        },
        error: function () {
            alert('Error saving comments.' + error);
        }
    });
}

// alert("kk")
function approve_disaprove_comment(event) {
    $(event).toggleClass("active")
    let status;
    if ($(event).hasClass("active")) {
        console.log("yes")
        status = 1
        // alert($(event).attr("data-name"))
        if ($(event).attr("data-name") == 'ca1') {
            $(event).html("CA1 Approved")
        }
        if ($(event).attr("data-name") == 'ca2') {
            $(event).html("CA2 Approved")
        }
        if ($(event).attr("data-name") == 'ca3') {
            $(event).html("CA3 Approved")
        }
        if ($(event).attr("data-name") == 'practical') {
            $(event).html("Practical Approved")
        }
        if ($(event).attr("data-name") == 'exam') {
            $(event).html("Exam Approved")
        }

    } else {
        if ($(event).attr("data-name") == 'ca1') {
            $(event).html("Approve CA1")
        }
        if ($(event).attr("data-name") == 'ca2') {
            $(event).html("Approve CA2")
        }
        if ($(event).attr("data-name") == 'ca3') {
            $(event).html("Approve CA3")
        }
        if ($(event).attr("data-name") == 'practical') {
            $(event).html("Approve Practical")
        }
        if ($(event).attr("data-name") == 'exam') {
            $(event).html("Approve Exam")
        }
        status = 0
    }
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: {
            'action': 'setclassapproval',
            'term_id': $(".select_btn.termclass.active").attr("data-name"),
            'session_id': $("#select_session_field").val(),
            'class_id': $("#select_class_field").val(),
            'score_approved': $(event).attr("data-name") + '/' + status
        },
        success: (data) => {
            data = JSON.parse(data)
            if (data.status == '1') {
                toastr.success('Updated assessment approval')
            } else {
                toastr.error("Unable to approve assessment")
            }
        }
    })
}

function delete_student_modal(event) {
    event.preventDefault();
    let formdata = new FormData(event.target);
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: formdata,
        processData: false,
        contentType: false,
        success: (data) => {
            data = JSON.parse(data);
            if (data.status == '1') {
                toastr.success(data.msg);
                filter_stud_Class()
                // $("#student_table").load('display_student_table.php', function () {
                setTimeout(function () {
                    $("#delete_student_modal").modal("hide");
                }, 200);

            } else {
                toastr.error(data.err || "An error occurred");
            }
        }
    });
}

function delete_class_modal(event) {
    // console.log($("#class_page").val() == 'display_g_class' ? '?is_g_table=1':null)
    const id = $(event).attr("data-id")
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: { "action": "delete_class_data", id, },
        beforeSend: function () {
            $("#delete_class_modal").modal("show")
        },

        success: (data) => {
            data = JSON.parse(data)
            if (data.status == '1') {
                $("#class_table").load(`../display_class_table.php${$("#class_page").val() == 'display_g_class' ? '?is_g_table=1' : ''}`)
                setTimeout($("#delete_class_modal").modal("hide"), 200)
                toastr.success("Updated Successfully")
            }
        }
    })
}
function get_subject_cat_info_to_delete(id) {
    $("#delete_subject_category_modal").modal("show")
    $("#delete_staff_modal_btn").attr("data-id", id)
}
function get_staff_info_to_delete(id) {
    $("#delete_staff_modal").modal("show")
    $("#delete_staff_modal_btn").attr("data-id", id)
}
function get_student_info_to_delete(id) {
    $("#delete_student_modal").modal("show")
    $(".bulk_transfer_ids").val(id)
}
function get_class_info_to_delete(id) {
    $("#delete_class_modal").modal("show")
    $("#delete_class_modal_btn").attr("data-id", id)
}
// alert('lk')
const init = () => {
    if ($("#scores_page").val() === 'post_scores') {
        // getsubjects($("#select_class_field").val(), 'callback')
        console.log('subjects')
        console.log($("#select_class_field").val())
        // getstudents()   
        loadSettings(setfilter);
        loadApproval()
    }
    if ($("#scores_page").val() === 'view_scores') {
        // getsubjects($("#select_class_field").val(), 'callback')
        loadSettings();
        // get_score_data()
    }
    if ($("#report_page").val() === 'report_scores') {
        loadSettings().done(() => {

            get_score_data()
        });
        // alert('re')
        // getsubjects($(".class_value.active").val(), 'callback')
        // loadSettings(report_setfilter);
    }
    if ($("#student_page").val() === 'display_students') {
        filter_stud_Class()
        // $("#student_table").load('display_student_table.php')
    }
    if ($("#report_student_page").val() === 'report_card') {
        get_stud_byClass_report()
        // $("#student_table").load('display_student_table.php')
    }
    if ($("#attendance_student_page").val() === 'attendance') {
        get_stud_byClass_attendance()
        // $("#student_table").load('display_student_table.php')
    }
    if ($("#comment_student_page").val() === 'comment') {
        get_stud_byClass_comment()
        // $("#student_table").load('display_student_table.php')
    }
    if ($("#staff_page").val() === 'display_staff') {
        $("#staff_tables").load('../display_staff_table.php')
    }
    if ($("#class_page").val() === 'display_class') {
        $("#class_table").load('../display_class_table.php')
    }
    if ($("#class_page").val() === 'display_g_class') {
        $("#class_table").load('../display_class_table.php?is_g_table=1')
    }

    if ($("#settings_page").val() === 'view_Settings') {
        $("#school_info_placeholder_form").load('../display_school_info_form.php')
        $("#school_setting_placeholder_form").load('../display_school_setting_form.php')
    }
    if ($("#subject_page").val() === 'view_Subjects') {
        $("#subject_category_container").load('../display_subject_category.php')
    }
    if ($("#profile_page").val() === 'display_profile') {
        $("#profile_placeholder").load("../display_profile.php")
    }
    if ($("#profile_page").val() === 'display_parent_profile') {
        $("#profile_placeholder").load("../display_parent_profile.php")
    }
    if ($("#class_page").val() === 'display_class') {
        load_subjects_by_cat('addclass', 'display_all_subject', 'All')
    }
};

$(document).ready(() => {
    init();
});
function toggletermbyclass(element) {
    // alert("llsd")
    // let session = $("#select_session_field").val()
    // let class = $("#select_class_field").val()
    $("#filterTerm_class button").removeClass('active');
    // if (element === '1') {
    $(element).addClass('active');
    // } else if (element === '2') {
    //     $("#second").addClass('active');
    // } else if (element === '3') {
    //     $("#third").addClass('active');
    // } else if (element === 'summary') {
    //     $("#summary").addClass('active');
    // }            
    // alert(element)
    // if ($("#scores_page").val() === 'view_scores') {
    //     if ($("#by_class_btn").hasClass("active")) {
    by_class_view_content()
    // alert("class")
    //     } else if ($("#by_stud_btn").hasClass("active")) {
    //         // alert("stude")
    //         check_result_toggle()
    //     }
    // }
    // if ($("#report_page").val() === 'report_scores') {
    //     check_result_toggle()
    // }
    // get_teacher_comment($(".term.select_btn.active").attr("data-name"), $("#select_session_field").val(), $("#select_student_field").val(), $("#select_class_field").val(), 'view')
    // set_behaviour_comment($(".term.select_btn.active").attr("data-name"), $("#select_session_field").val(), $("#select_student_field").val(), $("#select_class_field").val(), 'view')

    // format_student_table(student_score_data, element, $("#select_session_field").val(), $("#select_class_field").val())
    // if ($("#scores_page").val() === 'post_scores') {
    //     $("#by_subj_btn").hasClass('active') === true ? display_table('subject') : display_table('student');
    // }
}
function toggletermfilterClass(element) {
    // alert("pos")
    // let session = $("#select_session_field").val()
    // let class = $("#select_class_field").val()
    $("#filterTerm button").removeClass('active');
    // console.log($(element).html())
    $(element).addClass('active');
    // console.log("some",$(element).attr('data-name'))
    // if (element === '1') {
    //     $("#first").addClass('active');
    // } else if (element === '2') {
    //     $("#second").addClass('active');
    // } else if (element === '3') {
    //     $("#third").addClass('active');
    // } else if (element === 'summary') {
    //     $("#summary").addClass('active');
    // }
    // alert(element)
    // if ($("#scores_page").val() === 'view_scores') {
    //     if ($("#by_class_btn").hasClass("active")) {
    //         by_class_view_content()
    //         // alert("class")
    //     } else if ($("#by_stud_btn").hasClass("active")) {
    //         // alert("stude") 
    check_result_toggle()
    if ($(element).attr('data-name') != 'summary') {
        get_billing_data();
    }
    //     }
    // }
    if ($("#report_page").val() === 'report_scores') {
        check_result_toggle()
    }
    // get_teacher_comment($(".term.select_btn.active").attr("data-name"), $("#select_session_field").val(), $("#select_student_field").val(), $("#select_class_field").val(), 'view')
    // set_behaviour_comment($(".term.select_btn.active").attr("data-name"), $("#select_session_field").val(), $("#select_student_field").val(), $("#select_class_field").val(), 'view')

    // format_student_table(student_score_data, element, $("#select_session_field").val(), $("#select_class_field").val())
    if ($("#scores_page").val() === 'post_scores') {
        $("#by_subj_btn").hasClass('active') === true ? display_table('subject') : display_table('student');
    }
}
// alert("lll")

function togglepostfilterClass(element, clickedbtn) {
    // alert(page)
    $("#by_all, #by_ca1, #by_ca2, #by_ca3, #by_pra, #by_exam").removeClass('active');
    if (element === 'all') {
        $("#by_all").addClass('active');
    } else if (element === 'ca1') {
        $("#by_ca1").addClass('active');
    } else if (element === 'ca2') {
        $("#by_ca2").addClass('active');
    } else if (element === 'ca3') {
        $("#by_ca3").addClass('active');
    } else if (element === 'pra') {
        $("#by_pra").addClass('active');
    } else if (element === 'exam') {
        $("#by_exam").addClass('active');
    }
    display_table(clickedbtn);
}

// ($("#by_stud_btn").hasClass('active') && 
// $(document).ready(function () {
//     if ($("#by_stud_btn").hasClass('active')) {
//         const classname = $("#select_class_field").html()
//         const subjectname = $("#select_student_field").html()
//         alert(subjectname)

//     }
// })

var subjects = [];
// function getsubjects() {
//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: { 'action': 'getsubjectsbyclassid' },
//         success: (data) => {
//             subjects = JSON.parse(data)
//         }
//     })
// }

function getsubjects(classid, callback) {
    return new Promise((resolve, reject) => {
        $.ajax({
            url: '../controller.php',
            type: 'POST',
            data: { 'action': 'getsubjectsbyclassid', 'class_id': classid },
            success: (data) => {
                let str;
                if (data == 0) {
                    $("#select_subject_warning").show()
                    $("#select_subject_field").empty()
                    return reject()
                }
                subjects = JSON.parse(data)
                if (callback == 'callback') {
                    if ($("#by_subj_btn").hasClass('active')) {
                        $("#select_subject_warning").hide()
                        subjects.map((item) => {
                            str = str + `<option value="${item.id}">${item.subject}</option>`
                        })
                        $("#select_subject_field").html(str)
                    }
                }
                resolve()
            }
        })
    })
}
// alert('ll')
// function getStudentSubject(classValue) {
//     // alert($("by_subj_btn").html())
//     if ($("#by_subj_btn").hasClass('active')) {
//         getsubjects(classValue, 'callback')
//         console.log(subjects)
//     } else {
//         getstudents(classValue)
//     }
// }
var students = []
function getstudents(classValue) {
    // alert('studen')
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: {
            classValue,
            'action': 'getstudents'
        },
        success: (data) => {

            let str;
            let parsedData = JSON.parse(data);
            students = parsedData
            if ($("#by_subj_btn").hasClass('active')) {
                students = parsedData;
                display_table('subject');
            }
            else if ($("#by_stud_btn").hasClass('active')) {
                // if (parsedData.length == 0) $("#select_student_field").empty()
                // parsedData.map((item) => {
                //     str = str + `<option value="${item.id}">${item.name}</option>`
                // })
                // $("#select_student_field").html(str)
                display_table('student')
            }
        }
        // success: (data) => {
        //     data = JSON.parse(data)
        //     var str;
        //     data.map((item) => {
        //         str = str + `<option value="${item.id}">${item.name}</option>`
        //     })
        //     $("#select_student_field").html(str)
        //     display_table('student')
        // }
    })
}


// function getstudents(classValue) {
//     // alert('kkk')
//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: {
//             classValue,
//             'action': 'getstudents'
//         },
//         success: (data) => {

//             let str;
//             let parsedData = JSON.parse(data);
//             students = parsedData
//             if ($("#by_subj_btn").hasClass('active')) {
//                 students = parsedData;
//                 // students = parsedData.map(student => student.name.trim());
//                 // alert('hhh')
//                 display_table('subject');
//             }
//             else if ($("#by_stud_btn").hasClass('active')) {
//                 if (parsedData.length == 0) $("#select_student_field").empty()
//                 parsedData.map((item) => {
//                     str = str + `<option value="${item.id}">${item.name}</option>`
//                 })
//                 $("#select_student_field").html(str)
//                 display_table('student')
//             }
//         }
//         // success: (data) => {
//         //     data = JSON.parse(data)
//         //     var str;
//         //     data.map((item) => {
//         //         str = str + `<option value="${item.id}">${item.name}</option>`
//         //     })
//         //     $("#select_student_field").html(str)
//         //     display_table('student')
//         // }
//     })
// }
// alert('lklwlk')
var filtertypesaved = 'subject';
// view_summary_table_data('subject')
function view_summary_table_data(filtertype) {
    // const termValue = '1';
    const termValue = $(".select_btn.term.active").attr("data-name");
    //  termValue ='1'
    const classValue = $("#select_class_field").val();
    const studentValue = $("#select_student_field").val();
    const subjectValue = $("#select_subject_field").val();
    const sessionValue = $("#select_session_field").val();
    let arrayValues = '';
    let postdata = {};

    if (filtertype === 'student') {
        arrayValues = subjects;
        postdata = {
            action: 'get_scores',
            termValue,
            classValue,
            studentValue,
            sessionValue
        };
    } else {
        arrayValues = students;
        postdata = {
            action: 'get_scores',
            termValue,
            classValue,
            subjectValue,
            sessionValue
        };
    }

    console.log("arrayValues", arrayValues);
    console.log("postdata", postdata);
    // alert("viewOrPostPage")
    let tableHtml = '';

    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: postdata,
        success: (data) => {
            data = data.trim();
            let scores = JSON.parse(data);
            console.log('scores')
            console.log("scores", scores);

            tableHtml = `
                    <thead>
                        <tr>
                            <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
                            ${settingsData.ca1 == 1 ? `<th>CA11</th>` : ''}
                            ${settingsData.ca1 == 1 ? `<th>CA1 Total</th>` : ''}
                            ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
                            ${settingsData.ca2 == 1 ? `<th>CA2 Total</th>` : ''}
                            ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
                            ${settingsData.ca3 == 1 ? `<th>CA3 Total</th>` : ''}
                            ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
                            ${settingsData.pra == 1 ? `<th>Practical Total</th>` : ''}
                            ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
                            ${settingsData.exa == 1 ? `<th>Exam Total</th>` : ''}
                        </tr>
                    </thead>
                    <tbody id="tbody">
                    ${arrayValues.map((arrayValue) => {
                let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
                let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
                console.log("Matching score for:", nameToMatch, score);

                return `<tr>
                            <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
                            ${settingsData.ca1 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca1 || ''}"></td>` : `<td>${score.ca1 || ''}</td>`}
                            ${settingsData.ca1 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca1Total || ''}"></td>` : `<td>${score.ca1Total || ''}</td>`}
                            ${settingsData.ca2 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca2 || ''}"></td>` : `<td>${score.ca2 || ''}</td>`}
                            ${settingsData.ca2 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca2Total || ''}"></td>` : `<td>${score.ca2Total || ''}</td>`}
                            ${settingsData.ca3 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca3 || ''}"></td>` : `<td>${score.ca3 || ''}</td>`}
                            ${settingsData.ca3 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca3Total || ''}"></td>` : `<td>${score.ca3Total || ''}</td>`}
                            ${settingsData.pra == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.pra || ''}"></td>` : `<td>${score.pra || ''}</td>`}
                            ${settingsData.pra == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.praTotal || ''}"></td>` : `<td>${score.praTotal || ''}</td>`}
                            ${settingsData.exa == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.exa || ''}"></td>` : `<td>${score.exa || ''}</td>`}
                            ${settingsData.exa == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.exaTotal || ''}"></td>` : `<td>${score.exaTotal || ''}</td>`}
                        </tr>`;
            }).join('')}
                    </tbody>`;
            // } 


            // Destroy existing DataTable instance
            if ($.fn.DataTable.isDataTable('#view_summary_table')) {
                $('#view_summary_table').DataTable().destroy();
            }
            $('#view_summary_table').html(tableHtml);

            // Reinitialize DataTable
            $('#view_summary_table').DataTable({
                scrollX: true,
                paging: false,
                ordering: false,
                fixedColumns: {
                    left: 1,
                    right: 0
                }
            });
        }
    });
}
// alert('lk')
// function view_table_data(filtertype, viewOrPostPage) {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     // alert(classValue)
//     // return
//     setTimeout(get_teacher_comment(termValue, sessionValue, studentValue, classValue, 'view'), 200);
//     let arrayValues = '';
//     let postdata = {};

//     if (filtertype === 'student') {
//         arrayValues = subjects;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             studentValue,
//             sessionValue
//         };
//         $("#view_table_title").html(`${$("#select_session_field option:selected").html() + ' ' + $(".select_btn.term.active").html() + ' scores for ' + $("#select_student_field option:selected").html() + ' in ' + $("#select_class_field option:Selected").html()}`)
//         $("#view_teacher_comment_container").show()
//     } else {
//         arrayValues = students;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             subjectValue,
//             sessionValue
//         };
//         $("#view_table_title").html(`${$("#select_session_field option:selected").html() + ' ' + $(".select_btn.term.active").html() + ' ' + $("#select_subject_field option:Selected").html() + ' scores for students in ' + $("#select_class_field option:selected").html()}`)
//         $("#view_teacher_comment_container").hide()
//     }

//     console.log("arrayValues", arrayValues);
//     console.log("postdata", postdata);
//     // alert("viewOrPostPage")
//     let tableHtml = '';

//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: postdata,
//         success: (data) => {
//             data = data.trim();
//             let scores = JSON.parse(data);
//             console.log("scores", scores);

//             if ($("#by_all").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             ${settingsData.ca1 == 1 ? `<th>CA1</th>` : ''}
//                             ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
//                             ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
//                             ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
//                             ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
//                             <th>Total</th>
//                             <th>Total(%)</th>
//                             <th>Grade</th>
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);

//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${settingsData.ca1 == 1 ? `<td class="scoreData">${score.ca1 || ''}</td>` : ''}
//                             ${settingsData.ca2 == 1 ? `<td class="scoreData">${score.ca2 || ''}</td>` : ''}
//                             ${settingsData.ca3 == 1 ? `<td class="scoreData">${score.ca3 || ''}</td>` : ''}
//                             ${settingsData.pra == 1 ? `<td class="scoreData">${score.pra || ''}</td>` : ''}
//                             ${settingsData.exa == 1 ? `<td class="scoreData">${score.exa || ''}</td>` : ''}
//                             <td class="font-xs-14 totalData"></td>
//                             <td class="font-xs-14 totalpercentage"></td>
//                             <td class="font-xs-14 grade"></td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_ca1").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>CA1</th>
//                             <th>CA1 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca1 || ''}"></td>` : `<td>${score.ca1 || ''}</td>`}
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca1Total || ''}"></td>` : `<td>${score.ca1Total || ''}</td>`}
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_ca2").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>CA2</th>
//                             <th>CA2 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca2 || ''}"></td>` : `<td>${score.ca2 || ''}</td>`}
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca2Total || ''}"></td>` : `<td>${score.ca2Total || ''}</td>`}
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_ca3").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>CA3</th>
//                             <th>CA3 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca3 || ''}"></td>` : `<td>${score.ca3 || ''}</td>`}
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca3Total || ''}"></td>` : `<td>${score.ca3Total || ''}</td>`}
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_pra").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>Practical</th>
//                             <th>Practical Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.pra || ''}"></td>` : `<td>${score.pra || ''}</td>`}
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.praTotal || ''}"></td>` : `<td>${score.praTotal || ''}</td>`}
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_exam").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             <th>Exam</th>
//                             <th>Exam Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.exa || ''}"></td>` : `<td>${score.exa || ''}</td>`}
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.exaTotal || ''}"></td>` : `<td>${score.exaTotal || ''}</td>`}
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }

//             // Destroy existing DataTable instance
//             if ($.fn.DataTable.isDataTable('#view_score_table_by_student')) {
//                 $('#view_score_table_by_student').DataTable().destroy();
//             }
//             $('#view_score_table_by_student').html(tableHtml);

//             // Function to calculate and update total scores
//             function calculateTotals() {
//                 $('#tbody tr').each(function () {
//                     let total = 0;
//                     $(this).find('.scoreData').each(function () {
//                         let score = parseFloat($(this).text()) || 0;
//                         total += score;
//                     });
//                     $(this).find('.totalData').text(total);
//                 });
//             }

//             // Reinitialize DataTable
//             $('#view_score_table_by_student').DataTable({
//                 scrollX: true,
//                 paging: false,
//                 ordering: false,
//                 fixedColumns: {
//                     left: 1,
//                     right: 0
//                 }
//             });

//             // Calculate and update totals after DataTable initialization
//             calculateTotals();
//         }
//     });
// }
// alert('lllll')
// use this if php handles the calculations
// function view_table_data(filtertype, viewOrPostPage) {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     setTimeout(get_teacher_comment(termValue, sessionValue, studentValue, classValue, 'view'), 200);
//     let arrayValues = '';
//     let postdata = {};

//     if (filtertype === 'student') {
//         arrayValues = subjects;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             studentValue,
//             sessionValue
//         };
//         $("#view_table_title").html(`${$("#select_session_field option:selected").html() + ' ' + $(".select_btn.term.active").html() + ' scores for ' + $("#select_student_field option:selected").html() + ' in ' + $("#select_class_field option:Selected").html()}`)
//         $("#view_teacher_comment_container").show()
//     } else {
//         arrayValues = students;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             subjectValue,
//             sessionValue
//         };
//         $("#view_table_title").html(`${$("#select_session_field option:selected").html() + ' ' + $(".select_btn.term.active").html() + ' ' + $("#select_subject_field option:Selected").html() + ' scores for students in ' + $("#select_class_field option:selected").html()}`)
//         $("#view_teacher_comment_container").hide()
//     }

//     console.log("arrayValues", arrayValues);
//     console.log("postdata", postdata);

//     let tableHtml = '';

//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: postdata,
//         success: (data) => {
//             data = data.trim();
//             let scores = JSON.parse(data);
//             console.log("scores", scores);

//             if ($("#by_all").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             ${settingsData.ca1 == 1 ? `<th>CA1</th>` : ''}
//                             ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
//                             ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
//                             ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
//                             ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
//                             <th>Total</th>
//                             <th>Total(%)</th>
//                             <th>Grade</th>
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);

//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${settingsData.ca1 == 1 ? `<td class="scoreData">${score.ca1 || ''}</td>` : ''}
//                             ${settingsData.ca2 == 1 ? `<td class="scoreData">${score.ca2 || ''}</td>` : ''}
//                             ${settingsData.ca3 == 1 ? `<td class="scoreData">${score.ca3 || ''}</td>` : ''}
//                             ${settingsData.pra == 1 ? `<td class="scoreData">${score.pra || ''}</td>` : ''}
//                             ${settingsData.exa == 1 ? `<td class="scoreData">${score.exa || ''}</td>` : ''}
//                             <td class="font-xs-14 totalData">${score.totalScore || ''}</td>
//  <td class="font-xs-14 totalpercentage">${score.percentage !== undefined ? score.percentage.toFixed(2) : ''}</td>                            <td class="font-xs-14 grade">${score.grade || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_ca1").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>CA1</th>
//                             <th>CA1 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             <td class="font-xs-14 ca1Data">${score.ca1 || ''}</td>
//                             <td class="font-xs-14 ca1Total">${score.ca1Total || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_ca2").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>CA2</th>
//                             <th>CA2 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             <td class="font-xs-14 ca2Data">${score.ca2 || ''}</td>
//                             <td class="font-xs-14 ca2Total">${score.ca2Total || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_ca3").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>CA3</th>
//                             <th>CA3 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             <td class="font-xs-14 ca3Data">${score.ca3 || ''}</td>
//                             <td class="font-xs-14 ca3Total">${score.ca3Total || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_pract").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>Practical</th>
//                             <th>Practical Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             <td class="font-xs-14 praData">${score.pra || ''}</td>
//                             <td class="font-xs-14 praTotal">${score.praTotal || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_exam").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>Exam</th>
//                             <th>Exam Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             <td class="font-xs-14 exaData">${score.exa || ''}</td>
//                             <td class="font-xs-14 exaTotal">${score.exaTotal || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }

//             if ($.fn.DataTable.isDataTable("#view_score_table_by_student")) {
//                 $('#view_score_table_by_student').DataTable().clear().destroy();
//             }

//             $("#view_score_table_by_student").html(tableHtml);
//             $('#view_score_table_by_student').DataTable({
//                 paging: false,
//                 fixedHeader: true
//             });
//         },
//         error: (error) => {
//             console.error("Error fetching data: ", error);
//         }
//     });
// }
// alert('lllkkkklll')
// async function view_table_data(filtertype, viewOrPostPage) {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     try {
//         await getsubjects(classValue, null)
//     }
//     catch (error) {
//         return
//     }
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();


//     let arrayValues = '';
//     let postdata = {};

//     if (filtertype === 'student') {
//         arrayValues = subjects;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             studentValue,
//             sessionValue
//         };
//         setTimeout(get_teacher_comment(termValue, sessionValue, studentValue, classValue, 'view'), 200);
//         setTimeout(set_behaviour_comment(termValue, sessionValue, studentValue, classValue, 'view'), 200);
//         $("#view_table_title").html(`${$("#select_session_field option:selected").html()} ${$(".select_btn.term.active").html()} scores for ${$("#select_student_field option:selected").html()} in ${$("#select_class_field option:selected").html()}`);
//         $("#view_teacher_comment_container").show();
//         $("#view_principal_comment_container").show();
//         $("#view_student_report_card_container").show();
//         // $("#view_teacher_comment_gb_container").show();
//         $("#view_student_general_behaviour").show();
//     } else {
//         arrayValues = students;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             subjectValue,
//             sessionValue
//         };
//         $("#view_table_title").html(`${$("#select_session_field option:selected").html()} ${$(".select_btn.term.active").html()} ${$("#select_subject_field option:selected").html()} scores for students in ${$("#select_class_field option:selected").html()}`);
//         $("#view_teacher_comment_container").hide();
//         $("#view_principal_comment_container").hide();
//         $("#view_teacher_comment_gb_container").hide();
//         $("#view_student_report_card_container").hide();
//         $("#view_student_general_behaviour").hide();
//     }

//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: postdata,
//         success: (data) => {
//             data = data.trim();
//             let response = JSON.parse(data);
//             let scores = response.scores;
//             console.log('scores', scores)
//             console.log('arravalues', arrayValues)
//             let grading = response.grading;

//             // Sort the grading system by values in descending order
//             grading = Object.fromEntries(Object.entries(grading).sort(([, a], [, b]) => b - a));

//             function calculateGrade(totalPercentage) {
//                 for (let grade in grading) {
//                     if (totalPercentage >= grading[grade]) {
//                         return grade;
//                     }
//                 }
//                 return 'F'; // Default to 'F' if no grade matches
//             }

//             function safeParseFloat(value) {
//                 return isNaN(parseFloat(value)) ? 0 : parseFloat(value);
//             }

//             let tableHtml = '';

//             if ($("#by_all").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             ${settingsData.ca1 == 1 ? `<th>CA1</th>` : ''}
//                             ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
//                             ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
//                             ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
//                             ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
//                             <th>Total</th>
//                             <th>Total (%)</th>
//                             <th>Grade</th>
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     let total = (safeParseFloat(score.ca1) + safeParseFloat(score.ca2) + safeParseFloat(score.ca3) + safeParseFloat(score.pra) + safeParseFloat(score.exam)).toFixed(2);
//                     let totalPercentage = 0;
//                     if (safeParseFloat(score.ca1Total) + safeParseFloat(score.ca2Total) + safeParseFloat(score.ca3Total) + safeParseFloat(score.praTotal) + safeParseFloat(score.examTotal) !== 0) {
//                         totalPercentage = ((total / (safeParseFloat(score.ca1Total) + safeParseFloat(score.ca2Total) + safeParseFloat(score.ca3Total) + safeParseFloat(score.praTotal) + safeParseFloat(score.examTotal))) * 100).toFixed(2);
//                     } else {
//                         totalPercentage = 0
//                     }
//                     // alert('kkk')
//                     let grade = calculateGrade(totalPercentage);

//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${settingsData.ca1 == 1 ? `<td class="scoreData">${score.ca1 || ''}</td>` : ''}
//                             ${settingsData.ca2 == 1 ? `<td class="scoreData">${score.ca2 || ''}</td>` : ''}
//                             ${settingsData.ca3 == 1 ? `<td class="scoreData">${score.ca3 || ''}</td>` : ''}
//                             ${settingsData.pra == 1 ? `<td class="scoreData">${score.pra || ''}</td>` : ''}
//                             ${settingsData.exa == 1 ? `<td class="scoreData">${score.exam || ''}</td>` : ''}
//                             <td class="font-xs-16 totalData">${total}</td>
//                             <td class="font-xs-16 totalpercentage">${totalPercentage}</td>
//                             <td class="font-xs-16 grade">${grade}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_ca1").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             <th>CA1</th>
//                             <th>CA1 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};

//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             <td class="scoreData">${score.ca1 || ''}</td>
//                             <td class="font-xs-16 totalData">${score.ca1Total || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_ca2").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             <th>CA2</th>
//                             <th>CA2 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};

//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             <td class="scoreData">${score.ca2 || ''}</td>
//                             <td class="font-xs-16 totalData">${score.ca2Total || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_ca3").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             <th>CA3</th>
//                             <th>CA3 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};

//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             <td class="scoreData">${score.ca3 || ''}</td>
//                             <td class="font-xs-16 totalData">${score.ca3Total || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_pra").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             <th>Practical</th>
//                             <th>Practical Total</th>
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};

//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             <td class="scoreData">${score.pra || ''}</td>
//                             <td class="font-xs-16 totalData">${score.praTotal || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_exam").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             <th>Exam</th>
//                             <th>Exam Total</th>
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};

//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             <td class="scoreData">${score.exam || ''}</td>
//                             <td class="font-xs-16 totalData">${score.examTotal || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }

//             if ($.fn.DataTable.isDataTable('#view_score_table_by_student')) {
//                 $('#view_score_table_by_student').DataTable().destroy();
//             }
//             $('#view_score_table_by_student').html(tableHtml);



//             // Reinitialize DataTable
//             $('#view_score_table_by_student').DataTable({
//                 scrollX: true,
//                 paging: false,
//                 ordering: false,
//                 fixedColumns: {
//                     left: 1,
//                     right: 0
//                 }
//             });
//         }
//     });
// }

// async function view_table_data_with_position(filtertype, viewOrPostPage) {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     try {
//         await getsubjects(classValue, null)
//     }
//     catch (error) {
//         return
//     }
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();


//     let arrayValues = '';
//     let postdata = {};

//     if (filtertype === 'student') {
//         arrayValues = subjects;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             studentValue,
//             sessionValue
//         };
//         setTimeout(get_teacher_comment(termValue, sessionValue, studentValue, classValue, 'view'), 200);
//         setTimeout(set_behaviour_comment(termValue, sessionValue, studentValue, classValue, 'view'), 200);
//         $("#view_table_title").html(`${$("#select_session_field option:selected").html()} ${$(".select_btn.term.active").html()} scores for ${$("#select_student_field option:selected").html()} in ${$("#select_class_field option:selected").html()}`);
//         $("#view_teacher_comment_container").show();
//         // $("#view_teacher_comment_gb_container").show();
//         $("#view_student_general_behaviour").show();
//     } else {
//         arrayValues = students;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             subjectValue,
//             sessionValue
//         };
//         $("#view_table_title").html(`${$("#select_session_field option:selected").html()} ${$(".select_btn.term.active").html()} ${$("#select_subject_field option:selected").html()} scores for students in ${$("#select_class_field option:selected").html()}`);
//         $("#view_teacher_comment_container").hide();
//         $("#view_teacher_comment_gb_container").hide();
//         $("#view_student_general_behaviour").hide();
//     }

//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: postdata,
//         success: (data) => {
//             data = data.trim();
//             let response = JSON.parse(data);
//             let scores = response.scores;
//             console.log('scores', scores);
//             let grading = response.grading;

//             // Sort the grading system by values in descending order
//             grading = Object.fromEntries(Object.entries(grading).sort(([, a], [, b]) => b - a));

//             function calculateGrade(totalPercentage) {
//                 for (let grade in grading) {
//                     if (totalPercentage >= grading[grade]) {
//                         return grade;
//                     }
//                 }
//                 return 'F'; // Default to 'F' if no grade matches
//             }

//             function safeParseFloat(value) {
//                 return isNaN(parseFloat(value)) ? 0 : parseFloat(value);
//             }

//             let tableData = arrayValues.map((arrayValue) => {
//                 let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                 let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                 let total = (safeParseFloat(score.ca1) + safeParseFloat(score.ca2) + safeParseFloat(score.ca3) + safeParseFloat(score.pra) + safeParseFloat(score.exam)).toFixed(2);
//                 let totalPercentage = 0;
//                 if (safeParseFloat(score.ca1Total) + safeParseFloat(score.ca2Total) + safeParseFloat(score.ca3Total) + safeParseFloat(score.praTotal) + safeParseFloat(score.examTotal) !== 0) {
//                     totalPercentage = ((total / (safeParseFloat(score.ca1Total) + safeParseFloat(score.ca2Total) + safeParseFloat(score.ca3Total) + safeParseFloat(score.praTotal) + safeParseFloat(score.examTotal))) * 100).toFixed(2);
//                 }
//                 let grade = calculateGrade(totalPercentage);

//                 return {
//                     name: nameToMatch,
//                     total: parseFloat(total),
//                     totalPercentage: totalPercentage,
//                     grade: grade,
//                     score: score
//                 };
//             });

//             // Sort by total score in descending order
//             tableData.sort((a, b) => b.total - a.total);

//             // Assign positions based on the sorted order
//             tableData.forEach((data, index) => {
//                 data.position = index + 1;
//             });

//             let tableHtml = '';

//             if ($("#by_all").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             ${settingsData.ca1 == 1 ? `<th>CA1</th>` : ''}
//                             ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
//                             ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
//                             ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
//                             ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
//                             <th>Total</th>
//                             <th>Total (%)</th>
//                             <th>Position</th>
//                             <th>Grade</th>
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     ${tableData.map((data) => {
//                     let score = data.score;

//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${data.name}>${data.name}</td>
//                             ${settingsData.ca1 == 1 ? `<td class="scoreData">${score.ca1 || ''}</td>` : ''}
//                             ${settingsData.ca2 == 1 ? `<td class="scoreData">${score.ca2 || ''}</td>` : ''}
//                             ${settingsData.ca3 == 1 ? `<td class="scoreData">${score.ca3 || ''}</td>` : ''}
//                             ${settingsData.pra == 1 ? `<td class="scoreData">${score.pra || ''}</td>` : ''}
//                             ${settingsData.exa == 1 ? `<td class="scoreData">${score.exam || ''}</td>` : ''}
//                             <td class="font-xs-16 totalData">${data.total.toFixed(2)}</td>
//                             <td class="font-xs-16 totalpercentage">${data.totalPercentage}</td>
//                             <td class="font-xs-16 position">${data.position}</td>
//                             <td class="font-xs-16 grade">${data.grade}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }

//             if ($.fn.DataTable.isDataTable('#view_score_table_by_student')) {
//                 $('#view_score_table_by_student').DataTable().destroy();
//             }
//             $('#view_score_table_by_student').html(tableHtml);

//             // Reinitialize DataTable
//             $('#view_score_table_by_student').DataTable({
//                 scrollX: true,
//                 paging: false,
//                 ordering: false,
//                 fixedColumns: {
//                     left: 1,
//                     right: 0
//                 }
//             });
//         }
//     });
// }








// function view_table_data(filtertype, viewOrPostPage) {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     setTimeout(get_teacher_comment(termValue, sessionValue, studentValue, classValue, 'view'), 200);
//     let arrayValues = '';
//     let postdata = {};

//     if (filtertype === 'student') {
//         arrayValues = subjects;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             studentValue,
//             sessionValue
//         };
//         $("#view_table_title").html(`${$("#select_session_field option:selected").html() + ' ' + $(".select_btn.term.active").html() + ' scores for ' + $("#select_student_field option:selected").html() + ' in ' + $("#select_class_field option:selected").html()}`);
//         $("#view_teacher_comment_container").show();
//     } else {
//         arrayValues = students;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             subjectValue,
//             sessionValue
//         };
//         $("#view_table_title").html(`${$("#select_session_field option:selected").html() + ' ' + $(".select_btn.term.active").html() + ' ' + $("#select_subject_field option:selected").html() + ' scores for students in ' + $("#select_class_field option:selected").html()}`);
//         $("#view_teacher_comment_container").hide();
//     }

//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: postdata,
//         success: (data) => {
//             data = data.trim();
//             let response = JSON.parse(data);
//             let scores = response.scores;
//             let grading = response.grading;

//             function calculateGrade(totalPercentage) {
//                 for (let grade in grading) {
//                     if (totalPercentage <= grading[grade]) {
//                         return grade;
//                     }
//                 }
//                 return 'F'; // Default to 'F' if no grade matches
//             }

//             function safeParseFloat(value) {
//                 return isNaN(parseFloat(value)) ? 0 : parseFloat(value);
//             }

//             let tableHtml = '';

//             if ($("#by_all").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             ${settingsData.ca1 == 1 ? `<th>CA1</th>` : ''}
//                             ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
//                             ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
//                             ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
//                             ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
//                             <th>Total</th>
//                             <th>Total(%)</th>
//                             <th>Grade</th>
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);

//                     let total = (safeParseFloat(score.ca1) + safeParseFloat(score.ca2) + safeParseFloat(score.ca3) + safeParseFloat(score.pra) + safeParseFloat(score.exa)).toFixed(2);
//                     let totalPercentage = 0;
//                     if (safeParseFloat(score.ca1Total) + safeParseFloat(score.ca2Total) + safeParseFloat(score.ca3Total) + safeParseFloat(score.praTotal) + safeParseFloat(score.exaTotal) !== 0) {
//                         totalPercentage = ((total / (safeParseFloat(score.ca1Total) + safeParseFloat(score.ca2Total) + safeParseFloat(score.ca3Total) + safeParseFloat(score.praTotal) + safeParseFloat(score.exaTotal))) * 100).toFixed(2);
//                     }
//                     let grade = calculateGrade(totalPercentage);

//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${settingsData.ca1 == 1 ? `<td class="scoreData">${score.ca1 || ''}</td>` : ''}
//                             ${settingsData.ca2 == 1 ? `<td class="scoreData">${score.ca2 || ''}</td>` : ''}
//                             ${settingsData.ca3 == 1 ? `<td class="scoreData">${score.ca3 || ''}</td>` : ''}
//                             ${settingsData.pra == 1 ? `<td class="scoreData">${score.pra || ''}</td>` : ''}
//                             ${settingsData.exa == 1 ? `<td class="scoreData">${score.exa || ''}</td>` : ''}
//                             <td class="font-xs-14 totalData">${total}</td>
//                             <td class="font-xs-14 totalpercentage">${totalPercentage}</td>
//                             <td class="font-xs-14 grade">${grade}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_ca1").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>CA1</th>
//                             <th>CA1 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td class="scoreData ca1Data"><input type="number" class="form-control form-control-sm assess_score" value="${score.ca1 || ''}"></td>` : `<td class="scoreData">${score.ca1 || ''}</td>`}
//                             <td class="ca1TotalData">${score.ca1Total || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_ca2").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>CA2</th>
//                             <th>CA2 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td class="scoreData ca2Data"><input type="number" class="form-control form-control-sm assess_score" value="${score.ca2 || ''}"></td>` : `<td class="scoreData">${score.ca2 || ''}</td>`}
//                             <td class="ca2TotalData">${score.ca2Total || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_ca3").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>CA3</th>
//                             <th>CA3 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td class="scoreData ca3Data"><input type="number" class="form-control form-control-sm assess_score" value="${score.ca3 || ''}"></td>` : `<td class="scoreData">${score.ca3 || ''}</td>`}
//                             <td class="ca3TotalData">${score.ca3Total || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_pra").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>Practical</th>
//                             <th>Practical Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td class="scoreData praData"><input type="number" class="form-control form-control-sm assess_score" value="${score.pra || ''}"></td>` : `<td class="scoreData">${score.pra || ''}</td>`}
//                             <td class="praTotalData">${score.praTotal || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_exa").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>Exam</th>
//                             <th>Exam Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td class="scoreData exaData"><input type="number" class="form-control form-control-sm assess_score" value="${score.exa || ''}"></td>` : `<td class="scoreData">${score.exa || ''}</td>`}
//                             <td class="exaTotalData">${score.exaTotal || ''}</td>
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             if ($.fn.DataTable.isDataTable('#view_score_table_by_student')) {
//                 $('#view_score_table_by_student').DataTable().destroy();
//             }
//             $('#view_score_table_by_student').html(tableHtml);



//             // Reinitialize DataTable
//             $('#view_score_table_by_student').DataTable({
//                 scrollX: true,
//                 paging: false,
//                 ordering: false,
//                 fixedColumns: {
//                     left: 1,
//                     right: 0
//                 }
//             });
//         },
//         error: (xhr, status, error) => {
//             console.error('Error fetching data:', error);
//         }
//     });
// }







// alert('jh')
async function report_table_data(filtertype, viewOrPostPage) {
    const termValue = $(".select_btn.term.active").attr("data-name");
    const classValue = $(".class_value.active").val();
    try {
        await getsubjects(classValue, null)
    }
    catch (error) {
        return
    }
    const studentValue = $(".select_student.active").attr("data-studentId");
    const subjectValue = $("#select_subject_field").val();
    const sessionValue = $("#select_session_field").val();
    // alert(sessionValue)
    // const sessionValue = $("#select_session_field").val();
    let arrayValues = '';
    let postdata = {};

    // if (filtertype === 'student') {
    arrayValues = subjects;
    postdata = {
        action: 'get_scores',
        termValue,
        classValue,
        studentValue,
        sessionValue
    };
    setTimeout(get_teacher_comment(termValue, sessionValue, studentValue, classValue, 'report'), 200);
    setTimeout(set_behaviour_comment(termValue, sessionValue, studentValue, classValue, 'report'), 200);
    $("#report_teacher_comment_container").show();
    $("#report_student_general_behaviour").show();

    $("#report_table_title").html(`${$("#select_session_field option:selected").html() + ' ' + $(".select_btn.term.active").html() + ' scores for ' + $("#select_student_field option:selected").html() + ' in ' + $("#select_class_field option:Selected").html()}`)



    console.log("arrayValues", arrayValues);
    console.log("postdata", postdata);
    // alert("viewOrPostPage")
    let tableHtml = '';

    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: postdata,
        success: (data) => {
            data = data.trim();
            let response = JSON.parse(data);
            let scores = response.scores;
            let grading = response.grading;

            // Sort the grading system by values in descending order
            grading = Object.fromEntries(Object.entries(grading).sort(([, a], [, b]) => b - a));

            function calculateGrade(totalPercentage) {
                for (let grade in grading) {
                    if (totalPercentage >= grading[grade]) {
                        return grade;
                    }
                }
                return 'F'; // Default to 'F' if no grade matches
            }

            function safeParseFloat(value) {
                return isNaN(parseFloat(value)) ? 0 : parseFloat(value);
            }

            console.log("scores", scores);
            console.log(settingsData)
            // if ($("#by_all").hasClass('active')) {
            tableHtml = `
                <thead>
                    <tr>
                        <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
                        ${settingsData.ca1 == 1 ? `<th>CA1</th>` : ''}
                        ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
                        ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
                        ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
                        ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
                        <th>Total</th>
                        <th>Total (%)</th>
                        <th>Grade</th>
                    </tr>
                </thead>
                <tbody id="tbody">
                ${arrayValues.map((arrayValue) => {
                let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
                let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
                let total = (safeParseFloat(score.ca1) + safeParseFloat(score.ca2) + safeParseFloat(score.ca3) + safeParseFloat(score.pra) + safeParseFloat(score.exam)).toFixed(2);
                let totalPercentage = 0;
                if (safeParseFloat(score.ca1Total) + safeParseFloat(score.ca2Total) + safeParseFloat(score.ca3Total) + safeParseFloat(score.praTotal) + safeParseFloat(score.examTotal) !== 0) {
                    totalPercentage = ((total / (safeParseFloat(score.ca1Total) + safeParseFloat(score.ca2Total) + safeParseFloat(score.ca3Total) + safeParseFloat(score.praTotal) + safeParseFloat(score.examTotal))) * 100).toFixed(2);
                }
                let grade = calculateGrade(totalPercentage);

                return `<tr>
                        <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
                        ${settingsData.ca1 == 1 ? `<td class="scoreData">${score.ca1 || ''}</td>` : ''}
                        ${settingsData.ca2 == 1 ? `<td class="scoreData">${score.ca2 || ''}</td>` : ''}
                        ${settingsData.ca3 == 1 ? `<td class="scoreData">${score.ca3 || ''}</td>` : ''}
                        ${settingsData.pra == 1 ? `<td class="scoreData">${score.pra || ''}</td>` : ''}
                        ${settingsData.exa == 1 ? `<td class="scoreData">${score.exam || ''}</td>` : ''}
                        <td class="font-xs-16 totalData">${total}</td>
                        <td class="font-xs-16 totalpercentage">${totalPercentage}</td>
                        <td class="font-xs-16 grade">${grade}</td>
                    </tr>`;
            }).join('')}
                </tbody>`;
            // }

            // Destroy existing DataTable instance
            if ($.fn.DataTable.isDataTable('#report_score_table')) {
                $('#report_score_table').DataTable().destroy();
            }
            $('#report_score_table').html(tableHtml);

            // Function to calculate and update total scores
            function calculateTotals() {
                $('#tbody tr').each(function () {
                    let total = 0;
                    $(this).find('.scoreData').each(function () {
                        let score = parseFloat($(this).text()) || 0;
                        total += score;
                    });
                    $(this).find('.totalData').text(total);
                });
            }

            // Reinitialize DataTable
            $('#report_score_table').DataTable({
                scrollX: true,
                paging: false,
                ordering: false,
                fixedColumns: {
                    left: 1,
                    right: 0
                }
            });

            // Calculate and update totals after DataTable initialization
            calculateTotals();
        }
    });
}


// Function to check/uncheck all checkboxes
function check_uncheck_all() {
    var checkboxes = document.querySelectorAll('.table_checkbox');
    var selectAll = document.getElementById('select_all').checked;

    checkboxes.forEach(function (checkbox) {
        checkbox.checked = selectAll;
    });

    check_checkbox(); // Call the function to update action buttons visibility
}

// Function to check if any checkbox is checked and show/hide action buttons
function check_checkbox() {
    var checkboxes = document.querySelectorAll('.table_checkbox:checked');
    var actionButtons = document.querySelectorAll('.action_btn');

    if (checkboxes.length > 0) {
        actionButtons.forEach(function (btn) {
            btn.style.display = 'inline'; // Show the buttons
        });
    } else {
        actionButtons.forEach(function (btn) {
            btn.style.display = 'none'; // Hide the buttons
        });
    }
}

console.log("lkjk")
function get_all_checked_checkbox(selection_type, id, modal) {
    console.log("lind")
    $("#" + modal).modal("show");
    if (selection_type == 'multiple') {
        var box = []
        var checkedbox = $('.table_checkbox:checked');
        for (var i = 0; i < checkedbox.length; i++) {
            box.push(checkedbox[i].value);
        }
        var joinedcheckbox = box.join(",")
        $(".bulk_transfer_ids").val(joinedcheckbox)
    } else {
        console.log("sentidin", id)

        $(".bulk_transfer_ids").val(id)
    }
    // $.ajax({
    //     url: "../controller.php",
    //     type: "POST",
    //     beforeSend: () => {
    //     },
    //     success: (data) => {
    //         console.log("sentid",id)
    //     }
    // })
}
function get_all_checked_checkbox_for_report(selection_type, id, modal, ids_class) {
    $("#" + modal).modal("show");
    if (selection_type == 'multiple') {
        var box = []
        var checkedbox = $('.table_checkbox:checked');
        for (var i = 0; i < checkedbox.length; i++) {
            box.push(checkedbox[i].value);
        }
        var joinedcheckbox = box.join(",")
        $("." + ids_class).val(joinedcheckbox)
    }
    else if (selection_type == 'single') {
        $("." + ids_class).val(id)
    }
}

function get_the_id_for_password_reset(id, modal) {
    $("#" + modal).modal("show");
    $("#student_id_for_password_reset").val(id)
}

function reset_student_password_modal(e) {
    e.preventDefault()
    let formdata = new FormData(e.target);
    $.ajax({
        url: '../controller.php',
        type: 'post',
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $("#reset_student_password_btn").html('Processing...').prop('disabled', true);
        },
        success: (data) => {
            try {
                let res = JSON.parse(data);
                if (res.status == '1') {
                    toastr.success(res.msg || "Password reset successfully.");
                    $('#reset_student_password_modal').modal('hide');
                } else {
                    toastr.error(res.err || "Failed to reset password.");
                }
            } catch (e) {
                toastr.error("An unexpected error occurred.");
            }
        },
        complete: () => {
            $("#reset_student_password_btn").html('Reset').prop('disabled', false);
            e.target.reset();
        }
    });
}

// alert("dgh")

var student_name;
// function download_report_card(page_type) {
//     // alert(student_name)
//     let student_ids = []
//     let term_id, class_id;
//     if (page_type == 'report_page') {
//         student_ids = $(".bulk_report_ids").val().split(",")
//         term_id = $("#select_term_field").val()
//         class_id = $("#select_class_field_report").val()
//     } else if (page_type == 'student_page') {
//         student_ids = $("#select_student_field").val().split(",")
//         term_id = $(".select_btn.term.active").attr("data-name")
//         class_id = $("#select_class_field").val()
//     }
//     // alert(student_ids)
//     let session_id = $("#select_session_field").val()
//     let gradingSystem;
//     student_ids.forEach(student_id => {
//         // console.log("studen",student_id)
//         $.ajax({
//             url: "../controller.php",
//             type: 'post',
//             data: {
//                 'action': 'get_grading_score_data',
//                 'session_id': session_id,
//                 'student_id': student_id,
//                 'class_id': class_id,
//                 'term_id': term_id
//             },
//             success: (data) => {
//                 data = JSON.parse(data)
//                 settingsData = data.settingsData[0]
//                 console.log("sesco", data.settingsData[0])
//                 student_score_data = data.score_data
//                 gradingSystem = settingsData.grade
//                 console.log("ini", gradingSystem)
//                 student_name = student_score_data[0].student_name
//                 // return
//                 // alert("inner" + student_name)

//                 reportdata = { student_id, class_id, session_id, term_id, }
//                 $.ajax({
//                     url: '../single_report_card.php',
//                     type: 'POST',
//                     data: reportdata,
//                     beforeSend: () => {
//                         if (page_type == "student_page") {
//                             $("#preview_report_card_modal").modal("show")
//                             $("#pdf-content").html(
//                                 `<div id="skeleton-loader" class="skeleton-loader align-items-center">
//                             <div class="skeleton-line skeleton-photo"></div>
//                             <div class="skeleton-line skeleton-input w-75"></div>
//                             <div class="skeleton-line skeleton-input"></div>
//                             <div class="skeleton-line skeleton-input"></div>
//                             <div class="skeleton-line skeleton-input"></div>
//                             <div class="skeleton-line skeleton-button"></div>
//                             </div>`)
//                         } else {
//                             $("#pdf-content").html("Processing...")
//                         }
//                     },
//                     success: (data) => {
//                         data = data.trim();
//                         $("#pdf-content").html(data)
//                         if (page_type == "student_page") {
//                             $("#preview_report_card_foot").show()
//                         }
//                         // setTimeout(get_score_data,)

//                         format_student_table_report(student_score_data, term_id, session_id, class_id, gradingSystem)
//                         //     set_behaviour_comment(term_id, session_id, student_id, class_id, 'view');
//                         //                 generatePDF(data)
//                         setTimeout(() => {
//                             set_behaviour_comment(term_id, session_id, student_id, class_id, 'view');
//                             if (page_type == "report_page") {
//                                 setTimeout(() => {
//                                     // alert(student_name)
//                                     generatePDF(data)
//                                 }, 2000);
//                             }
//                         }, 200)


//                     }
//                 })
//             }
//         })
//     })
//     // return
//     // Select the section of the page you want to convert to PDF
//     // });
// }

// function save_attendance() {
//     const checkedbox_re = document.querySelectorAll('.table_checkbox.take_att_checkbox');
//     const register = {}
//     checkedbox_re.forEach((checkbox) => {
//         if (checkbox.checked) {
//             register[checkbox.value] = 1
//         } else {
//             register[checkbox.value] = 0
//         }
//     })
//     $.ajax({
//         url: "../controller.php",
//         type: "post",
//         data: { action: 'set_attendance', att_date: $("#att_date").val(), class_id: $("#select_class_field").val(), register, },
//         success: (data) => {
//             toastr.success("Attendance taken")
//         }
//     })
// }
function save_attendance(type) {
    if (type != '0') {
        // alert("not 0")
        // return
        const checkedbox_re = document.querySelectorAll('.table_checkbox.take_att_checkbox');
        const checkedbox_re2 = document.querySelectorAll('.table_checkbox2.take_att_checkbox2');
        const register = {}
        const register2 = {}
        checkedbox_re.forEach((checkbox) => {
            if (checkbox.checked) {
                register[checkbox.value] = 1
            } else {
                register[checkbox.value] = 0
            }
        })
        checkedbox_re2.forEach((checkbox2) => {
            if (checkbox2.checked) {
                register2[checkbox2.value] = 1
            } else {
                register2[checkbox2.value] = 0
            }
        })
        post_data = { action: 'set_attendance', att_date: $("#att_date").val(), class_id: $("#select_class_field").val(), register, register2, type, };
    } else {
        // alert("0")
        // --- Collect data for 'once' type attendance ---
        const attendanceData = {}; // Use an object to map student_id to attendance count

        $('input[name="one_time_att"]').each(function () {
            const studentId = $(this).data('student_id'); // Get student ID from data attribute
            const attendanceValue = $(this).val();       // Get attendance count from input value

            // Ensure studentId is valid before adding to the object
            if (studentId !== undefined && studentId !== null) {
                // Store the value, converting to an integer (or 0 if empty/invalid)
                attendanceData[studentId] = parseInt(attendanceValue, 10) || 0;
            } else {
                console.warn("Input field found without a valid data-student_id attribute.");
            }
        });

        // Prepare the data object for the AJAX request
        post_data = { // Assign to the existing post_data variable
            action: 'set_attendance', // Use a specific action for this type of update
            // att_date: $("#att_date").val(), // Include date if needed by your PHP
            class_id: $("#select_class_field").val(), // Include class ID
            attendance_data: attendanceData, // The collected attendance data object
            type, // Specify the type of attendance
        };

        console.log("Data to be sent:", post_data); // For debugging purposes
        // --- End of data collection for 'once' type ---
    }
    // The AJAX call remains the same, using the populated post_data variable
    // Ensure your PHP controller has a case for action: 'set_attendance_once'
    // to handle the 'attendance_data' object correctly.

    /*
    // Original AJAX call structure (keep this part)
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: post_data,
        success: (data) => {
            toastr.success("Attendance taken")
        }
    }) 
    */
    // Example AJAX call using the collected post_data:
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: post_data, // Send the structured data
        // dataType: 'json', // Expect JSON response if your PHP sends one
        success: (data) => {
            // Process the response from your PHP script
            // Example: Assuming JSON response { status: '1', msg: '...' }
            try {
                const response = JSON.parse(data);
                if (response.status === '1') {
                    toastr.success(response.msg || "Attendance saved successfully");
                } else {
                    toastr.error(response.err || "Failed to save attendance");
                }
            } catch (e) { console.error("Failed to parse response:", data); toastr.error("An error occurred."); }
        },
        error: (xhr, status, error) => { console.error("AJAX error:", status, error); toastr.error("Failed to communicate with the server."); }
    });
}

// alert("kk")
$(".daterange").change(() => {
    calculateDateRange()
    if ($(".daterange").val() == "custom") {
        $("#daterange_custom").show()
    } else {
        $("#daterange_custom").hide()
    }
})
$("#daterange_custom").change(() => {
    if (!$("#custom_start").val() || !$("#custom_end").val()) {
        return
    }
    fetchSelectedDates_att($("#custom_start").val(), $("#custom_end").val());
})
function calculateDateRange() {
    if ($(".daterange").val() == "custom") {
        fetchSelectedDates_att($("#custom_start").val(), $("#custom_end").val());
        return
    } else {

        const today = new Date();
        let startDate = new Date();


        switch ($(".daterange").val()) {
            case "today":
                break;

            case "yesterday":
                startDate.setDate(today.getDate() - 1);
                break;

            case "last 7 days":
                startDate.setDate(today.getDate() - 6);
                break;

            case "last 30 days":
                startDate.setDate(today.getDate() - 29);
                break;

            case "this month":
                startDate = new Date(today.getFullYear(), today.getMonth(), 1);
                break;

            case "last month":
                startDate = new Date(today.getFullYear(), today.getMonth() - 1, 1);
                endDate = new Date(today.getFullYear(), today.getMonth(), 0);
                break;

            case "this term":
                startDate = 'term';
                break;
            case "this session":
                startDate = 'session';
                break;

            default:
                throw new Error("Invalid range. Accepted values are: Today, Yesterday, Last 7 days, Last 30 days, This month, Last month.");
        }
        // console.log(endDate)

        const formatDate = (date) =>
            `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`;
        if (startDate == 'term' || startDate == 'session') {
            fetchSelectedDates_att((startDate), formatDate(today));
            return
        }
        fetchSelectedDates_att(formatDate(startDate), formatDate(today));
        // return {
        //     startDate: formatDate(startDate),
        //     endDate: formatDate(today),
        // };
    }
}

// function fetchSelectedDates_att(startDate, endDate) {
//     $.ajax({
//         url: '../controller.php', // Replace with your PHP endpoint
//         method: 'POST',
//         data: {
//             start_date: startDate,
//             end_date: endDate,
//             action: 'get_att',
//             class_id: $("#select_class_field").val(),
//             // student_id: $(".bulk_att_report_ids").val(),
//         },
//         success: function (response) {
//             const data = JSON.parse(response);

//             if (data.length === 0) {
//                 $(".data_overlay").show()
//                 $(".data_overlay").html(`
//                     <p class="font-weight-bold">No attendance data found for the selected date or class</p>
//                 `)
//                 $("#tbl_container").html('');
//                 // $("#att_table_report").html("<p>No attendance data found for the selected date range.</p>");
//                 return;
//             }
//             $(".data_overlay").hide()



//             // Extract unique dates and students
//             const dates = [...new Set(data.map(item => item.att_date))].sort();
//             const students = [...new Set(data.map(item => item.student_id))];

//             // Generate table header
//             let tableHeader = `
//                 <table id="att_table_report" class="display nowrap" style="width:100%;">

//                 <thead>
//                     <tr>
//                         <th class="font-weight-normal">Names</th>`;
//             dates.forEach(date => {
//                 tableHeader += `<th>${moment(date).format('DD-MM')}</th>`;
//             });
//             tableHeader += `
//                         <th>Present</th>
//                         <th>Absent</th>
//                         <th>History</th>
//                     </tr>
//                 </thead>`;

//             // Generate table body
//             let tableBody = "<tbody>";

//             students.forEach(student_id => {
//                 const studentData = data.filter(item => item.student_id === student_id);
//                 const studentName = `${studentData[0].lastname} ${studentData[0].firstname} ${studentData[0].middlename}`.trim();
//                 console.log(studentData)

//                 let presentCount = 0;
//                 let absentCount = 0;
//                 let history = `<a onclick="get_att_inform('today','today','${studentName}','${student_id}','${studentData[0].session_id}','${studentData[0].term_id}','${studentData[0].class_id}')"><span class="material-symbols-outlined accent">manage_search</span></a>`

//                 tableBody += `<tr><td>${studentName}</td>`;

//                 dates.forEach(date => {
//                     const attendance = studentData.find(item => item.att_date === date);
//                     if (attendance) {
//                         if (attendance.state === "1") {
//                             tableBody += `<td><span class="material-symbols-outlined text-success">check</span></td>`;
//                             presentCount++;
//                         } else {
//                             tableBody += `<td><span class="material-symbols-outlined text-danger">close</span></td>`;
//                             absentCount++;
//                         }

//                     } else {
//                         tableBody += `<td>-</td>`; // No data for this date
//                     }
//                 });

//                 tableBody += `<td>${presentCount}</td><td>${absentCount}</td><td>${history}</td></tr>`;
//             });

//             tableBody += "</tbody></table>";

//             // Combine header and body
//             const tableHTML = `<table class="table table-bordered">${tableHeader}${tableBody}</table>`;

//             $("#tbl_container").html(tableHTML);
//             // if ($.fn.DataTable.isDataTable('#att_table_report')) {
//             //     $('#att_table_report').DataTable().destroy();
//             // }
//             $('#att_table_report').DataTable({
//                 scrollX: true,
//                 paging: false,
//                 ordering: false,
//                 fixedColumns: {
//                     left: 1,
//                     right: 0
//                 }
//             });
//         },
//         error: function (error) {
//             console.error("Error fetching data:", error);
//         },
//     });
// }
function fetchSelectedDates_att(startDate, endDate) {
    // alert("kl")
    $.ajax({
        url: '../controller.php', // Replace with your PHP endpoint
        method: 'POST',
        data: {
            start_date: startDate,
            end_date: endDate,
            action: 'get_att',
            class_id: $("#select_class_field").val(),
            // student_id: $(".bulk_att_report_ids").val(), // Keep commented if not needed
        },
        success: function (response) {
            let data;
            try {
                data = JSON.parse(response);
            } catch (e) {
                console.error("Failed to parse JSON response:", response);
                $(".data_overlay").show().html(`<p class="font-weight-bold">Error processing attendance data.</p>`);
                $("#tbl_container").html('');
                return;
            }


            if (!Array.isArray(data) || data.length === 0) {
                $(".data_overlay").show().html(`
                    <p class="font-weight-bold">No attendance data found for the selected date or class</p>
                `);
                $("#tbl_container").html('');
                return;
            }
            $(".data_overlay").hide();

            // Extract unique dates and students
            const dates = [...new Set(data.map(item => item.att_date))].sort();
            // Group data by student_id for easier lookup
            const studentsData = data.reduce((acc, item) => {
                if (!acc[item.student_id]) {
                    acc[item.student_id] = {
                        name: `${item.lastname} ${item.firstname} ${item.middlename}`.trim(),
                        records: {},
                        // Store details needed for history link once
                        session_id: item.session_id,
                        term_id: item.term_id,
                        class_id: item.class_id
                    };
                }
                acc[item.student_id].records[item.att_date] = item; // Map date to record
                return acc;
            }, {});

            const studentIds = Object.keys(studentsData);

            // --- Generate table header ---
            let tableHeader = `
                <table id="att_table_report" class="display nowrap compact table-bordered" style="width:100%;">
                <thead>
                    <tr>
                        <th rowspan="2" class="font-weight-normal align-middle">Names</th>`; // rowspan for Name column
            dates.forEach(date => {
                // Add date header spanning two columns
                tableHeader += `<th colspan="2" class="text-center">${moment(date).format('DD-MM')}</th>`;
            });
            tableHeader += `
                        <th rowspan="2" class="align-middle">Present</th>
                        <th rowspan="2" class="align-middle">Absent</th>
                        <th rowspan="2" class="align-middle">History</th>
                    </tr>
                    <tr>`; // Second header row for First/Second
            dates.forEach(() => {
                // Add First and Second sub-headers for each date
                tableHeader += `<th>1st</th><th>2nd</th>`;
            });
            tableHeader += `
                    </tr>
                </thead>`;
            // --- End of table header generation ---

            // --- Generate table body ---
            let tableBody = "<tbody>";

            studentIds.forEach(student_id => {
                const studentInfo = studentsData[student_id];
                const studentName = studentInfo.name;
                const studentRecords = studentInfo.records;

                let presentCount = 0;
                let absentCount = 0;
                // Construct history link using stored details
                let history = `<a onclick="get_att_inform('today','today','${studentName.replace(/'/g, "\\'")}', '${student_id}','${studentInfo.session_id}','${studentInfo.term_id}','${studentInfo.class_id}')"><span class="material-symbols-outlined accent">manage_search</span></a>`;

                tableBody += `<tr><td>${studentName}</td>`; // Student name cell

                dates.forEach(date => {
                    const attendance = studentRecords[date]; // Get record for this student and date
                    if (attendance) {
                        // Check 'first' attendance
                        if (attendance.first === "1") {
                            tableBody += `<td><span class="material-symbols-outlined text-success">check</span></td>`;
                        } else {
                            tableBody += `<td><span class="material-symbols-outlined text-danger">close</span></td>`;
                        }
                        // Check 'second' attendance
                        if (attendance.second === "1") {
                            tableBody += `<td><span class="material-symbols-outlined text-success">check</span></td>`;
                        } else {
                            tableBody += `<td><span class="material-symbols-outlined text-danger">close</span></td>`;
                        }

                        // Update present/absent count for the day
                        if (attendance.first === "1" || attendance.second === "1") {
                            // presentCount++; // Old logic: Count day as present if attended at least once
                        } else {
                            // absentCount++; // Old logic: Count day as absent if attended neither
                        }
                        presentCount += (attendance.first === "1" ? 1 : 0) + (attendance.second === "1" ? 1 : 0);
                        absentCount += (attendance.first === "0" ? 1 : 0) + (attendance.second === "0" ? 1 : 0);
                    } else {
                        // No data for this date, add placeholders for both sessions
                        tableBody += `<td>-</td><td>-</td>`;
                        absentCount++; // Count as absent if no record exists for the day
                    }
                });

                // Add total present, absent, and history link cells
                tableBody += `<td>${presentCount}</td><td>${absentCount}</td><td>${history}</td></tr>`;
            }); // End studentIds.forEach

            tableBody += "</tbody>"; // Close tbody
            // --- End of table body generation ---

            // Combine header and body
            const tableHTML = tableHeader + tableBody + `</table>`; // Close table

            $("#tbl_container").html(tableHTML);

            // Destroy previous DataTable instance if it exists
            if ($.fn.DataTable.isDataTable('#att_table_report')) {
                $('#att_table_report').DataTable().destroy();
            }
            // Initialize DataTable
            $('#att_table_report').DataTable({
                scrollX: true,
                paging: false, // Consider enabling paging if the table gets very long
                ordering: false,
                fixedColumns: {
                    left: 1, // Fix the 'Names' column
                    right: 0
                },
                // Optional: Add buttons for export if needed
                // dom: 'Bfrtip',
                // buttons: [
                //     'copy', 'excel', 'pdf', 'print'
                // ]
            });
        },
        error: function (xhr, status, error) { // Added xhr for more details
            console.error("Error fetching data:", status, error, xhr.responseText);
            $(".data_overlay").show().html(`<p class="font-weight-bold">Error fetching attendance data. Please check console.</p>`);
            $("#tbl_container").html('');
        },
    });
}




function preview_pdf() {
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
            "data": student_score_data,
            settingsData,
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
            // alert("jj")
            format_student_table_report(student_score_data, $(".select_btn.term.active").attr("data-name"), $("#select_session_field").val(), $("#select_class_field").val())
            // generatePDF();
            console.log("sllslll", student_score_data)

            // setTimeout(set_behaviour_comment('1', '1', '33', '24', 'view'), 200);

            // var element = document.getElementById('pdf-content');
            //  return


            // Configure and generate the PDF
            // html2pdf().from(element).set({
            //     margin: 1,
            //     filename: 'sample.pdf',
            //     html2canvas: {
            //         scale: 2
            //     },
            //     jsPDF: {
            //         orientation: 'portrait',
            //         unit: 'in',
            //         format: 'letter',
            //         compressPDF: true
            //     }
            // }).save();
        }
    })
    // Select the section of the page you want to convert to PDF
    // });
}
// alert('lk')
// alert("lll")
// function download_att_report() {
//     // return
//     const element = $("#pdf-content").html();
//     // const element = document.querySelector('.report-card');

//     const opt = {
//         margin: 3, // Set margins [top, left, bottom, right]
//         filename: 'attendance_report.pdf',
//         image: {
//             type: 'jpeg',
//             quality: 0.98
//         },
//         html2canvas: {
//             scale: 2
//         }, // Scale can be adjusted (2 is default; lower values reduce the size)
//         jsPDF: {
//             unit: 'mm',
//             format: 'a4',
//             orientation: 'portrait'
//         }
//     };

//     html2pdf().from(element).set(opt).save();
// }
function download_att_report() {
    // Select the DataTables container (processed table)
    const dataTableHtml = document.querySelector('#att_table_report_wrapper').outerHTML;

    // Create a temporary div for the rendered table content
    const tempDiv = document.createElement('div');
    tempDiv.style.display = 'block';
    tempDiv.style.width = '100%';
    tempDiv.style.transform = 'rotate(-90deg)'; // Rotate content
    tempDiv.style.transformOrigin = 'top left'; // Ensure the rotation starts at the top-left corner
    tempDiv.style.paddingTop = '30px'; // Adjust top padding to prevent clipping
    tempDiv.style.marginLeft = '10px'; // Adjust left margin to position it properly
    tempDiv.innerHTML = dataTableHtml;

    // Define PDF options
    const opt = {
        margin: [10, 10], // Set margins
        filename: 'attendance_report.pdf',
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2 },
        jsPDF: {
            unit: 'mm',
            format: 'a4',
            orientation: 'portrait', // Use portrait orientation to accommodate rotated content
        },
    };

    // Generate PDF from the temporary div
    html2pdf().from(tempDiv).set(opt).save().then(() => {
        console.log('PDF generated successfully!');
    });
}





function generatePDF(thestudent_name) {
    const previewContent = document.getElementById("preview-content");
    const singleReport = document.querySelector(".report-card");
    const element =
        previewContent && previewContent.innerHTML.trim() !== ""
            ? previewContent
            : singleReport;

    if (!element) return;

    const htmlString = `
    <div style="width: 1000px; background-color: #ffffff; padding: 20px; font-family: sans-serif;">
      ${element.innerHTML}
    </div>
  `;

    const opt = {
        margin: [10, 5, 10, 5],
        filename: (thestudent_name || "Report").trim() + ".pdf",
        image: { type: "jpeg", quality: 0.98 },
        html2canvas: {
            scale: 2,
            useCORS: true,
            letterRendering: true,
            width: 1000,
        },
        jsPDF: {
            unit: "mm",
            format: "a4",
            orientation: "portrait",
            compress: true,
        },
    };

    html2pdf()
        .from(htmlString)
        .set(opt)
        .save()
        .catch((err) => {
            console.error("PDF Generation Error:", err);
        });
}
async function downloadAllReports() {
    console.log("weeeeeeeeeeeeeeeeeeeeeeeeeeee")
    const reports = document.querySelectorAll("#preview-content .single-report");
    const downloadButton = $("#download-pdf-button");

    if (reports.length === 0) return;

    downloadButton
        .prop("disabled", true)
        .html('<i class="fas fa-spinner fa-spin mr-1"></i> Downloading...');

    for (let i = 0; i < reports.length; i++) {
        const report = reports[i];
        const nameEl = report.querySelector(".student-name-header");
        const studentName = nameEl
            ? nameEl.getAttribute("data-student-name")
            : `Student_${i + 1}`;

        // Create a temporary container for each report to ensure clean capture
        const htmlString = `
      <div style="width: 1000px; background-color: #ffffff; padding: 20px; font-family: sans-serif;">
        ${report.innerHTML}
      </div>
    `;

        const opt = {
            margin: [10, 5, 10, 5],
            filename: (studentName || "Report").trim() + ".pdf",
            image: { type: "jpeg", quality: 0.98 },
            html2canvas: {
                scale: 2,
                useCORS: true,
                letterRendering: true,
                width: 1000,
            },
            jsPDF: {
                unit: "mm",
                format: "a4",
                orientation: "portrait",
                compress: true,
            },
        };

        try {
            await html2pdf().from(htmlString).set(opt).save();
            // Small delay to prevent browser download blocking
            if (i < reports.length - 1) {
                await new Promise((resolve) => setTimeout(resolve, 800));
            }
        } catch (err) {
            console.error(`Error downloading report for ${studentName}:`, err);
        }
    }

    downloadButton
        .prop("disabled", false)
        .html('<i class="fas fa-download mr-1"></i> Download PDF');
}

// function generatePDF(data) {
//     console.log(data)
//     // alert("func" + student_name)
//     // return
//     // const element = data;
//     const element = document.querySelector('.report-card');

//     const opt = {
//         margin: 3, // Set margins [top, left, bottom, right]
//         filename: student_name + '.pdf',
//         image: {
//             type: 'jpeg',
//             quality: 0.98
//         },
//         html2canvas: {
//             scale: 2
//         }, // Scale can be adjusted (2 is default; lower values reduce the size)
//         jsPDF: {
//             unit: 'mm',
//             format: 'a4',
//             orientation: 'portrait'
//         }
//     };

//     html2pdf().from(element).set(opt).save();
// }
// function multiplereport_download() {
//     // console.log(student_score_data)
//     let session_id = '1'
//     let student_id = '57'
//     let class_id = '44'
//     let term_id = '1'
//     let gradingSystem;
//     $.ajax({
//         url: "../controller.php",
//         type: 'post',
//         data: {
//             'action': 'get_grading_score_data',
//             'session_id': session_id,
//             'student_id': student_id,
//             'class_id': class_id,
//             'term_id': term_id
//         },
//         success: (data) => {
//             data = JSON.parse(data)
//             console.log("sesco", data)
//             settingsData = data.settingsData
//             student_score_data = data.score_data
//             console.log(settingsData)
//             gradingSystem = settingsData[0].grade
//             // console.log(settingsData[0].grade)
//             // return
//             // return {
//             //     settingsData,
//             //     student_score_data,
//             //     gradingSystem,
//             // }
//             $.ajax({
//                 url: 'single_report_card.php',
//                 type: 'POST',
//                 data: {
//                     "studentid": student_id,
//                     "classid": class_id,
//                     "sessionid": session_id,
//                     "termid": term_id,
//                     // "data": student_score_data,
//                     // settingsData,
//                 },
//                 beforeSend: () => {
//                     console.log("Downloading...")
//                 },
//                 success: (data) => {
//                     data = data.trim();
//                     $("#pdf_m_cont").html(data)
//                     format_student_table_report(student_score_data, student_id, term_id, session_id, class_id, gradingSystem, () => {

//                         alert("hj")
//                         var element = document.getElementById('pdf_m_cont');
//                         const opt = {
//                             margin: 3, // Set margins [top, left, bottom, right]
//                             filename: 'Report_Card.pdf',
//                             image: {
//                                 type: 'jpeg',
//                                 quality: 0.98
//                             },
//                             html2canvas: {
//                                 scale: 2
//                             }, // Scale can be adjusted (2 is default; lower values reduce the size)
//                             jsPDF: {
//                                 unit: 'mm',
//                                 format: 'a4',
//                                 orientation: 'portrait'
//                             }
//                         };

//                         html2pdf().from(element).set(opt).save();
//                     })
//                 }
//             })
//         }
//     })
//     // return
//     // loadSettings().done(function (response) {
//     // return
// }

// function set_behaviour_comment(term, session, student_id, class_id, pagetype) {
//     // alert('kl')
//     if ($("#report_page").val() === 'report_scores') {
//         pagetype = 'report'
//     }
//     $.ajax({
//         url: "../controller.php",
//         type: "POST",
//         data: { 'action': 'getbehaviour_comment', term, session, student_id, class_id, pagetype },
//         success: (data) => {
//             data = data.trim();
//             data = JSON.parse(data);
//             // alert(data.staff_classId)
//             // let staff_classId_json = JSON.parse(data.staff_classId)
//             // alert((data.staff_classId).includes(class_id))
//             thebehavedata = data.comment;
//             if ($("#comment_student_page").val() == "comment") {
//                 // console.log("comm",data.comment)
//                 if ((data.staff_classId).includes(class_id) == false && pagetype == 'post') {

//                     // console.log("kkk")
//                     document.querySelectorAll(".btn.togglebtn").forEach(button => {
//                         button.disabled = true
//                         // button.addEventListener("click", function(event){
//                         //     event.preventDefault()
//                         //     event.stopPropagation()
//                         // })
//                     })

//                 }
//                 if (data.comment == '') {
//                     console.log('success but empty');
//                     $("#post_teacher_comment_gb_container").show();
//                     let behave = ['punctuality', 'classattendance', 'resptoass', 'Politeness', 'Honesty', 'selfcontrol', 'relationship', 'responsibility', 'organizationability', 'Neatness', 'Obedience', 'Creativity', 'Writing', 'Fluency', 'Sport', 'Games', 'DrawingPainting', 'Music', 'HandlingTools', 'Crafts'];
//                     behave.map((each) => {
//                         let theclasses = Array.from(document.querySelectorAll(`.${each}`));
//                         theclasses.map((item) => {
//                             item.classList.remove("active");
//                         });
//                     });
//                 } else {
//                     console.log("access garnted with ful data")
//                     parsedata = JSON.parse(thebehavedata)
//                     $("#post_teacher_comment_gb_container").show();
//                     Object.entries(parsedata).forEach(([key, thevalue]) => {
//                         let punct = Array.from(document.querySelectorAll(`.${key}`));
//                         punct.map((each) => {
//                             each.classList.remove("active");
//                             each.value == thevalue && each.classList.add("active");
//                         });
//                     });
//                 }
//             }


//             if ((data.staff_classId).includes(class_id) && pagetype == 'post') {
//                 if (data.comment == '') {
//                     console.log('success but empty');
//                     $("#post_teacher_comment_gb_container").show();
//                     let behave = ['punctuality', 'classattendance', 'resptoass', 'Politeness', 'Honesty', 'selfcontrol', 'relationship', 'responsibility', 'organizationability', 'Neatness', 'Obedience', 'Creativity', 'Writing', 'Fluency', 'Sport', 'Games', 'DrawingPainting', 'Music', 'HandlingTools', 'Crafts'];
//                     behave.map((each) => {
//                         let theclasses = Array.from(document.querySelectorAll(`.${each}`));
//                         theclasses.map((item) => {
//                             item.classList.remove("active");
//                         });
//                     });
//                 } else {
//                     console.log("access garnted with ful data")
//                     parsedata = JSON.parse(thebehavedata)
//                     $("#post_teacher_comment_gb_container").show();
//                     Object.entries(parsedata).forEach(([key, thevalue]) => {
//                         let punct = Array.from(document.querySelectorAll(`.${key}`));
//                         punct.map((each) => {
//                             each.classList.remove("active");
//                             each.value == thevalue && each.classList.add("active");
//                         });
//                     });
//                 }
//             } else if (pagetype == 'view' || pagetype == 'report') {
//                 // alert('ll')
//                 function getPercentage(score) {
//                     switch (score) {
//                         case "5": return "100%";
//                         case "4": return "80%";
//                         case "3": return "60%";
//                         case "2": return "40%";
//                         case "1": return "20%";
//                         default: return "Not rated";
//                     }
//                 }
//                 if (thebehavedata == '') {
//                     let behave = ['punctuality', 'classattendance', 'resptoass', 'Politeness', 'Honesty', 'selfcontrol', 'relationship', 'responsibility', 'organizationability', 'Neatness', 'Obedience', 'Creativity', 'Writing', 'Fluency', 'Sport', 'Games', 'DrawingPainting', 'Music', 'HandlingTools', 'Crafts'];
//                     behave.map((key) => {
//                         console.log(key)
//                         $("." + key).html(getPercentage(0))
//                     })
//                 } else {
//                     par = JSON.parse(thebehavedata)
//                     Object.entries(par).forEach(([key, value]) => {
//                         $("." + key).html(getPercentage(value))
//                     })
//                 }
//             }
//             else {
//                 $("#view_teacher_comment_gb_container").hide();
//                 $("#post_teacher_comment_gb_container").hide();
//             }
//         }
//     });
// }
console.log('kilometer')
function toggleBehaviourSectionsVisibility(showSections, container = null) {
    const shouldShow = showSections !== false;
    if (container) {
        container.find('.general_behaviour_section, .psychomotive_skills_section').toggle(shouldShow);
        container.find('.report-card-behaviour-table').closest('table').toggle(shouldShow);
        container.find('.report-card-psychomotive-table').closest('table').toggle(shouldShow);
        return;
    }
    $('.general_behaviour_section, .psychomotive_skills_section').toggle(shouldShow);
}

function set_behaviour_comment(term, session, student_id, class_id, pagetype) {
    console.log(window.schoolHiddenSkills);
    if ($("#report_page").val() === "report_scores") {
        pagetype = "report";
    }
    $.ajax({
        url: "../controller.php",
        type: "POST",
        data: {
            action: "getbehaviour_comment",
            term,
            session,
            student_id,
            class_id,
            pagetype,
        },
        success: (data) => {
            data = data.trim();
            data = JSON.parse(data);
            // alert(data.staff_classId)
            // let staff_classId_json = JSON.parse(data.staff_classId)
            // alert((data.staff_classId).includes(class_id))
            toggleBehaviourSectionsVisibility(data.show_behaviour_sections);
            thebehavedata = data.comment;
            console.log("thebehavedata", thebehavedata)
            console.log("thebehavedata2", data)
            if ($("#comment_student_page").val() == "comment") {
                // console.log("comm",data.comment)
                if (
                    data.staff_classId.includes(class_id) == false &&
                    pagetype == "post"
                ) {
                    // console.log("kkk")
                    document.querySelectorAll(".btn.togglebtn").forEach((button) => {
                        button.disabled = true;
                        // button.addEventListener("click", function(event){
                        //     event.preventDefault()
                        //     event.stopPropagation()
                        // })
                    });
                }
                if (data.comment == "") {
                    console.log("success but empty");
                    $("#post_teacher_comment_gb_container").show();
                    let behave =
                        typeof window.schoolSkills !== "undefined" &&
                            Array.isArray(window.schoolSkills) &&
                            window.schoolSkills.length > 0
                            ? window.schoolSkills
                            : [
                                "punctuality",
                                "classattendance",
                                "resptoass",
                                "Politeness",
                                "Honesty",
                                "selfcontrol",
                                "relationship",
                                "responsibility",
                                "organizationability",
                                "Neatness",
                                "Obedience",
                                "Creativity",
                                "Writing",
                                "Fluency",
                                "Sport",
                                "Games",
                                "DrawingPainting",
                                "Music",
                                "HandlingTools",
                                "Crafts",
                            ];
                    if (
                        typeof window.schoolHiddenSkills !== "undefined" &&
                        Array.isArray(window.schoolHiddenSkills)
                    ) {
                        behave = behave.filter(
                            (skill) => !window.schoolHiddenSkills.includes(skill)
                        );
                    }
                    console.log("theskills", behave);
                    behave.map((each) => {
                        let theclasses = Array.from(document.querySelectorAll(`.${each}`));
                        theclasses.map((item) => {
                            item.classList.remove("active");
                        });
                    });
                } else {
                    console.log("access garnted with ful data1");
                    parsedata = JSON.parse(thebehavedata);
                    console.log("comm", parsedata);
                    $("#post_teacher_comment_gb_container").show();
                    Object.entries(parsedata).forEach(([key, thevalue]) => {
                        let punct = Array.from(document.querySelectorAll(`.${key}`));
                        punct.map((each) => {
                            each.classList.remove("active");
                            each.value == thevalue && each.classList.add("active");
                        });
                    });
                }
            }

            if (data.staff_classId.includes(class_id) && pagetype == "post") {
                if (data.comment == "") {
                    console.log("success but empty");
                    $("#post_teacher_comment_gb_container").show();
                    let behave =
                        typeof window.schoolSkills !== "undefined" &&
                            Array.isArray(window.schoolSkills) &&
                            window.schoolSkills.length > 0
                            ? window.schoolSkills
                            : [
                                "punctuality",
                                "classattendance",
                                "resptoass",
                                "Politeness",
                                "Honesty",
                                "selfcontrol",
                                "relationship",
                                "responsibility",
                                "organizationability",
                                "Neatness",
                                "Obedience",
                                "Creativity",
                                "Writing",
                                "Fluency",
                                "Sport",
                                "Games",
                                "DrawingPainting",
                                "Music",
                                "HandlingTools",
                                "Crafts",
                            ];
                    if (
                        typeof window.schoolHiddenSkills !== "undefined" &&
                        Array.isArray(window.schoolHiddenSkills)
                    ) {
                        behave = behave.filter(
                            (skill) => !window.schoolHiddenSkills.includes(skill)
                        );
                    }
                    console.log("theskills", behave);
                    behave.map((each) => {
                        let theclasses = Array.from(document.querySelectorAll(`.${each}`));
                        theclasses.map((item) => {
                            item.classList.remove("active");
                        });
                    });
                } else {
                    console.log("access garnted with ful data2");
                    parsedata = JSON.parse(thebehavedata);
                    console.log("comm", parsedata);
                    $("#post_teacher_comment_gb_container").show();
                    Object.entries(parsedata).forEach(([key, thevalue]) => {
                        let punct = Array.from(document.querySelectorAll(`.${key}`));
                        punct.map((each) => {
                            each.classList.remove("active");
                            each.value == thevalue && each.classList.add("active");
                        });
                    });
                }
            } else if (pagetype == "view" || pagetype == "report") {
                console.log('llama now')
                function getPercentage(score) {
                    switch (score) {
                        case "5":
                            return "100%";
                        case "4":
                            return "80%";
                        case "3":
                            return "60%";
                        case "2":
                            return "40%";
                        case "1":
                            return "20%";
                        default:
                            return "Not rated";
                    }
                }
                if (thebehavedata == "") {
                    console.log("behace")
                    let behave =
                        typeof window.schoolSkills !== "undefined" &&
                            Array.isArray(window.schoolSkills) &&
                            window.schoolSkills.length > 0
                            ? window.schoolSkills
                            : [
                                "punctuality",
                                "classattendance",
                                "resptoass",
                                "Politeness",
                                "Honesty",
                                "selfcontrol",
                                "relationship",
                                "responsibility",
                                "organizationability",
                                "Neatness",
                                "Obedience",
                                "Creativity",
                                "Writing",
                                "Fluency",
                                "Sport",
                                "Games",
                                "DrawingPainting",
                                "Music",
                                "HandlingTools",
                                "Crafts",
                            ];
                    if (
                        typeof window.schoolHiddenSkills !== "undefined" &&
                        Array.isArray(window.schoolHiddenSkills)
                    ) {
                        behave = behave.filter(
                            (skill) => !window.schoolHiddenSkills.includes(skill)
                        );
                    }
                    console.log("theskills", behave);
                    behave.map((key) => {
                        console.log(key);
                        $("." + key).html(getPercentage(0));
                    });
                } else {
                    console.log("king and queens")
                    par = JSON.parse(thebehavedata);
                    Object.entries(par).forEach(([key, value]) => {
                        $("." + key).html(getPercentage(value));
                    });
                }
            } else {
                $("#view_teacher_comment_gb_container").hide();
                $("#post_teacher_comment_gb_container").hide();
            }
        },
    });
}
// function get_teacher_comment(term, session, student_id, class_id, pagetype) {
//     // alert(class_id)
//     // return
//     if ($("#report_page").val() === 'report_scores') {
//         pagetype = 'report'
//     }
//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: { 'action': 'get_comment', term, session, student_id, class_id, pagetype },
//         success: (data) => {
//             data = data.trim();
//             data = JSON.parse(data)
//             let datacount = data.length;
//             // alert(noofdata)
//             data.map((item) => {
//                 // if (item.comment != '') {
//                 if (pagetype != 'post') {
//                     if (item.role_type == '' || datacount == 1) {
//                         $("#theprincipal_comment").html('No comment')
//                         $("#theteacher_comment").html('No Comment')
//                         $("#thereportteacher_comment12").html('No Comment')
//                         $("#theprincipalreportteacher_comment12").html('No Comment')
//                         // alert(item.role_type)
//                     }
//                     // alert('some')
//                     if (item.role_type == 0) {
//                         $("#theteacher_comment").html(item.comment == '' ? 'No comment' : item.comment)
//                         $("#thereportteacher_comment12").html(item.comment == '' ? 'No comment' : item.comment)
//                     } else if (item.role_type == 1) {
//                         $("#theprincipal_comment").html(item.comment == '' ? 'No comment' : item.comment)
//                         $("#theprincipalreportteacher_comment12").html(item.comment == '' ? 'No comment' : item.comment)
//                     }
//                     //  else if (item.role_type == '') {
//                     //     alert('lk')
//                     //     $("#theprincipal_comment").html('')
//                     // }
//                     // }
//                 } else {
//                     // if(class_id == item.staff_classId && item.role_type == 0){
//                     //     $("#post_teacher_comment_container").show()
//                     //     $("#post_teacher_comment_message").val(item.comment == '' ? 'No comment' : item.comment)
//                     // }
//                     // else{
//                     //     alert('k')
//                     //     $("#post_teacher_comment_container").hide()
//                     // }
//                     if (datacount == 1 || item.role_type == '') {
//                         $("#post_teacher_comment_message").val('')
//                         $("#post_principal_comment_message").val('')
//                         // alert('commen')
//                     }
//                     console.log(item.comment)
//                     $("#post_teacher_comment_message").html("item.comment")
//                     if ((item.staff_classId).includes(class_id)) {
//                         $("#post_teacher_comment_container").show()
//                         if (item.role_type === '0') {
//                             // alert('commen teaher')
//                             $("#post_teacher_comment_message").val(item.comment)
//                         }
//                     } else {
//                         // alert('commen teaher here 2')
//                         $("#post_teacher_comment_container").hide()
//                     }
//                     if (item.staff_type == '2' || item.staff_type == '3' || item.staff_type == '4') { //if principal
//                         if (item.role_type === "1") {
//                             if ($("#post_teacher_comment_message").val() == '') {

//                             }
//                             $("#post_principal_comment_message").val(item.comment)
//                             // alert('commen teaher here 3')
//                         }
//                     }
//                 }


//             })
//             // if (data == 0) {
//             //     // $("#post_teacher_comment_container").show()
//             //     $("#thereportteacher_comment12").html('No comment')
//             //     $("#theprincipalreportteacher_comment12").html('No comment')
//             //     return
//             // }
//             // data.map((item) => {
//             //     console.log('coment', item.comment)
//             //     if (item.role_type == '0') {
//             //         if (item.staff_classId == class_id && pagetype == 'post') {
//             //             $("#post_teacher_comment_container").show()
//             //             $("#post_teacher_comment_message").val(item.role_type = '0' ? item.comment : '')
//             //         }
//             //         else {
//             //             $("#post_teacher_comment_container").hide()
//             //             $("#thereportteacher_comment12").html(item.comment != '' ? item.comment : 'No comment')
//             //             $("#theteacher_comment").html(item.comment != '' ? item.comment : 'No comment')
//             //             $("#thereportteacher_comment").html(item.comment)
//             //         }
//             //     }
//             //     else {
//             //         $("#post_principal_comment_message").val(item.comment)
//             //         // $("#thereportteacher_comment12").html(item.comment != '' ? item.comment : 'No comment')
//             //         $("#theprincipalreportteacher_comment12").html(item.comment != '' ? item.comment : 'No comment')
//             //     }

//             // })
//             // return
//             // if (data == '') {
//             //     console.log('empty data but have access')
//             //     $("#post_teacher_comment_container").show()
//             // }
//             // else if (data == '0') {
//             //     console.log("restricted no access")
//             //     $("#post_teacher_comment_container").hide()
//             // }
//             // else {
//             //     console.log("access granted fully")
//             //     $("#post_teacher_comment_container").show()
//             // }
//             // return
//             // if (data == 'no') {
//             //     $("#view_teacher_comment_container").hide()
//             //     $("#report_teacher_comment_container").hide()
//             //     $("#post_teacher_comment_container").hide()
//             // } else {
//             //     $("#report_teacher_comment_container").show()
//             //     $("#view_teacher_comment_container").show()
//             //     if (pagetype == 'post') {
//             //         alert('ll')
//             //         $("#post_teacher_comment_container").show()
//             //         $("#post_teacher_comment_message").val(data)
//             //     }
//             //     else if (pagetype == 'view') {
//             //         $("#theteacher_comment").html(data)
//             //     }
//             //     else if (pagetype == 'report') {
//             //         $("#thereportteacher_comment").html(data)
//             //     }
//             // }
//         }
//     })
// }
function get_teacher_comment(term, session, student_id, class_id, pagetype) {
    // alert(class_id)
    // return
    if ($("#report_page").val() === 'report_scores') {
        pagetype = 'report'
    }
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: { 'action': 'get_comment', term, session, student_id, class_id, pagetype },
        success: (data) => {
            data = data.trim();
            data = JSON.parse(data)
            let datacount = data.length;
            const shouldShowComments = !(data.length > 0 && data[0].show_comment_sections === false);
            $("#view_teacher_comment_container, #view_principal_comment_container").toggle(shouldShowComments);
            $("#report_teacher_comment_container").toggle(shouldShowComments);
            // alert(noofdata)
            data.map((item) => {
                // if (item.comment != '') {
                if (pagetype != 'post') {
                    if (item.role_type == '' || datacount == 1) {
                        $("#theprincipal_comment").html('No comment')
                        $("#theteacher_comment").html('No Comment')
                        $("#thereportteacher_comment12").html('No Comment')
                        $("#theprincipalreportteacher_comment12").html('No Comment')
                        // alert(item.role_type)
                    }
                    // alert('some')
                    if (item.role_type == 0) {
                        $("#theteacher_comment").html(item.comment == '' ? 'No comment' : item.comment)
                        $("#thereportteacher_comment12").html(item.comment == '' ? 'No comment' : item.comment)
                    } else if (item.role_type == 1) {
                        $("#theprincipal_comment").html(item.comment == '' ? 'No comment' : item.comment)
                        $("#theprincipalreportteacher_comment12").html(item.comment == '' ? 'No comment' : item.comment)
                    }
                    //  else if (item.role_type == '') {
                    //     alert('lk')
                    //     $("#theprincipal_comment").html('')
                    // }
                    // }
                } else {
                    // if(class_id == item.staff_classId && item.role_type == 0){
                    //     $("#post_teacher_comment_container").show()
                    //     $("#post_teacher_comment_message").val(item.comment == '' ? 'No comment' : item.comment)
                    // }
                    // else{
                    //     alert('k')
                    //     $("#post_teacher_comment_container").hide()
                    // }
                    if (datacount == 1 || item.role_type == '') {
                        $("#post_teacher_comment_message").val('')
                        $("#post_principal_comment_message").val('')
                        // alert('commen')
                    }
                    console.log(item.comment)
                    $("#post_teacher_comment_message").html("item.comment")
                    if ((item.staff_classId).includes(class_id)) {
                        $("#post_teacher_comment_container").show()
                        if (item.role_type === '0') {
                            // alert('commen teaher')
                            $("#post_teacher_comment_message").val(item.comment)
                        }
                    } else {
                        // alert('commen teaher here 2')
                        $("#post_teacher_comment_container").hide()
                    }
                    if (item.staff_type == '2' || item.staff_type == '3' || item.staff_type == '4') { //if principal
                        if (item.role_type === "1") {
                            if ($("#post_teacher_comment_message").val() == '') {

                            }
                            $("#post_principal_comment_message").val(item.comment)
                            // alert('commen teaher here 3')
                        }
                    }
                }


            })
            // if (data == 0) {
            //     // $("#post_teacher_comment_container").show()
            //     $("#thereportteacher_comment12").html('No comment')
            //     $("#theprincipalreportteacher_comment12").html('No comment')
            //     return
            // }
            // data.map((item) => {
            //     console.log('coment', item.comment)
            //     if (item.role_type == '0') {
            //         if (item.staff_classId == class_id && pagetype == 'post') {
            //             $("#post_teacher_comment_container").show()
            //             $("#post_teacher_comment_message").val(item.role_type = '0' ? item.comment : '')
            //         }
            //         else {
            //             $("#post_teacher_comment_container").hide()
            //             $("#thereportteacher_comment12").html(item.comment != '' ? item.comment : 'No comment')
            //             $("#theteacher_comment").html(item.comment != '' ? item.comment : 'No comment')
            //             $("#thereportteacher_comment").html(item.comment)
            //         }
            //     }
            //     else {
            //         $("#post_principal_comment_message").val(item.comment)
            //         // $("#thereportteacher_comment12").html(item.comment != '' ? item.comment : 'No comment')
            //         $("#theprincipalreportteacher_comment12").html(item.comment != '' ? item.comment : 'No comment')
            //     }

            // })
            // return
            // if (data == '') {
            //     console.log('empty data but have access')
            //     $("#post_teacher_comment_container").show()
            // }
            // else if (data == '0') {
            //     console.log("restricted no access")
            //     $("#post_teacher_comment_container").hide()
            // }
            // else {
            //     console.log("access granted fully")
            //     $("#post_teacher_comment_container").show()
            // }
            // return
            // if (data == 'no') {
            //     $("#view_teacher_comment_container").hide()
            //     $("#report_teacher_comment_container").hide()
            //     $("#post_teacher_comment_container").hide()
            // } else {
            //     $("#report_teacher_comment_container").show()
            //     $("#view_teacher_comment_container").show()
            //     if (pagetype == 'post') {
            //         alert('ll')
            //         $("#post_teacher_comment_container").show()
            //         $("#post_teacher_comment_message").val(data)
            //     }
            //     else if (pagetype == 'view') {
            //         $("#theteacher_comment").html(data)
            //     }
            //     else if (pagetype == 'report') {
            //         $("#thereportteacher_comment").html(data)
            //     }
            // }
        }
    })
}
// alert('lk')
var approval_data;
function loadApproval() {
    const term_id = $(".select_btn.term.active").attr("data-name");
    const class_id = $("#select_class_field").val();
    const session_id = $("#select_session_field").val();
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: { 'action': 'get_approval', class_id, term_id, session_id, },
        cache: true,
        success: (data) => {
            data = JSON.parse(data)
            approval_data = data[0];
        }
    })
}
// async function post_table_data(filtertype, viewOrPostPage) {
//     // alert('kk')
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     // alert(termValue)
//     // return
//     const classValue = $("#select_class_field").val();
//     const sessionValue = $("#select_session_field").val();
//     if ($("#by_subj_btn").hasClass("active") && (!classValue || !($("#select_subject_field").val()))) {
//         $(".data_overlay").html(`
//             <p class="font-weight-bold">Fill the form appropiately</p>
//         `).show()
//         $(".thecontentbox").hide()
//         return
//     }
//     if ($("#by_stud_btn").hasClass("active") && (!classValue || !($("#select_student_field").val()))) {
//         $(".data_overlay").html(`
//             <p class="font-weight-bold">Fill the form appropiately</p>
//         `).show()
//         $(".thecontentbox").hide()
//         return
//     }


//     $(".comment_term").val(termValue)
//     $(".comment_Session").val(sessionValue)
//     $(".comment_class").val(classValue)

//     let arrayValues = '';
//     let postdata = {};
//     let hideshowtotals = ''
//     if (filtertype === 'student') {
//         hideshowtotals = '';
//         try {
//             await getsubjects(classValue, null)
//         }
//         catch (error) {
//             return
//         }
//         const studentValue = $("#select_student_field").val();
//         $(".student_id_for_comment").val(studentValue)
//         $("#post_principal_comment_container").show()
//         arrayValues = subjects;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             studentValue,
//             sessionValue
//         };
//         // alert('k')
//         setTimeout(get_teacher_comment(termValue, sessionValue, studentValue, classValue, 'post'), 200);
//         setTimeout(set_behaviour_comment(termValue, sessionValue, studentValue, classValue, 'post'), 200);
//         if (!$("#select_student_field").val()) {
//             $("#select_student_warning").show()
//             return
//         }
//         else {
//             $("#select_student_warning").hide()
//         }
//         // $("#post_table_title").html(`${$("#select_session_field option:selected").html() + ' ' + $(".select_btn.term.active").html() + ' scores for ' + $("#select_student_field option:selected").html() + ' in ' + $("#select_class_field option:Selected").html()}`)
//         // $("#post_teacher_comment_container").show()
//     } else {
//         hideshowtotals = 'd-none';
//         const subjectValue = $("#select_subject_field").val();
//         try {
//             await getsubjects(classValue)
//         }
//         catch (error) {
//             $("#subject_student_container").html('<h3>No Data to show</h3>')
//             return
//         }

//         arrayValues = students;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             subjectValue,
//             sessionValue
//         };
//         // alert("here")
//         $("#post_principal_comment_container").hide()
//         // $("#post_table_title").html(`${$("#select_session_field option:selected").html() + ' ' + $(".select_btn.term.active").html() + ' ' + $("#select_subject_field option:Selected").html() + ' scores for students in ' + $("#select_class_field option:selected").html()}`)
//         $("#post_teacher_comment_container").hide()
//         $("#post_teacher_comment_gb_container").hide()
//     }

//     console.log("arrayValues", arrayValues);
//     console.log("postdata", postdata);
//     // alert("viewOrPostPage")
//     let tableHtml = '';


//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: postdata,
//         beforeSend: () => {
//             $(".data_overlay").html(`
//                 <p class="font-weight-bold">Loading...</p>
//             `)
//             $(".thecontentbox").hide()
//             $(".data_overlay").show()
//         },
//         success: (data) => {
//             $(".thecontentbox").show()
//             $(".data_overlay").hide()
//             $(".data_overlay").html(`
//                 <p class="font-weight-bold">Fill the forms appropiately</p>
//             `)
//             data = data.trim();
//             let response = JSON.parse(data);
//             let scores = response.scores;
//             console.log("scores", scores);
//             console.log("aproval", approval_data);


//             if ($("#by_all").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'Student' ? 'Subjects' : 'Students'}</th>
//                             ${settingsData.ca1 == 1 ? `<th>CA1</th>` : ''}
//                             ${settingsData.ca1 == 1 ? `<th class="d-non ${hideshowtotals}">CA1Total</th>` : ''}
//                             ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
//                             ${settingsData.ca2 == 1 ? `<th class="d-non ${hideshowtotals}">CA2Total</th>` : ''}
//                             ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
//                             ${settingsData.ca3 == 1 ? `<th class="d-non ${hideshowtotals}">CA3Total</th>` : ''}
//                             ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
//                             ${settingsData.pra == 1 ? `<th class="d-non ${hideshowtotals}">PracticalTotal</th>` : ''}
//                             ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
//                             ${settingsData.exa == 1 ? `<th class="d-non ${hideshowtotals}">ExamTotal</th>` : ''}
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     <tr class="${filtertype === 'student' ? 'd-none' : ''}">
//                         <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
//                         ${settingsData.ca1 == 1 ? `<td><input type="number" class="w-xs-60 assess_input ca1total" ${approval_data.ca1 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca1total')" value="${scores.length > 0 ? scores[0].ca1Total || '' : ''}" /></td>` : ''}
//                         ${settingsData.ca1 == 1 ? `<td class="d-non ${hideshowtotals}"><input type="number" class="w-xs-60 assess_input ca1total" ${approval_data.ca1 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca1total')" value="${scores.length > 0 ? scores[0].ca1Total || '' : ''}" /></td>` : ''}
//                         ${settingsData.ca2 == 1 ? `<td><input type="number" class="w-xs-60 assess_input ca2total" onchange="updatehiddentotals(this,'ca2total')" ${approval_data.ca2 == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].ca2Total || '' : ''}" /></td>` : ''}
//                         ${settingsData.ca2 == 1 ? `<td class="d-non ${hideshowtotals}"><input type="number" class="w-xs-60 assess_input ca2total" ${approval_data.ca2 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca2total')" value="${scores.length > 0 ? scores[0].ca2Total || '' : ''}" /></td>` : ''}
//                         ${settingsData.ca3 == 1 ? `<td><input type="number" class="w-xs-60 assess_input ca3total" onchange="updatehiddentotals(this,'ca3total')" ${approval_data.ca3 == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].ca3Total || '' : ''}" /></td>` : ''}
//                         ${settingsData.ca3 == 1 ? `<td class="d-non ${hideshowtotals}"><input type="number" class="w-xs-60 assess_input ca3total" onchange="updatehiddentotals(this,'ca3total')" ${approval_data.ca3 == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].ca3Total || '' : ''}" /></td>` : ''}
//                         ${settingsData.pra == 1 ? `<td><input type="number" class="w-xs-60 assess_input pratotal" onchange="updatehiddentotals(this,'pratotal')" ${approval_data.practical == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].praTotal || '' : ''}" /></td>` : ''}
//                         ${settingsData.pra == 1 ? `<td class="d-non ${hideshowtotals}"><input type="number" class="w-xs-60 assess_input pratotal" onchange="updatehiddentotals(this,'pratotal')" ${approval_data.practical == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].praTotal || '' : ''}" /></td>` : ''}
//                         ${settingsData.exa == 1 ? `<td><input type="number"  class="w-xs-60 assess_input exatotal" onchange="updatehiddentotals(this,'exatotal')" ${approval_data.exam == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].examTotal || '' : ''}" /></td>` : ''}
//                         ${settingsData.exa == 1 ? `<td class="d-non ${hideshowtotals}"><input type="number"  class="w-xs-60 assess_input exatotal" onchange="updatehiddentotals(this,'exatotal')" ${approval_data.exam == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].examTotal || '' : ''}" /></td>` : ''}
//                     </tr>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : `<a href="students?id=${arrayValue.id}">${arrayValue.name}</a>`;


//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);

//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>

//                             ${settingsData.ca1 == 1 ? `<td><input class="w-xs-60 assess_input ca1Total" type="number" ${approval_data.ca1 == '1' ? 'disabled' : ''} value="${score.ca1 || ''}"></td>` : ''}
//                             ${settingsData.ca1 == 1 ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca1total" type="number" ${approval_data.ca1 == '1' ? 'disabled' : ''} value="${score.ca1Total || ''}"></td>` : ''}
//                             ${settingsData.ca2 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.ca2 == '1' ? 'disabled' : ''} value="${score.ca2 || ''}"></td>` : ''}
//                             ${settingsData.ca2 == 1 ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca2total" type="number" ${approval_data.ca2 == '1' ? 'disabled' : ''} value="${score.ca2Total || ''}"></td>` : ''}
//                             ${settingsData.ca3 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.ca2 == '1' ? 'disabled' : ''} value="${score.ca3 || ''}"></td>` : ''}
//                             ${settingsData.ca3 == 1 ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca3total" ${approval_data.ca3 == '1' ? 'disabled' : ''} type="number" value="${score.ca3Total || ''}"></td>` : ''}
//                             ${settingsData.pra == 1 ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.ca3 == '1' ? 'disabled' : ''} value="${score.pra || ''}"></td>` : ''}
//                             ${settingsData.pra == 1 ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input pratotal" ${approval_data.practical == '1' ? 'disabled' : ''} type="number" value="${score.praTotal || ''}"></td>` : ''}
//                             ${settingsData.exa == 1 ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.exam == '1' ? 'disabled' : ''} value="${score.exam || ''}"></td>` : ''}
//                             ${settingsData.exa == 1 ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input exatotal" ${approval_data.exam == '1' ? 'disabled' : ''} type="number" value="${score.examTotal || ''}"></td>` : ''}
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             } else if ($("#by_ca1").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             <th>CA1</th>
//                             <th class="d-non ${hideshowtotals}">CA1 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     <tr class="${filtertype === 'student' ? 'd-none' : ''}">
//                         <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
//                         <td><input type="number" class="w-xs-60 assess_input" ${approval_data.ca1 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca1total')" value="${scores.length > 0 ? scores[0].ca1Total || '' : ''}" /></td>
//                         <td class="d-non ${hideshowtotals}"><input type="number" ${approval_data.ca1 == '1' ? 'disabled' : ''} class="assess_input ca1total" value="${scores.length > 0 ? scores[0].ca1Total || '' : ''}" /></td>
//                     </tr>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : `<a href="students?id=${arrayValue.id}">${arrayValue.name}</a>`;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.ca1 == '1' ? 'disabled' : ''} value="${score.ca1 || ''}"></td>` : `<td>${score.ca1 || ''}</td>`}
//                             ${viewOrPostPage === 'post' ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca1total" ${approval_data.ca1 == '1' ? 'disabled' : ''} type="number" value="${score.ca1Total || ''}"></td>` : `<td>${score.ca1Total || ''}</td>`}
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_ca2").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             <th>CA2</th>
//                             <th class="d-non ${hideshowtotals}">CA2 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     <tr class="${filtertype === 'student' ? 'd-none' : ''}">
//                         <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
//                         <td><input type="number" class="w-xs-60 assess_input" ${approval_data.ca2 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca2total')" value="${scores.length > 0 ? scores[0].ca2Total || '' : ''}" /></td>
//                         <td class="d-non ${hideshowtotals}"><input type="number" ${approval_data.ca2 == '1' ? 'disabled' : ''} class="assess_input ca2total" value="${scores.length > 0 ? scores[0].ca2Total || '' : ''}" /></td>
//                     </tr>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : `<a href="students?id=${arrayValue.id}">${arrayValue.name}</a>`;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.ca2 == '1' ? 'disabled' : ''} value="${score.ca2 || ''}"></td>` : `<td>${score.ca2 || ''}</td>`}
//                             ${viewOrPostPage === 'post' ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca2total" ${approval_data.ca2 == '1' ? 'disabled' : ''} type="number" value="${score.ca2Total || ''}"></td>` : `<td>${score.ca2Total || ''}</td>`}
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_ca3").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             <th>CA3</th>
//                             <th class="d-non ${hideshowtotals}">CA3 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     <tr class="${filtertype === 'student' ? 'd-none' : ''}">
//                         <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
//                         <td><input type="number" class="w-xs-60 assess_input" ${approval_data.ca3 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca3total')" value="${scores.length > 0 ? scores[0].ca3Total || '' : ''}" /></td>
//                         <td class="d-non ${hideshowtotals}"><input type="number" ${approval_data.ca3 == '1' ? 'disabled' : ''} class="assess_input ca3total" value="${scores.length > 0 ? scores[0].ca3Total || '' : ''}" /></td>
//                     </tr>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : `<a href="students?id=${arrayValue.id}">${arrayValue.name}</a>`;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" ${approval_data.ca3 == '1' ? 'disabled' : ''} type="number" value="${score.ca3 || ''}"></td>` : `<td>${score.ca3 || ''}</td>`}
//                             ${viewOrPostPage === 'post' ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca3total" ${approval_data.ca3 == '1' ? 'disabled' : ''} type="number" value="${score.ca3Total || ''}"></td>` : `<td>${score.ca3Total || ''}</td>`}
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_pra").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             <th>Practical</th>
//                             <th class="d-non ${hideshowtotals}">Practical Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     <tr class="${filtertype === 'student' ? 'd-none' : ''}">
//                         <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
//                         <td><input type="number" class="w-xs-60 assess_input" ${approval_data.practical == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'pratotal')" value="${scores.length > 0 ? scores[0].praTotal || '' : ''}" /></td>
//                         <td class="d-non ${hideshowtotals}"><input type="number" ${approval_data.practical == '1' ? 'disabled' : ''} class="assess_input pratotal" value="${scores.length > 0 ? scores[0].praTotal || '' : ''}" /></td>
//                     </tr>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : `<a href="students?id=${arrayValue.id}">${arrayValue.name}</a>`;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" ${approval_data.pratical == '1' ? 'disabled' : ''} type="number" value="${score.pra || ''}"></td>` : `<td>${score.pra || ''}</td>`}
//                             ${viewOrPostPage === 'post' ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input pratotal" ${approval_data.practical == '1' ? 'disabled' : ''} type="number" value="${score.praTotal || ''}"></td>` : `<td>${score.ca3Total || ''}</td>`}
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             else if ($("#by_exam").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
//                             <th>Exam</th>
//                             <th class="d-non ${hideshowtotals}">Exam Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     <tr class="${filtertype === 'student' ? 'd-none' : ''}">
//                         <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
//                         <td><input type="number" class="w-xs-60 assess_input" ${approval_data.exam == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'exatotal')" value="${scores.length > 0 ? scores[0].examTotal || '' : ''}" /></td>
//                         <td class="d-non ${hideshowtotals}"><input type="number" class="assess_input exatotal" ${approval_data.exam == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].examTotal || '' : ''}" /></td>
//                     </tr>
//                     ${arrayValues.map((arrayValue) => {
//                     let nameToMatch = filtertype === 'student' ? arrayValue.subject : `<a href="students?id=${arrayValue.id}">${arrayValue.name}</a>`;
//                     let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                     console.log("Matching score for:", nameToMatch, score);
//                     return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.exam == '1' ? 'disabled' : ''} value="${score.exam || ''}"></td>` : `<td>${score.exa || ''}</td>`}
//                             ${viewOrPostPage === 'post' ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input exatotal" ${approval_data.exam == '1' ? 'disabled' : ''} type="number" value="${score.examTotal || ''}"></td>` : `<td>${score.exaTotal || ''}</td>`}
//                         </tr>`;
//                 }).join('')}
//                     </tbody>`;
//             }
//             // alert('l')

//             // Destroy existing DataTable instance
//             if ($.fn.DataTable.isDataTable('#post_score_table_by_student')) {
//                 $('#post_score_table_by_student').DataTable().destroy();
//             }
//             $('#post_score_table_by_student').html(tableHtml);

//             // Reinitialize DataTable
//             $('#post_score_table_by_student').DataTable({
//                 scrollX: true,
//                 paging: false,
//                 ordering: false,
//                 fixedColumns: {
//                     left: 1,
//                     right: 0
//                 }
//             });
//         }
//     });
// }
async function post_table_data(filtertype, viewOrPostPage) {
    // alert('kk')
    const termValue = $(".select_btn.term.active").attr("data-name");
    // alert(termValue)
    // return
    const classValue = $("#select_class_field").val();
    const sessionValue = $("#select_session_field").val();
    if ($("#by_subj_btn").hasClass("active") && (!classValue || !($("#select_subject_field").val()))) {
        $(".data_overlay").html(`
            <p class="font-weight-bold">Fill the form appropiately</p>
        `).show()
        $(".thecontentbox").hide()
        return
    }
    if ($("#by_stud_btn").hasClass("active") && (!classValue || !($("#select_student_field").val()))) {
        $(".data_overlay").html(`
            <p class="font-weight-bold">Fill the form appropiately</p>
        `).show()
        $(".thecontentbox").hide()
        return
    }


    $(".comment_term").val(termValue)
    $(".comment_Session").val(sessionValue)
    $(".comment_class").val(classValue)

    let arrayValues = '';
    let postdata = {};
    let hideshowtotals = ''
    if (filtertype === 'student') {
        hideshowtotals = '';
        try {
            await getsubjects(classValue, null)
        }
        catch (error) {
            return
        }
        const studentValue = $("#select_student_field").val();
        $(".student_id_for_comment").val(studentValue)
        $("#post_principal_comment_container").show()
        arrayValues = subjects;
        postdata = {
            action: 'get_scores',
            termValue,
            classValue,
            studentValue,
            sessionValue
        };
        // alert('k')
        setTimeout(get_teacher_comment(termValue, sessionValue, studentValue, classValue, 'post'), 200);
        setTimeout(set_behaviour_comment(termValue, sessionValue, studentValue, classValue, 'post'), 200);
        if (!$("#select_student_field").val()) {
            $("#select_student_warning").show()
            return
        }
        else {
            $("#select_student_warning").hide()
        }
        // $("#post_table_title").html(`${$("#select_session_field option:selected").html() + ' ' + $(".select_btn.term.active").html() + ' scores for ' + $("#select_student_field option:selected").html() + ' in ' + $("#select_class_field option:Selected").html()}`)
        // $("#post_teacher_comment_container").show()
    } else {
        hideshowtotals = 'd-none';
        const subjectValue = $("#select_subject_field").val();
        try {
            await getsubjects(classValue)
        }
        catch (error) {
            $("#subject_student_container").html('<h3>No Data to show</h3>')
            return
        }

        arrayValues = students;
        postdata = {
            action: 'get_scores',
            termValue,
            classValue,
            subjectValue,
            sessionValue
        };
        // alert("here")
        $("#post_principal_comment_container").hide()
        // $("#post_table_title").html(`${$("#select_session_field option:selected").html() + ' ' + $(".select_btn.term.active").html() + ' ' + $("#select_subject_field option:Selected").html() + ' scores for students in ' + $("#select_class_field option:selected").html()}`)
        $("#post_teacher_comment_container").hide()
        $("#post_teacher_comment_gb_container").hide()
    }

    console.log("arrayValues", arrayValues);
    console.log("postdata", postdata);
    // alert("viewOrPostPage")
    let tableHtml = '';


    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: postdata,
        beforeSend: () => {
            $(".data_overlay").html(`
                <p class="font-weight-bold">Loading...</p>
            `)
            $(".thecontentbox").hide()
            $(".data_overlay").show()
        },
        success: (data) => {
            $(".thecontentbox").show()
            $(".data_overlay").hide()
            $(".data_overlay").html(`
                <p class="font-weight-bold">Fill the forms appropiately</p>
            `)
            data = data.trim();
            let response = JSON.parse(data);
            let scores = response.scores;
            console.log("scores", scores);
            console.log("aproval", approval_data);


            if ($("#by_all").hasClass('active')) {
                tableHtml = `
                    <thead>
                        <tr>
                            <th>${filtertype === 'Student' ? 'Subjects' : 'Students'}</th>
                            ${settingsData.ca1 == 1 ? `<th>CA1</th>` : ''}
                            ${settingsData.ca1 == 1 ? `<th class="d-non ${hideshowtotals}">CA1Total</th>` : ''}
                            ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
                            ${settingsData.ca2 == 1 ? `<th class="d-non ${hideshowtotals}">CA2Total</th>` : ''}
                            ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
                            ${settingsData.ca3 == 1 ? `<th class="d-non ${hideshowtotals}">CA3Total</th>` : ''}
                            ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
                            ${settingsData.pra == 1 ? `<th class="d-non ${hideshowtotals}">PracticalTotal</th>` : ''}
                            ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
                            ${settingsData.exa == 1 ? `<th class="d-non ${hideshowtotals}">ExamTotal</th>` : ''}
                        </tr>
                    </thead>
                    <tbody id="tbody">
                    <tr class="${filtertype === 'student' ? 'd-none' : ''}">
                        <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
                        ${settingsData.ca1 == 1 ? `<td><input type="number" class="w-xs-60 assess_input ca1total" ${approval_data.ca1 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca1total')" value="${scores.length > 0 ? scores[0].ca1Total || '' : ''}" /></td>` : ''}
                        ${settingsData.ca1 == 1 ? `<td class="d-non ${hideshowtotals}"><input type="number" class="w-xs-60 assess_input ca1total" ${approval_data.ca1 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca1total')" value="${scores.length > 0 ? scores[0].ca1Total || '' : ''}" /></td>` : ''}
                        ${settingsData.ca2 == 1 ? `<td><input type="number" class="w-xs-60 assess_input ca2total" onchange="updatehiddentotals(this,'ca2total')" ${approval_data.ca2 == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].ca2Total || '' : ''}" /></td>` : ''}
                        ${settingsData.ca2 == 1 ? `<td class="d-non ${hideshowtotals}"><input type="number" class="w-xs-60 assess_input ca2total" ${approval_data.ca2 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca2total')" value="${scores.length > 0 ? scores[0].ca2Total || '' : ''}" /></td>` : ''}
                        ${settingsData.ca3 == 1 ? `<td><input type="number" class="w-xs-60 assess_input ca3total" onchange="updatehiddentotals(this,'ca3total')" ${approval_data.ca3 == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].ca3Total || '' : ''}" /></td>` : ''}
                        ${settingsData.ca3 == 1 ? `<td class="d-non ${hideshowtotals}"><input type="number" class="w-xs-60 assess_input ca3total" onchange="updatehiddentotals(this,'ca3total')" ${approval_data.ca3 == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].ca3Total || '' : ''}" /></td>` : ''}
                        ${settingsData.pra == 1 ? `<td><input type="number" class="w-xs-60 assess_input pratotal" onchange="updatehiddentotals(this,'pratotal')" ${approval_data.practical == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].praTotal || '' : ''}" /></td>` : ''}
                        ${settingsData.pra == 1 ? `<td class="d-non ${hideshowtotals}"><input type="number" class="w-xs-60 assess_input pratotal" onchange="updatehiddentotals(this,'pratotal')" ${approval_data.practical == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].praTotal || '' : ''}" /></td>` : ''}
                        ${settingsData.exa == 1 ? `<td><input type="number"  class="w-xs-60 assess_input exatotal" onchange="updatehiddentotals(this,'exatotal')" ${approval_data.exam == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].examTotal || '' : ''}" /></td>` : ''}
                        ${settingsData.exa == 1 ? `<td class="d-non ${hideshowtotals}"><input type="number"  class="w-xs-60 assess_input exatotal" onchange="updatehiddentotals(this,'exatotal')" ${approval_data.exam == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].examTotal || '' : ''}" /></td>` : ''}
                    </tr>
                    ${arrayValues.map((arrayValue) => {
                    let nameToMatch;
                    let thestudentnameorsubj;
                    // let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
                    if (filtertype === 'student') {
                        console.log('student')
                        nameToMatch = arrayValue.subject;
                        thestudentnameorsubj = nameToMatch;
                    } else {
                        console.log('subject now')
                        nameToMatch = arrayValue.name;
                        thestudentnameorsubj = `<a href="students?id=${arrayValue.id}">${nameToMatch}</a>`;
                    }

                    let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
                    console.log("Matching score for:", nameToMatch, score);

                    return `<tr>
                            <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${thestudentnameorsubj}</td>
                            
                            ${settingsData.ca1 == 1 ? `<td><input class="w-xs-60 assess_input ca1Total" type="number" ${approval_data.ca1 == '1' ? 'disabled' : ''} value="${score.ca1 || ''}"></td>` : ''}
                            ${settingsData.ca1 == 1 ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca1total" type="number" ${approval_data.ca1 == '1' ? 'disabled' : ''} value="${score.ca1Total || ''}"></td>` : ''}
                            ${settingsData.ca2 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.ca2 == '1' ? 'disabled' : ''} value="${score.ca2 || ''}"></td>` : ''}
                            ${settingsData.ca2 == 1 ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca2total" type="number" ${approval_data.ca2 == '1' ? 'disabled' : ''} value="${score.ca2Total || ''}"></td>` : ''}
                            ${settingsData.ca3 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.ca2 == '1' ? 'disabled' : ''} value="${score.ca3 || ''}"></td>` : ''}
                            ${settingsData.ca3 == 1 ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca3total" ${approval_data.ca3 == '1' ? 'disabled' : ''} type="number" value="${score.ca3Total || ''}"></td>` : ''}
                            ${settingsData.pra == 1 ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.ca3 == '1' ? 'disabled' : ''} value="${score.pra || ''}"></td>` : ''}
                            ${settingsData.pra == 1 ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input pratotal" ${approval_data.practical == '1' ? 'disabled' : ''} type="number" value="${score.praTotal || ''}"></td>` : ''}
                            ${settingsData.exa == 1 ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.exam == '1' ? 'disabled' : ''} value="${score.exam || ''}"></td>` : ''}
                            ${settingsData.exa == 1 ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input exatotal" ${approval_data.exam == '1' ? 'disabled' : ''} type="number" value="${score.examTotal || ''}"></td>` : ''}
                        </tr>`;
                }).join('')}
                    </tbody>`;
            } else if ($("#by_ca1").hasClass('active')) {
                tableHtml = `
                    <thead>
                        <tr>
                            <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
                            <th>CA1</th>
                            <th class="d-non ${hideshowtotals}">CA1 Total</th>
                        </tr>
                    </thead>
                    <tbody>
                    <tr class="${filtertype === 'student' ? 'd-none' : ''}">
                        <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
                        <td><input type="number" class="w-xs-60 assess_input" ${approval_data.ca1 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca1total')" value="${scores.length > 0 ? scores[0].ca1Total || '' : ''}" /></td>
                        <td class="d-non ${hideshowtotals}"><input type="number" ${approval_data.ca1 == '1' ? 'disabled' : ''} class="assess_input ca1total" value="${scores.length > 0 ? scores[0].ca1Total || '' : ''}" /></td>
                    </tr>
                    ${arrayValues.map((arrayValue) => {
                    let nameToMatch;
                    let thestudentnameorsubj;
                    // let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue;
                    if (filtertype === 'student') {
                        console.log('student')
                        nameToMatch = arrayValue.subject;
                        thestudentnameorsubj = nameToMatch;
                    } else {
                        console.log('subject now')
                        nameToMatch = arrayValue.name;
                        thestudentnameorsubj = `<a href="students?id=${arrayValue.id}">${nameToMatch}</a>`;
                    }
                    let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
                    console.log("Matching score for:", nameToMatch, score);
                    return `<tr>
                            <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${thestudentnameorsubj}</td>
                            ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.ca1 == '1' ? 'disabled' : ''} value="${score.ca1 || ''}"></td>` : `<td>${score.ca1 || ''}</td>`}
                            ${viewOrPostPage === 'post' ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca1total" ${approval_data.ca1 == '1' ? 'disabled' : ''} type="number" value="${score.ca1Total || ''}"></td>` : `<td>${score.ca1Total || ''}</td>`}
                        </tr>`;
                }).join('')}
                    </tbody>`;
            }
            else if ($("#by_ca2").hasClass('active')) {
                tableHtml = `
                    <thead>
                        <tr>
                            <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
                            <th>CA2</th>
                            <th class="d-non ${hideshowtotals}">CA2 Total</th>
                        </tr>
                    </thead>
                    <tbody>
                    <tr class="${filtertype === 'student' ? 'd-none' : ''}">
                        <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
                        <td><input type="number" class="w-xs-60 assess_input" ${approval_data.ca2 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca2total')" value="${scores.length > 0 ? scores[0].ca2Total || '' : ''}" /></td>
                        <td class="d-non ${hideshowtotals}"><input type="number" ${approval_data.ca2 == '1' ? 'disabled' : ''} class="assess_input ca2total" value="${scores.length > 0 ? scores[0].ca2Total || '' : ''}" /></td>
                    </tr>
                    ${arrayValues.map((arrayValue) => {
                    // let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
                    let nameToMatch;
                    let thestudentnameorsubj;
                    // let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue;
                    if (filtertype === 'student') {
                        console.log('student')
                        nameToMatch = arrayValue.subject;
                        thestudentnameorsubj = nameToMatch;
                    } else {
                        console.log('subject now')
                        nameToMatch = arrayValue.name;
                        thestudentnameorsubj = `<a href="students?id=${arrayValue.id}">${nameToMatch}</a>`;
                    }
                    let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
                    console.log("Matching score for:", nameToMatch, score);
                    return `<tr>
                            <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${thestudentnameorsubj}</td>
                            ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.ca2 == '1' ? 'disabled' : ''} value="${score.ca2 || ''}"></td>` : `<td>${score.ca2 || ''}</td>`}
                            ${viewOrPostPage === 'post' ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca2total" ${approval_data.ca2 == '1' ? 'disabled' : ''} type="number" value="${score.ca2Total || ''}"></td>` : `<td>${score.ca2Total || ''}</td>`}
                        </tr>`;
                }).join('')}
                    </tbody>`;
            }
            else if ($("#by_ca3").hasClass('active')) {
                tableHtml = `
                    <thead>
                        <tr>
                            <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
                            <th>CA3</th>
                            <th class="d-non ${hideshowtotals}">CA3 Total</th>
                        </tr>
                    </thead>
                    <tbody>
                    <tr class="${filtertype === 'student' ? 'd-none' : ''}">
                        <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
                        <td><input type="number" class="w-xs-60 assess_input" ${approval_data.ca3 == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'ca3total')" value="${scores.length > 0 ? scores[0].ca3Total || '' : ''}" /></td>
                        <td class="d-non ${hideshowtotals}"><input type="number" ${approval_data.ca3 == '1' ? 'disabled' : ''} class="assess_input ca3total" value="${scores.length > 0 ? scores[0].ca3Total || '' : ''}" /></td>
                    </tr>
                    ${arrayValues.map((arrayValue) => {
                    // let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
                    let nameToMatch;
                    let thestudentnameorsubj;
                    // let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue;
                    if (filtertype === 'student') {
                        console.log('student')
                        nameToMatch = arrayValue.subject;
                        thestudentnameorsubj = nameToMatch;
                    } else {
                        console.log('subject now')
                        nameToMatch = arrayValue.name;
                        thestudentnameorsubj = `<a href="students?id=${arrayValue.id}">${nameToMatch}</a>`;
                    }
                    let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
                    console.log("Matching score for:", nameToMatch, score);
                    return `<tr>
                            <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${thestudentnameorsubj}</td>
                            ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" ${approval_data.ca3 == '1' ? 'disabled' : ''} type="number" value="${score.ca3 || ''}"></td>` : `<td>${score.ca3 || ''}</td>`}
                            ${viewOrPostPage === 'post' ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input ca3total" ${approval_data.ca3 == '1' ? 'disabled' : ''} type="number" value="${score.ca3Total || ''}"></td>` : `<td>${score.ca3Total || ''}</td>`}
                        </tr>`;
                }).join('')}
                    </tbody>`;
            }
            else if ($("#by_pra").hasClass('active')) {
                tableHtml = `
                    <thead>
                        <tr>
                            <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
                            <th>Practical</th>
                            <th class="d-non ${hideshowtotals}">Practical Total</th>
                        </tr>
                    </thead>
                    <tbody>
                    <tr class="${filtertype === 'student' ? 'd-none' : ''}">
                        <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
                        <td><input type="number" class="w-xs-60 assess_input" ${approval_data.practical == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'pratotal')" value="${scores.length > 0 ? scores[0].praTotal || '' : ''}" /></td>
                        <td class="d-non ${hideshowtotals}"><input type="number" ${approval_data.practical == '1' ? 'disabled' : ''} class="assess_input pratotal" value="${scores.length > 0 ? scores[0].praTotal || '' : ''}" /></td>
                    </tr>
                    ${arrayValues.map((arrayValue) => {
                    // let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
                    let nameToMatch;
                    let thestudentnameorsubj;
                    // let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue;
                    if (filtertype === 'student') {
                        console.log('student')
                        nameToMatch = arrayValue.subject;
                        thestudentnameorsubj = nameToMatch;
                    } else {
                        console.log('subject now')
                        nameToMatch = arrayValue.name;
                        thestudentnameorsubj = `<a href="students?id=${arrayValue.id}">${nameToMatch}</a>`;
                    }
                    let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
                    console.log("Matching score for:", nameToMatch, score);
                    return `<tr>
                            <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${thestudentnameorsubj}</td>
                            ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" ${approval_data.pratical == '1' ? 'disabled' : ''} type="number" value="${score.pra || ''}"></td>` : `<td>${score.pra || ''}</td>`}
                            ${viewOrPostPage === 'post' ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input pratotal" ${approval_data.practical == '1' ? 'disabled' : ''} type="number" value="${score.praTotal || ''}"></td>` : `<td>${score.ca3Total || ''}</td>`}
                        </tr>`;
                }).join('')}
                    </tbody>`;
            }
            else if ($("#by_exam").hasClass('active')) {
                tableHtml = `
                    <thead>
                        <tr>
                            <th>${filtertype === 'student' ? 'Subjects' : 'Students'}</th>
                            <th>Exam</th>
                            <th class="d-non ${hideshowtotals}">Exam Total</th>
                        </tr>
                    </thead>
                    <tbody>
                    <tr class="${filtertype === 'student' ? 'd-none' : ''}">
                        <td class="font-xs-16 assess_subject" data-id="NAN">Total</td>
                        <td><input type="number" class="w-xs-60 assess_input" ${approval_data.exam == '1' ? 'disabled' : ''} onchange="updatehiddentotals(this,'exatotal')" value="${scores.length > 0 ? scores[0].examTotal || '' : ''}" /></td>
                        <td class="d-non ${hideshowtotals}"><input type="number" class="assess_input exatotal" ${approval_data.exam == '1' ? 'disabled' : ''} value="${scores.length > 0 ? scores[0].examTotal || '' : ''}" /></td>
                    </tr>
                    ${arrayValues.map((arrayValue) => {
                    // let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
                    let nameToMatch;
                    let thestudentnameorsubj;
                    // let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue;
                    if (filtertype === 'student') {
                        console.log('student')
                        nameToMatch = arrayValue.subject;
                        thestudentnameorsubj = nameToMatch;
                    } else {
                        console.log('subject now')
                        nameToMatch = arrayValue.name;
                        thestudentnameorsubj = `<a href="students?id=${arrayValue.id}">${nameToMatch}</a>`;
                    }
                    let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
                    console.log("Matching score for:", nameToMatch, score);
                    return `<tr>
                            <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${thestudentnameorsubj}</td>
                            ${viewOrPostPage === 'post' ? `<td><input class="w-xs-60 assess_input" type="number" ${approval_data.exam == '1' ? 'disabled' : ''} value="${score.exam || ''}"></td>` : `<td>${score.exa || ''}</td>`}
                            ${viewOrPostPage === 'post' ? `<td class="d-non ${hideshowtotals}"><input class="w-xs-60 assess_input exatotal" ${approval_data.exam == '1' ? 'disabled' : ''} type="number" value="${score.examTotal || ''}"></td>` : `<td>${score.exaTotal || ''}</td>`}
                        </tr>`;
                }).join('')}
                    </tbody>`;
            }
            // alert('l')

            // Destroy existing DataTable instance
            if ($.fn.DataTable.isDataTable('#post_score_table_by_student')) {
                $('#post_score_table_by_student').DataTable().destroy();
            }
            $('#post_score_table_by_student').html(tableHtml);

            // Reinitialize DataTable
            $('#post_score_table_by_student').DataTable({
                scrollX: true,
                paging: false,
                ordering: false,
                fixedColumns: {
                    left: 1,
                    right: 0
                }
            });
        }
    });
}
// alert('lk')
function display_table(filtertype) {
    if (!filtertype) {
        filtertype = filtertypesaved;
    } else {
        filtertypesaved = filtertype;
    }

    if ($("#scores_page").val() === 'view_scores') {
        viewOrPostPage = 'view'
        view_table_data(filtertype, viewOrPostPage)
    }
    if ($("#scores_page").val() === 'post_scores') {
        viewOrPostPage = 'post'
        // getstudents($("#select_class_field").val())
        setTimeout(() => {
            loadApproval()
            setTimeout(() => {
                post_table_data(filtertype, viewOrPostPage)
            }, 200);
        }, 200)
    }
    if ($("#report_page").val() === 'report_scores') {
        viewOrPostPage = 'view'
        // alert('kkkk')
        report_table_data(filtertype, viewOrPostPage)
    }

}




// alert('kj')
// function display_table(filtertype) {
//     if (!filtertype) {
//         filtertype = filtertypesaved;
//     } else {
//         filtertypesaved = filtertype;
//     }

//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     let arrayValues = '';
//     let postdata = {};

//     if (filtertype === 'student') {
//         arrayValues = subjects;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             studentValue,
//             sessionValue
//         };
//     } else {
//         arrayValues = students;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             subjectValue,
//             sessionValue
//         };
//     }

//     console.log("arrayValues", arrayValues);
//     console.log("postdata", postdata);

//     let tableHtml = '';

//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: postdata,
//         success: (data) => {
//             data = data.trim();
//             let scores = JSON.parse(data);
//             console.log("scores", scores);

//             if ($("#by_all").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             ${settingsData.ca1 == 1 ? `<th>CA1</th>` : ''}
//                             ${settingsData.ca1 == 1 ? `<th>CA1 Total</th>` : ''}
//                             ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
//                             ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
//                             ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
//                             ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
//                         </tr>

//                     </thead>
//                     <tbody id="tbody">
//                     ${arrayValues.map((arrayValue) => {
//                         let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                         let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                         console.log("Matching score for:", nameToMatch, score);
//                         return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${settingsData.ca1 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca1 || ''}"></td>` : ''}
//                             ${settingsData.ca1 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca1Total || ''}"></td>` : ''}
//                             ${settingsData.ca2 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca2 || ''}"></td>` : ''}
//                             ${settingsData.ca3 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca3 || ''}"></td>` : ''}
//                             ${settingsData.pra == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.pra || ''}"></td>` : ''}
//                             ${settingsData.exa == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.exa || ''}"></td>` : ''}
//                         </tr>`;
//                     }).join('')}
//                     </tbody>`;
//             } else if ($("#by_ca1").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>CA1</th>
//                             <th>Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                         let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                         let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                         console.log("Matching score for:", nameToMatch, score);
//                         return `<tr>
//                             <td class="font-xs-16 assess_subject">${nameToMatch}</td>
//                             <td><input class="w-xs-60 assess_input" type="number" value="${score.ca1 || ''}"></td>
//                             <td><input class="w-xs-60 assess_total" type="number" value="${score.ca1Total || ''}"></td>
//                         </tr>`;
//                     }).join('')}
//                     </tbody>`;
//             }

//             // Destroy existing DataTable instance
//             if ($.fn.DataTable.isDataTable('#post_score_table_by_student')) {
//                 $('#post_score_table_by_student').DataTable().destroy();
//             }
//             $('#post_score_table_by_student').html(tableHtml);

//             // Reinitialize DataTable
//             $('#post_score_table_by_student').DataTable({
//                 scrollX: true,
//                 paging: false,
//                 ordering: false,
//                 fixedColumns: {
//                     left: 1,
//                     right: 0
//                 }
//             });
//         }
//     });
// }


// alert('iop')
// function display_table(filtertype) {
//     if (!filtertype) {
//         filtertype = filtertypesaved;
//     } else {
//         filtertypesaved = filtertype;
//     }

//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     let arrayValues = '';
//     let postdata = {};

//     if (filtertype === 'student') {
//         arrayValues = subjects;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             studentValue,
//             sessionValue
//         };
//     } else {
//         arrayValues = students;
//         postdata = {
//             action: 'get_scores',
//             termValue,
//             classValue,
//             subjectValue,
//             sessionValue
//         };
//     }

//     console.log("arrayValues", arrayValues);
//     console.log("postdata", postdata);

//     let tableHtml = '';

//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: postdata,
//         success: (data) => {
//             data = data.trim();
//             let scores = JSON.parse(data);
//             console.log("scores", scores);

//             if ($("#by_all").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             ${settingsData.ca1 == 1 ? `<th>CA1</th>` : ''}
//                             ${settingsData.ca1 == 1 ? `<th>CA1 Total</th>` : ''}
//                             ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
//                             ${settingsData.ca2 == 1 ? `<th>CA2 Total</th>` : ''}
//                             ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
//                             ${settingsData.ca3 == 1 ? `<th>CA3 Total</th>` : ''}
//                             ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
//                             ${settingsData.pra == 1 ? `<th>Practical Total</th>` : ''}
//                             ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
//                             ${settingsData.exa == 1 ? `<th>Exam Total</th>` : ''}
//                         </tr>
//                     </thead>
//                     <tbody id="tbody">
//                     ${arrayValues.map((arrayValue) => {
//                         let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                         let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                         console.log("Matching score for:", nameToMatch, score);
//                         return `<tr>
//                             <td class="font-xs-16 assess_subject" data-id=${arrayValue.id}>${nameToMatch}</td>
//                             ${settingsData.ca1 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca1 || ''}"></td>` : ''}
//                             ${settingsData.ca1 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca1Total || ''}"></td>` : ''}
//                             ${settingsData.ca2 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca2 || ''}"></td>` : ''}
//                             ${settingsData.ca2 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca2Total || ''}"></td>` : ''}
//                             ${settingsData.ca3 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca3 || ''}"></td>` : ''}
//                             ${settingsData.ca3 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca3Total || ''}"></td>` : ''}
//                             ${settingsData.pra == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.pra || ''}"></td>` : ''}
//                             ${settingsData.pra == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.praTotal || ''}"></td>` : ''}
//                             ${settingsData.exa == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.exa || ''}"></td>` : ''}
//                             ${settingsData.exa == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.exaTotal || ''}"></td>` : ''}
//                         </tr>`;
//                     }).join('')}
//                     </tbody>`;
//             } else if ($("#by_ca1").hasClass('active')) {
//                 tableHtml = `
//                     <thead>
//                         <tr>
//                             <th>${filtertype === 'student' ? 'Subject' : 'Student'}</th>
//                             <th>CA1</th>
//                             <th>CA1 Total</th>
//                         </tr>
//                     </thead>
//                     <tbody>
//                     ${arrayValues.map((arrayValue) => {
//                         let nameToMatch = filtertype === 'student' ? arrayValue.subject : arrayValue.name;
//                         let score = scores.find(s => s.subjectsOrNames.trim() === nameToMatch.trim()) || {};
//                         console.log("Matching score for:", nameToMatch, score);
//                         return `<tr>
//                             <td class="font-xs-16 assess_subject">${nameToMatch}</td>
//                             <td><input class="w-xs-60 assess_input" type="number" value="${score.ca1 || ''}"></td>
//                             <td><input class="w-xs-60 assess_total" type="number" value="${score.ca1Total || ''}"></td>
//                         </tr>`;
//                     }).join('')}
//                     </tbody>`;
//             }

//             // Destroy existing DataTable instance
//             if ($.fn.DataTable.isDataTable('#post_score_table_by_student')) {
//                 $('#post_score_table_by_student').DataTable().destroy();
//             }
//             $('#post_score_table_by_student').html(tableHtml);

//             // Reinitialize DataTable
//             $('#post_score_table_by_student').DataTable({
//                 scrollX: true,
//                 paging: false,
//                 ordering: false,
//                 fixedColumns: {
//                     left: 1,
//                     right: 0
//                 }
//             });
//         }
//     });
// }

// getsubjects()
// function display_table(filtertype) {
//     console.log(filtertype)
//     const termValue = $(".select_btn.term.active").attr("data-name")
//     const classValue = $("#select_class_field").val()
//     const studentValue = $("#select_student_field").val()
//     const subjectValue = $("#select_subject_field").val()
//     const sessionValue = $("#select_session_field").val()
//     let tableHtml = '';
//     if ($("#by_all").hasClass('active')) {
//         let postdata;
//         if (filtertype === 'by_subj_btn') {
//             postdata = {
//                 "action":"get_scores",
//                 termValue,
//                 classValue,
//                 subjectValue,
//                 sessionValue
//             }
//         }
//         $.ajax({
//             url: '../controller.php',
//             type: 'POST',
//             data: {
//                 'action':'get_scores',
//                 termValue,
//                 classValue,
//                 subjectValue,
//                 sessionValue
//             },
//             success: (data) => {
//                 console.log(data)
//             }
//         })
//         tableHtml = `
//             <thead>
//                 <tr>
//                     <th class="">Subject</th>
//                     ${settingsData.ca1 == 1 ? `<th>CA1</th>` : ''}
//                     ${settingsData.ca2 == 1 ? `<th>CA2</th>` : ''}
//                     ${settingsData.ca3 == 1 ? `<th>CA3</th>` : ''}
//                     ${settingsData.pra == 1 ? `<th>Practical</th>` : ''}
//                     ${settingsData.exa == 1 ? `<th>Exam</th>` : ''}
//                 </tr>
//             </thead>
//             <tbody id="tbody">
//             ${subjects.map((subject) =>
//             `<tr>
//                     <td class="font-xs-16 assess_subject">${subject}</td>
//                     ${settingsData.ca1 == 1 ? `<td><input class="w-xs-60 assess_input" type="number"></td>` : ''}
//                     ${settingsData.ca2 == 1 ? `<td><input class="w-xs-60 assess_input" type="number"></td>` : ''}
//                     ${settingsData.ca3 == 1 ? `<td><input class="w-xs-60 assess_input" type="number"></td>` : ''}
//                     ${settingsData.pra == 1 ? `<td><input class="w-xs-60 assess_input" type="number"></td>` : ''}
//                     ${settingsData.exa == 1 ? `<td><input class="w-xs-60 assess_input" type="number"></td>` : ''}
//                 </tr>`).join('')}
//             </tbody>`;
//     } else if ($("#by_ca1").hasClass('active')) {
//         tableHtml = `
//             <thead>
//                 <tr>
//                     <th class="">Subject</th>
//                     <th class="">CA1</th>
//                     <th class="">Total</th>
//                 </tr>
//             </thead>
//             <tbody>
//             ${subjects.map((subject) =>
//             `<tr>
//                     <td class="font-xs-16 assess_subject">${subject}</td>
//                     <td><input class="w-xs-60 assess_input" type="number"></td>
//                     <td><input class="w-xs-60 assess_total" type="number"></td>
//                 </tr>`).join('')}
//             </tbody>`;
//     } else if ($("#by_ca2").hasClass('active')) {
//         tableHtml = `
//             <thead>
//                 <tr>
//                     <th class="">Subject</th>
//                     <th class="">CA2</th>
//                     <th class="">Total</th>
//                 </tr>
//             </thead>
//             <tbody>
//                 <tr>
//                     <td class="font-xs-16 assess_subject"><strong>Onaolapo</strong><br>Olusegun Abayomi</td>
//                     <td><input class="w-xs-60 assess_input" type="number"></td>
//                     <td><input class="w-xs-60 assess_input" type="number"></td>
//                 </tr>
//             </tbody>`;
//     } else if ($("#by_pra").hasClass('active')) {
//         tableHtml = `
//             <thead>
//                 <tr>
//                     <th class="">Subject</th>
//                     <th class="">Practical</th>
//                     <th class="">Total</th>
//                 </tr>
//             </thead>
//             <tbody>
//                 <tr>
//                     <td class="font-xs-16 assess_subject"><strong>Onaolapo</strong><br>Olusegun Abayomi</td>
//                     <td><input class="w-xs-60" type="number"></td>
//                     <td><input class="w-xs-60" type="number"></td>
//                 </tr>
//             </tbody>`;
//     } else if ($("#by_ca3").hasClass('active')) {
//         tableHtml = `
//             <thead>
//                 <tr>
//                     <th class="">Subject</th>
//                     <th class="">CA3</th>
//                     <th class="">Total</th>
//                 </tr>
//             </thead>
//             <tbody>
//                 <tr>
//                     <td class="font-xs-16 assess_subject"><strong>Onaolapo</strong><br>Olusegun Abayomi</td>
//                     <td><input class="w-xs-60" type="number"></td>
//                     <td><input class="w-xs-60" type="number"></td>
//                 </tr>
//             </tbody>`;
//     } else if ($("#by_exam").hasClass('active')) {
//         tableHtml = `
//             <thead>
//                 <tr>
//                     <th class="">Subject</th>
//                     <th class="">Exam</th>
//                     <th class="">Total</th>
//                 </tr>
//             </thead>
//             <tbody>
//                 <tr>
//                     <td class="font-xs-14 assess_subject"><strong>Onaolapo</strong><br>Olusegun Abayomi</td>
//                     <td><input class="w-xs-60" type="number"></td>
//                     <td><input class="w-xs-60" type="number"></td>
//                 </tr>
//             </tbody>`;
//     }
//     // Destroy existing DataTable instance
//     if ($.fn.DataTable.isDataTable('#post_score_table_by_student')) {
//         $('#post_score_table_by_student').DataTable().destroy();
//     }
//     $('#post_score_table_by_student').html(tableHtml);

//     // Reinitialize DataTable
//     $('#post_score_table_by_student').DataTable({
//         scrollX: true,
//         paging: false,
//         ordering: false,
//         fixedColumns: {
//             left: 1,
//             right: 0
//         }
//     });
// }
function display_table1(filtertype) {
    if (!filtertype) {
        filtertype = filtertypesaved;
    } else {
        filtertypesaved = filtertype;
    }
    const termValue = $(".select_btn.term.active").attr("data-name");
    const classValue = $("#select_class_field").val();
    const studentValue = $("#select_student_field").val();
    const subjectValue = $("#select_subject_field").val();
    const sessionValue = $("#select_session_field").val();
    let arrayValues = '';
    let postdata = {};
    if (filtertype === 'student') {
        arrayValues = subjects;
        postdata = {
            action: 'get_scores',
            termValue,
            classValue,
            studentValue,
            sessionValue
        };
    } else {
        arrayValues = students;
        postdata = {
            action: 'get_scores',
            termValue,
            classValue,
            subjectValue,
            sessionValue
        };
    }

    let tableHtml = '';
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: postdata,
        success: (data) => {
            data = data.trim();
            let scores = JSON.parse(data);

            if ($("#by_all").hasClass('active')) {
                tableHtml = `
                    <thead>
                        <tr>
                            <th class="">Subject</th>
                            ${settingsData.ca1 == 1 ? `<th>CA1</th><th>CA1 Total</th>` : ''}
                            ${settingsData.ca2 == 1 ? `<th>CA2</th><th>CA2 Total</th>` : ''}
                            ${settingsData.ca3 == 1 ? `<th>CA3</th><th>CA3 Total</th>` : ''}
                            ${settingsData.pra == 1 ? `<th>Practical</th><th>Practical Total</th>` : ''}
                            ${settingsData.exa == 1 ? `<th>Exam</th><th>Exam Total</th>` : ''}
                        </tr>
                    </thead>
                    <tbody id="tbody">
                    ${arrayValues.map((arrayValue) => {
                    let score = scores.find(s => s.subjectsOrNames == arrayValue.subject) || {};
                    return `<tr>
                            <td class="font-xs-14 assess_subject" data-id=${arrayValue.id}>${filtertype === 'student' ? arrayValue.subject : arrayValue.name}</td>
                            ${settingsData.ca1 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca1 || ''}"></td><td><input class="w-xs-60 assess_input" type="number" value="${score.ca1Total || ''}"></td>` : ''}
                            ${settingsData.ca2 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca2 || ''}"></td><td><input class="w-xs-60 assess_input" type="number" value="${score.ca2Total || ''}"></td>` : ''}
                            ${settingsData.ca3 == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.ca3 || ''}"></td><td><input class="w-xs-60 assess_input" type="number" value="${score.ca3Total || ''}"></td>` : ''}
                            ${settingsData.pra == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.pra || ''}"></td><td><input class="w-xs-60 assess_input" type="number" value="${score.praTotal || ''}"></td>` : ''}
                            ${settingsData.exa == 1 ? `<td><input class="w-xs-60 assess_input" type="number" value="${score.exam || ''}"></td><td><input class="w-xs-60 assess_input" type="number" value="${score.examTotal || ''}"></td>` : ''}
                        </tr>`;
                }).join('')}
                    </tbody>`;
            } else if ($("#by_ca1").hasClass('active')) {
                tableHtml = `
                            <thead>
                                <tr>
                                    <th class="">Subject</th>
                                    <th class="">CA1</th>
                                    <th class="">Total</th>
                                </tr>
                            </thead>
                            <tbody>
                            ${arrayValues.map((arrayValue) => {
                    let score = scores.find(s => s.subjectsOrNames == arrayValue) || {};
                    return `<tr>
                                    <td class="font-xs-14 assess_subject">${arrayValue}</td>
                                    <td><input class="w-xs-60 assess_input" type="number" value="${score.ca1 || ''}"></td>
                                    <td><input class="w-xs-60 assess_total" type="number" value="${score.ca1Total || ''}"></td>
                                </tr>`;
                }).join('')}
                            </tbody>`;
            }
            // Similar updates for other cases: by_ca1, by_ca2, etc.

            // Destroy existing DataTable instance
            if ($.fn.DataTable.isDataTable('#post_score_table_by_student')) {
                $('#post_score_table_by_student').DataTable().destroy();
            }
            $('#post_score_table_by_student').html(tableHtml);

            // Reinitialize DataTable
            $('#post_score_table_by_student').DataTable({
                scrollX: true,
                paging: false,
                ordering: false,
                fixedColumns: {
                    left: 1,
                    right: 0
                }
            });
        }
    });
}

function getTableData() {
    const tableData = [];

    $('#post_score_table_by_student tbody tr').each(function () {
        const subject = $(this).find('.assess_subject').text();
        const ca1 = $(this).find('input[type="number"]').eq(0).val() || 0;
        const ca2 = $(this).find('input[type="number"]').eq(1).val() || 0;
        const ca3 = $(this).find('input[type="number"]').eq(2).val() || 0;
        const practical = $(this).find('input[type="number"]').eq(3).val() || 0;
        const exam = $(this).find('input[type="number"]').eq(4).val() || 0;

        tableData.push({
            subject,
            ca1: Number(ca1),
            ca2: Number(ca2),
            ca3: Number(ca3),
            practical: Number(practical),
            exam: Number(exam)
        });
    });
    return tableData;
}

function scoreValue() {

}



// function submitScores1() {
//     const data = getTableData();
//     console.log(data);
//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: { "action": "post_scores", scores: data },
//         success: function (response) {
//             console.log('Data submitted successfully:', response);
//         },
//         error: function (error) {
//             console.error('Error submitting data:', error);
//         }
//     });
// }

// Call this function on form submission
// $('#submit_scores_button').on('click', submitFormData);
// alert('lku')
function getstudent(classValue) {
    // setfilter('student')
    console.log(classValue)
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: {
            'action': 'getstudents',
            classValue,
        },
        success: (data) => {
            data = JSON.parse(data)
            var str;
            data.map((item) => {
                str = str + `<option value="${item.id}">${item.name}</option>`
            })
            $("#select_student_field").html(str)
            display_table('student')
        }
    })
}
// alert('lkj')
// function submitScores() {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     const tableData = [];

//     function processRow(row, extraFields = {}) {
//         const subjectOrNameId = $(row).find('.assess_subject').attr('data-id');
//         const ca1 = $(row).find('input[type="number"]').eq(0).val() || 0;
//         const ca2 = $(row).find('input[type="number"]').eq(1).val() || 0;
//         const ca3 = $(row).find('input[type="number"]').eq(2).val() || 0;
//         const practical = $(row).find('input[type="number"]').eq(3).val() || 0;
//         const exam = $(row).find('input[type="number"]').eq(4).val() || 0;

//         const scoreData = {
//             class: classValue,
//             term: termValue,
//             session: sessionValue,
//             subjectOrNameId,
//             ca1: Number(ca1),
//             ca2: Number(ca2),
//             ca3: Number(ca3),
//             practical: Number(practical),
//             exam: Number(exam),
//             ...extraFields
//         };

//         tableData.push(scoreData);
//     }

//     function processTable(extraFields = {}) {
//         $('#post_score_table_by_student tbody tr').each(function () {
//             processRow(this, extraFields);
//         });
//     }

//     if ($("#by_stud_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//         if ($("#by_ca1").hasClass('active')) {
//             processTable({ studentId: studentValue, total: $(this).find('input[type="number"]').eq(1).val() || 0 });
//         }
//     } else if ($("#by_subj_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ subject: subjectValue });
//         }
//         if ($("#by_ca1").hasClass('active')) {
//             processTable({ subject: subjectValue, total: $(this).find('input[type="number"]').eq(1).val() || 0 });
//         }
//     }

//     // Debug output
//     console.log('Submitting scores: ', tableData);

//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: { scores: tableData, action: "submit_scores" },
//         success: (data) => {
//             console.log('Server response: ', data);
//         }
//     });
// }

// function submitScores() {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     const tableData = [];

//     function processRow(row, extraFields = {}) {
//         const subjectOrNameId = $(row).find('.assess_subject').attr('data-id');
//         const ca1 = $(row).find('input[type="number"]').eq(0).val() || 0;
//         const ca1Total = $(row).find('input[type="number"]').eq(1).val() || 0;
//         const ca2 = $(row).find('input[type="number"]').eq(2).val() || 0;
//         const ca2Total = $(row).find('input[type="number"]').eq(3).val() || 0;
//         const ca3 = $(row).find('input[type="number"]').eq(4).val() || 0;
//         const ca3Total = $(row).find('input[type="number"]').eq(5).val() || 0;
//         const practical = $(row).find('input[type="number"]').eq(6).val() || 0;
//         const practicalTotal = $(row).find('input[type="number"]').eq(7).val() || 0;
//         const exam = $(row).find('input[type="number"]').eq(8).val() || 0;
//         const examTotal = $(row).find('input[type="number"]').eq(9).val() || 0;

//         const scoreData = {
//             class: classValue,
//             term: termValue,
//             session: sessionValue,
//             subjectOrNameId,
//             ca1: Number(ca1),
//             ca1Total: Number(ca1Total),
//             ca2: Number(ca2),
//             ca2Total: Number(ca2Total),
//             ca3: Number(ca3),
//             ca3Total: Number(ca3Total),
//             practical: Number(practical),
//             practicalTotal: Number(practicalTotal),
//             exam: Number(exam),
//             examTotal: Number(examTotal),
//             ...extraFields
//         };

//         tableData.push(scoreData);
//     }

//     function processTable(extraFields = {}) {
//         $('#post_score_table_by_student tbody tr').each(function () {
//             processRow(this, extraFields);
//         });
//     }

//     if ($("#by_stud_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//         if ($("#by_ca1").hasClass('active')) {
//             processTable({ studentId: studentValue, total: $(this).find('input[type="number"]').eq(1).val() || 0 });
//         }
//     } else if ($("#by_subj_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ subject: subjectValue });
//         }
//         if ($("#by_ca1").hasClass('active')) {
//             processTable({ subject: subjectValue, total: $(this).find('input[type="number"]').eq(1).val() || 0 });
//         }
//     }
//     console.log(tableData)
//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: { scores: tableData, action: "submit_scores" },
//         success: (data) => {
//             console.log(data);
//         }
//     });
// }
// function submitScores() {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     const tableData = [];

//     function processRow(row, extraFields = {}) {
//         const subjectOrNameId = $(row).find('.assess_subject').attr('data-id');
//         const ca1 = $(row).find('input[type="number"]').eq(0).val() || 0;
//         const ca1Total = $(row).find('input[type="number"]').eq(1).val() || 0;
//         const ca2 = $(row).find('input[type="number"]').eq(2).val() || 0;
//         const ca2Total = $(row).find('input[type="number"]').eq(3).val() || 0;
//         const ca3 = $(row).find('input[type="number"]').eq(4).val() || 0;
//         const ca3Total = $(row).find('input[type="number"]').eq(5).val() || 0;
//         const practical = $(row).find('input[type="number"]').eq(6).val() || 0;
//         const practicalTotal = $(row).find('input[type="number"]').eq(7).val() || 0;
//         const exam = $(row).find('input[type="number"]').eq(8).val() || 0;
//         const examTotal = $(row).find('input[type="number"]').eq(9).val() || 0;

//         const scoreData = {
//             class: classValue,
//             term: termValue,
//             session: sessionValue,
//             subjectOrNameId,
//             ca1: Number(ca1),
//             ca1Total: Number(ca1Total),
//             ca2: Number(ca2),
//             ca2Total: Number(ca2Total),
//             ca3: Number(ca3),
//             ca3Total: Number(ca3Total),
//             practical: Number(practical),
//             practicalTotal: Number(practicalTotal),
//             exam: Number(exam),
//             examTotal: Number(examTotal),
//             ...extraFields
//         };

//         tableData.push(scoreData);
//     }

//     function processTable(extraFields = {}) {
//         $('#post_score_table_by_student tbody tr').each(function () {
//             processRow(this, extraFields);
//         });
//     }

//     if ($("#by_stud_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//         if ($("#by_ca1").hasClass('active')) {
//             processTable({ studentId: studentValue, total: $(this).find('input[type="number"]').eq(1).val() || 0 });
//         }
//     } else if ($("#by_subj_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ subject: subjectValue });
//         }
//         if ($("#by_ca1").hasClass('active')) {
//             processTable({ subject: subjectValue, total: $(this).find('input[type="number"]').eq(1).val() || 0 });
//         }
//     }
//     console.log(tableData)
//     $.ajax({
//         url: '../controller.php',
//         type: 'POST',
//         data: { scores: tableData, action: "submit_scores" },
//         success: (data) => {
//             console.log(data);
//         }
//     });
// }

// function submitScoreslatest() {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     const tableData = [];

//     function processRow(row, extraFields = {}) {
//         const subjectOrNameId = $(row).find('.assess_subject').attr('data-id');
//         const ca1 = $(row).find('input[type="number"]').eq(0).val() || 0;
//         const ca1Total = $(row).find('input[type="number"]').eq(1).val() || 0;
//         const ca2 = $(row).find('input[type="number"]').eq(2).val() || 0;
//         const ca2Total = $(row).find('input[type="number"]').eq(3).val() || 0;
//         const ca3 = $(row).find('input[type="number"]').eq(4).val() || 0;
//         const ca3Total = $(row).find('input[type="number"]').eq(5).val() || 0;
//         const practical = $(row).find('input[type="number"]').eq(6).val() || 0;
//         const practicalTotal = $(row).find('input[type="number"]').eq(7).val() || 0;
//         const exam = $(row).find('input[type="number"]').eq(8).val() || 0;
//         const examTotal = $(row).find('input[type="number"]').eq(9).val() || 0;

//         const scoreData = {
//             term: termValue,
//             class: classValue,
//             session: sessionValue,
//             subjectOrNameId,
//             ca1: Number(ca1),
//             ca1Total: Number(ca1Total),
//             ca2: Number(ca2),
//             ca2Total: Number(ca2Total),
//             ca3: Number(ca3),
//             ca3Total: Number(ca3Total),
//             practical: Number(practical),
//             practicalTotal: Number(practicalTotal),
//             exam: Number(exam),
//             examTotal: Number(examTotal),
//             ...extraFields
//         };

//         tableData.push(scoreData);
//     }

//     function processTable(extraFields = {}) {
//         $('#post_score_table_by_student tbody tr').each(function () {
//             processRow(this, extraFields);
//         });
//     }

//     if ($("#by_stud_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//         if ($("#by_ca1").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//     } else if ($("#by_subj_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         }
//         if ($("#by_ca1").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         }
//         if ($("#by_ca2").hasClass('active')) {
//             // alert('j')
//             processTable({ ca2: Number(ca2) });
//         }
//     }

//     console.log(tableData);

//     if (tableData.length > 0) {
//         $.ajax({
//             url: '../controller.php',
//             type: 'POST',
//             data: { scores: tableData, action: "submit_scores" },
//             success: function (response) {
//                 console.log(response);
//             },
//             error: function (xhr, status, error) {
//                 console.error(xhr.responseText);
//             }
//         });
//     } else {
//         console.error("Error: No data to submit.");
//     }
// }
// function submitScores() {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     const tableData = [];

//     function processRow(row, extraFields = {}) {
//         const subjectOrNameId = $(row).find('.assess_subject').attr('data-id');

//         let ca1 = 0, ca1Total = 0, ca2 = 0, ca2Total = 0, ca3 = 0, ca3Total = 0, practical = 0, practicalTotal = 0, exam = 0, examTotal = 0;

//         if ($("#by_all").hasClass('active')) {
//             ca1 = $(row).find('input[type="number"]').eq(0).val() || 19;
//             ca1Total = $(row).find('input[type="number"]').eq(1).val() || 0;
//             ca2 = $(row).find('input[type="number"]').eq(2).val() || 0;
//             ca2Total = $(row).find('input[type="number"]').eq(3).val() || 0;
//             ca3 = $(row).find('input[type="number"]').eq(4).val() || 0;
//             ca3Total = $(row).find('input[type="number"]').eq(5).val() || 0;
//             practical = $(row).find('input[type="number"]').eq(6).val() || 0;
//             practicalTotal = $(row).find('input[type="number"]').eq(7).val() || 0;
//             exam = $(row).find('input[type="number"]').eq(8).val() || 0;
//             examTotal = $(row).find('input[type="number"]').eq(9).val() || 0;
//         } else if ($("#by_ca1").hasClass('active')) {
//             ca1 = $(row).find('input[type="number"]').eq(0).val() || 0;
//             ca1Total = $(row).find('input[type="number"]').eq(1).val() || 0;
//         } else if ($("#by_ca2").hasClass('active')) {
//             ca2 = $(row).find('input[type="number"]').eq(0).val() || 0;
//             ca2Total = $(row).find('input[type="number"]').eq(1).val() || 0;
//         } else if ($("#by_ca3").hasClass('active')) {
//             ca3 = $(row).find('input[type="number"]').eq(0).val() || 0;
//             ca3Total = $(row).find('input[type="number"]').eq(1).val() || 0;
//         }

//         const scoreData = {
//             term: termValue,
//             class: classValue,
//             session: sessionValue,
//             subjectOrNameId,
//             ca1: Number(ca1),
//             ca1Total: Number(ca1Total),
//             ca2: Number(ca2),
//             ca2Total: Number(ca2Total),
//             ca3: Number(ca3),
//             ca3Total: Number(ca3Total),
//             practical: Number(practical),
//             practicalTotal: Number(practicalTotal),
//             exam: Number(exam),
//             examTotal: Number(examTotal),
//             ...extraFields
//         };

//         tableData.push(scoreData);
//     }

//     function processTable(extraFields = {}) {
//         $('#post_score_table_by_student tbody tr').each(function () {
//             processRow(this, extraFields);
//         });
//     }

//     if ($("#by_stud_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//         if ($("#by_ca1").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//         if ($("#by_ca2").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//         if ($("#by_ca3").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//     } else if ($("#by_subj_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         }
//         if ($("#by_ca1").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         }
//         if ($("#by_ca2").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         }
//         if ($("#by_ca3").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         }
//     }

//     console.log(tableData);

//     if (tableData.length > 0) {
//         $.ajax({
//             url: '../controller.php',
//             type: 'POST',
//             data: { scores: tableData, action: "submit_scores" },
//             success: function (response) {
//                 console.log(response);
//             },
//             error: function (xhr, status, error) {
//                 console.error(xhr.responseText);
//             }
//         });
//     } else {
//         console.error("Error: No data to submit.");
//     }
// }
// function submitScoreslatestlatest() {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     const tableData = [];

//     function processRow(row, extraFields = {}) {
//         const subjectOrNameId = $(row).find('.assess_subject').attr('data-id');
//         const scoreData = {
//             term: termValue,
//             class: classValue,
//             session: sessionValue,
//             subjectOrNameId,
//             ...extraFields
//         };

//         if ($("#by_all").hasClass('active')) {
//             scoreData.ca1 = Number($(row).find('input[type="number"]').eq(0).val() || 0);
//             scoreData.ca1Total = Number($(row).find('input[type="number"]').eq(1).val() || 0);
//             scoreData.ca2 = Number($(row).find('input[type="number"]').eq(2).val() || 0);
//             scoreData.ca2Total = Number($(row).find('input[type="number"]').eq(3).val() || 0);
//             scoreData.ca3 = Number($(row).find('input[type="number"]').eq(4).val() || 0);
//             scoreData.ca3Total = Number($(row).find('input[type="number"]').eq(5).val() || 0);
//             scoreData.practical = Number($(row).find('input[type="number"]').eq(6).val() || 0);
//             scoreData.practicalTotal = Number($(row).find('input[type="number"]').eq(7).val() || 0);
//             scoreData.exam = Number($(row).find('input[type="number"]').eq(8).val() || 0);
//             scoreData.examTotal = Number($(row).find('input[type="number"]').eq(9).val() || 0);
//         } else if ($("#by_ca1").hasClass('active')) {
//             scoreData.ca1 = Number($(row).find('input[type="number"]').eq(0).val() || 0);
//             scoreData.ca1Total = Number($(row).find('input[type="number"]').eq(1).val() || 0);
//         } else if ($("#by_ca2").hasClass('active')) {
//             scoreData.ca2 = Number($(row).find('input[type="number"]').eq(0).val() || 0);
//             scoreData.ca2Total = Number($(row).find('input[type="number"]').eq(1).val() || 0);
//         } else if ($("#by_ca3").hasClass('active')) {
//             scoreData.ca3 = Number($(row).find('input[type="number"]').eq(0).val() || 0);
//             scoreData.ca3Total = Number($(row).find('input[type="number"]').eq(1).val() || 0);
//         } else if ($("#by_pra").hasClass('active')) {
//             scoreData.practical = Number($(row).find('input[type="number"]').eq(0).val() || 0);
//             scoreData.practicalTotal = Number($(row).find('input[type="number"]').eq(1).val() || 0);
//         }
//         else if ($("#by_exam").hasClass('active')) {
//             scoreData.exam = Number($(row).find('input[type="number"]').eq(0).val() || 0);
//             scoreData.examTotal = Number($(row).find('input[type="number"]').eq(1).val() || 0);
//         }

//         tableData.push(scoreData);
//     }

//     function processTable(extraFields = {}) {
//         $('#post_score_table_by_student tbody tr').each(function () {
//             processRow(this, extraFields);
//         });
//     }

//     if ($("#by_stud_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         } else if ($("#by_ca1").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         } else if ($("#by_ca2").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         } else if ($("#by_ca3").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//         else if ($("#by_pra").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//         else if ($("#by_exam").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//     } else if ($("#by_subj_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         } else if ($("#by_ca1").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         } else if ($("#by_ca2").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         } else if ($("#by_ca3").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         }
//         else if ($("#by_pra").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         }
//         else if ($("#by_exam").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         }
//     }

//     console.log(tableData);

//     if (tableData.length > 0) {
//         $.ajax({
//             url: '../controller.php',
//             type: 'POST',
//             data: { scores: tableData, action: "submit_scores" },
//             success: function (response) {
//                 console.log(response);
//             },
//             error: function (xhr, status, error) {
//                 console.error(xhr.responseText);
//             }
//         });
//     } else {
//         console.error("Error: No data to submit.");
//     }
// }
// alert('l')
function updatehiddentotals(event, class_selected) {
    // alert('lk')
    $(`.assess_input.${class_selected}`).val($(event).val())
}

// alert('k')
function submitScores() {
    const termValue = $(".select_btn.term.active").attr("data-name");
    const classValue = $("#select_class_field").val();
    const studentValue = $("#select_student_field").val();
    const subjectValue = $("#select_subject_field").val();
    const sessionValue = $("#select_session_field").val();
    const tableData = [];

    function processRow(row, extraFields = {}) {
        const subjectOrNameId = $(row).find('.assess_subject').attr('data-id');
        const scoreData = {
            term: termValue,
            class: classValue,
            session: sessionValue,
            subjectOrNameId,
            ...extraFields
        };

        let inputs = $(row).find('input[type="number"]');
        let inputIndex = 0;

        if ($("#by_all").hasClass('active')) {
            if (settingsData.ca1 == 1) {
                scoreData.ca1 = Number(inputs.eq(inputIndex++).val() || 0);
                scoreData.ca1Total = Number(inputs.eq(inputIndex++).val() || 0);
            }
            if (settingsData.ca2 == 1) {
                scoreData.ca2 = Number(inputs.eq(inputIndex++).val() || 0);
                scoreData.ca2Total = Number(inputs.eq(inputIndex++).val() || 0);
            }
            if (settingsData.ca3 == 1) {
                scoreData.ca3 = Number(inputs.eq(inputIndex++).val() || 0);
                scoreData.ca3Total = Number(inputs.eq(inputIndex++).val() || 0);
            }
            if (settingsData.pra == 1) {
                scoreData.practical = Number(inputs.eq(inputIndex++).val() || 0);
                scoreData.practicalTotal = Number(inputs.eq(inputIndex++).val() || 0);
            }
            if (settingsData.exa == 1) {
                scoreData.exam = Number(inputs.eq(inputIndex++).val() || 0);
                scoreData.examTotal = Number(inputs.eq(inputIndex++).val() || 0);
            }
        } else if ($("#by_ca1").hasClass('active')) {
            scoreData.ca1 = Number(inputs.eq(0).val() || 0);
            scoreData.ca1Total = Number(inputs.eq(1).val() || 0);
        } else if ($("#by_ca2").hasClass('active')) {
            scoreData.ca2 = Number(inputs.eq(0).val() || 0);
            scoreData.ca2Total = Number(inputs.eq(1).val() || 0);
        } else if ($("#by_ca3").hasClass('active')) {
            scoreData.ca3 = Number(inputs.eq(0).val() || 0);
            scoreData.ca3Total = Number(inputs.eq(1).val() || 0);
        } else if ($("#by_pra").hasClass('active')) {
            scoreData.practical = Number(inputs.eq(0).val() || 0);
            scoreData.practicalTotal = Number(inputs.eq(1).val() || 0);
        } else if ($("#by_exam").hasClass('active')) {
            scoreData.exam = Number(inputs.eq(0).val() || 0);
            scoreData.examTotal = Number(inputs.eq(1).val() || 0);
        }

        tableData.push(scoreData);
    }

    function processTable(extraFields = {}) {
        $('#post_score_table_by_student tbody tr').each(function () {
            processRow(this, extraFields);
        });
    }

    if ($("#by_stud_btn").hasClass('active')) {
        processTable({ studentId: studentValue });
    } else if ($("#by_subj_btn").hasClass('active')) {
        processTable({ subjectId: subjectValue });
    }

    console.log(tableData);

    if (tableData.length > 0) {

        $.ajax({
            url: '../controller.php',
            type: 'POST',
            data: { scores: tableData, action: "submit_scores" },
            success: function (data) {
                data = JSON.parse(data)
                if (data.status == '1') {
                    setTimeout(track_scores_changes, 1000);
                    toastr.success(data.msg);
                    // alert('kingnow')
                    $.ajax({
                        url: "../controller.php",
                        type: "POST",
                        data: {
                            'action': 'update_total_score',
                            classValue,
                            termValue,
                            sessionValue
                        },
                        success: (data) => {
                            console.log('updatesores', data)
                        }
                    })
                } else {
                    toastr.error(data.err);
                }
            }
        });
    } else {
        console.error("Error: No data to submit.");
    }
}


// alert('kj')
// function submitScores() {
//     const termValue = $(".select_btn.term.active").attr("data-name");
//     const classValue = $("#select_class_field").val();
//     const studentValue = $("#select_student_field").val();
//     const subjectValue = $("#select_subject_field").val();
//     const sessionValue = $("#select_session_field").val();
//     const tableData = [];

//     function processRow(row, extraFields = {}) {
//         const subjectOrNameId = $(row).find('.assess_subject').attr('data-id');
//         const scoreData = {
//             term: termValue,
//             class: classValue,
//             session: sessionValue,
//             subjectOrNameId,
//             ...extraFields
//         };

//         if ($("#by_all").hasClass('active')) {
//             scoreData.ca1 = Number($(row).find('input[type="number"]').eq(0).val() || 0);
//             scoreData.ca1Total = Number($(row).find('input[type="number"]').eq(1).val() || 0);
//             scoreData.ca2 = Number($(row).find('input[type="number"]').eq(2).val() || 0);
//             scoreData.ca2Total = Number($(row).find('input[type="number"]').eq(3).val() || 0);
//             scoreData.ca3 = Number($(row).find('input[type="number"]').eq(4).val() || 0);
//             scoreData.ca3Total = Number($(row).find('input[type="number"]').eq(5).val() || 0);
//             scoreData.practical = Number($(row).find('input[type="number"]').eq(6).val() || 0);
//             scoreData.practicalTotal = Number($(row).find('input[type="number"]').eq(7).val() || 0);
//             scoreData.exam = Number($(row).find('input[type="number"]').eq(8).val() || 0);
//             scoreData.examTotal = Number($(row).find('input[type="number"]').eq(9).val() || 0);
//         } else if ($("#by_ca1").hasClass('active')) {
//             scoreData.ca1 = Number($(row).find('input[type="number"]').eq(0).val() || 0);
//             scoreData.ca1Total = Number($(row).find('input[type="number"]').eq(1).val() || 0);
//         } else if ($("#by_ca2").hasClass('active')) {
//             scoreData.ca2 = Number($(row).find('input[type="number"]').eq(0).val() || 0);
//             scoreData.ca2Total = Number($(row).find('input[type="number"]').eq(1).val() || 0);
//         } else if ($("#by_ca3").hasClass('active')) {
//             scoreData.ca3 = Number($(row).find('input[type="number"]').eq(0).val() || 0);
//             scoreData.ca3Total = Number($(row).find('input[type="number"]').eq(1).val() || 0);
//         }

//         tableData.push(scoreData);
//     }

//     function processTable(extraFields = {}) {
//         $('#post_score_table_by_student tbody tr').each(function () {
//             processRow(this, extraFields);
//         });
//     }

//     if ($("#by_stud_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         } else if ($("#by_ca1").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         } else if ($("#by_ca2").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         } else if ($("#by_ca3").hasClass('active')) {
//             processTable({ studentId: studentValue });
//         }
//     } else if ($("#by_subj_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         } else if ($("#by_ca1").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         } else if ($("#by_ca2").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         } else if ($("#by_ca3").hasClass('active')) {
//             processTable({ subjectId: subjectValue });
//         }
//     }

//     console.log(tableData);

//     if (tableData.length > 0) {
//         $.ajax({
//             url: '../controller.php',
//             type: 'POST',
//             data: { scores: tableData, action: "submit_scores" },
//             success: function (response) {
//                 console.log(response);
//             },
//             error: function (xhr, status, error) {
//                 console.error(xhr.responseText);
//             }
//         });
//     } else {
//         console.error("Error: No data to submit.");
//     }
// }










// function submitScores() {
//     const termValue = $(".select_btn.term.active").attr("data-name")
//     const classValue = $("#select_class_field").val()
//     const studentValue = $("#select_student_field").val()
//     const subjectValue = $("#select_subject_field").val()
//     const sessionValue = $("#select_session_field").val()
//     const tableData = [];
//     // alert('lk')
//     if ($("#by_stud_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             $('#post_score_table_by_student tbody tr').each(function () {
//                 const subjectOrName = $(this).find('.assess_subject').text();
//                 const ca1 = $(this).find('input[type="number"]').eq(0).val() || 0;
//                 const ca2 = $(this).find('input[type="number"]').eq(1).val() || 0;
//                 const ca3 = $(this).find('input[type="number"]').eq(2).val() || 0;
//                 const practical = $(this).find('input[type="number"]').eq(3).val() || 0;
//                 const exam = $(this).find('input[type="number"]').eq(4).val() || 0;

//                 tableData.push({
//                     class: classValue,
//                     studentId: studentValue,
//                     session: sessionValue,
//                     subjectOrName,
//                     ca1: Number(ca1),
//                     ca2: Number(ca2),
//                     ca3: Number(ca3),
//                     practical: Number(practical),
//                     exam: Number(exam)
//                 });
//             });

//         }
//         if ($("#by_ca1").hasClass('active')) {
//             $('#post_score_table_by_student tbody tr').each(function () {
//                 const subjectOrName = $(this).find('.assess_subject').text();
//                 const ca1 = $(this).find('input[type="number"]').eq(0).val() || 0;
//                 const total = $(this).find('input[type="number"]').eq(1).val() || 0;

//                 tableData.push({
//                     class: classValue,
//                     studentId: studentValue,
//                     session: sessionValue,
//                     subjectOrName,
//                     ca1: Number(ca1),
//                     total: Number(total),
//                 });
//             });
//         }
//         $.ajax({
//             url: '../controller.php',
//             type: 'POST',
//             data: {scores:tableData,action:"submit_scores"},
//             success: (data) => {
//                 console.log(data)
//             }
//         })
//     }
//     else if ($("#by_subj_btn").hasClass('active')) {
//         if ($("#by_all").hasClass('active')) {
//             $('#post_score_table_by_student tbody tr').each(function () {
//                 const subjectOrName = $(this).find('.assess_subject').text();
//                 const ca1 = $(this).find('input[type="number"]').eq(0).val() || 0;
//                 const ca2 = $(this).find('input[type="number"]').eq(1).val() || 0;
//                 const ca3 = $(this).find('input[type="number"]').eq(2).val() || 0;
//                 const practical = $(this).find('input[type="number"]').eq(3).val() || 0;
//                 const exam = $(this).find('input[type="number"]').eq(4).val() || 0;

//                 tableData.push({
//                     class: classValue,
//                     subject: subjectValue,
//                     session: sessionValue,
//                     subjectOrName,
//                     ca1: Number(ca1),
//                     ca2: Number(ca2),
//                     ca3: Number(ca3),
//                     practical: Number(practical),
//                     exam: Number(exam)
//                 });
//             });
//         }
//         if ($("#by_ca1").hasClass('active')) {
//             $('#post_score_table_by_student tbody tr').each(function () {
//                 const subjectOrName = $(this).find('.assess_subject').text();
//                 const ca1 = $(this).find('input[type="number"]').eq(0).val() || 0;
//                 const total = $(this).find('input[type="number"]').eq(1).val() || 0;

//                 tableData.push({
//                     class: classValue,
//                     subject: subjectValue,
//                     session: sessionValue,
//                     subjectOrName,
//                     ca1: Number(ca1),
//                     total: Number(total),
//                 });
//             });
//         }
//         $.ajax({
//             url: '../controller.php',
//             type: 'POST',
//             data: {scores:tableData,action:"submit_scores"},
//             success: (data) => {
//                 console.log(data)
//             }
//         })
//     }
// }
// alert('lk')
// $("#select_class_field").change(function () {
//     if (!$("#by_subj_btn").hasClass('active')) {
//         const selected_class_value = $(this).val()
//         $.ajax({
//             url: '../controller.php',
//             type: 'POST',
//             data: {
//                 'action': 'getstudent',
//                 selected_class_value,
//             },
//             success: (data) => {
//                 data = JSON.parse(data)
//                 var str = ``
//                 data.map((item) => {
//                     str = str + `<option value="${item.id}">${item.name}</option>`
//                 })
//                 $("#select_student_field").html(str)
//             }
//         })
//     }
// })

// alert('jjjjj')
$(".changepass").submit(function (event) {
    event.preventDefault()
    let formdata = new FormData(this);
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        success: (data) => {
            data = JSON.parse(data)
            if (data.status == '1') {
                window.location = `./${data.location}`
            }
            else {
                toastr.error(data.err)
            }
        }
    })
})

function add_staff_data(event) {
    event.preventDefault();
    let formdata = new FormData(event.target);
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $("#add_new_staff_submit_btn").html('Processing')
            $("#add_new_staff_submit_btn").attr('disabled', true);
        },
        success: (data) => {
            $("#add_new_staff_submit_btn").html('Register')
            $("#add_new_staff_submit_btn").attr('disabled', false);
            data = JSON.parse(data);
            if (data.status == '1') {
                $("#staff_tables").load('../display_staff_table.php');
                setTimeout(() => {
                    toastr.success(data.msg);
                    $("#add_staff_modal").modal("hide");
                }, 200);
                // Reset the form fields
                event.target.reset();
                // Keep the placeholder image intact
                $('#image_profile_preview').attr('src', '../dist/img/avatar.png');

                $("#add_staff_data_warning").html('');
                $("#add_staff_data_warning").hide();
            } else {
                $("#add_staff_data_warning").html(data.err);
                $("#add_staff_data_warning").show();
            }
        }
    });
}

// alert('kk')
function add_sub_cat_form(event) {

    event.preventDefault()

    const checkboxes = document.querySelectorAll('.subject_checkbox');
    let subjectsList = [];


    checkboxes.forEach((checkbox) => {
        if (checkbox.checked) {
            const id = checkbox.value;
            // console.log(id)
            if (!subjectsList.includes(id)) {
                subjectsList.push(id);
            }
        }
    });

    console.log(subjectsList);
    if (subjectsList.length == 0) {
        $(".myalert").show()
        $("#add_subject_category_warning").html('Select at least one subject')
        return
    }
    // return
    let formdata = new FormData(event.target);
    formdata.append('subjectslist', JSON.stringify(subjectsList));
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $("#add_new_category_btn").html("Processing")
            $("#add_new_category_btn").attr("disabled", true)
        },
        success: (data) => {
            data = JSON.parse(data)
            if (data.status == '1') {
                $(".myalert").hide()
                $.ajax({
                    url: "../display_subject_category.php",
                    type: "post",
                    success: (response) => {
                        $("#add_new_category_btn").html("Save Category")
                        $("#add_new_category_btn").attr("disabled", false)
                        $("#subject_category_container").html(response)
                        $("#add_category_modal").modal("hide")
                        $(".subject_tabpane.tab-pane.active").removeClass('active')
                        $(".subject_tabpane.tab-pane.show").removeClass('show')
                        $(".pill-link.link-primary.subjectpage.active").removeClass('active')
                        $(".pill-link.link-primary.subjectpage:last").addClass('active')
                        $(".subject_tabpane.tab-pane:last").addClass('active')
                        $(".subject_tabpane.tab-pane:last").addClass('show')
                        load_subjects_by_cat('addsubject', `${$(".pill-link.subjectpage:last").attr("data-element")}`, `${$(".pill-link.subjectpage:last").attr("data-type")}`)
                        toastr.success(data.msg)
                        event.target.reset()
                        // $(".subject_checkbox").attr("checked", false)
                    }
                })
            }
            else {
                $("#add_new_category_btn").html("Save Category")
                $("#add_new_category_btn").attr("disabled", false)
                $(".myalert").show()
                $("#add_subject_category_warning").html(data.err)
            }
        }
    });
}
function update_sub_cat_form(event) {
    event.preventDefault()

    const checkboxes = document.querySelectorAll('.subject_checkbox');
    let subjectsList = [];


    checkboxes.forEach((checkbox) => {
        if (checkbox.checked) {
            const id = checkbox.value;
            if (!subjectsList.includes(id)) {
                subjectsList.push(id);
            }
        }
    });
    if (subjectsList.length == 0) {
        $(".myalert").show()
        $("#update_subject_category_warning").html('Select at least one subject')
        return
    }
    // console.log(subjectsList);
    let formdata = new FormData(event.target);
    formdata.append('subjectslist', JSON.stringify(subjectsList));
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $("#update_subj_cat_btn").html("Processing")
            $("#update_subj_cat_btn").attr("disabled", true)
        },
        success: (data) => {
            data = JSON.parse(data)
            $(".myalert").hide()
            if (data.status == '1') {
                load_subjects_by_cat('addsubject', `${$(".pill-link.subjectpage.active").attr("data-element")}`, `${$(".pill-link.subjectpage.active").attr("data-type")}`)
                $(".pill-link.subjectpage.active").html($("#subject_category_name").val())
                // $("#subject_category_container").load('display_subject_category.php')

                setTimeout($("#update_subject_category").modal("hide"), 200)
                $("#update_subj_cat_btn").html("Processing")
                $("#update_subj_cat_btn").attr("disabled", false)
                toastr.success(data.msg)
            }
            else {
                $("#update_subj_cat_btn").html("Save update")
                $("#update_subj_cat_btn").attr("disabled", false)
                // $("#update_subject_category_warning").show(data.err)
            }
        }
    });
}
function add_g_class_data(event) {
    event.preventDefault()
    let formdata = new FormData(event.target);
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $("#create_class_btn").html('Processing')
            $("#create_class_btn").attr('disabled', true)
        },
        success: (data) => {
            $("#create_class_btn").html('Create Class')
            $("#create_class_btn").attr('disabled', false)
            data = JSON.parse(data)
            if (data.status == '1') {
                $(".myalert").hide()

                $("#class_table").load('../display_class_table.php?is_g_table=1')
                setTimeout($("#add_class_modal").modal("hide"), 200)
                toastr.success(data.msg)
                event.target.reset()
                $('.select2').val(null).trigger('change')
            } else {
                $(".warning").html(data.err)
                $(".myalert").show()
            }
        },
    });
}

function add_class_data(event) {
    console.log('mknck')
    event.preventDefault()
    let formdata = new FormData(event.target);
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $("#create_class_btn").html('Processing')
            $("#create_class_btn").attr('disabled', true)
        },
        success: (data) => {
            $("#create_class_btn").html('Create Class')
            $("#create_class_btn").attr('disabled', false)
            data = JSON.parse(data)
            if (data.status == '1') {
                $(".myalert").hide()
                $("#class_table").load('../display_class_table.php')
                setTimeout($("#add_class_modal").modal("hide"), 200)
                toastr.success(data.msg)
                event.target.reset()
                $('.select2').val(null).trigger('change')
            } else {
                $(".warning").html(data.err)
                $(".myalert").show()
            }
        },
    });
}
function add_student_data(event) {
    event.preventDefault()
    let formdata = new FormData(event.target);
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $("#add_student_btn").attr("disabled", true)
            $("#add_student_btn").html("Processing...")
        },
        success: (data) => {
            data = JSON.parse(data)
            if (data.status == '1') {
                filter_stud_Class()
                // $("#student_table").load('display_student_table.php')
                setTimeout($("#add_student_modal").modal("hide"), 200)
                $("#add_student_data_warning").html('')
                $("#add_student_data_warning").hide()
                event.target.reset()
                toastr.success('Added successfully')
                $('.search_parentphone').val(null).trigger('change')
            } else {
                $("#add_student_data_warning").html(data.err)
                $("#add_student_data_warning").show()
            }
        },
        complete: () => {
            $("#add_student_btn").attr("disabled", false)
            $("#add_student_btn").html("Register")
        }
    });
}
// alert('kk')

function update_class_data(event) {
    event.preventDefault()
    let formdata = new FormData(event.target);
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        success: (data) => {
            data = JSON.parse(data)
            if (data.status == '1') {
                $("#class_table").load(`../display_class_table.php${data.is_graduate ? '?is_g_table=1' : ''}`)
                setTimeout($("#edit_class_modal").modal("hide"), 200)
                // toastr.success("Updated Successfully")
            }
        },
        error: (xhr, status, error) => {
            console.error('Error: ' + error);
        }
    });
}

function update_parent_data(event) {
    event.preventDefault()
    let formdata = new FormData(event.target);
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $("#update_parent_submit_btn").html('Processing')
            $("#update_parent_submit_btn").attr('disabled', true)
        },
        success: (data) => {
            data = JSON.parse(data)

            if (data.status == '1') {
                // $("#staff_tables").load('display_staff_table.php')
                setTimeout($("#edit_parent_modal").modal("hide"), 200)
                toastr.success("Updated Successfully")
                if ($("#profile_page").val() === 'display_parent_profile') {
                    $("#profile_placeholder").load("../display_parent_profile.php")
                }
            } else {
                $("#add_parent_data_warning").show().html(data.err)
            }
        },
        complete: () => {
            $("#update_parent_submit_btn").html('Update Now')
            $("#update_parent_submit_btn").attr('disabled', false)
        },
        error: (xhr, status, error) => {
            console.error('Error: ' + error);
        }
    });
}
function update_staff_data(event) {
    event.preventDefault()
    let formdata = new FormData(event.target);
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $("#update_staff_submit_btn").html('Processing')
            $("#update_staff_submit_btn").attr('disabled', true)
        },
        success: (data) => {
            data = JSON.parse(data)
            $("#update_staff_submit_btn").html('Update')
            $("#update_staff_submit_btn").attr('disabled', true)
            if (data.status == '1') {
                $("#staff_tables").load('../display_staff_table.php')
                setTimeout($("#edit_staff_modal").modal("hide"), 200)
                toastr.success("Updated Successfully")
            }
            if ($("#profile_page").val() === 'display_profile') {
                $("#profile_placeholder").load("../display_profile.php")
            }
        },
        error: (xhr, status, error) => {
            console.error('Error: ' + error);
        }
    });
}
function update_student_data(event) {
    event.preventDefault()
    let formdata = new FormData(event.target);
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $("#update_student_btn").attr('disabled', false)
        },
        success: (data) => {
            data = JSON.parse(data)
            $("#update_student_btn").attr('disabled', false)
            if (data.status == '1') {
                filter_stud_Class()
                // $("#student_table").load('../display_student_table.php')
                setTimeout($("#edit_student_modal").modal("hide"), 200)
                toastr.success("Updated Successfully")
            }
        }
    });
}


// alert('ll')
function update_subject(event) {

    // alert('llll')
    // $(".update_subject_form").submit(function (event) {
    event.preventDefault();
    const checkboxes = document.querySelectorAll('.subject_checkbox');
    let subjectsList = [];


    checkboxes.forEach((checkbox) => {
        if (checkbox.checked) {
            const id = checkbox.value;
            if (!subjectsList.includes(id)) {
                subjectsList.push(id);
            }
        }
    });

    console.log(subjectsList);

    $.ajax({
        url: "../controller.php",
        type: "post",
        data: {
            action: "update_school_subject",
            subjectsList: JSON.stringify(subjectsList)
        },
        success: (data) => {
            console.log(data);
            data = JSON.parse(data);
            if (data.status == '1') {
                toastr.success(data.msg);
            } else {
                toastr.error(data.err);
            }
        }
    });
    // });
}

// alert('ghl')
$(".settingsform").submit(function (event) {
    event.preventDefault();
    let grade_letter = document.querySelectorAll(".grade_letter")
    let grade_value = document.querySelectorAll(".grade_value")
    const thegrades = {}
    for (let i = 0; i < grade_letter.length; i++) {
        thegrades[grade_letter[i].value] = grade_value[i].value
    }
    let formdata = new FormData(this);
    formdata.append('term_id', $(".select_btn.term_setting.active").attr("data-name"))
    formdata.append('grades', JSON.stringify(thegrades))

    // formdata.append('subjects_status', JSON.stringify(subjectsStatus));

    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        success: (data) => {
            data = JSON.parse(data);
            if (data.status == '1') {
                toastr.success(data.msg);
            } else {
                toastr.error(data.err);
            }
        }
    });
});


function transfer_student_modal(event, tableId, page) {
    event.preventDefault();
    // alert('ll')
    let formdata = new FormData(event.target);  // Use 'event' instead of 'this'

    $.ajax({
        url: '../controller.php',  // Use the form's action attribute
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        success: (data) => {
            data = JSON.parse(data);
            if (data.status == '1') {
                $(event.target).parents('.modal').modal("hide");  // Hide the modal
                filter_stud_Class()
                // $("#student_table")
                // $("#" + tableId).load(page, function () {
                $(".action_btn").hide()
                $("#select_all").prop('checked', false)
                // $('.select2').val(null).trigger('change')
                toastr.success(data.msg);
                // });
            } else {
                $(event.target).find('.warning').show().html(data.err);
            }
        }
    });
}




$(".form").submit(function (event) {
    event.preventDefault();
    let formdata = new FormData(this);
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        success: (data) => {
            data = JSON.parse(data)
            if (data.status == '1') {
                toastr.success(data.msg)
            }
            else {
                toastr.error(data.err)
            }
        }
    });
});
// alert('kk')
const savepath = () => {
    const thepath = location.pathname.split('/')
    if (thepath[thepath.length - 1] != 'login' && thepath[thepath.length - 1]) {
        localStorage.setItem('myurl', window.location.href)
    } else {
        if (localStorage.getItem('myurl')) {
            localStorage.removeItem('myurl');
        }
    }

}
savepath()
$(".loginform").submit(function (event) {
    event.preventDefault();
    var $form = $(this);
    var $url = $form.attr("action");
    let $btn = $form.find(".staff_login_btn")
    let $btntext = $btn.html()
    let formdata = new FormData(this);
    $.ajax({
        url: $url,
        type: "post",
        data: formdata,
        contentType: false,
        processData: false,
        beforeSend: () => {
            $($btn).attr("disabled", true)
            $($btn).html("Processing")
        },
        success: (data) => {
            $($btn).attr("disabled", false)
            $($btn).html($btntext)
            // data = JSON.parse(data)
            if (data.status == '1') {
                // alert(data.location)
                // alert(localStorage.getItem("myurl"))

                window.location = `./${data.location}`

                // window.location = `./${data.location}`
            }
            else {
                toastr.error(data.err);
            }
        }
    });
});


function get_note_week_create(element = true) {
    $("#week_btns_container").html(
        `
        <label for="" class="mb-2 text-dark">Select Week</label>
            <div class="week_btns d-flex flex-wrap" style="gap:15px;">
                <button type="button" class="btn week_btn select_btn active" data-id="1" onclick="toggle_week_btn(this, ${element})">${element ? '1' : 'Week 1'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="2" onclick="toggle_week_btn(this, ${element})">${element ? '2' : 'Week 2'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="3" onclick="toggle_week_btn(this, ${element})">${element ? '3' : 'Week 3'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="4" onclick="toggle_week_btn(this, ${element})">${element ? '4' : 'Week 4'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="5" onclick="toggle_week_btn(this, ${element})">${element ? '5' : 'Week 5'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="6" onclick="toggle_week_btn(this, ${element})">${element ? '6' : 'Week 6'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="7" onclick="toggle_week_btn(this, ${element})">${element ? '7' : 'Week 7'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="8" onclick="toggle_week_btn(this, ${element})">${element ? '8' : 'Week 8'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="9" onclick="toggle_week_btn(this, ${element})">${element ? '9' : 'Week 9'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="10" onclick="toggle_week_btn(this, ${element})">${element ? '10' : 'Week 10'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="11" onclick="toggle_week_btn(this, ${element})">${element ? '11' : 'Week 11'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="12" onclick="toggle_week_btn(this, ${element})">${element ? '12' : 'Week 12'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="13" onclick="toggle_week_btn(this, ${element})">${element ? '13' : 'Week 13'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="14" onclick="toggle_week_btn(this, ${element})">${element ? '14' : 'Week 14'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="15" onclick="toggle_week_btn(this, ${element})">${element ? '15' : 'Week 15'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="16" onclick="toggle_week_btn(this, ${element})">${element ? '16' : 'Week 16'}</button>
                <button type="button" class="btn week_btn select_btn" data-id="17" onclick="toggle_week_btn(this, ${element})">${element ? '17' : 'Week 17'}</button>
        </div>
        `
    )
    setTimeout(get_notes_week_view, 100)
    setTimeout(() => get_lesson_note(element), 100)
    setTimeout(() => {
        // ensure a lesson term is selected (default to first) before loading weeks
        if ($('.lesson_term.select_btn').length && !$('.lesson_term.select_btn.active').length) {
            $('.lesson_term.select_btn').first().addClass('active');
        }
    }, 10);
}


function get_notes_week_view() {
    if (!$("#select_class_field").val() || !$("#select_subject_field").val() || !$(".week_btn.active").attr("data-id")) {
        return false;
    }
    $.ajax({
        url: "../controller.php",
        type: 'post',
        data: {
            "class_id": $("#select_class_field").val(),
            "subject_id": $("#select_subject_field").val(),
            "term_id": $('.lesson_term.select_btn.active').attr('data-name') || $('.term.select_btn.active').attr('data-name') || '',

            'action': 'get_note_weeks'
        },
        success: (data) => {
            console.log(data)
            // alert(data)
            data = JSON.parse(data)
            const week_ids = Array.from(document.querySelectorAll(".week_btn.select_btn"));

            week_ids.forEach((item) => {
                if (data.includes(item.getAttribute("data-id"))) {
                    if (item.hasAttributes("data-id")) {
                        item.classList.add("accent_active")
                    }
                }
            })
        }
    })
}

function get_lesson_note(element = true) {
    setTimeout(element ? get_lesson_note_topic : get_class_note_topic, 100)
    setTimeout(element ? get_lesson_note_body : get_class_note_body, 100)
}
function toggle_week_btn(event, staff = true) {
    $(".week_btn.select_btn").removeClass("active")
    $(event).addClass("active")
    get_lesson_note(staff)
}
function toggle_lesson_term(event) {
    $(".lesson_term.select_btn").removeClass("active");
    $(event).addClass("active");
    // reload weeks and lesson content for the selected term
    get_note_week_create();
    get_lesson_note(true);
}
function toggle_subject_btn(event, staff = true) {
    $(".subject_btn.select_btn").removeClass("active")
    $(event).addClass("active")
    get_lesson_note(staff)
}




let editorInstance;


function get_class_note_topic() {
    // const week_ids = Array.from(document.querySelectorAll(".week_btn.active")).map((item) => item.getAttribute("data-id"));
    if (!$("#select_class_student").val() || !$(".subject_btn.select_btn.active").attr("data-id") || !$(".week_btn.active").attr("data-id")) {
        return false;
    }

    $("#note_container_topic").html(`
        <div class="mt-4">
        <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                <h5>Topic</h5>
                <p id="lesson_topic_view" style="background-color: #fcfcfc; padding-top: 10px; padding-bottom: 10px; padding-left: 10px; padding-right: 10px; border-radius: 5px;"><i>Nothing here yet</i></p>
            </div>
        </div>
    `);

    $.ajax({
        url: "../controller.php",
        type: "post",
        data: {
            "class_id": $("#select_class_student").val(),
            "subject_id": $(".subject_btn.select_btn.active").attr("data-id"),
            "week_id": $(".week_btn.active").attr("data-id"),
            term_id: $('.lesson_term.select_btn.active').attr('data-name') || $('.term.select_btn.active').attr('data-name') || '',

            "type": 'topic',
            "action": "get_lesson_note"
        },
        beforeSend: () => {
            $("#lesson_topic_view").html("Loading...")
        },
        success: (response) => {
            const data = !response ? '' : JSON.parse(response);
            $("#lesson_topic").val(data.topic || '');
            $("#lesson_topic_view").html(data.topic || "<i>Nothing here yet</i>");
        },
        error: (error) => {
            console.error("Error fetching lesson note:", error);
        }
    });
}
function get_lesson_note_topic() {
    // const week_ids = Array.from(document.querySelectorAll(".week_btn.active")).map((item) => item.getAttribute("data-id"));
    if (!$("#select_class_field").val() || !$("#select_subject_field").val() || !$(".week_btn.active").attr("data-id")) {
        return false;
    }

    $("#note_container_topic").html(`
        <div class="mt-4">
            <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                <div class="form-group mb-0 w-100" id="lesson_note_topic_editor" style="display:none;">
                    <label class="">Topic</label>
                    <input type="text" id="lesson_topic" value="" class="form-control">
                    <div class="d-flex mt-3">
                        <button type="button" class="btn btn-primary mr-3" onclick="create_lesson_note_topic()">Save changes</button>
                        <button type="button" class="btn btn-outline-primary" onclick="show_lesson_note_topic_view()">Cancel editing</button>
                    </div>
                </div>

                <div class="form-group mb-0 w-100" id="lesson_note_topic_body" style="display:inline-block">
                    <label class="">Topic</label>
                    <p id="lesson_topic_view" style="background-color: #fcfcfc; padding-top: 10px; padding-bottom: 10px; padding-left: 10px; padding-right: 10px; border-radius: 5px;"><i>Nothing here yet</i></p>
                    <a onclick="show_lesson_note_topic_editor()" class="btn accent pl-0 pr-5 d-flex align-items-center">Edit topic</a>
                </div>
            </div>
        </div>
    `);

    $.ajax({
        url: "../controller.php",
        type: "post",
        data: {
            "class_id": $("#select_class_field").val(),
            "subject_id": $("#select_subject_field").val(),
            "week_id": $(".week_btn.active").attr("data-id"),
            "term_id": $('.lesson_term.select_btn.active').attr('data-name') || $('.term.select_btn.active').attr('data-name') || '',

            "type": 'topic',
            "action": "get_lesson_note"
        },
        beforeSend: () => {
            $("#lesson_topic_view").html("Loading...")
        },
        success: (response) => {
            const data = !response ? '' : JSON.parse(response);
            $("#lesson_topic").val(data.topic || '');
            $("#lesson_topic_view").html(data.topic || "<i>Nothing here yet</i>");
        },
        error: (error) => {
            console.error("Error fetching lesson note:", error);
        }
    });
}
// alert("moocd")
function get_class_note_body() {
    if (!$("#select_class_student").val() || !$(".subject_btn.select_btn.active").attr("data-id") || !$(".week_btn.active").attr("data-id")) {
        return false;
    }
    console.log("mmpemcy")
    $("#note_container_body").html(`
        
                    <div class="mt-4">
                        <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                        <h5>Note</h5>    
                        <div id="lesson_body_view"></div>
                        </div>
                    </div>
        
    `);
    $.ajax({
        url: "../controller.php",
        type: "post",
        data: {
            "class_id": $("#select_class_student").val(),
            "subject_id": $(".subject_btn.select_btn.active").attr("data-id"),
            "week_id": $(".week_btn.active").attr("data-id"),
            "term_id": $('.lesson_term.select_btn.active').attr('data-name') || $('.term.select_btn.active').attr('data-name') || '',

            'type': 'body',
            "action": "get_lesson_note"
        },
        beforeSend: () => {
            $("#lesson_body_view").html("Loading...")
        },
        success: (response) => {
            console.log("Response:", response);
            const data = !response ? '' : JSON.parse(response);
            // editorInstance.setData(data.content || '');
            console.log("data", data)
            // Extract all sections between <{ and }> (including HTML-escaped variants) and concatenate them
            function extractAllInnerMarkers(content) {
                if (!content || typeof content !== 'string') return '';
                // First produce an "unescaped" version where &lt; and &gt; are restored
                const unescapedContent = content.replace(/&lt;/g, '<').replace(/&gt;/g, '>');
                const results = [];

                // Use a global regex on the unescaped content to capture all marker blocks
                const regex = /<\{([\s\S]*?)\}>/g;
                let m;
                while ((m = regex.exec(unescapedContent)) !== null) {
                    if (m[1]) {
                        // Trim outer whitespace but preserve inner HTML tags
                        results.push(m[1].trim());
                    }
                    if (regex.lastIndex === m.index) regex.lastIndex++;
                }

                // Remove duplicates while preserving order
                const seen = new Set();
                const unique = results.filter(item => {
                    if (seen.has(item)) return false;
                    seen.add(item);
                    return true;
                });

                // Join with spacing. The resulting string should contain HTML tags ready for insertion via .html()
                return unique.join('\n\n');
            }

            const extractedAll = extractAllInnerMarkers(data.content || '');
            console.log(extractedAll)
            $("#lesson_body_view").html(extractedAll || "<i>No content here yet</i>");

        },
        error: (error) => {
            console.error("Error fetching lesson note:", error);
        }
    });
}
// function get_lesson_note_body() {
//     if (!$("#select_class_field").val() || !$("#select_subject_field").val() || !$(".week_btn.active").attr("data-id")) {
//         return false;
//     }
//     if (editorInstance) {
//         editorInstance.destroy()
//             .then(() => {
//                 console.log("Editor destroyed");
//             })
//             .catch(error => {
//                 console.error("Error destroying editor:", error);
//             });
//     }

//     $("#note_container_body").html(`

//                     <div class="mt-4">
//                         <div class="py-3 px-15 bg-white" style="border-radius: 10px;">

//                             <div class="form-group mb-0 w-100" id="lesson_note_body_editor" style="display:none;">
//                                 <label class="">Content</label>
//                                 <textarea id="lesson_body" name=""></textarea>
//                                 <div class="d-flex mt-3">
//                                     <button type="button" class="btn btn-primary mr-3" onclick="create_lesson_note_body()">Save changes</button>
//                                     <button type="button" class="btn btn-outline-primary" onclick="show_lesson_note_body()">Cancel editing</button>
//                                 </div>
//                             </div>
//                             <div class="form-group mb-0 w-100" id="lesson_note_body_view" style="display: inline-block;">
//                                 <label class="">Content</label>
//                                 <div id="lesson_body_view" style="background-color: #fcfcfc; padding-top: 10px; padding-bottom: 10px; padding-left: 10px; padding-right: 10px; border-radius: 5px;">        
//                                 <i>No content here yet</i>
//                                 </div>
//                                 <a onclick="show_lesson_note_body_editor()" class="btn accent pl-0 pr-5 d-flex align-items-center">Edit content</a>
//                             </div>
//                         </div>
//                     </div>

//     `);

//     ClassicEditor.create(document.querySelector("#lesson_body"), {
//         toolbar: {
//             shouldNotGroupWhenFull: true,
//             items: [
//                 'heading', 'bold', 'italic', 'underline', 'strikethrough',
//                 '|', 'bulletedList', 'numberedList', 'alignment',
//                 '|', 'blockQuote', 'link', 'undo', 'redo',
//                 '|', 'fontSize', 'fontColor', 'fontBackgroundColor', 'insertTable', 'imageUpload'
//             ]
//         },
//         // Enable image upload via SimpleUpload adapter. Remove heavy/unused plugins but keep image upload support.
//         removePlugins: ['MediaEmbed', 'EasyImage', 'CKFinder'],
//         simpleUpload: {
//             // Upload URL: controller will handle uploads when action=upload_lesson_image
//             uploadUrl: '../controller.php?action=upload_lesson_image',
//             // Optional headers (e.g., CSRF) can be added here if needed:
//             // headers: { 'X-CSRF-TOKEN': 'CSRF-Token' }
//         },
//         heading: {
//             options: [
//                 { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
//                 { model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1' },
//                 { model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2' },
//                 { model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3' },
//             ]
//         }
//     })
//         .then(editor => {
//             editorInstance = editor;
//             editorInstance.setData(''); // Set initial data
//             console.log("Editor initialized successfully!");
//             // Provide a fallback image upload control when the CKEditor upload adapter/plugin
//             // is not available (filerepository-no-upload-adapter). This allows users to upload
//             // an image via a simple file input and insert it into the editor content.
//             try {
//                 const viewEl = document.querySelector('#lesson_note_body_view');
//                 if (viewEl) {
//                     let uploadGroup = document.getElementById('lesson_image_upload_group');
//                     if (!uploadGroup) {
//                         uploadGroup = document.createElement('div');
//                         uploadGroup.id = 'lesson_image_upload_group';
//                         uploadGroup.style.marginTop = '8px';
//                         uploadGroup.innerHTML = `
//                             <input type="file" id="lesson_image_input" accept="image/*" style="display:none;">
//                             <button type="button" id="lesson_image_btn" class="btn btn-sm btn-secondary">Upload Image</button>
//                             <span id="lesson_image_status" style="margin-left:10px"></span>
//                             <div id="lesson_image_progress_wrap" style="margin-top:8px; display:none;">
//                                 <div style="height:6px; background:#e9ecef; border-radius:3px; overflow:hidden;">
//                                     <div id="lesson_image_progress" style="height:6px; width:0%; background:#007bff;"></div>
//                                 </div>
//                                 <div style="font-size:12px; margin-top:4px; color:#666; display:flex; justify-content:space-between;">
//                                     <span id="lesson_image_progress_text">0 B of 2 MB used</span>
//                                     <button type="button" id="lesson_image_reset" class="btn btn-sm btn-link" style="padding:0;">Reset</button>
//                                 </div>
//                             </div>
//                         `;
//                         // Insert upload controls after the view element
//                         viewEl.parentNode.insertBefore(uploadGroup, viewEl.nextSibling);

//                         const fileInput = document.getElementById('lesson_image_input');
//                         const uploadBtn = document.getElementById('lesson_image_btn');
//                         const statusEl = document.getElementById('lesson_image_status');

//                         uploadBtn.addEventListener('click', function () {
//                             fileInput.click();
//                         });

//                         // initialize global tracking state if not present
//                         if (!window.lessonImageUploadState) {
//                             window.lessonImageUploadState = {
//                                 maxTotal: 2 * 1024 * 1024, // 2 MB
//                                 used: 0,
//                                 inProgress: false,
//                                 // store names of files uploaded in this session
//                                 files: []
//                             };
//                         }

//                         const progressWrap = document.getElementById('lesson_image_progress_wrap');
//                         const progressBar = document.getElementById('lesson_image_progress');
//                         const progressText = document.getElementById('lesson_image_progress_text');
//                         const resetBtn = document.getElementById('lesson_image_reset');

//                         function updateProgressUI() {
//                             const used = window.lessonImageUploadState.used || 0;
//                             const max = window.lessonImageUploadState.maxTotal;
//                             const pct = Math.min(100, Math.round((used / max) * 100));
//                             progressBar.style.width = pct + '%';
//                             progressText.textContent = bytesToHuman(used) + ' of ' + bytesToHuman(max) + ' used';
//                             if (used >= max) {
//                                 uploadBtn.disabled = true;
//                                 uploadBtn.classList.add('disabled');
//                             } else {
//                                 uploadBtn.disabled = false;
//                                 uploadBtn.classList.remove('disabled');
//                             }
//                             progressWrap.style.display = used > 0 ? 'block' : 'none';
//                         }

//                         resetBtn.addEventListener('click', function () {
//                             window.lessonImageUploadState.used = 0;
//                             updateProgressUI();
//                         });

//                         function bytesToHuman(n) {
//                             if (n < 1024) return n + ' B';
//                             if (n < 1024 * 1024) return (n / 1024).toFixed(1) + ' KB';
//                             return (n / (1024 * 1024)).toFixed(2) + ' MB';
//                         }

//                         fileInput.addEventListener('change', function (e) {
//                             const file = this.files && this.files[0];
//                             if (!file) return;

//                             // Check remaining quota
//                             const state = window.lessonImageUploadState;
//                             const remaining = state.maxTotal - (state.used || 0);
//                             if (file.size > remaining) {
//                                 statusEl.textContent = 'File too large for remaining quota';
//                                 return;
//                             }

//                             statusEl.textContent = 'Uploading...';
//                             progressWrap.style.display = 'block';

//                             const xhr = new XMLHttpRequest();
//                             const form = new FormData();
//                             form.append('image', file);

//                             xhr.open('POST', '../upload_image.php');

//                             // progress for this upload
//                             xhr.upload.addEventListener('progress', function (ev) {
//                                 if (ev.lengthComputable) {
//                                     const percent = Math.round((ev.loaded / ev.total) * 100);
//                                     // show progress towards this file only
//                                     progressBar.style.width = percent + '%';
//                                     progressText.textContent = bytesToHuman((state.used || 0) + ev.loaded) + ' of ' + bytesToHuman(state.maxTotal) + ' used';
//                                 }
//                             });

//                             xhr.addEventListener('load', function () {
//                                 try {
//                                     const resp = JSON.parse(xhr.responseText);
//                                         if (xhr.status >= 200 && xhr.status < 300 && resp && resp.url) {
//                                         // commit usage
//                                         state.used = (state.used || 0) + file.size;
//                                         // record uploaded filename (server returns 'name') or fallback to parsing from url
//                                         if (resp.name) {
//                                             state.files.push(resp.name);
//                                         } else if (resp.url) {
//                                             try {
//                                                 const parts = resp.url.split('/');
//                                                 const base = parts[parts.length - 1].split('?')[0];
//                                                 if (base) state.files.push(base);
//                                             } catch (e) {}
//                                         }
//                                         updateProgressUI();

//                                         const insertImageByUrl = (url) => {
//                                             try {
//                                                 if (editorInstance && editorInstance.model && editorInstance.model.schema && editorInstance.model.schema.checkChild) {
//                                                     editorInstance.model.change(writer => {
//                                                         const imageElement = writer.createElement('imageBlock', { src: url });
//                                                         editorInstance.model.insertContent(imageElement, editorInstance.model.document.selection);
//                                                     });
//                                                 } else if (editorInstance && typeof editorInstance.execute === 'function') {
//                                                     try {
//                                                         editorInstance.execute('imageInsert', { source: url });
//                                                     } catch (e) {
//                                                         const current = editorInstance.getData();
//                                                         editorInstance.setData(current + `<p><img src="${url}"/></p>`);
//                                                     }
//                                                 } else {
//                                                     const current = editorInstance.getData ? editorInstance.getData() : '';
//                                                     if (typeof editorInstance.setData === 'function') {
//                                                         editorInstance.setData(current + `<p><img src="${url}"/></p>`);
//                                                     }
//                                                 }
//                                                 statusEl.textContent = 'Uploaded';
//                                             } catch (err) {
//                                                 try {
//                                                     const current = editorInstance.getData();
//                                                     editorInstance.setData(current + `<p><img src="${url}"/></p>`);
//                                                     statusEl.textContent = 'Uploaded (fallback)';
//                                                 } catch (err2) {
//                                                     console.error('Insert image error', err2);
//                                                     statusEl.textContent = 'Uploaded but insert failed';
//                                                 }
//                                             }
//                                         };

//                                         insertImageByUrl(resp.url);
//                                     } else {
//                                         statusEl.textContent = resp && resp.error ? (resp.error.message || resp.error) : 'Upload failed';
//                                     }
//                                 } catch (err) {
//                                     console.error('Upload parse error', err, xhr.responseText);
//                                     statusEl.textContent = 'Upload error';
//                                 }
//                             });

//                             xhr.addEventListener('error', function (ev) {
//                                 console.error('XHR upload error', ev);
//                                 statusEl.textContent = 'Upload error';
//                             });

//                             xhr.send(form);
//                         });
//                     }
//                 }
//             } catch (e) {
//                 console.error('Fallback upload init error', e);
//             }

//             // --- Image resize toolbar ---
//             try {
//                 // Create floating toolbar element
//                 let imgToolbar = document.getElementById('ck_img_resize_toolbar');
//                 if (!imgToolbar) {
//                     imgToolbar = document.createElement('div');
//                     imgToolbar.id = 'ck_img_resize_toolbar';
//                     imgToolbar.style.position = 'absolute';
//                     imgToolbar.style.display = 'none';
//                     imgToolbar.style.zIndex = 9999;
//                     imgToolbar.style.background = '#fff';
//                     imgToolbar.style.border = '1px solid #ddd';
//                     imgToolbar.style.padding = '6px';
//                     imgToolbar.style.borderRadius = '4px';
//                     imgToolbar.style.boxShadow = '0 2px 6px rgba(0,0,0,0.15)';
//                     imgToolbar.innerHTML = `
//                         <button class="btn btn-sm btn-light ck-img-size-btn" data-size="25">25%</button>
//                         <button class="btn btn-sm btn-light ck-img-size-btn" data-size="50">50%</button>
//                         <button class="btn btn-sm btn-light ck-img-size-btn" data-size="75">75%</button>
//                         <button class="btn btn-sm btn-light ck-img-size-btn" data-size="100">100%</button>
//                         <input id="ck_img_custom_px" type="number" placeholder="px" style="width:64px; margin-left:6px;" />
//                         <button class="btn btn-sm btn-primary" id="ck_img_apply_px" style="margin-left:6px;">Apply</button>
//                         <button class="btn btn-sm btn-outline-secondary" id="ck_img_remove_style" style="margin-left:6px;">Reset</button>
//                     `;
//                     document.body.appendChild(imgToolbar);
//                 }

//                 let currentImage = null;

//                 // Helper to position toolbar near an element
//                 function positionToolbarForElement(el) {
//                     const rect = el.getBoundingClientRect();
//                     const toolbarRect = imgToolbar.getBoundingClientRect();
//                     // place above the image if possible
//                     let top = window.scrollY + rect.top - toolbarRect.height - 8;
//                     if (top < window.scrollY + 5) top = window.scrollY + rect.bottom + 8; // below if not enough space
//                     let left = window.scrollX + rect.left;
//                     imgToolbar.style.top = top + 'px';
//                     imgToolbar.style.left = left + 'px';
//                     imgToolbar.style.display = 'block';
//                 }

//                 // Click handler inside the editor to detect images
//                 const editable = editor.ui ? editor.ui.view.editable.element : document.querySelector('.ck-editor__editable');
//                 if (editable) {
//                     editable.addEventListener('click', function (ev) {
//                         const target = ev.target;
//                         if (target && target.tagName && target.tagName.toLowerCase() === 'img') {
//                             currentImage = target;
//                             positionToolbarForElement(target);
//                             // Pre-fill custom px with current width (if set as px)
//                             const width = target.style.width || target.getAttribute('width') || '';
//                             const px = width && width.indexOf('%') === -1 ? parseInt(width, 10) || '' : '';
//                             document.getElementById('ck_img_custom_px').value = px;
//                         } else {
//                             currentImage = null;
//                             imgToolbar.style.display = 'none';
//                         }
//                     });

//                     // Hide toolbar when clicking elsewhere
//                     document.addEventListener('click', function (ev) {
//                         if (!imgToolbar.contains(ev.target) && !editable.contains(ev.target)) {
//                             imgToolbar.style.display = 'none';
//                             currentImage = null;
//                         }
//                     });

//                     // Toolbar button handlers
//                     imgToolbar.addEventListener('click', function (ev) {
//                         const btn = ev.target.closest('.ck-img-size-btn');
//                         if (btn && currentImage) {
//                             const size = btn.getAttribute('data-size');
//                             currentImage.style.width = size + '%';
//                             // reflect change into editor model if possible
//                             try { currentImage.removeAttribute('height'); } catch (e) {}
//                         }
//                         if (ev.target && ev.target.id === 'ck_img_apply_px' && currentImage) {
//                             const val = parseInt(document.getElementById('ck_img_custom_px').value, 10);
//                             if (!isNaN(val) && val > 0) {
//                                 currentImage.style.width = val + 'px';
//                             }
//                         }
//                         if (ev.target && ev.target.id === 'ck_img_remove_style' && currentImage) {
//                             currentImage.style.width = '';
//                             currentImage.removeAttribute('width');
//                         }
//                     });
//                 }
//             } catch (e) {
//                 console.error('Image toolbar init error', e);
//             }
//         })
//         .catch(error => {
//             console.error("Error initializing editor:", error);
//         });




//     $.ajax({
//         url: "../controller.php",
//         type: "post",
//         data: {
//             "class_id": $("#select_class_field").val(),
//             "subject_id": $("#select_subject_field").val(),
//             "week_id": $(".week_btn.active").attr("data-id"),
//             'type': 'body',
//             "action": "get_lesson_note"
//         },
//         beforeSend: () => {
//             $("#lesson_body_view").html("Loading...")
//         },
//         success: (response) => {
//             const data = !response ? '' : JSON.parse(response);
//             // Keep the full content in the editor and show full content in the view
//             editorInstance.setData(data.content || '');
//             $("#lesson_body_view").html(data.content || "<i>No content here yet</i>");

//         },
//         error: (error) => {
//             console.error("Error fetching lesson note:", error);
//         }
//     });
// }

function populate_multi_class_select(targetId = "#lesson_note_multi_class") {
    const $target = $(targetId);
    const currentClass = $("#select_class_field").val();
    $.ajax({
        url: "../controller.php",
        type: "POST",
        data: {
            action: "get_classes_for_lesson_note",
        },
        success: function (response) {
            if (!response) return;
            try {
                console.log(response);
                const json = JSON.parse(response);
                if (json.status == "1" && json.data) {
                    $target.empty();
                    json.data.forEach(function (cls) {
                        $target.append(new Option(cls.classname, cls.id));
                    });
                    if ($target.hasClass("select2-hidden-accessible")) {
                        $target.select2("destroy");
                    }
                    $target.select2();
                    // Pre-select the current class if it exists in the new list
                    if (currentClass) {
                        $target.val([currentClass]).trigger("change");
                    }
                }
            } catch (e) {
                console.error("Error parsing classes:", e);
            }
        },
        error: function (err) {
            console.error("Error fetching classes:", err);
        },
    });
}


// function get_lesson_note_body() {
//     if (!$("#select_class_field").val() || !$("#select_subject_field").val() || !$(".week_btn.active").attr("data-id")) {
//         return false;
//     }
//     // Only inject the editor/view markup and initialize CKEditor once. Subsequent
//     // calls will reuse the same editor instance and only update the view content.
//     if ($("#note_container_body").children().length === 0) {
//         $("#note_container_body").html(`

//                     <div class="mt-4">
//                         <div class="py-3 px-15 bg-white" style="border-radius: 10px;">

//                             <div class="form-group mb-0 w-100" id="lesson_note_body_editor" style="display:none;">
//                                 <label class="">Content</label>
//                                 <textarea id="lesson_body" name=""></textarea>
//                                 <div class="d-flex mt-3">
//                                     <button type="button" class="btn btn-primary mr-3" onclick="create_lesson_note_body()">Save changes</button>
//                                     <button type="button" class="btn btn-outline-primary" onclick="show_lesson_note_body()">Cancel editing</button>
//                                 </div>
//                             </div>
//                             <div class="form-group mb-0 w-100" id="lesson_note_body_view" style="display: inline-block;">
//                                 <label class="">Content</label>
//                                 <div id="lesson_body_view" style="background-color: #fcfcfc; padding-top: 10px; padding-bottom: 10px; padding-left: 10px; padding-right: 10px; border-radius: 5px;">        
//                                 <i>No content here yet</i>
//                                 </div>
//                                 <a onclick="show_lesson_note_body_editor()" class="btn accent pl-0 pr-5 d-flex align-items-center">Edit content</a>
//                             </div>
//                         </div>
//                     </div>

//     `);

//     ClassicEditor.create(document.querySelector("#lesson_body"), {
//         toolbar: {
//             shouldNotGroupWhenFull: true,
//             items: [
//                 'heading', 'bold', 'italic', 'underline', 'strikethrough',
//                 '|', 'bulletedList', 'numberedList', 'alignment',
//                 '|', 'blockQuote', 'link', 'undo', 'redo',
//                 '|', 'fontSize', 'fontColor', 'fontBackgroundColor', 'insertTable', 'imageUpload'
//             ]
//         },
//         // Enable image upload via SimpleUpload adapter. Remove heavy/unused plugins but keep image upload support.
//         removePlugins: ['MediaEmbed', 'EasyImage', 'CKFinder'],
//         simpleUpload: {
//             // Upload URL: controller will handle uploads when action=upload_lesson_image
//             uploadUrl: '../controller.php?action=upload_lesson_image',
//             // Optional headers (e.g., CSRF) can be added here if needed:
//             // headers: { 'X-CSRF-TOKEN': 'CSRF-Token' }
//         },
//         heading: {
//             options: [
//                 { model: 'paragraph', title: 'Paragraph', class: 'ck-heading_paragraph' },
//                 { model: 'heading1', view: 'h1', title: 'Heading 1', class: 'ck-heading_heading1' },
//                 { model: 'heading2', view: 'h2', title: 'Heading 2', class: 'ck-heading_heading2' },
//                 { model: 'heading3', view: 'h3', title: 'Heading 3', class: 'ck-heading_heading3' },
//             ]
//         }
//     })
//         .then(editor => {
//             editorInstance = editor;
//             editorInstance.setData(''); // Set initial data
//             // Start editor in read-only mode (view mode). Editing is toggled via
//             // show_lesson_note_body_editor() which sets isReadOnly = false.
//             try { editorInstance.isReadOnly = true; } catch (e) {}
//             // If a pending body was stored (user clicked Edit before editor ready), restore it
//             try {
//                 if (window.__pendingLessonBody && typeof editorInstance.setData === 'function') {
//                     editorInstance.setData(window.__pendingLessonBody);
//                     window.__pendingLessonBody = null;
//                 }
//             } catch (e) {
//                 console.warn('Could not apply pending lesson body to editor:', e);
//             }
//             console.log("Editor initialized successfully!");
//             // Provide a fallback image upload control when the CKEditor upload adapter/plugin
//             // is not available (filerepository-no-upload-adapter). This allows users to upload
//             // an image via a simple file input and insert it into the editor content.
//             try {
//                 const viewEl = document.querySelector('#lesson_note_body_view');
//                 if (viewEl) {
//                     let uploadGroup = document.getElementById('lesson_image_upload_group');
//                     if (!uploadGroup) {
//                         uploadGroup = document.createElement('div');
//                         uploadGroup.id = 'lesson_image_upload_group';
//                         uploadGroup.style.marginTop = '8px';
//                         uploadGroup.innerHTML = `
//                             <input type="file" id="lesson_image_input" accept="image/*" style="display:none;">
//                             <button type="button" id="lesson_image_btn" class="btn btn-sm btn-secondary">Upload Image</button>
//                             <span id="lesson_image_status" style="margin-left:10px"></span>
//                             <div id="lesson_image_progress_wrap" style="margin-top:8px; display:none;">
//                                 <div style="height:6px; background:#e9ecef; border-radius:3px; overflow:hidden;">
//                                     <div id="lesson_image_progress" style="height:6px; width:0%; background:#007bff;"></div>
//                                 </div>
//                                 <div style="font-size:12px; margin-top:4px; color:#666; display:flex; justify-content:space-between;">
//                                     <span id="lesson_image_progress_text">0 B of 2 MB used</span>
//                                     <button type="button" id="lesson_image_reset" class="btn btn-sm btn-link d-none" style="padding:0;">Reset</button>
//                                 </div>
//                             </div>
//                         `;
//                         // Insert upload controls after the view element
//                         viewEl.parentNode.insertBefore(uploadGroup, viewEl.nextSibling);

//                         const fileInput = document.getElementById('lesson_image_input');
//                         const uploadBtn = document.getElementById('lesson_image_btn');
//                         const statusEl = document.getElementById('lesson_image_status');

//                         uploadBtn.addEventListener('click', function () {
//                             fileInput.click();
//                         });

//                         // initialize global tracking state if not present
//                         if (!window.lessonImageUploadState) {
//                             // files: array of { name: string, url?: string, size: number }
//                             window.lessonImageUploadState = {
//                                 maxTotal: 2 * 1024 * 1024, // 2 MB
//                                 inProgress: false,
//                                 // store uploaded file metadata
//                                 files: []
//                             };
//                         }

//                         // Helper: compute used bytes from known files
//                         function computeUsedFromFiles() {
//                             try {
//                                 const files = window.lessonImageUploadState.files || [];
//                                 return files.reduce((s, f) => s + (Number(f.size) || 0), 0);
//                             } catch (e) { return 0; }
//                         }

//                         // Replace earlier used tracking by computing on-demand
//                         function updateProgressUI() {
//                             const used = computeUsedFromFiles();
//                             const state = window.lessonImageUploadState;
//                             const max = state.maxTotal;
//                             const pct = Math.min(100, Math.round((used / max) * 100));
//                             progressBar.style.width = pct + '%';
//                             progressText.textContent = bytesToHuman(used) + ' of ' + bytesToHuman(max) + ' used';
//                             if (used >= max) {
//                                 uploadBtn.disabled = true;
//                                 uploadBtn.classList.add('disabled');
//                             } else {
//                                 uploadBtn.disabled = false;
//                                 uploadBtn.classList.remove('disabled');
//                             }
//                             progressWrap.style.display = used > 0 ? 'block' : 'none';
//                         }

//                         const progressWrap = document.getElementById('lesson_image_progress_wrap');
//                         const progressBar = document.getElementById('lesson_image_progress');
//                         const progressText = document.getElementById('lesson_image_progress_text');
//                         const resetBtn = document.getElementById('lesson_image_reset');

//                         // (updateProgressUI replaced above to compute used from files)

//                         resetBtn.addEventListener('click', function () {
//                             // clear tracked files (only client-side for this session)
//                             window.lessonImageUploadState.files = [];
//                             updateProgressUI();
//                         });

//                         function bytesToHuman(n) {
//                             if (n < 1024) return n + ' B';
//                             if (n < 1024 * 1024) return (n / 1024).toFixed(1) + ' KB';
//                             return (n / (1024 * 1024)).toFixed(2) + ' MB';
//                         }

//                         fileInput.addEventListener('change', function (e) {
//                             const file = this.files && this.files[0];
//                             if (!file) return;

//                             const state = window.lessonImageUploadState;
//                             const usedNow = computeUsedFromFiles();
//                             const remaining = state.maxTotal - usedNow;
//                             if (file.size > remaining) {
//                                 statusEl.textContent = 'File too large for remaining quota';
//                                 return;
//                             }

//                             statusEl.textContent = 'Uploading...';
//                             progressWrap.style.display = 'block';

//                             const xhr = new XMLHttpRequest();
//                             const form = new FormData();
//                             form.append('image', file);

//                             xhr.open('POST', '../upload_image.php');

//                             // progress for this upload (visual per-file)
//                             xhr.upload.addEventListener('progress', function (ev) {
//                                 if (ev.lengthComputable) {
//                                     const percent = Math.round((ev.loaded / ev.total) * 100);
//                                     progressBar.style.width = percent + '%';
//                                     progressText.textContent = bytesToHuman(usedNow + ev.loaded) + ' of ' + bytesToHuman(state.maxTotal) + ' used';
//                                 }
//                             });

//                             xhr.addEventListener('load', function () {
//                                 try {
//                                     const resp = JSON.parse(xhr.responseText);
//                                     if (xhr.status >= 200 && xhr.status < 300 && resp && resp.url) {
//                                         // commit usage: store object with name/url/size
//                                         const parts = (resp.name ? resp.name : resp.url.split('/').pop().split('?')[0]) || '';
//                                         state.files.push({ name: parts, url: resp.url, size: file.size });
//                                         updateProgressUI();

//                                         const insertImageByUrl = (url) => {
//                                             try {
//                                                 if (editorInstance && editorInstance.model && editorInstance.model.schema && editorInstance.model.schema.checkChild) {
//                                                     editorInstance.model.change(writer => {
//                                                         const imageElement = writer.createElement('imageBlock', { src: url });
//                                                         editorInstance.model.insertContent(imageElement, editorInstance.model.document.selection);
//                                                     });
//                                                 } else if (editorInstance && typeof editorInstance.execute === 'function') {
//                                                     try {
//                                                         editorInstance.execute('imageInsert', { source: url });
//                                                     } catch (e) {
//                                                         const current = editorInstance.getData();
//                                                         editorInstance.setData(current + `<p><img src="${url}"/></p>`);
//                                                     }
//                                                 } else {
//                                                     const current = editorInstance.getData ? editorInstance.getData() : '';
//                                                     if (typeof editorInstance.setData === 'function') {
//                                                         editorInstance.setData(current + `<p><img src="${url}"/></p>`);
//                                                     }
//                                                 }
//                                                 statusEl.textContent = 'Uploaded';
//                                             } catch (err) {
//                                                 try {
//                                                     const current = editorInstance.getData();
//                                                     editorInstance.setData(current + `<p><img src="${url}"/></p>`);
//                                                     statusEl.textContent = 'Uploaded (fallback)';
//                                                 } catch (err2) {
//                                                     console.error('Insert image error', err2);
//                                                     statusEl.textContent = 'Uploaded but insert failed';
//                                                 }
//                                             }
//                                         };

//                                         insertImageByUrl(resp.url);
//                                     } else {
//                                         statusEl.textContent = resp && resp.error ? (resp.error.message || resp.error) : 'Upload failed';
//                                     }
//                                 } catch (err) {
//                                     console.error('Upload parse error', err, xhr.responseText);
//                                     statusEl.textContent = 'Upload error';
//                                 }
//                             });

//                             xhr.addEventListener('error', function (ev) {
//                                 console.error('XHR upload error', ev);
//                                 statusEl.textContent = 'Upload error';
//                             });

//                             xhr.send(form);
//                         });

//                         // Scan existing images in the view and try to include their sizes
//                         (function includeExistingImagesSizes() {
//                             try {
//                                 const imgs = viewEl.querySelectorAll('img');
//                                 if (!imgs || imgs.length === 0) return;
//                                 const state = window.lessonImageUploadState;
//                                 // For each image, if URL looks same-origin or points to uploads folder, try a HEAD request
//                                 Array.from(imgs).forEach(img => {
//                                     try {
//                                         const src = img.getAttribute('src') || img.src || '';
//                                         if (!src) return;
//                                         // avoid data: URIs
//                                         if (src.indexOf('data:') === 0) return;
//                                         // Only attempt for http(s) URLs or relative paths
//                                         const isHttp = src.indexOf('http') === 0 || src.indexOf('//') === 0 || src.indexOf('/') === 0;
//                                         if (!isHttp) return;

//                                         // Try to build an absolute URL
//                                         let url = src;
//                                         try {
//                                             url = new URL(src, window.location.href).href;
//                                         } catch (e) {}

//                                         // Skip obvious external hosts (basic check)
//                                         try {
//                                             const urlObj = new URL(url);
//                                             if (urlObj.hostname !== window.location.hostname) return;
//                                         } catch (e) {}

//                                         // If we already tracked this file by name/url, skip
//                                         const base = url.split('/').pop().split('?')[0];
//                                         if ((state.files || []).some(f => f.name === base || f.url === url)) return;

//                                         // HEAD request to fetch Content-Length
//                                         const xhr = new XMLHttpRequest();
//                                         xhr.open('HEAD', url);
//                                         xhr.onreadystatechange = function () {
//                                             if (xhr.readyState === 4) {
//                                                 try {
//                                                     if (xhr.status >= 200 && xhr.status < 400) {
//                                                         const len = xhr.getResponseHeader('Content-Length');
//                                                         const size = len ? parseInt(len, 10) : 0;
//                                                         state.files.push({ name: base, url: url, size: size });
//                                                         updateProgressUI();
//                                                     }
//                                                 } catch (e) { /* ignore */ }
//                                             }
//                                         };
//                                         // Add a small timeout so this doesn't block other init
//                                         setTimeout(() => {
//                                             try { xhr.send(); } catch (e) {}
//                                         }, 10);
//                                     } catch (e) { /* ignore per-image errors */ }
//                                 });
//                             } catch (e) { console.warn('includeExistingImagesSizes error', e); }
//                         })();

//                         // Ensure the UI shows the current usage immediately (may be 0)
//                         try { updateProgressUI(); } catch (e) { /* ignore */ }

//                         // Reconcile tracked files with the current images in the lesson view.
//                         // This will remove entries for images that were deleted and add sizes for
//                         // newly-added, same-origin images.
//                         function reconcileTrackedFilesWithView() {
//                             try {
//                                 const state = window.lessonImageUploadState;
//                                 if (!state) return;
//                                 // collect images from both the readonly view and the editor editable DOM (if present)
//                                 let imgs = [];
//                                 try { imgs = imgs.concat(Array.from(viewEl.querySelectorAll('img'))); } catch (e) {}
//                                 try {
//                                     const editableEl = editorInstance && editorInstance.ui && editorInstance.ui.view && editorInstance.ui.view.editable && editorInstance.ui.view.editable.element;
//                                     if (editableEl) imgs = imgs.concat(Array.from(editableEl.querySelectorAll('img')));
//                                 } catch (e) {}
//                                 // dedupe
//                                 imgs = imgs.filter((v,i,a)=>a.indexOf(v)===i);

//                                 const currentBases = new Set();
//                                 imgs.forEach(img => {
//                                     try {
//                                         const src = img.getAttribute('src') || img.src || '';
//                                         if (!src) return;
//                                         const base = (new URL(src, window.location.href).pathname.split('/').pop() || '').split('?')[0];
//                                         if (base) currentBases.add(base);
//                                     } catch (e) {
//                                         const src = img.getAttribute('src') || '';
//                                         const base = src.split('/').pop().split('?')[0];
//                                         if (base) currentBases.add(base);
//                                     }
//                                 });

//                                 // remove tracked files not present anymore
//                                 state.files = (state.files || []).filter(f => {
//                                     const fname = (f.name || (f.url || '').split('/').pop().split('?')[0] || '');
//                                     return currentBases.has(fname);
//                                 });

//                                 // add any current images not tracked yet (attempt HEAD for same-origin)
//                                 imgs.forEach(img => {
//                                     try {
//                                         const src = img.getAttribute('src') || img.src || '';
//                                         if (!src) return;
//                                         if (src.indexOf('data:') === 0) return;
//                                         let url = src;
//                                         try { url = new URL(src, window.location.href).href; } catch (e) {}
//                                         // basic same-host check
//                                         try {
//                                             const urlObj = new URL(url);
//                                             if (urlObj.hostname !== window.location.hostname) return;
//                                         } catch (e) {}
//                                         const base = url.split('/').pop().split('?')[0];
//                                         if (!base) return;
//                                         if ((state.files || []).some(f => f.name === base || f.url === url)) return;

//                                         // HEAD request to try to get Content-Length
//                                         const xhr = new XMLHttpRequest();
//                                         xhr.open('HEAD', url);
//                                         xhr.onreadystatechange = function () {
//                                             if (xhr.readyState === 4) {
//                                                 try {
//                                                     if (xhr.status >= 200 && xhr.status < 400) {
//                                                         const len = xhr.getResponseHeader('Content-Length');
//                                                         const size = len ? parseInt(len, 10) : 0;
//                                                         state.files.push({ name: base, url: url, size: size });
//                                                         updateProgressUI();
//                                                     }
//                                                 } catch (e) { /* ignore */ }
//                                             }
//                                         };
//                                         setTimeout(() => { try { xhr.send(); } catch (e) {} }, 10);
//                                     } catch (e) { /* per-image ignore */ }
//                                 });

//                                 updateProgressUI();
//                             } catch (e) { console.warn('reconcileTrackedFilesWithView error', e); }
//                         }

//                         // Observe the lesson view and the editor editable DOM for image add/remove changes so we can update the quota
//                         try {
//                             const observer = new MutationObserver(function (mutations) {
//                                 // simple throttle: run reconcile once per mutation batch
//                                 reconcileTrackedFilesWithView();
//                             });
//                             observer.observe(viewEl, { childList: true, subtree: true, attributes: true, attributeFilter: ['src'] });
//                             try {
//                                 const editableEl = editorInstance && editorInstance.ui && editorInstance.ui.view && editorInstance.ui.view.editable && editorInstance.ui.view.editable.element;
//                                 if (editableEl) {
//                                     observer.observe(editableEl, { childList: true, subtree: true, attributes: true, attributeFilter: ['src'] });
//                                 }
//                             } catch (e) { /* ignore */ }
//                         } catch (e) { console.warn('MutationObserver not available', e); }
//                     }
//                 }
//             } catch (e) {
//                 console.error('Fallback upload init error', e);
//             }

//             // --- Image resize toolbar ---
//             try {
//                 // Create floating toolbar element
//                 let imgToolbar = document.getElementById('ck_img_resize_toolbar');
//                 if (!imgToolbar) {
//                     imgToolbar = document.createElement('div');
//                     imgToolbar.id = 'ck_img_resize_toolbar';
//                     imgToolbar.style.position = 'absolute';
//                     imgToolbar.style.display = 'none';
//                     imgToolbar.style.zIndex = 9999;
//                     imgToolbar.style.background = '#fff';
//                     imgToolbar.style.border = '1px solid #ddd';
//                     imgToolbar.style.padding = '6px';
//                     imgToolbar.style.borderRadius = '4px';
//                     imgToolbar.style.boxShadow = '0 2px 6px rgba(0,0,0,0.15)';
//                     imgToolbar.innerHTML = `
//                         <button class="btn btn-sm btn-light ck-img-size-btn" data-size="25">25%</button>
//                         <button class="btn btn-sm btn-light ck-img-size-btn" data-size="50">50%</button>
//                         <button class="btn btn-sm btn-light ck-img-size-btn" data-size="75">75%</button>
//                         <button class="btn btn-sm btn-light ck-img-size-btn" data-size="100">100%</button>
//                         <input id="ck_img_custom_px" type="number" placeholder="px" style="width:64px; margin-left:6px;" />
//                         <button class="btn btn-sm btn-primary" id="ck_img_apply_px" style="margin-left:6px;">Apply</button>
//                         <button class="btn btn-sm btn-outline-secondary" id="ck_img_remove_style" style="margin-left:6px;">Reset</button>
//                     `;
//                     document.body.appendChild(imgToolbar);
//                 }

//                 let currentImage = null;

//                 // Helper to position toolbar near an element
//                 function positionToolbarForElement(el) {
//                     const rect = el.getBoundingClientRect();
//                     const toolbarRect = imgToolbar.getBoundingClientRect();
//                     // place above the image if possible
//                     let top = window.scrollY + rect.top - toolbarRect.height - 8;
//                     if (top < window.scrollY + 5) top = window.scrollY + rect.bottom + 8; // below if not enough space
//                     let left = window.scrollX + rect.left;
//                     imgToolbar.style.top = top + 'px';
//                     imgToolbar.style.left = left + 'px';
//                     imgToolbar.style.display = 'block';
//                 }

//                 // Helper to apply a visual width that overrides common layout constraints
//                 function applyVisualWidth(el, widthVal) {
//                     try {
//                         if (!el || !widthVal) return;
//                         // ensure width is explicit and important so parent CSS (min-width, flex) doesn't override
//                         el.style.setProperty('width', widthVal, 'important');
//                         el.style.setProperty('height', 'auto', 'important');
//                         // reset constraints that can block percentage sizing
//                         el.style.setProperty('min-width', '0', 'important');
//                         el.style.setProperty('max-width', 'none', 'important');
//                         el.style.setProperty('flex', '0 0 auto', 'important');
//                         el.style.setProperty('flex-grow', '0', 'important');
//                         // make image block level so percentage widths behave predictably
//                         el.style.setProperty('display', 'block', 'important');
//                         // ensure object-fit doesn't crop unexpectedly
//                         el.style.setProperty('object-fit', 'contain', 'important');
//                     } catch (e) { try { el.style.width = widthVal; } catch (err) {} }
//                 }

//                 function clearVisualWidth(el) {
//                     try {
//                         if (!el) return;
//                         el.style.removeProperty('width');
//                         el.style.removeProperty('height');
//                         el.style.removeProperty('min-width');
//                         el.style.removeProperty('max-width');
//                         el.style.removeProperty('flex');
//                         el.style.removeProperty('flex-grow');
//                         el.style.removeProperty('display');
//                         el.style.removeProperty('object-fit');
//                     } catch (e) { /* ignore */ }
//                 }

//                 // Click handler inside the editor to detect images
//                 const editable = editor.ui ? editor.ui.view.editable.element : document.querySelector('.ck-editor__editable');
//                 if (editable) {
//                     // Listen for clicks and use closest to find images even if nested (e.g., inside figure)
//                     editable.addEventListener('click', function (ev) {
//                         const targetImg = ev.target && ev.target.closest ? ev.target.closest('img') : null;
//                         if (targetImg) {
//                             currentImage = targetImg;
//                             positionToolbarForElement(targetImg);
//                             // Pre-fill custom px with current width (if set as px)
//                             const width = targetImg.style.width || targetImg.getAttribute('width') || '';
//                             const px = width && width.indexOf('%') === -1 ? parseInt(width, 10) || '' : '';
//                             const cust = document.getElementById('ck_img_custom_px');
//                             if (cust) cust.value = px;
//                         } else {
//                             currentImage = null;
//                             imgToolbar.style.display = 'none';
//                         }
//                     });

//                     // Hide toolbar when clicking elsewhere
//                     document.addEventListener('click', function (ev) {
//                         if (!imgToolbar.contains(ev.target) && !editable.contains(ev.target)) {
//                             imgToolbar.style.display = 'none';
//                             currentImage = null;
//                         }
//                     });

//                     // Toolbar button handlers
//                     imgToolbar.addEventListener('click', function (ev) {
//                         const btn = ev.target.closest('.ck-img-size-btn');
//                         if (btn && currentImage) {
//                             const size = btn.getAttribute('data-size');
//                             applyVisualWidth(currentImage, size + '%');
//                             try { currentImage.removeAttribute('height'); } catch (e) {}
//                         }
//                         if (ev.target && ev.target.id === 'ck_img_apply_px' && currentImage) {
//                             const val = parseInt(document.getElementById('ck_img_custom_px').value, 10);
//                             if (!isNaN(val) && val > 0) {
//                                 applyVisualWidth(currentImage, val + 'px');
//                             }
//                         }
//                         if (ev.target && ev.target.id === 'ck_img_remove_style' && currentImage) {
//                             clearVisualWidth(currentImage);
//                             currentImage.removeAttribute('width');
//                         }
//                     });
//                 }
//             } catch (e) {
//                 console.error('Image toolbar init error', e);
//             }

//             // Helper: ensure the resized image style is persisted into the editor data
//             function syncImageToEditor(imgEl) {
//                 try {
//                     if (!editorInstance) return;

//                     // If editor has a model and we can map DOM to model, try to update via model.change
//                     if (editorInstance.model && editorInstance.editing && typeof editorInstance.editing.view._renderer === 'object') {
//                         // Best-effort: update by finding image element in editor data by src and replace its style/width
//                         const src = imgEl.getAttribute('src') || imgEl.src || '';
//                         if (!src) return;

//                         // Retrieve current editor HTML
//                         let html = editorInstance.getData();

//                         // Create a DOM parser to modify the image tag corresponding to this src
//                         const parser = new DOMParser();
//                         const doc = parser.parseFromString('<div>' + html + '</div>', 'text/html');
//                         // Find images with matching src (use endsWith compare to allow absolute/relative differences)
//                         const imgs = Array.from(doc.querySelectorAll('img'));
//                         let matched = false;
//                         for (let i = 0; i < imgs.length; i++) {
//                             const iSrc = imgs[i].getAttribute('src') || imgs[i].src || '';
//                             if (!iSrc) continue;
//                             // Compare by filename at end to tolerate query strings
//                             const baseA = iSrc.split('/').pop().split('?')[0];
//                             const baseB = src.split('/').pop().split('?')[0];
//                             if (baseA === baseB || iSrc === src) {
//                                 // copy inline width/style attributes from imgEl
//                                 const widthStyle = imgEl.style.width || '';
//                                 if (widthStyle) {
//                                     imgs[i].setAttribute('style', (imgs[i].getAttribute('style') || '') + ' width: ' + widthStyle + ';');
//                                     imgs[i].setAttribute('width', ''); // keep style-driven width
//                                 } else {
//                                     // remove width/style if cleared
//                                     let st = imgs[i].getAttribute('style') || '';
//                                     st = st.replace(/\bwidth\s*:\s*[^;]+;?/ig, '');
//                                     if (st.trim()) imgs[i].setAttribute('style', st); else imgs[i].removeAttribute('style');
//                                     imgs[i].removeAttribute('width');
//                                 }
//                                 matched = true;
//                                 // Do not break — update all matching images
//                             }
//                         }

//                         if (matched) {
//                             // Serialize back to HTML and set data
//                             const newHtml = doc.body.firstChild.innerHTML;
//                             editorInstance.setData(newHtml);
//                         }
//                         return;
//                     }

//                     // Fallback: direct replace in editor HTML string by src
//                     const src = imgEl.getAttribute('src') || imgEl.src || '';
//                     if (!src) return;
//                     let data = editorInstance.getData();
//                     // build regex to find the img tag with this src (escape special chars)
//                     const esc = src.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
//                     const re = new RegExp('(<img[^>]*src=["\']?'+esc+'["\']?[^>]*>)','gi');
//                     const match = data.match(re);
//                     if (match && match.length > 0) {
//                         // pick first occurrence and update style attribute
//                         const originalTag = match[0];
//                         // create a DOM element to manipulate
//                         const tmp = document.createElement('div');
//                         tmp.innerHTML = originalTag;
//                         const img = tmp.querySelector('img');
//                         if (!img) return;
//                         // copy computed style width
//                         const widthStyle = imgEl.style.width || '';
//                         if (widthStyle) {
//                             img.setAttribute('style', (img.getAttribute('style') || '') + ' width: ' + widthStyle + ';');
//                             img.setAttribute('width', '');
//                         } else {
//                             let st = img.getAttribute('style') || '';
//                             st = st.replace(/\bwidth\s*:\s*[^;]+;?/ig, '');
//                             if (st.trim()) img.setAttribute('style', st); else img.removeAttribute('style');
//                             img.removeAttribute('width');
//                         }
//                         const newTag = tmp.innerHTML;
//                         data = data.replace(re, newTag);
//                         editorInstance.setData(data);
//                     }
//                 } catch (err) {
//                     console.error('syncImageToEditor error', err);
//                 }
//             }
//         })
//         .catch(error => {
//             console.error("Error initializing editor:", error);
//         });
//     } // end init-once




//     $.ajax({
//         url: "../controller.php",
//         type: "post",
//         data: {
//             "class_id": $("#select_class_field").val(),
//             "subject_id": $("#select_subject_field").val(),
//             "week_id": $(".week_btn.active").attr("data-id"),
//             'type': 'body',
//             "action": "get_lesson_note"
//         },
//         beforeSend: () => {
//             $("#lesson_body_view").html("Loading...")
//         },
//         success: (response) => {
//             const data = !response ? '' : JSON.parse(response);
//             const contentHtml = data.content || '<i>No content here yet</i>';
//             // Update the view HTML
//             $("#lesson_body_view").html(contentHtml);
//             // If editor exists and is initialized, update its data too but keep it readOnly
//             try {
//                 if (editorInstance && typeof editorInstance.setData === 'function') {
//                     // Only update the editor data so that toggling to edit will reflect latest content
//                     editorInstance.setData(contentHtml);
//                     try { editorInstance.isReadOnly = true; } catch (e) {}
//                 }
//             } catch (e) {
//                 console.warn('Could not set editor data on get_lesson_note_body success:', e);
//             }

//         },
//         error: (error) => {
//             console.error("Error fetching lesson note:", error);
//         }
//     });
// }
function get_lesson_note_body() {
    if (
        !$("#select_class_field").val() ||
        !$("#select_subject_field").val() ||
        !$(".week_btn.active").attr("data-id")
    ) {
        return false;
    }
    // Only inject the editor/view markup and initialize CKEditor once. Subsequent
    // calls will reuse the same editor instance and only update the view content.
    if ($("#note_container_body").children().length === 0) {
        $("#note_container_body").html(`
        
                    <div class="mt-4">
                        <div class="py-3 px-15 bg-white" style="border-radius: 10px;">
                            
                            <div class="form-group mb-0 w-100" id="lesson_note_body_editor" style="display:none;">
                                <label class="">Content</label>
                                <textarea id="lesson_body" name=""></textarea>
                                <div class="form-group mt-3">
                                    <label>Save for Classes (Multi-Select)</label>
                                    <select class="form-control select2" multiple="multiple" id="lesson_note_multi_class" style="width: 100%;"></select>
                                </div>
                                <div class="d-flex mt-3">
                                    <button type="button" class="btn btn-primary mr-3" onclick="create_lesson_note_body()">Save changes</button>
                                    <button type="button" class="btn btn-outline-primary" onclick="show_lesson_note_body()">Cancel editing</button>
                                </div>
                            </div>
                            <div class="form-group mb-0 w-100" id="lesson_note_body_view" style="display: inline-block;">
                                <label class="">Content</label>
                                <div id="lesson_body_view" style="background-color: #fcfcfc; padding-top: 10px; padding-bottom: 10px; padding-left: 10px; padding-right: 10px; border-radius: 5px;">        
                                <i>No content here yet</i>
                                </div>
                                <a onclick="show_lesson_note_body_editor()" class="btn accent pl-0 pr-5 d-flex align-items-center">Edit content</a>
                            </div>
                        </div>
                    </div>
        
    `);

        ClassicEditor.create(document.querySelector("#lesson_body"), {
            toolbar: {
                shouldNotGroupWhenFull: true,
                items: [
                    "heading",
                    "bold",
                    "italic",
                    "underline",
                    "strikethrough",
                    "|",
                    "bulletedList",
                    "numberedList",
                    "alignment",
                    "|",
                    "blockQuote",
                    "link",
                    "undo",
                    "redo",
                    "|",
                    "fontSize",
                    "fontColor",
                    "fontBackgroundColor",
                    "insertTable",
                    "imageUpload",
                ],
            },
            // Enable image upload via SimpleUpload adapter. Remove heavy/unused plugins but keep image upload support.
            removePlugins: ["MediaEmbed", "EasyImage", "CKFinder"],
            simpleUpload: {
                // Upload URL: controller will handle uploads when action=upload_lesson_image
                uploadUrl: "../controller.php?action=upload_lesson_image",
                // Optional headers (e.g., CSRF) can be added here if needed:
                // headers: { 'X-CSRF-TOKEN': 'CSRF-Token' }
            },
            heading: {
                options: [
                    {
                        model: "paragraph",
                        title: "Paragraph",
                        class: "ck-heading_paragraph",
                    },
                    {
                        model: "heading1",
                        view: "h1",
                        title: "Heading 1",
                        class: "ck-heading_heading1",
                    },
                    {
                        model: "heading2",
                        view: "h2",
                        title: "Heading 2",
                        class: "ck-heading_heading2",
                    },
                    {
                        model: "heading3",
                        view: "h3",
                        title: "Heading 3",
                        class: "ck-heading_heading3",
                    },
                ],
            },
        })
            .then((editor) => {
                editorInstance = editor;
                editorInstance.setData(""); // Set initial data

                // Populate multi-class select
                populate_multi_class_select();

                // Start editor in read-only mode (view mode). Editing is toggled via
                // show_lesson_note_body_editor() which sets isReadOnly = false.
                try {
                    editorInstance.isReadOnly = true;
                } catch (e) { }
                // If a pending body was stored (user clicked Edit before editor ready), restore it
                try {
                    if (
                        window.__pendingLessonBody &&
                        typeof editorInstance.setData === "function"
                    ) {
                        editorInstance.setData(window.__pendingLessonBody);
                        window.__pendingLessonBody = null;
                    }
                } catch (e) {
                    console.warn("Could not apply pending lesson body to editor:", e);
                }
                console.log("Editor initialized successfully!");
                // Provide a fallback image upload control when the CKEditor upload adapter/plugin
                // is not available (filerepository-no-upload-adapter). This allows users to upload
                // an image via a simple file input and insert it into the editor content.
                try {
                    const viewEl = document.querySelector("#lesson_note_body_view");
                    if (viewEl) {
                        let uploadGroup = document.getElementById(
                            "lesson_image_upload_group"
                        );
                        if (!uploadGroup) {
                            uploadGroup = document.createElement("div");
                            uploadGroup.id = "lesson_image_upload_group";
                            uploadGroup.style.marginTop = "8px";
                            uploadGroup.innerHTML = `
                            <input type="file" id="lesson_image_input" accept="image/*" style="display:none;">
                            <button type="button" id="lesson_image_btn" class="btn btn-sm btn-secondary">Upload Image</button>
                            <span id="lesson_image_status" style="margin-left:10px"></span>
                            <div id="lesson_image_progress_wrap" style="margin-top:8px; display:none;">
                                <div style="height:6px; background:#e9ecef; border-radius:3px; overflow:hidden;">
                                    <div id="lesson_image_progress" style="height:6px; width:0%; background:#007bff;"></div>
                                </div>
                                <div style="font-size:12px; margin-top:4px; color:#666; display:flex; justify-content:space-between;">
                                    <span id="lesson_image_progress_text">0 B of 2 MB used</span>
                                    <button type="button" id="lesson_image_reset" class="btn btn-sm btn-link d-none" style="padding:0;">Reset</button>
                                </div>
                            </div>
                        `;
                            // Insert upload controls after the view element
                            viewEl.parentNode.insertBefore(uploadGroup, viewEl.nextSibling);

                            const fileInput = document.getElementById("lesson_image_input");
                            const uploadBtn = document.getElementById("lesson_image_btn");
                            const statusEl = document.getElementById("lesson_image_status");

                            uploadBtn.addEventListener("click", function () {
                                fileInput.click();
                            });

                            // initialize global tracking state if not present
                            if (!window.lessonImageUploadState) {
                                // files: array of { name: string, url?: string, size: number }
                                window.lessonImageUploadState = {
                                    maxTotal: 2 * 1024 * 1024, // 2 MB
                                    inProgress: false,
                                    // store uploaded file metadata
                                    files: [],
                                };
                            }

                            // Helper: compute used bytes from known files
                            function computeUsedFromFiles() {
                                try {
                                    const files = window.lessonImageUploadState.files || [];
                                    return files.reduce((s, f) => s + (Number(f.size) || 0), 0);
                                } catch (e) {
                                    return 0;
                                }
                            }

                            // Replace earlier used tracking by computing on-demand
                            function updateProgressUI() {
                                const used = computeUsedFromFiles();
                                const state = window.lessonImageUploadState;
                                const max = state.maxTotal;
                                const pct = Math.min(100, Math.round((used / max) * 100));
                                progressBar.style.width = pct + "%";
                                progressText.textContent =
                                    bytesToHuman(used) + " of " + bytesToHuman(max) + " used";
                                if (used >= max) {
                                    uploadBtn.disabled = true;
                                    uploadBtn.classList.add("disabled");
                                } else {
                                    uploadBtn.disabled = false;
                                    uploadBtn.classList.remove("disabled");
                                }
                                progressWrap.style.display = used > 0 ? "block" : "none";
                            }

                            const progressWrap = document.getElementById(
                                "lesson_image_progress_wrap"
                            );
                            const progressBar = document.getElementById(
                                "lesson_image_progress"
                            );
                            const progressText = document.getElementById(
                                "lesson_image_progress_text"
                            );
                            const resetBtn = document.getElementById("lesson_image_reset");

                            // (updateProgressUI replaced above to compute used from files)

                            resetBtn.addEventListener("click", function () {
                                // clear tracked files (only client-side for this session)
                                window.lessonImageUploadState.files = [];
                                updateProgressUI();
                            });

                            function bytesToHuman(n) {
                                if (n < 1024) return n + " B";
                                if (n < 1024 * 1024) return (n / 1024).toFixed(1) + " KB";
                                return (n / (1024 * 1024)).toFixed(2) + " MB";
                            }

                            fileInput.addEventListener("change", function (e) {
                                const file = this.files && this.files[0];
                                if (!file) return;

                                const state = window.lessonImageUploadState;
                                const usedNow = computeUsedFromFiles();
                                const remaining = state.maxTotal - usedNow;
                                if (file.size > remaining) {
                                    statusEl.textContent = "File too large for remaining quota";
                                    return;
                                }

                                statusEl.textContent = "Uploading...";
                                progressWrap.style.display = "block";

                                const xhr = new XMLHttpRequest();
                                const form = new FormData();
                                form.append("image", file);

                                xhr.open("POST", "../upload_image.php");

                                // progress for this upload (visual per-file)
                                xhr.upload.addEventListener("progress", function (ev) {
                                    if (ev.lengthComputable) {
                                        const percent = Math.round((ev.loaded / ev.total) * 100);
                                        progressBar.style.width = percent + "%";
                                        progressText.textContent =
                                            bytesToHuman(usedNow + ev.loaded) +
                                            " of " +
                                            bytesToHuman(state.maxTotal) +
                                            " used";
                                    }
                                });

                                xhr.addEventListener("load", function () {
                                    try {
                                        const resp = JSON.parse(xhr.responseText);
                                        if (
                                            xhr.status >= 200 &&
                                            xhr.status < 300 &&
                                            resp &&
                                            resp.url
                                        ) {
                                            // commit usage: store object with name/url/size
                                            const parts =
                                                (resp.name
                                                    ? resp.name
                                                    : resp.url.split("/").pop().split("?")[0]) || "";
                                            state.files.push({
                                                name: parts,
                                                url: resp.url,
                                                size: file.size,
                                            });
                                            updateProgressUI();

                                            const insertImageByUrl = (url) => {
                                                try {
                                                    if (
                                                        editorInstance &&
                                                        editorInstance.model &&
                                                        editorInstance.model.schema &&
                                                        editorInstance.model.schema.checkChild
                                                    ) {
                                                        editorInstance.model.change((writer) => {
                                                            const imageElement = writer.createElement(
                                                                "imageBlock",
                                                                { src: url }
                                                            );
                                                            editorInstance.model.insertContent(
                                                                imageElement,
                                                                editorInstance.model.document.selection
                                                            );
                                                        });
                                                    } else if (
                                                        editorInstance &&
                                                        typeof editorInstance.execute === "function"
                                                    ) {
                                                        try {
                                                            editorInstance.execute("imageInsert", {
                                                                source: url,
                                                            });
                                                        } catch (e) {
                                                            const current = editorInstance.getData();
                                                            editorInstance.setData(
                                                                current + `<p><img src="${url}"/></p>`
                                                            );
                                                        }
                                                    } else {
                                                        const current = editorInstance.getData
                                                            ? editorInstance.getData()
                                                            : "";
                                                        if (typeof editorInstance.setData === "function") {
                                                            editorInstance.setData(
                                                                current + `<p><img src="${url}"/></p>`
                                                            );
                                                        }
                                                    }
                                                    statusEl.textContent = "Uploaded";
                                                } catch (err) {
                                                    try {
                                                        const current = editorInstance.getData();
                                                        editorInstance.setData(
                                                            current + `<p><img src="${url}"/></p>`
                                                        );
                                                        statusEl.textContent = "Uploaded (fallback)";
                                                    } catch (err2) {
                                                        console.error("Insert image error", err2);
                                                        statusEl.textContent = "Uploaded but insert failed";
                                                    }
                                                }
                                            };

                                            insertImageByUrl(resp.url);
                                        } else {
                                            statusEl.textContent =
                                                resp && resp.error
                                                    ? resp.error.message || resp.error
                                                    : "Upload failed";
                                        }
                                    } catch (err) {
                                        console.error("Upload parse error", err, xhr.responseText);
                                        statusEl.textContent = "Upload error";
                                    }
                                });

                                xhr.addEventListener("error", function (ev) {
                                    console.error("XHR upload error", ev);
                                    statusEl.textContent = "Upload error";
                                });

                                xhr.send(form);
                            });

                            // Scan existing images in the view and try to include their sizes
                            (function includeExistingImagesSizes() {
                                try {
                                    const imgs = viewEl.querySelectorAll("img");
                                    if (!imgs || imgs.length === 0) return;
                                    const state = window.lessonImageUploadState;
                                    // For each image, if URL looks same-origin or points to uploads folder, try a HEAD request
                                    Array.from(imgs).forEach((img) => {
                                        try {
                                            const src = img.getAttribute("src") || img.src || "";
                                            if (!src) return;
                                            // avoid data: URIs
                                            if (src.indexOf("data:") === 0) return;
                                            // Only attempt for http(s) URLs or relative paths
                                            const isHttp =
                                                src.indexOf("http") === 0 ||
                                                src.indexOf("//") === 0 ||
                                                src.indexOf("/") === 0;
                                            if (!isHttp) return;

                                            // Try to build an absolute URL
                                            let url = src;
                                            try {
                                                url = new URL(src, window.location.href).href;
                                            } catch (e) { }

                                            // Skip obvious external hosts (basic check)
                                            try {
                                                const urlObj = new URL(url);
                                                if (urlObj.hostname !== window.location.hostname)
                                                    return;
                                            } catch (e) { }

                                            // If we already tracked this file by name/url, skip
                                            const base = url.split("/").pop().split("?")[0];
                                            if (
                                                (state.files || []).some(
                                                    (f) => f.name === base || f.url === url
                                                )
                                            )
                                                return;

                                            // HEAD request to fetch Content-Length
                                            const xhr = new XMLHttpRequest();
                                            xhr.open("HEAD", url);
                                            xhr.onreadystatechange = function () {
                                                if (xhr.readyState === 4) {
                                                    try {
                                                        if (xhr.status >= 200 && xhr.status < 400) {
                                                            const len =
                                                                xhr.getResponseHeader("Content-Length");
                                                            const size = len ? parseInt(len, 10) : 0;
                                                            state.files.push({
                                                                name: base,
                                                                url: url,
                                                                size: size,
                                                            });
                                                            updateProgressUI();
                                                        }
                                                    } catch (e) {
                                                        /* ignore */
                                                    }
                                                }
                                            };
                                            // Add a small timeout so this doesn't block other init
                                            setTimeout(() => {
                                                try {
                                                    xhr.send();
                                                } catch (e) { }
                                            }, 10);
                                        } catch (e) {
                                            /* ignore per-image errors */
                                        }
                                    });
                                } catch (e) {
                                    console.warn("includeExistingImagesSizes error", e);
                                }
                            })();

                            // Ensure the UI shows the current usage immediately (may be 0)
                            try {
                                updateProgressUI();
                            } catch (e) {
                                /* ignore */
                            }

                            // Reconcile tracked files with the current images in the lesson view.
                            // This will remove entries for images that were deleted and add sizes for
                            // newly-added, same-origin images.
                            function reconcileTrackedFilesWithView() {
                                try {
                                    const state = window.lessonImageUploadState;
                                    if (!state) return;
                                    // collect images from both the readonly view and the editor editable DOM (if present)
                                    let imgs = [];
                                    try {
                                        imgs = imgs.concat(
                                            Array.from(viewEl.querySelectorAll("img"))
                                        );
                                    } catch (e) { }
                                    try {
                                        const editableEl =
                                            editorInstance &&
                                            editorInstance.ui &&
                                            editorInstance.ui.view &&
                                            editorInstance.ui.view.editable &&
                                            editorInstance.ui.view.editable.element;
                                        if (editableEl)
                                            imgs = imgs.concat(
                                                Array.from(editableEl.querySelectorAll("img"))
                                            );
                                    } catch (e) { }
                                    // dedupe
                                    imgs = imgs.filter((v, i, a) => a.indexOf(v) === i);

                                    const currentBases = new Set();
                                    imgs.forEach((img) => {
                                        try {
                                            const src = img.getAttribute("src") || img.src || "";
                                            if (!src) return;
                                            const base = (
                                                new URL(src, window.location.href).pathname
                                                    .split("/")
                                                    .pop() || ""
                                            ).split("?")[0];
                                            if (base) currentBases.add(base);
                                        } catch (e) {
                                            const src = img.getAttribute("src") || "";
                                            const base = src.split("/").pop().split("?")[0];
                                            if (base) currentBases.add(base);
                                        }
                                    });

                                    // remove tracked files not present anymore
                                    state.files = (state.files || []).filter((f) => {
                                        const fname =
                                            f.name ||
                                            (f.url || "").split("/").pop().split("?")[0] ||
                                            "";
                                        return currentBases.has(fname);
                                    });

                                    // add any current images not tracked yet (attempt HEAD for same-origin)
                                    imgs.forEach((img) => {
                                        try {
                                            const src = img.getAttribute("src") || img.src || "";
                                            if (!src) return;
                                            if (src.indexOf("data:") === 0) return;
                                            let url = src;
                                            try {
                                                url = new URL(src, window.location.href).href;
                                            } catch (e) { }
                                            // basic same-host check
                                            try {
                                                const urlObj = new URL(url);
                                                if (urlObj.hostname !== window.location.hostname)
                                                    return;
                                            } catch (e) { }
                                            const base = url.split("/").pop().split("?")[0];
                                            if (!base) return;
                                            if (
                                                (state.files || []).some(
                                                    (f) => f.name === base || f.url === url
                                                )
                                            )
                                                return;

                                            // HEAD request to try to get Content-Length
                                            const xhr = new XMLHttpRequest();
                                            xhr.open("HEAD", url);
                                            xhr.onreadystatechange = function () {
                                                if (xhr.readyState === 4) {
                                                    try {
                                                        if (xhr.status >= 200 && xhr.status < 400) {
                                                            const len =
                                                                xhr.getResponseHeader("Content-Length");
                                                            const size = len ? parseInt(len, 10) : 0;
                                                            state.files.push({
                                                                name: base,
                                                                url: url,
                                                                size: size,
                                                            });
                                                            updateProgressUI();
                                                        }
                                                    } catch (e) {
                                                        /* ignore */
                                                    }
                                                }
                                            };
                                            setTimeout(() => {
                                                try {
                                                    xhr.send();
                                                } catch (e) { }
                                            }, 10);
                                        } catch (e) {
                                            /* per-image ignore */
                                        }
                                    });

                                    updateProgressUI();
                                } catch (e) {
                                    console.warn("reconcileTrackedFilesWithView error", e);
                                }
                            }

                            // Observe the lesson view and the editor editable DOM for image add/remove changes so we can update the quota
                            try {
                                const observer = new MutationObserver(function (mutations) {
                                    // simple throttle: run reconcile once per mutation batch
                                    reconcileTrackedFilesWithView();
                                });
                                observer.observe(viewEl, {
                                    childList: true,
                                    subtree: true,
                                    attributes: true,
                                    attributeFilter: ["src"],
                                });
                                try {
                                    const editableEl =
                                        editorInstance &&
                                        editorInstance.ui &&
                                        editorInstance.ui.view &&
                                        editorInstance.ui.view.editable &&
                                        editorInstance.ui.view.editable.element;
                                    if (editableEl) {
                                        observer.observe(editableEl, {
                                            childList: true,
                                            subtree: true,
                                            attributes: true,
                                            attributeFilter: ["src"],
                                        });
                                    }
                                } catch (e) {
                                    /* ignore */
                                }
                            } catch (e) {
                                console.warn("MutationObserver not available", e);
                            }
                        }
                    }
                } catch (e) {
                    console.error("Fallback upload init error", e);
                }

                // --- Image resize toolbar ---
                try {
                    // Create floating toolbar element
                    let imgToolbar = document.getElementById("ck_img_resize_toolbar");
                    if (!imgToolbar) {
                        imgToolbar = document.createElement("div");
                        imgToolbar.id = "ck_img_resize_toolbar";
                        imgToolbar.style.position = "absolute";
                        imgToolbar.style.display = "none";
                        imgToolbar.style.zIndex = 9999;
                        imgToolbar.style.background = "#fff";
                        imgToolbar.style.border = "1px solid #ddd";
                        imgToolbar.style.padding = "6px";
                        imgToolbar.style.borderRadius = "4px";
                        imgToolbar.style.boxShadow = "0 2px 6px rgba(0,0,0,0.15)";
                        imgToolbar.innerHTML = `
                        <button class="btn btn-sm btn-light ck-img-size-btn" data-size="25">25%</button>
                        <button class="btn btn-sm btn-light ck-img-size-btn" data-size="50">50%</button>
                        <button class="btn btn-sm btn-light ck-img-size-btn" data-size="75">75%</button>
                        <button class="btn btn-sm btn-light ck-img-size-btn" data-size="100">100%</button>
                        <input id="ck_img_custom_px" type="number" placeholder="px" style="width:64px; margin-left:6px;" />
                        <button class="btn btn-sm btn-primary" id="ck_img_apply_px" style="margin-left:6px;">Apply</button>
                        <button class="btn btn-sm btn-outline-secondary" id="ck_img_remove_style" style="margin-left:6px;">Reset</button>
                    `;
                        document.body.appendChild(imgToolbar);
                    }

                    let currentImage = null;

                    // Helper to position toolbar near an element
                    function positionToolbarForElement(el) {
                        const rect = el.getBoundingClientRect();
                        const toolbarRect = imgToolbar.getBoundingClientRect();
                        // place above the image if possible
                        let top = window.scrollY + rect.top - toolbarRect.height - 8;
                        if (top < window.scrollY + 5)
                            top = window.scrollY + rect.bottom + 8; // below if not enough space
                        let left = window.scrollX + rect.left;
                        imgToolbar.style.top = top + "px";
                        imgToolbar.style.left = left + "px";
                        imgToolbar.style.display = "block";
                    }

                    // Helper to apply a visual width that overrides common layout constraints
                    function applyVisualWidth(el, widthVal) {
                        try {
                            if (!el || !widthVal) return;
                            // ensure width is explicit and important so parent CSS (min-width, flex) doesn't override
                            el.style.setProperty("width", widthVal, "important");
                            el.style.setProperty("height", "auto", "important");
                            // reset constraints that can block percentage sizing
                            el.style.setProperty("min-width", "0", "important");
                            el.style.setProperty("max-width", "none", "important");
                            el.style.setProperty("flex", "0 0 auto", "important");
                            el.style.setProperty("flex-grow", "0", "important");
                            // make image block level so percentage widths behave predictably
                            el.style.setProperty("display", "block", "important");
                            // ensure object-fit doesn't crop unexpectedly
                            el.style.setProperty("object-fit", "contain", "important");
                        } catch (e) {
                            try {
                                el.style.width = widthVal;
                            } catch (err) { }
                        }
                    }

                    function clearVisualWidth(el) {
                        try {
                            if (!el) return;
                            el.style.removeProperty("width");
                            el.style.removeProperty("height");
                            el.style.removeProperty("min-width");
                            el.style.removeProperty("max-width");
                            el.style.removeProperty("flex");
                            el.style.removeProperty("flex-grow");
                            el.style.removeProperty("display");
                            el.style.removeProperty("object-fit");
                        } catch (e) {
                            /* ignore */
                        }
                    }

                    // Click handler inside the editor to detect images
                    const editable = editor.ui
                        ? editor.ui.view.editable.element
                        : document.querySelector(".ck-editor__editable");
                    if (editable) {
                        // Listen for clicks and use closest to find images even if nested (e.g., inside figure)
                        editable.addEventListener("click", function (ev) {
                            const targetImg =
                                ev.target && ev.target.closest
                                    ? ev.target.closest("img")
                                    : null;
                            if (targetImg) {
                                currentImage = targetImg;
                                positionToolbarForElement(targetImg);
                                // Pre-fill custom px with current width (if set as px)
                                const width =
                                    targetImg.style.width ||
                                    targetImg.getAttribute("width") ||
                                    "";
                                const px =
                                    width && width.indexOf("%") === -1
                                        ? parseInt(width, 10) || ""
                                        : "";
                                const cust = document.getElementById("ck_img_custom_px");
                                if (cust) cust.value = px;
                            } else {
                                currentImage = null;
                                imgToolbar.style.display = "none";
                            }
                        });

                        // Hide toolbar when clicking elsewhere
                        document.addEventListener("click", function (ev) {
                            if (
                                !imgToolbar.contains(ev.target) &&
                                !editable.contains(ev.target)
                            ) {
                                imgToolbar.style.display = "none";
                                currentImage = null;
                            }
                        });

                        // Toolbar button handlers
                        imgToolbar.addEventListener("click", function (ev) {
                            const btn = ev.target.closest(".ck-img-size-btn");
                            if (btn && currentImage) {
                                const size = btn.getAttribute("data-size");
                                applyVisualWidth(currentImage, size + "%");
                                try {
                                    currentImage.removeAttribute("height");
                                } catch (e) { }
                            }
                            if (
                                ev.target &&
                                ev.target.id === "ck_img_apply_px" &&
                                currentImage
                            ) {
                                const val = parseInt(
                                    document.getElementById("ck_img_custom_px").value,
                                    10
                                );
                                if (!isNaN(val) && val > 0) {
                                    applyVisualWidth(currentImage, val + "px");
                                }
                            }
                            if (
                                ev.target &&
                                ev.target.id === "ck_img_remove_style" &&
                                currentImage
                            ) {
                                clearVisualWidth(currentImage);
                                currentImage.removeAttribute("width");
                            }
                        });
                    }
                } catch (e) {
                    console.error("Image toolbar init error", e);
                }

                // Helper: ensure the resized image style is persisted into the editor data
                function syncImageToEditor(imgEl) {
                    try {
                        if (!editorInstance) return;

                        // If editor has a model and we can map DOM to model, try to update via model.change
                        if (
                            editorInstance.model &&
                            editorInstance.editing &&
                            typeof editorInstance.editing.view._renderer === "object"
                        ) {
                            // Best-effort: update by finding image element in editor data by src and replace its style/width
                            const src = imgEl.getAttribute("src") || imgEl.src || "";
                            if (!src) return;

                            // Retrieve current editor HTML
                            let html = editorInstance.getData();

                            // Create a DOM parser to modify the image tag corresponding to this src
                            const parser = new DOMParser();
                            const doc = parser.parseFromString(
                                "<div>" + html + "</div>",
                                "text/html"
                            );
                            // Find images with matching src (use endsWith compare to allow absolute/relative differences)
                            const imgs = Array.from(doc.querySelectorAll("img"));
                            let matched = false;
                            for (let i = 0; i < imgs.length; i++) {
                                const iSrc = imgs[i].getAttribute("src") || imgs[i].src || "";
                                if (!iSrc) continue;
                                // Compare by filename at end to tolerate query strings
                                const baseA = iSrc.split("/").pop().split("?")[0];
                                const baseB = src.split("/").pop().split("?")[0];
                                if (baseA === baseB || iSrc === src) {
                                    // copy inline width/style attributes from imgEl
                                    const widthStyle = imgEl.style.width || "";
                                    if (widthStyle) {
                                        imgs[i].setAttribute(
                                            "style",
                                            (imgs[i].getAttribute("style") || "") +
                                            " width: " +
                                            widthStyle +
                                            ";"
                                        );
                                        imgs[i].setAttribute("width", ""); // keep style-driven width
                                    } else {
                                        // remove width/style if cleared
                                        let st = imgs[i].getAttribute("style") || "";
                                        st = st.replace(/\bwidth\s*:\s*[^;]+;?/gi, "");
                                        if (st.trim()) imgs[i].setAttribute("style", st);
                                        else imgs[i].removeAttribute("style");
                                        imgs[i].removeAttribute("width");
                                    }
                                    matched = true;
                                    // Do not break — update all matching images
                                }
                            }

                            if (matched) {
                                // Serialize back to HTML and set data
                                const newHtml = doc.body.firstChild.innerHTML;
                                editorInstance.setData(newHtml);
                            }
                            return;
                        }

                        // Fallback: direct replace in editor HTML string by src
                        const src = imgEl.getAttribute("src") || imgEl.src || "";
                        if (!src) return;
                        let data = editorInstance.getData();
                        // build regex to find the img tag with this src (escape special chars)
                        const esc = src.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
                        const re = new RegExp(
                            "(<img[^>]*src=[\"']?" + esc + "[\"']?[^>]*>)",
                            "gi"
                        );
                        const match = data.match(re);
                        if (match && match.length > 0) {
                            // pick first occurrence and update style attribute
                            const originalTag = match[0];
                            // create a DOM element to manipulate
                            const tmp = document.createElement("div");
                            tmp.innerHTML = originalTag;
                            const img = tmp.querySelector("img");
                            if (!img) return;
                            // copy computed style width
                            const widthStyle = imgEl.style.width || "";
                            if (widthStyle) {
                                img.setAttribute(
                                    "style",
                                    (img.getAttribute("style") || "") +
                                    " width: " +
                                    widthStyle +
                                    ";"
                                );
                                img.setAttribute("width", "");
                            } else {
                                let st = img.getAttribute("style") || "";
                                st = st.replace(/\bwidth\s*:\s*[^;]+;?/gi, "");
                                if (st.trim()) img.setAttribute("style", st);
                                else img.removeAttribute("style");
                                img.removeAttribute("width");
                            }
                            const newTag = tmp.innerHTML;
                            data = data.replace(re, newTag);
                            editorInstance.setData(data);
                        }
                    } catch (err) {
                        console.error("syncImageToEditor error", err);
                    }
                }
            })
            .catch((error) => {
                console.error("Error initializing editor:", error);
            });
    } // end init-once

    $.ajax({
        url: "../controller.php",
        type: "post",
        data: {
            class_id: $("#select_class_field").val(),
            subject_id: $("#select_subject_field").val(),
            week_id: $(".week_btn.active").attr("data-id"),
            term_id: $('.lesson_term.select_btn.active').attr('data-name') || $('.term.select_btn.active').attr('data-name') || '',

            type: "body",
            action: "get_lesson_note",
        },
        beforeSend: () => {
            $("#lesson_body_view").html("Loading...");
        },
        success: (response) => {
            //   const data = !response ? "" : response;
            const data = !response ? "" : JSON.parse(response);
            const contentHtml = data.content || "<i>No content here yet</i>";
            // Update the view HTML
            $("#lesson_body_view").html(contentHtml);
            // If editor exists and is initialized, update its data too but keep it readOnly
            try {
                if (editorInstance && typeof editorInstance.setData === "function") {
                    // Only update the editor data so that toggling to edit will reflect latest content
                    editorInstance.setData(contentHtml);
                    try {
                        editorInstance.isReadOnly = true;
                    } catch (e) { }
                }
            } catch (e) {
                console.warn(
                    "Could not set editor data on get_lesson_note_body success:",
                    e
                );
            }
        },
        error: (error) => {
            console.error("Error fetching lesson note:", error);
        },
    });
}
function show_lesson_note_body_editor() {
    // Copy current view HTML into the editor but convert inline img style widths
    // into a width attribute (percent or px) before setData, since CKEditor5 may
    // strip style attributes but often preserves the width attribute on images.
    try {
        const viewEl = document.getElementById('lesson_body_view');
        const viewHtml = viewEl ? viewEl.innerHTML : '';

        // Create a clone DOM so we can capture a map of image src/filename -> width
        // and prepare HTML to pass to CKEditor. We'll reapply widths into the
        // editable DOM after CKEditor renders since CKEditor may strip styles.
        let preparedHtml = viewHtml;
        const imgWidthMap = {}; // { 'full/src.png': '200px', 'basename.png': '200px' }
        try {
            if (viewEl) {
                const clone = viewEl.cloneNode(true);
                const imgs = clone.querySelectorAll('img');
                imgs.forEach(img => {
                    // Prefer inline style width, then data-width, then width attribute
                    let widthVal = img.style && img.style.width ? img.style.width.trim() : '';
                    if (!widthVal) widthVal = img.getAttribute('data-width') || img.getAttribute('width') || '';
                    if (widthVal) {
                        // normalize numeric to px, keep percent
                        if (/^\d+$/.test(widthVal)) widthVal = widthVal + 'px';
                        const src = img.getAttribute('src') || '';
                        const base = src.split('/').pop().split('?')[0];
                        if (src) imgWidthMap[src] = widthVal;
                        if (base) imgWidthMap[base] = widthVal;
                    }
                });
                // Remove inline style width from prepared HTML to reduce CKEditor conflicts;
                // we'll reapply sizes to the editable DOM after setData using imgWidthMap.
                clone.querySelectorAll('img').forEach(img => { if (img.style) img.style.width = ''; });
                preparedHtml = clone.innerHTML;
            }
        } catch (err) {
            console.warn('Error preparing images for editor setData:', err);
            preparedHtml = viewHtml;
        }

        if (editorInstance && typeof editorInstance.setData === 'function') {
            // Ensure editor container is visible so the editable element exists and toolbar
            // handlers can attach to it. Show editor container first (it will be hidden
            // visually by caller if needed).
            try { $("#lesson_note_body_editor").show(); } catch (e) { }

            // When applying preparedHtml, keep both width attribute and style width for
            // maximum compatibility. Many CKEditor instances preserve width attribute.
            // So convert preparedHtml img tags to include style width if width attr exists.
            try {
                const tmpWrap = document.createElement('div');
                tmpWrap.innerHTML = preparedHtml;
                tmpWrap.querySelectorAll('img').forEach(im => {
                    const w = im.getAttribute('width');
                    if (w && !(im.style && im.style.width)) {
                        try { applyVisualWidth(im, w); } catch (e) { im.style.width = w; }
                    }
                });
                preparedHtml = tmpWrap.innerHTML;
            } catch (err) {
                console.warn('Could not sync width attribute -> style before setData', err);
            }

            editorInstance.setData(preparedHtml);
            // attempt to focus editable area
            try {
                const editableEl = editorInstance.ui && editorInstance.ui.getEditableElement && editorInstance.ui.getEditableElement();
                if (editableEl && typeof editableEl.focus === 'function') editableEl.focus();
                // After setData, CKEditor renders the editable DOM. Re-apply widths
                // we captured from the view DOM using imgWidthMap. Match by full src
                // first, then by basename.
                setTimeout(() => {
                    try {
                        const ed = editorInstance.ui && editorInstance.ui.getEditableElement && editorInstance.ui.getEditableElement();
                        if (ed) {
                            ed.querySelectorAll('img').forEach(im => {
                                try {
                                    const src = im.getAttribute('src') || '';
                                    const base = src.split('/').pop().split('?')[0];
                                    const widthToApply = (src && imgWidthMap[src]) || (base && imgWidthMap[base]) || im.getAttribute('data-width') || im.getAttribute('width') || '';
                                    if (widthToApply) {
                                        try { applyVisualWidth(im, widthToApply); } catch (e) { try { im.style.width = widthToApply; } catch (_) { } }
                                        // clear layout constraints on parent elements which often override percent widths
                                        try {
                                            let p = im.parentElement;
                                            let depth = 0;
                                            while (p && depth < 4) {
                                                try {
                                                    p.style.setProperty('min-width', '0', 'important');
                                                    p.style.setProperty('max-width', '100%', 'important');
                                                    p.style.setProperty('flex', '0 0 auto', 'important');
                                                    p.style.setProperty('flex-grow', '0', 'important');
                                                    p.style.setProperty('display', 'block', 'important');
                                                } catch (err) { }
                                                p = p.parentElement;
                                                depth++;
                                            }
                                        } catch (err) { }
                                    } else {
                                        // if no widthToApply, clear any visual overrides
                                        try { clearVisualWidth(im); } catch (e) { }
                                    }
                                } catch (e) { }
                            });
                        }
                    } catch (e) {
                        console.warn('Could not reapply image widths in editable DOM:', e);
                    }
                }, 80);
            } catch (e) { }
        } else {
            window.__pendingLessonBody = preparedHtml;
        }
    } catch (e) {
        console.warn('Error copying view HTML to editor:', e);
    }

    $("#lesson_note_body_editor").show()
    $("#lesson_note_body_view").hide()
}

function show_lesson_note_body() {
    $("#lesson_note_body_editor").hide()
    $("#lesson_note_body_view").show()
}

function show_lesson_note_topic_editor() {
    $("#lesson_note_topic_editor").show()
    $("#lesson_note_topic_body").hide()
}

function show_lesson_note_topic_view() {
    $("#lesson_note_topic_editor").hide()
    $("#lesson_note_topic_body").show()
}

// function create_lesson_note_body() {
//     show_lesson_note_body()

//     // Prefer the visible editable DOM contents so inline styles applied by the
//     // floating toolbar (e.g., img.style.width) are preserved. Fallback to
//     // editorInstance.getData() when the editable element is not available.
//     let bodyContent = '';
//     try {
//         // CKEditor5 editable area element
//         const editableEl = document.querySelector('.ck-editor__editable') || (editorInstance && editorInstance.ui && editorInstance.ui.getEditableElement && editorInstance.ui.getEditableElement());
//         if (editableEl && editableEl.innerHTML && editableEl.innerHTML.trim().length > 0) {
//             bodyContent = editableEl.innerHTML;
//         }
//     } catch (e) {
//         console.warn('Could not read editable DOM innerHTML:', e);
//     }

//     if (!bodyContent && editorInstance && typeof editorInstance.getData === 'function') {
//         bodyContent = editorInstance.getData();
//     }

//     // Normalize images in the bodyContent: add data-width attribute so we can
//     // re-apply the width when the editor renders (CKEditor may strip style).
//     try {
//         const parser = new DOMParser();
//         const doc = parser.parseFromString('<div>' + bodyContent + '</div>', 'text/html');
//         const imgs = doc.querySelectorAll('img');
//         imgs.forEach(img => {
//             let w = img.style && img.style.width ? img.style.width.trim() : '';
//             if (!w) w = img.getAttribute('width') || '';
//             if (w) img.setAttribute('data-width', w);
//         });
//         bodyContent = doc.body.firstChild.innerHTML;
//     } catch (e) {
//         console.warn('Could not normalize image widths before save:', e);
//     }

//     $.ajax({
//         url: "../controller.php",
//         type: "POST",
//         data: {
//             "class_id": $("#select_class_field").val(),
//             "subject_id": $("#select_subject_field").val(),
//             "week_id": $(".week_btn.active").attr("data-id"),
//             // "topic": $("#lesson_topic").val(),
//             "body": bodyContent,
//             "action": "create_lesson_note_body",
//         },
//         success: (response) => {
//             console.log("Lesson note saved:", response);
//             get_lesson_note_body()
//             setTimeout(get_notes_week_view, 100)
//         },
//         error: (error) => {
//             console.error("Error saving lesson note:", error);
//         }
//     });
// }
// function create_lesson_note_topic() {
//     show_lesson_note_topic_view()
//     $.ajax({
//         url: "../controller.php",
//         type: "POST",
//         data: {
//             "class_id": $("#select_class_field").val(),
//             "subject_id": $("#select_subject_field").val(),
//             "week_id": $(".week_btn.active").attr("data-id"),
//             "topic": $("#lesson_topic").val(),
//             // "body": editorInstance.getData(),
//             "action": "create_lesson_note_topic",
//         },
//         success: (response) => {
//             console.log("Lesson note saved:", response);
//             get_lesson_note_topic()
//             setTimeout(get_notes_week_view, 100)

//         },
//         error: (error) => {
//             console.error("Error saving lesson note:", error);
//         }
//     });
// }
function create_lesson_note_body() {
    show_lesson_note_body();

    // Prefer the visible editable DOM contents so inline styles applied by the
    // floating toolbar (e.g., img.style.width) are preserved. Fallback to
    // editorInstance.getData() when the editable element is not available.
    let bodyContent = "";
    try {
        // CKEditor5 editable area element
        const editableEl =
            document.querySelector(".ck-editor__editable") ||
            (editorInstance &&
                editorInstance.ui &&
                editorInstance.ui.getEditableElement &&
                editorInstance.ui.getEditableElement());
        if (
            editableEl &&
            editableEl.innerHTML &&
            editableEl.innerHTML.trim().length > 0
        ) {
            bodyContent = editableEl.innerHTML;
        }
    } catch (e) {
        console.warn("Could not read editable DOM innerHTML:", e);
    }

    if (
        !bodyContent &&
        editorInstance &&
        typeof editorInstance.getData === "function"
    ) {
        bodyContent = editorInstance.getData();
    }

    // Normalize images in the bodyContent: add data-width attribute so we can
    // re-apply the width when the editor renders (CKEditor may strip style).
    try {
        const parser = new DOMParser();
        const doc = parser.parseFromString(
            "<div>" + bodyContent + "</div>",
            "text/html"
        );
        const imgs = doc.querySelectorAll("img");
        imgs.forEach((img) => {
            let w = img.style && img.style.width ? img.style.width.trim() : "";
            if (!w) w = img.getAttribute("width") || "";
            if (w) img.setAttribute("data-width", w);
        });
        bodyContent = doc.body.firstChild.innerHTML;
    } catch (e) {
        console.warn("Could not normalize image widths before save:", e);
    }

    // Determine class_id(s) to save to. Use the multi-select from the body editor if available/populated,
    // otherwise fallback to the main class selector.
    let selectedClasses = $("#lesson_note_multi_class").val();
    if (!selectedClasses || selectedClasses.length === 0) {
        selectedClasses = $("#select_class_field").val();
    }

    $.ajax({
        url: "../controller.php",
        type: "POST",
        data: {
            class_id: selectedClasses,
            subject_id: $("#select_subject_field").val(),
            week_id: $(".week_btn.active").attr("data-id"),
            // "topic": $("#lesson_topic").val(),
            body: bodyContent,
            action: "create_lesson_note_body",
        },
        success: (response) => {
            console.log("Lesson note saved:", response);
            get_lesson_note_body();
            setTimeout(get_notes_week_view, 100);
        },
        error: (error) => {
            console.error("Error saving lesson note:", error);
        },
    });
}
function create_lesson_note_topic() {
    show_lesson_note_topic_view();

    // Determine class_id(s) to save to. Use the multi-select from the body editor if available/populated,
    // otherwise fallback to the main class selector.
    let selectedClasses = $("#lesson_note_multi_class").val();
    if (!selectedClasses || selectedClasses.length === 0) {
        selectedClasses = $("#select_class_field").val();
    }

    $.ajax({
        url: "../controller.php",
        type: "POST",
        data: {
            class_id: selectedClasses,
            subject_id: $("#select_subject_field").val(),
            week_id: $(".week_btn.active").attr("data-id"),
            topic: $("#lesson_topic").val(),
            // "body": editorInstance.getData(),
            action: "create_lesson_note_topic",
        },
        success: (response) => {
            console.log("Lesson note saved:", response);
            get_lesson_note_topic();
            setTimeout(get_notes_week_view, 100);
        },
        error: (error) => {
            console.error("Error saving lesson note:", error);
        },
    });
}
var draggableInstance;
var extraEventsDraggableInstance;

var eventToDelete;
var currentView = 'timeGridWeek'; // Default view
var calendar; // Declare calendar variable in a higher scope
var allEventsData = [];

$('#addEventForm').submit(function (event) {
    event.preventDefault();
    var eventTitle = $('#eventTitle').val();

    $.ajax({
        url: '../controller.php',
        type: 'post',
        data: {
            action: 'add_extra_event',
            title: eventTitle
        },
        success: function (response) {
            $('#eventTitle').val('')
            var newEvent = JSON.parse(response);
            if (newEvent && newEvent.id) {
                // Add the new event button to the fc-extraevent button group before the "Add new" button
                var newButtonHtml = `
                        <div class="btn-group fc-extraevent" data-id="${newEvent.id}" data-color="#17a2b8">
                            <button type="button" class="btn btn-sm extraeventbtn" style="background-color:#17a2b8; color:white;">${newEvent.title}</button>
                            <button type="button" class="btn btn-sm dropdown-toggle dropdown-icon" data-toggle="dropdown">
                                <span class="sr-only" aria-hidden="true">Toggle Dropdown</span>
                            </button>
                            <div class="dropdown-menu" role="menu">
                                <a class="dropdown-item edit-event" href="#">Edit</a>
                                <a class="dropdown-item delete-event" onclick="delete_extraevent('${newEvent.id}')" href="#">Delete</a>
                            </div>
                        </div>`;
                $(newButtonHtml).insertBefore('#addEventButton');

                // Reinitialize the draggable instance for extraevents
                if (extraEventsDraggableInstance) {
                    extraEventsDraggableInstance.destroy();
                }
                extraEventsDraggableInstance = new FullCalendar.Draggable(document.getElementById('extraevents'), {
                    itemSelector: '.fc-extraevent',
                    eventData: function (extraEv) {
                        return {
                            title: extraEv.querySelector('.extraeventbtn').innerText.trim(),
                            duration: '00:40', // Default duration for dropped events
                            backgroundColor: extraEv.getAttribute("data-color"),
                            extendedProps: {
                                eventid: extraEv.getAttribute("data-id")
                            }
                        };
                    }
                });

                // Close the modal
                $('#addEventModal').modal('hide');
            } else {
                console.error('Failed to add event:', response);
            }
        },
        error: function (xhr, status, error) {
            console.error('Error adding event:', error);
        }
    });
});



function delete_extraevent(eventId) {
    $('#extraeventid').val(eventId);
    $('#deleteEventModal').modal('show');
}
// Handle confirm delete button click
function confirmDeleteEvent() {
    $.ajax({
        url: '../controller.php',
        type: 'post',
        data: {
            action: 'delete_extra_event',
            eventid: $("#extraeventid").val()
        },
        success: function (response) {
            var result = JSON.parse(response);
            if (result.success) {
                // Remove the deleted event button from the button group
                $('.fc-extraevent[data-id="' + $("#extraeventid").val() + '"]').remove();
                $('#deleteEventModal').modal('hide');
                var calendarEvents = calendar.getEvents();
                calendarEvents.forEach(function (event) {
                    if (event.extendedProps.eventid == $("#extraeventid").val()) {
                        event.remove();
                    }
                });

                allEventsData = allEventsData.filter(event => event.event_id != $("#extraeventid").val());
            } else {
                console.error('Failed to delete event:', result.error);
            }
        },
        error: function (xhr, status, error) {
            console.error('Error deleting event:', error);
        }
    });
}

$('#delete_event').click(function () {
    console.log(eventToDelete)
    if (eventToDelete) {
        var id = eventToDelete.id;
        var subjectid = eventToDelete.extendedProps.subjectid;
        var classid = eventToDelete.extendedProps.classid;
        var eventExtendedProps = eventToDelete.extendedProps;

        if (id && subjectid && classid) {
            // Delete from time_table if event has an id
            $.ajax({
                url: '../controller.php',
                type: 'post',
                data: {
                    action: 'delete_time_table_event',
                    id: id,
                    subjectid: subjectid,
                    classid: classid
                },
                success: function (response) {
                    var result = JSON.parse(response);
                    if (result.success) {
                        eventToDelete.remove();
                        $('#deleteEvent').modal('hide');
                        allEventsData = allEventsData.filter(event => event.id != id);
                    } else {
                        console.error('Failed to delete event:', result.error);
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error deleting event:', error);
                }
            });
        } else if (eventExtendedProps.eventid && id) {
            // Delete from extraevents if event has an extendedProps.eventid
            $.ajax({
                url: '../controller.php',
                type: 'post',
                data: {
                    action: 'delete_extra_eventslot',
                    id: id
                },
                success: function (response) {
                    var result = JSON.parse(response);
                    if (result.success) {
                        eventToDelete.remove();
                        $('#deleteEvent').modal('hide');
                        allEventsData = allEventsData.filter(event => event.id != id);
                    } else {
                        console.error('Failed to delete event:', result.error);
                    }
                },
                error: function (xhr, status, error) {
                    console.error('Error deleting event:', error);
                }
            });
        } else {
            // Remove from calendar if no id or eventid
            eventToDelete.remove();
            $('#deleteEvent').modal('hide');
        }
    }
});

function edit_extraevent(eventId, ev) {
    console.log(ev)
    $('#editEventId').val(eventId);
    var eventTitle = $(ev).parents('.fc-extraevent').find('.extraeventbtn').text().trim();
    $('#editEventModal').modal('show');
    $('#editEventTitle').val(eventTitle)
}

$('#editEventForm').submit(function (event) {
    event.preventDefault();
    var eventTitle = $('#editEventTitle').val();
    var eventId = $('#editEventId').val();
    $.ajax({
        url: '../controller.php',
        type: 'post',
        data: {
            action: 'edit_extra_event',
            title: eventTitle,
            id: eventId
        },
        success: function (response) {
            var result = JSON.parse(response);
            if (result.success) {
                // Update the event button text
                $('.fc-extraevent[data-id="' + eventId + '"] .extraeventbtn').text(eventTitle);
                $('#editEventModal').modal('hide');
                var calendarEvents = calendar.getEvents();
                calendarEvents.forEach(event => {
                    if (event.extendedProps.eventid == eventId) {
                        event.setProp('title', eventTitle);
                    }
                });
            } else {
                console.error('Failed to edit event:', result.error);
            }
        },
        error: function (xhr, status, error) {
            console.error('Error editing event:', error);
        }
    });
});


function get_extrevents() {
    $.ajax({
        url: '../controller.php',
        type: 'post',
        data: {
            action: 'get_extraevents'
        },
        success: (data) => {
            let str = ''
            console.log(data)
            if (data) {
                data = JSON.parse(data)
                console.log(data)
                data.forEach((item) => {
                    str += `
                            <div class="btn-group fc-extraevent" data-id="${item.id}" data-color="${item.color}">
                                <button type="button" class="btn btn-sm extraeventbtn" style="background-color:${item.color}; color:white;">${item.events}</button>
                                <button type="button" class="btn btn-sm dropdown-toggle dropdown-icon" data-toggle="dropdown">
                                    <span class="sr-only">Toggle Dropdown</span>
                                </button>
                                <div class="dropdown-menu" role="menu">
                                    <a class="dropdown-item edit-event" onclick="edit_extraevent('${item.id}',this)">Edit</a>
                                    <a class="dropdown-item delete-event" onclick="delete_extraevent('${item.id}')" href="#">Delete</a>
                                </div>
                            </div>
                            `
                })
                str += `
                            <button type="button" id="addEventButton" class="btn btn-sm text-info font-weight-bold d-flex align-items-center" data-toggle="modal" data-target="#addEventModal"><span class="material-symbols-outlined">add</span>Add New</button>
                        `
            } else {
                // 
            }
            $("#extraevents").html(str)
            if (!draggableInstance) {
                draggableInstance = new FullCalendar.Draggable(document.getElementById('external-events'), {
                    itemSelector: '.fc-event',
                    eventData: function (eventEl) {
                        return {
                            title: `${eventEl.getAttribute("data-classname").trim()} - ${eventEl.getAttribute("data-subject").trim()}`, // Set the event title
                            duration: '00:40', // Default duration for dropped events
                            backgroundColor: eventEl.getAttribute("data-color"),
                            extendedProps: {
                                classid: eventEl.getAttribute("data-classid"),
                                subjectid: eventEl.getAttribute("data-subjectid"),
                            }
                        };
                    }
                });
            }
        }
    })
}





function get_this_subject_time_tbl(subject, classid) {
    $.ajax({
        url: '../controller.php',
        type: 'post',
        data: {
            action: 'get_this_subject_time_tbl',
            subj_id: subject,
            classid: classid
        },
        success: function (data) {
            if (data) {
                allEventsData = JSON.parse(data); // Store all event data in a global variable
                let events = [];
                allEventsData.forEach(item => {
                    let title = item.events ? item.events : `${item.classname} - ${item.subject}`;
                    events.push({
                        id: item.id,
                        title: title,
                        start: item.start,
                        end: item.end,
                        backgroundColor: item.color,
                        extendedProps: {
                            classid: item.class_id,
                            subjectid: item.subject_id,
                            eventid: item.event_id
                        }
                    });
                });
                initializeCalendar(events);
                if (!draggableInstance) {
                    // draggableInstance.destroy();


                    // Initialize FullCalendar Draggable after the events are added to the DOM
                    draggableInstance = new FullCalendar.Draggable(document.getElementById('external-events'), {
                        itemSelector: '.fc-event',
                        eventData: function (eventEl) {
                            return {
                                title: `${eventEl.getAttribute("data-classname").trim()} - ${eventEl.getAttribute("data-subject").trim()}`, // Set the event title
                                duration: '00:40', // Default duration for dropped events
                                backgroundColor: eventEl.getAttribute("data-color"),
                                extendedProps: {
                                    classid: eventEl.getAttribute("data-classid"),
                                    subjectid: eventEl.getAttribute("data-subjectid"),
                                }
                            };
                        }
                    });
                }
                if (!extraEventsDraggableInstance) {
                    extraEventsDraggableInstance = new FullCalendar.Draggable(document.getElementById('extraevents'), {
                        itemSelector: '.fc-extraevent',
                        eventData: function (extraEv) {
                            return {
                                title: extraEv.querySelector('.extraeventbtn').innerText.trim(),
                                duration: '00:40', // Default duration for dropped events
                                backgroundColor: extraEv.getAttribute("data-color"),
                                extendedProps: {
                                    eventid: extraEv.getAttribute("data-id")
                                }
                            };
                        }
                    });
                }
            }
        },
        error: function (xhr, status, error) {
            console.error('Error fetching events:', error);
        }
    });
}

// Add event listener to fc-event buttons
$(document).on('click', '.externalbtns', function () {
    var classid = $(this).data('classid');
    var subjectid = $(this).data('subjectid');
    displayEvent(classid, subjectid);
});

// Add event listener to fc-extraevent buttons
$(document).on('click', '.fc-extraevent .extraeventbtn', function () {
    var eventId = $(this).closest('.fc-extraevent').data('id');
    displayExtraEvent(eventId);
});

// Function to display the specific event
function displayEvent(classid, subjectid) {
    // alert(classid)
    // alert(subjectid)
    console.log(allEventsData);
    if (subjectid == 'all' && classid != 'all') {
        var events = allEventsData.filter(event => event.class_id == classid);
    } else if (subjectid != 'all' && classid == 'all') {
        var events = allEventsData.filter(event => event.subject_id == subjectid);
    } else if (subjectid == 'all' && classid == 'all') {
        var events = allEventsData;
    } else {
        var events = allEventsData.filter(event => event.class_id == classid && event.subject_id == subjectid);
    }
    console.log(events);
    if (events.length > 0) {
        // Clear existing events
        calendar.getEvents().forEach(event => event.remove());

        // Add each occurrence of the fetched event to the calendar
        events.forEach(event => {
            calendar.addEvent({
                id: event.id,
                title: event.events ? event.events : `${event.classname} - ${event.subject}`,
                start: event.start,
                end: event.end,
                backgroundColor: event.color,
                extendedProps: {
                    classid: event.class_id,
                    subjectid: event.subject_id,
                    eventid: event.event_id
                }
            });
        });
    } else {
        console.error('Event not found for classid:', classid, 'and subjectid:', subjectid);
    }
}

// Function to display the specific extra event
function displayExtraEvent(eventId) {
    // alert(eventId)
    console.log(allEventsData)
    var events = allEventsData.filter(event => event.event_id == eventId);
    console.log(events)
    if (events.length > 0) {
        // Clear existing events
        calendar.getEvents().forEach(event => event.remove());

        // Add each occurrence of the fetched event to the calendar
        events.forEach(event => {
            calendar.addEvent({
                id: event.id,
                title: event.events ? event.events : `${event.classname} - ${event.subject}`,
                start: event.start,
                end: event.end,
                backgroundColor: event.color,
                extendedProps: {
                    classid: event.class_id,
                    subjectid: event.subject_id,
                    eventid: event.event_id
                }
            });
        });
    } else {
        console.error('Event not found:', eventId);
    }
}

function get_time_tbl_filter() {
    $.ajax({
        url: '../controller.php',
        type: 'post',
        data: {
            action: 'get_time_tbl_filter'
        },
        success: (data) => {
            console.log(data)
            let str = ''
            if (data) {
                data = JSON.parse(data)
                // data = data[]
                str += `<div class="d-flex pb-2 custom-scrollbar" style="gap:10px; overflow-x: auto; white-space: nowrap; position: relative;">
                                    <button type="button" onclick="get_subjects_for_timetable('all','all','all','transparent')" class="btn btn-sm fixed_btn">All</button>`
                data.forEach(item => {
                    str += `<button type="button" onclick="get_subjects_for_timetable('${item.subject_cat}','${item.id}','${item.classname}','${item.color}')" class="btn btn-sm text-white" style="background-color: ${item.color};">${item.classname}</button>`
                });

                str += `</div>
                                    <div class="hr my-4" style="height: 10px; width: 100%; background-color: #ededed;"></div>
                                    <p class="small muted-text mb-2" id="info_subj_timetbl">Click any subject to reveal on table or drag to place on table</p>
                                <div id="external-events" class="custom-scrollbar subj_btns_container"></div>
                            `
            }
            $("#time_tbl_filter").html(str)
            get_subjects_for_timetable('all', 'all', 'all', 'transparent')
        }
    })
}

function get_subjects_for_timetable(subject_cat_id, id, classname, color) {
    $.ajax({
        url: '../controller.php',
        type: 'post',
        data: {
            subject_cat_id,
            action: 'get_subjects_timetable'
        },
        success: (data) => {
            let str = `<button type="button" onclick="displayEvent('${id}','all')" class="btn btn-sm btn-primary fixed_btn">All</button>`
            // let str = `<button type="button" onclick="get_this_subject_time_tbl('all','${id}')" class="btn btn-sm btn-primary fixed_btn">All</button>`
            if (data) {
                data = JSON.parse(data)
                Object.entries(data).forEach(([key, value]) => {
                    if (subject_cat_id == 'all' || id == 'all') {
                        str += `
                            <button type="button" style="border: 2px solid #e2e2e2;" data-color="${color}" data-classid="${id}" data-subjectid="${key}" data-classname="${classname}" data-subject="${value}" class="btn btn-sm externalbtns">${value}</button>
                            `
                    } else {
                        str += `
                            <button type="button" style="background-color: ${color}; border: none;" data-color="${color}" data-classid="${id}" data-subjectid="${key}" data-classname="${classname}" data-subject="${value}" class="btn btn-sm btn-primary fc-event externalbtns">${value}</button>
                            `
                    }
                })
                $("#info_subj_timetbl").show()
            } else {
                $("#info_subj_timetbl").hide()
                str = '<p class="muted text">No subject assigned for the class selected</p>'
            }
            $("#external-events").html(str)
            // get_this_subject_time_tbl('all', id)
            // get_time_tbl_events(initializeCalendar);
        }
    })

}


function togglecalendarView() {
    if (currentView === 'timeGridWeek') {
        calendar.changeView('listWeek');
        currentView = 'listWeek';
    } else {
        calendar.changeView('timeGridWeek');
        currentView = 'timeGridWeek';
    }
}

function initializeCalendar(events) {
    console.log(events)
    const calendarEl = document.getElementById('calendar');
    calendar = new FullCalendar.Calendar(calendarEl, {
        // plugins: ['interaction'], // Enable interaction plugin
        // initialView: 'listWeek', // Use week view
        initialView: 'timeGridWeek', // Use week view
        initialDate: '2025-01-16', // Start date
        slotDuration: '00:40:00', // 40-minute time slots
        slotMinTime: '08:00:00', // Start at 8 AM
        slotMaxTime: '16:00:00', // End at 4 PM
        scrollTime: '08:00:00', // Scroll to 8 AM
        contentHeight: 'auto', // Adjust content height automatically
        height: 'auto', // Let it expand based on content
        nowIndicator: true, // Show current time indicator
        headerToolbar: false,
        events: events, // Populate events dynamically
        dayHeaderFormat: {
            weekday: 'long'
        }, // Display only the weekday
        views: {
            timeGridWeek: {
                dayHeaderFormat: {
                    weekday: 'long'
                } // Customize for timeGridWeek
            },
            listWeek: {
                dayHeaderFormat: {
                    weekday: 'long'
                } // Customize for listWeek
            }
        },
        eventClick: function (info) {
            eventToDelete = info.event;
            $('#deleteEvent').modal('show');
        },
        editable: true, // Disable dragging and editing of events
        droppable: true, // Disable event dropping
        expandRows: false, // Prevent row wrapping
        aspectRatio: 2.5, // Make the calendar wider
        eventOverlap: true, // Prevent event overlap
        hiddenDays: [0, 6], // Hide Sunday (0) and Saturday (6)
        displayEventTime: true, // Hide event time from the all-day section
        allDaySlot: false, // Remove the all-day section
    });

    // Render the calendar
    calendar.render();
}


$('#saveTimetable').click(function () {
    let slotevents = calendar.getEvents();
    var eventData = slotevents.map(event => {
        let start = new Date(event.start);
        start.setHours(start.getHours() + 1);
        let end = event.end ? new Date(event.end) : null;
        if (end) {
            end.setHours(end.getHours() + 1);
        }
        return {
            id: event.id,
            start: start.toISOString(),
            end: end ? end.toISOString() : null,
            classid: event.extendedProps.classid,
            subjectid: event.extendedProps.subjectid,
            eventid: event.extendedProps.eventid
        };
    });
    console.log(eventData);
    // return
    $.ajax({
        url: '../controller.php',
        type: 'post',
        data: {
            action: 'save_time_tbl',
            events: eventData
        },
        success: function (response) {
            let savedEvents = JSON.parse(response);
            if (Array.isArray(savedEvents)) {
                savedEvents.forEach((savedEvent, index) => {
                    let event = slotevents[index];
                    event.setProp('id', savedEvent.id);
                    console.log(event);

                    // Update the allEventsData array with the new data
                    let existingEventIndex = allEventsData.findIndex(e => e.id == savedEvent.id);
                    if (existingEventIndex !== -1) {
                        allEventsData[existingEventIndex] = {
                            id: savedEvent.id,
                            start: event.start.toISOString(),
                            end: event.end ? event.end.toISOString() : null,
                            class_id: event.extendedProps.classid,
                            subject_id: event.extendedProps.subjectid,
                            event_id: event.extendedProps.eventid,
                            events: event.title,
                            color: event.backgroundColor
                        };
                    } else {
                        allEventsData.push({
                            id: savedEvent.id,
                            start: event.start.toISOString(),
                            end: event.end ? event.end.toISOString() : null,
                            class_id: event.extendedProps.classid,
                            subject_id: event.extendedProps.subjectid,
                            event_id: event.extendedProps.eventid,
                            events: event.title,
                            color: event.backgroundColor
                        });
                    }
                });
                // alert('Timetable saved successfully!');
            } else {
                console.error('Unexpected response format:', response);
            }
        },
        error: function (xhr, status, error) {
            console.error('Error saving timetable:', error);
        }
    });
});


// Add this variable outside your functions (globally or scoped appropriately)
let currentReportScale = 1.0;
const minScale = 0.5;
const maxScale = 2.5;
const scaleStep = 0.1;

// Function to apply the current scale to all report cards in the preview
function applyReportScale() {
    // alert("l")
    $('#preview-content .report-card').css('transform', 'scale(' + currentReportScale + ')');
    // $('#preview-content .report-card').css('width', '800px');

}

// Function to handle zooming in
function zoomInReport() {
    if (currentReportScale < maxScale) {
        currentReportScale = parseFloat((currentReportScale + scaleStep).toFixed(2)); // Use parseFloat and toFixed for precision
        applyReportScale();
    }
}

// Function to handle zooming out
function zoomOutReport() {
    if (currentReportScale > minScale) {
        currentReportScale = parseFloat((currentReportScale - scaleStep).toFixed(2)); // Use parseFloat and toFixed for precision
        applyReportScale();
    }
}

// Function to reset zoom
function resetReportZoom() {
    currentReportScale = 1.0;
    applyReportScale();
}



/**
 * Preview a custom report card
 * @param {string|number} report_id - The ID of the custom report to preview
 */
async function preview_custom_report_card(report_id) {
    const reportModal = $('#report_preview_modal');
    const previewContent = $('#preview-content');
    const loadingOverlay = $('.loading-overlay-report');

    // Show modal and loading state
    reportModal.modal('show');
    previewContent.empty();
    loadingOverlay.show();
    $('#print_report_btn, #download_report_btn').attr('disabled', true);

    try {
        // 1. Fetch custom report settings
        let reportResponse = await $.ajax({
            url: '../report_controller.php',
            type: 'POST',
            data: { action: 'fetch_report_by_id', report_id: report_id },
            dataType: 'json'
        });

        // Ensure reportResponse is an object
        if (typeof reportResponse === 'string') {
            try {
                reportResponse = JSON.parse(reportResponse);
            } catch (e) {
                console.error("JSON parse error:", reportResponse);
                throw new Error("Invalid response format from server");
            }
        }

        if (reportResponse.status !== 'success') {
            throw new Error(reportResponse.message || 'Failed to fetch report settings');
        }

        const reportData = reportResponse.data;
        const customAssessments = JSON.parse(reportData.assessment_type || "[]").map(a => a.toLowerCase());
        const session_id = reportData.session_id;
        const term_id = reportData.term_id;
        const school_id = reportData.school_id;

        // 2. Fetch student score data
        // For parent portal, we assume the student_id is available correctly. 
        // We'll get it from the session/context if needed, but usually, parent_portal.php has it.
        // In preview_report_card_multiple, it uses a global or passed student_id.
        // Let's assume we can get student_id from the context or a global.
        const activeStudentId = $('#select_student_field').val() || '';
        const activeClassId = $('#select_class_field').val() || '';

        let scoreResponse = await $.ajax({
            url: "../controller.php",
            type: "post",
            data: {
                action: "get_grading_score_data",
                session_id: session_id,
                student_id: activeStudentId,
                class_id: activeClassId,
                term_id: term_id,
            },
            dataType: 'json'
        });

        // Robust parsing for scoreResponse
        if (typeof scoreResponse === 'string') {
            try {
                scoreResponse = JSON.parse(scoreResponse);
            } catch (e) {
                console.error("Score response parse error:", scoreResponse);
                throw new Error("Invalid score data format from server");
            }
        }

        console.log("scoreResponse received:", scoreResponse);
        if (!scoreResponse || !scoreResponse.score_data) {
            console.error("Missing score_data in response:", scoreResponse);
            throw new Error('Failed to fetch score data');
        }

        // Set globals for other functions
        student_score_data = scoreResponse.score_data;

        if (!scoreResponse.settingsData || !scoreResponse.settingsData[0]) {
            console.error("Missing settingsData in scoreResponse:", scoreResponse);
            throw new Error('Failed to fetch school settings for this term');
        }

        settingsData = scoreResponse.settingsData[0];
        const grading = settingsData.grade;

        // Override settingsData based on custom report assessments
        settingsData.ca1 = customAssessments.includes('ca1') ? 1 : 0;
        settingsData.ca2 = customAssessments.includes('ca2') ? 1 : 0;
        settingsData.ca3 = customAssessments.includes('ca3') ? 1 : 0;
        settingsData.pra = customAssessments.includes('pra') ? 1 : 0;
        settingsData.exa = customAssessments.includes('exa') ? 1 : 0;

        // 3. Fetch custom report card HTML
        const reportCardHtml = await $.ajax({
            url: "../custom_report_card.php",
            type: "POST",
            data: {
                student_id: activeStudentId,
                class_id: activeClassId,
                session_id: session_id,
                term_id: term_id,
                report_id: report_id,
                sessionOrTerm: 'term'
            },
        });

        previewContent.html(reportCardHtml);

        // 4. Render the table with custom calculations
        const tableContainer = previewContent.find('.table_visuals_display_report_custom');
        await format_student_table_report(
            student_score_data,
            term_id,
            session_id,
            activeClassId,
            grading,
            tableContainer,
            customAssessments
        );

        // 5. Update performance summary in the header
        updateCustomReportSummary(previewContent, customAssessments, grading);

        // 6. Set behavior/skills ratings (reusing existing function if possible)
        await set_behaviour_comment_report(
            term_id,
            session_id,
            activeStudentId,
            activeClassId,
            'term',
            previewContent
        );

        loadingOverlay.hide();
        $('#print_report_btn, #download_report_btn').attr('disabled', false);
        currentReportScale = 1.0;
        applyReportScale();

    } catch (error) {
        console.error('Custom Report Preview Error:', error);
        previewContent.html(`<div class="alert alert-danger">Error: ${error.message}</div>`);
        loadingOverlay.hide();
    }
}

/**
 * Calculates and updates the summary for a custom report
 */
function updateCustomReportSummary(container, customAssessments, gradingParam) {
    let totalScore = 0;
    let totalObtainable = 0;

    container.find('#view_student_score_table tbody tr').each(function () {
        const rowTotal = parseFloat($(this).find('.total-score').text()) || 0;
        let rowMaxTotal = $(this).data('max-total');

        // Ensure rowMaxTotal is a valid number, default to 100 ONLY if undefined or null
        if (rowMaxTotal === undefined || rowMaxTotal === null) {
            rowMaxTotal = 100;
        } else {
            rowMaxTotal = parseFloat(rowMaxTotal) || 0;
        }

        totalScore += rowTotal;
        totalObtainable += rowMaxTotal;
    });

    const percentage = totalObtainable > 0 ? Math.round((totalScore / totalObtainable) * 100) : 0;
    const grader = format_grade(gradingParam);
    const grade = calculateGrade1(percentage, grader);

    container.find('.custom-total-score').text(totalScore.toFixed(1));
    container.find('.custom-total-obtainable').text(totalObtainable);
    container.find('.custom-percentage').text(percentage + '%');
    container.find('.custom-grade').text(grade);
}


// track score change starts
// async function preview_report_card_multiple(page_type,sessionOrTerm) {
//     console.log("sessionOrTerm",sessionOrTerm)
//     const previewModal = $('#report_preview_modal');
//     const previewContent = $('#preview-content');
//     const loadingDiv = $('#preview-loading');
//     const printButton = $('#print-button');
//     const loadingStatus = $('.loading-status');

//     // Reset state
//     loadedReports = 0;
//     previewContent.empty();
//     printButton.prop('disabled', true);
//     // resetReportZoom(); // Reset scale when opening modal

//     // Show modal and loading indicator
//     previewModal.modal('show');
//     loadingDiv.show();

//     // Get parameters
//     let student_ids, term_id, class_id;
//     if (page_type == 'report_page') {
//         student_ids = $(".bulk_report_ids").val().split(",")
//         term_id = $("#select_term_field").val()
//         if (term_id == 'cum') {
//             sessionOrTerm = 'session';
//             term_id = 3;
//         }
//         class_id = $("#select_class_field_report").val()
//     }
//     else if (page_type == 'student_page') {
//         student_ids = $("#select_student_field").val().split(",")
//         term_id = $(".select_btn.term.active").attr("data-name")
//         class_id = $("#select_class_field").val()
//     }
//     // const student_ids = $('.bulk_report_ids').val().split(',') || $("#select_student_field").val().split(",");
//     // alert(student_ids)
//     // // const student_ids = $('.bulk_report_ids').val().split(',') || $("#select_student_field").val().split(",");
//     // const term_id = $('#select_term_field').val() || $(".select_btn.term.active").attr("data-name");
//     const session_id = $('#select_session_field').val();
//     // const class_id = $('#select_class_field_report').val() || $("#select_class_field").val();

//     totalReports = student_ids.length;
//     loadingStatus.text(`Loading report 0 of ${totalReports}...`);

//     // Load reports one by one
//     for (const student_id of student_ids) {
//         try {
//             // First get the grading data
//             const gradingData = await $.ajax({
//                 url: '../controller.php',
//                 type: 'post',
//                 data: {
//                     action: 'get_grading_score_data',
//                     session_id,
//                     student_id,
//                     class_id,
//                     term_id
//                 }
//             });

//             data = JSON.parse(gradingData);
//             settingsData = data.settingsData[0];
//             student_score_data = data.score_data;

//             // Then get the report card HTML
//             let myschl = null;
//              const reportCard = await $.ajax({
//                 url: myschl == 13 ? '../single_report_card-homat.php' : '../single_report_card.php',
//                 type: 'POST',
//                 data: { student_id, class_id, session_id, term_id,sessionOrTerm, }
//             });

//             // Create a container for this specific report
//             const reportDiv = $('<div>').addClass('single-report').html(reportCard);
//             previewContent.append(reportDiv);

//             const tableContainer = reportDiv.find('#table_visuals_display_report');
//             const commentContainer = reportDiv.find('.student_behaviour_skills');
//             await set_behaviour_comment_report(term_id, session_id, student_id, class_id, 'view', commentContainer);
//             // alert(myschl)
//             if(myschl == 13) {
//                 if (sessionOrTerm == 'session') {
//                     await format_student_cummulative_table_report(student_score_data, student_id, session_id, class_id, settingsData.grade, tableContainer);
//                 } else if (term_id == '2') {
//                     await format_2nd_term_student_cummulative_table_report(student_score_data, student_id, session_id, class_id, settingsData.grade, tableContainer);
//                 } else {
//                     await format_student_table_report(student_score_data, term_id, session_id, class_id, settingsData.grade, tableContainer);
//                 }
//             }else {
//                 if(sessionOrTerm == 'session'){
//                     await format_student_cummulative_table_report(student_score_data, student_id, session_id, class_id, settingsData.grade, tableContainer);
//                 }else{
//                     await format_student_table_report(student_score_data, term_id, session_id, class_id, settingsData.grade, tableContainer);
//                 }
//             }

//             loadedReports++;
//             loadingStatus.text(`Loading report ${loadedReports} of ${totalReports}...`);

//             // Enable print button when all reports are loaded
//             if (loadedReports === totalReports) {
//                 loadingDiv.hide();
//                 printButton.prop('disabled', false);
//             }
//         } catch (error) {
//             console.error('Error loading report:', error);
//             // Update status to show error
//             loadingStatus.text(`Error loading report for student ${student_id}: ${error.message}`);
//         }
//     }
// }
async function preview_report_card_multiple(page_type, sessionOrTerm) {
    console.log("we neeeeeeeeeeeeeeeeeeeee")
    console.log("sessionOrTerm", sessionOrTerm);
    const previewModal = $("#report_preview_modal");
    const previewContent = $("#preview-content");
    const loadingDiv = $("#preview-loading");
    const printButton = $("#print-button");
    const downloadButton = $("#download-pdf-button");
    const loadingStatus = $(".loading-status");

    // Reset state
    loadedReports = 0;
    previewContent.empty();
    printButton.prop("disabled", true);
    downloadButton.prop("disabled", true);
    // resetReportZoom(); // Reset scale when opening modal

    // Show modal and loading indicator
    previewModal.modal("show");
    loadingDiv.show();

    // Get parameters
    let student_ids, term_id, class_id;
    if (page_type == "report_page") {
        student_ids = $(".bulk_report_ids").val().split(",");
        term_id = $("#select_term_field").val();
        if (term_id == "cum") {
            sessionOrTerm = "session";
            term_id = 3;
        }
        class_id = $("#select_class_field_report").val();
    } else if (page_type == "student_page") {
        student_ids = $("#select_student_field").val().split(",");
        term_id = $(".select_btn.term.active").attr("data-name");
        class_id = $("#select_class_field").val();
    }
    // const student_ids = $('.bulk_report_ids').val().split(',') || $("#select_student_field").val().split(",");
    // alert(student_ids)
    // // const student_ids = $('.bulk_report_ids').val().split(',') || $("#select_student_field").val().split(",");
    // const term_id = $('#select_term_field').val() || $(".select_btn.term.active").attr("data-name");
    const session_id = $("#select_session_field").val();
    // const class_id = $('#select_class_field_report').val() || $("#select_class_field").val();

    totalReports = student_ids.length;
    loadingStatus.text(`Loading report 0 of ${totalReports}...`);

    // Load reports one by one
    for (const student_id of student_ids) {
        try {
            // First get the grading data
            const gradingData = await $.ajax({
                url: "../controller.php",
                type: "post",
                data: {
                    action: "get_grading_score_data",
                    session_id,
                    student_id,
                    class_id,
                    term_id,
                },
            });

            const gradingPayload =
                typeof gradingData === "string" ? JSON.parse(gradingData) : gradingData;
            settingsData = gradingPayload.settingsData[0];
            student_score_data = gradingPayload.score_data;

            // Then get the report card HTML
            let myschl = null;
            const reportCard = await $.ajax({
                url:
                    myschl == 13
                        ? "../single_report_card-homat.php"
                        : "../single_report_card.php",
                type: "POST",
                data: { student_id, class_id, session_id, term_id, sessionOrTerm },
            });

            // Create a container for this specific report
            const reportDiv = $("<div>").addClass("single-report").html(reportCard);
            previewContent.append(reportDiv);

            const tableContainer = reportDiv.find("#table_visuals_display_report");
            const commentContainer = reportDiv.find(".student_behaviour_skills");
            const reportCardElement = reportDiv.find(".report-card").first();
            const templateTableMode =
                typeof window.getReportTemplateTableMode === "function"
                    ? window.getReportTemplateTableMode(reportCardElement, term_id, sessionOrTerm)
                    : "standard";
            await set_behaviour_comment_report(
                term_id,
                session_id,
                student_id,
                class_id,
                "view",
                commentContainer
            );
            // alert(myschl)
            if (myschl == 13) {
                if (sessionOrTerm == "session" || templateTableMode === "full_cumulative") {
                    await format_student_cummulative_table_report(
                        student_score_data,
                        student_id,
                        session_id,
                        class_id,
                        settingsData.grade,
                        tableContainer
                    );
                } else if (term_id == "2" || templateTableMode === "second_term_cumulative") {
                    await format_2nd_term_student_cummulative_table_report(
                        student_score_data,
                        student_id,
                        session_id,
                        class_id,
                        settingsData.grade,
                        tableContainer
                    );
                } else {
                    await format_student_table_report(
                        student_score_data,
                        term_id,
                        session_id,
                        class_id,
                        settingsData.grade,
                        tableContainer
                    );
                }
            } else {
                if (sessionOrTerm == "session" || templateTableMode === "full_cumulative") {
                    await format_student_cummulative_table_report(
                        student_score_data,
                        student_id,
                        session_id,
                        class_id,
                        settingsData.grade,
                        tableContainer
                    );
                } else if (templateTableMode === "second_term_cumulative") {
                    await format_2nd_term_student_cummulative_table_report(
                        student_score_data,
                        student_id,
                        session_id,
                        class_id,
                        settingsData.grade,
                        tableContainer
                    );
                } else {
                    await format_student_table_report(
                        student_score_data,
                        term_id,
                        session_id,
                        class_id,
                        settingsData.grade,
                        tableContainer
                    );
                }
            }

            loadedReports++;
            loadingStatus.text(
                `Loading report ${loadedReports} of ${totalReports}...`
            );

            // Enable buttons when all reports are loaded
            if (loadedReports === totalReports) {
                loadingDiv.hide();
                printButton.prop("disabled", false);
                downloadButton.prop("disabled", false);
            }
        } catch (error) {
            console.error("Error loading report:", error);
            // Update status to show error
            loadingStatus.text(
                `Error loading report for student ${student_id}: ${error.message}`
            );
        }
    }
}
async function format_student_table_report(student_score_data, term, session_id, class_id, grading, container, customAssessments = null) {
    return new Promise((resolve) => {
        let grader = format_grade(grading);
        console.log("format_student_table_report filter params:", { term, session_id, class_id, customAssessments });
        const nwdata = student_score_data.filter(item => {
            const matches = item.term_id == term &&
                item.session_id == session_id &&
                item.class_id == class_id;

            if (!matches) return false;

            const rowMaxTotal = customAssessments ? calculate_row_max_total(item, customAssessments) : 100;

            // For custom reports, only show if max possible score > 0
            if (customAssessments) {
                return rowMaxTotal > 0;
            }

            // For standard reports, show if there's any score recorded
            return parseFloat(item.Total) > 0;
        });
        console.log("nwdata after filter:", nwdata);
        let str = ''
        if (nwdata.length > 0) {
            str = `
<table id="view_student_score_table" class="display nowrap" style="width:100%;">
  <thead>
      <tr>
          <th>Subjects</th>
          <th class="${settingsData.ca1 == 0 ? 'd-none' : ''}">CA1</th>
          <th class="${settingsData.ca2 == 0 ? 'd-none' : ''}">CA2</th>
          <th class="${settingsData.ca3 == 0 ? 'd-none' : ''}">CA3</th>
          <th class="${settingsData.pra == 0 ? 'd-none' : ''}">Practical</th>
          <th class="${settingsData.exa == 0 ? 'd-none' : ''}">Exam</th>
      <th>Total</th>         
          <th>Total(%)</th>
          <th>Grade</th>
      </tr>
  </thead>
  <tbody>
`;

            // if () {
            nwdata.forEach(item => {
                console.log('subj', item.subject_id)
                const rowMaxTotal = customAssessments ? calculate_row_max_total(item, customAssessments) : 100;
                str += `
      <tr data-max-total="${rowMaxTotal}">
      <td>${item.subject}</td>
      <td class="score ${settingsData.ca1 == 0 ? 'd-none' : ''}">${parseFloat(item.ca1Total) > 0 ? item.CA1 : '-'}</td>
      <td class="score ${settingsData.ca2 == 0 ? 'd-none' : ''}">${parseFloat(item.ca2Total) > 0 ? item.CA2 : '-'}</td>
      <td class="score ${settingsData.ca3 == 0 ? 'd-none' : ''}">${parseFloat(item.ca3Total) > 0 ? item.CA3 : '-'}</td>
      <td class="score ${settingsData.pra == 0 ? 'd-none' : ''}">${parseFloat(item.praTotal) > 0 ? item.Practical : '-'}</td>
      <td class="score ${settingsData.exa == 0 ? 'd-none' : ''}">${parseFloat(item.exaTotal) > 0 ? item.Exam : '-'}</td>
      <td class="total-score">${customAssessments ? calculate_row_total(item, customAssessments) : item.Total}</td>
      <td class="percentage">${customAssessments ? calculate_row_percentage(item, customAssessments) : get_subject_percentage(item.subject_id, term, session_id, class_id)}</td>
      <td>${calculateGrade1(customAssessments ? calculate_row_percentage(item, customAssessments) : get_subject_percentage(item.subject_id, term, session_id, class_id), grader)}</td>
  </tr>
`
                // }
            });

            str += `</tbody>
</table>`;
        }
        container.html(str);
        if (typeof window.applyReportTemplateToRenderedTable === "function") {
            window.applyReportTemplateToRenderedTable(container.closest(".report-card"));
        }
        setTimeout(resolve, 100);
    });
}

function calculate_row_total(item, assessments) {
    let total = 0;
    const lowerAssessments = assessments.map(a => a.toLowerCase());
    if (lowerAssessments.includes('ca1') && parseFloat(item.ca1Total) > 0) total += parseFloat(item.CA1) || 0;
    if (lowerAssessments.includes('ca2') && parseFloat(item.ca2Total) > 0) total += parseFloat(item.CA2) || 0;
    if (lowerAssessments.includes('ca3') && parseFloat(item.ca3Total) > 0) total += parseFloat(item.CA3) || 0;
    if (lowerAssessments.includes('practical') && parseFloat(item.praTotal) > 0) total += parseFloat(item.Practical) || 0;
    if (lowerAssessments.includes('exam') && parseFloat(item.exaTotal) > 0) total += parseFloat(item.Exam) || 0;
    return total;
}

function calculate_row_max_total(item, assessments) {
    let maxTotal = 0;
    const lowerAssessments = assessments.map(a => a.toLowerCase());
    if (lowerAssessments.includes('ca1')) maxTotal += parseFloat(item.ca1Total) || 0;
    if (lowerAssessments.includes('ca2')) maxTotal += parseFloat(item.ca2Total) || 0;
    if (lowerAssessments.includes('ca3')) maxTotal += parseFloat(item.ca3Total) || 0;
    if (lowerAssessments.includes('practical')) maxTotal += parseFloat(item.praTotal) || 0;
    if (lowerAssessments.includes('exam')) maxTotal += parseFloat(item.exaTotal) || 0;
    return maxTotal;
}

function calculate_row_percentage(item, assessments) {
    let total = calculate_row_total(item, assessments);
    let maxTotal = calculate_row_max_total(item, assessments);

    if (maxTotal > 0) {
        return Math.round((total / maxTotal) * 100).toString();
    }
    return "0";
}
async function format_student_cummulative_table_report(student_score_data, student_id, session_id, class_id, grading_param, containerSelector) {
    // student_score_data: Array of all score objects
    // student_id: The ID of the student for whom the report is generated
    // session_id: The ID of the academic session
    // class_id: The ID of the class
    // grading_param: The grading scale string (e.g., "A:90,B:80...")
    // containerSelector: jQuery selector for the HTML element to place the table (e.g., "#reportContainer")

    return new Promise((resolve) => {
        let grader = format_grade(grading_param); // Assumes format_grade is available

        // Filter data for the specific student, session, and class.
        const filteredData = student_score_data.filter(record =>
            record.student_id === student_id.toString() &&
            record.session_id === session_id.toString() &&
            record.class_id === class_id.toString()
        );

        if (filteredData.length === 0) {
            $(containerSelector).html("<p>No cumulative score data available for this student in the selected session/class.</p>");
            resolve();
            return;
        }

        // Helper function to get specific score data for a subject and term
        function getScoreForTerm(subjectRecords, termId, scoreField) {
            const termRecord = subjectRecords.find(record => record.term_id === termId.toString());
            // scoreField will be 'CA1', 'CA2', 'CA3', 'Practical', 'Exam'
            return termRecord && termRecord[scoreField] != null ? termRecord[scoreField] : '-';
        }

        // Helper function to get total score for a subject and term from the 'Total' field
        function getTotalScoreForTerm(subjectRecords, termId) {
            const termRecord = subjectRecords.find(record => record.term_id === termId.toString());
            return termRecord && termRecord.Total != null ? parseFloat(termRecord.Total) : 0;
        }

        // Helper function to get max obtainable score for a subject and term
        function getMaxObtainableForTerm(subjectRecords, termId) {
            const termRecord = subjectRecords.find(record => record.term_id === termId.toString());
            if (!termRecord) return 0;
            // Assumes student_score_data items have ca1Total, ca2Total, ca3Total, praTotal, exaTotal
            return (parseFloat(termRecord.ca1Total) || 0) +
                (parseFloat(termRecord.ca2Total) || 0) +
                (parseFloat(termRecord.ca3Total) || 0) +
                (parseFloat(termRecord.praTotal) || 0) +
                (parseFloat(termRecord.exaTotal) || 0);
        }

        // Get a unique list of subjects from the filtered data
        const subjectsInfo = [];
        const subjectMap = new Map();
        filteredData.forEach(record => {
            if (!subjectMap.has(record.subject_id)) {
                subjectMap.set(record.subject_id, true);
                // Assuming 'subject' is the name field from your data
                subjectsInfo.push({ id: record.subject_id, name: record.subject });
            }
        });

        // Calculate colspan for "3rd Term" assessments
        let thirdTermColspan = 0;
        if (settingsData.ca1 != 0) thirdTermColspan++;
        if (settingsData.ca2 != 0) thirdTermColspan++;
        if (settingsData.ca3 != 0) thirdTermColspan++;
        if (settingsData.pra != 0) thirdTermColspan++;
        if (settingsData.exa != 0) thirdTermColspan++;

        // Ensure colspan is at least 1 if no assessments are active, to prevent invalid HTML
        // Or, you might want to hide the "3rd Term" header entirely if thirdTermColspan is 0.
        // For now, let's assume it should be at least 1 or hide if 0.
        const thirdTermHeaderVisible = thirdTermColspan > 0;


        let tableHtml = `
            <table id="cumulative_student_score_table_${student_id}" class="display nowrap table table-bordered table-striped" style="width:100%;">
                <thead>
                     <tr>
                        <th rowspan="2" style="vertical-align: middle;">Subjects</th>
                        ${thirdTermHeaderVisible ? `<th colspan="${thirdTermColspan}" class="text-center">3rd Term</th>` : ''}
                        <th colspan="3" class="text-center">Term Totals</th>
                        <th rowspan="2" style="vertical-align: middle;">Total</th>
                        <th rowspan="2" style="vertical-align: middle;">Avg</th>
                        <th rowspan="2" style="vertical-align: middle;">(%)</th>
                        <th rowspan="2" style="vertical-align: middle;">Grade</th>
                    </tr>
                    <tr>
                        ${settingsData.ca1 == 0 ? '' : '<th>CA1</th>'}
                        ${settingsData.ca2 == 0 ? '' : '<th>CA2</th>'}
                        ${settingsData.ca3 == 0 ? '' : '<th>CA3</th>'}
                        ${settingsData.pra == 0 ? '' : '<th>Practical</th>'}
                        ${settingsData.exa == 0 ? '' : '<th>Exam</th>'}
                        
                        <th>1st</th>
                        <th>2nd</th>
                        <th>3rd</th>
                    </tr>
                </thead>
                <tbody>
        `;

        subjectsInfo.forEach(subject => {
            const subjectRecords = filteredData.filter(record => record.subject_id === subject.id);

            const term1TotalScore = getTotalScoreForTerm(subjectRecords, '1');
            const term2TotalScore = getTotalScoreForTerm(subjectRecords, '2');
            const term3TotalScore = getTotalScoreForTerm(subjectRecords, '3');

            const term1MaxObtainable = getMaxObtainableForTerm(subjectRecords, '1');
            const term2MaxObtainable = getMaxObtainableForTerm(subjectRecords, '2');
            const term3MaxObtainable = getMaxObtainableForTerm(subjectRecords, '3');

            const cumulativeScore = term1TotalScore + term2TotalScore + term3TotalScore;
            const cumulativeMaxObtainable = term1MaxObtainable + term2MaxObtainable + term3MaxObtainable;
            console.log("cumulativeMaxObtainable", cumulativeMaxObtainable)

            let termsWithScoresCount = 0;
            if (term1MaxObtainable > 0) termsWithScoresCount++;
            if (term2MaxObtainable > 0) termsWithScoresCount++;
            if (term3MaxObtainable > 0) termsWithScoresCount++;

            const averageScore = termsWithScoresCount > 0 ? (cumulativeScore / termsWithScoresCount) : 0;
            const overallPercentage = cumulativeMaxObtainable > 0 ? ((cumulativeScore / cumulativeMaxObtainable) * 100) : 0;
            // Assumes calculateGrade1 is available and handles percentage input
            const grade = calculateGrade1(overallPercentage.toFixed(0), grader);

            tableHtml += `
                <tr>
                    <td>${subject.name}</td>
                    <!-- 3rd Term Scores -->
                    ${settingsData.ca1 == 0 ? '' : `<td>${getScoreForTerm(subjectRecords, '3', 'CA1')}</td>`}
                    ${settingsData.ca2 == 0 ? '' : `<td>${getScoreForTerm(subjectRecords, '3', 'CA2')}</td>`}
                    ${settingsData.ca3 == 0 ? '' : `<td>${getScoreForTerm(subjectRecords, '3', 'CA3')}</td>`}
                    ${settingsData.pra == 0 ? '' : `<td>${getScoreForTerm(subjectRecords, '3', 'Practical')}</td>`}
                    ${settingsData.exa == 0 ? '' : `<td>${getScoreForTerm(subjectRecords, '3', 'Exam')}</td>`}
                    
                    <!-- Term Totals -->
                    <td>${term1TotalScore > 0 || term1MaxObtainable > 0 ? term1TotalScore.toFixed(0) : '-'}</td>
                    <td>${term2TotalScore > 0 || term2MaxObtainable > 0 ? term2TotalScore.toFixed(0) : '-'}</td>
                    <td>${term3TotalScore > 0 || term3MaxObtainable > 0 ? term3TotalScore.toFixed(0) : '-'}</td>
                    <!-- Cumulative Stats -->
                    <td>${cumulativeScore > 0 || cumulativeMaxObtainable > 0 ? cumulativeScore.toFixed(0) : '-'}</td>
                    <td>${averageScore > 0 ? averageScore.toFixed(0) : '-'}</td>
                    <td>${overallPercentage > 0 ? overallPercentage.toFixed(0) + '%' : '-'}</td>
                    <td>${grade}</td>
                </tr>
            `;
        });

        tableHtml += `
                </tbody>
            </table>
        `;

        $(containerSelector).html(tableHtml);
        if (typeof window.applyReportTemplateToRenderedTable === "function") {
            window.applyReportTemplateToRenderedTable($(containerSelector).closest(".report-card"));
        }

        const tableId = `#cumulative_student_score_table_${student_id}`;
        // if ($.fn.DataTable.isDataTable(tableId)) {
        //     $(tableId).DataTable().destroy();
        // }
        // $(tableId).DataTable({
        //     scrollX: true,
        //     paging: false,
        //     ordering: true,
        //     info: false,
        //     searching: false,
        //     fixedColumns: {
        //         left: 1
        //     }
        // });

        setTimeout(resolve, 100); // Resolve after a short delay for DOM updates
    });
}
async function format_2nd_term_student_cummulative_table_report(student_score_data, student_id, session_id, class_id, grading_param, containerSelector) {
    // student_score_data: Array of all score objects
    // student_id: The ID of the student for whom the report is generated
    // session_id: The ID of the academic session
    // class_id: The ID of the class
    // grading_param: The grading scale string (e.g., "A:90,B:80...")
    // containerSelector: jQuery selector for the HTML element to place the table (e.g., "#reportContainer")

    return new Promise((resolve) => {
        let grader = format_grade(grading_param);
        const filteredData = student_score_data.filter(record =>
            record.student_id === student_id.toString() &&
            record.session_id === session_id.toString() &&
            record.class_id === class_id.toString()
        );
        if (filteredData.length === 0) {
            $(containerSelector).html("<p>No cumulative score data available for this student in the selected session/class.</p>");
            resolve();
            return;
        }
        // Helper function to get specific score data for a subject and term
        function getScoreForTerm(subjectRecords, termId, scoreField) {
            const termRecord = subjectRecords.find(record => record.term_id === termId.toString());
            return termRecord && termRecord[scoreField] != null ? termRecord[scoreField] : '-';
        }
        // Helper function to get total score for a subject and term from the 'Total' field
        function getTotalScoreForTerm(subjectRecords, termId) {
            const termRecord = subjectRecords.find(record => record.term_id === termId.toString());
            return termRecord && termRecord.Total != null ? parseFloat(termRecord.Total) : 0;
        }
        // Helper function to get max obtainable score for a subject and term
        function getMaxObtainableForTerm(subjectRecords, termId) {
            const termRecord = subjectRecords.find(record => record.term_id === termId.toString());
            if (!termRecord) return 0;
            return (parseFloat(termRecord.ca1Total) || 0) +
                (parseFloat(termRecord.ca2Total) || 0) +
                (parseFloat(termRecord.ca3Total) || 0) +
                (parseFloat(termRecord.praTotal) || 0) +
                (parseFloat(termRecord.exaTotal) || 0);
        }
        // Get a unique list of subjects from the filtered data
        const subjectsInfo = [];
        const subjectMap = new Map();
        filteredData.forEach(record => {
            if (!subjectMap.has(record.subject_id)) {
                subjectMap.set(record.subject_id, true);
                subjectsInfo.push({ id: record.subject_id, name: record.subject });
            }
        });
        // Calculate colspan for second term assessments (only for second term)
        let secondTermColspan = 0;
        if (settingsData.ca1 != 0) secondTermColspan++;
        if (settingsData.ca2 != 0) secondTermColspan++;
        if (settingsData.ca3 != 0) secondTermColspan++;
        if (settingsData.pra != 0) secondTermColspan++;
        if (settingsData.exa != 0) secondTermColspan++;
        const secondTermHeaderVisible = secondTermColspan > 0;
        let tableHtml = `
            <table id="cumulative_student_score_table_${student_id}" class="display nowrap table table-bordered table-striped" style="width:100%;">
                <thead>
                     <tr>
                        <th rowspan="2" style="vertical-align: middle;">Subjects</th>
                        ${secondTermHeaderVisible ? `<th colspan="${secondTermColspan}" class="text-center">2nd Term</th>` : ''}
                        <th colspan="2" class="text-center">Term Totals</th>
                        <th rowspan="2" style="vertical-align: middle;">Total</th>
                        <th rowspan="2" style="vertical-align: middle;">Avg</th>
                        <th rowspan="2" style="vertical-align: middle;">(%)</th>
                        <th rowspan="2" style="vertical-align: middle;">Grade</th>
                    </tr>
                    <tr>
                        ${settingsData.ca1 == 0 ? '' : '<th>CA1</th>'}
                        ${settingsData.ca2 == 0 ? '' : '<th>CA2</th>'}
                        ${settingsData.ca3 == 0 ? '' : '<th>CA3</th>'}
                        ${settingsData.pra == 0 ? '' : '<th>Practical</th>'}
                        ${settingsData.exa == 0 ? '' : '<th>Exam</th>'}
                        <th style="text-align:center;">1st</th>
                        <th style="text-align:center">2nd</th>
                    </tr>
                </thead>
                <tbody>
        `;
        subjectsInfo.forEach(subject => {
            const subjectRecords = filteredData.filter(record => record.subject_id === subject.id);
            const term1TotalScore = getTotalScoreForTerm(subjectRecords, '1');
            const term2TotalScore = getTotalScoreForTerm(subjectRecords, '2');
            const term1MaxObtainable = getMaxObtainableForTerm(subjectRecords, '1');
            const term2MaxObtainable = getMaxObtainableForTerm(subjectRecords, '2');
            const cumulativeScore = term1TotalScore + term2TotalScore;
            const cumulativeMaxObtainable = term1MaxObtainable + term2MaxObtainable;
            let termsWithScoresCount = 0;
            if (term1MaxObtainable > 0) termsWithScoresCount++;
            if (term2MaxObtainable > 0) termsWithScoresCount++;
            const averageScore = termsWithScoresCount > 0 ? (cumulativeScore / termsWithScoresCount) : 0;
            const overallPercentage = cumulativeMaxObtainable > 0 ? ((cumulativeScore / cumulativeMaxObtainable) * 100) : 0;
            const grade = calculateGrade1(overallPercentage.toFixed(0), grader);
            tableHtml += `
                <tr>
                    <td>${subject.name}</td>
                    <!-- 2nd Term Scores -->
                    ${settingsData.ca1 == 0 ? '' : `<td>${getScoreForTerm(subjectRecords, '2', 'CA1')}</td>`}
                    ${settingsData.ca2 == 0 ? '' : `<td>${getScoreForTerm(subjectRecords, '2', 'CA2')}</td>`}
                    ${settingsData.ca3 == 0 ? '' : `<td>${getScoreForTerm(subjectRecords, '2', 'CA3')}</td>`}
                    ${settingsData.pra == 0 ? '' : `<td>${getScoreForTerm(subjectRecords, '2', 'Practical')}</td>`}
                    ${settingsData.exa == 0 ? '' : `<td>${getScoreForTerm(subjectRecords, '2', 'Exam')}</td>`}
                    <!-- Term Totals -->
                    <td style="text-align:center">${term1TotalScore > 0 || term1MaxObtainable > 0 ? term1TotalScore.toFixed(0) : '-'}</td>
                    <td style="text-align:center">${term2TotalScore > 0 || term2MaxObtainable > 0 ? term2TotalScore.toFixed(0) : '-'}</td>
                    <!-- Cumulative Stats -->
                    <td>${cumulativeScore > 0 || cumulativeMaxObtainable > 0 ? cumulativeScore.toFixed(0) : '-'}</td>
                    <td>${averageScore > 0 ? averageScore.toFixed(0) : '-'}</td>
                    <td>${overallPercentage > 0 ? overallPercentage.toFixed(0) + '%' : '-'}</td>
                    <td>${grade}</td>
                </tr>
            `;
        });
        tableHtml += `
                </tbody>
            </table>
        `;
        $(containerSelector).html(tableHtml);
        if (typeof window.applyReportTemplateToRenderedTable === "function") {
            window.applyReportTemplateToRenderedTable($(containerSelector).closest(".report-card"));
        }
        const tableId = `#cumulative_student_score_table_${student_id}`;
        setTimeout(resolve, 100);
    });
}
// async function set_behaviour_comment_report(term, session, student_id, class_id, pagetype, container) {
//     // alert('kkk')
//     if ($("#report_page").val() === 'report_scores') {
//         pagetype = 'report'
//     }

//     return new Promise((resolve) => {
//         $.ajax({
//             url: "../controller.php",
//             type: "post",
//             data: {
//                 'action': 'getbehaviour_comment',
//                 term,
//                 session,
//                 student_id,
//                 class_id,
//                 pagetype
//             },
//             success: (data) => {
//                 data = data.trim();
//                 data = JSON.parse(data);
//                 // alert(data.staff_classId)
//                 // let staff_classId_json = JSON.parse(data.staff_classId)
//                 // alert((data.staff_classId).includes(class_id))
//                 thebehavedata = data.comment;
//                 // alert('ll')
//                 function getPercentage(score) {
//                     switch (score) {
//                         case "5": return "5";
//                         case "4": return "4";
//                         case "3": return "3";
//                         case "2": return "2";
//                         case "1": return "1";
//                         default: return "Not rated";
//                     }
//                 }
//                 if (thebehavedata == '') {
//                     let behave = ['punctuality', 'classattendance', 'resptoass', 'Politeness', 'Honesty', 'selfcontrol', 'relationship', 'responsibility', 'organizationability', 'Neatness', 'Obedience', 'Creativity', 'Writing', 'Fluency', 'Sport', 'Games', 'DrawingPainting', 'Music', 'HandlingTools', 'Crafts'];

//                     behave.map((key) => {
//                         container.find(`.${key}`).html(getPercentage(0))
//                     })
//                 } else {
//                     par = JSON.parse(thebehavedata)
//                     Object.entries(par).forEach(([key, value]) => {
//                         container.find(`.${key}`).html(getPercentage(value))
//                     })
//                 }
//                 resolve();
//             }
//         })
//     });
// }
async function set_behaviour_comment_report(
    term,
    session,
    student_id,
    class_id,
    pagetype,
    container
) {
    // alert('kkk')
    if ($("#report_page").val() === "report_scores") {
        pagetype = "report";
    }

    return new Promise((resolve) => {
        $.ajax({
            url: "../controller.php",
            type: "post",
            data: {
                action: "getbehaviour_comment",
                term,
                session,
                student_id,
                class_id,
                pagetype,
            },
            success: (data) => {
                data = typeof data === "string" ? JSON.parse(data.trim()) : data;
                // alert(data.staff_classId)
                // let staff_classId_json = JSON.parse(data.staff_classId)
                // alert((data.staff_classId).includes(class_id))
                thebehavedata = data.comment;
                // alert('ll')
                function getPercentage(score) {
                    switch (score) {
                        case "5":
                            return "5";
                        case "4":
                            return "4";
                        case "3":
                            return "3";
                        case "2":
                            return "2";
                        case "1":
                            return "1";
                        default:
                            return "Not rated";
                    }
                }
                if (thebehavedata == "") {
                    let behave =
                        typeof window.schoolSkills !== "undefined" &&
                            Array.isArray(window.schoolSkills) &&
                            window.schoolSkills.length > 0
                            ? window.schoolSkills
                            : [
                                "punctuality",
                                "classattendance",
                                "resptoass",
                                "Politeness",
                                "Honesty",
                                "selfcontrol",
                                "relationship",
                                "responsibility",
                                "organizationability",
                                "Neatness",
                                "Obedience",
                                "Creativity",
                                "Writing",
                                "Fluency",
                                "Sport",
                                "Games",
                                "DrawingPainting",
                                "Music",
                                "HandlingTools",
                                "Crafts",
                            ];
                    if (
                        typeof window.schoolHiddenSkills !== "undefined" &&
                        Array.isArray(window.schoolHiddenSkills)
                    ) {
                        behave = behave.filter(
                            (skill) => !window.schoolHiddenSkills.includes(skill)
                        );
                    }
                    console.log("new skills", behave)
                    behave.map((key) => {
                        container.find(`.${key}`).html(getPercentage(0));
                    });
                } else {
                    par = JSON.parse(thebehavedata);
                    Object.entries(par).forEach(([key, value]) => {
                        container.find(`.${key}`).html(getPercentage(value));
                    });
                }
                resolve();
            },
        });
    });
}
function printReports() {
    // Get the content to print
    const content = document.getElementById('preview-content');
    // $('#preview-content .report-card').css('width', '100%');
    // alert('print')
    // $('#preview-content .report-card').css('transform', 'scale(' + currentReportScale + ')');


    // Create a new window for printing
    const printWindow = window.open('', '', 'height=600,width=1200');

    // Add the content and necessary styles to the new window
    printWindow.document.write('<html><head><title>Report Card</title>');
    printWindow.document.write('<link rel="stylesheet" href="../dist/css/adminlte.css">');
    printWindow.document.write('<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">');
    printWindow.document.write(`<style>
            @media print { 
            body { padding: 0; margin: 0; }
                        .report-card {
                            page-break-after: always;
                            page-break-inside: avoid;
                        }
                        /* Ensure last page doesn't have an extra blank page */
                        .report-card:last-child {
                            page-break-after: avoid;
                        } 
            }
            </style>`);
    printWindow.document.write('</head><body>');
    printWindow.document.write(content.innerHTML);
    printWindow.document.write('</body></html>');

    printWindow.document.close();

    // Wait for the styles to load
    printWindow.onload = function () {
        printWindow.focus();
        printWindow.print();
        printWindow.close();
    };
}

// Function to enable print button when all reports are loaded
function updatePrintButton() {
    const printButton = document.getElementById('print-button');
    if (loadedReports === totalReports && totalReports > 0) {
        printButton.disabled = false;
    } else {
        printButton.disabled = true;
    }
}

function check_score_changes() {
    $("#score_change_check_modal").modal('show');
    getChangeLogs('score_update');
}
function getChangeLogs(actionType = null) {
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: {
            action: 'get_change_logs',
            action_type: actionType
        },
        success: function (response) {
            const logs = JSON.parse(response);
            displayChangeLogs(logs);
        },
        error: function (xhr, status, error) {
            toastr.error("Error fetching change logs");
        }
    });
}

function displayChangeLogs(logs) {
    let html = `
    <div class="row mt-3">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Change History</h3>
                    <div class="card-tools">
                        <button type="button" class="btn btn-sm btn-primary" onclick="getChangeLogs('score_update')">
                            Score Changes
                        </button>
                        <button type="button" class="btn btn-sm btn-info" onclick="getChangeLogs('staff_update')">
                            Staff Changes
                        </button>
                    </div>
                </div>
                <div class="card-body">
                    <div class="timeline">`;

    // Group logs by date
    const groupedLogs = {};
    logs.forEach(log => {
        const date = new Date(log.timestamp).toLocaleDateString();
        if (!groupedLogs[date]) {
            groupedLogs[date] = [];
        }
        groupedLogs[date].push(log);
    });

    Object.keys(groupedLogs).forEach(date => {
        html += `
        <div class="time-label">
            <span class="bg-red">${date}</span>
        </div>`;

        groupedLogs[date].forEach(log => {
            const changes = typeof log.changes === 'string' ? JSON.parse(log.changes) : log.changes;
            let changesHtml = '';
            let timelineIcon = '';
            let timelineColor = '';

            if (log.action_type === 'score_update') {
                timelineIcon = 'fas fa-edit';
                timelineColor = 'bg-blue';

                changesHtml = `
                 <table class="changes_table display nowrap" style="width:100%">
                        <thead>
                            <tr>
                                <th>Student</th>
                                <th>Subject</th>
                                <th>Assessment Type</th>
                                <th>From</th>
                                <th>To</th>
                                <th>Change Type</th>
                                <th>Class</th>
                            </tr>
                        </thead>
                        <tbody>`;

                Object.entries(changes.changes || {}).forEach(([studentId, studentChanges]) => {
                    studentChanges.forEach(change => {
                        changesHtml += `
                        <tr>
                            <td>${change.student_name}</td>
                            <td>${change.subject_name}</td>
                            <td>${change.field}</td>
                            <td>${change.old}</td>
                            <td>${change.new}</td>
                            <td><span class="badge ${change.change_type === 'new_entry' ? 'bg-success' : 'bg-warning'}">${change.change_type}</span></td>
                            <td>${changes.class_name || 'N/A'}</td>
                        </tr>`;
                    });
                });

                changesHtml += `
                    </tbody>
                </table>`;

            } else if (log.action_type === 'staff_update') {
                timelineIcon = 'fas fa-user-edit';
                timelineColor = 'bg-green';

                changesHtml = `
                <table class="table table-bordered table-sm">
                    <thead>
                        <tr>
                            <th>Field</th>
                            <th>From</th>
                            <th>To</th>
                        </tr>
                    </thead>
                    <tbody>`;

                Object.entries(changes.changes || {}).forEach(([field, change]) => {
                    changesHtml += `
                    <tr>
                        <td>${change.field}</td>
                        <td>${change.old}</td>
                        <td>${change.new}</td>
                    </tr>`;
                });

                changesHtml += `
                    </tbody>
                </table>`;
            }

            html += `
            <div>
                <i class="${timelineIcon} ${timelineColor}"></i>
                <div class="timeline-item">
                    <span class="time">
                        <i class="fas fa-clock"></i> 
                        ${new Date(log.timestamp).toLocaleTimeString()}
                    </span>
                    <h3 class="timeline-header">
                        <a href="#">${log.user_name}</a> made ${log.action_type} changes
                    </h3>
                    <div class="timeline-body">
                        ${changesHtml}
                    </div>
                </div>
            </div>`;
        });
    });

    html += `
                        <div>
                            <i class="fas fa-clock bg-gray"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>`;

    $('#change_timeline').html(html);
    // Initialize DataTable with fixed first column
    if ($.fn.DataTable.isDataTable('#changes_table')) {
        $('.changes_table').DataTable().destroy();
    }

    $('.changes_table').DataTable({
        scrollX: true,
        fixedColumns: {
            left: 1 // Fix the first column (Student)
        },
        ordering: true,
        paging: true,
        pageLength: 10,
        dom: 'Bfrtip',
        buttons: ['copy', 'excel', 'pdf']
    });
}

function track_scores_changes() {
    $.ajax({
        url: '../controller.php',
        type: 'POST',
        data: {
            action: 'track_scores_changes'
        },
        success: function (response) {
            console.log(response);
        }
    });
}



$('.select2').select2()

// if ('serviceWorker' in navigator && navigator.serviceWorker.controller) {
//   navigator.serviceWorker.controller.postMessage({
//     type: 'precache',
//     urls: [
//       'https://cdnjs.cloudflare.com/ajax/libs/summernote/0.9.1/summernote-bs4.min.js',
//       'https://cdnjs.cloudflare.com/ajax/libs/summernote/0.9.1/summernote-bs4.min.css',
//     //   'https://cdnjs.cloudflare.com/ajax/libs/mathquill/0.10.1/mathquill.min.css',
//     //   'https://cdnjs.cloudflare.com/ajax/libs/mathquill/0.10.1/mathquill.min.js'
//     ]
//   });
// }
