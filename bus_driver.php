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

if (!transport_is_staff_user()) {
    header("Location: parent_portal");
    exit();
}

if (!transport_can_open_driver_page() && !transport_is_admin()) {
    header("Location: dashboard");
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Driver Tracking | <?= get_staff_fullname_by_id($_SESSION['userid']) ?></title>

    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700&display=fallback">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="../plugins/fontawesome-free/css/all.min.css">
    <link rel="stylesheet" href="../plugins/toastr/toastr.min.css">
    <link rel="stylesheet" href="../dist/css/adminlte.css">
    <style>
        body {
            background: #f4f7fa;
        }

        .driver-shell {
            margin: 0 auto;
            max-width: 760px;
            padding: 18px;
        }

        .driver-card {
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.08);
            padding: 18px;
        }

        .driver-status-grid {
            display: grid;
            gap: 10px;
            grid-template-columns: repeat(auto-fit, minmax(140px, 1fr));
        }

        .driver-status-tile {
            background: #f8fafc;
            border: 1px solid #e9eef5;
            border-radius: 8px;
            padding: 12px;
        }

        .driver-status-tile p {
            color: #6c757d;
            font-size: 0.82rem;
            margin-bottom: 4px;
        }

        .driver-status-tile strong {
            display: block;
            font-size: 1rem;
            word-break: break-word;
        }

        .driver-actions {
            display: grid;
            gap: 10px;
            grid-template-columns: 1fr 1fr;
        }

        .driver-actions .btn {
            min-height: 54px;
        }

        @media (max-width: 575.98px) {
            .driver-actions {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
    <div class="driver-shell">
        <div class="d-flex align-items-center justify-content-between mb-3">
            <div>
                <h4 class="font-weight-bold mb-1">Driver Tracking</h4>
                <p class="text-muted mb-0"><?= $_SESSION['school_name'] ?></p>
            </div>
            <a href="logout" class="btn btn-light">Logout</a>
        </div>

        <div class="driver-card mb-3">
            <h5 class="font-weight-bold mb-2">Start Your Bus Trip</h5>
            <p class="text-muted">Choose your bus, tap Start Tracking, and keep this page open until the trip is finished.</p>
            <form id="driverTripForm">
                <div class="form-group">
                    <label>Bus</label>
                    <select class="form-control" id="driver_bus_id" required></select>
                </div>
                <div class="form-group">
                    <label>Route direction</label>
                    <select class="form-control" id="driver_direction">
                        <option value="to_school">Going to school</option>
                        <option value="to_home">Going home</option>
                    </select>
                </div>
                <input type="hidden" id="driver_route_id">
                <div class="driver-actions">
                    <button class="btn btn-success btn-lg font-weight-bold" type="submit" id="startTripBtn">Start Tracking</button>
                    <button class="btn btn-danger btn-lg font-weight-bold" type="button" id="stopTripBtn" disabled>Stop Tracking</button>
                </div>
                <button class="btn btn-outline-primary btn-block mt-2" type="button" id="sendLocationNowBtn" disabled>Send current location now</button>
            </form>
        </div>

        <div class="driver-card">
            <h5 class="font-weight-bold mb-3">Tracking Status</h5>
            <div class="driver-status-grid">
                <div class="driver-status-tile"><p>Trip</p><strong id="driverTripStatus">Not started</strong></div>
                <div class="driver-status-tile"><p>GPS accuracy</p><strong id="driverAccuracy">Waiting</strong></div>
                <div class="driver-status-tile"><p>Last sent</p><strong id="driverLastSent">Never</strong></div>
                <div class="driver-status-tile"><p>Status</p><strong id="driverServerStatus">Idle</strong></div>
            </div>
            <div class="alert alert-light border mt-3 mb-0">
                Location is shared only while tracking is started. If accuracy is rejected, move near a window or outdoors and send again.
            </div>
        </div>
    </div>

    <script src="../plugins/jquery/jquery.min.js"></script>
    <script src="../plugins/bootstrap/js/bootstrap.bundle.min.js"></script>
    <script src="../plugins/toastr/toastr.min.js"></script>
    <script src="../dist/js/adminlte.min.js"></script>
    <script>
        const state = { buses: [], settings: {} };
        const driverState = { tripId: null, watchId: null, latestPosition: null, sendTimer: null, lastSentAt: 0, lastSentPoint: null };

        function escapeHtml(value) {
            return String(value ?? '').replace(/[&<>"']/g, char => ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' }[char]));
        }

        function postTransport(data) {
            return $.ajax({ url: '../bus_controller.php', method: 'POST', data, dataType: 'json' });
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

        function fillBusOptions() {
            if (!state.buses.length) {
                $('#driver_bus_id').html('<option value="">No assigned bus</option>');
                $('#startTripBtn').prop('disabled', true);
                $('#driverServerStatus').text('No assigned bus');
                return;
            }

            let html = '<option value="">Select your bus</option>';
            state.buses.forEach(bus => {
                const label = bus.bus_name + (bus.bus_number ? ' - ' + bus.bus_number : '');
                html += '<option value="' + bus.id + '" data-route="' + (bus.active_route_id || '') + '" data-direction="' + (bus.active_direction || '') + '">' + escapeHtml(label) + '</option>';
            });
            $('#driver_bus_id').html(html);
            if (state.buses.length === 1) {
                $('#driver_bus_id').val(state.buses[0].id).trigger('change');
            }
        }

        function hydrateActiveDriverTrip() {
            const active = state.buses.find(bus => bus.active_trip_id);
            if (!active) return;
            $('#driver_bus_id').val(active.id);
            $('#driver_route_id').val(active.active_route_id || '');
            $('#driver_direction').val(active.active_direction || 'to_home');
            driverState.tripId = active.active_trip_id;
            $('#driverTripStatus').text('Active trip #' + driverState.tripId + ' ready');
            $('#startTripBtn').text('Resume GPS').prop('disabled', false);
            $('#stopTripBtn').prop('disabled', false);
            $('#sendLocationNowBtn').prop('disabled', false);
        }

        function loadDriverContext() {
            postTransport({ action: 'driver_context' }).done(function(resp) {
                state.buses = resp.buses || [];
                state.settings = resp.settings || {};
                fillBusOptions();
                hydrateActiveDriverTrip();
            }).fail(function(xhr) {
                $('#driverServerStatus').text((xhr.responseJSON && xhr.responseJSON.err) || 'Unable to load buses');
            });
        }

        function updateDriverPosition(position) {
            driverState.latestPosition = {
                latitude: position.coords.latitude,
                longitude: position.coords.longitude,
                accuracy: position.coords.accuracy,
                speed: position.coords.speed,
                heading: position.coords.heading
            };
            $('#driverAccuracy').text(Math.round(position.coords.accuracy || 0) + 'm');
            $('#driverServerStatus').text('GPS fix received');
        }

        function startWatchingPosition() {
            if (!navigator.geolocation) {
                $('#driverServerStatus').text('GPS not supported');
                return;
            }
            if (driverState.watchId !== null) navigator.geolocation.clearWatch(driverState.watchId);
            $('#driverServerStatus').text('Waiting for GPS permission');
            navigator.geolocation.getCurrentPosition(function(position) {
                updateDriverPosition(position);
                sendDriverLocation(true);
            }, function(error) {
                $('#driverServerStatus').text(error.message || 'GPS permission/location error');
            }, { enableHighAccuracy: true, maximumAge: 0, timeout: 20000 });
            driverState.watchId = navigator.geolocation.watchPosition(function(position) {
                updateDriverPosition(position);
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
            $('#sendLocationNowBtn').prop('disabled', true);
        }

        function driverSkipMessage(resp) {
            if (resp.reason === 'low_accuracy') {
                const actual = resp.accuracy_meters ? Math.round(Number(resp.accuracy_meters)) + 'm' : 'too low';
                const max = resp.max_accuracy_meters ? Math.round(Number(resp.max_accuracy_meters)) + 'm' : 'current limit';
                return 'GPS accuracy ' + actual + '; limit is ' + max;
            }
            if (resp.reason === 'throttled') return 'Waiting for update interval';
            if (resp.reason === 'minimal_movement') return 'Skipped: bus has barely moved';
            return resp.reason || 'Skipped';
        }

        function sendDriverLocation(force = false) {
            if (!driverState.tripId) return;
            if (!driverState.latestPosition) {
                $('#driverServerStatus').text('No GPS fix yet');
                return;
            }
            const now = Date.now();
            const intervalMs = Math.max(15, Number(state.settings.update_interval_seconds || 20)) * 1000;
            const minMovement = Math.max(0, Number(state.settings.min_movement_meters || 30));
            const point = { latitude: driverState.latestPosition.latitude, longitude: driverState.latestPosition.longitude };
            if (!force && (now - driverState.lastSentAt) < intervalMs) return;
            if (!force && driverDistanceMeters(driverState.lastSentPoint, point) < minMovement && driverState.lastSentAt > 0) return;

            $('#driverServerStatus').text('Sending location');
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
                    $('#driverServerStatus').text(driverSkipMessage(resp));
                }
            }).fail(function(xhr) {
                $('#driverServerStatus').text((xhr.responseJSON && xhr.responseJSON.err) || 'Send failed');
            });
        }

        $('#driver_bus_id').on('change', function() {
            const selected = state.buses.find(bus => Number(bus.id) === Number(this.value));
            $('#driver_route_id').val(selected ? (selected.active_route_id || '') : '');
            if (selected && selected.active_direction) $('#driver_direction').val(selected.active_direction);
        });

        $('#driverTripForm').on('submit', function(event) {
            event.preventDefault();
            const busId = $('#driver_bus_id').val();
            if (!busId) return toastr.error('Select your bus');
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
                $('#sendLocationNowBtn').prop('disabled', false);
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
                $('#startTripBtn').text('Start Tracking').prop('disabled', false);
                $('#stopTripBtn').prop('disabled', true);
                toastr.success(resp.msg || 'Trip stopped');
                loadDriverContext();
            }).fail(function(xhr) {
                toastr.error((xhr.responseJSON && xhr.responseJSON.err) || 'Unable to stop trip');
            });
        });

        $('#sendLocationNowBtn').on('click', function() {
            if (!driverState.tripId) return toastr.error('Start or resume a trip first');
            if (!navigator.geolocation) return toastr.error('GPS is not supported in this browser');
            $('#driverServerStatus').text('Requesting current location');
            navigator.geolocation.getCurrentPosition(function(position) {
                updateDriverPosition(position);
                sendDriverLocation(true);
            }, function(error) {
                $('#driverServerStatus').text(error.message || 'GPS permission/location error');
            }, { enableHighAccuracy: true, maximumAge: 0, timeout: 20000 });
        });

        $(loadDriverContext);
    </script>
</body>

</html>
