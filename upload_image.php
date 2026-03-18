<?php
// Simple image upload endpoint for lesson notes
// Accepts a single file in 'image' field, saves to uploads/lesson_images and returns JSON { url: 'uploads/...' }

session_start();
header('Content-Type: application/json');
// Make PHP warnings/notices throw exceptions so we can return JSON for everything
set_error_handler(function ($severity, $message, $file, $line) {
    throw new ErrorException($message, 0, $severity, $file, $line);
});

// central logging helper
function log_upload_error($msg) {
    $uploadsDir = __DIR__ . '/uploads/lesson_images';
    if (!is_dir($uploadsDir)) @mkdir($uploadsDir, 0755, true);
    $logFile = $uploadsDir . '/upload_errors.log';
    $entry = date('Y-m-d H:i:s') . " - " . $msg . "\n";
    @file_put_contents($logFile, $entry, FILE_APPEND | LOCK_EX);
}

ob_start(); // capture any accidental output
try {
    // Server-side max total for the whole upload session (2MB). Client also enforces.
    $maxTotal = 2 * 1024 * 1024; // 2MB

    $clientTotal = isset($_POST['total_size']) ? (int)$_POST['total_size'] : 0;
    if ($clientTotal > $maxTotal) {
        http_response_code(400);
        echo json_encode(['error' => 'Total upload size exceeds allowed 2 MB']);
        exit;
    }

    // Support deletion requests: POST with action=delete and file=<basename>
    if (isset($_POST['action']) && $_POST['action'] === 'delete') {
        $file = isset($_POST['file']) ? basename($_POST['file']) : '';
        $uploadsDir = __DIR__ . '/uploads/lesson_images/';
        // safety check: simple filename
        if (!$file || !preg_match('/^[a-zA-Z0-9_\-\.]+$/', $file)) {
            http_response_code(400);
            echo json_encode(['error' => 'invalid_filename']);
            exit;
        }
        $path = $uploadsDir . $file;
        if (file_exists($path) && is_file($path)) {
            $ok = @unlink($path);
            if ($ok) {
                echo json_encode(['status' => 'deleted', 'file' => $file]);
            } else {
                http_response_code(500);
                echo json_encode(['error' => 'unlink_failed', 'file' => $file]);
            }
        } else {
            http_response_code(404);
            echo json_encode(['error' => 'not_found', 'file' => $file]);
        }
        exit;
    }

    if (!isset($_FILES['image'])) {
        http_response_code(400);
        echo json_encode(['error' => 'No file uploaded']);
        exit;
    }

    $file = $_FILES['image'];

    if ($file['error'] !== UPLOAD_ERR_OK) {
        $code = $file['error'];
        $msg = 'Unknown upload error';
        switch ($code) {
            case UPLOAD_ERR_INI_SIZE:
            case UPLOAD_ERR_FORM_SIZE:
                $msg = 'Uploaded file exceeds server size limit';
                break;
            case UPLOAD_ERR_PARTIAL:
                $msg = 'File was only partially uploaded';
                break;
            case UPLOAD_ERR_NO_FILE:
                $msg = 'No file sent';
                break;
            case UPLOAD_ERR_NO_TMP_DIR:
                $msg = 'Missing temporary folder on server';
                break;
            case UPLOAD_ERR_CANT_WRITE:
                $msg = 'Failed to write file to disk';
                break;
            case UPLOAD_ERR_EXTENSION:
                $msg = 'A PHP extension stopped the file upload';
                break;
            default:
                $msg = 'Upload error code: ' . $code;
        }
        $diag = ['error' => $msg, 'code' => $code, 'size' => $file['size'], 'clientTotal' => $clientTotal];
        log_upload_error(json_encode($diag));
        http_response_code(400);
        echo json_encode($diag);
        exit;
    }

    if ($file['size'] > $maxTotal) {
        $diag = ['error' => 'File exceeds maximum allowed size', 'size' => $file['size']];
        log_upload_error(json_encode($diag));
        http_response_code(400);
        echo json_encode($diag);
        exit;
    }

    $finfo = finfo_open(FILEINFO_MIME_TYPE);
    $mime = finfo_file($finfo, $file['tmp_name']);
    finfo_close($finfo);

    $allowed = ['image/jpeg', 'image/png', 'image/gif', 'image/webp'];
    if (!in_array($mime, $allowed)) {
        $diag = ['error' => 'Invalid file type', 'mime' => $mime];
        log_upload_error(json_encode($diag));
        http_response_code(400);
        echo json_encode($diag);
        exit;
    }

    $uploadsDir = __DIR__ . '/uploads/lesson_images';
    if (!is_dir($uploadsDir)) mkdir($uploadsDir, 0755, true);

    $ext = pathinfo($file['name'], PATHINFO_EXTENSION);
    $name = uniqid('ln_', true) . '.' . $ext;
    $dest = $uploadsDir . '/' . $name;

    if (!move_uploaded_file($file['tmp_name'], $dest)) {
        $diag = ['error' => 'Could not save file', 'tmp' => $file['tmp_name']];
        log_upload_error(json_encode($diag));
        http_response_code(500);
        echo json_encode($diag);
        exit;
    }
    // retain this line in localhost
    // // $baseUrl = dirname($_SERVER['SCRIPT_NAME']);
    // $url = $baseUrl . '/uploads/lesson_images/' . $name;
    
    // retain this line in production
    $url = '/uploads/lesson_images/' . $name;
    $size = filesize($dest);

    // clear any accidental output
    ob_end_clean();
    echo json_encode(['url' => $url, 'name' => $name, 'size' => $size]);
    exit;
} catch (Throwable $e) {
    // capture and log unexpected exceptions or errors
    $msg = ['error' => 'Server exception', 'message' => $e->getMessage(), 'file' => $e->getFile(), 'line' => $e->getLine()];
    log_upload_error(json_encode($msg));
    // ensure we return JSON only
    if (ob_get_length()) ob_end_clean();
    http_response_code(500);
    echo json_encode($msg);
    exit;
}
