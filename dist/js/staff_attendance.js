// Initialize DataTable for staff attendance report matrix

// Global variables
let scanner = null;
let isFlashOn = false;
let currentCamera = null;
let activeCamera = null;

// Move initializeScanner to global scope
async function initializeScanner() {
    try {
        // if (!isHttps()) {
        //     showError('Camera access requires HTTPS. Please access this page using HTTPS or via localhost.');
        //     return;
        // }

        // Only create new scanner if it doesn't exist
        if (!scanner) {
            scanner = new Instascan.Scanner({
                video: document.getElementById('preview'),
                mirror: false,
                backgroundScan: true,
                continuous: true,
                refractoryPeriod: 1000,
                scanPeriod: 1
            });

            // Handle successful scans
            let lastScan = 0;
            scanner.addListener('scan', async function (decodedText) {
                // Debounce multiple rapid scans
                const now = Date.now();
                if (now - lastScan < 2000) return;
                lastScan = now;

                try {
                    let data;
                    try {
                        data = JSON.parse(decodedText);
                        console.log("Decoded data:", data);
                    } catch (e) {
                        navigator.vibrate && navigator.vibrate(100);
                        showError('Invalid QR code format');
                        return;
                    }

                    // Validate required fields
                    if (!data.staff_id || !data.firstname || !data.lastname) {
                        navigator.vibrate && navigator.vibrate(100);
                        showError('Invalid student QR code format');
                        return;
                    }

                    // Success feedback
                    navigator.vibrate && navigator.vibrate([100, 50, 100]);

                    // Store current camera reference
                    currentCamera = activeCamera;

                    // Stop scanning
                    if (scanner) {
                        await scanner.stop();
                    }

                    // Show success UI with properly escaped data
                    const studentData = encodeURIComponent(JSON.stringify(data));
                    showSuccess(`
                                <div class="card mb-0">
                                    <div class="card-body p-2">
                                        <div class="d-flex align-items-center mb-3">
                                            <div><img src="../uploads/${data.photo || 'avatar.png'}" width="50" 
                                                class="img-fluid rounded-circle" alt="Student Photo">
                                            </div>
                                            <div class="ml-2">
                                                <p class="mb-0 font-weight-bold">${data.firstname} ${data.lastname}</p>
                                                <div class="d-flex">
                                                    <button class="btn btn-success mr-2" id='mark_attendance_qr_btn' onclick="confirmAttendance('${studentData}')">
                                                        Mark Attendance
                                                    </button>
                                                    <button class="btn btn-danger" id='cancel_attendance_qr_btn'>
                                                        Cancel
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                            `);
                } catch (error) {
                    console.error('QR code processing error:', error);
                    showError(`Error: ${error.message}`);
                }
            });
        }

        // Get cameras
        const cameras = await Instascan.Camera.getCameras();

        if (cameras.length === 0) {
            showError('No cameras found on your device.');
            return;
        }

        // Only populate camera selector if it's empty
        const cameraSelectorElement = document.getElementById('cameraSelector');
        if (cameraSelectorElement.options.length <= 1) {
            cameraSelectorElement.innerHTML = '';
            cameras.forEach((camera, index) => {
                const option = document.createElement('option');
                option.value = index;
                option.text = `Camera ${index + 1}${camera.name ? ` (${camera.name})` : ''}`;
                cameraSelectorElement.appendChild(option);
            });
        }

        // Use stored camera if available, otherwise find the best camera
        let selectedCamera = currentCamera;
        if (!selectedCamera) {
            const backCamera = cameras.find(camera =>
                camera.name && (camera.name.toLowerCase().includes('back') ||
                    camera.name.toLowerCase().includes('rear')));

            selectedCamera = backCamera || cameras[0];
            if (backCamera) {
                cameraSelectorElement.value = cameras.indexOf(backCamera);
            }
        }

        // Start scanning with selected camera
        if (selectedCamera) {
            await scanner.start(selectedCamera);
            activeCamera = selectedCamera; // Update active camera reference
            currentCamera = selectedCamera; // Update stored camera reference

            // Check if flash is available
            const track = scanner.stream.getVideoTracks()[0];
            const capabilities = track.getCapabilities();
            if (capabilities.torch) {
                $('#flashButton').removeClass('d-none');
            }

            showInfo('Scanner ready. Please show a QR code.');
        } else {
            showError('Failed to start camera. Please try again.');
        }

    } catch (error) {
        console.error('Scanner initialization error:', error);
        // showError(`Error initializing scanner: ${error.message}`);
        // Reset scanner state on error
        scanner = null;
        currentCamera = null;
        activeCamera = null;
    }
}


