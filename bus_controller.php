<?php
session_start();
include_once("model/connect.php");
include_once("model/functions.php");

header('Content-Type: application/json');

function bus_json($payload, $http_code = 200)
{
    http_response_code($http_code);
    echo json_encode($payload);
    exit;
}

function bus_require_login()
{
    if (!isset($_SESSION['userid']) || !isset($_SESSION['school_id'])) {
        bus_json(['status' => '0', 'err' => 'Login required'], 401);
    }
}

function bus_request($key, $default = '')
{
    if (isset($_POST[$key])) {
        return is_string($_POST[$key]) ? trim($_POST[$key]) : $_POST[$key];
    }

    if (isset($_GET[$key])) {
        return is_string($_GET[$key]) ? trim($_GET[$key]) : $_GET[$key];
    }

    return $default;
}

function bus_bind($stmt, $types, $params)
{
    if ($types === '' || empty($params)) {
        return true;
    }

    $refs = [$stmt, $types];
    foreach ($params as $key => $value) {
        $refs[] = &$params[$key];
    }

    return call_user_func_array('mysqli_stmt_bind_param', $refs);
}

function bus_fetch_all($sql, $types = '', $params = [])
{
    global $conn;

    $stmt = mysqli_prepare($conn, $sql);
    if (!$stmt) {
        bus_json(['status' => '0', 'err' => 'Database prepare failed'], 500);
    }

    bus_bind($stmt, $types, $params);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);
    $rows = [];

    while ($result && $row = mysqli_fetch_assoc($result)) {
        $rows[] = $row;
    }

    mysqli_stmt_close($stmt);
    return $rows;
}

function bus_fetch_one($sql, $types = '', $params = [])
{
    $rows = bus_fetch_all($sql, $types, $params);
    return $rows[0] ?? null;
}

function bus_execute($sql, $types = '', $params = [])
{
    global $conn;

    $stmt = mysqli_prepare($conn, $sql);
    if (!$stmt) {
        bus_json(['status' => '0', 'err' => 'Database prepare failed'], 500);
    }

    bus_bind($stmt, $types, $params);
    $ok = mysqli_stmt_execute($stmt);
    $affected = mysqli_stmt_affected_rows($stmt);
    $insert_id = mysqli_insert_id($conn);
    $error = mysqli_stmt_error($stmt);
    mysqli_stmt_close($stmt);

    if (!$ok) {
        bus_json(['status' => '0', 'err' => $error ?: 'Database write failed'], 500);
    }

    return ['affected' => $affected, 'insert_id' => $insert_id];
}

function bus_require_staff()
{
    if (!transport_is_staff_user()) {
        bus_json(['status' => '0', 'err' => 'Staff access required'], 403);
    }
}

function bus_require_admin()
{
    if (!transport_is_admin()) {
        bus_json(['status' => '0', 'err' => 'Transport admin access required'], 403);
    }
}

function bus_direction_or_fail($direction)
{
    if (!in_array($direction, ['to_school', 'to_home'], true)) {
        bus_json(['status' => '0', 'err' => 'Invalid route direction'], 422);
    }

    return $direction;
}

function bus_distance_meters($lat1, $lng1, $lat2, $lng2)
{
    $earth_radius = 6371000;
    $lat_delta = deg2rad($lat2 - $lat1);
    $lng_delta = deg2rad($lng2 - $lng1);
    $a = sin($lat_delta / 2) * sin($lat_delta / 2)
        + cos(deg2rad($lat1)) * cos(deg2rad($lat2))
        * sin($lng_delta / 2) * sin($lng_delta / 2);

    return $earth_radius * (2 * atan2(sqrt($a), sqrt(1 - $a)));
}

function bus_settings_payload($school_id)
{
    $settings = transport_get_tracking_settings($school_id);
    return [
        'update_interval_seconds' => $settings['update_interval_seconds'],
        'stale_after_seconds' => $settings['stale_after_seconds'],
        'min_movement_meters' => $settings['min_movement_meters'],
        'max_accuracy_meters' => $settings['max_accuracy_meters'],
        'history_retention_days' => $settings['history_retention_days'],
    ];
}

