<?php
session_start();
// set timezone
date_default_timezone_set("africa/lagos");
header('Content-Type: application/json');
include_once 'model/connect.php';
include_once 'model/functions.php';

$school_id = isset($_SESSION['school_id']) ? $_SESSION['school_id'] : 0;
$user_id = isset($_SESSION['userid']) ? $_SESSION['userid'] : 0;

function get_status_label($status)
{
    switch ($status) {
        case 1:
            return 'Present';
        case 0:
            return 'Absent';
        case 2:
            return 'Late';
        case 3:
            return 'Half Day';
        default:
            return '-';
    }
}

function get_mode_label($mode)
{
    switch ($mode) {
        case 0:
            return 'Manual';
        case 1:
            return 'QR';
        case 2:
            return 'Self';
        default:
            return '-';
    }
}

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $action = isset($_POST['action']) ? $_POST['action'] : '';
    // Get today's attendance for a staff (for QR scan logic)
    if ($action === 'get_staff_today') {
        $staff_id = intval($_POST['staff_id']);
        $today = date('Y-m-d');
        $sql = "SELECT check_in, check_out FROM staff_attendance WHERE staff_id=? AND school_id=? AND date=? LIMIT 1";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('iis', $staff_id, $school_id, $today);
        $stmt->execute();
        $stmt->store_result();
        $data = null;
        if ($stmt->num_rows > 0) {
            $stmt->bind_result($check_in, $check_out);
            $stmt->fetch();
            $data = ['check_in' => $check_in, 'check_out' => $check_out];
        }
        echo json_encode(['status' => 1, 'data' => $data]);
        exit;
    }

    // QR staff attendance: log check-in or check-out
    if ($action === 'qr_staff_attendance') {
        $staff_id = intval($_POST['staff_id']);
        $now = date('Y-m-d H:i:s');
        $today = date('Y-m-d');
        $mode = 1; // QR
        $current_time = date('H:i');
        // exit;

        // Get current record
        $sql = "SELECT id, check_in, check_out FROM staff_attendance WHERE staff_id=? AND school_id=? AND date=?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('iis', $staff_id, $school_id, $today);
        $stmt->execute();
        $stmt->store_result();

        $status = 'Absent';
        $status_map = ['Present' => 1, 'Absent' => 0, 'Late' => 2, 'Half Day' => 3];
        if ($stmt->num_rows > 0) {
            $stmt->bind_result($att_id, $db_check_in, $db_check_out);
            $stmt->fetch();
            // If no check-in, set check-in
            if (empty($db_check_in)) {
                $db_check_in = $current_time;
                $db_check_out = null;
                $status = ($db_check_in > '08:00') ? 'Late' : 'Present';
                $status_val = $status_map[$status];
                $sql2 = "UPDATE staff_attendance SET check_in=?, check_out=NULL, status=?, mode=?, updated_at=?, updated_by=? WHERE id=?";
                $stmt2 = $conn->prepare($sql2);
                $stmt2->bind_param('siisii', $db_check_in, $status_val, $mode, $now, $user_id, $att_id);
                $ok = $stmt2->execute();
                if ($ok) {
                    echo json_encode(['status' => 1, 'message' => 'Check-in recorded']);
                } else {
                    echo json_encode(['status' => 0, 'message' => 'DB error']);
                }
                exit;
            }
            // If check-in exists but no check-out, set check-out
            if (!empty($db_check_in) && empty($db_check_out)) {
                $db_check_out = $current_time;
                $status = ($db_check_in > '08:00') ? 'Late' : 'Present';
                $status_val = $status_map[$status];
                $sql2 = "UPDATE staff_attendance SET check_out=?, status=?, mode=?, updated_at=?, updated_by=? WHERE id=?";
                $stmt2 = $conn->prepare($sql2);
                $stmt2->bind_param('siisii', $db_check_out, $status_val, $mode, $now, $user_id, $att_id);
                $ok = $stmt2->execute();
                if ($ok) {
                    echo json_encode(['status' => 1, 'message' => 'Check-out recorded']);
                } else {
                    echo json_encode(['status' => 0, 'message' => 'DB error']);
                }
                exit;
            }
            // If both check-in and check-out exist, prevent further marking
            echo json_encode(['status' => 2, 'message' => 'Attendance already completed for today.']);
            exit;
        } else {
            // Insert new record with check-in
            $db_check_in = $current_time;
            $status = ($db_check_in > '08:00') ? 'Late' : 'Present';
            $status_val = $status_map[$status];
            $sql2 = "INSERT INTO staff_attendance (staff_id, school_id, date, check_in, status, mode, created_at, updated_at, updated_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            $stmt2 = $conn->prepare($sql2);
            $stmt2->bind_param('iissiiisi', $staff_id, $school_id, $today, $db_check_in, $status_val, $mode, $now, $now, $user_id);
            $ok = $stmt2->execute();
            if ($ok) {
                echo json_encode(['status' => 1, 'message' => 'Check-in recorded']);
            } else {
                echo json_encode(['status' => 0, 'message' => 'DB error']);
            }
            exit;
        }
    }
    // Geolocation staff attendance: same logic as QR but with mode=2
    if ($action === 'geo_staff_attendance') {
        // Use logged-in user as staff
        $staff_id = intval($user_id);
        $lat = isset($_POST['lat']) ? $_POST['lat'] : null;
        $lng = isset($_POST['lng']) ? $_POST['lng'] : null;
        $now = date('Y-m-d H:i:s');
        $today = date('Y-m-d');
        $mode = 2; // Geolocation
        $current_time = date('H:i');

        // Get current record
        $sql = "SELECT id, check_in, check_out FROM staff_attendance WHERE staff_id=? AND school_id=? AND date=?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('iis', $staff_id, $school_id, $today);
        $stmt->execute();
        $stmt->store_result();

        $status = 'Absent';
        $status_map = ['Present' => 1, 'Absent' => 0, 'Late' => 2, 'Half Day' => 3];
        if ($stmt->num_rows > 0) {
            $stmt->bind_result($att_id, $db_check_in, $db_check_out);
            $stmt->fetch();
            // If no check-in, set check-in
            if (empty($db_check_in)) {
                $db_check_in = $current_time;
                $db_check_out = null;
                $status = ($db_check_in > '08:00') ? 'Late' : 'Present';
                $status_val = $status_map[$status];
                // Update; do not store lat/lng (DB schema not changed). If you want to store coords, we must alter table.
                $sql2 = "UPDATE staff_attendance SET check_in=?, check_out=NULL, status=?, mode=?, updated_at=?, updated_by=? WHERE id=?";
                $stmt2 = $conn->prepare($sql2);
                $stmt2->bind_param('siisii', $db_check_in, $status_val, $mode, $now, $user_id, $att_id);
                $ok = $stmt2->execute();
                if ($ok) {
                    echo json_encode(['status' => 1, 'message' => 'Check-in recorded']);
                } else {
                    echo json_encode(['status' => 0, 'message' => 'DB error']);
                }
                exit;
            }
            // If check-in exists but no check-out, set check-out
            if (!empty($db_check_in) && empty($db_check_out)) {
                $db_check_out = $current_time;
                $status = ($db_check_in > '08:00') ? 'Late' : 'Present';
                $status_val = $status_map[$status];
                $sql2 = "UPDATE staff_attendance SET check_out=?, status=?, mode=?, updated_at=?, updated_by=? WHERE id=?";
                $stmt2 = $conn->prepare($sql2);
                $stmt2->bind_param('siisii', $db_check_out, $status_val, $mode, $now, $user_id, $att_id);
                $ok = $stmt2->execute();
                if ($ok) {
                    echo json_encode(['status' => 1, 'message' => 'Check-out recorded']);
                } else {
                    echo json_encode(['status' => 0, 'message' => 'DB error']);
                }
                exit;
            }
            // If both check-in and check-out exist, prevent further marking
            echo json_encode(['status' => 2, 'message' => 'Attendance already completed for today.']);
            exit;
        } else {
            // Insert new record with check-in
             $db_check_in = $current_time;
            $status = ($db_check_in > '08:00') ? 'Late' : 'Present';
            $status_val = $status_map[$status];
            $sql2 = "INSERT INTO staff_attendance (staff_id, school_id, date, check_in, status, mode, created_at, updated_at, updated_by) VALUES ('$staff_id', '$school_id', '$today', '$db_check_in', '$status_val', '$mode', '$now', '$now', '$user_id')";
            if (mysqli_query($conn, $sql2)) {
                echo json_encode(['status' => 1, 'message' => 'Check-in recorded']);
            } else {
                echo json_encode(['status' => 0, 'message' => 'DB error: ' . mysqli_error($conn)]);
            }
            exit;
            // $db_check_in = $current_time;
            // $status = ($db_check_in > '08:00') ? 'Late' : 'Present';
            // $status_val = $status_map[$status];
            // echo $sql2 = "INSERT INTO staff_attendance (staff_id, school_id, date, check_in, status, mode, created_at, updated_at, updated_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            // $stmt2 = $conn->prepare($sql2);
            // $stmt2->bind_param('iissiiisi', $staff_id, $school_id, $today, $db_check_in, $status_val, $mode, $now, $now, $user_id);
            // $ok = $stmt2->execute();
            // if ($ok) {
            //     echo json_encode(['status' => 1, 'message' => 'Check-in recorded']);
            // } else {
            //     echo json_encode(['status' => 0, 'message' => 'DB error']);
            // }
            // exit;
        }
    }
    if ($action === 'manual_staff_attendance') {
        $staff_id = intval($_POST['staff_id']);
        $date = $_POST['date'];
        $check_in = isset($_POST['check_in']) && $_POST['check_in'] !== '' ? $_POST['check_in'] : null;
        $check_out = isset($_POST['check_out']) && $_POST['check_out'] !== '' ? $_POST['check_out'] : null;
        $status = $_POST['status'];
        $mode = 0; // manual
        $now = date('Y-m-d H:i:s');


        // Convert status string to int
        $status_map = ['Present' => 1, 'Absent' => 0, 'Late' => 2, 'Half Day' => 3];
        // Auto-detect status if both check_in and check_out are filled
        if ($check_in && $check_out) {
            if ($check_in > '08:00') {
                $status = 'Late';
            } else {
                $status = 'Present';
            }
        }
        $status_val = isset($status_map[$status]) ? $status_map[$status] : 0;

        // Check if record exists for staff/date
        $sql = "SELECT id FROM staff_attendance WHERE staff_id=? AND school_id=? AND date=?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('iis', $staff_id, $school_id, $date);
        $stmt->execute();
        $stmt->store_result();

        if ($stmt->num_rows > 0) {
            // Update
            $stmt->bind_result($att_id);
            $stmt->fetch();
            $sql2 = "UPDATE staff_attendance SET check_in=?, check_out=?, status=?, mode=?, updated_at=?, updated_by=? WHERE id=?";
            $stmt2 = $conn->prepare($sql2);
            // Use null for empty check_in/check_out
            $stmt2->bind_param(
                'ssiisii',
                $check_in,
                $check_out,
                $status_val,
                $mode,
                $now,
                $user_id,
                $att_id
            );
            // If check_in or check_out is null, use $stmt2->send_null() workaround
            if ($check_in === null) $stmt2->send_long_data(0, null);
            if ($check_out === null) $stmt2->send_long_data(1, null);
            $ok = $stmt2->execute();
        } else {
            // Insert
            $sql2 = "INSERT INTO staff_attendance (staff_id, school_id, date, check_in, check_out, status, mode, created_at, updated_at, updated_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
            $stmt2 = $conn->prepare($sql2);
            $stmt2->bind_param(
                'iisssiissi',
                $staff_id,
                $school_id,
                $date,
                $check_in,
                $check_out,
                $status_val,
                $mode,
                $now,
                $now,
                $user_id
            );
            if ($check_in === null) $stmt2->send_long_data(3, null);
            if ($check_out === null) $stmt2->send_long_data(4, null);
            $ok = $stmt2->execute();
        }
        if ($ok) {
            echo json_encode(['status' => 1, 'message' => 'Attendance saved']);
        } else {
            echo json_encode(['status' => 0, 'message' => 'DB error']);
        }
        exit;
    }
    // DataTable AJAX for all staff attendance
    if ($action === 'get_staff_attendance_range') {
        // Get date range and lateness time
        $start_date = isset($_POST['start_date']) ? $_POST['start_date'] : '';
        $end_date = isset($_POST['end_date']) ? $_POST['end_date'] : '';
        $lateness_time = isset($_POST['lateness_time']) ? $_POST['lateness_time'] : '08:00';
        if (!$start_date || !$end_date) {
            echo json_encode(['status' => 0, 'message' => 'Missing date range']);
            exit;
        }
        // Get all staff for this school
        $sql_staff = "SELECT id, CONCAT(lastname, ' ', firstname) as staff FROM staff WHERE school_id=? ORDER BY lastname, firstname";
        $stmt_staff = $conn->prepare($sql_staff);
        $stmt_staff->bind_param('i', $school_id);
        $stmt_staff->execute();
        $result_staff = $stmt_staff->get_result();
        $staff_list = [];
        while ($row = $result_staff->fetch_assoc()) {
            $staff_list[] = $row;
        }

        // Build date columns: only dates present in DB
        $dates = [];
        $sql_dates = "SELECT DISTINCT date FROM staff_attendance WHERE school_id=? AND date BETWEEN ? AND ? ORDER BY date";
        $stmt_dates = $conn->prepare($sql_dates);
        $stmt_dates->bind_param('iss', $school_id, $start_date, $end_date);
        $stmt_dates->execute();
        $result_dates = $stmt_dates->get_result();
        while ($row = $result_dates->fetch_assoc()) {
            $dates[] = $row['date'];
        }

        // Get all attendance records for staff in range (include check_in for lateness logic)
        $staff_ids = array_column($staff_list, 'id');
        $attendance = [];
        if (count($staff_ids) > 0) {
            $in = implode(',', array_fill(0, count($staff_ids), '?'));
            $types = str_repeat('i', count($staff_ids)) . 'i' . 'ss'; // add 'i' for school_id
            $params = array_merge($staff_ids, [$school_id, $start_date, $end_date]);
            $sql_att = "SELECT staff_id, date, status, check_in FROM staff_attendance WHERE staff_id IN ($in) AND school_id=? AND date BETWEEN ? AND ?";
            $stmt_att = $conn->prepare($sql_att);
            $bind_names = [];
            $bind_names[] = $types;
            foreach ($params as $k => $v) {
                $bind_names[] = &$params[$k];
            }
            call_user_func_array([$stmt_att, 'bind_param'], $bind_names);
            $stmt_att->execute();
            $result_att = $stmt_att->get_result();
            while ($row = $result_att->fetch_assoc()) {
                $attendance[$row['staff_id']][$row['date']] = [
                    'status' => $row['status'],
                    'check_in' => $row['check_in']
                ];
            }
        }

        // Build data for frontend: each row = staff, columns = dates, plus present/absent/late counts
        $data = [];
        foreach ($staff_list as $staff) {
            $row = [
                'staff' => $staff['staff'],
            ];
            $presentCount = 0;
            $absentCount = 0;
            $lateCount = 0;
            foreach ($dates as $date) {
                $att = isset($attendance[$staff['id']][$date]) ? $attendance[$staff['id']][$date] : null;
                if ($att) {
                    $status = intval($att['status']);
                    $check_in = $att['check_in'];
                    if ($status === 1 || $status === 2) { // Present or Late
                        $row[$date] = '✔️';
                        $presentCount++;
                        // Only count as late if check_in > lateness_time
                        if ($check_in && $check_in > $lateness_time) {
                            $lateCount++;
                        }
                    } else {
                        $row[$date] = '❌';
                        $absentCount++;
                    }
                } else {
                    $row[$date] = '❌';
                    $absentCount++;
                }
            }
            $row['presentCount'] = $presentCount;
            $row['absentCount'] = $absentCount;
            $row['lateCount'] = $lateCount;
            $data[] = $row;
        }

        echo json_encode([
            'status' => 1,
            'dates' => $dates,
            'data' => $data
        ]);
        exit;
    }
    // write code to accept   action: 'save_lateness_time',lateness_time: $('#lateness_time').val() and save the lateness time in the database table "school" in column "att_lateness_time"
    if ($action === 'save_lateness_time') {
        $lateness_time = $_POST['lateness_time'];
        if (!$lateness_time) {
            echo json_encode(['status' => 0, 'message' => 'Lateness time is required']);
            exit;
        }
        // Update school lateness time
        $sql = "UPDATE school SET att_lateness_time=? WHERE id=?";
        $stmt = $conn->prepare($sql);
        $stmt->bind_param('si', $lateness_time, $school_id);
        if ($stmt->execute()) {
            echo json_encode(['status' => 1, 'message' => 'Lateness time updated']);
        } else {
            echo json_encode(['status' => 0, 'message' => 'DB error']);
        }
        exit;
    }
    // DataTable AJAX for all staff attendance
    if ($action === 'get_staff_attendance') {
        // DataTables params
        $school_id = isset($_SESSION['school_id']) ? $_SESSION['school_id'] : 0;
        $draw = isset($_POST['draw']) ? intval($_POST['draw']) : 1;
        $start = isset($_POST['start']) ? intval($_POST['start']) : 0;
        $length = isset($_POST['length']) ? intval($_POST['length']) : 10;
        $search = isset($_POST['search']['value']) ? $_POST['search']['value'] : '';
        $orderable_columns = ['staff', 'date', 'check_in', 'check_out', 'status', 'mode'];
        $order_col = isset($_POST['order'][0]['column']) ? intval($_POST['order'][0]['column']) : 1;
        $order_dir = isset($_POST['order'][0]['dir']) && strtolower($_POST['order'][0]['dir']) === 'asc' ? 'ASC' : 'DESC';
        $order_by = isset($orderable_columns[$order_col]) ? $orderable_columns[$order_col] : 'staff';

        $where = "WHERE s.school_id=?";
        $params = [$school_id];
        $types = 'i';
        if ($search) {
            $where .= " AND (s.firstname LIKE ? OR s.lastname LIKE ?)";
            $params[] = "%$search%";
            $params[] = "%$search%";
            $types .= 'ss';
        }

        $attendance_date = isset($_POST['attendance_date']) && $_POST['attendance_date'] ? $_POST['attendance_date'] : date('Y-m-d');
        // Always show all staff for the selected date, even if no attendance record exists
        $safe_school_id = intval($school_id);
        $safe_start = intval($start);
        $safe_length = intval($length);
        $safe_order_by = in_array($order_by, $orderable_columns) ? $order_by : 'staff';
        $safe_order_dir = ($order_dir === 'ASC') ? 'ASC' : 'DESC';
        $where_sql = "WHERE s.school_id='$safe_school_id'";
        if ($search) {
            $safe_search = mysqli_real_escape_string($conn, $search);
            $where_sql .= " AND (s.firstname LIKE '%$safe_search%' OR s.lastname LIKE '%$safe_search%')";
        }
        $safe_attendance_date = mysqli_real_escape_string($conn, $attendance_date);
        $sql = "SELECT s.id as staff_id, CONCAT(s.lastname, ' ', s.firstname) as staff, s.photo, a.date, a.check_in, a.check_out, a.status, a.mode FROM staff s LEFT JOIN staff_attendance a ON a.staff_id = s.id AND a.school_id = s.school_id AND a.date = '$safe_attendance_date' $where_sql ORDER BY $safe_order_by $safe_order_dir LIMIT $safe_start, $safe_length";
        $result = $conn->query($sql);
        if (!$result) {
            echo json_encode(['status' => 0, 'message' => 'Query error: ' . $conn->error]);
            exit;
        }
        $data = [];
        while ($row = $result->fetch_assoc()) {
            $data[] = [
                'staff_id' => $row['staff_id'],
                'staff' => $row['staff'],
                'date' => $attendance_date,
                'check_in' => $row['check_in'],
                'check_out' => $row['check_out'],
                'status' => '',
                'mode' => get_mode_label($row['mode'])
            ];
        }

        // Get total records for DataTables pagination
        $sql2 = "SELECT COUNT(*) as total FROM staff s LEFT JOIN staff_attendance a ON a.staff_id = s.id AND a.school_id = s.school_id $where_sql";
        $result2 = $conn->query($sql2);
        $total = 0;
        if ($result2 && $row2 = $result2->fetch_assoc()) {
            $total = intval($row2['total']);
        }

        echo json_encode([
            'draw' => $draw,
            'recordsTotal' => $total,
            'recordsFiltered' => $total,
            'data' => $data
        ]);
        exit;
    }
}

// fallback
echo json_encode(['status' => 0, 'message' => 'Invalid request']);