$(document).on('click', '#cancel_attendance_qr_btn', function () {
    $("#qr-result").html('');
});


// Only start/stop scanner when modal is shown/hidden
let scannerInitialized = false;
$('#qrScannerModal').on('shown.bs.modal', function () {
    initializeScanner();
});
$('#qrScannerModal').on('hidden.bs.modal', async function () {
    if (scanner && scanner.stop) {
        await scanner.stop();
    }
    scanner = null;
    currentCamera = null;
    activeCamera = null;
    $("#qr-result").html('');
});

function save_to_School() {
    // alert("Saving lateness time to school table...");
    // write an ajax function to save the lateness time to school table
    $.ajax({
        url: '../record_staff_attendance.php',
        type: 'POST',
        data: {
            action: 'save_lateness_time',
            lateness_time: $('#lateness_time').val()
        },
        success: function (response) {
            // Handle success response
            console.log('Lateness time saved successfully:', response);
        },
        error: function (xhr, status, error) {
            // Handle error response
            console.error('Error saving lateness time:', error);
        }
    });
}

// Reload table when attendance_date or lateness_time changes
$('#attendance_date, #lateness_time').on('change', function () {
    attendanceTable.ajax.reload();
});
var attendanceTable = $('#att_log_scan').DataTable({
    processing: true,
    serverSide: true,
    responsive: true,
    scrollX: true,
    scrollY: '60vh',
    // paging: false,
    pageLength: 1000, // Show up to 1000 staff, adjust as needed
    ordering: true,
    order: [
        [0, 'asc']
    ],
    fixedColumns: {
        left: 1,
        right: 0
    },
    autoWidth: true,

    ajax: {
        url: '../record_staff_attendance.php',
        type: 'POST',
        data: function (d) {
            d.action = 'get_staff_attendance';
            d.attendance_date = $('#attendance_date').val();
            d.lateness_time = $('#lateness_time').val();
        }

    },
    columns: [{
        data: 'staff',
        render: function (data, type, row) {
            return data || '-';
        }
    },
    {
        data: 'date',
        render: function (data) {
            return data || '-';
        }
    },
    {
        data: 'check_in',
        render: function (data) {
            return data || '–';
        }
    },
    {
        data: 'check_out',
        render: function (data) {
            return data || '–';
        }
    },
    {
        data: null,
        render: function (data, type, row) {
            // Always use the current lateness time from the input
            let latenessTime = $('#lateness_time').val() || '08:00';
            let status = 'Absent';
            let isLate = false;
            let hasCheckIn = !!row.check_in;
            let hasCheckOut = !!row.check_out;
            if (hasCheckIn) {
                if (row.check_in > latenessTime) {
                    status = 'Late';
                    isLate = true;
                } else {
                    status = 'Present';
                }
                if (hasCheckIn && hasCheckOut) {
                    // If checked in and out, but was late, show both badges
                    if (isLate) {
                        return `<span class="badge badge-warning">Late</span> <span class="badge badge-success">Present</span>`;
                    } else {
                        status = 'Present';
                    }
                }
            }
            let badgeClass = 'badge-secondary';
            if (status === 'Present') badgeClass = 'badge-success';
            else if (status === 'Absent') badgeClass = 'badge-danger';
            else if (status === 'Late') badgeClass = 'badge-warning';
            return `<span class="badge ${badgeClass}">${status}</span>`;
        }
    },
    {
        data: 'mode',
        render: function (data) {
            return data || '-';
        }
    },
    {
        data: null,
        orderable: false,
        render: function (data, type, row) {
            if (!row.check_in) {
                return `<button class="btn btn-sm btn-success manual-mark-btn" 
                            data-staff-id="${row.staff_id}" 
                            data-staff-name="${row.staff}" 
                            data-date="${row.date}" 
                            data-check-in="${row.check_in || ''}" 
                            data-check-out="${row.check_out || ''}">
                            ➕ Mark</button>`;
            } else {
                return `<button class="btn btn-sm btn-primary manual-mark-btn" 
                            data-staff-id="${row.staff_id}" 
                            data-staff-name="${row.staff}" 
                            data-date="${row.date}" 
                            data-check-in="${row.check_in || ''}" 
                            data-check-out="${row.check_out || ''}">
                            ✏️ Edit</button>`;
            }
        }
    }
    ],
    order: [
        [1, 'desc']
    ],
    dom: '<"d-flex justify-content-between align-items-center mb-3"<"d-flex align-items-center"f>>rtip',
    language: {
        search: "",
        searchPlaceholder: "Search records...",
        processing: '<div class="spinner-border text-primary" role="status"><span class="sr-only">Loading...</span></div>'
    }
});


