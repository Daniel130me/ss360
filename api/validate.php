<?php
// api/validate.php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

require_once __DIR__ . '/../db_connect.php';

$input = json_decode(file_get_contents('php://input'), true) ?: $_POST;

$license_key = $input['license_key'] ?? '';
$hardware_id = $input['hardware_id'] ?? '';

if (empty($license_key) || empty($hardware_id)) {
    http_response_code(400);
    die(json_encode(['success' => false, 'message' => 'Missing required parameters']));
}

try {
    // 1. Find License
    $stmt = $pdo->prepare("SELECT id, is_active FROM schools WHERE license_key = ?");
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

    // 2. Validate Device
    $stmtDevice = $pdo->prepare("SELECT id FROM devices WHERE school_id = ? AND hardware_id = ?");
    $stmtDevice->execute([$school['id'], $hardware_id]);
    $existingDevice = $stmtDevice->fetch();

    if (!$existingDevice) {
        http_response_code(403);
        die(json_encode(['success' => false, 'message' => 'Device not registered or revoked']));
    }

    // 3. Update device check-in timestamp
    $pdo->prepare("UPDATE devices SET last_check_in = CURRENT_TIMESTAMP WHERE id = ?")->execute([$existingDevice['id']]);

    // Extend expiry by 1 year from now. 
    // In a formal setup, you would have a contract expiry date column in schools table.
    $expiry_date = date('Y-m-d H:i:s', strtotime('+1 year'));

    echo json_encode([
        'success' => true,
        'valid' => true,
        'expiry_date' => $expiry_date
    ]);
} catch (PDOException $e) {
    error_log("Validation DB Error: " . $e->getMessage());
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Internal Server Error']);
}
