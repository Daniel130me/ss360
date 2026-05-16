<?php
session_start();
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");

if (!transport_is_staff_user()) {
    header("Location: parent_portal");
    exit();
}

$can_manage_transport = transport_is_admin();
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bus Tracking | <?= get_staff_fullname_by_id($_SESSION['userid']) ?></title>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../plugins/select2/css/select2.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
    <style>
        .material-symbols-outlined {
            font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 20;
        }

        .transport-toolbar {
            gap: 8px;
            overflow-x: auto;
        }

        .transport-panel {
            background: #fff;
            border-radius: 8px;
            padding: 16px;
            min-height: 100%;
        }

        .transport-table {
            width: 100%;
            border-collapse: collapse;
        }

        .transport-table th,
        .transport-table td {
            border-bottom: 1px solid #eef1f5;
            padding: 10px 8px;
            vertical-align: top;
        }

        .transport-table th {
            color: #6c757d;
            font-size: 0.78rem;
            text-transform: uppercase;
        }

        .status-pill {
            border-radius: 999px;
            display: inline-flex;
            font-size: 0.78rem;
            font-weight: 700;
            padding: 4px 10px;
        }

        .status-pill.active {
            background: #e8f7ee;
            color: #1d7a3f;
        }

        .status-pill.inactive {
            background: #f1f3f5;
            color: #6c757d;
        }

        .empty-state {
            border: 1px dashed #dce3ea;
            border-radius: 8px;
            color: #6c757d;
            padding: 18px;
            text-align: center;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
            gap: 12px;
        }

        #staffBusMap {
            border-radius: 8px;
            height: 420px;
            margin-bottom: 16px;
            overflow: hidden;
            width: 100%;
        }
    </style>
</head>

