function money(val) {
    return '₦' + Number(val || 0).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}


function recalculate_balance(data) {
    // Get the initial balance from the data attribute. This doesn't change.
    const initialBalanceString = $(data).attr("data-current_balance");

    // Convert the money string (e.g., "₦5,000.00") to a number
    // by removing all characters that are not digits, a decimal point, or a minus sign.
    const initialBalance = parseFloat(initialBalanceString.replace(/[^\d.-]/g, '')) || 0;

    // Get the amount currently being paid from the input's value
    const amountPaid = parseFloat($(data).val()) || 0;

    // Calculate the new balance based on the initial balance
    let newBalance = initialBalance - amountPaid;

    // Ensure balance doesn't go below zero
    if (newBalance < 0) {
        newBalance = 0;record_payment
    }

    // Update the display with the newly formatted balance
    $('#amount_balance_record_payment').html(money(newBalance));
}
$(document).ready(function () {
    // --- Share Receipt Button Logic ---
    $(document).on('click', '#shareReceiptButton', function () {
        const element = document.getElementById('printableReceipt');
        if (!element) return toastr.error('No receipt to share.');
        // Show loading
        const $btn = $(this);
        $btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Sharing...');
        html2pdf().from(element).outputPdf('blob').then(function (pdfBlob) {
            // Try Web Share API for WhatsApp (and others)
            const file = new File([pdfBlob], 'receipt.pdf', { type: 'application/pdf' });
            if (navigator.canShare && navigator.canShare({ files: [file] })) {
                navigator.share({
                    files: [file],
                    title: 'Payment Receipt',
                    text: 'Here is your payment receipt.'
                }).then(function () {
                    $btn.prop('disabled', false).html('<i class="fas fa-share-alt"></i> Share');
                    toastr.success('Shared successfully!');
                }).catch(function (err) {
                    $btn.prop('disabled', false).html('<i class="fas fa-share-alt"></i> Share');
                    // If user cancels, do nothing. If error, fallback.
                    if (err && err.name !== 'AbortError') fallbackShare();
                });
            } else {
                fallbackShare();
            }

            function fallbackShare() {
                // Fallback: upload for WhatsApp link and show modal as before
                var formData = new FormData();
                formData.append('action', 'upload_receipt_pdf');
                formData.append('file', pdfBlob, 'receipt.pdf');
                $.ajax({
                    url: '../billing_controller.php',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    dataType: 'json',
                    success: function (res) {
                        $btn.prop('disabled', false).html('<i class="fas fa-share-alt"></i> Share');
                        let shareHtml = '<div class="text-center mb-2">Share this receipt:</div>' +
                            '<div class="d-flex justify-content-center">' +
                            (res.success && res.url ? '<a href="https://wa.me/?text=' + encodeURIComponent('Here is your payment receipt: ' + res.url) + '" target="_blank" class="btn btn-success mr-2"><i class="fab fa-whatsapp"></i> WhatsApp</a>' : '') +
                            '<button class="btn btn-primary" id="emailShareBtn"><i class="fas fa-envelope"></i> Email</button>' +
                            '</div>';
                        // Use Bootstrap modal or a simple alert
                        let $modal = $('#shareReceiptModal');
                        if ($modal.length === 0) {
                            $('body').append('<div class="modal fade" id="shareReceiptModal" tabindex="-1" role="dialog"><div class="modal-dialog modal-dialog-centered" role="document"><div class="modal-content"><div class="modal-header"><h5 class="modal-title">Share Receipt</h5><button type="button" class="close" data-dismiss="modal"><span>&times;</span></button></div><div class="modal-body" id="shareReceiptModalBody"></div></div></div></div>');
                            $modal = $('#shareReceiptModal');
                        }
                        $('#shareReceiptModalBody').html(shareHtml);
                        $modal.modal('show');
                        // Email share handler (send PDF as base64, not URL)
                        $modal.off('click', '#emailShareBtn').on('click', '#emailShareBtn', function () {
                            let email = prompt('Enter recipient email:');
                            if (!email) return;
                            // Convert blob to base64
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                const base64data = e.target.result.split(',')[1]; // Remove data:application/pdf;base64,
                                // Send email via backend with base64
                                $.ajax({
                                    url: '../billing_controller.php',
                                    type: 'POST',
                                    data: JSON.stringify({ action: 'email_receipt_pdf_data', email: email, pdf_base64: base64data }),
                                    contentType: 'application/json',
                                    dataType: 'json',
                                    success: function (resp) {
                                        if (resp.success) {
                                            toastr.success('Receipt sent via email!');
                                        } else {
                                            toastr.error(resp.message || 'Failed to send email.');
                                        }
                                    },
                                    error: function () { toastr.error('Failed to send email.'); }
                                });
                            };
                            reader.readAsDataURL(pdfBlob);
                        });
                    },
                    error: function () {
                        $btn.prop('disabled', false).html('<i class="fas fa-share-alt"></i> Share');
                        toastr.error('Failed to upload receipt for sharing.');
                    }
                });
            }
        });
    });
   
    // --- Unified Payment Receipt Modal Logic ---
    function showPaymentReceiptModal({ billId, paymentId = null, studentId = null, last = false }) {
        const $modal = $('#paymentReceiptPreviewModal');
        const $content = $('#paymentReceiptContent');
        $content.html('<div class="text-center text-muted p-5"><i class="fas fa-spinner fa-spin fa-2x"></i><br>Loading receipt...</div>');
        $modal.modal('show');
    
        let ajaxData = { bill_id: billId };
        const termId = $('.term_btn.select_btn.active').attr('data-id') || $('#select_term_field').val();
        const sessionId = $('#select_session_field').val();
        if (termId) ajaxData.term_id = termId;
        if (sessionId) ajaxData.session_id = sessionId;
    
        let action = 'get_payment_receipt';
        if (last) {
            action = 'get_last_payment_receipt';
            ajaxData.student_id = studentId;
        } else {
            ajaxData.payment_id = paymentId;
        }
        ajaxData.action = action;
    
        $.ajax({
            url: '../billing_controller.php',
            method: 'POST',
            dataType: 'json',
            data: ajaxData,
            success: function (res) {
                if (!res.success || !res.data) {
                    $content.html('<div class="alert alert-danger text-center">No payment yet!.</div>');
                    return;
                }
                const d = res.data;
                const logoUrl = d.school_logo ? `../uploads/${d.school_logo}` : '';
                const student = d.student || {};
                const bill = d.bill || {};
                const billType = d.bill_type || {};
                const payment = d.payment || {};
                
                let breakdown = [];
                try {
                    breakdown = bill.bill_items ? JSON.parse(bill.bill_items) : [];
                } catch (e) { breakdown = []; }
    
                const formatDate = dt => {
                    if (!dt) return '-';
                    const date = new Date(dt);
                    if (isNaN(date.getTime())) return dt;
                    return date.toLocaleDateString('en-GB', { year: 'numeric', month: 'long', day: 'numeric' });
                }
    
                let breakdownHtml = '';
                if (breakdown.length > 0) {
                    breakdown.forEach(function (item) {
                        let desc = '', amt = 0;
                        if (typeof item === 'object' && !Array.isArray(item)) {
                            const keys = Object.keys(item);
                            if (keys.length === 1) {
                                desc = keys[0];
                                amt = item[desc];
                            }
                        }
                        if(desc){
                            breakdownHtml += `<tr class="item"><td>${desc}</td><td class="text-right">${money(amt)}</td></tr>`;
                        }
                    });
                } else if (billType.bill_name) {
                     breakdownHtml += `<tr class="item"><td>${billType.bill_name}</td><td class="text-right">${money(bill.amount)}</td></tr>`;
                }
    
                const html = `
                <div id="printableReceipt" class="receipt-box">
                    <style>
                        .receipt-box {
                            max-width: 800px;
                            margin: auto;
                            padding: 30px;
                            border: 1px solid #eee;
                            box-shadow: 0 0 10px rgba(0, 0, 0, 0.15);
                            font-size: 16px;
                            line-height: 24px;
                            font-family: 'Helvetica Neue', 'Helvetica', Helvetica, Arial, sans-serif;
                            color: #555;
                        }
                        body { /* for printing */
                            -webkit-print-color-adjust: exact;
                            print-color-adjust: exact;
                        }
                        .receipt-box table {
                            width: 100%;
                            line-height: inherit;
                            text-align: left;
                            border-collapse: collapse;
                        }
                        .receipt-box table td {
                            padding: 5px;
                            vertical-align: top;
                        }
                        .receipt-box .top-table td {
                            padding-bottom: 20px;
                        }
                        .receipt-box .heading td {
                            background: #eee !important;
                            border-bottom: 1px solid #ddd;
                            font-weight: bold;
                        }
                        .receipt-box .details td {
                            padding-bottom: 20px;
                        }
                        .receipt-box .item td {
                            border-bottom: 1px solid #eee;
                        }
                        .receipt-box .total td {
                            padding-top: 5px;
                            padding-bottom: 5px;
                            border-top: 1px solid #eee;
                        }
                        .receipt-box .total.grand-total td {
                            border-top: 2px solid #eee;
                            font-weight: bold;
                            font-size: 1.2em;
                        }
                        .text-right { text-align: right; }
                        @media print {
                            .receipt-box {
                                box-shadow: none;
                                border: 0;
                            }
                        }
                    </style>
                    <table cellpadding="0" cellspacing="0">
                        <tr class="top">
                            <td colspan="2">
                                <table class="top-table">
                                    <tr>
                                        <td class="title">
                                            ${logoUrl ? `<img src="${logoUrl}" alt="School Logo" style="width: 100%; max-width: 150px" />` : `<h2>${d.school_name || ''}</h2>`}
                                        </td>
                                        <td class="text-right">
                                            <strong>Receipt #: ${String(payment.id || '').padStart(10, '0')}</strong><br />
                                            Date Paid: ${formatDate(payment.date_paid)}<br />
                                            Date Issued: ${formatDate(d.date_issued)}
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr class="information">
                            <td colspan="2">
                                <table>
                                    <tr>
                                        <td>
                                            <strong>${d.school_name || ''}</strong><br />
                                            ${d.school_address || ''}<br />
                                            ${d.school_phone || ''}<br />
                                            ${d.school_email || ''}
                                        </td>
                                        <td class="text-right">
                                            <strong>Billed To</strong><br />
                                            ${student.firstname || ''} ${student.lastname || ''}<br />
                                            Admission No: ${student.admission_no || ''}<br />
                                            Class: ${d.class_name || ''}
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr class="heading">
                            <td>Payment Method</td>
                            <td class="text-right"></td>
                        </tr>
                        <tr class="details">
                            <td>${payment.payment_method || 'N/A'}</td>
                            <td class="text-right"></td>
                        </tr>
                        <tr class="heading">
                            <td>Item Description</td>
                            <td class="text-right">Amount</td>
                        </tr>
                        ${breakdownHtml}
                    </table>
                    <table cellpadding="0" cellspacing="0" style="margin-top: 20px;">
                        <tr class="total">
                            <td class="text-right"><strong>Subtotal:</strong></td>
                            <td class="text-right">${money(bill.amount)}</td>
                        </tr>
                        <tr class="total">
                            <td class="text-right"><strong>Tax (${bill.tax || billType.tax || 0}%):</strong></td>
                            <td class="text-right">${money((bill.amount_due - bill.amount) > 0 ? (bill.amount_due - bill.amount) : 0)}</td>
                        </tr>
                        <tr class="total">
                            <td class="text-right"><strong>Total Due:</strong></td>
                            <td class="text-right">${money(bill.amount_due)}</td>
                        </tr>
                        <tr class="total grand-total">
                            <td class="text-right">Amount Paid:</td>
                            <td class="text-right">${money(payment.amount_newly_paid)}</td>
                        </tr>
                        <tr class="total">
                            <td class="text-right">Balance:</td>
                            <td class="text-right">${money(payment.balance)}</td>
                        </tr>
                    </table>
                    <div style="margin-top: 40px;">
                        <strong>Notes:</strong> ${payment.description || billType.notes || 'Payment for school bill'}
                    </div>
                     <div class="text-center" style="margin-top: 40px; font-style: italic;">Thank you for your payment!</div>
                </div>
            `;
                $content.html(html);
            },
            error: function () {
                $content.html('<div class="alert alert-danger text-center">No payment yet!.</div>');
            }
        });
    }
    $(document).on('click', '.term_btn.select_btn', function () {
        $('.term_btn.select_btn').removeClass('active');
        $(this).addClass('active');
        // If you want to trigger a reload or AJAX here, do it now
        // For example, reload the DataTable or trigger any dependent logic
        if (typeof fetchAndDisplayEstimatedIncome === 'function') fetchAndDisplayEstimatedIncome();
        if ($.fn.DataTable.isDataTable('#student_payment_recordTable')) {
                $('#student_payment_recordTable').DataTable().ajax.reload();
            }else{
                data_student()
            }
    });

    // Print and Download buttons for receipt (shared)
    $(document).on('click', '#printReceiptButton', function () {
        const printContents = document.getElementById('printableReceipt');
        if (!printContents) return;
        const win = window.open('', '', 'height=700,width=900');
        win.document.write('<html><head><title>Print Receipt</title>');
        win.document.write('<link rel="stylesheet" href="../dist/css/adminlte.css">');
        win.document.write('<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">');
        win.document.write(`<style>
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
        // win.document.write('<link rel="stylesheet" href="../plugins/bootstrap/css/bootstrap.min.css">');
        win.document.write('</head><body >');
        win.document.write(printContents.outerHTML);
        win.document.write('</body></html>');
        win.document.close();
        win.focus();
        setTimeout(function () { win.print(); win.close(); }, 500);
    });

    $(document).on('click', '#downloadReceiptButton', function () {
        const element = document.getElementById('printableReceipt');
        if (!element) return;
        html2pdf().from(element).set({
            margin: 0.5,
            filename: 'payment_receipt.pdf',
            html2canvas: { scale: 2 },
            jsPDF: { unit: 'in', format: 'a4', orientation: 'portrait' }
        }).save();
    });
    // Open Payment Record Timeline Modal on button click
    $(document).on('click', '.view-bill', function () {
        const billId = $(this).data('id');
        // Find the student_id from the row data (DataTable row object)
        let studentId = $(this).data('student_id');
        // If not present as data attribute, try to get from DataTable row
        if (!studentId) {
            // Try to get the row data from DataTable
            const table = $('#student_payment_recordTable').DataTable();
            const tr = $(this).closest('tr');
            const rowData = table.row(tr).data();
            if (rowData && rowData.student_id) studentId = rowData.student_id;
        }
        if (billId && studentId) {
            showPaymentRecordModal(billId, studentId);
        } else {
            toastr.error('Could not determine bill or student for payment record.');
        }
    });

    // --- Payment Record Timeline Modal Logic ---
    window.showPaymentRecordModal = function (billId, studentId) {
        $('#paymentRecordModal').modal('show');
        const $container = $('#paymentTimelineContainer');
        $container.html('<div class="text-center text-muted">Loading payment records...</div>');
        $.ajax({
            url: '../billing_controller.php',
            method: 'POST',
            dataType: 'json',
            data: {
                action: 'get_payment_timeline',
                bill_id: billId,
                student_id: studentId
            },
            success: function (res) {
                if (!res.success || !Array.isArray(res.data) || res.data.length === 0) {
                    $container.html('<div class="alert alert-warning text-center">No payment records found for this bill.</div>');
                    return;
                }
                // Group by date for timeline labels
                let timeline = '<div class="timeline">';
                let lastDate = '';
                res.data.forEach(function (item, idx) {
                    // Format date for label (YYYY-MM-DD to e.g. 21 Jun. 2025)
                    let dateObj = item.date_paid ? new Date(item.date_paid) : (item.datecreated ? new Date(item.datecreated) : null);
                    let dateLabel = dateObj ? dateObj.toLocaleDateString('en-GB', { day: '2-digit', month: 'short', year: 'numeric' }) : '';
                    if (dateLabel && dateLabel !== lastDate) {
                        timeline += `<div class="time-label"><span class="bg-info">${dateLabel}</span></div>`;
                        lastDate = dateLabel;
                    }
                    // Icon and color
                    let icon = 'fa-money-bill-wave', bg = 'bg-success', statusText = 'Paid', statusColor = 'text-success';
                    if (item.status == 0) { statusText = 'Pending'; bg = 'bg-warning'; icon = 'fa-hourglass-half'; statusColor = 'text-warning'; }
                    if (item.balance > 0 && item.amount_newly_paid == 0) { statusText = 'Outstanding'; bg = 'bg-danger'; icon = 'fa-exclamation-circle'; statusColor = 'text-danger'; }
                    // Timeline item
                    timeline += `
                      <div>
                        <i class="fas ${icon} ${bg}"></i>
                        <div class="timeline-item">
                        <a href="#paymentReceiptPreviewModal" class="float-right" data-toggle="modal" aria-expanded="false" data-bill_id="${item.bill_id}" data-paymentid="${item.id}" aria-controls="paymentReceiptPreviewModal">Preview Payment Receipt</a>
                          <h3 class="timeline-header ${statusColor}">
                            <b>${statusText}</b> - ₦${Number(item.amount_newly_paid).toLocaleString()} paid
                          </h3>
                          <div class="timeline-body">
                            <div><b>Description:</b> ${item.description || 'No description'}</div>
                            <div><b>Payment Method:</b> ${item.payment_method || 'N/A'}</div>
                            <div><b>Total Amount Paid To Date:</b> ₦${Number(item.total_amount_paid).toLocaleString()}</div>
                            <div><b>Balance:</b> <span class="${item.balance > 0 ? 'text-danger' : 'text-success'}">₦${Number(item.balance).toLocaleString()}</span></div>
                          </div>
                        </div>
                      </div>
                    `;
                });
                timeline += '<div><i class="fas fa-flag-checkered bg-gray"></i></div></div>';
                $container.html(timeline);
            },
            error: function () {
                $container.html('<div class="alert alert-danger text-center">Failed to load payment records.</div>');
            }
        });
    };
    // Unified handler for both preview and last receipt
    $(document).on('click', 'a[data-toggle="modal"][data-bill_id][data-paymentid][aria-controls="paymentReceiptPreviewModal"]', function (e) {
        e.preventDefault();
        showPaymentReceiptModal({
            billId: $(this).data('bill_id'),
            paymentId: $(this).data('paymentid')
        });
    });
    $(document).on('click', '.generate-last-receipt', function () {
        showPaymentReceiptModal({
            billId: $(this).data('bill_id'),
            studentId: $(this).data('student_id'),
            last: true
        });
    });
    // ...existing code...
    // --- Quick Assign Bill Modal: Invoice Logic ---
    // Setup for Quick Assign Bill Form (Invoice) with add/remove and live calculation
    setupInvoiceForm({
        addRowBtn: '#addQuickAssignBreakdownRow',
        tableBody: '#quickAssignInvoiceBreakdownTable tbody',
        rowClass: 'quick-assign-breakdown',
        removeRowClass: 'remove-quick-assign-breakdown-row',
        subtotalId: '#quick_assign_subtotal',
        discountId: '#quick_assign_deduction_percentage',
        taxId: '#quick_assign_tax',
        totalId: '#quick_assign_total_amount'
    });

    // Preview functionality for Quick Assign Bill
    function renderQuickAssignPreview() {
        const billTypeId = $('#quick_assign_bill_type').val();
        const billTypeName = $('#quick_assign_bill_type option:selected').text();
        const subtotal = $('#quick_assign_subtotal').val();
        const deductionPurpose = $('#quick_assign_deduction_purpose').val();
        const deductionPercentage = $('#quick_assign_deduction_percentage').val();
        const tax = $('#quick_assign_tax').val();
        const totalAmount = $('#quick_assign_total_amount').val();
        const notes = $('#quick_assign_notes').val();
        const terms = $('#quick_assign_terms').val();
        const studentName = $('#quick_assign_student_name').val();

        // Gather breakdown items and build rows
        let rows = '';
        $('#quickAssignInvoiceBreakdownTable tbody tr').each(function () {
            const desc = $(this).find('input').eq(0).val() || '';
            const amt = $(this).find('input').eq(1).val() || '';
            if (desc || amt) rows += `<tr><td>${escapeHtml(desc)}</td><td class="text-right">₦${Number(amt || 0).toLocaleString()}</td></tr>`;
        });
        if (!rows) rows = '<tr><td colspan="2" class="text-muted">No items</td></tr>';

        // Validation
        let errors = [];
        if (!billTypeId) errors.push('Please select a Bill Type.');
        // Ensure at least one breakdown item exists for quick assign
        let hasQuickItem = false;
        $('#quickAssignInvoiceBreakdownTable tbody tr').each(function () {
            const amt = $(this).find('input[name="quick_assign_breakdown_amount[]"]').val();
            if (amt !== undefined && amt !== null && amt !== '') hasQuickItem = true;
        });
        if (!hasQuickItem) errors.push('Please add at least one breakdown item.');
        if (totalAmount === '' || isNaN(parseFloat(totalAmount)) || parseFloat(totalAmount) < 0) errors.push('Please enter a valid Total Amount.');
        if (tax === '' || isNaN(parseFloat(tax)) || parseFloat(tax) < 0) errors.push('Please enter a valid Tax percentage (use 0 if none).');
        if (!studentName) errors.push('Student name missing.');

        if (errors.length > 0) {
            toastr.warning(errors.join('<br>'), 'Missing Information');
            return false;
        }

        // Build branded preview card (logo, school name, student, breakdown, totals, notes)
        const logoUrl = ($('.brand-link img').first().attr('src')) ? $('.brand-link img').first().attr('src') : '';
        const schoolName = ($('.brand-text').first().text() || '').trim();
        let previewHtml = `
            <div class="card receipt-card">
                <div class="card-body p-3">
                    <div class="d-flex align-items-center mb-3">
                        <div class="mr-3">${logoUrl ? `<img src="${logoUrl}" alt="${escapeHtml(schoolName)}" style="height:56px;max-width:150px;object-fit:contain;" />` : `<h5 class="mb-0">${escapeHtml(schoolName)}</h5>`}</div>
                        <div class="flex-fill">
                            <h5 class="mb-0">${escapeHtml(billTypeName || 'Bill')}</h5>
                            <small class="text-muted">Quick Assign Preview</small>
                        </div>
                        <div class="text-right">
                            <div><strong>${escapeHtml(studentName || '')}</strong></div>
                            <small class="text-muted">Single student</small>
                        </div>
                    </div>

                    <div class="table-responsive mb-2">
                        <table class="table table-sm table-striped mb-0">
                            <thead class="thead-light"><tr><th>Description</th><th class="text-right">Amount</th></tr></thead>
                            <tbody>
                                ${rows}
                            </tbody>
                        </table>
                    </div>

                    <div class="row mt-3">
                        <div class="col-md-6 small text-muted">Notes</div>
                        <div class="col-md-6 text-right small text-dark">${escapeHtml(notes || 'No notes')}</div>
                    </div>

                    <div class="row mt-2">
                        <div class="col-md-6 small text-muted">Terms</div>
                        <div class="col-md-6 text-right small text-dark">${escapeHtml(terms || '—')}</div>
                    </div>

                    <hr />
                    <div class="d-flex justify-content-end">
                        <div style="min-width:220px;">
                            <div class="d-flex justify-content-between"><small class="text-muted">Subtotal</small><strong>${money(subtotal)}</strong></div>
                            <div class="d-flex justify-content-between"><small class="text-muted">Deduction</small><strong>${escapeHtml(deductionPercentage || '0')}%</strong></div>
                            <div class="d-flex justify-content-between"><small class="text-muted">Tax</small><strong>${escapeHtml(tax || '0')}%</strong></div>
                            <hr class="my-2">
                            <div class="d-flex justify-content-between"><small class="text-muted">Total</small><strong>${money(totalAmount)}</strong></div>
                        </div>
                    </div>
                </div>
                <div class="card-footer bg-white text-right"><small class="text-muted">Preview — verify before assigning</small></div>
            </div>
        `;

        // Populate preview content but do not automatically switch tabs here.
        // Tab activation is handled by the wizard to ensure validation occurs first.
        $('#quickPreviewBillContent').html(previewHtml);
        return true;
    }

    // Attach function to button if present
    $('#quickPreviewBillButton').off('click.quick').on('click.quick', function () {
        const ok = (typeof renderQuickAssignPreview === 'function') ? renderQuickAssignPreview() : false;
        if (ok) {
            // Activate preview step via wizard routing
            $('#quick-preview-bill-tab-link').trigger('click');
        }
    });

    // Ensure the in-form preview button (if present in old markup) is hidden to avoid duplicates
    $(function () {
        $('#quickPreviewBillButton').hide();
    });
    // Optionally, reset or auto-render preview content on modal show for better UX
    $('#quickAssignBillModal').on('show.bs.modal', function () {
        var $quickSelect = $('#quick_assign_bill_type');
        // If fields are already populated (student + bill type + total), render preview automatically
        const studentName = $('#quick_assign_student_name').val();
        const billTypeId = $quickSelect.val();
        const totalAmount = $('#quick_assign_total_amount').val();
        if (studentName && billTypeId && totalAmount && !isNaN(parseFloat(totalAmount)) && parseFloat(totalAmount) >= 0) {
            // Small delay to allow modal DOM and select2 to initialize; only render if validation passes
            setTimeout(function () { if (typeof renderQuickAssignPreview === 'function') renderQuickAssignPreview(); }, 80);
        } else {
            $('#quickPreviewBillContent').html('<p class="text-muted">Select a bill type and add breakdown items, then click "Preview" to view the quick assign summary.</p>');
            // Make sure the Details step is visible without relying on Bootstrap's tab('show') (avoids race conditions)
            $('#quickAssignBillTabs .nav-link').removeClass('active');
            $('#quick-assign-bill-tab-link').addClass('active');
            $('#quickAssignBillTabsContent .tab-pane').removeClass('show active').css('display', 'none');
            $('#quick-assign-bill-tab').addClass('show active').css('display', 'block');
        }
    });

    // --- Quick Assign Modal: Step-by-step wizard for better UX ---
    (function setupQuickAssignWizard() {
        const $modal = $('#quickAssignBillModal');
    const $step1 = $('#quick-assign-bill-tab');
    const $step2 = $('#quick-preview-bill-tab');
    const $btn1 = $('#quick-step-btn-1');
    const $btn2 = $('#quick-step-btn-2');
    const $next = $('#quick-wizard-next');
    const $back = $('#quick-wizard-back');
    const $assignNow = $('#quick-assign-now');

        function showQuickStep(step) {
            // reset classes
            $btn1.removeClass('btn-primary').addClass('btn-secondary');
            $btn2.removeClass('btn-primary').addClass('btn-secondary');

            $step1.removeClass('show active');
            $step2.removeClass('show active');

            if (step === 1) {
                $btn1.removeClass('btn-secondary').addClass('btn-primary');
                // Ensure tab link and pane are active/visible
                $('#quickAssignBillTabs .nav-link').removeClass('active');
                $('#quick-assign-bill-tab-link').addClass('active');
                $('#quickAssignBillTabsContent .tab-pane').removeClass('show active').css('display', 'none');
                $('#quick-assign-bill-tab').addClass('show active').css('display', 'block');
                $back.hide(); $next.show();
                // Hide assign button in Details step
                $('#quick-assign-now').detach();
            } else if (step === 2) {
                // Attempt preview generation before showing step 2
                if (typeof renderQuickAssignPreview === 'function') {
                    const ok = renderQuickAssignPreview();
                    if (!ok) return; // validation failed, stay on step 1
                }
                $btn2.removeClass('btn-secondary').addClass('btn-primary');
                // Activate preview pane directly to avoid bootstrap tab race
                $('#quickAssignBillTabs .nav-link').removeClass('active');
                $('#quick-preview-bill-tab-link').addClass('active');
                $('#quickAssignBillTabsContent .tab-pane').removeClass('show active').css('display', 'none');
                $('#quick-preview-bill-tab').addClass('show active').css('display', 'block');
                $back.show(); $next.hide();
                // Move assign button into preview pane if not already present
                if ($('#quick-assign-now').length === 0) {
                    $('#quickPreviewBillContent').after('<div class="text-right mt-3"><button type="submit" form="quickAssignBillForm" class="btn btn-success" id="quick-assign-now">Assign Bill</button></div>');
                }
            }
        }

        // Initialize state when modal shown
        $modal.on('shown.bs.modal', function () {
            showQuickStep(1);
        });

        // Step button clicks
    $btn1.on('click', function () { showQuickStep(1); });
    $btn2.on('click', function () { showQuickStep(2); });

        // Prevent direct clicking of the tab nav links; route through wizard validation
        $('#quick-assign-bill-tab-link, #quick-preview-bill-tab-link').on('click', function (e) {
            e.preventDefault();
            const target = $(this).attr('id');
            if (target === 'quick-assign-bill-tab-link') showQuickStep(1);
            else if (target === 'quick-preview-bill-tab-link') showQuickStep(2);
        });

        // Next/back
        $next.on('click', function () {
            if ($('#quick-assign-bill-tab').hasClass('active') || $('#quick-assign-bill-tab').hasClass('show')) {
                // Validate minimal required fields before preview
                const billTypeId = $('#quick_assign_bill_type').val();
                let hasItem = false;
                $('#quickAssignInvoiceBreakdownTable tbody tr').each(function () {
                    const amt = $(this).find('input[name="quick_assign_breakdown_amount[]"]').val();
                    if (amt !== undefined && amt !== null && amt !== '') hasItem = true;
                });
                if (!billTypeId) { toastr.warning('Please select a Bill Type before proceeding.'); return; }
                if (!hasItem) { toastr.warning('Please add at least one breakdown item.'); return; }
                showQuickStep(2);
            }
        });

        $back.on('click', function () {
            if ($('#quick-preview-bill-tab').hasClass('active') || $('#quick-preview-bill-tab').hasClass('show')) showQuickStep(1);
        });

        // Hide assign now until step 3
    // Remove assign button from footer, will be injected into preview step
    $assignNow.hide();
    })();
    // Setup for Assign Bill Form (Invoice) with add/remove and live calculation
    setupInvoiceForm({
        addRowBtn: '#addAssignBreakdownRow',
        tableBody: '#assignInvoiceBreakdownTableAssign tbody',
        rowClass: 'assign-breakdown', // Changed hyphen to underscore
        removeRowClass: 'remove-assign-breakdown-row',
        subtotalId: '#assignSubtotal',
        discountId: '#assignDeductionPercentage',
        taxId: '#assignTaxPercentage',
        totalId: '#assignTotalAmount'
    });
    // Utility function to escape HTML
    function escapeHtml(unsafe) {
        if (typeof unsafe !== 'string') {
            return unsafe; // Return as is if not a string
        }
        return unsafe
            .replace(/&/g, "&amp;")
            .replace(/</g, "&lt;")
            .replace(/>/g, "&gt;")
            .replace(/"/g, "&quot;")
            .replace(/'/g, "&#039;");
    }
    // --- Assign Bill Modal: Fetch and display invoice when bill type is selected ---
    // $('#selectBillTypeModal').on('change', function () {
    //     const billTypeId = $(this).val();
    //     if (!billTypeId) return;
    //     $.ajax({
    //         url: '../billing_controller.php',
    //         type: 'POST',
    //         data: {
    //             action: 'get_bill_type',
    //             bill_type_id: billTypeId
    //         },
    //         dataType: 'json',
    //         success: function (response) {
    //             if (response.success) {
    //                 const d = response.data;
    //                 // Populate invoice fields
    //                 $('#assignDeductionPurpose').val(d.deduction_purpose);
    //                 $('#assignDeductionPercentage').val(d.deduction_percentage);
    //                 $('#assignSubtotal').val(d.subtotal);
    //                 $('#assignTaxPercentage').val(d.tax);
    //                 $('#assignTotalAmount').val(d.total);
    //                 $('#assignNotes').val(d.notes);
    //                 $('#assignTerms').val(d.terms);
    //                 // Populate breakdown table
    //                 let items = [];
    //                 try {
    //                     items = JSON.parse(d.bill_items || '[]');
    //                 } catch (e) {
    //                     items = [];
    //                 }
    //                 // const $tbody = $('#assignInvoiceBreakdownTable tbody');
    //                 const $tbody = $('#assignInvoiceBreakdownTableAssign tbody');
    //                 $tbody.empty();
    //                 if (items.length > 0) {
    //                     items.forEach(function (item) {
    //                         let desc = '';
    //                         let amt = '';
    //                         if (typeof item === 'object' && !Array.isArray(item)) {
    //                             if ('description' in item && 'amount' in item) {
    //                                 desc = item.description;
    //                                 amt = item.amount;
    //                             } else {
    //                                 const keys = Object.keys(item);
    //                                 if (keys.length === 1) {
    //                                     desc = keys[0];
    //                                     amt = item[desc];
    //                                 }
    //                             }
    //                         }
    //                         $tbody.append(`
    //                                     <tr>
    //                                         <td><input type="text" name="assign_breakdown_description[]" class="form-control" value="${desc}" required></td>
    //                                         <td><input type="number" name="assign_breakdown_amount[]" class="form-control assign-breakdown-amount" step="0.01" min="0" value="${amt}" required></td>
    //                                     </tr>
    //                                 `);
    //                     });
    //                 } else {
    //                     $tbody.append(`
    //                                 <tr>
    //                                     <td><input type="text" name="assign_breakdown_description[]" class="form-control" placeholder="e.g. Uniform Fee" required></td>
    //                                     <td><input type="number" name="assign_breakdown_amount[]" class="form-control assign-breakdown-amount" step="0.01" min="0" required></td>
    //                                 </tr>
    //                             `);
    //                 }
    //                 // Trigger calculation
    //                 updateInvoiceTotal({
    //                     rowClass: 'assign-breakdown',
    //                     subtotalId: '#assignSubtotal',
    //                     discountId: '#assignDeductionPercentage',
    //                     taxId: '#assignTaxPercentage',
    //                     totalId: '#assignTotalAmount'
    //                 });
    //             }
    //         }
    //     });
    // });
     $('#selectBillTypeModal').on('change', function () {
        const billTypeId = $(this).val();
        if (!billTypeId) return;
        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: {
                action: 'get_bill_type',
                bill_type_id: billTypeId
            },
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    const d = response.data;
                    // Populate invoice fields
                    $('#assignDeductionPurpose').val(d.deduction_purpose);
                    $('#assignDeductionPercentage').val(d.deduction_percentage);
                    $('#assignSubtotal').val(d.subtotal);
                    $('#assignTaxPercentage').val(d.tax);
                    $('#assignTotalAmount').val(d.total);
                    $('#assignNotes').val(d.notes);
                    $('#assignTerms').val(d.terms);
                    // Populate breakdown table
                    let items = [];
                    try {
                        items = JSON.parse(d.bill_items || '[]');
                    } catch (e) {
                        items = [];
                    }
                    // const $tbody = $('#assignInvoiceBreakdownTable tbody');
                    const $tbody = $('#assignInvoiceBreakdownTableAssign tbody');
                    $tbody.empty();
                    if (items.length > 0) {
                        items.forEach(function (item) {
                            let desc = '';
                            let amt = '';
                            if (typeof item === 'object' && !Array.isArray(item)) {
                                if ('description' in item && 'amount' in item) {
                                    desc = item.description;
                                    amt = item.amount;
                                } else {
                                    const keys = Object.keys(item);
                                    if (keys.length === 1) {
                                        desc = keys[0];
                                        amt = item[desc];
                                    }
                                }
                            }
                            $tbody.append(`
                                        <tr>
                                            <td><input type="text" name="assign_breakdown_description[]" class="form-control" value="${desc}" required></td>
                                            <td><input type="number" name="assign_breakdown_amount[]" class="form-control assign-breakdown-amount" step="0.01" min="0" value="${amt}" required></td>
                                            <td><button type="button" class="btn btn-danger btn-sm remove-assign-breakdown-row" title="Remove"><i class="fas fa-trash"></i></button></td>
                                        </tr>
                                    `);
                        });
                    } else {
                        $tbody.append(`
                                    <tr>
                                        <td><input type="text" name="assign_breakdown_description[]" class="form-control" placeholder="e.g. Uniform Fee" required></td>
                                        <td><input type="number" name="assign_breakdown_amount[]" class="form-control assign-breakdown-amount" step="0.01" min="0" required></td>
                                        <td><button type="button" class="btn btn-danger btn-sm remove-assign-breakdown-row" title="Remove"><i class="fas fa-trash"></i></button></td>
                                    </tr>
                                `);
                    }
                    // Trigger calculation
                    updateInvoiceTotal({
                        rowClass: 'assign-breakdown',
                        subtotalId: '#assignSubtotal',
                        discountId: '#assignDeductionPercentage',
                        taxId: '#assignTaxPercentage',
                        totalId: '#assignTotalAmount'
                    });
                }
            }
        });
    });
    var currentBillTypeFilter = 'all';
    var studentRecordFilter = 'all'; // all, assigned, unassigned, partly_paid, unpaid, paid
    const $createAssignModal = $('#createAssignBillModal');
    const $selectBillTypeModal = $('#selectBillTypeModal');
    const $billAmountModal = $('#assignTotalAmount');
    const $billTaxModal = $('#assignTaxPercentage');
    const $filterClassModal = $('#filterClassModal');
    const $studentListTableBody = $('#studentListTableBodyModal');
    const $selectAllCheckbox = $('#selectAllStudentsCheckbox');
    const $previewButton = $('#previewBillButton');
    const $previewContent = $('#previewBillContent');
    const $previewTabLink = $('#preview-bill-tab-link');
    const $assignNowButton = $('#assignNowButton');
    const $assignBillForm = $('#assignBillForm');

    let selectedStudents = {}; // Object to store selected students { student_id: { name: '...', admission_no: '...', class_name: '...', class_id: ... } }
    let loadedBillTypesData = {}; // To store fetched bill type data { bill_type_id: { amount: ..., tax: ... } }

    // Add these event handlers

    // Show/hide student payment record table and message based on class selection
    data_student();
    
     $('#select_class_field').on('change', function () {
        var classVal = $(this).val();
        if (!classVal) {
            $('#select-class-message').show();
            $('#estimated-income-section').hide();
            $('#student_payment_recordTable').hide();
            $('#student-record-filters').hide()
            console.log("ll man")
            if ($.fn.DataTable.isDataTable('#student_payment_recordTable')) {
                console.log("wearehere now now")
                $('#student_payment_recordTable').DataTable().clear().draw();
            }
        } else {
            $('#select-class-message').hide();
            $('#student-record-filters').show()
            $('#estimated-income-section').show();
            $('#estimated-income-section').css("display", "flex");

            $('#student_payment_recordTable').show();
            // Always reload DataTable when showing
            if ($.fn.DataTable.isDataTable('#student_payment_recordTable')) {
                $('#student_payment_recordTable').DataTable().ajax.reload();
            }else{
                data_student()
            }
            fetchAndDisplayEstimatedIncome();
        }
    });
    // Also trigger once on page load to set initial state
    $('#select_class_field').trigger('change');
    // Keep session field change for reload if needed
    $('#select_session_field').on('change', function () {
        if ($.fn.DataTable.isDataTable('#student_payment_recordTable')) {
            $('#student_payment_recordTable').DataTable().ajax.reload();
        }else {
            data_student()
        }
        fetchAndDisplayEstimatedIncome();
    });

    // $('.term_btn').on('click', function () {
    //     // data_student()
    //     $('#student_payment_recordTable').DataTable().ajax.reload();
    //     fetchAndDisplayEstimatedIncome();
    // });
    // $('#bill-type-selector-container').on('click', '.bill-type-btn', function() {
    //     const $button = $(this);

    //     // Update active state visually
    //     $('.bill-type-btn').removeClass('btn-success').addClass('btn-primary');
    //     $button.removeClass('btn-primary').addClass('btn-success');

    //     // Update current filter
    //     currentBillTypeFilter = $button.data('id');

    //     // Reload the DataTable
    //     $('#student_payment_recordTable').DataTable().ajax.reload();
    // });
    // Unified Bill breakdown row add/remove and calculation for all Bill forms
    // --- Estimated Income Fetch & Display ---
    function fetchAndDisplayEstimatedIncome() {

        const classId = $('#select_class_field').val();
        const sessionId = $('#select_session_field').val();
        const termId = $('.term_btn.select_btn.active').attr('data-id');
        // Use window.currentBillTypeFilter to ensure global access
        let billType = 'all';
        if (currentBillTypeFilter !== undefined && currentBillTypeFilter !== null) {
            billType = currentBillTypeFilter;
        }
        console.log("new bill clicked", currentBillTypeFilter)
        console.log('billType sent:', billType);
        $.ajax({
            url: '../billing_controller.php',
            method: 'POST',
            dataType: 'json',
            data: {
                action: 'get_expected_income',
                class_id: classId,
                session_id: sessionId,
                term_id: termId,
                bill_type: billType
            },
            success: function (res) {
                if (res.success) {
                    // Estimated income
                    $('#estimated-income-class').text('₦' + Number(res.class_total).toLocaleString());
                    $('#estimated-income-all').text('₦' + Number(res.all_total).toLocaleString());

                    // Total paid
                    if (res.class_paid !== undefined) {
                        const classPercentage = res.class_total > 0 ? (parseFloat(res.class_paid) / parseFloat(res.class_total)) * 100 : 0;
                        $('#total-paid-class').html(`₦${Number(res.class_paid).toLocaleString()} <small>(${classPercentage.toFixed(2)}%)</small>`);
                    }
                    if (res.all_paid !== undefined) {
                        const allPercentage = res.all_total > 0 ? (res.all_paid / res.all_total) * 100 : 0;
                        $('#total-paid-all').html(`₦${Number(res.all_paid).toLocaleString()} <small>(${allPercentage.toFixed(2)}%)</small>`);
                    }

                    // Amount left
                    if (res.class_left !== undefined) {
                        $('#amount-left-class').text('₦' + Number(res.class_left).toLocaleString());
                    }
                    if (res.all_left !== undefined) {
                        $('#amount-left-all').text('₦' + Number(res.all_left).toLocaleString());
                    }

                    // Student/payment stats
                    if (res.class_total_students !== undefined) {
                        $('#total-students-class').text(Number(res.class_total_students).toLocaleString());
                    }
                    if (res.all_total_students !== undefined) {
                        $('#total-students-all').text(Number(res.all_total_students).toLocaleString());
                    }
                    if (res.class_students_paid !== undefined) {
                        $('#students-paid-class').text(Number(res.class_students_paid).toLocaleString());
                    }
                    if (res.all_students_paid !== undefined) {
                        $('#students-paid-all').text(Number(res.all_students_paid).toLocaleString());
                    }
                    if (res.class_students_completed !== undefined) {
                        $('#students-completed-class').text(Number(res.class_students_completed).toLocaleString());
                    }
                    if (res.all_students_completed !== undefined) {
                        $('#students-completed-all').text(Number(res.all_students_completed).toLocaleString());
                    }
                    if (res.class_students_unpaid !== undefined) {
                        $('#students-unpaid-class').text(Number(res.class_students_unpaid).toLocaleString());
                    }
                    if (res.all_students_unpaid !== undefined) {
                        $('#students-unpaid-all').text(Number(res.all_students_unpaid).toLocaleString());
                    }
                    // New: students assigned to selected bill type
                    if (res.class_students_assigned !== undefined) {
                        if ($('#students-assigned-class').length === 0) {
                            // Optionally create an element if it doesn't exist
                        } else {
                            $('#students-assigned-class').text(Number(res.class_students_assigned).toLocaleString());
                        }
                    }
                    if (res.all_students_assigned !== undefined) {
                        if ($('#students-assigned-all').length === 0) {
                            // Optionally create an element if it doesn't exist
                        } else {
                            $('#students-assigned-all').text(Number(res.all_students_assigned).toLocaleString());
                        }
                    }
                } else {
                    $('#estimated-income-class').text('–');
                    $('#estimated-income-all').text('–');
                    $('#total-paid-class').text('–');
                    $('#total-paid-all').text('–');
                    $('#amount-left-class').text('–');
                    $('#amount-left-all').text('–');
                    $('#total-students-class').text('–');
                    $('#total-students-all').text('–');
                    $('#students-paid-class').text('–');
                    $('#students-paid-all').text('–');
                    $('#students-completed-class').text('–');
                    $('#students-completed-all').text('–');
                    $('#students-unpaid-class').text('–');
                    $('#students-unpaid-all').text('–');
                }
            },
            error: function () {
                $('#estimated-income-class').text('–');
                $('#estimated-income-all').text('–');
                $('#total-paid-class').text('–');
                $('#total-paid-all').text('–');
                $('#amount-left-class').text('–');
                $('#amount-left-all').text('–');
                $('#total-students-class').text('–');
                $('#total-students-all').text('–');
                $('#students-paid-class').text('–');
                $('#students-paid-all').text('–');
                $('#students-completed-class').text('–');
                $('#students-completed-all').text('–');
                $('#students-unpaid-class').text('–');
                $('#students-unpaid-all').text('–');
            }
        });
    }
    function setupInvoiceForm(options) {
        // alert("nijn")
        const {
            addRowBtn,
            tableBody,
            rowClass,
            removeRowClass,
            subtotalId,
            discountId,
            taxId,
            totalId
        } = options;

        // Add new breakdown row
        $(document).on('click', addRowBtn, function () {
            $(tableBody).append(`
                        <tr>
                            <td><input type="text" name="${rowClass}_description[]" class="form-control ${rowClass}-description" placeholder="e.g. Tuition Fee" required></td>
                            <td><input type="number" name="${rowClass}_amount[]" class="form-control ${rowClass}-amount" step="0.01" min="0" required></td>
                            <td><button type="button" class="btn btn-danger btn-sm ${removeRowClass}" title="Remove"><i class="fas fa-trash"></i></button></td>
                        </tr>
                    `);
        });
        // Remove breakdown row
        $(document).on('click', '.' + removeRowClass, function () {
            $(this).closest('tr').remove();
            updateInvoiceTotal(options);
        });
        // Update total on amount, discount, or tax change
        $(document).on('input', `.${rowClass}-amount, ${discountId}, ${taxId}`, function () {
            updateInvoiceTotal(options);
        });
        // Initial calculation
        updateInvoiceTotal(options);
    }
    // alert("klnkln")

    function updateInvoiceTotal(options) {
        const {
            rowClass,
            subtotalId,
            discountId,
            taxId,
            totalId
        } = options;
        let subtotal = 0;
        $(`.${rowClass}-amount`).each(function () {
            let val = parseFloat($(this).val()) || 0;
            subtotal += val;
        });
        $(subtotalId).val(subtotal.toFixed(2));

        let discount = parseFloat($(discountId).val()) || 0;
        let taxPercent = parseFloat($(taxId).val()) || 0;
        let taxable = subtotal - ((discount / 100) * subtotal);
        let tax = taxable > 0 ? taxable * (taxPercent / 100) : 0;
        let total = taxable + tax;
        $(totalId).val(total.toFixed(2));
    }

    // Setup for Edit Bill Type Form
    setupInvoiceForm({
        addRowBtn: '#addBreakdownRow',
        tableBody: '#invoiceBreakdownTable tbody',
        rowClass: 'breakdown',
        removeRowClass: 'remove-breakdown-row',
        subtotalId: '#subtotal',
        discountId: '#deduction_percentage',
        taxId: '#editBillTaxPercentage',
        totalId: '#totalAmountInvoice'
    });

    // Setup for Create Bill Type Form
    setupInvoiceForm({
        addRowBtn: '#addCreateBreakdownRow',
        tableBody: '#createInvoiceBreakdownTable tbody',
        rowClass: 'create-breakdown',
        removeRowClass: 'remove-create-breakdown-row',
        subtotalId: '#createSubtotal',
        discountId: '#create_deduction_percentage',
        taxId: '#createTax',
        totalId: '#createTotalAmount'
    });

    // Setup for Quick Assign Bill Form (ensure subtotal/total recalc when items loaded/changed)
    setupInvoiceForm({
        addRowBtn: '#addQuickAssignBreakdownRow',
        tableBody: '#quickAssignInvoiceBreakdownTable tbody',
        rowClass: 'quick-assign-breakdown',
        removeRowClass: 'remove-quick-assign-breakdown-row',
        subtotalId: '#quick_assign_subtotal',
        discountId: '#quick_assign_deduction_percentage',
        taxId: '#quick_assign_tax',
        totalId: '#quick_assign_total_amount'
    });
    // data_student()
      function data_student() {
        //   alert(!$('#select_class_field').val())
          
        // ...existing code...
                    if (!$('#select_class_field').val()) {
                        $('#student_payment_recordTable').hide();
                        return false;
                    }
                    // alert("lkj")
        // if ($.fn.DataTable.isDataTable('#student_payment_recordTable')) {
        //         // $('#student_payment_recordTable').DataTable().ajax.reload();
        // }
        $('#student_payment_recordTable').DataTable({
            scrollX: true,
            scrollY: '50vh',
            responsive: true,
            ajax: {
                url: '../billing_controller.php',
                type: 'POST',
                data: function (d) {
                    return {
                        ...d,
                        action: 'get_student_payment_record',
                        class_id: $('#select_class_field').val(),
                        term_id: $('.term_btn.select_btn.active').attr('data-id'),
                        session_id: $('#select_session_field').val(),
                        bill_type_filter: currentBillTypeFilter,
                        student_record_filter: studentRecordFilter
                    };
                },
                dataSrc: function (json) {
                    console.log("rec",json)
                    // If no class is selected, return empty array to prevent loading
                    if (!$('#select_class_field').val()) {
            //             console.log("jjjklones")
            //             if ($.fn.DataTable.isDataTable('#student_payment_recordTable')) {
            //     console.log("wearehere mongo")
            //     $('#student_payment_recordTable').DataTable().clear().draw();
            // }
            //             $('#student_payment_recordTable').hide();
                        return [];
                    }
                    return json.data || [];
                }
            },
            columns: [
                {
                    data: null,
                    render: function (data, type, row) {
                        return row.firstname + ' ' + row.lastname;
                    }
                },
                { data: 'bill_type_name' },
                {
                    data: 'amount_due',
                    render: function (data) {
                        return '₦' + parseFloat(data).toLocaleString();
                    }
                },
                {
                    data: 'amount_paid',
                    render: function (data) {
                        return '₦' + parseFloat(data).toLocaleString();
                    }
                },
                {
                    data: 'balance',
                    render: function (data) {
                        return '₦' + parseFloat(data).toLocaleString();
                    }
                },
                {
                    data: 'status',
                    render: function (data) {
                        switch (parseInt(data)) {
                            case 1:
                                return '<span class="badge badge-success">Paid</span>';
                            case 2:
                                return '<span class="badge badge-warning">Part Paid</span>';
                            default:
                                return '<span class="badge badge-danger">Unpaid</span>';
                        }
                    },
                },
                {
                    data: 'last_payment',
                    render: function (data) {
                        if (!data || data === '0000-00-00 00:00:00') {
                            return '–';
                        }
                        const date = new Date(data);
                        if (isNaN(date.getTime())) {
                            return '–';
                        }
                        // Only display the date part (DD-MM-YYYY)
                        let formattedDate = date.toLocaleDateString('en-GB', {
                            year: 'numeric',
                            month: '2-digit',
                            day: '2-digit'
                        }).replace(/\//g, '-');
                        return formattedDate;
                    }
                },
                {
                    data: null,
                    render: function (data, type, row) {
                        // console.log("data", data)
                        // console.log("type", type)
                        // console.log("row", row)
                        if (row.bill_type) {
                            return `
                                <div class="btn-group" role="group" aria-label="Actions">
                                <button class="btn btn-xs btn-primary view-bill ${row.amount_paid == 0 && 'd-none'}" data-id="${row.id}">View Payment Record</button>
                                <button class="btn btn-xs btn-primary edit-bill ${row.amount_paid != 0 && 'd-none'}" data-id="${row.id}" data-student_id="${row.student_id}">Update Assigned Bill</button>
                                    <button class="btn btn-xs btn-primary record-payment ${row.balance == 0 && 'd-none'}" data-amountdue="${row.amount_due}" data-balance="${row.balance}" data-id="${row.id}" data-student_id="${row.student_id}">Record Payment</button>
                                    <button class="btn btn-xs btn-success ${row.amount_paid == 0 && 'd-none'} generate-last-receipt" data-bill_id="${row.id}" data-student_id="${row.student_id}">Generate Last Receipt</button>
                                    <button class="btn btn-xs btn-primary preview-invoice-btn" data-bill_id="${row.id}">View Invoice</button>
                                </div>
                            `;
                        } else {
                            return `
                                <div class="btn-group" role="group" aria-label="Actions">
                                    <button class="btn btn-xs btn-success quick-assign-bill" 
                                        data-student_id="${row.student_id}"
                                        data-student_name="${row.firstname} ${row.lastname}">
                                        <i class="fas fa-plus"></i> Assign Bill
                                    </button>
                                </div>
                            `;
                        }
                    }
                }
            ]
        });
        
        // ...existing code...
    }

    // Student record filter button handlers
    $(document).on('click', '.filter-btn', function () {
        $('.filter-btn').removeClass('btn-primary').addClass('btn-outline-primary').removeClass('active');
        $(this).removeClass('btn-outline-primary').addClass('btn-primary').addClass('active');
        studentRecordFilter = $(this).data('filter');
        if ($.fn.DataTable && $('#student_payment_recordTable').length) {
            $('#student_payment_recordTable').DataTable().ajax.reload();
        }else{
            data_student()
        }
    });
    // Handle Generate Last Receipt button click
    // $(document).on('click', '.generate-last-receipt', function () {
    //     const billId = $(this).data('bill_id');
    //     const studentId = $(this).data('student_id');
    //     const $modal = $('#paymentRecordModal');
    //     const $container = $('#paymentTimelineContainer');
    //     $container.html('<div class="text-center text-muted">Loading last payment receipt...</div>');
    //     $modal.modal('show');
    //     $.ajax({
    //         url: '../billing_controller.php',
    //         method: 'POST',
    //         dataType: 'json',
    //         data: {
    //             action: 'get_last_payment_receipt',
    //             bill_id: billId,
    //             student_id: studentId
    //         },
    //         success: function(res) {
    //             if (!res.success || !res.data) {
    //                 $container.html('<div class="alert alert-danger text-center">No payment receipt found for this bill.</div>');
    //                 return;
    //             }
    //             const d = res.data;
    //             // School info
    //             const logoUrl = d.school_logo ? ('../uploads/' + d.school_logo) : '';
    //             // Student info
    //             const student = d.student || {};
    //             // Bill info
    //             const bill = d.bill || {};
    //             // Bill type info
    //             const billType = d.bill_type || {};
    //             // Payment info
    //             const payment = d.payment || {};
    //             // Breakdown items
    //             let breakdown = [];
    //             try {
    //                 breakdown = bill.bill_items ? JSON.parse(bill.bill_items) : [];
    //             } catch (e) { breakdown = []; }
    //             // Format date
    //             function formatDate(dt) {
    //                 if (!dt) return '-';
    //                 const date = new Date(dt);
    //                 if (isNaN(date.getTime())) return dt;
    //                 return date.toLocaleString('en-GB', { year: 'numeric', month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: true });
    //             }
    //             // Format money
    //             function money(val) {
    //                 return '₦' + Number(val || 0).toLocaleString();
    //             }
    //             // Receipt HTML
    //             let html = `<div class="receipt-container p-3" id="printableReceipt">
    //                 <div class="row align-items-center mb-3">
    //                     <div class="col-2 text-center">
    //                         ${logoUrl ? `<img src="${logoUrl}" alt="School Logo" style="max-width:80px;max-height:80px;">` : ''}
    //                     </div>
    //                     <div class="col-10">
    //                         <h3 class="mb-0">${d.school_name || ''}</h3>
    //                         <h5 class="mb-0">Payment Receipt</h5>
    //                     </div>
    //                 </div>
    //                 <hr>
    //                 <div class="row mb-2">
    //                     <div class="col-md-6">
    //                         <b>Student Name:</b> ${student.firstname || ''} ${student.lastname || ''}<br>
    //                         <b>Admission No:</b> ${student.admission_no || ''}<br>
    //                         <b>Class:</b> ${d.class_name || ''}<br>
    //                     </div>
    //                     <div class="col-md-6 text-right">
    //                         <b>Receipt No:</b> ${payment.id || ''}<br>
    //                         <b>Date Paid:</b> ${formatDate(payment.date_paid)}<br>
    //                         <b>Date Issued:</b> ${formatDate(d.date_issued)}<br>
    //                     </div>
    //                 </div>
    //                 <div class="mb-2"><b>Bill Type:</b> ${billType.bill_name || ''}</div>
    //                 <div class="mb-2"><b>Description:</b> ${payment.description || billType.notes || 'Payment for school bill'}</div>
    //                 <div class="mb-2"><b>Payment Method:</b> ${payment.payment_method || 'N/A'}</div>
    //                 <div class="mb-2"><b>Notes:</b> ${billType.notes || ''}</div>
    //                 <div class="mb-2"><b>Terms:</b> ${billType.terms || ''}</div>
    //                 <div class="mb-2"><b>Breakdown:</b></div>
    //                 <table class="table table-bordered mb-2">
    //                     <thead><tr><th>Description</th><th>Amount</th></tr></thead>
    //                     <tbody>`;
    //             if (breakdown.length > 0) {
    //                 breakdown.forEach(function(item) {
    //                     let desc = '', amt = '';
    //                     if (typeof item === 'object' && !Array.isArray(item)) {
    //                         if ('description' in item && 'amount' in item) {
    //                             desc = item.description;
    //                             amt = item.amount;
    //                         } else {
    //                             const keys = Object.keys(item);
    //                             if (keys.length === 1) {
    //                                 desc = keys[0];
    //                                 amt = item[desc];
    //                             }
    //                         }
    //                     }
    //                     html += `<tr><td>${desc}</td><td>${money(amt)}</td></tr>`;
    //                 });
    //             } else {
    //                 html += `<tr><td>${billType.bill_name || 'Fee'}</td><td>${money(bill.amount)}</td></tr>`;
    //             }
    //             html += `</tbody></table>
    //                 <table class="table table-sm table-bordered mb-2">
    //                     <tr><th>Subtotal</th><td>${money(bill.amount)}</td></tr>
    //                     <tr><th>Deduction Purpose</th><td>${bill.deduction_purpose || billType.deduction_purpose || ''}</td></tr>
    //                     <tr><th>Deduction (%)</th><td>${bill.deduction_percentage || billType.deduction_percentage || 0}</td></tr>
    //                     <tr><th>Tax (%)</th><td>${bill.tax || billType.tax || 0}</td></tr>
    //                     <tr><th>Total Due</th><td><b>${money(bill.amount_due)}</b></td></tr>
    //                     <tr><th>Amount Paid</th><td><b>${money(payment.amount_newly_paid)}</b></td></tr>
    //                     <tr><th>Total Paid To Date</th><td>${money(payment.total_amount_paid)}</td></tr>
    //                     <tr><th>Balance</th><td><span class="${payment.balance > 0 ? 'text-danger' : 'text-success'}">${money(payment.balance)}</span></td></tr>
    //                 </table>
    //                 <div class="text-center mt-3"><b>Thank you for your payment!</b></div>
    //             </div>`;
    //             $container.html(html);
    //         },
    //         error: function() {
    //             $container.html('<div class="alert alert-danger text-center">Failed to load last payment receipt.</div>');
    //         }
    //     });
    // });
    // --- Record Payment Modal Logic ---
    // Open modal and populate hidden fields
    $(document).on('click', '.record-payment', function () {
        const billId = $(this).data('id');
        const studentId = $(this).data('student_id');
        console.log("this",this)
        $('#payment_student_id').val(studentId);
        $('#payment_bill_id').val(billId);
        $('#amount_due_record_payment').html(money($(this).data('amountdue')));
        $('#amount_balance_record_payment').html(money($(this).data('balance')));
        $('#payment_amount').attr("data-current_balance",money($(this).data('balance')));
        // Optionally reset form fields
        $('#recordPaymentForm')[0].reset();
        $('#recordPaymentModal').modal('show');
    });

    

    // Handle form submission
    $('#recordPaymentForm').on('submit', function (e) {
        e.preventDefault();
        // Get term_id, session_id, class_id from the page
        const term_id = $('.term_btn.select_btn.active').data('id');
        const session_id = $('#select_session_field').val();
        const class_id = $('#select_class_field').val();
        // Serialize form and append extra fields
        let formData = $(this).serialize();
        formData += '&action=record_payment';
        formData += '&term_id=' + encodeURIComponent(term_id);
        formData += '&session_id=' + encodeURIComponent(session_id);
        formData += '&class_id=' + encodeURIComponent(class_id);
        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: formData,
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    toastr.success(response.message || 'Payment recorded successfully.');
                    $('#recordPaymentModal').modal('hide');
                    // Reload the DataTable and expected income section
                    if ($.fn.DataTable.isDataTable('#student_payment_recordTable')) {
                        $('#student_payment_recordTable').DataTable().ajax.reload();
                    } else {
                        data_student();
                    }
                    if (typeof fetchAndDisplayEstimatedIncome === 'function') {
                        fetchAndDisplayEstimatedIncome();
                    }
                } else {
                    toastr.error(response.message || 'Failed to record payment.');
                }
            },
            error: function () {
                toastr.error('An error occurred while recording payment.');
            }
        });
    });
    // --- Existing DataTable and other setup code ---
    // ... (keep your existing table init, etc.)
    // Filter handling
    $('.term_btn').click(function () {
        $('.term_btn').removeClass('active');
        $(this).addClass('active');
    });
    const billTypeButtonContainer = $('#bill-type-buttons');
    let selectedBillTypeId = null; // To keep track of the selected bill type ID

    // Function to load bill types
    function loadBillTypes() {
        billTypeButtonContainer.html('<span class="text-muted">Loading bill types...</span>'); // Show loading indicator

        $.ajax({
            url: '../billing_controller.php', // Your controller file
            type: 'POST',
            data: {
                action: 'get_bill_types'
                // school_id is likely handled via session in the controller
            },
            dataType: 'json',
            success: function (response) {
                billTypeButtonContainer.empty(); // Clear previous buttons/loading message

                // Add the 'All' button first
                const allBtnClass = (currentBillTypeFilter === 'all' || currentBillTypeFilter === null) ? 'btn-success' : 'btn-primary';
                const allBtnHtml = `<button type="button" class="btn btn-primary btn-sm bill-type-btn ${allBtnClass}" data-id="all">All</button>`;
                billTypeButtonContainer.append(allBtnHtml);

                if (response && response.length > 0) {
                    response.forEach((billType, index) => {
                        loadedBillTypesData[billType.id] = {
                            bill_name: billType.bill_name,
                            amount: billType.amount,
                            tax: billType.tax
                        };

                        const btnClass = currentBillTypeFilter === billType.id ? 'btn-success' : 'btn-primary';
                        const billTypeHtml = `
                                    <div class="btn-group bill-type-group">
                                        <button type="button" 
                                                class="btn btn-sm bill-type-btn ${btnClass}" 
                                                data-id="${billType.id}" 
                                                style="color:white;">
                                            ${escapeHtml(billType.bill_name)}
                                        </button>
                                        <button type="button" 
                                                class="btn btn-sm ${btnClass} dropdown-toggle dropdown-icon" 
                                                data-toggle="dropdown" 
                                                style="color:white;">
                                            <span class="sr-only">Toggle Dropdown</span>
                                        </button>
                                        <div class="dropdown-menu" role="menu">
                                            <a class="dropdown-item edit-bill-type" href="#" data-id="${billType.id}">Edit</a>
                                            <a class="dropdown-item delete-bill-type" href="#" data-id="${billType.id}">Delete</a>
                                        </div>
                                    </div>
                                `;
                        billTypeButtonContainer.append(billTypeHtml);
                    });

                    // Trigger data table reload or other actions based on the initially selected bill type
                    console.log("Initially selected Bill Type ID:", selectedBillTypeId);
                    // Example: table.ajax.reload(); // If your table depends on this selection
                    // Or call a function: handleBillTypeSelection(selectedBillTypeId);

                } else {
                    billTypeButtonContainer.append('<span class="text-muted">No bill types found.</span>');
                }
            },
            error: function (xhr, status, error) {
                console.error("Error loading bill types:", status, error);
                billTypeButtonContainer.html('<span class="text-danger">Error loading bill types.</span>');
                toastr.error('Failed to load bill types.');
            }
        });
    }

    // --- Event Handlers ---

    // Handle clicking the main bill type button (for selection)
    // billTypeButtonContainer.on('click', '.bill-type-btn', function() {
    $('#bill_type_selector_container').on('click', '.bill-type-btn', function () {
        const $button = $(this);
        const billTypeId = $button.data('id');

        // Remove active state from all buttons
        $('.bill-type-btn').removeClass('btn-success').addClass('btn-primary');

        // Add active state to clicked button
        $button.removeClass('btn-primary').addClass('btn-success');

        // Update current filter
        // console.log(billTypeId)
        currentBillTypeFilter = billTypeId; // This can be 'all' or a number

        console.log("Selected bill type:", currentBillTypeFilter); // For debugging


        // Reload the DataTable
        if ($.fn.DataTable.isDataTable('#student_payment_recordTable')) {
                $('#student_payment_recordTable').DataTable().ajax.reload();
            } else {
                data_student();
            }
        fetchAndDisplayEstimatedIncome();

    });

    // Handle clicking the "Edit" dropdown item
    billTypeButtonContainer.on('click', '.edit-bill-type', function (e) {
        e.preventDefault();
        // Find the parent .bill-type-group, then the .bill-type-btn inside it
        const $group = $(this).closest('.bill-type-group');
        const $btn = $group.find('.bill-type-btn');
        const billId = $btn.data('id');

        // Fetch bill type details from the server
        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: {
                action: 'get_bill_type',
                bill_type_id: billId
            },
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    // Populate the edit modal fields with fetched data
                    $('#editBillTypeId').val(response.data.id);
                    $('#editBillName').val(response.data.bill_name);
                    $('#editAmount').val(response.data.amount);
                    $('#editBillTaxPercentage').val(response.data.tax);
                    $('#deductionPurpose').val(response.data.deduction_purpose);
                    $('#deduction_percentage').val(response.data.deduction_percentage);
                    $('#subtotal').val(response.data.subtotal);
                    $('#totalAmountInvoice').val(response.data.total);
                    $('#notes').val(response.data.notes);
                    $('#terms').val(response.data.terms);
                    // Populate breakdown table
                    let items = [];
                    try {
                        items = JSON.parse(response.data.bill_items || '[]');
                    } catch (e) {
                        items = [];
                    }
                    const $tbody = $('#invoiceBreakdownTable tbody');
                    $tbody.empty();
                    if (items.length > 0) {
                        items.forEach(function (item) {
                            // Support both {description, amount} and {label, value} or {"First term":5000} style
                            let desc = '';
                            let amt = '';
                            if (typeof item === 'object' && !Array.isArray(item)) {
                                if ('description' in item && 'amount' in item) {
                                    desc = item.description;
                                    amt = item.amount;
                                } else {
                                    // Handle {"First term":5000} style
                                    const keys = Object.keys(item);
                                    if (keys.length === 1) {
                                        desc = keys[0];
                                        amt = item[desc];
                                    }
                                }
                            }
                            $tbody.append(`
                                        <tr>
                                            <td><input type="text" name="breakdown_description[]" class="form-control" value="${desc}" required></td>
                                            <td><input type="number" name="breakdown_amount[]" class="form-control breakdown-amount" step="0.01" min="0" value="${amt}" required></td>
                                            <td><button type="button" class="btn btn-danger btn-sm remove-breakdown-row" title="Remove"><i class="fas fa-trash"></i></button></td>
                                        </tr>
                                    `);
                        });
                    } else {
                        $tbody.append(`
                                    <tr>
                                        <td><input type="text" name="breakdown_description[]" class="form-control" placeholder="e.g. Uniform Fee" required></td>
                                        <td><input type="number" name="breakdown_amount[]" class="form-control breakdown-amount" step="0.01" min="0" required></td>
                                        <td><button type="button" class="btn btn-danger btn-sm remove-breakdown-row" title="Remove"><i class="fas fa-trash"></i></button></td>
                                    </tr>
                                `);
                    }
                    // Show the modal
                    $('#editBillTypeModal').modal('show');
                } else {
                    toastr.error(response.message || 'Failed to fetch bill type details.');
                }
            },
            error: function () {
                toastr.error('An error occurred while fetching bill type details.');
            }
        });
    });

    // Handle clicking the "Delete" dropdown item
    billTypeButtonContainer.on('click', '.delete-bill-type', function (e) {
        e.preventDefault();
        // Correctly get billId from the clicked delete link's data-id attribute
        const billId = $(this).data('id');
        // Correctly get billName from the text of the main button within the same group
        const billName = $(this).closest('.btn-group').find('.bill-type-btn').text().trim();

        // Set confirmation text and store ID for the confirmation button
        $('#deleteBillTypeName').text(billName);
        $('#confirmDeleteBillType').data('id', billId); // Store ID on the button

        // Show the confirmation modal
        $('#deleteBillTypeModal').modal('show');
    });

    // Handle the actual deletion confirmation
    $('#confirmDeleteBillType').on('click', function () {
        const billId = $(this).data('id');
        const $deleteButton = $(this); // Reference the button
        $deleteButton.prop('disabled', true).text('Deleting...'); // Disable button

        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: {
                action: 'delete_bill_type',
                bill_type_id: billId
            },
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    toastr.success(response.message || 'Bill type deleted successfully.');
                    $('#deleteBillTypeModal').modal('hide');
                    loadBillTypes(); // Reload the bill types list
                } else {
                    toastr.error(response.message || 'Failed to delete bill type.');
                }
            },
            error: function () {
                toastr.error('An error occurred while trying to delete the bill type.');
            },
            complete: function () {
                $deleteButton.prop('disabled', false).text('Delete'); // Re-enable button
            }
        });
    });

    // Handle Create Bill Type Form Submission
    $('#createBillTypeForm').on('submit', function (e) {
        e.preventDefault();
        const $form = $(this);
        const $submitButton = $form.closest('.modal-content').find('button[type="submit"]');
        $submitButton.prop('disabled', true).text('Creating...');

        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: $form.serialize() + '&action=create_bill_type', // Add action parameter
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    toastr.success(response.message || 'Bill type created successfully.');
                    $('#createBillTypeModal').modal('hide');
                    $form[0].reset(); // Clear the form
                    loadBillTypes(); // Reload the list
                } else {
                    toastr.error(response.message || 'Failed to create bill type.');
                }
            },
            error: function () {
                toastr.error('An error occurred while creating the bill type.');
            },
            complete: function () {
                $submitButton.prop('disabled', false).text('Create');
            }
        });
    });

    // Handle Edit Bill Type Form Submission
    $('#editBillTypeForm').on('submit', function (e) {
        e.preventDefault();
        const $form = $(this);
        const $submitButton = $form.closest('.modal-content').find('button[type="submit"]');
        $submitButton.prop('disabled', true).text('Saving...');

        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: $form.serialize() + '&action=update_bill_type', // Add action parameter
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    toastr.success(response.message || 'Bill type updated successfully.');
                    $('#editBillTypeModal').modal('hide');
                    loadBillTypes(); // Reload the list
                } else {
                    toastr.error(response.message || 'Failed to update bill type.');
                }
            },
            error: function () {
                toastr.error('An error occurred while updating the bill type.');
            },
            complete: function () {
                $submitButton.prop('disabled', false).text('Save Changes');
            }
        });
    });


    // --- Initial Load ---
    loadBillTypes();



    // --- Create/Assign Bill Modal Logic ---


    // Function to load Bill Types into the modal dropdown
    function loadBillTypesModal() {
        $selectBillTypeModal.prop('disabled', true).html('<option value="" selected disabled>Loading...</option>'); // Disable and show loading

        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: {
                action: 'get_bill_types'
            },
            dataType: 'json',
            success: function (billTypes) {
                $selectBillTypeModal.empty().append('<option value="" selected disabled>Select a Bill Type</option>'); // Clear and add default
                loadedBillTypesData = {}; // Reset cache
                if (billTypes && billTypes.length > 0) {
                    billTypes.forEach(function (bill) {
                        $selectBillTypeModal.append(`<option value="${bill.id}">${escapeHtml(bill.bill_name)}</option>`);
                        // Store amount and tax for quick lookup
                        loadedBillTypesData[bill.id] = {
                            bill_name: bill.bill_name,
                            amount: bill.amount,
                            tax: bill.tax
                        };
                    });
                    $selectBillTypeModal.prop('disabled', false); // Enable dropdown
                } else {
                    $selectBillTypeModal.append('<option value="" disabled>No bill types found</option>');
                }
                // Reinitialize Select2 if it was already initialized
                // if ($selectBillTypeModal.data('select2')) {
                //     $selectBillTypeModal.select2('destroy');
                //     console.log("knoceno")
                // }
                // $selectBillTypeModal.select2({
                //     dropdownParent: $createAssignModal
                // });
                if ($selectBillTypeModal.data('select2')) {
                    $selectBillTypeModal.select2('destroy').select2({
                        dropdownParent: $createAssignModal
                    }); // Reinitialize with dropdownParent
                }
                else {
                    $selectBillTypeModal.select2({
                        dropdownParent: $createAssignModal
                    }); // Initialize with dropdownParent
                }
                $selectBillTypeModal.val(null).trigger('change'); // Reset selection
            },
            error: function (xhr, status, error) {
                console.error("Error loading bill types for modal:", status, error);
                $selectBillTypeModal.html('<option value="" disabled>Error loading bill types</option>');
                toastr.error('Failed to load bill types for the modal.');
            }
        });
    }

    // Function to load Classes into the filter dropdown
    // Function to load Classes into the filter dropdown
    function loadClassesFilterModal() {
        $filterClassModal.prop('disabled', true).html('<option value="" selected disabled>Loading classes...</option>');
        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: {
                action: 'get_classes'
            },
            dataType: 'json',
            success: function (classes) {
                $filterClassModal.empty().append('<option value="" selected disabled>Select a class to load students</option>');
                if (classes && classes.length > 0) {
                    classes.forEach(function (cls) {
                        $filterClassModal.append(`<option value="${cls.id}">${escapeHtml(cls.classname)}</option>`);
                    });
                    $filterClassModal.prop('disabled', false);
                } else {
                    $filterClassModal.append('<option value="" disabled>No classes found</option>');
                }
                // Always reinitialize Select2
                if ($filterClassModal.data('select2')) {
                    $filterClassModal.select2('destroy');
                }
                // $filterClassModal.select2({
                //     dropdownParent: $createAssignModal,
                //     width: '100%'
                // });
                $filterClassModal.val(null).trigger('change'); // Reset selection

            },
            error: function (xhr, status, error) {
                console.error("Error loading classes for modal filter:", status, error);
                $filterClassModal.html('<option value="" disabled>Error loading classes</option>');
                toastr.error('Failed to load classes for the filter.');
            }
        });
    }


    // --- Event Listener for Modal Show ---
    $createAssignModal.on('show.bs.modal', function () {
        // Reset form elements and state when modal opens
        $assignBillForm[0].reset();
        $selectBillTypeModal.val(null).trigger('change');
        $filterClassModal.val(null).trigger('change');
        $billAmountModal.prop('readonly', true).val('');
        $billTaxModal.prop('readonly', true).val('');
        $studentListTableBody.html('<tr><td colspan="4" class="text-center text-muted">Select a class to view students.</td></tr>');
        $selectAllCheckbox.prop('checked', false);
        selectedStudents = {}; // Clear selected students
        $previewContent.html('<p class="text-muted">Click the "Preview Bill" button in the Assign Bill tab to see the details here.</p>');
        $assignNowButton.prop('disabled', true); // Disable assign button initially
        // Ensure Assign Bill tab is active
        $('#assign-bill-tab-link').tab('show');

        // Load dynamic data
        loadClassesFilterModal();
        loadBillTypesModal();
    });

    // Initialize Select2 for the dropdowns inside the modal *once*
    // We use dropdownParent to ensure the dropdown appears correctly within the modal
    $selectBillTypeModal.select2({
        dropdownParent: $createAssignModal
    });
    // $filterClassModal.select2({
    //     dropdownParent: $createAssignModal
    // });

    // --- (End Create/Assign Bill Modal Logic) ---
    // --- Event Listener for Bill Type Change in Modal ---
    $selectBillTypeModal.on('change', function () {
        const selectedBillTypeId = $(this).val();

        if (selectedBillTypeId && loadedBillTypesData[selectedBillTypeId]) {
            const billData = loadedBillTypesData[selectedBillTypeId];
            // Populate amount and tax, make them editable
            $billAmountModal.val(billData.amount).prop('readonly', false);
            $billTaxModal.val(billData.tax).prop('readonly', false);
        } else {
            // Clear amount and tax, make them readonly again
            $billAmountModal.val('').prop('readonly', true);
            $billTaxModal.val('').prop('readonly', true);
        }
        updateAssignBillTotal();
        // Maybe trigger validation or other dependent actions if needed
    });
    // --- Event Listener for Class Filter Change in Modal ---
    $filterClassModal.on('change', function () {
        const selectedClassId = $(this).val();
        const selectedClassName = $(this).find('option:selected').text(); // Get class name for display

        if (!selectedClassId) {
            $studentListTableBody.html('<tr><td colspan="4" class="text-center text-muted">Select a class to view students.</td></tr>');
            $selectAllCheckbox.prop('checked', false).prop('disabled', true); // Disable select all if no class
            return; // Exit if no class selected
        }

        // Show loading state
        $studentListTableBody.html('<tr><td colspan="4" class="text-center text-muted"><i class="fas fa-spinner fa-spin"></i> Loading students...</td></tr>');
        $selectAllCheckbox.prop('checked', false).prop('disabled', true); // Disable while loading

        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: {
                action: 'get_students_by_class',
                class_id: selectedClassId
            },
            dataType: 'json',
            success: function (response) {
                $studentListTableBody.empty(); // Clear loading message or previous students
                if (response.success && response.students && response.students.length > 0) {
                    response.students.forEach(function (student) {
                        // Check if this student is already selected (from a previous class filter)
                        const isChecked = selectedStudents.hasOwnProperty(student.id);
                        const rowHtml = `
                                                <tr>
                                                    <td>
                                                        <input type="checkbox" class="student-checkbox" value="${student.id}" data-student-name="${escapeHtml(student.student_name)}" data-admission-no="${escapeHtml(student.admission_no)}" data-class-name="${escapeHtml(student.class_name)}" data-class-id="${selectedClassId}" ${isChecked ? 'checked' : ''}>
                                                    </td>
                                                    <td>${escapeHtml(student.student_name)}</td>
                                                    <td>${escapeHtml(student.admission_no)}</td>
                                                    <td>${escapeHtml(student.classname)}</td>
                                                </tr>
                                            `;
                        $studentListTableBody.append(rowHtml);
                    });
                    $selectAllCheckbox.prop('disabled', false); // Enable select all
                    updateSelectAllCheckboxState(); // Check if all currently displayed are selected
                } else if (response.success) {
                    $studentListTableBody.html('<tr><td colspan="4" class="text-center text-muted">No students found in this class.</td></tr>');
                    $selectAllCheckbox.prop('disabled', true); // No students to select
                } else {
                    $studentListTableBody.html('<tr><td colspan="4" class="text-center text-danger">Error loading students.</td></tr>');
                    toastr.error(response.message || 'Failed to load students for the selected class.');
                    $selectAllCheckbox.prop('disabled', true);
                }
            },
            error: function (xhr, status, error) {
                console.error("Error loading students:", status, error);
                $studentListTableBody.html('<tr><td colspan="4" class="text-center text-danger">An error occurred while loading students.</td></tr>');
                toastr.error('An error occurred while loading students.');
                $selectAllCheckbox.prop('disabled', true);
            }
        });
    });

    // --- Helper Function to Update Select All Checkbox State ---
    function updateSelectAllCheckboxState() {
        const $visibleCheckboxes = $studentListTableBody.find('.student-checkbox');
        const totalVisible = $visibleCheckboxes.length;
        const totalCheckedVisible = $visibleCheckboxes.filter(':checked').length;

        if (totalVisible === 0) {
            $selectAllCheckbox.prop('checked', false).prop('indeterminate', false).prop('disabled', true);
        } else {
            $selectAllCheckbox.prop('disabled', false);
            if (totalCheckedVisible === totalVisible) {
                $selectAllCheckbox.prop('checked', true).prop('indeterminate', false);
            } else if (totalCheckedVisible > 0) {
                $selectAllCheckbox.prop('checked', false).prop('indeterminate', true); // Partially selected
            } else {
                $selectAllCheckbox.prop('checked', false).prop('indeterminate', false); // None selected
            }
        }
    }
    // alert("nkcn")
    // --- Helper Function to Update Assign Now Button State ---
    function updateAssignNowButtonState() {
        const billTypeSelected = $selectBillTypeModal.val();
        const studentsSelectedCount = Object.keys(selectedStudents).length;

        // Enable Assign Now only if a bill type is selected AND at least one student is selected
        if (billTypeSelected && studentsSelectedCount > 0) {
            $assignNowButton.prop('disabled', false);
        } else {
            $assignNowButton.prop('disabled', true);
        }
    }

    // --- Event Listener for Individual Student Checkbox Change ---
    // Use event delegation on the table body for dynamically added rows
    $studentListTableBody.on('change', '.student-checkbox', function () {
        const $checkbox = $(this);
        const studentId = $checkbox.val();
        const isChecked = $checkbox.prop('checked');

        if (isChecked) {
            // Add student to selectedStudents object
            selectedStudents[studentId] = {
                id: studentId, // Store id explicitly as well
                name: $checkbox.data('student-name'),
                admission_no: $checkbox.data('admission-no'),
                class_name: $checkbox.data('class-name'),
                class_id: $checkbox.data('class-id') // Store class_id
            };
        } else {
            // Remove student from selectedStudents object
            delete selectedStudents[studentId];
        }

        // console.log("Selected Students:", selectedStudents); // For debugging
        updateSelectAllCheckboxState(); // Update the header checkbox state
        updateAssignNowButtonState(); // Update the Assign Now button state
    });

    // --- Event Listener for "Select All" Checkbox Change ---
    $selectAllCheckbox.on('change', function () {
        const isChecked = $(this).prop('checked');
        // Select/deselect only the checkboxes currently visible in the table
        $studentListTableBody.find('.student-checkbox').each(function () {
            const $studentCheckbox = $(this);
            const studentId = $studentCheckbox.val();

            // Only change if the state is different
            if ($studentCheckbox.prop('checked') !== isChecked) {
                $studentCheckbox.prop('checked', isChecked);

                if (isChecked) {
                    // Add student to selectedStudents
                    selectedStudents[studentId] = {
                        id: studentId,
                        name: $studentCheckbox.data('student-name'),
                        admission_no: $studentCheckbox.data('admission-no'),
                        class_name: $studentCheckbox.data('class-name'),
                        class_id: $studentCheckbox.data('class-id')
                    };
                } else {
                    // Remove student from selectedStudents
                    // Important: Only remove if it exists (might have been added from another class view)
                    if (selectedStudents.hasOwnProperty(studentId)) {
                        delete selectedStudents[studentId];
                    }
                }
            } else if (isChecked && !selectedStudents.hasOwnProperty(studentId)) {
                // Edge case: If 'Select All' is checked, but this student wasn't in the object yet
                // (e.g., due to complex state changes), add them.
                selectedStudents[studentId] = {
                    id: studentId,
                    name: $studentCheckbox.data('student-name'),
                    admission_no: $studentCheckbox.data('admission-no'),
                    class_name: $studentCheckbox.data('class-name'),
                    class_id: $studentCheckbox.data('class-id')
                };
            }
        });

        // console.log("Selected Students after Select All:", selectedStudents); // For debugging
        updateAssignNowButtonState(); // Update the Assign Now button state
    });

    // Also call updateAssignNowButtonState when bill type changes
    $selectBillTypeModal.on('change', function () {
        // ... (existing code to set amount/tax) ...
        updateAssignNowButtonState(); // Add this call here too
    });
    // --- Event Listener for Preview Bill Button ---
    // Extract preview generation into a callable function so preview can be triggered
    function renderAssignPreview() {
        // --- 1. Gather Data (from invoice fields) ---
        const billTypeId = $selectBillTypeModal.val();
        const billTypeName = $selectBillTypeModal.find('option:selected').text();
        const subtotal = $('#assignSubtotal').val();
        const deductionPurpose = $('#assignDeductionPurpose').val();
        const deductionPercentage = $('#assignDeductionPercentage').val();
        const tax = $('#assignTaxPercentage').val();
        const totalAmount = $('#assignTotalAmount').val();
        const notes = $('#assignNotes').val();
        const terms = $('#assignTerms').val();
        const termId = $('.term_btn.select_btn.active').data('id');
        const termName = $('.term_btn.select_btn.active').text() + ' Term';
        const sessionId = $('#select_session_field').val();
        const sessionName = $('#select_session_field option:selected').text();
        const studentCount = Object.keys(selectedStudents).length;

        // --- 2. Basic Validation ---
        let errors = [];
        if (!billTypeId) {
            errors.push("Please select a Bill Type.");
        }
        if (totalAmount === '' || isNaN(parseFloat(totalAmount)) || parseFloat(totalAmount) < 0) {
            errors.push("Please enter a valid Total Amount.");
        }
        if (tax === '' || isNaN(parseFloat(tax)) || parseFloat(tax) < 0) {
            errors.push("Please enter a valid Tax percentage (use 0 if none).");
        }
        if (!termId) {
            errors.push("Please select a Term on the main page.");
        }
        if (!sessionId) {
            errors.push("Please select a Session on the main page.");
        }
        if (studentCount === 0) {
            errors.push("Please select at least one student to assign the bill to.");
        }

        if (errors.length > 0) {
            toastr.warning(errors.join('<br>'), 'Missing Information');
            return false; // indicate preview not rendered due to validation
        }

        // --- 3. Format Data for Preview (Branded Card Layout) ---
        const schoolLogo = (typeof __school_logo !== 'undefined') ? __school_logo : null; // optional global
        let previewHtml = `...preview-template-placeholder...`;

        // Build the real preview HTML (reuse previous card HTML block)
        previewHtml = (function buildPreview() {
            let html = '';
            html += `<div class="card">`;
            html += `<div class="card-header bg-white border-0 d-flex align-items-center">`;
            html += `<div class="mr-3">`;
            const logo = sessionStorage.getItem('schoolLogo');
            if (logo) html += `<img src="${logo}" style="height:48px; width:auto;">`;
            else if (typeof logoUrl !== 'undefined' && logoUrl) html += `<img src="${logoUrl}" style="height:48px; width:auto;">`;
            html += `</div>`;
            html += `<div><h5 class="mb-0">${escapeHtml(billTypeName)} — Preview</h5><small class="text-muted">${escapeHtml(sessionName)} · ${escapeHtml(termName)}</small></div>`;
            html += `<div class="ml-auto text-right"><span class="badge badge-pill badge-info">${studentCount} student(s)</span></div>`;
            html += `</div>`;
            html += `<div class="card-body">`;
            html += `<div class="row mb-3"><div class="col-md-8"><h6 class="text-secondary">Breakdown</h6><div class="table-responsive"><table class="table table-sm table-borderless mb-0"><thead><tr class="text-muted"><th>Description</th><th class="text-right">Amount</th></tr></thead><tbody>`;
            let rows = '';
            $('#assignInvoiceBreakdownTableAssign tbody tr').each(function () {
                const desc = $(this).find('input').eq(0).val() || '';
                const amt = $(this).find('input').eq(1).val() || '';
                if (desc || amt) rows += `<tr><td>${escapeHtml(desc)}</td><td class="text-right">₦${Number(amt || 0).toLocaleString()}</td></tr>`;
            });
            if (!rows) rows = '<tr><td colspan="2" class="text-muted">No items</td></tr>';
            html += rows;
            html += `</tbody></table></div></div>`;
            html += `<div class="col-md-4"><div class="card bg-light"><div class="card-body p-2">`;
            html += `<div class="d-flex justify-content-between"><small class="text-muted">Subtotal</small><strong>₦${Number($('#assignSubtotal').val() || 0).toLocaleString()}</strong></div>`;
            html += `<div class="d-flex justify-content-between"><small class="text-muted">Deduction</small><strong>${escapeHtml($('#assignDeductionPercentage').val() || '0')}%</strong></div>`;
            html += `<div class="d-flex justify-content-between"><small class="text-muted">Tax</small><strong>${escapeHtml($('#assignTaxPercentage').val() || '0')}%</strong></div>`;
            html += `<hr class="my-2">`;
            html += `<div class="d-flex justify-content-between"><small class="text-muted">Total Due</small><strong>₦${Number($('#assignTotalAmount').val() || 0).toLocaleString()}</strong></div>`;
            html += `</div></div><div class="mt-2 small text-muted">Notes:</div><div class="small text-dark">${escapeHtml(notes || '') || '<span class="text-muted">No notes</span>'}</div></div></div>`;
            html += `<hr><h6 class="text-secondary">Selected Students</h6>`;

            // Students grouped by class
            const studentsByClass = {};
            for (const studentId in selectedStudents) {
                const student = selectedStudents[studentId];
                const className = student.class_name || 'Unknown Class';
                if (!studentsByClass[className]) studentsByClass[className] = [];
                studentsByClass[className].push(student);
            }
            const sortedClassNames = Object.keys(studentsByClass).sort();
            if (sortedClassNames.length > 0) {
                sortedClassNames.forEach(className => {
                    html += `<div class="mt-3"><strong>${escapeHtml(className)}</strong>`;
                    html += `<div class="table-responsive"><table class="table table-sm table-striped mb-0"><thead><tr><th style="width:40px">#</th><th>Student Name</th><th>Admission No</th></tr></thead><tbody>`;
                    studentsByClass[className].sort((a, b) => a.name.localeCompare(b.name));
                    studentsByClass[className].forEach((student, index) => {
                        html += `<tr><td>${index + 1}</td><td>${escapeHtml(student.name)}</td><td>${escapeHtml(student.admission_no)}</td></tr>`;
                    });
                    html += `</tbody></table></div></div>`;
                });
            } else {
                html += '<p class="text-muted">No students selected.</p>';
            }

            html += `</div><div class="card-footer text-right bg-white"><small class="text-muted">Preview — review details before assigning</small></div></div>`;
            return html;
        })();

        $previewContent.html(previewHtml);
        $previewTabLink.tab('show');
        return true; // success
    }

    // Attach to button if present; otherwise other code should call renderAssignPreview()
    if ($previewButton && $previewButton.length) {
        $previewButton.off('click.assignPreview').on('click.assignPreview', function () {
            renderAssignPreview();
        });
    }

    // --- Wizard Navigation for Create/Assign Bill Modal ---
    (function setupAssignWizard() {
        const $step1 = $('#step-1');
        const $step2 = $('#step-2');
        const $step3 = $('#step-3');
        const $stepBtn1 = $('#step-btn-1');
        const $stepBtn2 = $('#step-btn-2');
        const $stepBtn3 = $('#step-btn-3');
        const $nextBtn = $('#wizard-next-btn');
        const $backBtn = $('#wizard-back-btn');

        function showStep(stepIndex) {
            $step1.hide(); $step2.hide(); $step3.hide();
            $stepBtn1.removeClass('btn-primary').addClass('btn-secondary');
            $stepBtn2.removeClass('btn-primary').addClass('btn-secondary');
            $stepBtn3.removeClass('btn-primary').addClass('btn-secondary');
            if (stepIndex === 1) { $step1.show(); $stepBtn1.removeClass('btn-secondary').addClass('btn-primary'); $backBtn.hide(); $nextBtn.show(); $assignNowButton.hide(); }
            if (stepIndex === 2) { $step2.show(); $stepBtn2.removeClass('btn-secondary').addClass('btn-primary'); $backBtn.show(); $nextBtn.show(); $assignNowButton.hide(); }
            if (stepIndex === 3) {
                // Attempt to render preview and validate before showing step 3
                if (typeof renderAssignPreview === 'function') {
                    const ok = renderAssignPreview();
                    if (!ok) return; // don't show step 3 if preview validation fails
                } else {
                    // Fallback to triggering preview button if function is absent
                    if ($previewButton && $previewButton.length) $previewButton.trigger('click');
                }
                $step3.show(); $stepBtn3.removeClass('btn-secondary').addClass('btn-primary'); $backBtn.show(); $nextBtn.hide(); $assignNowButton.show();
            }
        }

        // Start on step 1 when modal opens
        $createAssignModal.on('shown.bs.modal', function () {
            showStep(1);
        });

        // Click handlers for the step buttons (navigate if valid)
        $stepBtn1.on('click', function () { showStep(1); });
        $stepBtn2.on('click', function () { showStep(2); });
        $stepBtn3.on('click', function () { 
            // Jump to step 3; showStep will generate preview and validate
            showStep(3);
        });

        // Next/back logic
        $nextBtn.on('click', function () {
            if ($step1.is(':visible')) {
                // Validate step 1 basics before moving to step 2
                const billTypeId = $selectBillTypeModal.val();
                if (!billTypeId) {
                    toastr.warning('Please select a Bill Type before proceeding.');
                    return;
                }
                // ensure there's at least one breakdown row with amount
                let hasItem = false;
                $('#assignInvoiceBreakdownTableAssign tbody tr').each(function () {
                    const amt = $(this).find('input[name="assign_breakdown_amount[]"]').val();
                    if (amt !== undefined && amt !== null && amt !== '') hasItem = true;
                });
                if (!hasItem) { toastr.warning('Please add at least one breakdown item.'); return; }
                showStep(2);
            } else if ($step2.is(':visible')) {
                // Ensure at least one student selected
                if (Object.keys(selectedStudents).length === 0) {
                    toastr.warning('Please select at least one student before proceeding.');
                    return;
                }
                // Let showStep handle preview generation and validation
                showStep(3);
            }
        });

        $backBtn.on('click', function () {
            if ($step3.is(':visible')) { showStep(2); }
            else if ($step2.is(':visible')) { showStep(1); }
        });
    })();

    // --- Event Listener for Assign Now Button ---
    $assignNowButton.on('click', function () {
        const $button = $(this);

        // --- 1. Gather Data (All Invoice Fields) ---
        const billTypeId = $selectBillTypeModal.val();
        const subtotal = $('#assignSubtotal').val();
        const deductionPurpose = $('#assignDeductionPurpose').val();
        const deductionPercentage = $('#assignDeductionPercentage').val();
        const tax = $('#assignTaxPercentage').val();
        const totalAmount = $('#assignTotalAmount').val();
        const notes = $('#assignNotes').val();
        const terms = $('#assignTerms').val();
        const termId = $('.term_btn.select_btn.active').data('id');
        const sessionId = $('#select_session_field').val();
        const studentCount = Object.keys(selectedStudents).length;

        // Gather breakdown items
        const breakdownDescriptions = [];
        const breakdownAmounts = [];
        $('#assignInvoiceBreakdownTableAssign tbody tr').each(function () {
            const desc = $(this).find('input[name="assign_breakdown_description[]"]').val();
            const amt = $(this).find('input[name="assign_breakdown_amount[]"]').val();
            console.log(desc, amt)
            if (desc && amt !== undefined && amt !== null && amt !== '') {
                breakdownDescriptions.push(desc);
                breakdownAmounts.push(amt);
            }
        });

        // --- 2. Validation (Reuse or copy from Preview) ---
        let errors = [];
        if (!billTypeId) errors.push("Please select a Bill Type.");
        if (totalAmount === '' || isNaN(parseFloat(totalAmount)) || parseFloat(totalAmount) < 0) errors.push("Please enter a valid Total Amount.");
        if (tax === '' || isNaN(parseFloat(tax)) || parseFloat(tax) < 0) errors.push("Please enter a valid Tax percentage (use 0 if none).");
        if (!termId) errors.push("Please select a Term on the main page.");
        if (!sessionId) errors.push("Please select a Session on the main page.");
        if (studentCount === 0) errors.push("Please select at least one student.");
        if (breakdownDescriptions.length === 0) errors.push("Please add at least one breakdown item.");

        if (errors.length > 0) {
            toastr.warning(errors.join('<br>'), 'Missing Information');
            return; // Stop if validation fails
        }

        // --- 3. Prepare Data for Submission ---
        const dataToSend = {
            action: 'assign_bill_to_students',
            bill_type_id: billTypeId,
            assign_subtotal: subtotal,
            assign_deduction_purpose: deductionPurpose,
            assign_deduction_percentage: deductionPercentage,
            assign_tax: tax,
            assign_total_amount: totalAmount,
            assign_notes: notes,
            assign_terms: terms,
            assign_breakdown_description: breakdownDescriptions,
            assign_breakdown_amount: breakdownAmounts,
            term_id: termId,
            session_id: sessionId,
            students: JSON.stringify(selectedStudents)
        };

        // --- 4. AJAX Call ---
        $button.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Assigning...'); // Show loading state

        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: dataToSend,
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    toastr.success(response.message || 'Bill assigned successfully!');
                    $createAssignModal.modal('hide'); // Close the modal on success

                    // --- Reload the main DataTable ---
                    if ($.fn.DataTable.isDataTable('#student_payment_recordTable')) {
                        $('#student_payment_recordTable').DataTable().ajax.reload();
                    }else{
                        data_student()
                    }
                    fetchAndDisplayEstimatedIncome();
                } else {
                    toastr.error(response.message || 'Failed to assign bill. Please check details and try again.');
                }
            },
            error: function (xhr, status, error) {
                console.error("Error assigning bill:", status, error, xhr.responseText);
                toastr.error('An error occurred while assigning the bill. Please try again.');
            },
            complete: function () {
                // Re-enable button regardless of success or error
                $button.prop('disabled', false).text('Assign Now');
            }
        });
    });

    // --- Edit Bill Modal: Invoice Structure Setup ---
    // Setup invoice form for Edit Bill Modal
    setupInvoiceForm({
        addRowBtn: '#addEditBreakdownRow',
        tableBody: '#editInvoiceBreakdownTable tbody',
        rowClass: 'edit_breakdown',
        removeRowClass: 'remove-edit-breakdown-row',
        subtotalId: '#editSubtotal',
        discountId: '#editDeductionPercentage',
        taxId: '#editTaxPercentage',
        totalId: '#editTotalAmount'
    });

    // Event handler for edit button click (load bill data and breakdown)
    $('#student_payment_recordTable').on('click', '.edit-bill', function () {
        const billId = $(this).data('id');
        const studentId = $(this).data('student_id');
        const termId = $('.term_btn.select_btn.active').data('id');
        const sessionId = $('#select_session_field').val();
        const classId = $('#select_class_field').val();

        // Load bill types for dropdown (but do not overwrite invoice fields)
        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: { action: 'get_bill_types' },
            dataType: 'json',
            success: function (billTypes) {
                const $select = $('#edit_bill_type');
                $select.empty();
                billTypes.forEach(function (type) {
                    $select.append(new Option(type.bill_name, type.id));
                });
                if ($select.data('select2')) $select.select2('destroy');
                $select.select2({ dropdownParent: $('#editBillModal') });
            }
        });

        // Always load bill details for the selected student/bill
        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: {
                action: 'get_bill_details',
                bill_id: billId,
                student_id: studentId,
                term_id: termId,
                session_id: sessionId,
                class_id: classId
            },
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    const data = response.data;
                    // Populate form fields from bill_record (not bill_type)
                    $('#edit_bill_id').val(data.id);
                    $('#edit_student_id').val(data.student_id);
                    $('#edit_student_name').val(data.student_name);
                    $('#editDeductionPurpose').val(data.deduction_purpose || '');
                    $('#editDeductionPercentage').val(data.deduction_percentage || 0);
                    $('#editTaxPercentage').val(data.tax || 0);
                    $('#editNotes').val(data.notes || '');
                    $('#editTerms').val(data.terms || '');
                    $('#edit_bill_type').val(data.bill_type).trigger('change.select2');

                    // Payment record fields
                    // $('#editAmountPaid').val(data.amount_paid || 0);
                    $('#editTotalAmount').val(data.total_amount || data.amount || 0);

                    // Load breakdown rows from bill_record
                    const $tbody = $('#editInvoiceBreakdownTable tbody');
                    $tbody.empty();
                    if (data.breakdown && Array.isArray(data.breakdown) && data.breakdown.length > 0) {
                        data.breakdown.forEach(function (item) {
                            let desc = Object.keys(item)[0];
                            let amt = item[desc];
                            $tbody.append(`
                                <tr class="edit-breakdown">
                                    <td><input type="text" name="edit_breakdown_description[]" class="form-control" value="${escapeHtml(desc)}" required></td>
                                    <td><input type="number" name="edit_breakdown_amount[]" class="form-control edit_breakdown-amount" step="0.01" min="0" value="${amt}" required></td>
                                    <td><button type="button" class="btn btn-danger btn-sm remove-edit-breakdown-row" title="Remove"><i class="fas fa-trash"></i></button></td>
                                </tr>
                            `);
                        });
                    } else {
                        $tbody.append(`
                            <tr class="edit-breakdown">
                                <td><input type="text" name="edit_breakdown_description[]" class="form-control" placeholder="e.g. Tuition" required></td>
                                <td><input type="number" name="edit_breakdown_amount[]" class="form-control edit_breakdown-amount" step="0.01" min="0" required></td>
                                <td><button type="button" class="btn btn-danger btn-sm remove-edit-breakdown-row" title="Remove"><i class="fas fa-trash"></i></button></td>
                            </tr>
                        `);
                    }
                    // Set subtotal and total
                    updateInvoiceTotal({
                        rowClass: 'edit_breakdown',
                        subtotalId: '#editSubtotal',
                        discountId: '#editDeductionPercentage',
                        taxId: '#editTaxPercentage',
                        totalId: '#editTotalAmount'
                    });

                    // Set balance and status
                    updateEditPaymentFields();

                    // Show modal
                    $('#editPreviewBillContent').html('<p class="text-muted">Click the "Preview Bill" button in the Edit Bill tab to see the details here.</p>');
                    $('#edit-bill-tab-link').tab('show');
                    $('#editBillModal').modal('show');
                } else {
                    toastr.error(response.message || 'Failed to load bill details');
                }
            },
            error: function () {
                toastr.error('Error loading bill details');
            }
        });
    });
    // When bill type is changed in the edit modal, fetch and update invoice fields
    $(document).off('change.editBillType').on('change.editBillType', '#edit_bill_type', function () {
        // console.log("lkji")
        const selectedBillTypeId = $(this).val();
        if (!selectedBillTypeId) return;
        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: {
                action: 'get_bill_type',
                bill_type_id: selectedBillTypeId
            },
            dataType: 'json',
            success: function (response) {
                if (response.success && response.data) {
                    const d = response.data;
                    // Update deduction, tax, subtotal, total, notes, terms
                    $('#editDeductionPurpose').val(d.deduction_purpose || '');
                    $('#editDeductionPercentage').val(d.deduction_percentage || 0);
                    $('#editTaxPercentage').val(d.tax || 0);
                    $('#editNotes').val(d.notes || '');
                    $('#editTerms').val(d.terms || '');
                    $('#editSubtotal').val(d.subtotal || d.amount || 0);
                    $('#editTotalAmount').val(d.total || d.amount || 0);

                    // Update breakdown table
                    const $tbody = $('#editInvoiceBreakdownTable tbody');
                    $tbody.empty();
                    let billItems = [];
                    if (d.bill_items) {
                        try {
                            billItems = typeof d.bill_items === 'string' ? JSON.parse(d.bill_items) : d.bill_items;
                        } catch (e) { billItems = []; }
                    }
                    if (Array.isArray(billItems) && billItems.length > 0) {
                        billItems.forEach(function (item) {
                            let desc = Object.keys(item)[0];
                            let amt = item[desc];
                            $tbody.append(`
                            <tr class="edit-breakdown">
                                <td><input type="text" name="edit_breakdown_description[]" class="form-control" value="${escapeHtml(desc)}" required></td>
                                <td><input type="number" name="edit_breakdown_amount[]" class="form-control edit_breakdown-amount" step="0.01" min="0" value="${amt}" required></td>
                                <td><button type="button" class="btn btn-danger btn-sm remove-edit-breakdown-row" title="Remove"><i class="fas fa-trash"></i></button></td>
                            </tr>
                        `);
                        });
                    } else {
                        $tbody.append(`
                        <tr class="edit-breakdown">
                            <td><input type="text" name="edit_breakdown_description[]" class="form-control" placeholder="e.g. Tuition" required></td>
                            <td><input type="number" name="edit_breakdown_amount[]" class="form-control edit_breakdown-amount" step="0.01" min="0" required></td>
                            <td><button type="button" class="btn btn-danger btn-sm remove-edit-breakdown-row" title="Remove"><i class="fas fa-trash"></i></button></td>
                        </tr>
                    `);
                    }
                    // Recompute totals
                    updateInvoiceTotal({
                        rowClass: 'edit_breakdown',
                        subtotalId: '#editSubtotal',
                        discountId: '#editDeductionPercentage',
                        taxId: '#editTaxPercentage',
                        totalId: '#editTotalAmount'
                    });
                    updateEditPaymentFields();
                }
            }
        });
    });

    // Update balance and status fields in edit modal
    function updateEditPaymentFields() {
        const total = parseFloat($('#editTotalAmount').val()) || 0;
        const paid = parseFloat($('#editAmountPaid').val()) || 0;
        const balance = total - paid;
        $('#editBalance').val(balance.toFixed(2));
        let status = '';
        if (balance <= 0) {
            status = 'Paid';
        } else if (paid > 0) {
            status = 'Part Paid';
        } else {
            status = 'Not Paid';
        }
        $('#editStatus').val(status);
    }

    // Live update of balance/status when amount paid or total changes
    $(document).on('input', '#editAmountPaid, #editTotalAmount', function () {
        updateEditPaymentFields();
    });

    // Preview functionality for Edit Bill Modal
    function renderEditPreview() {
        // Gather Data
        const billTypeId = $('#edit_bill_type').val();
        const billTypeName = $('#edit_bill_type option:selected').text();
        const subtotal = $('#editSubtotal').val();
        const deductionPurpose = $('#editDeductionPurpose').val();
        const deductionPercentage = $('#editDeductionPercentage').val();
        const tax = $('#editTaxPercentage').val();
        const totalAmount = $('#editTotalAmount').val();
        const notes = $('#editNotes').val();
        const terms = $('#editTerms').val();
        const studentName = $('#edit_student_name').val();

        // Gather breakdown items
        let breakdownHtml = '';
        let hasBreakdown = false;
        $('#editInvoiceBreakdownTable tbody tr').each(function () {
            const desc = $(this).find('input[name="edit_breakdown_description[]"]').val();
            const amt = $(this).find('input[name="edit_breakdown_amount[]"]').val();
            if (desc && amt && !isNaN(parseFloat(amt))) {
                breakdownHtml += `<tr><td>${escapeHtml(desc)}</td><td>${parseFloat(amt).toLocaleString()}</td></tr>`;
                hasBreakdown = true;
            }
        });

        // Validation
        let errors = [];
        if (!billTypeId) errors.push('Bill type is required.');
        if (totalAmount === '' || isNaN(parseFloat(totalAmount)) || parseFloat(totalAmount) < 0) errors.push('Total amount is invalid.');
        if (tax === '' || isNaN(parseFloat(tax)) || parseFloat(tax) < 0) errors.push('Tax is invalid.');
        if (!studentName) errors.push('Student name is required.');
        if (!hasBreakdown) errors.push('At least one breakdown item is required.');
        if (errors.length > 0) {
            toastr.error(errors.join('<br>'));
            return false;
        }

        // Build branded preview card for Edit modal
        const logoUrl = ($('.brand-link img').first().attr('src')) ? $('.brand-link img').first().attr('src') : '';
        const schoolName = ($('.brand-text').first().text() || '').trim();
        const previewHtml = `
            <div class="card receipt-card">
                <div class="card-body p-3">
                    <div class="d-flex align-items-center mb-3">
                        <div class="mr-3">${logoUrl ? `<img src="${logoUrl}" alt="${escapeHtml(schoolName)}" style="height:56px;max-width:150px;object-fit:contain;" />` : `<h5 class="mb-0">${escapeHtml(schoolName)}</h5>`}</div>
                        <div class="flex-fill">
                            <h5 class="mb-0">${escapeHtml(billTypeName || 'Bill')}</h5>
                            <small class="text-muted">Edit Preview</small>
                        </div>
                        <div class="text-right">
                            <div><strong>${escapeHtml(studentName || '')}</strong></div>
                        </div>
                    </div>

                    <div class="table-responsive mb-2">
                        <table class="table table-sm table-striped mb-0">
                            <thead class="thead-light"><tr><th>Description</th><th class="text-right">Amount</th></tr></thead>
                            <tbody>${breakdownHtml}</tbody>
                        </table>
                    </div>

                    <div class="row mt-3">
                        <div class="col-md-6 small text-muted">Notes</div>
                        <div class="col-md-6 text-right small text-dark">${escapeHtml(notes || 'No notes')}</div>
                    </div>

                    <div class="row mt-2">
                        <div class="col-md-6 small text-muted">Terms</div>
                        <div class="col-md-6 text-right small text-dark">${escapeHtml(terms || '—')}</div>
                    </div>

                    <hr />
                    <div class="d-flex justify-content-end">
                        <div style="min-width:220px;">
                            <div class="d-flex justify-content-between"><small class="text-muted">Subtotal</small><strong>${money(subtotal)}</strong></div>
                            <div class="d-flex justify-content-between"><small class="text-muted">Deduction</small><strong>${escapeHtml(deductionPercentage || '0')}%</strong></div>
                            <div class="d-flex justify-content-between"><small class="text-muted">Tax</small><strong>${escapeHtml(tax || '0')}%</strong></div>
                            <hr class="my-2">
                            <div class="d-flex justify-content-between"><small class="text-muted">Total</small><strong>${money(totalAmount)}</strong></div>
                        </div>
                    </div>
                </div>
                <div class="card-footer bg-white text-right"><small class="text-muted">Preview — verify before saving changes</small></div>
            </div>
        `;
        $('#editPreviewBillContent').html(previewHtml);
        return true;
    }

    // If a legacy preview button exists, wire it to the new renderer
    $('#editPreviewBillButton').off('click.editPreview').on('click.editPreview', function () {
        const ok = renderEditPreview();
        if (ok) {
            // Let tab activation be handled by any existing wizard; if there isn't one, fall back to activating tab
            if ($('#edit-wizard-next').length === 0) {
                $('#edit-preview-bill-tab-link').tab('show');
            }
        }
    });

    // Setup Edit Bill wizard (stepper) to validate and route to preview
    (function setupEditWizard() {
        const $modal = $('#editBillModal');
        const $step1 = $('#edit-bill-tab');
        const $step2 = $('#edit-preview-bill-tab');
        const $btn1 = $('#edit-step-btn-1');
        const $btn2 = $('#edit-step-btn-2');
        const $next = $('#edit-wizard-next');
        const $back = $('#edit-wizard-back');
        const $save = $('#edit-save-changes');

        function showEditStep(step) {
            $btn1.removeClass('btn-primary').addClass('btn-secondary');
            $btn2.removeClass('btn-primary').addClass('btn-secondary');
            $step1.removeClass('show active');
            $step2.removeClass('show active');

            if (step === 1) {
                $btn1.removeClass('btn-secondary').addClass('btn-primary');
                $('#editBillTabs .nav-link').removeClass('active');
                $('#edit-bill-tab-link').addClass('active');
                $('#editBillTabsContent .tab-pane').removeClass('show active').css('display', 'none');
                $('#edit-bill-tab').addClass('show active').css('display', 'block');
                $back.hide(); $next.show(); $save.hide();
            } else if (step === 2) {
                // Generate preview and validate
                if (typeof renderEditPreview === 'function') {
                    const ok = renderEditPreview();
                    if (!ok) return; // validation failed, stay on step 1
                }
                $btn2.removeClass('btn-secondary').addClass('btn-primary');
                $('#editBillTabs .nav-link').removeClass('active');
                $('#edit-preview-bill-tab-link').addClass('active');
                $('#editBillTabsContent .tab-pane').removeClass('show active').css('display', 'none');
                $('#edit-preview-bill-tab').addClass('show active').css('display', 'block');
                $back.show(); $next.hide(); $save.show();
            }
        }

        $modal.on('shown.bs.modal', function () { showEditStep(1); });
        $btn1.on('click', function () { showEditStep(1); });
        $btn2.on('click', function () { showEditStep(2); });

        // Prevent direct tab clicks
        $('#edit-bill-tab-link, #edit-preview-bill-tab-link').on('click', function (e) {
            e.preventDefault();
            const id = $(this).attr('id');
            if (id === 'edit-bill-tab-link') showEditStep(1);
            else if (id === 'edit-preview-bill-tab-link') showEditStep(2);
        });

        $next.on('click', function () {
            // When Next pressed from step 1, attempt to go to preview (showEditStep will validate)
            if ($('#edit-bill-tab').hasClass('active') || $('#edit-bill-tab').hasClass('show')) {
                showEditStep(2);
            }
        });

        $back.on('click', function () {
            if ($('#edit-preview-bill-tab').hasClass('active') || $('#edit-preview-bill-tab').hasClass('show')) showEditStep(1);
        });
    })();

    // Function to load bill types in edit modal
    function loadBillTypesForEdit(selectedBillType) {
        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: {
                action: 'get_bill_types'
            },
            success: function (billTypes) {
                const $select = $('#edit_bill_type');
                $select.empty();

                billTypes.forEach(function (type) {
                    $select.append(new Option(type.bill_name, type.id,
                        false, type.id == selectedBillType));
                });

                // Initialize/refresh Select2
                if ($select.data('select2')) {
                    $select.select2('destroy');
                }
                $select.select2({
                    dropdownParent: $('#editBillModal')
                });
            }
        });
    }

    // Function to update status based on amounts
    function updateEditStatus(amountDue, amountPaid) {
        const balance = amountDue - amountPaid;
        $('#edit_balance').val(balance);

        let status = '';
        if (balance <= 0) {
            status = 'Paid';
        } else if (amountPaid > 0) {
            status = 'Part Paid';
        } else {
            status = 'Not Paid';
        }
        $('#edit_status').val(status);
    }

    // Event handlers for amount changes
    $('#edit_amount_due, #edit_amount_paid').on('input', function () {
        const amountDue = parseFloat($('#edit_amount_due').val()) || 0;
        const amountPaid = parseFloat($('#edit_amount_paid').val()) || 0;
        updateEditStatus(amountDue, amountPaid);
    });

    // --- Custom: Update Total Amount on Tax or Deduction Change (Assign Bill Modal) ---
    function updateAssignBillTotal() {
        // Get base amount (from billAmountModal, which is readonly and prefilled)
        let baseAmount = parseFloat($('#billAmountModal').val()) || 0;
        // Get tax percentage
        let tax = parseFloat($('#billTaxModal').val()) || 0;
        // Get deduction percentage
        let deduction = parseFloat($('#deduction_percent').val()) || 0;

        // Calculate deduction amount
        let deductionAmount = baseAmount * (deduction / 100);
        // Calculate tax amount (on the reduced amount)
        let taxableAmount = baseAmount - deductionAmount;
        let taxAmount = taxableAmount * (tax / 100);

        // Calculate total
        let total = taxableAmount + taxAmount;

        // Optionally, show the calculated total in a new field or update the amount field if editable
        // If you want to show the calculated total in billAmountModal (even if readonly):
        $('#totalAmount').html(total.toFixed(2));
    }

    // Listen for changes on tax and deduction fields in Assign Bill Modal
    $(document).on('input', '#billAmountModal, #billTaxModal, #deduction_percent', function () {
        updateAssignBillTotal();
    });

    // Optionally, call once on modal show to initialize
    $('#createAssignBillModal').on('shown.bs.modal', function () {
        updateAssignBillTotal();
    });

    // Handle form submission
    $('#editBillForm').on('submit', function (e) {
        e.preventDefault();

        // Gather all invoice fields
        const bill_id = $('#edit_bill_id').val();
        const bill_type = $('#edit_bill_type').val();
        const student_id = $('#edit_student_id').val();
        const amount_due = parseFloat($('#edit_amount_due').val()) || 0;
        // Use the correct selector for amount paid
        // const amount_paid = parseFloat($('#editAmountPaid').val()) || 0;
        // const balance = amount_due - amount_paid;
        // let status = 0;
        // if (balance <= 0) {
        //     status = 1; // Paid
        // } else if (amount_paid > 0) {
        //     status = 2; // Part Paid
        // }

        // Breakdown (array of {desc: amount})
        let breakdown = [];
        $('#editInvoiceBreakdownTable tbody tr').each(function () {
            const desc = $(this).find('input[name="edit_breakdown_description[]"]').val();
            const amt = parseFloat($(this).find('input[name="edit_breakdown_amount[]"]').val()) || 0;
            if (desc && !isNaN(amt)) {
                let obj = {};
                obj[desc] = amt;
                breakdown.push(obj);
            }
        });
        const bill_items = JSON.stringify(breakdown);

        // Other invoice fields
        const deduction_purpose = $('#editDeductionPurpose').val() || '';
        const deduction_percentage = parseFloat($('#editDeductionPercentage').val()) || 0;
        const tax = parseFloat($('#editTaxPercentage').val()) || 0;
        const notes = $('#editNotes').val() || '';
        const terms = $('#editTerms').val() || '';
        const subtotal = parseFloat($('#editSubtotal').val()) || 0;
        const total_amount = parseFloat($('#editTotalAmount').val()) || 0;

        // Compose data
        const data = {
            action: 'update_bill',
            bill_id,
            bill_type,
            student_id,
            // amount_paid,
            // balance,
            // status,
            bill_items,
            deduction_purpose,
            deduction_percentage,
            tax,
            notes,
            terms,
            subtotal,
            total_amount
        };

        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: data,
            dataType: 'json',
            success: function (response) {
                if (response.success) {
                    toastr.success('Bill updated successfully');
                    $('#editBillModal').modal('hide');
                    // Reload the DataTable and expected income section
                    if ($.fn.DataTable.isDataTable('#student_payment_recordTable')) {
                        $('#student_payment_recordTable').DataTable().ajax.reload();
                    }else{
                        data_student()
                    }
                    fetchAndDisplayEstimatedIncome();
                } else {
                    toastr.error(response.message || 'Failed to update bill');
                }
            },
            error: function () {
                toastr.error('Error updating bill');
            }
        });
    });

    // Handle Quick Assign button click
    $('#student_payment_recordTable').on('click', '.quick-assign-bill', function () {
        const studentId = $(this).data('student_id');
        const studentName = $(this).data('student_name');

        // Populate student info
        $('#quick_assign_student_id').val(studentId);
        $('#quick_assign_student_name').val(studentName);

        // Load bill types
        console.log(loadedBillTypesData)
        loadBillTypesForQuickAssign();

        // Show modal
        $('#quickAssignBillModal').modal('show');
    });

    // Function to load bill types for quick assign
    function loadBillTypesForQuickAssign() {
        // $.ajax({
        //     url: '../billing_controller.php',
        //     type: 'POST',
        //     data: {
        //         action: 'get_bill_types'
        //     },
        // success: function(billTypes) {
        const $select = $('#quick_assign_bill_type');
        $select.empty().append('<option value="" selected disabled>Select a Bill Type</option>');
        Object.entries(loadedBillTypesData).forEach(function ([billId, billData]) {
            // billId is the key (the ID), billData is the value ({bill_name, amount, tax})
            console.log(billData, billId)
            $select.append(new Option(billData.bill_name, billId));
        });
        // billTypes.forEach(function(type) {
        //     $select.append(new Option(type.bill_name, type.id));
        // });

        // Initialize/refresh Select2
        // if ($select.data('select2')) {
        //     $select.select2('destroy');
        //     console.log("quick")
        // }
        // $select.select2({
        //     dropdownParent: $('#quickAssignBillModal')
        // });
        //         }
        //     });
    }

    // Handle bill type selection in quick assign modal
    $('#quick_assign_bill_type').on('change', function () {
        const selectedTypeId = $(this).val();
        console.log('quick assign selected:', selectedTypeId); // For debugging
        console.log(loadedBillTypesData);
        populateBillTypeDetails(selectedTypeId, 'quick');

        // Fetch full bill type details (breakdown, notes, terms) and populate the quick assign form
        if (selectedTypeId) {
            $.ajax({
                url: '../billing_controller.php',
                type: 'POST',
                dataType: 'json',
                data: {
                    action: 'get_bill_type',
                    bill_type_id: selectedTypeId
                },
                success: function (res) {
                    if (!res || !res.success || !res.data) return;
                    const data = res.data;
                    // Populate notes and terms if present
                    if (data.notes !== undefined) $('#quick_assign_notes').val(data.notes);
                    if (data.terms !== undefined) $('#quick_assign_terms').val(data.terms);

                    // Populate breakdown table if bill_items exists
                    const $tbody = $('#quickAssignInvoiceBreakdownTable tbody');
                    $tbody.empty();
                    let items = [];
                    try {
                        items = data.bill_items ? JSON.parse(data.bill_items) : [];
                    } catch (e) {
                        items = [];
                    }
                    if (items.length > 0) {
                        let subtotal = 0;
                        items.forEach(function (item) {
                            let desc = '';
                            let amt = '';
                            if (typeof item === 'object' && !Array.isArray(item)) {
                                if ('description' in item && 'amount' in item) {
                                    desc = item.description;
                                    amt = item.amount;
                                } else {
                                    const keys = Object.keys(item);
                                    if (keys.length === 1) {
                                        desc = keys[0];
                                        amt = item[desc];
                                    }
                                }
                            }
                            subtotal += parseFloat(amt) || 0;
                            $tbody.append(`
                                <tr>
                                    <td><input type="text" name="quick_assign_breakdown_description[]" class="form-control quick-assign-breakdown-description" value="${escapeHtml(desc)}" required></td>
                                    <td><input type="number" name="quick_assign_breakdown_amount[]" class="form-control quick-assign-breakdown-amount" step="0.01" min="0" value="${amt}" required></td>
                                    <td><button type="button" class="btn btn-danger btn-sm remove-quick-assign-breakdown-row" title="Remove"><i class="fas fa-trash"></i></button></td>
                                </tr>
                            `);
                        });
                        $('#quick_assign_subtotal').val(subtotal);
                        // Use amount from data.amount if provided, else subtotal
                        const amount = data.amount !== undefined ? parseFloat(data.amount) : subtotal;
                        $('#quick_assign_total_amount').val(amount);
                        $('#quick_assign_tax').val(data.tax !== undefined ? data.tax : '');
                    } else {
                        // No breakdown items; fall back to using data.amount
                        $tbody.append(`
                            <tr>
                                <td><input type="text" name="quick_assign_breakdown_description[]" class="form-control quick-assign-breakdown-description" placeholder="e.g. Uniform Fee" required></td>
                                <td><input type="number" name="quick_assign_breakdown_amount[]" class="form-control quick-assign-breakdown-amount" step="0.01" min="0" required></td>
                                <td><button type="button" class="btn btn-danger btn-sm remove-quick-assign-breakdown-row" title="Remove"><i class="fas fa-trash"></i></button></td>
                            </tr>
                        `);
                        const amount = data.amount !== undefined ? parseFloat(data.amount) : '';
                        $('#quick_assign_subtotal').val(amount);
                        $('#quick_assign_total_amount').val(amount);
                        $('#quick_assign_tax').val(data.tax !== undefined ? data.tax : '');
                    }
                    updateInvoiceTotal({
                        rowClass: 'quick-assign-breakdown',
                        subtotalId: '#quick_assign_subtotal',
                        discountId: '#quick_assign_deduction_percentage',
                        taxId: '#quick_assign_tax',
                        totalId: '#quick_assign_total_amount'
                    });
                },
                error: function () {
                    // ignore failures silently for now
                }
            });
        }
    });

    // Add a new generic function to populate bill type details
    function populateBillTypeDetails(billTypeId, mode) {
        if (billTypeId && loadedBillTypesData[billTypeId]) {
            const billData = loadedBillTypesData[billTypeId];
            console.log(billData)
            if (mode === 'quick') {
                // For quick assign modal: populate subtotal and total amount
                $('#quick_assign_subtotal').val(billData.amount);
                $('#quick_assign_total_amount').val(billData.amount);
                $('#quick_assign_tax').val(billData.tax);
            } else {
                // For main assign modal
                $('#billAmountModal').val(billData.amount);
                $('#billTaxModal').val(billData.tax);
            }
        } else {
            console.log("no bill type")
            // Clear fields if no valid bill type selected
            if (mode === 'quick') {
                $('#quick_assign_subtotal').val('');
                $('#quick_assign_total_amount').val('');
                $('#quick_assign_tax').val('');
            } else {
                $('#billAmountModal').val('');
                $('#billTaxModal').val('');
            }
        }
    }

    // Handle quick assign form submission
    $('#quickAssignBillForm').on('submit', function (e) {
        e.preventDefault();

        // Gather all required fields
        const students = [];
        // If you allow multiple students, collect them here. Otherwise, just push the single student.
        const studentId = $('#quick_assign_student_id').val();
        if (studentId) students.push({ id: studentId });

        // Collect breakdown items
        const breakdownDescriptions = [];
        const breakdownAmounts = [];
        $('.quick-assign-breakdown-description').each(function () {
            breakdownDescriptions.push($(this).val());
        });
        $('.quick-assign-breakdown-amount').each(function () {
            breakdownAmounts.push($(this).val());
        });

        const formData = {
            action: 'quick_assign_bill',
            students: JSON.stringify(students),
            bill_type_id: $('#quick_assign_bill_type').val(),
            assign_subtotal: $('#quick_assign_subtotal').val(),
            assign_deduction_purpose: $('#quick_assign_deduction_purpose').val(),
            assign_deduction_percentage: $('#quick_assign_deduction_percentage').val(),
            assign_notes: $('#quick_assign_notes').val(),
            assign_terms: $('#quick_assign_terms').val(),
            assign_total_amount: $('#quick_assign_total_amount').val(),
            assign_tax: $('#quick_assign_tax').val(),
            term_id: $('.term_btn.select_btn.active').data('id'),
            session_id: $('#select_session_field').val(),
            class_id: $('#select_class_field').val(),
            assign_breakdown_description: breakdownDescriptions,
            assign_breakdown_amount: breakdownAmounts
        };

        $.ajax({
            url: '../billing_controller.php',
            type: 'POST',
            data: formData,
            success: function (response) {
                if (response.success) {
                    toastr.success('Bill assigned successfully');
                    $('#quickAssignBillModal').modal('hide');
                    // Reload the DataTable and expected income section
                    if ($.fn.DataTable.isDataTable('#student_payment_recordTable')) {
                        $('#student_payment_recordTable').DataTable().ajax.reload();
                    }else{
                        data_student()
                    }
                    fetchAndDisplayEstimatedIncome();
                } else {
                    toastr.error(response.message || 'Failed to assign bill');
                }
            },
            error: function () {
                toastr.error('Error assigning bill');
            }
        });
    });
});