// Modal open logic
$(document).on('click', '.manual-mark-btn', function () {
    var staffId = $(this).data('staff-id');
    var staffName = $(this).data('staff-name');
    var date = $(this).data('date') || new Date().toISOString().slice(0, 10);
    var checkIn = $(this).data('check-in');
    var checkOut = $(this).data('check-out');
    var now = new Date();
    var nowTime = now.toTimeString().slice(0, 5);

    // Prefill logic
    $('#modal_staff_id').val(staffId);
    $('#modal_staff_name').val(staffName);
    $('#modal_date').val(date);
    $('#modal_check_in').val(checkIn || '');
    $('#modal_check_out').val(checkOut || (checkIn ? nowTime : ''));

    // Status auto-detect
    let status = 'Absent';
    if (checkIn) {
        if (checkIn <= '08:00') status = 'Present';
        else status = 'Late';
        if (checkIn && (checkOut || '')) status = 'Present';
    }
    $('#modal_status').val(status);

    $('#manualAttendanceModal').modal('show');
});

// Modal form submit
$('#manualAttendanceForm').on('submit', function (e) {
    e.preventDefault();
    var formData = {
        action: 'manual_staff_attendance',
        staff_id: $('#modal_staff_id').val(),
        date: $('#modal_date').val(),
        check_in: $('#modal_check_in').val(),
        check_out: $('#modal_check_out').val(),
        status: $('#modal_status').val(),
        mode: 0 // manual
    };
    var $btn = $('#manualAttendanceForm button[type="submit"]');
    $btn.prop('disabled', true).text('Saving...');
    $.ajax({
        url: '../record_staff_attendance.php',
        method: 'POST',
        data: formData,
        dataType: 'json',
        success: function (res) {
            if (res.status == 1) {
                toastr.success('Attendance saved');
                $('#manualAttendanceModal').modal('hide');
                attendanceTable.ajax.reload(null, false);
            } else {
                toastr.error(res.message || 'Error saving attendance');
            }
        },
        error: function (xhr) {
            toastr.error('Server error');
        },
        complete: function () {
            $btn.prop('disabled', false).text('Save');
        }
    });
});



function confirmAttendance(encodedData) {
    // Decode and parse the data
    const data = JSON.parse(decodeURIComponent(encodedData));

    // Get the button element
    const markAttendanceBtn = document.getElementById('mark_attendance_qr_btn');

    // If staff QR (has staff_id), send to record_staff_attendance.php
    if (data.staff_id) {
        $.ajax({
            url: '../record_staff_attendance.php',
            method: 'POST',
            dataType: 'json',
            data: {
                action: 'qr_staff_attendance',
                staff_id: data.staff_id,
                check_in: new Date().toTimeString().slice(0, 5) // Mark check-in time
            },
            beforeSend: function () {
                markAttendanceBtn.disabled = true;
                markAttendanceBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Processing...';
            },
            success: function (response) {
                if (response.status == '1') {
                    toastr.success('Staff attendance recorded successfully');
                    $("#qr-result").html('');
                    attendanceTable.ajax.reload(null, false);
                } else if (response.status == '2') {
                    showInfo(response.message);
                    markAttendanceBtn.disabled = false;
                    markAttendanceBtn.innerHTML = 'Mark Attendance';
                } else {
                    showError('Error recording staff attendance: ' + (response.message || 'Unknown error'));
                    markAttendanceBtn.disabled = false;
                    markAttendanceBtn.innerHTML = 'Mark Attendance';
                }
            },
            error: function (xhr, status, error) {
                showError('Error recording staff attendance: ' + error);
                markAttendanceBtn.disabled = false;
                markAttendanceBtn.innerHTML = 'Mark Attendance';
            }
        });
        return;
    }
}

