<?php
// local_push_test.php
// Wrapper for local CLI testing of push API
header('Content-Type: application/json');
require_once __DIR__ . '/../../../config.php';

$payload_file = $argv[1] ?? '';
if (!file_exists($payload_file)) {
    die(json_encode(['success' => false, 'message' => 'Payload file missing']));
}

$input = json_decode(file_get_contents($payload_file), true);
$license_key = $input['license'] ?? '';
$sync_data = $input['data'] ?? [];

if (empty($license_key)) {
    http_response_code(401);
    die(json_encode(['success' => false, 'message' => 'Unauthorized: Missing license key']));
}

try {
    // $db is established via require_once __DIR__ . '/../../../config.php'

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

    $school_id = $school['id'];
    $successful_receipts = [
        'assessments' => [],
        'questions' => [],
        'options' => []
    ];

    $db->beginTransaction();

    if (!empty($sync_data['assessments'])) {
        $stmt_ass = $db->prepare("INSERT INTO sync_assessments 
            (local_id, school_id, title, duration, instruction, number_of_questions, subject_id, class_ids) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE 
            title=VALUES(title), duration=VALUES(duration), instruction=VALUES(instruction), 
            number_of_questions=VALUES(number_of_questions), subject_id=VALUES(subject_id), class_ids=VALUES(class_ids)");

        foreach ($sync_data['assessments'] as $row) {
            $stmt_ass->execute([
                $row['id'],
                $school_id,
                $row['title'],
                $row['duration'],
                $row['instruction'],
                $row['number_of_questions'],
                $row['subject_id'],
                $row['class_ids']
            ]);
            $successful_receipts['assessments'][] = $row['id'];
        }
    }

    if (!empty($sync_data['questions'])) {
        $stmt_qz = $db->prepare("INSERT INTO sync_questions (local_id, school_id, ass_id, question) VALUES (?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE question=VALUES(question)");
        foreach ($sync_data['questions'] as $row) {
            $stmt_qz->execute([$row['id'], $school_id, $row['ass_id'], $row['question']]);
            $successful_receipts['questions'][] = $row['id'];
        }
    }

    if (!empty($sync_data['options'])) {
        $stmt_opt = $db->prepare("INSERT INTO sync_options (local_id, school_id, question_id, options, answer) VALUES (?, ?, ?, ?, ?)
            ON DUPLICATE KEY UPDATE options=VALUES(options), answer=VALUES(answer)");
        foreach ($sync_data['options'] as $row) {
            $stmt_opt->execute([$row['id'], $school_id, $row['question_id'], $row['options'], $row['answer']]);
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