<body class="hold-transition sidebar-mini">
    <div class="wrapper">
        <nav class="main-header navbar border-bottom-0 navbar-expand justify-content-between bg1">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a class="nav-link" data-widget="pushmenu" href="#" role="button"><i class="muted-text fas fa-bars"></i></a>
                </li>
            </ul>
            <ul class="navbar-nav align-items-center">
                <li class="nav-item dropdown">
                    <a data-toggle="dropdown" href="#">
                        <div class="user-panel d-flex align-items-center">
                            <span class="material-symbols-outlined">arrow_drop_down</span>
                            <div class="image pl-0">
                                <img src="../uploads/<?= $_SESSION['staff_photo'] ?>" class="img-circle elevation-2" alt="User Image">
                            </div>
                            <div class="info d-none d-sm-inline-block">
                                <p style="font-size: 14px;" class="mb-0 d-block"><?= $_SESSION['firstname'] . ' ' . $_SESSION['lastname'] ?></p>
                                <p style="font-size: 12px;" class="d-block mb-0 accent"><?= get_staff_type_in_name($_SESSION['staff_type']) ?></p>
                            </div>
                        </div>
                    </a>
                    <div class="dropdown-menu dropdown-menu-sm dropdown-menu-right p-2" style="border-radius: 10px;">
                        <a href="profile" class="dropdown-item text-muted d-flex"><i class="material-symbols-outlined mr-2 d-inline">person</i> Profile</a>
                        <a href="change_password" class="dropdown-item text-muted d-flex"><span class="material-symbols-outlined mr-2">lock</span> Change PIN</a>
                        <a href="logout" class="dropdown-item text-muted d-flex"><span class="material-symbols-outlined mr-2">logout</span> Logout</a>
                    </div>
                </li>
            </ul>
        </nav>

        <aside class="main-sidebar sidebar-light-primary elevation-4">
            <a href="" class="brand-link">
                <img src="../uploads/<?= $_SESSION['logo'] ?>" alt="<?= $_SESSION['school_name'] ?>" class="brand-image" style="opacity: .8">
                <span class="brand-text font-weight-light" style="visibility: hidden;">SchoolSuite360</span>
            </a>
            <div class="py-2 px-15">
                <p class="font-weight-bold text-tertiary"><?= $_SESSION['school_name'] ?></p>
            </div>
            <div class="sidebar">
                <nav class="mt-2">
                    <ul class="nav nav-pills nav-sidebar flex-column pb-5" data-widget="treeview" role="menu" data-accordion="false">
                        <li class="nav-item"><a href="dashboard" class="nav-link"><p class="d-flex"><i class="material-symbols-outlined pr-2">dashboard</i>Dashboard</p></a></li>
                        <?php if ($can_manage_transport) { ?>
                            <li class="nav-item"><a href="settings" class="nav-link"><p class="d-flex"><i class="material-symbols-outlined pr-2">tune</i>Settings</p></a></li>
                        <?php } ?>
                        <li class="nav-item"><a href="staff" class="nav-link"><p class="d-flex"><i class="material-symbols-outlined pr-2">supervisor_account</i>Staff</p></a></li>
                        <li class="nav-item"><a href="students" class="nav-link"><p class="d-flex"><i class="material-symbols-outlined pr-2">groups</i>Students</p></a></li>
                        <li class="nav-item"><a href="bus_tracking" class="nav-link active"><p class="d-flex"><i class="material-symbols-outlined pr-2">directions_bus</i>Bus Tracking</p></a></li>
                        <li class="nav-item"><a href="attendance" class="nav-link"><p class="d-flex"><i class="material-symbols-outlined pr-2">list</i>Attendance</p></a></li>
                        <li class="nav-item"><a href="communication" class="nav-link"><p class="d-flex"><i class="material-symbols-outlined pr-2">hub</i>Communication</p></a></li>
                    </ul>
                </nav>
            </div>
            <a href="" class="brand-link" style="background:white; position: fixed; bottom:0;">
                <img src="../dist/img/company_logo.png" alt="Schoolsuite360" class="brand-image img-circle elevation-3" style="opacity: .8">
                <span class="brand-text font-weight-light">Schoolsuite360</span>
            </a>
        </aside>

        <div class="content-wrapper" style="background-color: #f4f7fa; padding-bottom: 100px;">
            <section class="content pt-3">
                <div class="container-fluid">
                    <div class="d-flex align-items-center justify-content-between flex-wrap mb-3">
                        <div>
                            <h4 class="mb-1 font-weight-bold">Bus Tracking</h4>
                            <p class="text-muted mb-0">Current transport activity and setup</p>
                        </div>
                        <button type="button" class="btn btn-primary d-flex align-items-center" onclick="refreshTransportData()">
                            <span class="material-symbols-outlined mr-1">refresh</span> Refresh
                        </button>
                    </div>

                    <div class="nav nav-pills transport-toolbar mb-3" role="tablist">
                        <a class="nav-link active" data-toggle="pill" href="#transport-live" role="tab">Live Dashboard</a>
                        <a class="nav-link" data-toggle="pill" href="#transport-driver" role="tab">Driver Mode</a>
                        <?php if ($can_manage_transport) { ?>
                            <a class="nav-link" data-toggle="pill" href="#transport-buses" role="tab">Buses</a>
                            <a class="nav-link" data-toggle="pill" href="#transport-routes" role="tab">Routes & Stops</a>
                            <a class="nav-link" data-toggle="pill" href="#transport-assignments" role="tab">Assignments</a>
                            <a class="nav-link" data-toggle="pill" href="#transport-settings" role="tab">Settings</a>
                        <?php } ?>
                    </div>

                    <div class="tab-content">
                        <div class="tab-pane fade show active" id="transport-live" role="tabpanel">
                            <div class="transport-panel">
                                <div class="d-flex justify-content-between align-items-center mb-3">
                                    <h5 class="font-weight-bold mb-0">Active Buses</h5>
                                    <span class="text-muted small" id="liveUpdatedAt">Loading...</span>
                                </div>
                                <div id="staffBusMap"></div>
                                <div id="liveBusTable"></div>
                            </div>
                        </div>

                        <div class="tab-pane fade" id="transport-driver" role="tabpanel">
                            <div class="row">
                                <div class="col-lg-5 mb-3">
                                    <div class="transport-panel">
                                        <h5 class="font-weight-bold">Trip Control</h5>
                                        <form id="driverTripForm">
                                            <div class="form-group"><label>Bus</label><select class="form-control" id="driver_bus_id" required></select></div>
                                            <div class="form-group"><label>Route</label><select class="form-control" id="driver_route_id"></select></div>
                                            <div class="form-group">
                                                <label>Direction</label>
                                                <select class="form-control" id="driver_direction">
                                                    <option value="to_school">Going to school</option>
                                                    <option value="to_home">Going home</option>
                                                </select>
                                            </div>
                                            <div class="d-flex" style="gap: 8px;">
                                                <button class="btn btn-success flex-fill" type="submit" id="startTripBtn">Start</button>
                                                <button class="btn btn-danger flex-fill" type="button" id="stopTripBtn" disabled>Stop</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                                <div class="col-lg-7 mb-3">
                                    <div class="transport-panel">
                                        <h5 class="font-weight-bold">Tracking Status</h5>
                                        <div class="row">
                                            <div class="col-md-6 mb-3"><p class="text-muted mb-1">Trip</p><strong id="driverTripStatus">Not started</strong></div>
                                            <div class="col-md-6 mb-3"><p class="text-muted mb-1">GPS accuracy</p><strong id="driverAccuracy">Waiting</strong></div>
                                            <div class="col-md-6 mb-3"><p class="text-muted mb-1">Last sent</p><strong id="driverLastSent">Never</strong></div>
                                            <div class="col-md-6 mb-3"><p class="text-muted mb-1">Server response</p><strong id="driverServerStatus">Idle</strong></div>
                                        </div>
                                        <div class="alert alert-light border mb-0" id="driverPermissionHint">
                                            Location sharing starts only after Start and stops when the trip is stopped.
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <?php if ($can_manage_transport) { ?>
                            <div class="tab-pane fade" id="transport-buses" role="tabpanel">
                                <div class="row">
                                    <div class="col-lg-4 mb-3">
                                        <div class="transport-panel">
                                            <h5 class="font-weight-bold">Bus Details</h5>
                                            <form id="busForm">
                                                <input type="hidden" name="action" value="save_bus">
                                                <input type="hidden" name="bus_id" id="bus_id">
                                                <div class="form-group"><label>Bus name</label><input class="form-control" name="bus_name" id="bus_name" required></div>
                                                <div class="form-grid">
                                                    <div class="form-group"><label>Bus number</label><input class="form-control" name="bus_number" id="bus_number"></div>
                                                    <div class="form-group"><label>Plate number</label><input class="form-control" name="plate_number" id="plate_number"></div>
                                                </div>
                                                <div class="form-group"><label>Driver</label><select class="form-control" name="driver_staff_id" id="driver_staff_id"></select></div>
                                                <div class="form-group"><label>Assistant</label><select class="form-control" name="assistant_staff_id" id="assistant_staff_id"></select></div>
                                                <div class="form-grid">
                                                    <div class="form-group"><label>Driver phone</label><input class="form-control" name="driver_phone" id="driver_phone"></div>
                                                    <div class="form-group"><label>Capacity</label><input type="number" min="0" class="form-control" name="capacity" id="capacity"></div>
                                                </div>
                                                <div class="form-group"><label>Status</label><select class="form-control" name="status" id="bus_status"><option value="1">Active</option><option value="0">Inactive</option></select></div>
                                                <button class="btn btn-primary btn-block" type="submit">Save Bus</button>
                                                <button class="btn btn-light btn-block" type="button" onclick="resetBusForm()">Clear</button>
                                            </form>
                                        </div>
                                    </div>
                                    <div class="col-lg-8 mb-3"><div class="transport-panel"><h5 class="font-weight-bold">Buses</h5><div id="busTable"></div></div></div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="transport-routes" role="tabpanel">
                                <div class="row">
                                    <div class="col-lg-4 mb-3">
                                        <div class="transport-panel">
                                            <h5 class="font-weight-bold">Route</h5>
                                            <form id="routeForm">
                                                <input type="hidden" name="action" value="save_route">
                                                <input type="hidden" name="route_id" id="route_id">
                                                <div class="form-group"><label>Route name</label><input class="form-control" name="route_name" id="route_name" required></div>
                                                <div class="form-group"><label>Description</label><textarea class="form-control" name="description" id="description" rows="2"></textarea></div>
                                                <div class="form-grid">
                                                    <div class="form-group"><label>To school label</label><input class="form-control" name="to_school_label" id="to_school_label" value="Going to school"></div>
                                                    <div class="form-group"><label>To home label</label><input class="form-control" name="to_home_label" id="to_home_label" value="Going home"></div>
                                                </div>
                                                <button class="btn btn-primary btn-block" type="submit">Save Route</button>
                                                <button class="btn btn-light btn-block" type="button" onclick="resetRouteForm()">Clear</button>
                                            </form>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 mb-3">
                                        <div class="transport-panel">
                                            <h5 class="font-weight-bold">Stop</h5>
                                            <form id="stopForm">
                                                <input type="hidden" name="action" value="save_route_stop">
                                                <input type="hidden" name="stop_id" id="stop_id">
                                                <div class="form-group"><label>Route</label><select class="form-control" name="route_id" id="stop_route_id" required></select></div>
                                                <div class="form-group"><label>Stop name</label><input class="form-control" name="stop_name" id="stop_name" required></div>
                                                <div class="form-grid">
                                                    <div class="form-group"><label>Latitude</label><input type="number" step="0.0000001" class="form-control" name="latitude" id="latitude" required></div>
                                                    <div class="form-group"><label>Longitude</label><input type="number" step="0.0000001" class="form-control" name="longitude" id="longitude" required></div>
                                                    <div class="form-group"><label>Order</label><input type="number" class="form-control" name="stop_order" id="stop_order" value="0"></div>
                                                </div>
                                                <button class="btn btn-primary btn-block" type="submit">Save Stop</button>
                                                <button class="btn btn-light btn-block" type="button" onclick="resetStopForm()">Clear</button>
                                            </form>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 mb-3"><div class="transport-panel"><h5 class="font-weight-bold">Routes & Stops</h5><div id="routeStopTable"></div></div></div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="transport-assignments" role="tabpanel">
                                <div class="row">
                                    <div class="col-lg-4 mb-3">
                                        <div class="transport-panel">
                                            <h5 class="font-weight-bold">Student Assignment</h5>
                                            <form id="assignmentForm">
                                                <input type="hidden" name="action" value="save_assignment">
                                                <input type="hidden" name="assignment_id" id="assignment_id">
                                                <div class="form-group"><label>Student</label><select class="form-control" name="student_id" id="assignment_student_id" required></select></div>
                                                <div class="form-group"><label>Bus</label><select class="form-control" name="bus_id" id="assignment_bus_id" required></select></div>
                                                <div class="form-group"><label>Route</label><select class="form-control" name="route_id" id="assignment_route_id"></select></div>
                                                <div class="form-group"><label>Stop</label><select class="form-control" name="stop_id" id="assignment_stop_id"></select></div>
                                                <div class="form-group"><label>Status</label><select class="form-control" name="status" id="assignment_status"><option value="1">Active</option><option value="0">Inactive</option></select></div>
                                                <button class="btn btn-primary btn-block" type="submit">Save Assignment</button>
                                                <button class="btn btn-light btn-block" type="button" onclick="resetAssignmentForm()">Clear</button>
                                            </form>
                                        </div>
                                    </div>
                                    <div class="col-lg-8 mb-3"><div class="transport-panel"><h5 class="font-weight-bold">Assignments</h5><div id="assignmentTable"></div></div></div>
                                </div>
                            </div>

                            <div class="tab-pane fade" id="transport-settings" role="tabpanel">
                                <div class="transport-panel">
                                    <h5 class="font-weight-bold">Tracking Settings</h5>
                                    <form id="settingsForm" class="form-grid">
                                        <input type="hidden" name="action" value="update_settings">
                                        <div class="form-group"><label>Update interval seconds</label><input type="number" min="15" class="form-control" name="update_interval_seconds" id="update_interval_seconds"></div>
                                        <div class="form-group"><label>Stale after seconds</label><input type="number" min="30" class="form-control" name="stale_after_seconds" id="stale_after_seconds"></div>
                                        <div class="form-group"><label>Minimum movement meters</label><input type="number" min="0" class="form-control" name="min_movement_meters" id="min_movement_meters"></div>
                                        <div class="form-group"><label>Maximum accuracy meters</label><input type="number" min="20" class="form-control" name="max_accuracy_meters" id="max_accuracy_meters"></div>
                                        <div class="form-group"><label>History retention days</label><input type="number" min="1" class="form-control" name="history_retention_days" id="history_retention_days"></div>
                                        <div class="form-group d-flex align-items-end"><button class="btn btn-primary btn-block" type="submit">Save Settings</button></div>
                                    </form>
                                </div>
                            </div>
                        <?php } ?>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <script src="../plugins/jquery/jquery.min.js"></script>
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script src="../plugins/select2/js/select2.full.min.js"></script>
    <script src="../dist/js/adminlte.min.js"></script>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        const canManageTransport = <?= $can_manage_transport ? 'true' : 'false' ?>;
        const state = { buses: [], driverBuses: [], routes: [], stops: [], assignments: [], staff: [], students: [], settings: {} };
        const driverState = { tripId: null, watchId: null, latestPosition: null, sendTimer: null, lastSentAt: 0, lastSentPoint: null };
        const mapState = { map: null, markers: {}, hasFitBounds: false };

        function escapeHtml(value) {
            return String(value ?? '').replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[char]));
        }

        function statusPill(status) {
            return Number(status) === 1 ? '<span class="status-pill active">Active</span>' : '<span class="status-pill inactive">Inactive</span>';
        }

        function postTransport(data) {
            return $.ajax({ url: 'bus_controller.php', method: 'POST', data, dataType: 'json' });
        }

        function optionHtml(rows, label, includeBlank = true) {
            let html = includeBlank ? '<option value="">Select ' + label + '</option>' : '';
            rows.forEach(row => {
                const text = row.name || row.bus_name || row.route_name || row.stop_name || '';
                const extra = row.classname ? ' - ' + row.classname : '';
                html += '<option value="' + row.id + '">' + escapeHtml(text + extra) + '</option>';
            });
            return html;
        }

        function renderLive(rows) {
            $('#liveUpdatedAt').text('Updated ' + new Date().toLocaleTimeString());
            updateStaffMap(rows);
            if (!rows.length) {
                $('#liveBusTable').html('<div class="empty-state">No bus has been registered yet.</div>');
                return;
            }

            let html = '<div class="table-responsive"><table class="transport-table"><thead><tr><th>Bus</th><th>Driver</th><th>Trip</th><th>Last update</th></tr></thead><tbody>';
            rows.forEach(row => {
                const trip = row.trip_id ? escapeHtml((row.direction || '').replace('_', ' ')) : 'No active trip';
                const last = row.recorded_at ? escapeHtml(row.recorded_at) : 'No location yet';
                html += '<tr><td><strong>' + escapeHtml(row.bus_name) + '</strong><div class="text-muted small">' + escapeHtml(row.bus_number || row.plate_number || '') + '</div></td><td>' + escapeHtml(row.driver_name || row.driver_phone || '') + '</td><td>' + trip + '</td><td>' + last + '</td></tr>';
            });
            html += '</tbody></table></div>';
            $('#liveBusTable').html(html);
        }

        function initStaffMap() {
            if (mapState.map || typeof L === 'undefined') return;
            mapState.map = L.map('staffBusMap').setView([9.082, 8.6753], 6);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '&copy; OpenStreetMap contributors'
            }).addTo(mapState.map);
        }

        function animateMarker(marker, nextLatLng) {
            const start = marker.getLatLng();
            const steps = 20;
            let current = 0;
            const timer = setInterval(function() {
                current += 1;
                const lat = start.lat + ((nextLatLng[0] - start.lat) * current / steps);
                const lng = start.lng + ((nextLatLng[1] - start.lng) * current / steps);
                marker.setLatLng([lat, lng]);
                if (current >= steps) clearInterval(timer);
            }, 35);
        }

        function updateStaffMap(rows) {
            initStaffMap();
            if (!mapState.map) return;
            const bounds = [];
            rows.forEach(row => {
                if (!row.latitude || !row.longitude) return;
                const latLng = [Number(row.latitude), Number(row.longitude)];
                const popup = '<strong>' + escapeHtml(row.bus_name) + '</strong><br>' +
                    escapeHtml(row.direction || 'No active trip') + '<br>' +
                    'Last update: ' + escapeHtml(row.recorded_at || 'Unknown');
                if (mapState.markers[row.bus_id]) {
                    animateMarker(mapState.markers[row.bus_id], latLng);
                    mapState.markers[row.bus_id].setPopupContent(popup);
                } else {
                    mapState.markers[row.bus_id] = L.marker(latLng).addTo(mapState.map).bindPopup(popup);
                }
                bounds.push(latLng);
            });
            if (bounds.length && !mapState.hasFitBounds) {
                mapState.map.fitBounds(bounds, { padding: [40, 40], maxZoom: 15 });
                mapState.hasFitBounds = true;
            }
        }

        function renderBuses() {
            if (!state.buses.length) {
                $('#busTable').html('<div class="empty-state">No buses registered.</div>');
                return;
            }
            let html = '<div class="table-responsive"><table class="transport-table"><thead><tr><th>Bus</th><th>Driver</th><th>Status</th><th></th></tr></thead><tbody>';
            state.buses.forEach(bus => {
                html += '<tr><td><strong>' + escapeHtml(bus.bus_name) + '</strong><div class="text-muted small">' + escapeHtml(bus.bus_number || '') + ' ' + escapeHtml(bus.plate_number || '') + '</div></td><td>' + escapeHtml(bus.driver_name || bus.driver_phone || '') + '</td><td>' + statusPill(bus.status) + '</td><td><button class="btn btn-sm btn-light" onclick="editBus(' + bus.id + ')">Edit</button></td></tr>';
            });
            html += '</tbody></table></div>';
            $('#busTable').html(html);
        }

        function renderRoutesAndStops() {
            const stopsByRoute = {};
            state.stops.forEach(stop => {
                if (!stopsByRoute[stop.route_id]) stopsByRoute[stop.route_id] = [];
                stopsByRoute[stop.route_id].push(stop);
            });
            if (!state.routes.length) {
                $('#routeStopTable').html('<div class="empty-state">No routes registered.</div>');
                return;
            }
            let html = '';
            state.routes.forEach(route => {
                html += '<div class="mb-3"><div class="d-flex justify-content-between"><strong>' + escapeHtml(route.route_name) + '</strong><button class="btn btn-sm btn-light" onclick="editRoute(' + route.id + ')">Edit</button></div>';
                const stops = stopsByRoute[route.id] || [];
                html += stops.length ? '<ol class="pl-3 mb-0">' + stops.map(stop => '<li>' + escapeHtml(stop.stop_name) + ' <button class="btn btn-xs btn-link" onclick="editStop(' + stop.id + ')">Edit</button></li>').join('') + '</ol>' : '<p class="text-muted small mb-0">No stops yet.</p>';
                html += '</div>';
            });
            $('#routeStopTable').html(html);
        }

        function renderAssignments() {
            if (!state.assignments.length) {
                $('#assignmentTable').html('<div class="empty-state">No student assignments.</div>');
                return;
            }
            let html = '<div class="table-responsive"><table class="transport-table"><thead><tr><th>Student</th><th>Bus</th><th>Stop</th><th>Status</th><th></th></tr></thead><tbody>';
            state.assignments.forEach(row => {
                html += '<tr><td><strong>' + escapeHtml(row.student_name) + '</strong><div class="text-muted small">' + escapeHtml(row.classname || '') + '</div></td><td>' + escapeHtml(row.bus_name) + '</td><td>' + escapeHtml(row.stop_name || '') + '</td><td>' + statusPill(row.status) + '</td><td><button class="btn btn-sm btn-light" onclick="editAssignment(' + row.id + ')">Edit</button></td></tr>';
            });
            html += '</tbody></table></div>';
            $('#assignmentTable').html(html);
        }

        function fillSelects() {
            $('#driver_staff_id, #assistant_staff_id').html(optionHtml(state.staff, 'staff'));
            $('#assignment_student_id').html(optionHtml(state.students, 'student'));
            $('#assignment_bus_id').html(optionHtml(state.buses, 'bus'));
            $('#stop_route_id, #assignment_route_id').html(optionHtml(state.routes, 'route'));
            $('#assignment_stop_id').html(optionHtml(state.stops, 'stop'));
            $('#driver_bus_id').html(optionHtml(state.driverBuses, 'bus'));
            $('#driver_route_id').html(optionHtml(state.routes, 'route'));
        }

        function fillSettings() {
            Object.keys(state.settings || {}).forEach(key => $('#' + key).val(state.settings[key]));
        }

        function refreshTransportData() {
            $.when(
                postTransport({ action: 'staff_snapshot' }),
                postTransport({ action: 'driver_context' }),
                canManageTransport ? postTransport({ action: 'list_transport_options' }) : $.Deferred().resolve([{ status: '1', staff: [], students: [] }]),
                canManageTransport ? postTransport({ action: 'list_buses' }) : $.Deferred().resolve([{ status: '1', buses: [] }]),
                postTransport({ action: 'list_routes' }),
                canManageTransport ? postTransport({ action: 'list_route_stops' }) : $.Deferred().resolve([{ status: '1', stops: [] }]),
                canManageTransport ? postTransport({ action: 'list_assignments' }) : $.Deferred().resolve([{ status: '1', assignments: [] }]),
                canManageTransport ? postTransport({ action: 'get_settings' }) : $.Deferred().resolve([{ status: '1', settings: {} }])
            ).done(function(snapshotResp, driverResp, optionsResp, busesResp, routesResp, stopsResp, assignmentsResp, settingsResp) {
                const snapshot = snapshotResp[0] || {};
                renderLive(snapshot.buses || []);
                const driver = driverResp[0] || {};
                state.driverBuses = driver.buses || [];
                state.settings = driver.settings || state.settings || {};

                if (!canManageTransport) {
                    state.routes = (routesResp[0] || {}).routes || [];
                    fillSelects();
                    hydrateActiveDriverTrip();
                    return;
                }
                const options = optionsResp[0] || {};
                state.staff = options.staff || [];
                state.students = options.students || [];
                state.buses = (busesResp[0] || {}).buses || [];
                state.routes = (routesResp[0] || {}).routes || [];
                state.stops = (stopsResp[0] || {}).stops || [];
                state.assignments = (assignmentsResp[0] || {}).assignments || [];
                state.settings = (settingsResp[0] || {}).settings || {};
                fillSelects();
                fillSettings();
                hydrateActiveDriverTrip();
                renderBuses();
                renderRoutesAndStops();
                renderAssignments();
            }).fail(function(xhr) {
                toastr.error((xhr.responseJSON && xhr.responseJSON.err) || 'Unable to load transport data');
            });
        }

        function resetBusForm() { $('#busForm')[0].reset(); $('#bus_id').val(''); }
        function resetRouteForm() { $('#routeForm')[0].reset(); $('#route_id').val(''); }
        function resetStopForm() { $('#stopForm')[0].reset(); $('#stop_id').val(''); }
        function resetAssignmentForm() { $('#assignmentForm')[0].reset(); $('#assignment_id').val(''); }

        function editBus(id) {
            const row = state.buses.find(item => Number(item.id) === Number(id));
            if (!row) return;
            Object.keys(row).forEach(key => $('#'+key).val(row[key]));
            $('#bus_id').val(row.id);
            $('#bus_status').val(row.status);
        }

        function editRoute(id) {
            const row = state.routes.find(item => Number(item.id) === Number(id));
            if (!row) return;
            Object.keys(row).forEach(key => $('#'+key).val(row[key]));
            $('#route_id').val(row.id);
        }

        function editStop(id) {
            const row = state.stops.find(item => Number(item.id) === Number(id));
            if (!row) return;
            $('#stop_id').val(row.id);
            $('#stop_route_id').val(row.route_id);
            $('#stop_name').val(row.stop_name);
            $('#latitude').val(row.latitude);
            $('#longitude').val(row.longitude);
            $('#stop_order').val(row.stop_order);
        }

        function editAssignment(id) {
            const row = state.assignments.find(item => Number(item.id) === Number(id));
            if (!row) return;
            $('#assignment_id').val(row.id);
            $('#assignment_student_id').val(row.student_id);
            $('#assignment_bus_id').val(row.bus_id);
            $('#assignment_route_id').val(row.route_id || '');
            $('#assignment_stop_id').val(row.stop_id || '');
            $('#assignment_status').val(row.status);
        }

        function hydrateActiveDriverTrip() {
            const active = state.driverBuses.find(bus => bus.active_trip_id);
            if (!active || driverState.tripId) return;
            $('#driver_bus_id').val(active.id);
            $('#driver_route_id').val(active.active_route_id || '');
            $('#driver_direction').val(active.active_direction || 'to_home');
            driverState.tripId = active.active_trip_id;
            $('#driverTripStatus').text('Active trip #' + driverState.tripId + ' ready');
            $('#startTripBtn').text('Resume GPS').prop('disabled', false);
            $('#stopTripBtn').prop('disabled', false);
        }

        function driverDistanceMeters(a, b) {
            if (!a || !b) return Infinity;
            const radius = 6371000;
            const toRad = value => value * Math.PI / 180;
            const dLat = toRad(b.latitude - a.latitude);
            const dLng = toRad(b.longitude - a.longitude);
            const calc = Math.sin(dLat / 2) ** 2 + Math.cos(toRad(a.latitude)) * Math.cos(toRad(b.latitude)) * Math.sin(dLng / 2) ** 2;
            return radius * (2 * Math.atan2(Math.sqrt(calc), Math.sqrt(1 - calc)));
        }

        function startWatchingPosition() {
            if (!navigator.geolocation) {
                $('#driverServerStatus').text('GPS not supported');
                return;
            }
            if (driverState.watchId !== null) navigator.geolocation.clearWatch(driverState.watchId);
            driverState.watchId = navigator.geolocation.watchPosition(function(position) {
                driverState.latestPosition = {
                    latitude: position.coords.latitude,
                    longitude: position.coords.longitude,
                    accuracy: position.coords.accuracy,
                    speed: position.coords.speed,
                    heading: position.coords.heading
                };
                $('#driverAccuracy').text(Math.round(position.coords.accuracy || 0) + 'm');
            }, function(error) {
                $('#driverServerStatus').text(error.message || 'GPS error');
            }, { enableHighAccuracy: true, maximumAge: 10000, timeout: 20000 });
        }

        function stopWatchingPosition() {
            if (driverState.watchId !== null) {
                navigator.geolocation.clearWatch(driverState.watchId);
                driverState.watchId = null;
            }
            if (driverState.sendTimer) {
                clearInterval(driverState.sendTimer);
                driverState.sendTimer = null;
            }
            driverState.latestPosition = null;
            driverState.lastSentPoint = null;
            driverState.lastSentAt = 0;
        }

        function sendDriverLocation() {
            if (!driverState.tripId || !driverState.latestPosition) return;
            const now = Date.now();
            const intervalMs = Math.max(15, Number(state.settings.update_interval_seconds || 20)) * 1000;
            const minMovement = Math.max(0, Number(state.settings.min_movement_meters || 30));
            const point = { latitude: driverState.latestPosition.latitude, longitude: driverState.latestPosition.longitude };
            if ((now - driverState.lastSentAt) < intervalMs) return;
            if (driverDistanceMeters(driverState.lastSentPoint, point) < minMovement && driverState.lastSentAt > 0) return;

            postTransport({
                action: 'submit_location',
                trip_id: driverState.tripId,
                latitude: driverState.latestPosition.latitude,
                longitude: driverState.latestPosition.longitude,
                accuracy_meters: driverState.latestPosition.accuracy || '',
                speed_mps: driverState.latestPosition.speed || '',
                heading_degrees: driverState.latestPosition.heading || ''
            }).done(function(resp) {
                driverState.lastSentAt = now;
                if (resp.accepted) {
                    driverState.lastSentPoint = point;
                    $('#driverLastSent').text(new Date().toLocaleTimeString());
                    $('#driverServerStatus').text('Location sent');
                } else {
                    $('#driverServerStatus').text(resp.reason || 'Skipped');
                }
            }).fail(function(xhr) {
                $('#driverServerStatus').text((xhr.responseJSON && xhr.responseJSON.err) || 'Send failed');
            });
        }

        $('#driverTripForm').on('submit', function(event) {
            event.preventDefault();
            const busId = $('#driver_bus_id').val();
            if (!busId) return toastr.error('Select a bus');
            postTransport({
                action: 'start_trip',
                bus_id: busId,
                route_id: $('#driver_route_id').val(),
                direction: $('#driver_direction').val()
            }).done(function(resp) {
                if (resp.status !== '1') return toastr.error(resp.err || 'Unable to start trip');
                driverState.tripId = resp.trip_id;
                state.settings = resp.settings || state.settings;
                $('#driverTripStatus').text('Active trip #' + driverState.tripId);
                $('#startTripBtn').text('Tracking').prop('disabled', true);
                $('#stopTripBtn').prop('disabled', false);
                $('#driverServerStatus').text('Tracking started');
                startWatchingPosition();
                driverState.sendTimer = setInterval(sendDriverLocation, 3000);
                toastr.success(resp.msg || 'Trip started');
            }).fail(function(xhr) {
                toastr.error((xhr.responseJSON && xhr.responseJSON.err) || 'Unable to start trip');
            });
        });

        $('#stopTripBtn').on('click', function() {
            if (!driverState.tripId) return;
            postTransport({ action: 'stop_trip', trip_id: driverState.tripId }).done(function(resp) {
                if (resp.status !== '1') return toastr.error(resp.err || 'Unable to stop trip');
                stopWatchingPosition();
                driverState.tripId = null;
                $('#driverTripStatus').text('Stopped');
                $('#driverAccuracy').text('Waiting');
                $('#driverServerStatus').text('Tracking stopped');
                $('#startTripBtn').text('Start').prop('disabled', false);
                $('#stopTripBtn').prop('disabled', true);
                toastr.success(resp.msg || 'Trip stopped');
                refreshTransportData();
            }).fail(function(xhr) {
                toastr.error((xhr.responseJSON && xhr.responseJSON.err) || 'Unable to stop trip');
            });
        });

        $('#busForm, #routeForm, #stopForm, #assignmentForm, #settingsForm').on('submit', function(event) {
            event.preventDefault();
            const form = $(this);
            postTransport(form.serialize()).done(function(resp) {
                if (resp.status === '1') {
                    toastr.success(resp.msg || 'Saved');
                    refreshTransportData();
                } else {
                    toastr.error(resp.err || 'Unable to save');
                }
            }).fail(function(xhr) {
                toastr.error((xhr.responseJSON && xhr.responseJSON.err) || 'Unable to save');
            });
        });

        $(function() {
            refreshTransportData();
            setInterval(refreshTransportData, Math.max(15, Number(state.settings.update_interval_seconds || 20)) * 1000);
        });
    </script>
</body>

</html>
