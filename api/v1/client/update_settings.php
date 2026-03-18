<?php
// Endpoint for Assesshub Desktop App to push local AI settings up to the Cloud Panel
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

// Allow POST requests with JSON payload
$input = json_decode(file_get_contents('php://input'), true);

$license_key = $input['license'] ?? '';

if (empty($license_key)) {
    http_response_code(401);
    die(json_encode(['success' => false, 'message' => 'Unauthorized: Missing license key']));
}

try {
    // $db is established via config.php

    // Authenticate School
    $stmt = $db->prepare("SELECT id, is_active FROM schools WHERE license_key = ?");
    $stmt->execute([$license_key]);
    $school = $stmt->fetch();

    if (!$school || !$school['is_active']) {
        http_response_code(403);
        die(json_encode(['success' => false, 'message' => 'Invalid or suspended license.']));
    }

    // Prepare fields to update
    $updates = [];
    $params = [];

    // Allow updating ai_provider, ai_model, ai_key, and school_name
    if (isset($input['school_name']) && !empty($input['school_name'])) {
        $updates[] = "school_name = ?";
        $params[] = $input['school_name'];
    }

    if (isset($input['ai_provider'])) {
        $updates[] = "ai_provider = ?";
        $params[] = $input['ai_provider'];
    }

    if (isset($input['ai_model'])) {
        $updates[] = "ai_model = ?";
        $params[] = $input['ai_model'];
    }

    if (isset($input['ai_key'])) {
        // If the school pushes an empty key, it effectively clears it out
        $updates[] = "ai_key = ?";
        $params[] = $input['ai_key'];
    }

    // Only run update if there are fields to update
    if (!empty($updates)) {
        $params[] = $license_key; // For the WHERE clause
        $sql = "UPDATE schools SET " . implode(", ", $updates) . " WHERE license_key = ?";

        $updateStmt = $db->prepare($sql);
        $updateStmt->execute($params);
    }

    echo json_encode([
        'success' => true,
        'message' => 'Cloud settings synchronized successfully.'
    ]);
} catch (Exception $e) {
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Server Error: ' . $e->getMessage()]);
}
