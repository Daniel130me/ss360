<?php
// Returns classes grouped by is_graduate for Select2
session_start();
header('Content-Type: application/json; charset=utf-8');
if (!isset($_SESSION['userid'])) {
    http_response_code(401);
    echo json_encode(['error' => 'Unauthorized']);
    exit;
}
include_once(__DIR__ . '/model/connect.php');

$school_id = isset($_SESSION['school_id']) ? $_SESSION['school_id'] : null;
if (!$school_id) {
    echo json_encode([]);
    exit;
}



?>
