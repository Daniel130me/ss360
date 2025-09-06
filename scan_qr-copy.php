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
        #qr-reader {
            height: 80vh;
            width: 100%;
            position: relative;
        }

        #qr-reader video {
            height: 100% !important;
            width: 100% !important;
            object-fit: cover;
        }

        #qr-reader__scan_region {
            height: 100% !important;
        }

        /* Add styles for the scanning area */
        #qr-reader__scan_region img {
            opacity: 0.7;
            width: 100% !important;
            height: 100% !important;
        }

        /* Enhance scan region visibility */
        #qr-reader__scan_region>div {
            border: 2px solid #fff !important;
            box-shadow: 0 0 0 100vmax rgba(0, 0, 0, 0.5);
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
                                        <button id="toggleFlash" class="btn btn-sm btn-outline-secondary">
                                            <i class="fas fa-bolt"></i> Toggle Flash
                                        </button>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div id="qr-reader"></div>
                                <div id="qr-result"></div>
                                <div class="mt-3 card">
                                    <div class="card-body">
                                        <div>
                                            <div class="d-flex mb-3">
                                                <img src="../uploads/avatar.png" width="50" class="img-fluid rounded-circle" alt="QR Code">
                                                <div class="ml-2">
                                                    <p class="font-weight-bold">Oluwagbenga Kosoko</p>
                                                    <p class="muted-text">Basic 1 success</p>
                                                </div>
                                            </div>
                                            <div class="d-flex">
                                                <button class="btn btn-success mr-2">Yes, Correct!</button>
                                                <button class="btn btn-danger">No, Cancel</button>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- <div id="qr-result" class="mt-3 alert alert-info">Scanning...</div> -->
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
    <!-- Include the html5-qrcode library from a CDN -->
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    <script src="../dist/js/skul.js"></script>
    <!-- <script src="https://unpkg.com/html5-qrcode/minified/html5-qrcode.min.js"></script> -->
    <script>
        $(document).ready(function() {
            $('#att_log_scan').DataTable();

            let qrReader = null;
            let selectedDeviceId = null;

            // Function to check if HTTPS is being used
            function isHttps() {
                return window.location.protocol === 'https:';
            }

            // Function to show error message
            function showError(message) {
                const qrResult = document.getElementById('qr-result');
                qrResult.className = 'mt-3 alert alert-danger';
                qrResult.innerHTML = message;
            }

            // Function to show success message
            function showSuccess(message) {
                const qrResult = document.getElementById('qr-result');
                qrResult.className = 'mt-3 alert alert-success';
                qrResult.innerHTML = message;
            }

            // Function to show info message
            function showInfo(message) {
                const qrResult = document.getElementById('qr-result');
                qrResult.className = 'mt-3 alert alert-info';
                qrResult.innerHTML = message;
            }

            // Function to populate camera selector
            async function populateCameraSelector() {
                try {
                    if (!isHttps() && !window.location.hostname.includes('localhost')) {
                        showError('Camera access requires HTTPS. Please access this page using HTTPS or via localhost.');
                        return;
                    }

                    showInfo('Requesting camera permission...');

                    // First check if we have camera permission
                    const stream = await navigator.mediaDevices.getUserMedia({
                        video: true
                    });
                    stream.getTracks().forEach(track => track.stop()); // Stop the stream after permission check

                    const devices = await Html5Qrcode.getCameras();
                    const cameraSelectorElement = document.getElementById('cameraSelector');
                    cameraSelectorElement.innerHTML = ''; // Clear existing options

                    if (devices.length === 0) {
                        showError('No cameras found on your device.');
                        return;
                    }

                    devices.forEach(device => {
                        const option = document.createElement('option');
                        option.value = device.id;
                        option.text = device.label || `Camera ${devices.indexOf(device) + 1}`;
                        cameraSelectorElement.appendChild(option);
                    });

                    // On mobile, prefer back camera if available
                    const backCamera = devices.find(device =>
                        device.label.toLowerCase().includes('back') ||
                        device.label.toLowerCase().includes('rear')
                    );

                    selectedDeviceId = backCamera ? backCamera.id : devices[0].id;
                    cameraSelectorElement.value = selectedDeviceId;
                    startScanning(selectedDeviceId);

                } catch (err) {
                    console.error('Error getting cameras', err);
                    if (err.name === 'NotAllowedError') {
                        showError('Camera access denied. Please allow camera access and refresh the page.');
                    } else if (err.name === 'NotFoundError') {
                        showError('No camera found on your device.');
                    } else if (err.name === 'NotReadableError') {
                        showError('Camera may be in use by another application.');
                    } else {
                        showError(`Error accessing camera: ${err.message}`);
                    }
                }
            }

            // Function to start scanning
            function startScanning(deviceId) {
                if (qrReader) {
                    qrReader.stop();
                }

                qrReader = new Html5Qrcode("qr-reader");

                const qrboxFunction = function(viewfinderWidth, viewfinderHeight) {
                    let minEdgePercentage = 0.7; // Use 70% of the smaller edge
                    let minEdgeSize = Math.min(viewfinderWidth, viewfinderHeight);
                    let qrboxSize = Math.floor(minEdgeSize * minEdgePercentage);
                    return {
                        width: qrboxSize,
                        height: qrboxSize
                    };
                };

                const config = {
                    fps: 10,
                    qrbox: qrboxFunction,
                    aspectRatio: 1.0,
                    disableFlip: false, // Allow image flip for better detection
                    formatsToSupport: [Html5QrcodeSupportedFormats.QR_CODE]
                };


                showInfo('Starting QR code scanner...');

                qrReader.start(
                    deviceId,
                    config,
                    (decodedText) => {
                        // On successful scan

                        showSuccess(`
                        <div class="card">

                        </div>
                        `);

                        // Here you can add AJAX call to process the scanned data
                        // For example: sending to server, updating attendance, etc.
                    },
                    (errorMessage) => {
                        // Ignore errors in continuous scanning
                    }
                ).catch((err) => {
                    console.error(`Start failed: ${err}`);
                    showError(`Error starting scanner: ${err.message}`);
                });
            }

            // Camera selection change handler
            document.getElementById('cameraSelector').addEventListener('change', function(e) {
                selectedDeviceId = e.target.value;
                if (selectedDeviceId) {
                    startScanning(selectedDeviceId);
                }
            });

            // Flashlight toggle handler
            document.getElementById('toggleFlash').addEventListener('click', async function() {
                if (!qrReader) return;

                try {
                    const track = qrReader.getRunningTrackCameraCapabilities();
                    if (track && track.torch) {
                        const torchState = await qrReader.getRunningTrackSettings().torch;
                        await qrReader.applyVideoConstraints({
                            advanced: [{
                                torch: !torchState
                            }]
                        });
                        showInfo(torchState ? 'Flashlight turned off' : 'Flashlight turned on');
                    } else {
                        showError('Flashlight not supported on this device/browser');
                    }
                } catch (err) {
                    console.error('Error toggling flash', err);
                    showError('Error toggling flashlight: ' + err.message);
                }
            });

            // Initialize camera list when page loads
            populateCameraSelector();
        });
    </script>
</body>

</html>