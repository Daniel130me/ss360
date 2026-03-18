<?php
// activate.php - Handle License Activation
header('Content-Type: application/json');
require_once 'db_connect.php';
// Only allow POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    die(json_encode(['success' => false, 'message' => 'Method Not Allowed']));
}

// Get input data
$input = json_decode(file_get_contents('php://input'), true);
$license_key = $input['license_key'] ?? '';
$hardware_id = $input['hardware_id'] ?? '';
$device_name = $input['device_name'] ?? 'Unknown Device';

if (empty($license_key) || empty($hardware_id)) {
    http_response_code(400);
    die(json_encode(['success' => false, 'message' => 'Missing license key or hardware ID']));
}

try {
    // 1. Find the license
    $stmt = $pdo->prepare("SELECT * FROM licenses WHERE license_key = ?");
    $stmt->execute([$license_key]);
    $license = $stmt->fetch();

    if (!$license) {
        http_response_code(404);
        die(json_encode(['success' => false, 'message' => 'Invalid license key']));
    }

    // 2. Check if active and not expired
    if (!$license['is_active']) {
        http_response_code(403);
        die(json_encode(['success' => false, 'message' => 'License has been suspended']));
    }

    if ($license['expiry_date'] && strtotime($license['expiry_date']) < time()) {
        http_response_code(403);
        die(json_encode(['success' => false, 'message' => 'License has expired']));
    }

    // 3. Check existing activation for this hardware ID
    $stmt = $pdo->prepare("SELECT * FROM activations WHERE license_id = ? AND hardware_id = ?");
    $stmt->execute([$license['id'], $hardware_id]);
    $existing_activation = $stmt->fetch();

    if ($existing_activation) {
        // Already activated on this device, just update check-in time
        $update = $pdo->prepare("UPDATE activations SET last_check_in = NOW(), ip_address = ? WHERE id = ?");
        $update->execute([$_SERVER['REMOTE_ADDR'], $existing_activation['id']]);

        echo json_encode([
            'success' => true,
            'message' => 'License reactivated successfully',
            'expiry_date' => $license['expiry_date'],
            'token' => generate_token($license_key, $hardware_id) // Simple signature
        ]);
        exit;
    }

    // 4. Check device limit
    $stmt = $pdo->prepare("SELECT COUNT(*) as count FROM activations WHERE license_id = ?");
    $stmt->execute([$license['id']]);
    $activation_count = $stmt->fetch()['count'];

    if ($activation_count >= $license['max_devices']) {
        http_response_code(403);
        die(json_encode(['success' => false, 'message' => 'Maximum device limit reached for this license']));
    }

    // 5. Create new activation
    $insert = $pdo->prepare("INSERT INTO activations (license_id, hardware_id, device_name, ip_address) VALUES (?, ?, ?, ?)");
    $insert->execute([$license['id'], $hardware_id, $device_name, $_SERVER['REMOTE_ADDR']]);

    echo json_encode([
        'success' => true,
        'message' => 'Activation successful',
        'expiry_date' => $license['expiry_date'],
        'token' => generate_token($license_key, $hardware_id)
    ]);

} catch (Exception $e) {
    error_log("Activation Error: " . $e->getMessage());
    http_response_code(500);
    die(json_encode(['success' => false, 'message' => 'Server error during activation']));
}

function generate_token($key, $hwid)
{
    // Simple HMAC signature to verify response came from us
    // In production, use a secret key stored in config
    $secret = 'Oluwagbenga';
    return hash_hmac('sha256', $key . $hwid, $secret);
}