function escapeHtml(unsafe) {
    if (typeof unsafe !== 'string') {
        return unsafe; // Return as is if not a string
    }
    return unsafe
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
}
// Preview Payment Invoice trigger (created by user at line ~472)
$(document).on('click', '.preview-invoice-btn', function (e) {
    e.preventDefault();
    const billId = $(this).data('bill_id') || $(this).attr('data-bill_id');
    if (!billId) {
        toastr.error('Missing bill id');
        return;
    }
    // Show modal and loading
    $('#invoicePreviewContent').html('<div class="text-center text-muted p-4"><i class="fas fa-spinner fa-spin"></i> Loading invoice...</div>');
    $('#invoicePreviewModal').modal('show');

    $.ajax({
        url: '../billing_controller.php',
        method: 'POST',
        dataType: 'json',
        data: { action: 'get_invoice', bill_id: billId },
        beforeSend: function () {
            console.log('Requesting invoice for bill id:', billId);
        },
        success: function (res) {
            console.log('Invoice response:', res);
            if (!res || !res.success) {
                $('#invoicePreviewContent').html('<div class="alert alert-danger">Failed to load invoice.</div>');
                return;
            }
            const d = res.data || {};
            // Build invoice HTML using pattern from quick preview
            const logoUrl = d.school_logo ? ('../uploads/' + d.school_logo) : '';
            const schoolName = d.school_name || '';
            const schoolPhone = d.school_phone || '';
            const schoolEmail = d.school_email || '';
            const schoolAddress = d.school_address || '';
            const student = d.student || {};
            const parent = d.parent || {};
            const bill = d.bill || {};
            const billType = d.bill_type || {};
            let items = [];
            try { items = bill.bill_items ? JSON.parse(bill.bill_items) : []; } catch (e) { items = []; }

            let rows = '';
            if (items.length > 0) {
                items.forEach(function (item) {
                    let desc = '', amt = 0;
                    if (typeof item === 'object' && !Array.isArray(item)) {
                        if ('description' in item && 'amount' in item) {
                            desc = item.description; amt = item.amount;
                        } else {
                            const keys = Object.keys(item);
                            if (keys.length === 1) { desc = keys[0]; amt = item[desc]; }
                        }
                    }
                    rows += `<tr><td>${escapeHtml(desc)}</td><td class="text-right">${money(amt)}</td></tr>`;
                });
            } else {
                rows = `<tr><td>${escapeHtml(billType.bill_name || 'Fee')}</td><td class="text-right">${money(bill.amount)}</td></tr>`;
            }

            const subtotal = bill.amount || 0;
            const deductionPercentage = bill.deduction_percentage || 0;
            const tax = bill.tax || 0;
            const total = bill.amount_due || 0;

            const invoiceHtml = `
                    <div class="card">
                        <div class="card-body p-3" id="printableInvoice">
                            <div class="d-flex align-items-center mb-3">
                                <div class="flex-fill">
                                <div class="mr-3">${logoUrl ? `<img src="${logoUrl}" style="height:56px;max-width:150px;object-fit:contain;"/>` : `<h5 class="mb-0">${escapeHtml(schoolName)}</h5>`}</div>
                                <div>
                                        <h5 class="mb-0">${escapeHtml(billType.bill_name || 'Invoice')}</h5>
                                        <div class="small text-muted mt-1">${escapeHtml(schoolAddress)}</div>
                                        <div class="small text-muted">${escapeHtml(schoolEmail)} ${schoolPhone ? ' • ' + escapeHtml(schoolPhone) : ''}</div>
                                        </div>
                                    </div>
                                    <div class="text-right">
                                        <div><strong>${escapeHtml(student.firstname || '')} ${escapeHtml(student.lastname || '')}</strong></div>
                                        <small class="text-muted">${escapeHtml(student.admission_no || '')}</small>
                                        <div class="small text-muted mt-1">${escapeHtml(parent.firstname || '')} ${escapeHtml(parent.lastname || '')}</div>
                                        <div class="small text-muted">${escapeHtml(parent.address || parent.p_address || '')}</div>
                                    </div>
                            </div>
                            <div class="table-responsive mb-2">
                                <table class="table table-sm table-striped mb-0">
                                    <thead class="thead-light"><tr><th>Description</th><th class="text-right">Amount</th></tr></thead>
                                    <tbody>${rows}</tbody>
                                </table>
                            </div>
                            <div class="row mt-3">
                                <div class="col-md-6 small text-muted">Notes</div>
                                <div class="col-md-6 text-right small text-dark">${escapeHtml(bill.notes || billType.notes || 'No notes')}</div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-md-6 small text-muted">Terms</div>
                                <div class="col-md-6 text-right small text-dark">${escapeHtml(bill.terms || billType.terms || '—')}</div>
                            </div>
                            <hr />
                            <div class="d-flex justify-content-end">
                                <div style="min-width:220px;">
                                    <div class="d-flex justify-content-between"><small class="text-muted">Subtotal</small><strong>${money(subtotal)}</strong></div>
                                    <div class="d-flex justify-content-between"><small class="text-muted">Deduction</small><strong>${escapeHtml(deductionPercentage || '0')}%</strong></div>
                                    <div class="d-flex justify-content-between"><small class="text-muted">Tax</small><strong>${escapeHtml(tax || '0')}%</strong></div>
                                    <hr class="my-2">
                                    <div class="d-flex justify-content-between"><small class="text-muted">Total Due</small><strong>${money(total)}</strong></div>
                                </div>
                            </div>
                        </div>
                        <div class="card-footer bg-white text-right"><small class="text-muted">Bill ID: ${escapeHtml(String(bill.id || '').padStart(8,'0'))} • Date: ${escapeHtml(String(bill.datecreated || ''))}</small></div>
                    </div>
                `;

            $('#invoicePreviewContent').html(invoiceHtml);
        },
        error: function (xhr, status, err) {
            console.error('Invoice AJAX error', status, err, xhr && xhr.responseText);
            $('#invoicePreviewContent').html('<div class="alert alert-danger">Failed to load invoice (server error).</div>');
        },
        complete: function () {
            console.log('Invoice AJAX completed for bill id:', billId);
            // Safety: if content still shows spinner, replace with an error placeholder so modal never stays stuck
            const $content = $('#invoicePreviewContent');
            if ($content.length && $content.find('.fa-spinner').length) {
                $content.html('<div class="alert alert-warning text-center">No content received. Check console/network for details.</div>');
            }
        }
    });
});

