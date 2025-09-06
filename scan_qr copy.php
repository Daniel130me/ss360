<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
// exit;
include_once("model/connect.php");
include_once("model/functions.php");
$school_id = $_SESSION['school_id'];
// $parent_id = $_SESSION['userid'];
$student_id = $_GET['id'];
$date = date("Y-m-d");
$school_settings = json_decode($_SESSION['skul_settings'], true);
$first_term = $school_settings['first'];
$second_term = $school_settings['second'];
$third_term = $school_settings['third'];
// $first_term_class = ($date >= $school_settings['first'] && $date <= $school_settings['second']) ? "active" : '';
// $second_term_class = ($date >= $school_settings['second'] && $date < $school_settings['third']) ? "active" : '';
// $third_term_class = $date >= $school_settings['third'] ? "active" : '';
// elseif($date >= $school_settings['second'] && $date <= $school_settings['third'] ) {
//     echo "second";
// }elseif($date >= $school_settings['third']) {
//     echo "third";
// }
// exit;
$data = [];
// echo $_GET['id'];
// exit;
$select = mysqli_query($conn, "SELECT s.*,c.classname,
p.firstname as p_firstname,p.lastname as p_lastname,
p.phone as p_phone,p.email as p_email,p.city,p.state,
p.address as p_address,p.country FROM students s, class c, 
parent p WHERE p.id=s.parent_id AND s.class_id=c.id AND 
s.school_id='$school_id' AND 
s.id='{$_GET['id']}'");

while ($row = mysqli_fetch_array($select)) {
    $data[] = array(
        'photo' => $row['photo'],
        'id' => $row['id'],
        'classname' => $row['classname'],
        'firstname' => $row['firstname'],
        'lastname' => $row['lastname'],
        'middlename' => $row['middlename'] == '' ? '' : $row['middlename'],
        'class_id' => $row['class_id'],
        'dob' => $row['dob'],
        'gender' => $row['gender'] == '' ? 'Nil' : $row['gender'],
        'phone' => $row['phone'] == '' ? 'Nil' : $row['phone'],
        'email' => $row['email'] == '' ? 'Nil' : $row['email'],
        'datecreated' => $row['datecreated'],
        'parent_id' => $row['parent_id'],
        'p_firstname' => $row['p_firstname'] == '' ? 'Nil' : $row['p_firstname'],
        'p_lastname' => $row['p_lastname'] == '' ? 'Nil' : $row['p_lastname'],
        'p_phone' => $row['p_phone'],
        'p_email' => $row['p_email'],
        'p_address' => $row['p_address'] == '' ? 'Nil' : $row['p_address'],
    );
}
// print_r($data);
// print_r($row);
// exit;
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= $data[0]['lastname'] . ' ' . $data[0]['firstname'] ?></title>

    <!-- Google Font: Source Sans Pro -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.4/css/jquery.dataTables.min.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/fixedcolumns/4.2.2/css/fixedColumns.dataTables.min.css">
    <!-- Select2 -->
    <style>
        #preview {
            height: 80vh;
            width: 100%;
            object-fit: cover;
            transform: translateZ(0);
            backface-visibility: hidden;
            will-change: transform; /* Optimize GPU acceleration */
        }

        .scanning-overlay {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 90%; /* Increased from 280px */
            height: 90%; /* Increased from 280px */
            border: 2px solid #00ff00;
            box-shadow: 0 0 0 100vmax rgba(0, 0, 0, 0.3); /* Reduced opacity for better visibility */
            pointer-events: none;
            z-index: 10;
        }

        .scanning-guides {
            position: absolute;
            width: 40px; /* Increased from 20px */
            height: 40px; /* Increased from 20px */
            border-color: #00ff00;
            border-style: solid;
            border-width: 0;
        }

        .guide-tl { top: 0; left: 0; border-top-width: 3px; border-left-width: 3px; }
        .guide-tr { top: 0; right: 0; border-top-width: 3px; border-right-width: 3px; }
        .guide-bl { bottom: 0; left: 0; border-bottom-width: 3px; border-left-width: 3px; }
        .guide-br { bottom: 0; right: 0; border-bottom-width: 3px; border-right-width: 3px; }

        .camera-selection {
            position: absolute;
            top: 10px;
            right: 10px;
            z-index: 1000;
        }

        .flash-button {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1000;
            padding: 10px 20px;
            border-radius: 20px;
            background: rgba(0,0,0,0.5);
            color: white;
            border: none;
        }

        /* Add loading animation */
        .scanning-animation {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 3px; /* Slightly thicker line */
            background: linear-gradient(to right, transparent, #00ff00, transparent);
            animation: scan 3s linear infinite;
            z-index: 11;
        }

        @keyframes scan {
            0% { transform: translateY(0); }
            50% { transform: translateY(100%); }
            100% { transform: translateY(0); }
        }
    </style>
</head>

<body class="hold-transition sidebar-mini">
    <div class="wrapper">

        <!-- Navbar -->
        <nav class="main-header navbar border-bottom-0 navbar-expand justify-content-between bg1 ml-0">
            <!-- <div class=""> -->
            <!-- <div> -->

            <!-- Left navbar links -->
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="fas fa-bars"></i></a>
                </li>
            </ul>

            <!-- Right navbar links -->
            <ul class="navbar-nav align-items-center">
                <li class="nav-item dropdown">
                    <a class="" data-toggle="dropdown" href="#" style="height: auto;">
                        <div class="user-panel d-flex align-items-center">
                            <span class="material-symbols-outlined">arrow_drop_down</span>
                            <div class="image pl-0">
                                <img src="../uploads/<?= $_SESSION['staff_photo'] ?>" class="img-circle elevation-2" alt="User Image">
                            </div>
                            <div class="info d-none d-sm-inline-block">
                                <p style="font-size: 14px;" class="mb-0 d-block">
                                    <?= $_SESSION['firstname'] . ' ' . $_SESSION['lastname'] ?></p>
                                <p style="font-size: 12px;" class="d-block mb-0 accent">
                                    <?= get_staff_type_in_name($_SESSION['staff_type']) ?>
                                </p>
                            </div>
                        </div>
                    </a>
                    <div class="dropdown-menu dropdown-menu-sm dropdown-menu-right p-2" style="border-radius: 10px;">
                        <a href="profile" class="dropdown-item text-muted d-flex">
                            <i class="material-symbols-outlined mr-2 d-inline">person</i> Profile
                        </a>
                        <a href="change_password" class="dropdown-item text-muted d-flex">
                            <span class="material-symbols-outlined mr-2">lock</span> Change PIN
                        </a>
                        <a href="logout" class="dropdown-item text-muted d-flex">
                            <span class="material-symbols-outlined mr-2">logout</span> Logout
                        </a>
                    </div>
                </li>
            </ul>
            <!-- </div> -->
            <!-- </div> -->

        </nav>
        <!-- /.navbar -->
        <div class="content-wrapper ml-0" style="background-color: #f4f7fa; padding-bottom: 100px;">
            <div class="container-fluid">
                <div class="row">
                    <div class="col-md-8 col-sm-12 mb-3">
                        <div class="card">
                            <div class="card-header">
                                <div class="d-flex justify-content-between align-items-center">
                                    <h5 class="mb-0">QR Code Scanner</h5>
                                    <div>
                                        <select id="cameraSelector" class="form-control form-control-sm d-inline-block mr-2" style="width: auto;">
                                            <option value="">Loading cameras...</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body" style="position: relative;">
                                <video id="preview" playsinline></video>
                                <div class="scanning-overlay">
                                    <div class="scanning-guides guide-tl"></div>
                                    <div class="scanning-guides guide-tr"></div>
                                    <div class="scanning-guides guide-bl"></div>
                                    <div class="scanning-guides guide-br"></div>
                                    <div class="scanning-animation"></div>
                                </div>
                                <button id="flashButton" class="flash-button d-none">
                                    <i class="fas fa-bolt"></i> Toggle Flash
                                </button>
                                <div id="qr-result" class="mt-3"></div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 col-sm-12">
                        <div class="table-responsive">
                            <table id="att_log_scan" class="display" style="width:100%">
                                <thead>
                                    <tr>
                                        <th>Name</th>
                                        <th>Time</th>
                                        <th>Date</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>John Doe</td>
                                        <td>10:00 AM</td>
                                        <td>2023-10-01</td>
                                        <td>Present</td>
                                    </tr>
                                    <tr>
                                        <td>Jane Smith</td>
                                        <td>10:15 AM</td>
                                        <td>2023-10-01</td>
                                        <td>Absent</td>
                                    </tr>
                                    <tr>
                                        <td>Michael Johnson</td>
                                        <td>10:30 AM</td>
                                        <td>2023-10-01</td>
                                        <td>Present</td>
                                    </tr>
                                    <tr>
                                        <td>Emily Davis</td>
                                        <td>10:45 AM</td>
                                        <td>2023-10-01</td>
                                        <td>Late</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="../plugins/jquery/jquery.min.js"></script>
    <!-- Bootstrap 4 -->
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../dist/js/adminlte.min.js"></script>
    <!-- <script src="https://code.jquery.com/jquery-3.5.1.js"></script> -->
    <script src="https://cdn.datatables.net/1.13.4/js/jquery.dataTables.min.js"></script>
    <script src="https://cdn.datatables.net/fixedcolumns/4.2.2/js/dataTables.fixedColumns.min.js"></script>
    <!-- Select2 -->
    <!-- Include Instascan library -->
    <script src="https://rawgit.com/schmich/instascan-builds/master/instascan.min.js"></script>
    <script>
        let scanner = null;
        let isFlashOn = false;
        let currentCamera = null;
        let activeCamera = null; // Add this to track the active camera

        $(document).ready(function() {
            $('#att_log_scan').DataTable({
                pageLength: 5,
                order: [[2, 'desc'], [1, 'desc']], // Sort by date then time
                responsive: true
            });

            // Function to check if HTTPS is being used
            function isHttps() {
                return window.location.protocol === 'https:' || window.location.hostname === 'localhost';
            }

            // Function to handle flash toggle
            async function toggleFlash() {
                try {
                    const track = scanner.stream.getVideoTracks()[0];
                    const capabilities = track.getCapabilities();
                    
                    if (capabilities.torch) {
                        isFlashOn = !isFlashOn;
                        await track.applyConstraints({
                            advanced: [{ torch: isFlashOn }]
                        });
                        $('#flashButton i').css('color', isFlashOn ? '#00ff00' : 'white');
                    }
                } catch (err) {
                    console.error('Flash error:', err);
                }
            }

            // Function to populate camera selector and start scanner
            async function initializeScanner() {
                try {
                    if (!isHttps()) {
                        showError('Camera access requires HTTPS. Please access this page using HTTPS or via localhost.');
                        return;
                    }

                    showInfo('Requesting camera permission...');

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
                        scanner.addListener('scan', async function(decodedText) {
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
                                if (!data.id || !data.firstname || !data.lastname || !data.class) {
                                    navigator.vibrate && navigator.vibrate(100);
                                    showError('Invalid student QR code format');
                                    return;
                                }

                                // Success feedback
                                navigator.vibrate && navigator.vibrate([100, 50, 100]);
                                
                                // Store current camera reference before stopping
                                currentCamera = activeCamera;
                                
                                // Stop scanning
                                if (scanner) {
                                    await scanner.stop();
                                }

                                // Show success UI
                                showSuccess(`
                                    <div class="card">
                                        <div class="card-body">
                                            <div class="d-flex mb-3">
                                                <img src="../uploads/${data.photo || 'avatar.png'}" width="50" 
                                                    class="img-fluid rounded-circle" alt="Student Photo">
                                                <div class="ml-2">
                                                    <p class="mb-0 font-weight-bold">${data.firstname} ${data.lastname}</p>
                                                    <p class="mb-0 text-muted">${data.class}</p>
                                                </div>
                                            </div>
                                            <div class="d-flex mt-2">
                                                <button class="btn btn-success mr-2" onclick="confirmAttendance('${JSON.stringify(data).replace(/'/g, "\\'")}')">
                                                    Mark Attendance
                                                </button>
                                                <button class="btn btn-danger" onclick="resumeScanning()">
                                                    Cancel
                                                </button>
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
                    showError(`Error initializing scanner: ${error.message}`);
                    // Reset scanner state on error
                    scanner = null;
                    currentCamera = null;
                    activeCamera = null;
                }
            }

            // Handle camera selection change
            document.getElementById('cameraSelector').addEventListener('change', async function(e) {
                try {
                    const cameras = await Instascan.Camera.getCameras();
                    const selectedCamera = cameras[parseInt(e.target.value)];
                    if (selectedCamera) {
                        if (scanner) {
                            await scanner.stop();
                        }
                        await scanner.start(selectedCamera);
                        activeCamera = selectedCamera;
                        currentCamera = selectedCamera;
                        
                        // Reset flash state
                        isFlashOn = false;
                        $('#flashButton i').css('color', 'white');
                        
                        // Check if new camera has flash
                        const track = scanner.stream.getVideoTracks()[0];
                        const capabilities = track.getCapabilities();
                        $('#flashButton').toggleClass('d-none', !capabilities.torch);
                    }
                } catch (error) {
                    console.error('Camera switch error:', error);
                    showError('Error switching camera');
                }
            });

            // Handle flash button click
            $('#flashButton').on('click', toggleFlash);

            // Initialize scanner when page loads
            initializeScanner();

            // Handle page visibility change
            document.addEventListener('visibilitychange', function() {
                if (document.hidden) {
                    scanner && scanner.stop();
                } else {
                    scanner && scanner.start();
                }
            });
        });

        async function resumeScanning() {
            try {
                if (scanner) {
                    // Try to use the stored camera reference
                    if (currentCamera) {
                        await scanner.start(currentCamera);
                        activeCamera = currentCamera;
                        showInfo('Scanner ready. Please show a QR code.');
                    } else {
                        // Fallback to reinitialize if no stored camera
                        const cameras = await Instascan.Camera.getCameras();
                        if (cameras.length > 0) {
                            const cameraIndex = parseInt(document.getElementById('cameraSelector').value);
                            const selectedCamera = cameras[cameraIndex] || cameras[0];
                            await scanner.start(selectedCamera);
                            activeCamera = selectedCamera;
                            currentCamera = selectedCamera;
                            showInfo('Scanner ready. Please show a QR code.');
                        } else {
                            showError('No cameras found. Please refresh the page.');
                        }
                    }
                } else {
                    // If scanner is null, reinitialize
                    await initializeScanner();
                }
            } catch (error) {
                console.error('Error resuming scanner:', error);
                // Try one more time to reinitialize
                try {
                    scanner = null;
                    currentCamera = null;
                    activeCamera = null;
                    await initializeScanner();
                } catch (retryError) {
                    showError('Could not restart scanner. Please refresh the page.');
                }
            }
        }

        function confirmAttendance(decodedData) {
            try {
                const data = JSON.parse(decodedData);

                $.ajax({
                    url: 'record_attendance.php',
                    method: 'POST',
                    data: {
                        student_data: data,
                        action: 'record_attendance'
                    },
                    success: function(response) {
                        try {
                            const result = JSON.parse(response);
                            if (result.status === 'success') {
                                showSuccess('Attendance recorded successfully!');
                                $('#att_log_scan').DataTable().ajax.reload();
                            } else {
                                showError('Failed to record attendance: ' + result.message);
                            }
                        } catch (e) {
                            showError('Invalid server response');
                        }
                    },
                    error: function(xhr, status, error) {
                        showError('Error recording attendance: ' + error);
                    },
                    complete: function() {
                        setTimeout(resumeScanning, 2000);
                    }
                });
            } catch (error) {
                console.error('Error processing attendance:', error);
                showError('Error processing attendance data');
                resumeScanning();
            }
        }

        function showError(message) {
            const qrResult = document.getElementById('qr-result');
            qrResult.className = 'mt-3 alert alert-danger';
            qrResult.innerHTML = message;
        }

        function showSuccess(message) {
            const qrResult = document.getElementById('qr-result');
            qrResult.className = 'mt-3 alert alert-success';
            qrResult.innerHTML = message;
        }

        function showInfo(message) {
            const qrResult = document.getElementById('qr-result');
            qrResult.className = 'mt-3 alert alert-info';
            qrResult.innerHTML = message;
        }
    </script>
</body>

</html>