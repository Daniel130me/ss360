<?php
session_start();
error_reporting(E_ALL); // Enable error reporting for debugging
ini_set('display_errors', 1); // Display errors on the screen
$date = date('Y-m-d H:i:s'); // Get current date and time
// Basic security checks - enhance as needed
if (!isset($_SESSION['userid'], $_SESSION['school_id'])) {
    header('Content-Type: application/json');
    echo json_encode(['success' => false, 'message' => 'Authentication required.']);
    exit();
}

include_once("model/connect.php"); // Adjust path if needed
include_once("model/functions.php"); // Include if needed for other functions

// Ensure database connection is established ($conn)
if (!$conn) {
    header('Content-Type: application/json');
    echo json_encode(['success' => false, 'message' => 'Database connection error.']);
    exit();
}

$action = $_POST['action'] ?? $_GET['action'] ?? null; // Get action from POST or GET
$school_id = (int)$_SESSION['school_id']; // Get school_id from session
$user_id = (int)$_SESSION['userid']; // Get user_id for createdby
$date = date('Y-m-d H:i:s'); // Get current date and time
header('Content-Type: application/json'); // Set content type for all responses

switch ($action) {
      case 'get_parent_billing':
        try {
            // Get filters from POST
            $student_id = isset($_POST['student_id']) ? intval($_POST['student_id']) : 0;
            $class_id = isset($_POST['class_id']) ? intval($_POST['class_id']) : 0;
            $session_id = isset($_POST['session_id']) ? intval($_POST['session_id']) : 0;
            $term_id = isset($_POST['term_id']) ? intval($_POST['term_id']) : 0;

            if (!$student_id || !$session_id || !$term_id) {
                echo json_encode(['success' => false, 'message' => 'student_id, session_id and term_id are required.']);
                break;
            }

            // Build base WHERE and parameters. Require session_id and term_id for accuracy; class_id is optional but applied when present.
            $where = 'student_id = ? AND school_id = ? AND session_id = ? AND term_id = ?';
            $types = 'iiii';
            $params = [$student_id, $school_id, $session_id, $term_id];
            if ($class_id) {
                $where .= ' AND class_id = ?';
                $types .= 'i';
                $params[] = $class_id;
            }

            // Sum amount_due from bill_record for this student + filters
            $sql = "SELECT COALESCE(SUM(amount_due),0) AS total_due FROM bill_record WHERE $where";
            $stmt = $conn->prepare($sql);
            if ($stmt === false) throw new Exception('Prepare failed: ' . $conn->error);
            // bind params dynamically
            $bind_names = [];
            $bind_names[] = &$types;
            foreach ($params as $k => $v) {
                $bind_names[] = &$params[$k];
            }
            call_user_func_array([$stmt, 'bind_param'], $bind_names);
            $stmt->execute();
            $res = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            $amount_due = floatval($res['total_due']);

            // Sum payments (amount_newly_paid) from payment_log for this student + filters
            $sql2 = "SELECT COALESCE(SUM(amount_newly_paid),0) AS total_paid FROM payment_log WHERE $where";
            $stmt2 = $conn->prepare($sql2);
            if ($stmt2 === false) throw new Exception('Prepare failed: ' . $conn->error);
            // bind same params
            $bind_names2 = [];
            $bind_names2[] = &$types;
            foreach ($params as $k => $v) {
                $bind_names2[] = &$params[$k];
            }
            call_user_func_array([$stmt2, 'bind_param'], $bind_names2);
            $stmt2->execute();
            $res2 = $stmt2->get_result()->fetch_assoc();
            $stmt2->close();

            $total_paid = floatval($res2['total_paid']);

            $balance = $amount_due - $total_paid;
            if ($balance < 0) $balance = 0;

            echo json_encode([
                'success' => true,
                'amount_due' => number_format($amount_due, 2, '.', ''),
                'total_amount_paid' => number_format($total_paid, 2, '.', ''),
                'balance' => number_format($balance, 2, '.', ''),
            ]);
        } catch (Exception $e) {
            error_log('get_parent_billing error: ' . $e->getMessage());
            echo json_encode(['success' => false, 'message' => 'Error fetching billing data.']);
        }
        break;
        
    case 'get_payment_breakdown':
        try {
            $student_id = isset($_POST['student_id']) ? intval($_POST['student_id']) : 0;
            $session_id = isset($_POST['session_id']) ? intval($_POST['session_id']) : 0;
            $term_id = isset($_POST['term_id']) ? intval($_POST['term_id']) : 0;
            $class_id = isset($_POST['class_id']) ? intval($_POST['class_id']) : 0;

            if (!$student_id || !$session_id || !$term_id) {
                echo json_encode(['success' => false, 'message' => 'student_id, session_id and term_id are required.']);
                break;
            }

            $where = 'pl.student_id = ? AND pl.school_id = ? AND pl.session_id = ? AND pl.term_id = ?';
            $types = 'iiii';
            $params = [$student_id, $school_id, $session_id, $term_id];
            if ($class_id) {
                $where .= ' AND pl.class_id = ?';
                $types .= 'i';
                $params[] = $class_id;
            }

            $sql = "SELECT pl.id, pl.bill_id, pl.date_paid, pl.amount_newly_paid, pl.total_amount_paid, pl.balance, pl.description, pl.createdby, pl.datecreated, pm.method as payment_method, br.amount_due, br.bill_type, bt.bill_name FROM payment_log pl LEFT JOIN payment_method pm ON pl.payment_method_id = pm.id LEFT JOIN bill_record br ON pl.bill_id = br.id LEFT JOIN bill_type bt ON br.bill_type = bt.id WHERE $where ORDER BY pl.date_paid DESC, pl.id DESC";

            $stmt = $conn->prepare($sql);
            if ($stmt === false) throw new Exception('Prepare failed: ' . $conn->error);

            // bind params dynamically
            $bind_names = [];
            $bind_names[] = &$types;
            foreach ($params as $k => $v) {
                $bind_names[] = &$params[$k];
            }
            call_user_func_array([$stmt, 'bind_param'], $bind_names);

            $stmt->execute();
            $res = $stmt->get_result();
            $data = [];
            while ($row = $res->fetch_assoc()) {
                $data[] = [
                    'id' => intval($row['id']),
                    'bill_id' => intval($row['bill_id']),
                    'bill_name' => isset($row['bill_name']) ? $row['bill_name'] : null,
                    'amount_due' => isset($row['amount_due']) ? floatval($row['amount_due']) : null,
                    'date_paid' => $row['date_paid'],
                    'amount_newly_paid' => floatval($row['amount_newly_paid']),
                    'total_amount_paid' => floatval($row['total_amount_paid']),
                    'balance' => floatval($row['balance']),
                    'payment_method' => $row['payment_method'],
                    'description' => $row['description'],
                    'createdby' => $row['createdby'],
                    'datecreated' => $row['datecreated']
                ];
            }
            $stmt->close();
            // Also include any bill_record rows for this student/filters that may not have payment_log entries
            // This ensures unpaid/assigned bills are shown alongside payment entries.
            $bwhere = 'br.student_id = ? AND br.school_id = ? AND br.session_id = ? AND br.term_id = ?';
            $btypes = 'iiii';
            $bparams = [$student_id, $school_id, $session_id, $term_id];
            if ($class_id) {
                $bwhere .= ' AND br.class_id = ?';
                $btypes .= 'i';
                $bparams[] = $class_id;
            }
            $bsql = "SELECT br.id as bill_id, br.amount_due, br.bill_type, bt.bill_name, br.datecreated FROM bill_record br LEFT JOIN bill_type bt ON br.bill_type = bt.id WHERE $bwhere ORDER BY br.datecreated DESC, br.id DESC";
            $bstmt = $conn->prepare($bsql);
            if ($bstmt !== false) {
                $bind_names = [];
                $bind_names[] = &$btypes;
                foreach ($bparams as $k => $v) $bind_names[] = &$bparams[$k];
                call_user_func_array([$bstmt, 'bind_param'], $bind_names);
                $bstmt->execute();
                $bres = $bstmt->get_result();

                // Build a set of bill_ids already present from payment logs
                $present = [];
                foreach ($data as $drow) {
                    if (!empty($drow['bill_id'])) $present[intval($drow['bill_id'])] = true;
                }

                while ($brow = $bres->fetch_assoc()) {
                    $bid = intval($brow['bill_id']);
                    if (isset($present[$bid])) continue; // skip bills already represented by payment entries
                    $data[] = [
                        'id' => 0,
                        'bill_id' => $bid,
                        'bill_name' => $brow['bill_name'] ?? null,
                        'amount_due' => floatval($brow['amount_due']),
                        'date_paid' => null,
                        'amount_newly_paid' => 0,
                        'total_amount_paid' => 0,
                        'balance' => floatval($brow['amount_due']),
                        'payment_method' => null,
                        'description' => 'No payment yet',
                        'createdby' => null,
                        'datecreated' => $brow['datecreated'] ?? null
                    ];
                }
                $bstmt->close();
            }

            echo json_encode(['success' => true, 'data' => $data]);
        } catch (Exception $e) {
            error_log('get_payment_breakdown error: ' . $e->getMessage());
            echo json_encode(['success' => false, 'message' => 'Error fetching payment breakdown.']);
        }
        break;
        
    case 'email_receipt_pdf_data':
        // Send PDF as attachment (base64, not saved to disk)
        $input = json_decode(file_get_contents('php://input'), true);
        $email = filter_var($input['email'] ?? '', FILTER_VALIDATE_EMAIL);
        $pdf_base64 = $input['pdf_base64'] ?? '';
        if (!$email || !$pdf_base64) {
            echo json_encode(['success' => false, 'message' => 'Missing or invalid email or PDF data.']);
            break;
        }
        $pdf_data = base64_decode($pdf_base64);
        if ($pdf_data === false) {
            echo json_encode(['success' => false, 'message' => 'Invalid PDF data.']);
            break;
        }
        // Use PHPMailer if available, else fallback to mail() with attachment (simple MIME)
        $boundary = md5(time());
        $subject = 'Your Payment Receipt';
        $message = "Dear Parent/Guardian,\n\nPlease find your payment receipt attached.\n\nThank you.";
        $headers = "From: noreply@" . $_SERVER['HTTP_HOST'] . "\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: multipart/mixed; boundary=\"$boundary\"\r\n";
        $body = "--$boundary\r\n";
        $body .= "Content-Type: text/plain; charset=utf-8\r\n\r\n$message\r\n";
        $body .= "--$boundary\r\n";
        $body .= "Content-Type: application/pdf; name=\"receipt.pdf\"\r\n";
        $body .= "Content-Transfer-Encoding: base64\r\n";
        $body .= "Content-Disposition: attachment; filename=\"receipt.pdf\"\r\n\r\n";
        $body .= chunk_split(base64_encode($pdf_data)) . "\r\n";
        $body .= "--$boundary--";
        $sent = mail($email, $subject, $body, $headers);
        if ($sent) {
            echo json_encode(['success' => true]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to send email.']);
        }
        break;
    case 'upload_receipt_pdf':
        // Handle PDF upload from share button
        if (!isset($_FILES['file']) || $_FILES['file']['error'] !== UPLOAD_ERR_OK) {
            echo json_encode(['success' => false, 'message' => 'No file uploaded or upload error.']);
            break;
        }
        $uploads_dir = __DIR__ . '/uploads/receipts';
        if (!is_dir($uploads_dir)) {
            mkdir($uploads_dir, 0777, true);
        }
        $filename = 'receipt_' . uniqid() . '.pdf';
        $target = $uploads_dir . '/' . $filename;
        if (move_uploaded_file($_FILES['file']['tmp_name'], $target)) {
            // Build public URL (adjust if needed for your server setup)
            $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https://' : 'http://';
            $host = $_SERVER['HTTP_HOST'];
            $base = rtrim(dirname($_SERVER['SCRIPT_NAME']), '/\\');
            $url = $protocol . $host . $base . '/uploads/receipts/' . $filename;
            echo json_encode(['success' => true, 'url' => $url]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to save file.']);
        }
        break;
    case 'upload_invoice_pdf':
        // Handle PDF upload from share button
        if (!isset($_FILES['file']) || $_FILES['file']['error'] !== UPLOAD_ERR_OK) {
            echo json_encode(['success' => false, 'message' => 'No file uploaded or upload error.']);
            break;
        }
        $uploads_dir = __DIR__ . '/uploads/receipts';
        if (!is_dir($uploads_dir)) {
            mkdir($uploads_dir, 0777, true);
        }
        $filename = 'invoice_' . uniqid() . '.pdf';
        $target = $uploads_dir . '/' . $filename;
        if (move_uploaded_file($_FILES['file']['tmp_name'], $target)) {
            // Build public URL (adjust if needed for your server setup)
            $protocol = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https://' : 'http://';
            $host = $_SERVER['HTTP_HOST'];
            $base = rtrim(dirname($_SERVER['SCRIPT_NAME']), '/\\');
            $url = $protocol . $host . $base . '/uploads/invoice/' . $filename;
            echo json_encode(['success' => true, 'url' => $url]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to save file.']);
        }
        break;

    case 'email_receipt_pdf':
        // Send receipt PDF link to email (simple version)
        $email = filter_var($_POST['email'] ?? '', FILTER_VALIDATE_EMAIL);
        $url = $_POST['url'] ?? '';
        if (!$email || !$url) {
            echo json_encode(['success' => false, 'message' => 'Missing or invalid email or file URL.']);
            break;
        }
        // Use PHP mail() for demo; for production use PHPMailer or similar
        $subject = 'Your Payment Receipt';
        $message = "Dear Parent/Guardian,\n\nPlease find your payment receipt at the following link:\n$url\n\nThank you.";
        $headers = 'From: noreply@' . $_SERVER['HTTP_HOST'];
        $sent = mail($email, $subject, $message, $headers);
        if ($sent) {
            echo json_encode(['success' => true]);
        } else {
            echo json_encode(['success' => false, 'message' => 'Failed to send email.']);
        }
        break;
    case 'get_last_payment_receipt':
        // Returns the latest payment receipt for a bill and student
        $bill_id = isset($_POST['bill_id']) ? intval($_POST['bill_id']) : 0;
        $student_id = isset($_POST['student_id']) ? intval($_POST['student_id']) : 0;
        $session_id = isset($_POST['session_id']) ? intval($_POST['session_id']) : 0;
        $term_id = isset($_POST['term_id']) ? intval($_POST['term_id']) : 0;
        if (!$bill_id || !$student_id) {
            echo json_encode(['success' => false, 'message' => 'Missing bill_id or student_id.']);
            break;
        }
        // Get the latest payment log for this bill/student
        $stmt = $conn->prepare("SELECT pl.*, pm.method as payment_method FROM payment_log pl LEFT JOIN payment_method pm ON pl.payment_method_id = pm.id WHERE pl.bill_id = ? AND pl.student_id = ? AND pl.school_id = ? ORDER BY pl.date_paid DESC, pl.id DESC LIMIT 1");
        $stmt->bind_param("iii", $bill_id, $student_id, $school_id);
        $stmt->execute();
        $payment = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        if (!$payment) {
            echo json_encode(['success' => false, 'message' => 'No payment found for this bill.']);
            break;
        }
        // Get bill record
        $stmt = $conn->prepare("SELECT * FROM bill_record WHERE id = ? AND school_id = ? LIMIT 1");
        $stmt->bind_param("ii", $bill_id, $school_id);
        $stmt->execute();
        $bill = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        if (!$bill) {
            echo json_encode(['success' => false, 'message' => 'Bill record not found.']);
            break;
        }
        // Get bill type
        $bill_type_id = isset($bill['bill_type']) ? intval($bill['bill_type']) : 0;
        // First, get bill_type
        $stmt = $conn->prepare("SELECT * FROM bill_type WHERE id = ? AND school_id = ? LIMIT 1");
        $stmt->bind_param("ii", $bill_type_id, $school_id);
        $stmt->execute();
        $bill_type = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        // Then, get session name if session_id is available
        $session_name = '';
        if (!empty($bill['session_id'])) {
            $stmt = $conn->prepare("SELECT session FROM `sessions` WHERE id = ? LIMIT 1");
            $stmt->bind_param("i", $bill['session_id']);
            $stmt->execute();
            $session_row = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            if ($session_row && isset($session_row['session'])) {
                $session_name = $session_row['session'];
            }
        }
        // Get student info
        $stmt = $conn->prepare("SELECT firstname, lastname, admission_no, class_id FROM students WHERE id = ? AND school_id = ? LIMIT 1");
        $stmt->bind_param("ii", $student_id, $school_id);
        $stmt->execute();
        $student = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        // Get class info
        $class_name = '';
        if (!empty($student['class_id'])) {
            $stmt = $conn->prepare("SELECT classname FROM `class` WHERE id = ? AND school_id = ? LIMIT 1");
            $stmt->bind_param("ii", $student['class_id'], $school_id);
            $stmt->execute();
            $class_row = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            $class_name = $class_row ? $class_row['classname'] : '';
        }
        // School info (from session)
        $school_name = isset($_SESSION['school_name']) ? $_SESSION['school_name'] : '';
        $school_logo = isset($_SESSION['logo']) ? $_SESSION['logo'] : '';
        // Compose receipt data
        $receipt = [
            'school_name' => $school_name,
            'school_logo' => $school_logo,
            'school_phone' => isset($_SESSION['phone1']) ? $_SESSION['phone1'] : '',
            'school_email' => isset($_SESSION['email']) ? $_SESSION['email'] : '',
            'school_address' => isset($_SESSION['address']) ? $_SESSION['address'] : '',
            'term' => isset($bill['term_id']) ? $bill['term_id'] : '',
            'session' => $session_name,
            'student' => $student,
            'class_name' => $class_name,
            'bill' => $bill,
            'bill_type' => $bill_type,
            'payment' => $payment,
            'date_issued' => date('Y-m-d'),
        ];
        echo json_encode(['success' => true, 'data' => $receipt]);
        break;
    case 'get_payment_receipt':
        // echo $_SESSION['phone1'];
        // exit;
        // Returns all data needed for a standard payment receipt
        $payment_id = isset($_POST['payment_id']) ? intval($_POST['payment_id']) : 0;
        $bill_id = isset($_POST['bill_id']) ? intval($_POST['bill_id']) : 0;
        if (!$payment_id || !$bill_id) {
            echo json_encode(['success' => false, 'message' => 'Missing payment_id or bill_id.']);
            break;
        }
        // Get payment log
        $stmt = $conn->prepare("SELECT pl.*, pm.method as payment_method FROM payment_log pl LEFT JOIN payment_method pm ON pl.payment_method_id = pm.id WHERE pl.id = ? AND pl.bill_id = ? AND pl.school_id = ? LIMIT 1");
        $stmt->bind_param("iii", $payment_id, $bill_id, $school_id);
        $stmt->execute();
        $payment = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        if (!$payment) {
            echo json_encode(['success' => false, 'message' => 'Payment record not found.']);
            break;
        }
        // Get bill record
        $stmt = $conn->prepare("SELECT * FROM bill_record WHERE id = ? AND school_id = ? LIMIT 1");
        $stmt->bind_param("ii", $bill_id, $school_id);
        $stmt->execute();
        $bill = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        if (!$bill) {
            echo json_encode(['success' => false, 'message' => 'Bill record not found.']);
            break;
        }
        // Get bill type
        $bill_type_id = isset($bill['bill_type']) ? intval($bill['bill_type']) : 0;
        $stmt = $conn->prepare("SELECT * FROM bill_type WHERE id = ? AND school_id = ? LIMIT 1");
        $stmt->bind_param("ii", $bill_type_id, $school_id);
        $stmt->execute();
        $bill_type = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        // Get student info
        $student_id = isset($bill['student_id']) ? intval($bill['student_id']) : 0;
        $stmt = $conn->prepare("SELECT firstname, lastname, admission_no, class_id FROM students WHERE id = ? AND school_id = ? LIMIT 1");
        $stmt->bind_param("ii", $student_id, $school_id);
        $stmt->execute();
        $student = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        // Get class info
        $class_name = '';
        if (!empty($student['class_id'])) {
            $stmt = $conn->prepare("SELECT classname FROM `class` WHERE id = ? AND school_id = ? LIMIT 1");
            $stmt->bind_param("ii", $student['class_id'], $school_id);
            $stmt->execute();
            $class_row = $stmt->get_result()->fetch_assoc();
            $stmt->close();
            $class_name = $class_row ? $class_row['classname'] : '';
        }
        // School info (from session)
        $school_name = isset($_SESSION['school_name']) ? $_SESSION['school_name'] : '';
        $school_logo = isset($_SESSION['logo']) ? $_SESSION['logo'] : '';
        // Compose receipt data
        // echo 
        $receipt = [
            'school_name' => $school_name,
            'school_address' => $_SESSION['address'],
            'school_phone' => $_SESSION['phone1'],
            'school_email' => $_SESSION['email'],
            'school_logo' => $school_logo,
            'student' => $student,
            'class_name' => $class_name,
            'bill' => $bill,
            'bill_type' => $bill_type,
            'payment' => $payment,
            'term' => getTermName($bill["term_id"]),
            'session' => getSSessionName($bill["session_id"]),
            'date_issued' => date('Y-m-d H:i:s'),
        ];
        echo json_encode(['success' => true, 'data' => $receipt]);
        break;
    case 'get_payment_timeline':
        // Returns payment timeline for a bill and student
        $bill_id = isset($_POST['bill_id']) ? intval($_POST['bill_id']) : 0;
        $student_id = isset($_POST['student_id']) ? intval($_POST['student_id']) : 0;
        if (!$bill_id || !$student_id) {
            echo json_encode(['success' => false, 'message' => 'Missing bill_id or student_id.']);
            break;
        }
        // Get bill record for context (amount_due, etc.)
        $stmt = $conn->prepare("SELECT * FROM bill_record WHERE id = ? AND student_id = ? AND school_id = ?");
        $stmt->bind_param("iii", $bill_id, $student_id, $school_id);
        $stmt->execute();
        $bill = $stmt->get_result()->fetch_assoc();
        $stmt->close();
        if (!$bill) {
            echo json_encode(['success' => false, 'message' => 'Bill record not found.']);
            break;
        }
        // Get all payment logs for this bill/student, ordered by date
        $stmt = $conn->prepare("SELECT pl.*, pm.method FROM payment_log pl LEFT JOIN payment_method pm ON pl.payment_method_id = pm.id WHERE pl.bill_id = ? AND pl.student_id = ? AND pl.school_id = ? ORDER BY pl.date_paid ASC, pl.id ASC");
        $stmt->bind_param("iii", $bill_id, $student_id, $school_id);
        $stmt->execute();
        $result = $stmt->get_result();
        $timeline = [];
        $total_paid = 0;
        while ($row = $result->fetch_assoc()) {
            $total_paid = floatval($row['total_amount_paid']);
            $timeline[] = [
                'id' => $row['id'],
                'bill_id' => $row['bill_id'],
                'date_paid' => $row['date_paid'],
                'amount_newly_paid' => floatval($row['amount_newly_paid']),
                'total_amount_paid' => $total_paid,
                'balance' => floatval($row['balance']),
                // Calculate status based on balance and total paid
                'status' => (
                    floatval($row['total_amount_paid']) == 0 ? 0 : (
                        floatval($row['balance']) == 0 ? 1 : 2
                    )
                ),
                'description' => $row['description'],
                'payment_method' => $row['method'],
                'datecreated' => $row['datecreated'],
            ];
        }
        // If no payment, show outstanding
        if (empty($timeline)) {
            $timeline[] = [
                'id' => 0,
                'bill_id' => $bill_id,
                'date_paid' => null,
                'amount_newly_paid' => 0,
                'total_amount_paid' => 0,
                'balance' => floatval($bill['amount_due']),
                'status' => 0,
                'description' => 'No payment yet',
                'payment_method' => null,
                'datecreated' => $bill['datecreated'],
            ];
        }
        echo json_encode(['success' => true, 'data' => $timeline]);
        break;
    case 'get_bill_type':
        // Fetch a single bill type by ID
        try {
            $billTypeId = filter_input(INPUT_POST, 'bill_type_id', FILTER_VALIDATE_INT);
            if (!$billTypeId) {
                throw new Exception("Invalid Bill Type ID provided.");
            }
            $stmt = $conn->prepare("SELECT * FROM bill_type WHERE id = ? AND school_id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }
            $stmt->bind_param("ii", $billTypeId, $school_id);
            $stmt->execute();
            $result = $stmt->get_result();
            if ($row = $result->fetch_assoc()) {
                echo json_encode(['success' => true, 'data' => $row]);
            } else {
                echo json_encode(['success' => false, 'message' => 'Bill type not found.']);
            }
            $stmt->close();
        } catch (Exception $e) {
            error_log("Error in get_bill_type: " . $e->getMessage());
            echo json_encode(['success' => false, 'message' => 'Error fetching bill type: ' . $e->getMessage()]);
        }
        break;
    case 'get_student_payment_record':


        $term_id = isset($_POST['term_id']) ? intval($_POST['term_id']) : 0;
        $session_id = isset($_POST['session_id']) ? intval($_POST['session_id']) : 0;
        $class_id = isset($_POST['class_id']) ? intval($_POST['class_id']) : 0;
        $bill_type_filter = isset($_POST['bill_type_filter']) ? $_POST['bill_type_filter'] : 'all';
        $student_record_filter = isset($_POST['student_record_filter']) ? $_POST['student_record_filter'] : 'all';

        // Validate input
        if (!$term_id || !$session_id) {
            throw new Exception("Invalid input data provided.");
        }

        // Query all students in the class, with their bill record and bill type
        $query = "
            SELECT 
                s.id as student_id,
                s.firstname,
                s.lastname,
                s.admission_no,
                br.id as bill_record_id,
                br.bill_type,
                br.term_id,
                br.session_id,
                br.class_id,
                br.amount_due as amount_due,
                bt.bill_name as bill_type_name,
                bt.id as bill_type_id
            FROM students s
            LEFT JOIN bill_record br ON s.id = br.student_id 
                AND br.school_id = ? 
                AND br.term_id = ?
                AND br.session_id = ?
                AND br.class_id = ?
            LEFT JOIN bill_type bt ON br.bill_type = bt.id
            WHERE s.school_id = ? 
            AND s.class_id = ?
            AND s.status = 1";

        // Add bill type filter if not 'all'
        if ($bill_type_filter !== 'all') {
            $query .= " AND (br.bill_type = ? OR br.bill_type IS NULL)";
        }

        $query .= " ORDER BY s.firstname ASC, s.lastname ASC";

        // Prepare statement with or without bill type filter
        if ($bill_type_filter !== 'all') {
            $stmt = $conn->prepare($query);
            if (!$stmt) {
                throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error . "\nSQL: $query");
            }
            $stmt->bind_param(
                "iiiiiis",
                $school_id,
                $term_id,
                $session_id,
                $class_id,
                $school_id,
                $class_id,
                $bill_type_filter
            );
        } else {
            $stmt = $conn->prepare($query);
            if (!$stmt) {
                throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error . "\nSQL: $query");
            }
            $stmt->bind_param(
                "iiiiii",
                $school_id,
                $term_id,
                $session_id,
                $class_id,
                $school_id,
                $class_id
            );
        }

        $stmt->execute();
        $result = $stmt->get_result();
        $data = [];

        while ($row = $result->fetch_assoc()) {
            $bill_id = $row['bill_record_id'];
            $student_id = $row['student_id'];
            $amount_due = $row['amount_due'] ?? 0;
            $amount_paid = 0;
            $balance = $amount_due;
            $status = 0;
            $last_payment = null;
            $payment_method = null;

            if ($bill_id) {
                // Fetch the latest payment log for this bill and student
                $pay_stmt = $conn->prepare("SELECT total_amount_paid, balance, date_paid, payment_method_id FROM payment_log WHERE bill_id = ? AND student_id = ? AND school_id = ? AND term_id = ? AND session_id = ? ORDER BY date_paid DESC, id DESC LIMIT 1");
                $pay_stmt->bind_param("iiiii", $bill_id, $student_id, $school_id, $term_id, $session_id);
                $pay_stmt->execute();
                $pay_result = $pay_stmt->get_result();
                if ($pay = $pay_result->fetch_assoc()) {
                    $amount_paid = floatval($pay['total_amount_paid']);
                    $balance = floatval($pay['balance']);
                    $last_payment = $pay['date_paid'];
                    $payment_method = $pay['payment_method_id'];
                    // Status: 1 = paid, 2 = part paid, 0 = not paid
                    if ($amount_paid >= $amount_due) {
                        $status = 1;
                    } elseif ($amount_paid > 0 && $amount_paid < $amount_due) {
                        $status = 2;
                    } else {
                        $status = 0;
                    }
                }
                $pay_stmt->close();
            }

            $data[] = [
                'id' => $bill_id,
                'student_id' => $student_id,
                'firstname' => $row['firstname'],
                'lastname' => $row['lastname'],
                'admission_no' => $row['admission_no'],
                'bill_type_name' => $row['bill_type_name'] ?? 'N/A',
                'bill_type' => $row['bill_type'],
                'term_id' => $row['term_id'] ?? 'N/A',
                'amount_due' => $amount_due,
                'amount_paid' => $amount_paid,
                'balance' => $balance,
                'status' => $status,
                'last_payment' => $last_payment,
                'payment_method' => $payment_method
            ];
        }

        // Apply student_record_filter on the assembled $data
        $filtered = [];
        foreach ($data as $row) {
            $include = true;
            switch ($student_record_filter) {
                case 'assigned':
                    $include = !empty($row['bill_type']);
                    break;
                case 'unassigned':
                    $include = empty($row['bill_type']);
                    break;
                case 'partly_paid':
                    $include = ($row['status'] == 2);
                    break;
                case 'unpaid':
                    // Only include students who have a bill assigned but haven't paid any amount
                    $include = (!empty($row['bill_type']) && floatval($row['amount_paid']) == 0);
                    break;
                case 'paid':
                    $include = ($row['status'] == 1);
                    break;
                case 'all':
                default:
                    $include = true;
            }
            if ($include) $filtered[] = $row;
        }

        echo json_encode([
            'draw' => isset($_POST['draw']) ? intval($_POST['draw']) : 1,
            'recordsTotal' => count($filtered),
            'recordsFiltered' => count($filtered),
            'data' => $filtered
        ]);

        $stmt->close();
        break;
    case 'get_bill_types':

        // echo "kl";
        try {
            // echo "SELECT id, bill_name, amount, tax FROM bill_type WHERE school_id = $school_id ORDER BY datecreated ASC, id ASC";
            // Order by datecreated or id to ensure consistent ordering, making the first one the default active
            $stmt = $conn->prepare("SELECT id, bill_name, amount, tax FROM bill_type WHERE school_id = ? ORDER BY datecreated ASC, id ASC");
            if (!$stmt) {
                throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }
            $stmt->bind_param("i", $school_id);
            $stmt->execute();
            $result = $stmt->get_result();
            $bill_types = $result->fetch_all(MYSQLI_ASSOC);
            $stmt->close();
            echo json_encode($bill_types); // Return the array directly
        } catch (Exception $e) {
            echo error_log("Error in get_bill_types: " . $e->getMessage()); // Log the error
            echo json_encode([]); // Return empty array on error
        }
        break;

    case 'create_bill_type':
        try {
            $billName = trim($_POST['billName'] ?? '');
            // Invoice breakdown items (arrays)
            $billItems = [];
            // Accept both create_breakdown_description[] and create-breakdown_description[] for compatibility
            $breakdownDescriptions = [];
            $breakdownAmounts = [];
            // Merge both possible field names into a single array for descriptions and amounts
            if (isset($_POST['create_breakdown_description'])) {
                $breakdownDescriptions = array_merge($breakdownDescriptions, (array)$_POST['create_breakdown_description']);
            }
            if (isset($_POST['create-breakdown_description'])) {
                $breakdownDescriptions = array_merge($breakdownDescriptions, (array)$_POST['create-breakdown_description']);
            }
            if (isset($_POST['create_breakdown_amount'])) {
                $breakdownAmounts = array_merge($breakdownAmounts, (array)$_POST['create_breakdown_amount']);
            }
            if (isset($_POST['create-breakdown_amount'])) {
                $breakdownAmounts = array_merge($breakdownAmounts, (array)$_POST['create-breakdown_amount']);
            }
            // Now, pair up by index, but allow for missing values
            $count = max(count($breakdownDescriptions), count($breakdownAmounts));
            for ($i = 0; $i < $count; $i++) {
                $desc = isset($breakdownDescriptions[$i]) ? trim($breakdownDescriptions[$i]) : '';
                $amt = isset($breakdownAmounts[$i]) ? floatval($breakdownAmounts[$i]) : 0;
                if ($desc !== '' && $amt > 0) {
                    $billItems[] = [
                        $desc => $amt
                    ];
                }
            }
            $billItemsJson = json_encode($billItems);
            // var_dump($billItemsJson); // Debugging line to check JSON structure
            // exit;
            $subtotal = filter_input(INPUT_POST, 'create_subtotal', FILTER_VALIDATE_FLOAT);
            $deduction_percentage = filter_input(INPUT_POST, 'deduction_percentage', FILTER_VALIDATE_FLOAT);
            $tax = filter_input(INPUT_POST, 'create_tax', FILTER_VALIDATE_FLOAT);
            $total = filter_input(INPUT_POST, 'create_total_amount', FILTER_VALIDATE_FLOAT);
            $notes = trim($_POST['create_notes'] ?? '');
            // Get terms and deduction_purpose from the correct fields
            $terms = trim($_POST['create_terms'] ?? '');
            $deduction_purpose = trim($_POST['deduction_purpose'] ?? '');

            // For backward compatibility, also set amount and tax fields
            $amount = $total;
            $taxPercentage = $tax;

            if (empty($billName) || $subtotal === false || $total === false || $subtotal < 0 || $total < 0) {
                throw new Exception("Invalid input data provided.");
            }

            // Insert into bill_type table
            // bill_type table: bill_name, amount, tax, deduction_purpose, deduction_percentage, subtotal, total, bill_items, notes, terms, school_id, createdby, datecreated
            $stmt = $conn->prepare("INSERT INTO bill_type (bill_name, amount, tax, deduction_purpose, deduction_percentage, subtotal, total, bill_items, notes, terms, school_id, createdby, datecreated) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())");
            if (!$stmt) {
                throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }
            $deduction_percentage = isset($_POST['deduction_percentage']) ? floatval($_POST['deduction_percentage']) : 0;
            $stmt->bind_param(
                "sddsdddsssii",
                $billName, //s
                $amount, //d
                $taxPercentage, //d
                $deduction_purpose, //s
                $deduction_percentage, // d
                $subtotal, //d
                $total, // d
                $billItemsJson,
                $notes,
                $terms,
                $school_id,
                $user_id
            );

            if ($stmt->execute()) {
                echo json_encode(['success' => true, 'message' => 'Bill type created successfully.']);
            } else {
                throw new Exception("Execute failed: (" . $stmt->errno . ") " . $stmt->error);
            }
            $stmt->close();
        } catch (Exception $e) {
            error_log("Error in create_bill_type: " . $e->getMessage());
            echo json_encode(['success' => false, 'message' => 'Error creating bill type: ' . $e->getMessage()]);
        }
        break;

    case 'update_bill_type':
        try {
            $date = date('Y-m-d H:i:s'); // Get current date and time
            $billTypeId = filter_input(INPUT_POST, 'billTypeId', FILTER_VALIDATE_INT);
            $billName = trim($_POST['billName'] ?? '');
            $updatedBy = (int)$_SESSION['userid']; // Get user_id for updatedby
            // Invoice breakdown items (arrays)
            $billItems = [];
            $breakdownDescriptions = [];
            $breakdownAmounts = [];
            if (isset($_POST['breakdown_description'])) {
                $breakdownDescriptions = array_merge($breakdownDescriptions, (array)$_POST['breakdown_description']);
            }
            if (isset($_POST['breakdown_amount'])) {
                $breakdownAmounts = array_merge($breakdownAmounts, (array)$_POST['breakdown_amount']);
            }
            $count = max(count($breakdownDescriptions), count($breakdownAmounts));
            for ($i = 0; $i < $count; $i++) {
                $desc = isset($breakdownDescriptions[$i]) ? trim($breakdownDescriptions[$i]) : '';
                $amt = isset($breakdownAmounts[$i]) ? floatval($breakdownAmounts[$i]) : 0;
                if ($desc !== '' && $amt > 0) {
                    $billItems[] = [
                        $desc => $amt
                    ];
                }
            }
            $billItemsJson = json_encode($billItems);

            $subtotal = filter_input(INPUT_POST, 'subtotal', FILTER_VALIDATE_FLOAT);
            $deduction_percentage = filter_input(INPUT_POST, 'deduction_percentage', FILTER_VALIDATE_FLOAT);
            $tax = filter_input(INPUT_POST, 'taxPercentage', FILTER_VALIDATE_FLOAT);
            $total = filter_input(INPUT_POST, 'amount', FILTER_VALIDATE_FLOAT);
            $notes = trim($_POST['notes'] ?? '');
            $terms = trim($_POST['terms'] ?? '');
            $deduction_purpose = trim($_POST['deduction_purpose'] ?? '');

            if (empty($billName) || $subtotal === false || $total === false || $subtotal < 0 || $total < 0 || !$billTypeId) {
                throw new Exception("Invalid input data provided for update.");
            }

            // Check ownership (ensure the bill type belongs to the school)
            $checkStmt = $conn->prepare("SELECT id FROM bill_type WHERE id = ? AND school_id = ?");
            if (!$checkStmt) throw new Exception("Prepare check failed: " . $conn->error);
            $checkStmt->bind_param("ii", $billTypeId, $school_id);
            $checkStmt->execute();
            $checkResult = $checkStmt->get_result();
            if ($checkResult->num_rows === 0) {
                $checkStmt->close();
                throw new Exception("Bill type not found or access denied.");
            }
            $checkStmt->close();

            $stmt = $conn->prepare("UPDATE bill_type SET bill_name = ?, amount = ?, tax = ?, deduction_purpose = ?, deduction_percentage = ?, subtotal = ?, total = ?, bill_items = ?, notes = ?, terms = ?, dateupdated=?, updatedby=? WHERE id = ? AND school_id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }
            $stmt->bind_param(
                "sddsdddsssssii",
                $billName,
                $total,
                $tax,
                $deduction_purpose,
                $deduction_percentage,
                $subtotal,
                $total,
                $billItemsJson,
                $notes,
                $terms,
                $date,
                $updatedBy,
                $billTypeId,
                $school_id
            );

            if ($stmt->execute()) {
                if ($stmt->affected_rows > 0) {
                    echo json_encode(['success' => true, 'message' => 'Bill type updated successfully.']);
                } else {
                    // Potentially no changes were made if data was identical
                    echo json_encode(['success' => true, 'message' => 'No changes detected in bill type.']);
                }
            } else {
                throw new Exception("Execute failed: (" . $stmt->errno . ") " . $stmt->error);
            }
            $stmt->close();
        } catch (Exception $e) {
            error_log("Error in update_bill_type: " . $e->getMessage());
            echo json_encode(['success' => false, 'message' => 'Error updating bill type: ' . $e->getMessage()]);
        }
        break;

    case 'delete_bill_type':
        try {
            $billTypeId = filter_input(INPUT_POST, 'bill_type_id', FILTER_VALIDATE_INT);

            if (!$billTypeId) {
                throw new Exception("Invalid Bill Type ID provided.");
            }

            // Prepare statement to prevent SQL injection and check ownership
            $stmt = $conn->prepare("DELETE FROM bill_type WHERE id = ? AND school_id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }
            $stmt->bind_param("ii", $billTypeId, $school_id);

            if ($stmt->execute()) {
                if ($stmt->affected_rows > 0) {
                    echo json_encode(['success' => true, 'message' => 'Bill type deleted successfully.']);
                } else {
                    // Bill type might not exist or doesn't belong to this school
                    throw new Exception("Bill type not found or could not be deleted.");
                }
            } else {
                throw new Exception("Execute failed: (" . $stmt->errno . ") " . $stmt->error);
            }
            $stmt->close();
        } catch (Exception $e) {
            error_log("Error in delete_bill_type: " . $e->getMessage());
            echo json_encode(['success' => false, 'message' => 'Error deleting bill type: ' . $e->getMessage()]);
        }
        break;

    // Add this case inside the switch statement in billing_controller.php
    case 'get_students_by_class':
        try {
            $class_id = filter_input(INPUT_POST, 'class_id', FILTER_VALIDATE_INT);

            if (!$class_id) {
                throw new Exception("Invalid Class ID provided.");
            }
            //  echo "SELECT s.id, CONCAT(s.firstname, ' ', s.lastname) AS student_name, s.admission_no, c.classname
            //         FROM students s
            //         JOIN class c ON s.class_id = c.id
            //         WHERE s.class_id = ? AND s.school_id = ? AND s.status = 1 ORDER BY s.firstname, s.lastname ASC";

            // Prepare statement to fetch students for the given class and school
            // Adjust the query based on your actual 'students' table structure
            // Ensure you select necessary fields like id, name, admission_no, and class name/id
            $stmt = $conn->prepare("
                    SELECT s.id, CONCAT(s.firstname, ' ', s.lastname) AS student_name, s.admission_no, c.classname
                    FROM students s
                    JOIN class c ON s.class_id = c.id
                    WHERE s.class_id = ? AND s.school_id = ? AND s.status = 1 ORDER BY s.firstname, s.lastname ASC
                "); // Assuming status=1 means active student

            if (!$stmt) {
                throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }

            $stmt->bind_param("ii", $class_id, $school_id);
            $stmt->execute();
            $result = $stmt->get_result();
            $students = $result->fetch_all(MYSQLI_ASSOC);
            $stmt->close();

            echo json_encode(['success' => true, 'students' => $students]);
        } catch (Exception $e) {
            error_log("Error in get_students_by_class: " . $e->getMessage());
            echo json_encode(['success' => false, 'message' => 'Error fetching students: ' . $e->getMessage(), 'students' => []]);
        }
        break;
    // Make sure this is before the 'default:' case
    case 'assign_bill_to_students':
        // Ensure we have POST data
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            echo json_encode(['success' => false, 'message' => 'Invalid request method.']);
            break;
        }

        $conn->begin_transaction();
        try {
            // --- Gather and validate input ---
            $bill_type_id = filter_input(INPUT_POST, 'bill_type_id', FILTER_VALIDATE_INT);
            $term_id = filter_input(INPUT_POST, 'term_id', FILTER_VALIDATE_INT);
            $session_id = filter_input(INPUT_POST, 'session_id', FILTER_VALIDATE_INT);
            $tax = filter_input(INPUT_POST, 'assign_tax', FILTER_VALIDATE_FLOAT);
            $students_json = $_POST['students'] ?? null;

            // Invoice fields
            $subtotal = isset($_POST['assign_subtotal']) ? floatval($_POST['assign_subtotal']) : 0;
            $deduction_purpose = trim($_POST['assign_deduction_purpose'] ?? '');
            $deduction_percentage = isset($_POST['assign_deduction_percentage']) ? floatval($_POST['assign_deduction_percentage']) : 0;
            $notes = trim($_POST['assign_notes'] ?? '');
            // exit;
            $terms = trim($_POST['assign_terms'] ?? '');
            $total = isset($_POST['assign_total_amount']) ? floatval($_POST['assign_total_amount']) : 0;

            // Breakdown items
            $breakdownDescriptions = isset($_POST['assign_breakdown_description']) ? (array)$_POST['assign_breakdown_description'] : [];
            $breakdownAmounts = isset($_POST['assign_breakdown_amount']) ? (array)$_POST['assign_breakdown_amount'] : [];
            $billItems = [];
            $count = max(count($breakdownDescriptions), count($breakdownAmounts));
            for ($i = 0; $i < $count; $i++) {
                $desc = isset($breakdownDescriptions[$i]) ? trim($breakdownDescriptions[$i]) : '';
                $amt = isset($breakdownAmounts[$i]) ? floatval($breakdownAmounts[$i]) : 0;
                if ($desc !== '' && $amt > 0) {
                    $billItems[] = [$desc => $amt];
                }
            }
            $billItemsJson = json_encode($billItems);

            if (!$bill_type_id || !$term_id || !$session_id || $total < 0 || $tax < 0 || empty($students_json)) {
                throw new Exception("Missing or invalid input data.");
            }
            $students = json_decode($students_json, true);
            if (json_last_error() !== JSON_ERROR_NONE || !is_array($students) || empty($students)) {
                throw new Exception("Invalid student data format.");
            }
            // var_dump($billItems);
            // echo $deduction_purpose,$terms;
            // exit; // Remove this exit

            $stmt = $conn->prepare("INSERT INTO bill_record (bill_type, student_id, school_id, class_id, term_id, session_id, amount, amount_due, createdby, datecreated, updatedby, dateupdated, bill_items, deduction_purpose, deduction_percentage, notes, terms, tax)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, NOW(), ?, ?, ?, ?, ?, ?)"); // 16 placeholders
            if (!$stmt) {
                throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }

            $status = 0; // not paid
            $last_payment = '0000-00-00 00:00:00';
            $amount_paid = 0;
            $updatedby = $user_id;

            $inserted_count = 0;
            foreach ($students as $student_data) {
                if (!isset($student_data['id']) || !isset($student_data['class_id'])) continue;
                $student_id = filter_var($student_data['id'], FILTER_VALIDATE_INT);
                $class_id = filter_var($student_data['class_id'], FILTER_VALIDATE_INT); // This class_id is from the student_data, not the overall filter
                if (!$student_id || !$class_id) continue;
                $stmt->bind_param(
                    "iiiiiiddiissdssd",
                    $bill_type_id,
                    $student_id,
                    $school_id,
                    $class_id,
                    $term_id,
                    $session_id,
                    $subtotal,          // for `amount`
                    $total,             // for `amount_due`
                    $user_id,
                    $updatedby,
                    $billItemsJson,
                    $deduction_purpose,
                    $deduction_percentage,
                    $notes,
                    $terms,
                    $tax
                );
                if (!$stmt->execute()) {
                    throw new Exception("Failed to assign bill to student ID $student_id: " . $stmt->error);
                }
                $inserted_count++;
            }
            $stmt->close();
            if ($conn->commit()) {
                echo json_encode(['success' => true, 'message' => "Bill successfully assigned to {$inserted_count} student(s)."]);
            } else {
                throw new Exception("Transaction commit failed: " . $conn->error);
            }
        } catch (Exception $e) {
            $conn->rollback();
            error_log("Error in assign_bill_to_students: " . $e->getMessage());
            echo json_encode(['success' => false, 'message' => 'Error assigning bill: ' . $e->getMessage()]);
        }
        break;

    // Add this case inside the switch statement in billing_controller.php
    case 'get_classes':
        try {
            // echo "SELECT id, class_name
            //     FROM class
            //     WHERE school_id = $school_id
            //     ORDER BY classname ASC";
            // Prepare statement to fetch classes for the current school
            $stmt = $conn->prepare("
                SELECT id, classname 
                FROM `class`
                WHERE school_id = ?
                ORDER BY classname ASC
            "); // Order alphabetically for the dropdown

            if (!$stmt) {
                throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }

            $stmt->bind_param("i", $school_id);
            $stmt->execute();
            $result = $stmt->get_result();
            $classes = $result->fetch_all(MYSQLI_ASSOC);
            $stmt->close();

            // Return the classes directly as a JSON array (suitable for Select2)
            echo json_encode($classes);
        } catch (Exception $e) {
            error_log("Error in get_classes: " . $e->getMessage());
            // Return an empty array in case of error, Select2 will handle it
            echo json_encode([]);
        }
        break; // End case 'get_classes'

    case 'get_bill_details':
        // check if the payment is recorded for the student in payment_log, if there is payment recorded, return a message.

        try {
            $bill_id = intval($_POST['bill_id']);
            $student_id = intval($_POST['student_id']);

            $query = "SELECT br.*, s.firstname, s.lastname, bt.bill_name 
                         FROM bill_record br
                         JOIN students s ON br.student_id = s.id
                         JOIN bill_type bt ON br.bill_type = bt.id
                         WHERE br.id = ? AND br.student_id = ?";

            $stmt = $conn->prepare($query);
            $stmt->bind_param("ii", $bill_id, $student_id);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($row = $result->fetch_assoc()) {
                // Parse breakdown (bill_items)
                $breakdown = [];
                if (!empty($row['bill_items'])) {
                    $items = json_decode($row['bill_items'], true);
                    if (is_array($items)) {
                        $breakdown = $items;
                    }
                }
                echo json_encode([
                    'success' => true,
                    'data' => [
                        'id' => $row['id'],
                        'student_id' => $row['student_id'],
                        'student_name' => $row['firstname'] . ' ' . $row['lastname'],
                        'bill_type' => $row['bill_type'],
                        'bill_type_name' => $row['bill_name'],
                        'amount_due' => $row['amount'],
                        // 'amount_paid' => $row['amount_paid'] ??  0,
                        // 'balance' => $row['balance'] ?? 0,
                        // 'status' => $row['status'] ?? 0,
                        'subtotal' => $row['amount'],
                        'deduction_purpose' => $row['deduction_purpose'],
                        'deduction_percentage' => $row['deduction_percentage'],
                        'tax' => $row['tax'],
                        'total_amount' => $row['amount_due'],
                        'notes' => $row['notes'],
                        'terms' => $row['terms'],
                        'breakdown' => $breakdown
                    ]
                ]);
            } else {
                echo json_encode(['success' => false, 'message' => 'Bill record not found']);
            }
        } catch (Exception $e) {
            echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
        }
        break;

    case 'update_bill':
        try {
            $bill_id = intval($_POST['bill_id']);
            $bill_type = intval($_POST['bill_type']);
            $amount_due = isset($_POST['total_amount']) ? floatval($_POST['total_amount']) : 0;
            $bill_items = isset($_POST['bill_items']) ? $_POST['bill_items'] : '';
            $deduction_purpose = isset($_POST['deduction_purpose']) ? trim($_POST['deduction_purpose']) : '';
            $deduction_percentage = isset($_POST['deduction_percentage']) ? floatval($_POST['deduction_percentage']) : 0;
            $tax = isset($_POST['tax']) ? floatval($_POST['tax']) : 0;
            $notes = isset($_POST['notes']) ? trim($_POST['notes']) : '';
            $terms = isset($_POST['terms']) ? trim($_POST['terms']) : '';
            $subtotal = isset($_POST['subtotal']) ? floatval($_POST['subtotal']) : 0;
            $total_amount = isset($_POST['total_amount']) ? floatval($_POST['total_amount']) : 0;

            // Validate JSON for bill_items
            if (!empty($bill_items) && !json_decode($bill_items)) {
                throw new Exception('Invalid breakdown (bill_items) JSON.');
            }


            // Use student_id, session_id, term_id from POST if provided, else fallback to DB
            $student_id = isset($_POST['student_id']) ? intval($_POST['student_id']) : null;
            $session_id = isset($_POST['session_id']) ? intval($_POST['session_id']) : null;
            $term_id = isset($_POST['term_id']) ? intval($_POST['term_id']) : null;
            if (!$student_id || !$session_id || !$term_id) {
                // Fallback to DB query if any is missing
                $stmt = $conn->prepare("SELECT student_id, session_id, term_id FROM bill_record WHERE id = ? LIMIT 1");
                if (!$stmt) throw new Exception("Prepare failed: " . $conn->error);
                $stmt->bind_param("i", $bill_id);
                $stmt->execute();
                $bill_row = $stmt->get_result()->fetch_assoc();
                $stmt->close();
                if (!$bill_row) {
                    throw new Exception("Bill record not found.");
                }
                $student_id = $bill_row['student_id'];
                $session_id = $bill_row['session_id'];
                $term_id = $bill_row['term_id'];
            }

            // Check if payment exists for this bill, student, session, term
            $stmt = $conn->prepare("SELECT id FROM payment_log WHERE bill_id = ? AND student_id = ? AND session_id = ? AND term_id = ? LIMIT 1");
            if (!$stmt) throw new Exception("Prepare failed: " . $conn->error);
            $stmt->bind_param("iiii", $bill_id, $student_id, $session_id, $term_id);
            $stmt->execute();
            $payment_exists = $stmt->get_result()->fetch_assoc();
            $stmt->close();

            if ($payment_exists) {
                echo json_encode(['success' => false, 'message' => 'Update not allowed: Payment already recorded for this bill, student, term, and session.']);
                break;
            }

            $query = "UPDATE bill_record SET 
                             bill_type = ?,
                             amount = ?,
                             amount_due = ?,
                             updatedby = ?,
                             dateupdated = NOW(),
                             bill_items = ?,
                             deduction_purpose = ?,
                             deduction_percentage = ?,
                             notes = ?,
                             terms = ?,
                             tax = ?
                             WHERE id = ?";
            $stmt = $conn->prepare($query);
            if (!$stmt) throw new Exception("Prepare failed: " . $conn->error);
            $stmt->bind_param(
                "idddssdssdi",
                $bill_type,           // i
                $subtotal,        // d
                $amount_due,          // d
                $_SESSION['userid'],  // i
                $bill_items,          // s
                $deduction_purpose,   // s
                $deduction_percentage, // d
                $notes,               // s
                $terms,               // s
                $tax,                 // d
                $bill_id              // i
            );

            if ($stmt->execute()) {
                echo json_encode(['success' => true]);
            } else {
                throw new Exception("Failed to update bill record");
            }
        } catch (Exception $e) {
            echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
        }
        break;
    case 'record_payment':
        try {
            // Get and validate input
            $student_id = filter_input(INPUT_POST, 'student_id', FILTER_VALIDATE_INT);
            $bill_id = filter_input(INPUT_POST, 'bill_id', FILTER_VALIDATE_INT);
            $amount_newly_paid = filter_input(INPUT_POST, 'amount_newly_paid', FILTER_VALIDATE_FLOAT);
            $payment_method_id = filter_input(INPUT_POST, 'payment_method', FILTER_VALIDATE_INT);
            // $status = filter_input(INPUT_POST, 'status', FILTER_VALIDATE_INT);
            $description = trim($_POST['description'] ?? '');
            $date_paid = filter_input(INPUT_POST, 'payment_date', FILTER_DEFAULT);
            $createdby = $user_id;
            $datecreated = $date;

            // Fetch bill record for this student and bill_id to get context (amount_due, subtotal, etc.)
            $stmt = $conn->prepare("SELECT br.*, s.class_id FROM bill_record br JOIN students s ON br.student_id = s.id WHERE br.id = ? AND br.student_id = ? AND br.school_id = ?");
            if (!$stmt) {
                throw new Exception("Prepare failed: (" . $conn->errno . ") " . $conn->error);
            }
            $stmt->bind_param("iii", $bill_id, $student_id, $school_id);
            $stmt->execute();
            $bill = $stmt->get_result()->fetch_assoc();
            $stmt->close();

            if (!$bill) {
                echo json_encode(['success' => false, 'message' => 'Bill record not found for this student.']);
                break;
            }
            // var_dump($bill);

            $subtotal = isset($bill['amount']) ? floatval($bill['amount']) : 0;
            $amount_due = isset($bill['amount_due']) ? floatval($bill['amount_due']) : 0;
            // Use POST values if provided, else fallback to bill record
            $class_id = isset($_POST['class_id']) && $_POST['class_id'] !== '' ? $_POST['class_id'] : (isset($bill['class_id']) ? $bill['class_id'] : '');
            $session_id = isset($_POST['session_id']) && $_POST['session_id'] !== '' ? $_POST['session_id'] : (isset($bill['session_id']) ? $bill['session_id'] : '');
            $term_id = isset($_POST['term_id']) && $_POST['term_id'] !== '' ? $_POST['term_id'] : (isset($bill['term_id']) ? $bill['term_id'] : '');

            // Get last total_amount_paid for this bill, student, school, session, and term
            $prev_paid = 0;
            $stmt = $conn->prepare("SELECT total_amount_paid FROM payment_log WHERE bill_id = ? AND student_id = ? AND school_id = ? AND session_id = ? AND term_id = ? ORDER BY date_paid DESC, id DESC LIMIT 1");
            $stmt->bind_param("iiiss", $bill_id, $student_id, $school_id, $session_id, $term_id);
            $stmt->execute();
            $result = $stmt->get_result();
            if ($row = $result->fetch_assoc()) {
                $prev_paid = floatval($row['total_amount_paid']);
            }
            $stmt->close();
            $total_amount_paid = $prev_paid + $amount_newly_paid;

            // Calculate balance
            $balance = $amount_due - $total_amount_paid;
            if ($balance < 0) $balance = 0;
            // echo "lml";
            // echo $balance;
            // exit;
            // Insert payment log
            $stmt = $conn->prepare("INSERT INTO payment_log (total_amount_paid, description, amount_newly_paid, balance, payment_method_id, student_id, school_id, session_id, term_id, class_id, date_paid, createdby, datecreated, bill_id) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            // Ensure numeric IDs are integers to match the bind types
            $payment_method_id = intval($payment_method_id);
            $student_id = intval($student_id);
            $school_id = intval($school_id);
            $session_id = intval($session_id);
            $term_id = intval($term_id);
            $class_id = intval($class_id);
            $createdby = intval($createdby);

            // Types: d (double), s (string), d (double), d (double),
            // then six integers (payment_method_id, student_id, school_id, session_id, term_id, class_id),
            // then s (date_paid), i (createdby), s (datecreated), i (bill_id)
            $typeStr = "dsddiiiiiisisi"; // 14 types matching the 14 variables below
            $stmt->bind_param(
                $typeStr,
                $total_amount_paid,
                $description,
                $amount_newly_paid,
                $balance,
                $payment_method_id,
                $student_id,
                $school_id,
                $session_id,
                $term_id,
                $class_id,
                $date_paid,
                $createdby,
                $datecreated,
                $bill_id
            );
            if ($stmt->execute()) {
                $stmt->close();
                echo json_encode(['success' => true, 'message' => 'Payment recorded successfully.']);
            } else {
                $stmt->close();
                echo json_encode(['success' => false, 'message' => 'Failed to record payment.']);
            }
        } catch (Exception $e) {
            error_log("Error in record_payment: " . $e->getMessage());
            echo json_encode(['success' => false, 'message' => 'Error recording payment: ' . $e->getMessage()]);
        }
        break;
    case 'quick_assign_bill':
        // Use similar logic as assign_bill_to_students
        if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
            echo json_encode(['success' => false, 'message' => 'Invalid request method.']);
            break;
        }

        $conn->begin_transaction();
        try {
            $bill_type_id = filter_input(INPUT_POST, 'bill_type_id', FILTER_VALIDATE_INT);
            $term_id = filter_input(INPUT_POST, 'term_id', FILTER_VALIDATE_INT);
            $session_id = filter_input(INPUT_POST, 'session_id', FILTER_VALIDATE_INT);
            $tax = filter_input(INPUT_POST, 'assign_tax', FILTER_VALIDATE_FLOAT);
            $students_json = $_POST['students'] ?? null;

            // Invoice fields
            $subtotal = isset($_POST['assign_subtotal']) ? floatval($_POST['assign_subtotal']) : 0;
            $deduction_purpose = trim($_POST['assign_deduction_purpose'] ?? '');
            $deduction_percentage = isset($_POST['assign_deduction_percentage']) ? floatval($_POST['assign_deduction_percentage']) : 0;
            $notes = trim($_POST['assign_notes'] ?? '');
            $terms = trim($_POST['assign_terms'] ?? '');
            $total = isset($_POST['assign_total_amount']) ? floatval($_POST['assign_total_amount']) : 0;

            // Breakdown items
            $breakdownDescriptions = isset($_POST['assign_breakdown_description']) ? (array)$_POST['assign_breakdown_description'] : [];
            // var_dump($breakdownDescriptions);
            // exit;
            $breakdownAmounts = isset($_POST['assign_breakdown_amount']) ? (array)$_POST['assign_breakdown_amount'] : [];
            $billItems = [];
            $count = max(count($breakdownDescriptions), count($breakdownAmounts));
            for ($i = 0; $i < $count; $i++) {
                $desc = $breakdownDescriptions[$i] ?? '';
                $amt = isset($breakdownAmounts[$i]) ? floatval($breakdownAmounts[$i]) : 0;
                if ($desc !== '' || $amt > 0) {
                    $billItems[] = [
                        $desc => $amt
                    ];
                }
            }
            $billItemsJson = json_encode($billItems);

            if (!$bill_type_id || !$term_id || !$session_id || $total < 0 || $tax < 0 || empty($students_json)) {
                throw new Exception('Missing or invalid data.');
            }
            $students = json_decode($students_json, true);
            if (json_last_error() !== JSON_ERROR_NONE || !is_array($students) || empty($students)) {
                throw new Exception('Invalid students data.');
            }

            // $status = 0; // not paid
            // $last_payment = '0000-00-00 00:00:00';
            // $amount_paid = 0;
            $updatedby = $_SESSION['userid'];
            $school_id = $_SESSION['school_id'];
            $class_id = isset($_POST['class_id']) ? intval($_POST['class_id']) : 0;

            $inserted_count = 0;
            $stmt = $conn->prepare("INSERT INTO bill_record (
                bill_type, student_id, school_id, class_id, term_id, session_id, amount, amount_due, createdby, datecreated, updatedby, dateupdated, bill_items, deduction_purpose, deduction_percentage, notes, terms, tax
            ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?, NOW(), ?, ?, ?, ?, ?, ?)");
            if (!$stmt) {
                throw new Exception('Prepare failed: ' . $conn->error);
            }

            foreach ($students as $student_data) {
                $student_id = isset($student_data['id']) ? intval($student_data['id']) : 0;
                if (!$student_id) continue;
                $amount_due = $total;
                // $balance = $total;
                $stmt->bind_param(
                    "iiiiiiddiissdssd",
                    $bill_type_id,
                    $student_id,
                    $school_id,
                    $class_id,
                    $term_id,
                    $session_id,
                    // $status,
                    // $last_payment,
                    $subtotal,
                    // $amount_paid,
                    $amount_due,
                    // $balance,
                    $_SESSION['userid'],
                    $updatedby,
                    $billItemsJson,
                    $deduction_purpose,
                    $deduction_percentage,
                    $notes,
                    $terms,
                    $tax
                );
                if ($stmt->execute()) {
                    $inserted_count++;
                }
            }
            $stmt->close();
            if ($conn->commit()) {
                echo json_encode(['success' => true, 'message' => "Bill successfully assigned to {$inserted_count} student(s)."]);
            } else {
                throw new Exception('Failed to commit transaction.');
            }
        } catch (Exception $e) {
            $conn->rollback();
            echo json_encode(['success' => false, 'message' => $e->getMessage()]);
        }
        break;
    // Make sure this is before the 'default:' case

    case 'get_expected_income':
        // Fetch total expected income and student payment stats for a class and for all classes in a term/session/bill_type
        try {
            $class_id = isset($_POST['class_id']) ? intval($_POST['class_id']) : 0;
            $session_id = isset($_POST['session_id']) ? intval($_POST['session_id']) : 0;
            $term_id = isset($_POST['term_id']) ? intval($_POST['term_id']) : 0;
            $bill_type = isset($_POST['bill_type']) ? $_POST['bill_type'] : 'all';

            // Helper function to get stats for a class (or all classes if $class_id = 0)
            function get_stats($conn, $school_id, $session_id, $term_id, $class_id, $bill_type)
            {
                $params = [$school_id];
                $class_filter = '';
                if ($class_id) {
                    $class_filter = 'AND s.class_id = ?';
                    $params[] = $class_id;
                }
                // Get all students in class
                $sql = "SELECT s.id as student_id FROM students s WHERE s.school_id = ? ";
                if ($class_id) $sql .= "AND s.class_id = ? ";
                $stmt = $conn->prepare($sql);
                $stmt->bind_param($class_id ? "ii" : "i", ...$params);
                $stmt->execute();
                $students = [];
                $res = $stmt->get_result();
                while ($row = $res->fetch_assoc()) $students[] = $row['student_id'];
                $stmt->close();
                $total_students = count($students);
                if ($total_students === 0) {
                    return [
                        'total_students' => 0,
                        'students_paid' => 0,
                        'students_completed' => 0,
                        'students_unpaid' => 0,
                        'total_due' => 0,
                        'total_paid' => 0,
                        'total_left' => 0
                    ];
                }
                // Get all bill records for these students
                $in = implode(',', array_fill(0, count($students), '?'));
                $types = str_repeat('i', count($students));
                $params_br = [$school_id, $session_id, $term_id];
                $sql = "SELECT br.id, br.amount_due, br.student_id FROM bill_record br WHERE br.school_id = ? AND br.session_id = ? AND br.term_id = ? ";
                if ($bill_type !== 'all') {
                    $sql .= "AND br.bill_type = ? ";
                    $params_br[] = $bill_type;
                }
                if ($class_id) {
                    $sql .= "AND br.class_id = ? ";
                    $params_br[] = $class_id;
                }
                $sql .= "AND br.student_id IN ($in)";
                $all_params = array_merge($params_br, $students);
                $stmt = $conn->prepare($sql);
                $stmt->bind_param(str_repeat('i', count($all_params)), ...$all_params);
                $stmt->execute();
                $bills = [];
                $res = $stmt->get_result();
                while ($row = $res->fetch_assoc()) $bills[] = $row;
                $stmt->close();
                $total_due = 0;
                $student_bill_map = [];
                foreach ($bills as $bill) {
                    $total_due += floatval($bill['amount_due']);
                    $student_bill_map[$bill['student_id']][] = $bill['id'];
                }
                // Get all payments for these bills
                $all_bill_ids = [];
                foreach ($bills as $bill) $all_bill_ids[] = $bill['id'];
                if (count($all_bill_ids) === 0) {
                    return [
                        'total_students' => $total_students,
                        'students_paid' => 0,
                        'students_completed' => 0,
                        'students_unpaid' => 0,
                        'total_due' => $total_due,
                        'total_paid' => 0,
                        'total_left' => $total_due
                    ];
                }
                $in_bills = implode(',', array_fill(0, count($all_bill_ids), '?'));
                $sql = "SELECT bill_id, student_id, SUM(amount_newly_paid) as paid FROM payment_log WHERE bill_id IN ($in_bills) AND school_id = ? GROUP BY bill_id, student_id";
                $stmt = $conn->prepare($sql);
                $params_bills = array_merge($all_bill_ids, [$school_id]);
                $stmt->bind_param(str_repeat('i', count($params_bills)), ...$params_bills);
                $stmt->execute();
                $res = $stmt->get_result();
                $student_paid_map = [];
                $total_paid = 0;
                while ($row = $res->fetch_assoc()) {
                    $student_paid_map[$row['student_id']] = ($student_paid_map[$row['student_id']] ?? 0) + floatval($row['paid']);
                    $total_paid += floatval($row['paid']);
                }
                $stmt->close();
                $students_paid = 0;
                $students_completed = 0;
                $students_unpaid = 0;
                foreach ($students as $sid) {
                    $due = 0;
                    if (isset($student_bill_map[$sid])) {
                        foreach ($student_bill_map[$sid] as $bid) {
                            foreach ($bills as $b) {
                                if ($b['id'] == $bid) $due += floatval($b['amount_due']);
                            }
                        }
                    }
                    $paid = $student_paid_map[$sid] ?? 0;
                    if ($paid > 0) $students_paid++;
                    if ($paid >= $due && $due > 0) $students_completed++;
                    if ($paid == 0 && $due > 0) $students_unpaid++;
                }
                $total_left = $total_due - $total_paid;
                return [
                    'total_students' => $total_students,
                    'students_paid' => $students_paid,
                    'students_completed' => $students_completed,
                    'students_unpaid' => $students_unpaid,
                    'total_due' => $total_due,
                    'total_paid' => $total_paid,
                    'total_left' => $total_left,
                    // Number of students who have a bill_record for the selected bill_type (assigned count)
                    'students_assigned' => count($student_bill_map)
                ];
            }

            $class_stats = get_stats($conn, $school_id, $session_id, $term_id, $class_id, $bill_type);
            $all_stats = get_stats($conn, $school_id, $session_id, $term_id, 0, $bill_type);

            echo json_encode([
                'success' => true,
                'class_total' => $class_stats['total_due'],
                'all_total' => $all_stats['total_due'],
                'class_paid' => $class_stats['total_paid'],
                'all_paid' => $all_stats['total_paid'],
                'class_left' => $class_stats['total_left'],
                'all_left' => $all_stats['total_left'],
                'class_total_students' => $class_stats['total_students'],
                'all_total_students' => $all_stats['total_students'],
                'class_students_paid' => $class_stats['students_paid'],
                'all_students_paid' => $all_stats['students_paid'],
                'class_students_completed' => $class_stats['students_completed'],
                'all_students_completed' => $all_stats['students_completed'],
                'class_students_unpaid' => $class_stats['students_unpaid'],
                'all_students_unpaid' => $all_stats['students_unpaid'],
                // New fields: total number of students assigned to the selected bill_type
                'class_students_assigned' => isset($class_stats['students_assigned']) ? $class_stats['students_assigned'] : 0,
                'all_students_assigned' => isset($all_stats['students_assigned']) ? $all_stats['students_assigned'] : 0
            ]);
        } catch (Exception $e) {
            echo json_encode(['success' => false, 'message' => 'Error: ' . $e->getMessage()]);
        }
        break;
        case 'get_invoice':
        // Return structured JSON for a bill invoice preview
        try {
            $bill_id = isset($_POST['bill_id']) ? intval($_POST['bill_id']) : 0;
            if (!$bill_id) {
                echo json_encode(['success' => false, 'message' => 'Missing bill_id']);
                break;
            }

            // Fetch bill_record
            $stmt = $conn->prepare("SELECT * FROM bill_record WHERE id = ? AND school_id = ? LIMIT 1");
            $stmt->bind_param("ii", $bill_id, $school_id);
            $stmt->execute();
            $bill = $stmt->get_result()->fetch_assoc();
            $stmt->close();

            if (!$bill) {
                echo json_encode(['success' => false, 'message' => 'Bill not found']);
                break;
            }

            // Fetch student
            $student = null;
            if (!empty($bill['student_id'])) {
                $sid = intval($bill['student_id']);
                $stmt = $conn->prepare("SELECT id, firstname, lastname, admission_no, class_id FROM students WHERE id = ? AND school_id = ? LIMIT 1");
                $stmt->bind_param("ii", $sid, $school_id);
                $stmt->execute();
                $student = $stmt->get_result()->fetch_assoc();
                $stmt->close();
            }

            // Fetch parent info if available (students.parent_id)
            $parent = null;
            if (!empty($student['id'])) {
                // Attempt to read parent_id from students table
                $stmt = $conn->prepare("SELECT parent_id FROM students WHERE id = ? AND school_id = ? LIMIT 1");
                $stmt->bind_param("ii", $student['id'], $school_id);
                $stmt->execute();
                $srow = $stmt->get_result()->fetch_assoc();
                $stmt->close();
                if (!empty($srow['parent_id'])) {
                    $pid = intval($srow['parent_id']);
                    $pst = $conn->prepare("SELECT id, firstname, lastname, phone, email, address, city, state, country FROM parent WHERE id = ? AND school_id = ? LIMIT 1");
                    if ($pst !== false) {
                        $pst->bind_param("ii", $pid, $school_id);
                        $pst->execute();
                        $parent = $pst->get_result()->fetch_assoc();
                        $pst->close();
                    }
                }
            }

            // Fetch bill_type
            $bill_type = null;
            if (!empty($bill['bill_type'])) {
                $btid = intval($bill['bill_type']);
                $stmt = $conn->prepare("SELECT * FROM bill_type WHERE id = ? AND school_id = ? LIMIT 1");
                $stmt->bind_param("ii", $btid, $school_id);
                $stmt->execute();
                $bill_type = $stmt->get_result()->fetch_assoc();
                $stmt->close();
            }

            // School info from session
            $school_name = isset($_SESSION['school_name']) ? $_SESSION['school_name'] : '';
            $school_logo = isset($_SESSION['logo']) ? $_SESSION['logo'] : '';
            $school_phone = isset($_SESSION['phone1']) ? $_SESSION['phone1'] : '';
            $school_email = isset($_SESSION['email']) ? $_SESSION['email'] : '';
            $school_address = isset($_SESSION['address']) ? $_SESSION['address'] : '';

            echo json_encode(['success' => true, 'data' => [
                'bill' => $bill,
                'student' => $student,
                'parent' => $parent,
                'bill_type' => $bill_type,
                'school_name' => $school_name,
                'school_logo' => $school_logo,
                'school_phone' => $school_phone,
                'school_email' => $school_email,
                'school_address' => $school_address
            ]]);
        } catch (Exception $e) {
            echo json_encode(['success' => false, 'message' => 'Server error']);
        }
        break;

    default:
        echo json_encode(['success' => false, 'message' => 'Invalid action specified.']);
        break;
}

$conn->close(); // Close the database connection
exit(); // Terminate script execution