bus_require_login();

$action = bus_request('action');
$school_id = transport_current_school_id();
$user_id = transport_current_user_id();
$date = date('Y-m-d H:i:s');

switch ($action) {
    case 'get_settings':
        bus_require_staff();
        bus_json(['status' => '1', 'settings' => bus_settings_payload($school_id)]);

    case 'update_settings':
        bus_require_admin();
        $interval = max(15, (int) bus_request('update_interval_seconds', 20));
        $stale_after = max(30, (int) bus_request('stale_after_seconds', 90));
        $movement = max(0, (int) bus_request('min_movement_meters', 30));
        $accuracy = max(20, (int) bus_request('max_accuracy_meters', 100));
        $retention = max(1, (int) bus_request('history_retention_days', 30));

        bus_execute(
            "INSERT INTO bus_tracking_settings
             (school_id, update_interval_seconds, stale_after_seconds, min_movement_meters,
              max_accuracy_meters, history_retention_days, createdby, updatedby, datecreated, dateupdated)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE
              update_interval_seconds = VALUES(update_interval_seconds),
              stale_after_seconds = VALUES(stale_after_seconds),
              min_movement_meters = VALUES(min_movement_meters),
              max_accuracy_meters = VALUES(max_accuracy_meters),
              history_retention_days = VALUES(history_retention_days),
              updatedby = VALUES(updatedby),
              dateupdated = VALUES(dateupdated)",
            'iiiiiiiiss',
            [$school_id, $interval, $stale_after, $movement, $accuracy, $retention, $user_id, $user_id, $date, $date]
        );
        bus_json(['status' => '1', 'msg' => 'Tracking settings saved', 'settings' => bus_settings_payload($school_id)]);

    case 'list_buses':
        bus_require_staff();
        $rows = bus_fetch_all(
            "SELECT b.id, b.bus_name, b.bus_number, b.plate_number, b.driver_staff_id, b.assistant_staff_id,
                    b.driver_phone, b.capacity, b.status,
                    CONCAT(COALESCE(ds.firstname, ''), ' ', COALESCE(ds.lastname, '')) AS driver_name,
                    CONCAT(COALESCE(asst.firstname, ''), ' ', COALESCE(asst.lastname, '')) AS assistant_name
             FROM school_buses b
             LEFT JOIN staff ds ON ds.id = b.driver_staff_id AND ds.school_id = b.school_id
             LEFT JOIN staff asst ON asst.id = b.assistant_staff_id AND asst.school_id = b.school_id
             WHERE b.school_id = ?
             ORDER BY b.bus_name ASC",
            'i',
            [$school_id]
        );
        bus_json(['status' => '1', 'buses' => $rows]);

    case 'save_bus':
        bus_require_admin();
        $bus_id = (int) bus_request('bus_id', 0);
        $bus_name = bus_request('bus_name');
        if ($bus_name === '') {
            bus_json(['status' => '0', 'err' => 'Bus name is required'], 422);
        }
        $bus_number = bus_request('bus_number');
        $plate_number = bus_request('plate_number');
        $driver_staff_id = bus_request('driver_staff_id') === '' ? null : (int) bus_request('driver_staff_id');
        $assistant_staff_id = bus_request('assistant_staff_id') === '' ? null : (int) bus_request('assistant_staff_id');
        $driver_phone = bus_request('driver_phone');
        $capacity = bus_request('capacity') === '' ? null : (int) bus_request('capacity');
        $status = (int) bus_request('status', 1);

        if ($bus_id > 0) {
            bus_execute(
                "UPDATE school_buses
                 SET bus_name = ?, bus_number = ?, plate_number = ?, driver_staff_id = ?,
                     assistant_staff_id = ?, driver_phone = ?, capacity = ?, status = ?,
                     updatedby = ?, dateupdated = ?
                 WHERE id = ? AND school_id = ?",
                'sssiisiiisii',
                [$bus_name, $bus_number, $plate_number, $driver_staff_id, $assistant_staff_id, $driver_phone, $capacity, $status, $user_id, $date, $bus_id, $school_id]
            );
            bus_json(['status' => '1', 'msg' => 'Bus updated', 'bus_id' => $bus_id]);
        }

        $insert = bus_execute(
            "INSERT INTO school_buses
             (school_id, bus_name, bus_number, plate_number, driver_staff_id, assistant_staff_id,
              driver_phone, capacity, status, createdby, datecreated)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            'isssiisiiis',
            [$school_id, $bus_name, $bus_number, $plate_number, $driver_staff_id, $assistant_staff_id, $driver_phone, $capacity, $status, $user_id, $date]
        );
        bus_json(['status' => '1', 'msg' => 'Bus created', 'bus_id' => $insert['insert_id']]);

    case 'list_routes':
        bus_require_staff();
        $rows = bus_fetch_all(
            "SELECT id, route_name, description, to_school_label, to_home_label, route_polyline, status
             FROM bus_routes
             WHERE school_id = ?
             ORDER BY route_name ASC",
            'i',
            [$school_id]
        );
        bus_json(['status' => '1', 'routes' => $rows]);

    case 'save_route':
        bus_require_admin();
        $route_id = (int) bus_request('route_id', 0);
        $route_name = bus_request('route_name');
        if ($route_name === '') {
            bus_json(['status' => '0', 'err' => 'Route name is required'], 422);
        }
        $description = bus_request('description');
        $to_school_label = bus_request('to_school_label', 'Going to school');
        $to_home_label = bus_request('to_home_label', 'Going home');
        $route_polyline = bus_request('route_polyline');
        $status = (int) bus_request('status', 1);

        if ($route_id > 0) {
            bus_execute(
                "UPDATE bus_routes
                 SET route_name = ?, description = ?, to_school_label = ?, to_home_label = ?,
                     route_polyline = ?, status = ?, updatedby = ?, dateupdated = ?
                 WHERE id = ? AND school_id = ?",
                'sssssiisii',
                [$route_name, $description, $to_school_label, $to_home_label, $route_polyline, $status, $user_id, $date, $route_id, $school_id]
            );
            bus_json(['status' => '1', 'msg' => 'Route updated', 'route_id' => $route_id]);
        }

        $insert = bus_execute(
            "INSERT INTO bus_routes
             (school_id, route_name, description, to_school_label, to_home_label, route_polyline,
              status, createdby, datecreated)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
            'isssssiis',
            [$school_id, $route_name, $description, $to_school_label, $to_home_label, $route_polyline, $status, $user_id, $date]
        );
        bus_json(['status' => '1', 'msg' => 'Route created', 'route_id' => $insert['insert_id']]);

    case 'list_route_stops':
        bus_require_staff();
        $route_id = (int) bus_request('route_id', 0);
        $rows = bus_fetch_all(
            "SELECT id, route_id, stop_name, latitude, longitude, stop_order, status
             FROM bus_route_stops
             WHERE school_id = ? AND (? = 0 OR route_id = ?)
             ORDER BY route_id ASC, stop_order ASC, stop_name ASC",
            'iii',
            [$school_id, $route_id, $route_id]
        );
        bus_json(['status' => '1', 'stops' => $rows]);

    case 'save_route_stop':
        bus_require_admin();
        $stop_id = (int) bus_request('stop_id', 0);
        $route_id = (int) bus_request('route_id', 0);
        $stop_name = bus_request('stop_name');
        $latitude = (float) bus_request('latitude');
        $longitude = (float) bus_request('longitude');
        $stop_order = (int) bus_request('stop_order', 0);
        $status = (int) bus_request('status', 1);

        if ($route_id <= 0 || $stop_name === '' || abs($latitude) > 90 || abs($longitude) > 180) {
            bus_json(['status' => '0', 'err' => 'Valid route, stop name, latitude and longitude are required'], 422);
        }

        if ($stop_id > 0) {
            bus_execute(
                "UPDATE bus_route_stops
                 SET route_id = ?, stop_name = ?, latitude = ?, longitude = ?, stop_order = ?,
                     status = ?, updatedby = ?, dateupdated = ?
                 WHERE id = ? AND school_id = ?",
                'isddiiisii',
                [$route_id, $stop_name, $latitude, $longitude, $stop_order, $status, $user_id, $date, $stop_id, $school_id]
            );
            bus_json(['status' => '1', 'msg' => 'Stop updated', 'stop_id' => $stop_id]);
        }

        $insert = bus_execute(
            "INSERT INTO bus_route_stops
             (school_id, route_id, stop_name, latitude, longitude, stop_order, status, createdby, datecreated)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
            'iisddiiis',
            [$school_id, $route_id, $stop_name, $latitude, $longitude, $stop_order, $status, $user_id, $date]
        );
        bus_json(['status' => '1', 'msg' => 'Stop created', 'stop_id' => $insert['insert_id']]);

    case 'list_assignments':
        bus_require_staff();
        $rows = bus_fetch_all(
            "SELECT a.id, a.bus_id, a.route_id, a.stop_id, a.student_id, a.pickup_status, a.dropoff_status, a.status,
                    b.bus_name, r.route_name, st.stop_name,
                    CONCAT(s.lastname, ' ', s.firstname, ' ', COALESCE(s.middlename, '')) AS student_name,
                    c.classname
             FROM bus_student_assignments a
             INNER JOIN students s ON s.id = a.student_id AND s.school_id = a.school_id
             LEFT JOIN class c ON c.id = s.class_id AND c.school_id = s.school_id
             INNER JOIN school_buses b ON b.id = a.bus_id AND b.school_id = a.school_id
             LEFT JOIN bus_routes r ON r.id = a.route_id AND r.school_id = a.school_id
             LEFT JOIN bus_route_stops st ON st.id = a.stop_id AND st.school_id = a.school_id
             WHERE a.school_id = ?
             ORDER BY b.bus_name ASC, s.lastname ASC, s.firstname ASC",
            'i',
            [$school_id]
        );
        bus_json(['status' => '1', 'assignments' => $rows]);

    case 'save_assignment':
        bus_require_admin();
        $assignment_id = (int) bus_request('assignment_id', 0);
        $bus_id = (int) bus_request('bus_id', 0);
        $route_id = bus_request('route_id') === '' ? null : (int) bus_request('route_id');
        $stop_id = bus_request('stop_id') === '' ? null : (int) bus_request('stop_id');
        $student_id = (int) bus_request('student_id', 0);
        $status = (int) bus_request('status', 1);

        if ($bus_id <= 0 || $student_id <= 0) {
            bus_json(['status' => '0', 'err' => 'Bus and student are required'], 422);
        }

        if ($assignment_id > 0) {
            bus_execute(
                "UPDATE bus_student_assignments
                 SET bus_id = ?, route_id = ?, stop_id = ?, student_id = ?, status = ?,
                     updatedby = ?, dateupdated = ?
                 WHERE id = ? AND school_id = ?",
                'iiiiiisii',
                [$bus_id, $route_id, $stop_id, $student_id, $status, $user_id, $date, $assignment_id, $school_id]
            );
            bus_json(['status' => '1', 'msg' => 'Assignment updated', 'assignment_id' => $assignment_id]);
        }

        $insert = bus_execute(
            "INSERT INTO bus_student_assignments
             (school_id, bus_id, route_id, stop_id, student_id, status, createdby, datecreated)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            'iiiiiiis',
            [$school_id, $bus_id, $route_id, $stop_id, $student_id, $status, $user_id, $date]
        );
        bus_json(['status' => '1', 'msg' => 'Assignment created', 'assignment_id' => $insert['insert_id']]);

    case 'driver_context':
        bus_require_staff();
        $rows = bus_fetch_all(
            "SELECT id, bus_name, bus_number, plate_number
             FROM school_buses
             WHERE school_id = ? AND status = 1
             AND (? IN (1,2,3,4) OR driver_staff_id = ? OR assistant_staff_id = ?)
             ORDER BY bus_name ASC",
            'iiii',
            [$school_id, (int) ($_SESSION['staff_type'] ?? 0), $user_id, $user_id]
        );
        bus_json(['status' => '1', 'buses' => $rows, 'settings' => bus_settings_payload($school_id)]);

    case 'start_trip':
        bus_require_staff();
        $bus_id = (int) bus_request('bus_id', 0);
        $route_id = bus_request('route_id') === '' ? null : (int) bus_request('route_id');
        $direction = bus_direction_or_fail(bus_request('direction', 'to_home'));

        if (!transport_staff_can_track_bus($bus_id)) {
            bus_json(['status' => '0', 'err' => 'You cannot start tracking for this bus'], 403);
        }

        $active = bus_fetch_one(
            "SELECT id FROM bus_trips WHERE school_id = ? AND bus_id = ? AND trip_status = 'active' LIMIT 1",
            'ii',
            [$school_id, $bus_id]
        );
        if ($active) {
            bus_json(['status' => '1', 'msg' => 'Trip already active', 'trip_id' => $active['id']]);
        }

        $insert = bus_execute(
            "INSERT INTO bus_trips
             (school_id, bus_id, route_id, direction, trip_status, started_by, started_at,
              createdby, datecreated)
             VALUES (?, ?, ?, ?, 'active', ?, ?, ?, ?)",
            'iiisisis',
            [$school_id, $bus_id, $route_id, $direction, $user_id, $date, $user_id, $date]
        );
        bus_json(['status' => '1', 'msg' => 'Trip started', 'trip_id' => $insert['insert_id'], 'settings' => bus_settings_payload($school_id)]);

    case 'stop_trip':
        bus_require_staff();
        $trip_id = (int) bus_request('trip_id', 0);
        $trip = bus_fetch_one(
            "SELECT id, bus_id FROM bus_trips WHERE id = ? AND school_id = ? AND trip_status = 'active' LIMIT 1",
            'ii',
            [$trip_id, $school_id]
        );
        if (!$trip || !transport_staff_can_track_bus((int) $trip['bus_id'])) {
            bus_json(['status' => '0', 'err' => 'Active trip not found or access denied'], 403);
        }

        bus_execute(
            "UPDATE bus_trips
             SET trip_status = 'completed', stopped_by = ?, stopped_at = ?, updatedby = ?, dateupdated = ?
             WHERE id = ? AND school_id = ?",
            'isisii',
            [$user_id, $date, $user_id, $date, $trip_id, $school_id]
        );
        bus_json(['status' => '1', 'msg' => 'Trip stopped']);

    case 'submit_location':
        bus_require_staff();
        $trip_id = (int) bus_request('trip_id', 0);
        $latitude = (float) bus_request('latitude');
        $longitude = (float) bus_request('longitude');
        $accuracy = bus_request('accuracy_meters') === '' ? null : (float) bus_request('accuracy_meters');
        $speed = bus_request('speed_mps') === '' ? null : (float) bus_request('speed_mps');
        $heading = bus_request('heading_degrees') === '' ? null : (float) bus_request('heading_degrees');
        $battery = bus_request('battery_percent') === '' ? null : (int) bus_request('battery_percent');

        if ($trip_id <= 0 || abs($latitude) > 90 || abs($longitude) > 180) {
            bus_json(['status' => '0', 'err' => 'Valid trip and coordinates are required'], 422);
        }

        $trip = bus_fetch_one(
            "SELECT id, bus_id FROM bus_trips WHERE id = ? AND school_id = ? AND trip_status = 'active' LIMIT 1",
            'ii',
            [$trip_id, $school_id]
        );
        if (!$trip || !transport_staff_can_track_bus((int) $trip['bus_id'])) {
            bus_json(['status' => '0', 'err' => 'Active trip not found or access denied'], 403);
        }

        $settings = transport_get_tracking_settings($school_id);
        if ($accuracy !== null && $accuracy > $settings['max_accuracy_meters']) {
            bus_json(['status' => '1', 'accepted' => false, 'reason' => 'low_accuracy']);
        }

        $current = bus_fetch_one(
            "SELECT latitude, longitude, recorded_at
             FROM bus_current_locations
             WHERE school_id = ? AND bus_id = ? AND trip_id = ?
             LIMIT 1",
            'iii',
            [$school_id, (int) $trip['bus_id'], $trip_id]
        );

        if ($current) {
            $seconds_since_last = time() - strtotime($current['recorded_at']);
            $distance = bus_distance_meters((float) $current['latitude'], (float) $current['longitude'], $latitude, $longitude);

            if ($seconds_since_last < $settings['update_interval_seconds']) {
                bus_json(['status' => '1', 'accepted' => false, 'reason' => 'throttled']);
            }

            if ($distance < $settings['min_movement_meters'] && $seconds_since_last < ($settings['update_interval_seconds'] * 3)) {
                bus_json(['status' => '1', 'accepted' => false, 'reason' => 'minimal_movement']);
            }
        }

        $location = bus_execute(
            "INSERT INTO bus_locations
             (school_id, bus_id, trip_id, latitude, longitude, accuracy_meters, speed_mps,
              heading_degrees, battery_percent, recorded_at, createdby, datecreated)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
            'iiidddddisis',
            [$school_id, (int) $trip['bus_id'], $trip_id, $latitude, $longitude, $accuracy, $speed, $heading, $battery, $date, $user_id, $date]
        );

        bus_execute(
            "INSERT INTO bus_current_locations
             (school_id, bus_id, trip_id, last_location_id, latitude, longitude, accuracy_meters,
              speed_mps, heading_degrees, battery_percent, recorded_at, dateupdated)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
             ON DUPLICATE KEY UPDATE
              trip_id = VALUES(trip_id),
              last_location_id = VALUES(last_location_id),
              latitude = VALUES(latitude),
              longitude = VALUES(longitude),
              accuracy_meters = VALUES(accuracy_meters),
              speed_mps = VALUES(speed_mps),
              heading_degrees = VALUES(heading_degrees),
              battery_percent = VALUES(battery_percent),
              recorded_at = VALUES(recorded_at),
              dateupdated = VALUES(dateupdated)",
            'iiiidddddiss',
            [$school_id, (int) $trip['bus_id'], $trip_id, (int) $location['insert_id'], $latitude, $longitude, $accuracy, $speed, $heading, $battery, $date, $date]
        );

        bus_json(['status' => '1', 'accepted' => true, 'location_id' => $location['insert_id'], 'recorded_at' => $date]);

    case 'staff_snapshot':
        bus_require_staff();
        $settings = transport_get_tracking_settings($school_id);
        $rows = bus_fetch_all(
            "SELECT b.id AS bus_id, b.bus_name, b.bus_number, b.plate_number, b.driver_phone,
                    CONCAT(COALESCE(ds.firstname, ''), ' ', COALESCE(ds.lastname, '')) AS driver_name,
                    t.id AS trip_id, t.direction, t.trip_status, t.started_at,
                    r.route_name,
                    cl.last_location_id, cl.latitude, cl.longitude, cl.accuracy_meters,
                    cl.speed_mps, cl.heading_degrees, cl.recorded_at,
                    TIMESTAMPDIFF(SECOND, cl.recorded_at, NOW()) AS seconds_since_update
             FROM school_buses b
             LEFT JOIN staff ds ON ds.id = b.driver_staff_id AND ds.school_id = b.school_id
             LEFT JOIN bus_trips t ON t.bus_id = b.id AND t.school_id = b.school_id AND t.trip_status = 'active'
             LEFT JOIN bus_routes r ON r.id = t.route_id AND r.school_id = b.school_id
             LEFT JOIN bus_current_locations cl ON cl.bus_id = b.id AND cl.school_id = b.school_id
             WHERE b.school_id = ? AND b.status = 1
             ORDER BY b.bus_name ASC",
            'i',
            [$school_id]
        );
        bus_json(['status' => '1', 'buses' => $rows, 'settings' => $settings]);

    case 'parent_snapshot':
        if (transport_is_staff_user()) {
            bus_json(['status' => '0', 'err' => 'Parent access required'], 403);
        }
        $student_id = (int) bus_request('student_id', 0);
        if (!transport_parent_can_view_student($student_id)) {
            bus_json(['status' => '0', 'err' => 'Student not found'], 403);
        }
        $rows = bus_fetch_all(
            "SELECT b.id AS bus_id, b.bus_name, b.bus_number, b.plate_number, b.driver_phone,
                    CONCAT(COALESCE(ds.firstname, ''), ' ', COALESCE(ds.lastname, '')) AS driver_name,
                    a.pickup_status, a.dropoff_status,
                    st.stop_name, st.latitude AS stop_latitude, st.longitude AS stop_longitude,
                    t.id AS trip_id, t.direction, t.trip_status, t.started_at,
                    r.route_name,
                    cl.last_location_id, cl.latitude, cl.longitude, cl.accuracy_meters,
                    cl.speed_mps, cl.heading_degrees, cl.recorded_at,
                    TIMESTAMPDIFF(SECOND, cl.recorded_at, NOW()) AS seconds_since_update
             FROM bus_student_assignments a
             INNER JOIN school_buses b ON b.id = a.bus_id AND b.school_id = a.school_id
             INNER JOIN students s ON s.id = a.student_id AND s.school_id = a.school_id
             LEFT JOIN staff ds ON ds.id = b.driver_staff_id AND ds.school_id = b.school_id
             LEFT JOIN bus_route_stops st ON st.id = a.stop_id AND st.school_id = a.school_id
             LEFT JOIN bus_trips t ON t.bus_id = b.id AND t.school_id = b.school_id AND t.trip_status = 'active'
             LEFT JOIN bus_routes r ON r.id = t.route_id AND r.school_id = a.school_id
             LEFT JOIN bus_current_locations cl ON cl.bus_id = b.id AND cl.school_id = a.school_id
             WHERE a.school_id = ? AND a.student_id = ? AND s.parent_id = ? AND a.status = 1
             LIMIT 1",
            'iii',
            [$school_id, $student_id, $user_id]
        );
        bus_json(['status' => '1', 'bus' => $rows[0] ?? null, 'settings' => bus_settings_payload($school_id)]);

    case 'trip_updates':
        $trip_id = (int) bus_request('trip_id', 0);
        $bus_id = (int) bus_request('bus_id', 0);
        $since_id = (int) bus_request('since_id', 0);

        $trip = bus_fetch_one(
            "SELECT id, bus_id FROM bus_trips WHERE id = ? AND school_id = ? LIMIT 1",
            'ii',
            [$trip_id, $school_id]
        );
        if (!$trip || (int) $trip['bus_id'] !== $bus_id) {
            bus_json(['status' => '0', 'err' => 'Trip not found'], 404);
        }

        $allowed = transport_is_staff_user()
            ? transport_staff_can_view_bus($bus_id)
            : transport_parent_can_view_bus($bus_id, bus_request('student_id') === '' ? null : (int) bus_request('student_id'));

        if (!$allowed) {
            bus_json(['status' => '0', 'err' => 'Access denied'], 403);
        }

        $rows = bus_fetch_all(
            "SELECT id, latitude, longitude, accuracy_meters, speed_mps, heading_degrees, recorded_at
             FROM bus_locations
             WHERE school_id = ? AND trip_id = ? AND id > ?
             ORDER BY id ASC
             LIMIT 100",
            'iii',
            [$school_id, $trip_id, $since_id]
        );
        bus_json(['status' => '1', 'locations' => $rows]);

    default:
        bus_json(['status' => '0', 'err' => 'Unknown action'], 400);
}
