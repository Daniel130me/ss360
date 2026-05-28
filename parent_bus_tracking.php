<?php
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}
if (!isset($_SESSION['userid'])) {
    header("Location: login");
    exit();
}
include_once("model/connect.php");
include_once("model/functions.php");

if (transport_is_staff_user()) {
    header("Location: bus_tracking");
    exit();
}

$school_id = $_SESSION['school_id'];
$parent_id = $_SESSION['userid'];
$students = [];
$select = mysqli_query($conn, "SELECT s.id, s.firstname, s.lastname, s.middlename, c.classname
    FROM students s
    LEFT JOIN class c ON c.id = s.class_id AND c.school_id = s.school_id
    WHERE s.school_id='$school_id' AND s.parent_id='$parent_id'
    ORDER BY s.lastname ASC, s.firstname ASC");
while ($row = mysqli_fetch_assoc($select)) {
    $students[] = $row;
}
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bus Tracking | <?= $_SESSION['lastname'] . ' ' . $_SESSION['firstname'] ?></title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,400i,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css">
    <style>
        .material-symbols-outlined { font-variation-settings: 'FILL' 0, 'wght' 300, 'GRAD' 0, 'opsz' 20; }
        .tracking-shell { background: #f4f7fa; min-height: 100vh; padding-bottom: 80px; }
        .tracking-panel { background: #fff; border-radius: 8px; padding: 16px; }
        #parentBusMap { border-radius: 8px; height: 520px; overflow: hidden; width: 100%; }
        .metric-label { color: #6c757d; font-size: 0.78rem; margin-bottom: 3px; text-transform: uppercase; }
        .status-pill { border-radius: 999px; display: inline-flex; font-size: 0.78rem; font-weight: 700; padding: 4px 10px; }
        .status-pill.good { background: #e8f7ee; color: #1d7a3f; }
        .status-pill.muted { background: #f1f3f5; color: #6c757d; }
        .empty-state { border: 1px dashed #dce3ea; border-radius: 8px; color: #6c757d; padding: 18px; text-align: center; }
    </style>
</head>

<body class="hold-transition sidebar-mini">
    <div class="tracking-shell">
        <nav class="navbar border-bottom-0 navbar-expand justify-content-between bg1 pt-3">
            <ul class="navbar-nav">
                <li class="nav-item">
                    <a href="parent_portal" class="brand-link py-1">
                        <img src="../dist/img/company_logo.png" alt="logo" class="brand-image img-circle elevation-3" style="opacity: .8">
                        <span class="brand-text font-weight-light">SchoolSuite360</span>
                    </a>
                </li>
            </ul>
            <ul class="navbar-nav align-items-center">
                <li class="nav-item dropdown">
                    <a data-toggle="dropdown" href="#">
                        <div class="user-panel d-flex align-items-center">
                            <span class="material-symbols-outlined">arrow_drop_down</span>
                            <div class="info d-none d-sm-flex flex-column">
                                <p style="font-size: 14px;" class="mb-0"><?= $_SESSION['firstname'] . ' ' . $_SESSION['lastname'] ?></p>
                                <p style="font-size: 12px;" class="mb-0 accent"><?= $_SESSION['email'] ?></p>
                            </div>
                        </div>
                    </a>
                    <div class="dropdown-menu dropdown-menu-sm dropdown-menu-right p-2" style="border-radius: 10px;">
                        <a href="parent_portal" class="dropdown-item text-muted d-flex"><span class="material-symbols-outlined mr-2">dashboard</span> Portal</a>
                        <a href="parent_profile" class="dropdown-item text-muted d-flex"><span class="material-symbols-outlined mr-2">person</span> Profile</a>
                        <a href="logout" class="dropdown-item text-muted d-flex"><span class="material-symbols-outlined mr-2">logout</span> Logout</a>
                    </div>
                </li>
            </ul>
        </nav>

        <main class="container-fluid pt-3">
            <div class="d-flex justify-content-between align-items-center flex-wrap mb-3">
                <div>
                    <h4 class="font-weight-bold mb-1">Bus Tracking</h4>
                    <p class="text-muted mb-0">Live location for your child’s assigned bus</p>
                </div>
                <a href="parent_portal" class="btn btn-light d-flex align-items-center"><span class="material-symbols-outlined mr-1">arrow_back</span> Portal</a>
            </div>
            <div class="row">
                <div class="col-lg-4 mb-3">
                    <div class="tracking-panel">
                        <div class="form-group">
                            <label>Child</label>
                            <select class="form-control" id="studentSelect">
                                <?php foreach ($students as $student) { ?>
                                    <option value="<?= $student['id'] ?>">
                                        <?= htmlspecialchars(trim($student['lastname'] . ' ' . $student['firstname'] . ' ' . $student['middlename'])) ?>
                                        <?= $student['classname'] ? ' - ' . htmlspecialchars($student['classname']) : '' ?>
                                    </option>
                                <?php } ?>
                            </select>
                        </div>
                        <div id="busInfo" class="mt-3"></div>
                    </div>
                </div>
                <div class="col-lg-8 mb-3">
                    <div class="tracking-panel">
                        <div id="parentBusMap"></div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <script src="../plugins/jquery/jquery.min.js"></script>
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script src="../dist/js/adminlte.min.js"></script>
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
    <script>
        const parentMapState = { map: null, marker: null, stopMarker: null, lastLocationId: 0, tripId: null, busId: null, settings: { update_interval_seconds: 20, stale_after_seconds: 90 } };

        function escapeHtml(value) {
            return String(value ?? '').replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[char]));
        }

        function initParentMap() {
            if (parentMapState.map || typeof L === 'undefined') return;
            parentMapState.map = L.map('parentBusMap').setView([9.082, 8.6753], 6);
            L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                maxZoom: 19,
                attribution: '&copy; OpenStreetMap contributors'
            }).addTo(parentMapState.map);
        }

        function animateMarker(marker, nextLatLng) {
            const start = marker.getLatLng();
            let current = 0;
            const steps = 20;
            const timer = setInterval(function() {
                current += 1;
                marker.setLatLng([
                    start.lat + ((nextLatLng[0] - start.lat) * current / steps),
                    start.lng + ((nextLatLng[1] - start.lng) * current / steps)
                ]);
                if (current >= steps) clearInterval(timer);
            }, 35);
        }

        function updateBusMarker(bus) {
            initParentMap();
            if (!parentMapState.map || !bus || !bus.latitude || !bus.longitude) return;
            const latLng = [Number(bus.latitude), Number(bus.longitude)];
            const popup = '<strong>' + escapeHtml(bus.bus_name) + '</strong><br>Last update: ' + escapeHtml(bus.recorded_at || 'Unknown');
            if (parentMapState.marker) {
                animateMarker(parentMapState.marker, latLng);
                parentMapState.marker.setPopupContent(popup);
            } else {
                parentMapState.marker = L.marker(latLng).addTo(parentMapState.map).bindPopup(popup);
                parentMapState.map.setView(latLng, 15);
            }

            if (bus.stop_latitude && bus.stop_longitude && !parentMapState.stopMarker) {
                parentMapState.stopMarker = L.circleMarker([Number(bus.stop_latitude), Number(bus.stop_longitude)], {
                    radius: 8,
                    color: '#007bff',
                    fillColor: '#007bff',
                    fillOpacity: 0.3
                }).addTo(parentMapState.map).bindPopup(escapeHtml(bus.stop_name || 'Assigned stop'));
            }
        }

        function renderBusInfo(bus) {
            if (!bus) {
                $('#busInfo').html('<div class="empty-state">No bus has been assigned to this child yet.</div>');
                return;
            }
            const seconds = Number(bus.seconds_since_update || 0);
            const stale = !bus.recorded_at || seconds > Number(parentMapState.settings.stale_after_seconds || 90);
            const status = stale ? '<span class="status-pill muted">Waiting for update</span>' : '<span class="status-pill good">Live</span>';
            $('#busInfo').html(
                '<div class="mb-3">' + status + '</div>' +
                '<div class="mb-3"><p class="metric-label">Bus</p><strong>' + escapeHtml(bus.bus_name || '') + '</strong><div class="text-muted small">' + escapeHtml(bus.bus_number || bus.plate_number || '') + '</div></div>' +
                '<div class="mb-3"><p class="metric-label">Driver</p><strong>' + escapeHtml(bus.driver_name || 'Not assigned') + '</strong><div class="text-muted small">' + escapeHtml(bus.driver_phone || '') + '</div></div>' +
                '<div class="mb-3"><p class="metric-label">Direction</p><strong>' + escapeHtml((bus.direction || 'No active trip').replace('_', ' ')) + '</strong></div>' +
                '<div class="mb-3"><p class="metric-label">Stop</p><strong>' + escapeHtml(bus.stop_name || 'Not set') + '</strong></div>' +
                '<div><p class="metric-label">Last updated</p><strong>' + escapeHtml(bus.recorded_at || 'No location yet') + '</strong></div>'
            );
        }

        function loadParentSnapshot() {
            const studentId = $('#studentSelect').val();
            if (!studentId) {
                $('#busInfo').html('<div class="empty-state">No child is available on this parent account.</div>');
                return;
            }
            $.ajax({
                url: '../bus_controller.php',
                method: 'POST',
                dataType: 'json',
                data: { action: 'parent_snapshot', student_id: studentId }
            }).done(function(resp) {
                if (resp.status !== '1') return toastr.error(resp.err || 'Unable to load bus');
                parentMapState.settings = resp.settings || parentMapState.settings;
                renderBusInfo(resp.bus);
                updateBusMarker(resp.bus);
                if (resp.bus && resp.bus.trip_id && resp.bus.last_location_id) {
                    parentMapState.tripId = resp.bus.trip_id;
                    parentMapState.busId = resp.bus.bus_id;
                    parentMapState.lastLocationId = Number(resp.bus.last_location_id);
                }
            }).fail(function(xhr) {
                toastr.error((xhr.responseJSON && xhr.responseJSON.err) || 'Unable to load bus');
            });
        }

        function loadTripUpdates() {
            const studentId = $('#studentSelect').val();
            if (!parentMapState.tripId || !parentMapState.busId || !studentId) return loadParentSnapshot();
            $.ajax({
                url: '../bus_controller.php',
                method: 'POST',
                dataType: 'json',
                data: {
                    action: 'trip_updates',
                    trip_id: parentMapState.tripId,
                    bus_id: parentMapState.busId,
                    since_id: parentMapState.lastLocationId,
                    student_id: studentId
                }
            }).done(function(resp) {
                if (resp.status !== '1') return loadParentSnapshot();
                if (!resp.locations || !resp.locations.length) return loadParentSnapshot();
                const latest = resp.locations[resp.locations.length - 1];
                parentMapState.lastLocationId = Number(latest.id);
                updateBusMarker({ latitude: latest.latitude, longitude: latest.longitude, recorded_at: latest.recorded_at, bus_name: 'Assigned bus' });
                loadParentSnapshot();
            }).fail(loadParentSnapshot);
        }

        $('#studentSelect').on('change', function() {
            parentMapState.lastLocationId = 0;
            parentMapState.tripId = null;
            parentMapState.busId = null;
            if (parentMapState.marker) {
                parentMapState.map.removeLayer(parentMapState.marker);
                parentMapState.marker = null;
            }
            if (parentMapState.stopMarker) {
                parentMapState.map.removeLayer(parentMapState.stopMarker);
                parentMapState.stopMarker = null;
            }
            loadParentSnapshot();
        });

        $(function() {
            initParentMap();
            loadParentSnapshot();
            setInterval(loadTripUpdates, Math.max(15, Number(parentMapState.settings.update_interval_seconds || 20)) * 1000);
        });
    </script>
</body>

</html>
