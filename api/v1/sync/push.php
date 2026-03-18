<?php
// Receiver for Assesshub Desktop App to push cloud sync data
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

$input = json_decode(file_get_contents('php://input'), true);
$license_key = $input['license'] ?? '';
$sync_data = $input['data'] ?? [];

if (empty($license_key)) {
    http_response_code(401);
    die(json_encode(['success' => false, 'message' => 'Unauthorized: Missing license key']));
}

try {
    // $db is established via require_once __DIR__ . '/../../../config.php'

    // Authenticate School
    $stmt = $db->prepare("SELECT id, is_active, sync_enabled FROM schools WHERE license_key = ?");
    $stmt->execute([$license_key]);
    $school = $stmt->fetch();

    if (!$school || !$school['is_active']) {
        http_response_code(403);
        die(json_encode(['success' => false, 'message' => 'Invalid or suspended license.']));
    }

    if (!$school['sync_enabled']) {
        http_response_code(403);
        die(json_encode(['success' => false, 'message' => 'Cloud Sync is disabled for this school.']));
    }

    // ── Device Registration & Limit Check ──
    $hwid = $input['hwid'] ?? '';
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
            die(json_encode(['success' => false, 'message' => 'Device Limit Reached. Cannot push data.']));
        }

        // Under limit: Register the new device
        $deviceIdStr = "Device-" . substr(md5($hwid), 0, 8);
        $db->prepare("INSERT INTO devices (school_id, hardware_id, device_name) VALUES (?, ?, ?)")
            ->execute([$school['id'], $hwid, $deviceIdStr]);
    }

    $school_id = $school['id'];
    $successful_receipts = [
        'assessments' => [],
        'questions' => [],
        'options' => []
    ];

    $db->beginTransaction();

    // 1. Process Assessments
    if (!empty($sync_data['assessments'])) {
        $stmt_ass = $db->prepare("INSERT INTO sync_assessments 
            (local_id, school_id, title, duration, instruction, number_of_questions, subject_id, class_ids) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE 
            title=VALUES(title), duration=VALUES(duration), instruction=VALUES(instruction), 
            number_of_questions=VALUES(number_of_questions), subject_id=VALUES(subject_id), class_ids=VALUES(class_ids)");

        foreach ($sync_data['assessments'] as $row) {
            $subj_id = empty($row['subject_id']) ? 0 : (int)$row['subject_id'];
            $stmt_ass->execute([
                $row['id'],
                $school_id,
                $row['title'],
                $row['duration'],
                $row['instruction'],
                $row['number_of_questions'],
                $subj_id,
                $row['class_ids']
            ]);
            $successful_receipts['assessments'][] = $row['id'];
        }
    }

    // 2. Process Questions
    if (!empty($sync_data['questions'])) {
        $stmt_qz = $db->prepare("INSERT INTO sync_questions (local_id, school_id, ass_id, question) VALUES (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE question=VALUES(question)");
        foreach ($sync_data['questions'] as $row) {
            $a_id = empty($row['ass_id']) ? 0 : (int)$row['ass_id'];
            $stmt_qz->execute([$row['id'], $school_id, $a_id, $row['question']]);
            $successful_receipts['questions'][] = $row['id'];
        }
    }

    // 3. Process Options
    if (!empty($sync_data['options'])) {
        $stmt_opt = $db->prepare("INSERT INTO sync_options (local_id, school_id, question_id, options, answer) VALUES (?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE options=VALUES(options), answer=VALUES(answer)");
        foreach ($sync_data['options'] as $row) {
            // Fix SQLite empty string into MySQL integer issue
            $q_id = empty($row['question_id']) ? 0 : (int)$row['question_id'];
            $stmt_opt->execute([$row['id'], $school_id, $q_id, $row['options'], $row['answer']]);
            $successful_receipts['options'][] = $row['id'];
        }
    }

    $db->commit();

    echo json_encode([
        'success' => true,
        'message' => 'Data synced successfully.',
        'receipts' => $successful_receipts
    ]);
} catch (Exception $e) {
    if (isset($db) && $db->inTransaction()) {
        $db->rollBack();
    }
    http_response_code(500);
    echo json_encode(['success' => false, 'message' => 'Sync failed: ' . $e->getMessage()]);
}
