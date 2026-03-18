<?php
// api/activate.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once __DIR__ . '/../db_connect.php';

$input = json_decode(file_get_contents('php://input'), true) ?: $_POST;

$license_key = $input['license_key'] ?? '';
$hardware_id = $input['hardware_id'] ?? '';
$device_name = $input['device_name'] ?? 'Classroom PC';

if (empty($license_key) || empty($hardware_id)) {
    http_response_code(400);
    die(json_encode(['success' => false, 'message' => 'Missing required parameters']));
}

try {
    // 1. Find License
    $stmt = $pdo->prepare("SELECT id, is_active, max_devices FROM schools WHERE license_key = ?");
    $stmt->execute([$license_key]);
    $school = $stmt->fetch(PDO::FETCH_ASSOC);

    if (!$school) {
        http_response_code(404);
        die(json_encode(['success' => false, 'message' => 'Invalid License Key']));
    }

    if (!$school['is_active']) {
        http_response_code(403);
        die(json_encode(['success' => false, 'message' => 'License suspended. Contact Support.']));
    }

    // 2. Device Registration Logic
    $stmtDevice = $pdo->prepare("SELECT id FROM devices WHERE school_id = ? AND hardware_id = ?");
    $stmtDevice->execute([$school['id'], $hardware_id]);
    $existingDevice = $stmtDevice->fetch();

    if (!$existingDevice) {
        // Enforce Max Devices Check
        $stmtCount = $pdo->prepare("SELECT COUNT(*) FROM devices WHERE school_id = ?");
        $stmtCount->execute([$school['id']]);
        $currentCount = (int)$stmtCount->fetchColumn();

        if ($currentCount >= (int)$school['max_devices']) {
            http_response_code(403);
            die(json_encode(['success' => false, 'message' => 'Device Limit Reached. Max allowed: ' . $school['max_devices']]));
        }

        // Register new device
        $deviceIdStr = empty($device_name) ? "Device-" . substr(md5($hardware_id), 0, 8) : $device_name;
        $pdo->prepare("INSERT INTO devices (school_id, hardware_id, device_name) VALUES (?, ?, ?)")
            ->execute([$school['id'], $hardware_id, $deviceIdStr]);
    } else {
        // Update check-in time for existing device
        $pdo->prepare("UPDATE devices SET last_check_in = CURRENT_TIMESTAMP WHERE id = ?")->execute([$existingDevice['id']]);
    }

    // 3. Generate Activation Token
    // In a real production system, this would be a JWT or signed payload. 
    // Here we use a generic signed token since local validation relies mostly on expiry dates.
    $token = hash_hmac('sha256', $license_key . $hardware_id . time(), 'A$$3ssHub_Cloud_Secret');

    // Default 1 year expiry for demo purposes. This could be fetched from schools table later.
    $expiry_date = date('Y-m-d H:i:s', strtotime('+1 year'));

    echo json_encode([
        'success' => true,
        'message' => 'Device activated successfully',
        'token' => $token,
        'expiry_date' => $expiry_date
    ]);
} catch (PDOException $e) {
    error_log("Activation DB Error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Internal Server Error']);
}
