<?php
// Endpoint for Assesshub Desktop App to fetch config and feature toggles
header('Content-Type: application/json');
// Find config.php in several levels up
$config_paths = [__DIR__ . '/../../../config.php', __DIR__ . '/../../config.php', __DIR__ . '/../config.php'];
foreach ($config_paths as $path) {
    if (file_exists($path)) {
        require_once $path;
        break;
    }
}
if (!isset($db)) {
    http_response_code(500);
    die(json_encode(['success' => false, 'message' => 'Cloud Configuration Error: config.php not found.']));
}

// Only allow POST requests (with hardware_id) or GET (with Bearer token)
// For simplicity, we expect Bearer token in headers or 'license_key' via GET/POST
$license_key = $_GET['license'] ?? $_POST['license'] ?? '';

if (empty($license_key)) {
    http_response_code(401);
    die(json_encode(['success' => false, 'message' => 'Unauthorized: Missing license key']));
}

try {
    // $db is established via require_once '../../../config.php'

    // Find School
    $stmt = $db->prepare("SELECT * FROM schools WHERE license_key = ?");
    $stmt->execute([$license_key]);
    $school = $stmt->fetch();

    if (!$school) {
        http_response_code(404);
        die(json_encode(['success' => false, 'message' => 'Invalid license']));
    }

    if (!$school['is_active']) {
        http_response_code(403);
        die(json_encode(['success' => false, 'message' => 'License suspended. Contact Support.']));
    }

    // ── Device Registration & Limit Check ──
    $hwid = $_GET['hwid'] ?? $_POST['hwid'] ?? '';
    if (empty($hwid)) {
        http_response_code(400);
        die(json_encode(['success' => false, 'message' => 'Missing Hardware Identifier. Update Assesshub software.']));
    }

    // Check if this device is already registered
    $stmtDevice = $db->prepare("SELECT id FROM devices WHERE school_id = ? AND hardware_id = ?");
    $stmtDevice->execute([$school['id'], $hwid]);
    $existingDevice = $stmtDevice->fetch();

    if ($existingDevice) {
        // Device is verified. Update its last check-in.
        $db->prepare("UPDATE devices SET last_check_in = CURRENT_TIMESTAMP WHERE id = ?")->execute([$existingDevice['id']]);
    } else {
        // New Device: Check against Max Devices limit
        $stmtCount = $db->prepare("SELECT COUNT(*) FROM devices WHERE school_id = ?");
        $stmtCount->execute([$school['id']]);
        $currentCount = (int)$stmtCount->fetchColumn();

        if ($currentCount >= (int)$school['max_devices']) {
            http_response_code(403);
            die(json_encode(['success' => false, 'message' => 'Device Limit Reached. Max devices allowed: ' . $school['max_devices']]));
        }

        // Under limit: Register the new device
        $deviceIdStr = "Device-" . substr(md5($hwid), 0, 8);
        $db->prepare("INSERT INTO devices (school_id, hardware_id, device_name) VALUES (?, ?, ?)")
            ->execute([$school['id'], $hwid, $deviceIdStr]);
    }

    // Get active announcements
    $announcements = $db->query("SELECT message, message_type FROM global_announcements WHERE is_active = 1 ORDER BY created_at DESC")->fetchAll(PDO::FETCH_ASSOC);

    // Get latest app version
    $latest_version_row = $db->query("SELECT version_code, download_url, is_critical FROM app_versions ORDER BY id DESC LIMIT 1")->fetch(PDO::FETCH_ASSOC);

    $response = [
        'success' => true,
        'school_name' => $school['school_name'],
        'status' => 'active',
        'features' => [
            'ai_enabled' => (bool)$school['ai_enabled'],
            'ai_provider' => $school['ai_provider'],
            'ai_model' => $school['ai_model'],
            'ai_key' => $school['ai_key'], // Encrypted key ideally sent over HTTPS
            'sync_enabled' => (bool)$school['sync_enabled']
        ],
        'announcements' => $announcements,
        'updates' => [
            'latest_version' => $latest_version_row ? $latest_version_row['version_code'] : '1.0.0',
            'download_url' => $latest_version_row ? $latest_version_row['download_url'] : null,
            'is_critical' => $latest_version_row ? (bool)$latest_version_row['is_critical'] : false
        ]
    ];

    echo json_encode($response);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Server Configuration Error']);
}