// Send geolocation-based attendance to server
function sendGeoAttendance(lat, lng) {
    return $.ajax({
        url: '../record_staff_attendance.php',
        method: 'POST',
        dataType: 'json',
        data: {
            action: 'geo_staff_attendance',
            lat: lat,
            lng: lng
        }
    });
}

// --- Geolocation attendance handler ---
// Target coordinates (user-provided). Update here if needed.
const GEO_TARGET_LAT = maplat;
const GEO_TARGET_LNG = maplong;
const GEO_ACCEPT_RADIUS_M = mapradius; // meters
// alert(maplong)

function _toRad(deg){ return deg * Math.PI / 180; }
function _haversineDistance(lat1, lon1, lat2, lon2){
    const R = 6371000;
    const dLat = _toRad(lat2 - lat1);
    const dLon = _toRad(lon2 - lon1);
    const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
              Math.cos(_toRad(lat1)) * Math.cos(_toRad(lat2)) *
              Math.sin(dLon/2) * Math.sin(dLon/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    return R * c;
}
// alert('men')
// toastr.success('we are one')
function _showMsg(msg, type='info'){
    if (window.toastr && typeof toastr[type] === 'function') toastr[type](msg);
    else alert(msg);
}

// Attach handler: when '#takemyattendance' is clicked, check location then post
$(document).on('click', '#takemyattendance', function(e){
    e.preventDefault();
    if (!navigator.geolocation){
        _showMsg('Geolocation is not supported by your browser', 'error');
        return;
    }
    navigator.geolocation.getCurrentPosition(function(position){
        const lat = position.coords.latitude;
        const lng = position.coords.longitude;
        const dist = _haversineDistance(lat, lng, GEO_TARGET_LAT, GEO_TARGET_LNG);
        if (dist <= GEO_ACCEPT_RADIUS_M){
            _showMsg('You are within the allowed area. Recording attendance...', 'info');
            if (typeof sendGeoAttendance === 'function'){
                sendGeoAttendance(lat, lng).done(function(res){
                    if (res && res.status == 1){
                        _showMsg(res.message || 'Attendance recorded', 'success');
                        if (window.attendanceTable && typeof attendanceTable.ajax !== 'undefined') attendanceTable.ajax.reload(null, false);
                    } else if (res && res.status == 2){
                        _showMsg(res.message || 'Attendance already completed', 'info');
                        if (window.attendanceTable && typeof attendanceTable.ajax !== 'undefined') attendanceTable.ajax.reload(null, false);
                    } else {
                        _showMsg(res.message || 'Unable to record attendance', 'error');
                    }
                }).fail(function(){
                    _showMsg('Server error while recording attendance', 'error');
                });
            } else {
                _showMsg('Attendance function missing', 'error');
            }
        } else {
            _showMsg('Kindly stay within the allowed area to take attendance.');
            // alert('Your location: Lat ' + lat + '\nLng ' + lng + '\nDistance: ' + Math.round(dist) + ' m');
        }
    }, function(err){
        let msg = '';
        switch(err.code){
            case err.PERMISSION_DENIED: msg = 'Permission denied. Please allow location access.'; break;
            case err.POSITION_UNAVAILABLE: msg = 'Location unavailable.'; break;
            case err.TIMEOUT: msg = 'Location request timed out.'; break;
            default: msg = 'Error getting location.'; break;
        }
        _showMsg(msg, 'error');
    }, { enableHighAccuracy: true, timeout: 10000, maximumAge: 0 });
});

function showError(message) {
    const qrResult = document.getElementById('qr-result');
    qrResult.className = 'mt-3 alert alert-danger';
    qrResult.innerHTML = message;
}

function showSuccess(message) {
    const qrResult = document.getElementById('qr-result');
    qrResult.className = '';
    qrResult.innerHTML = message;
}

function showInfo(message) {
    const qrResult = document.getElementById('qr-result');
    qrResult.className = 'mt-3 alert alert-info';
    qrResult.innerHTML = message;
}

const trigger_change = (selected) => {
    let htmlselect = selected.value == 'custom' ? "block" : 'none';
    document.getElementById("daterange_custom_staff").style.display = htmlselect
}

// Helper to get date string in yyyy-mm-dd
function formatDate(date) {
    let d = new Date(date),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();
    if (month.length < 2) month = '0' + month;
    if (day.length < 2) day = '0' + day;
    return [year, month, day].join('-');
}
// Set period selector logic
// alert("ll")
function setRangeByPeriod(period) {
    const today = new Date();
    let start, end;
    switch (period) {
        case 'today':
            start = end = formatDate(today);
            break;
        case 'yesterday':
            let yest = new Date(today);
            yest.setDate(today.getDate() - 1);
            start = end = formatDate(yest);
            break;
        case 'last 7 days':
            end = formatDate(today);
            let s7 = new Date(today);
            s7.setDate(today.getDate() - 6);
            start = formatDate(s7);
            break;
        case 'last 30 days':
            end = formatDate(today);
            let s30 = new Date(today);
            s30.setDate(today.getDate() - 29);
            start = formatDate(s30);
            break;
        case 'this month':
            start = formatDate(new Date(today.getFullYear(), today
                .getMonth(), 1));
            end = formatDate(today);
            break;
        case 'custom':
            // Don't set here
            return;
        default:
            // fallback to today
            start = end = formatDate(today);
    }
    $('#custom_start').val(start);
    $('#custom_end').val(end);
    loadAttendanceMatrix()
}
// alert("lk")
$('#period_selector').on('change', function () {
    const val = $(this).val();
    if (val === 'custom') {
        $('#daterange_custom_staff').show();
    } else {
        $('#daterange_custom_staff').hide();
        setRangeByPeriod(val);
        // Optionally auto-load matrix here
        // if ($('#custom_start').val() && $('#custom_end').val()) {
        //     $('#load_attendance_matrix_btn').click();
        // }
    }
});
// When custom date changes, optionally auto-load
// $('#custom_start, #custom_end').on('change', function () {
//     if ($('#period_selector').val() === 'custom' && $(
//         '#custom_start').val() && $('#custom_end').val()) {
//         $('#load_attendance_matrix_btn').click();
//     }
// });
// Set default to today
setRangeByPeriod('today');



// --- Date Range Attendance Matrix ---
function loadAttendanceMatrix() {
    const start = $('#custom_start').val();
    const end = $('#custom_end').val();
    if (!start || !end) {
        toastr.error('Please select both start and end dates');
        return;
    }
    // Destroy DataTable before updating contents to ensure fresh data
    if ($.fn.DataTable.isDataTable('#staff_att_report_table')) {
        $('#staff_att_report_table').DataTable().clear().destroy();
    }
    $('#staff_att_report_table thead').empty();
    $('#staff_att_report_table tbody').html('<tr><td colspan="100%">Loading...</td></tr>');
    $.ajax({
        url: '../record_staff_attendance.php',
        method: 'POST',
        dataType: 'json',
        data: {
            action: 'get_staff_attendance_range',
            start_date: start,
            end_date: end,
            lateness_time: $('#lateness_time').val() || '08:00'
        },
        success: function (res) {
            console.log(res)
            if (res.status !== 1) {
                $('#attendance_matrix_head').html('');
                $('#attendance_matrix_body').html('<tr><td colspan="100%">No data found</td></tr>');
                // Destroy previous DataTable instance if exists
                if ($.fn.DataTable.isDataTable('#staff_att_report_table')) {
                    $('#staff_att_report_table').DataTable().destroy();
                }
                return;
            }
            // Build table header
            let headHtml = '<tr><th>Staff</th>';
            res.dates.forEach(date => {
                const d = new Date(date);
                const day = d.getDate();
                const month = d.toLocaleString('default', { month: 'short' });
                const getOrdinal = n => {
                    if (n > 3 && n < 21) return 'th';
                    switch (n % 10) {
                        case 1: return 'st';
                        case 2: return 'nd';
                        case 3: return 'rd';
                        default: return 'th';
                    }
                };
                headHtml += `<th style="text-align: center;">${day}${getOrdinal(day)} ${month}</th>`;
            });
            headHtml += '<th style="text-align: center;">Present</th><th style="text-align: center;">Absent</th><th style="text-align: center;">Late</th>';
            headHtml += '</tr>';
            // Replace only the contents of thead/tbody
            $('#staff_att_report_table thead').html(headHtml);
            let bodyHtml = '';
            res.data.forEach(row => {
                bodyHtml += `<tr><td>${row.staff}</td>`;
                res.dates.forEach(date => {
                    bodyHtml += `<td style="text-align:center">${row[date] || '❌'}</td>`;
                });
                bodyHtml += `<td style="text-align:center">${row.presentCount}</td><td style="text-align:center">${row.absentCount}</td><td style="text-align:center">${row.lateCount}</td>`;
                bodyHtml += '</tr>';
            });
            $('#staff_att_report_table tbody').html(bodyHtml);
            // Re-initialize DataTable after updating content
            $('#staff_att_report_table').DataTable({
                scrollX: true,
                scrollY: '60vh',
                paging: false,
                ordering: true,
                order: [[0, 'asc']],
                fixedColumns: {
                    left: 1,
                    right: 0
                },
                autoWidth: true,
                dom: '<"d-flex justify-content-between align-items-center mb-3"<"d-flex align-items-center"f>>rtip',
                language: {
                    search: "",
                    searchPlaceholder: "Search staff...",
                    processing: '<div class="spinner-border text-primary" role="status"><span class="sr-only">Loading...</span></div>'
                }
            });
        },
        error: function () {
            $('#attendance_matrix_head').html('');
            $('#attendance_matrix_body').html('<tr><td colspan="100%">Error loading data</td></tr>');
            // Destroy previous DataTable instance if exists
            if ($.fn.DataTable.isDataTable('#staff_att_report_table')) {
                $('#staff_att_report_table').DataTable().destroy();
            }
        }
    });
}

// Load matrix when button is clicked
// $(document).on('click', '#load_attendance_matrix_btn', function () {
//     loadAttendanceMatrix();
// });
// Count late as present if using only '✔️' and '❌', but if you want to count late separately, you need to distinguish it in backend
// For now, count present as '✔️', absent as '❌', late as '🟡' (if you use that symbol)
// bodyHtml += `<td style="text-align:center">${presentCount}</td><td style="text-align:center">${absentCount}</td><td style="text-align:center">${lateCount}</td>`;
// Load matrix when period changes (except custom)
// $('#period_selector').on('change', function () {
//     const val = $(this).val();
//     if (val !== 'custom') {
//         setTimeout(loadAttendanceMatrix, 100); // Wait for date fields to update
//     }
// });
// Load matrix when custom date changes
$('#custom_start, #custom_end').on('change', function () {
    console.log("wxjiij");
    if ($('#period_selector').val() === 'custom' && $('#custom_start').val() && $('#custom_end').val()) {
        loadAttendanceMatrix();
    }
});

// $('#staff_att_report_table').DataTable({
//     scrollX: true,
//     scrollY: '60vh',
//     paging: false,
//     ordering: true,
//     order: [
//         [0, 'asc']
//     ],
//     fixedColumns: {
//         left: 1,
//         right: 0
//     },
//     autoWidth: true,
//     dom: '<"d-flex justify-content-between align-items-center mb-3"<"d-flex align-items-center"l><"d-flex align-items-center"f>>rtip',
//     language: {
//         search: "",
//         searchPlaceholder: "Search staff...",
//         lengthMenu: "_MENU_ per page",
//         processing: '<div class="spinner-border text-primary" role="status"><span class="sr-only">Loading...</span></div>'
//     }
// });