function payment_breakdown_modal() {
    // Show modal and loading state
    $('#payment-breakdown-content').html('<div class="text-center py-4"><div class="spinner-border" role="status" aria-hidden="true"></div><div class="mt-2">Loading payment details&hellip;</div></div>');
    $('#payment_breakdown_modal').modal('show');

    // gather selection
    let student_id = $('#select_student_field').val();
    let term_id = $('.term.select_btn.active').attr('data-name') || '';
    let session_id = $('#select_session_field').val() || '';
    let class_id = $('#select_class_field').val() || '';

    if (!student_id || !term_id || !session_id) {
        $('#payment-breakdown-content').html('<p class="text-danger">Please select student, term and session.</p>');
        return;
    }

    function escapeHtml(str) {
        if (str === null || str === undefined) return '';
        return String(str).replace(/&/g, '&amp;').replace(/"/g, '&quot;').replace(/'/g, '&#39;').replace(/</g, '&lt;').replace(/>/g, '&gt;');
    }

    $.ajax({
        url: '../billing_controller.php',
        type: 'POST',
        dataType: 'json',
        data: {
            action: 'get_payment_breakdown',
            student_id: student_id,
            term_id: term_id,
            session_id: session_id,
            class_id: class_id
        },
        success: function (resp) {
            if (!resp || !resp.success) {
                $('#payment-breakdown-content').html('<p class="text-danger">Failed to load payment breakdown.</p>');
                return;
            }

            const data = resp.data || [];
            if (data.length === 0) {
                $('#payment-breakdown-content').html('<p>No payments or bills found for the selected filters.</p>');
                return;
            }

            // Group by bill_id to create a timeline per bill
            const grouped = {};
            data.forEach(item => {
                const bid = item.bill_id || 'no-bill';
                if (!grouped[bid]) grouped[bid] = { bill_name: item.bill_name || ('Bill ' + bid), entries: [] };
                grouped[bid].entries.push(item);
            });

            let html = '';
            Object.keys(grouped).forEach(bid => {
                const group = grouped[bid];
                html += `<div class="mb-4 p-3 border rounded">`;
                html += `<div class="d-flex justify-content-between flex-wrap align-items-start mb-2">`;
                html += `<div><strong>${escapeHtml(group.bill_name)}</strong></div>
                <a href="#" class="preview-invoice-btn d-block float-right" data-toggle="modal" aria-expanded="false" data-bill_id="${bid}" aria-controls="">View Payment Invoice</a>`;
                html += `</div>`;

                // timeline list
                html += '<ul class="list-unstyled mb-0">';
                // entries are expected ordered by date desc from server; normalize to desc
                group.entries.sort((a, b) => (b.date_paid || '') > (a.date_paid || '') ? 1 : -1);
                group.entries.forEach(entry => {
                    const date = entry.date_paid || entry.datecreated || '';
                    // Show the payment amount if present, otherwise show the assigned amount_due
                    const amount = Number(entry.amount_newly_paid || entry.amount_due || 0);
                    const total_paid = Number(entry.total_amount_paid || 0);
                    const balance = Number(entry.balance || 0);
                    const method = entry.payment_method || '';
                    const desc = entry.description || '';

                    // Only show receipt preview if there is a real payment log entry (id > 0)
                    let receiptLink = '';
                    if (entry.id && Number(entry.id) > 0) {
                        receiptLink = `<a href="#paymentReceiptPreviewModal" class="float-right accent" data-toggle="modal" aria-expanded="false" data-bill_id="${entry.bill_id}" data-paymentid="${entry.id}" aria-controls="paymentReceiptPreviewModal">Preview Payment Receipt</a>`;
                    }

                    html += `<li class="mb-2">`;
                    html += `<div class="p-2 border rounded">`;
                    html += `<div class="d-flex justify-content-between flex-wrap">`;
                    html += `<div>`;
                    html += `<div><strong>₦${amount.toLocaleString()}</strong></div>`;
                    html += `<div class="small text-muted">${escapeHtml(desc)}${method ? ' — ' + escapeHtml(method) : ''}</div>`;
                    html += `</div>`;
                    html += `<div class="text-left text-sm-right small text-muted">${escapeHtml(date)}<div>Balance: ₦${balance.toLocaleString()}</div>
                    <div>Paid to date: ₦${total_paid.toLocaleString()}</div>
                    ${receiptLink}
                    </div>`;
                    html += `</div>`;
                    html += `</div>`;
                    html += `</li>`;
                });
                html += '</ul>';
                html += `</div>`;
            });

            $('#payment-breakdown-content').html(html);
        },
        error: function (xhr, status, err) {
            console.error(err);
            $('#payment-breakdown-content').html('<p class="text-danger">Error fetching payment breakdown.</p>');
        }
    });
}

 // Print handler for invoice modal
    $(document).on('click', '#printInvoiceButton', function () {
        const el = document.getElementById('printableInvoice');
        if (!el) return;
        const w = window.open('', '', 'height=700,width=900');
        w.document.write('<html><head><title>Print Invoice</title>');
        w.document.write('<link rel="stylesheet" href="../dist/css/adminlte.css">');
        w.document.write('</head><body>');
        w.document.write(el.outerHTML);
        w.document.write('</body></html>');
        w.document.close();
        w.focus();
        setTimeout(function () { w.print(); w.close(); }, 500);
    });
    $(document).on('click', '#downloadInvoiceButton', function () {
        const element = document.getElementById('printableInvoice');
        if (!element) return;
        html2pdf().from(element).set({ margin: 0.5, filename: 'invoice.pdf', html2canvas: { scale: 2 }, jsPDF: { unit: 'in', format: 'a4' } }).save();
    });

    // Share invoice handler: Web Share API with upload + email fallback
    $(document).on('click', '#shareInvoiceButton', function () {
        const element = document.getElementById('printableInvoice');
        if (!element) return toastr.error('No invoice to share.');
        // Show loading
        const $btn = $(this);
        $btn.prop('disabled', true).html('<i class="fas fa-spinner fa-spin"></i> Sharing...');
        html2pdf().from(element).outputPdf('blob').then(function (pdfBlob) {
            const file = new File([pdfBlob], 'invoice.pdf', { type: 'application/pdf' });
            if (navigator.canShare && navigator.canShare({ files: [file] })) {
                navigator.share({ files: [file], title: 'Payment Invoice', text: 'Here is your payment invoice.' }).then(function () {
                    $btn.prop('disabled', false).html('<i class="fas fa-share-alt"></i> Share');
                    toastr.success('Shared successfully!');
                }).catch(function (err) {
                    $btn.prop('disabled', false).html('<i class="fas fa-share-alt"></i> Share');
                    if (err && err.name !== 'AbortError') fallbackShare();
                });
            } else {
                fallbackShare();
            }

            function fallbackShare() {
                var formData = new FormData();
                formData.append('action', 'upload_invoice_pdf');
                formData.append('file', pdfBlob, 'invoice.pdf');
                $.ajax({
                    url: '../billing_controller.php',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    dataType: 'json',
                    success: function (res) {
                        $btn.prop('disabled', false).html('<i class="fas fa-share-alt"></i> Share');
                        let shareHtml = '<div class="text-center mb-2">Share this invoice:</div>' +
                            '<div class="d-flex justify-content-center">' +
                            (res.success && res.url ? '<a href="https://wa.me/?text=' + encodeURIComponent('Here is your payment invoice: ' + res.url) + '" target="_blank" class="btn btn-success mr-2"><i class="fab fa-whatsapp"></i> WhatsApp</a>' : '') +
                            '<button class="btn btn-primary" id="emailShareBtn"><i class="fas fa-envelope"></i> Email</button>' +
                            '</div>';
                        let $modal = $('#shareInvoiceModal');
                        if ($modal.length === 0) {
                            $('body').append('<div class="modal fade" id="shareInvoiceModal" tabindex="-1" role="dialog"><div class="modal-dialog modal-dialog-centered" role="document"><div class="modal-content"><div class="modal-header"><h5 class="modal-title">Share Invoice</h5><button type="button" class="close" data-dismiss="modal"><span>&times;</span></button></div><div class="modal-body" id="shareInvoiceModalBody"></div></div></div></div>');
                            $modal = $('#shareInvoiceModal');
                        }
                        $('#shareInvoiceModalBody').html(shareHtml);
                        $modal.modal('show');

                        $modal.off('click', '#emailShareBtn').on('click', '#emailShareBtn', function () {
                            let email = prompt('Enter recipient email:');
                            if (!email) return;
                            const reader = new FileReader();
                            reader.onload = function (e) {
                                const base64data = e.target.result.split(',')[1];
                                $.ajax({
                                    url: '../billing_controller.php',
                                    type: 'POST',
                                    data: JSON.stringify({ action: 'email_receipt_pdf_data', email: email, pdf_base64: base64data }),
                                    contentType: 'application/json',
                                    dataType: 'json',
                                    success: function (resp) {
                                        if (resp.success) toastr.success('Invoice sent via email!'); else toastr.error(resp.message || 'Failed to send email.');
                                    },
                                    error: function () { toastr.error('Failed to send email.'); }
                                });
                            };
                            reader.readAsDataURL(pdfBlob);
                        });
                    },
                    error: function () {
                        $btn.prop('disabled', false).html('<i class="fas fa-share-alt"></i> Share');
                        toastr.error('Failed to upload invoice for sharing.');
                    }
                });
            }
        });
    });