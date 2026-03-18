<?php
// validate.php - Periodic License Check (Heartbeat)
header('Content-Type: application/json');
require_once 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    die(json_encode(['success' => false, 'message' => 'Method Not Allowed']));
}

$input = json_decode(file_get_contents('php://input'), true);
$license_key = $input['license_key'] ?? '';
$hardware_id = $input['hardware_id'] ?? '';

if (empty($license_key) || empty($hardware_id)) {
    die(json_encode(['success' => false, 'valid' => false, 'message' => 'Missing parameters']));
}

try {
    // Check if license exists and is active
    $stmt = $pdo->prepare("
        SELECT l.is_active, l.expiry_date, a.id as activation_id 
        FROM licenses l 
        JOIN activations a ON l.id = a.license_id 
        WHERE l.license_key = ? AND a.hardware_id = ?
    ");
    $stmt->execute([$license_key, $hardware_id]);
    $result = $stmt->fetch();

    if (!$result) {
        die(json_encode(['success' => true, 'valid' => false, 'message' => 'License not found or not activated on this device']));
    }

    if (!$result['is_active']) {
        die(json_encode(['success' => true, 'valid' => false, 'message' => 'License suspended']));
    }

    if ($result['expiry_date'] && strtotime($result['expiry_date']) < time()) {
        die(json_encode(['success' => true, 'valid' => false, 'message' => 'License expired']));
    }

    // Update last check-in
    $update = $pdo->prepare("UPDATE activations SET last_check_in = NOW(), ip_address = ? WHERE id = ?");
    $update->execute([$_SERVER['REMOTE_ADDR'], $result['activation_id']]);

    echo json_encode([
        'success' => true,
        'valid' => true,
        'expiry_date' => $result['expiry_date']
    ]);

} catch (Exception $e) {
    error_log("Validation Error: " . $e->getMessage());
    http_response_code(500);
    die(json_encode(['success' => false, 'message' => 'Server error']));
}
