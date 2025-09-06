<?php
session_start();
header('Content-Type: application/json');
include_once("model/connect.php");

$action = isset($_POST['action']) ? $_POST['action'] : '';
if ($action === 'delete') {
    $id = intval($_POST['id'] ?? 0);
    if ($id < 1) {
        echo json_encode(['success' => false, 'message' => 'Invalid input']);
        exit;
    }
    $stmt = mysqli_prepare($conn, "DELETE FROM suggested_comments WHERE id=?");
    mysqli_stmt_bind_param($stmt, 'i', $id);
    $ok = mysqli_stmt_execute($stmt);
    if ($ok) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'DB error']);
    }
    exit;
}
if ($action === 'edit') {
    $id = intval($_POST['id'] ?? 0);
    $comment = trim($_POST['comment'] ?? '');
    if ($id < 1 || $comment === '') {
        echo json_encode(['success' => false, 'message' => 'Invalid input']);
        exit;
    }
    $now = date('Y-m-d H:i:s');
    $stmt = mysqli_prepare($conn, "UPDATE suggested_comments SET comment=?, dateupdated=? WHERE id=?");
    mysqli_stmt_bind_param($stmt, 'ssi', $comment, $now, $id);
    $ok = mysqli_stmt_execute($stmt);
    if ($ok) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'DB error']);
    }
    exit;
}

if ($action === 'list') {
    $result = [];
    $school_id = $_SESSION['school_id'] ?? 0;
    if ($school_id < 1) {
        echo json_encode(['success' => false, 'message' => 'Invalid school ID']);
        exit;
    }
    // Pagination params
    $page = max(1, intval($_POST['page'] ?? 1));
    $per_page = max(1, intval($_POST['per_page'] ?? 10));
    $offset = ($page - 1) * $per_page;
    // Search param
    $search = trim($_POST['search'] ?? '');
    $where = "school_id='" . mysqli_real_escape_string($conn, $school_id) . "'";
    if ($search !== '') {
        $search_esc = mysqli_real_escape_string($conn, $search);
        $where .= " AND comment LIKE '%$search_esc%'";
    }
    // Get total count
    $count_sql = "SELECT COUNT(*) as total FROM suggested_comments WHERE $where";
    $count_query = mysqli_query($conn, $count_sql);
    $total = 0;
    if ($count_query && ($count_row = mysqli_fetch_assoc($count_query))) {
        $total = intval($count_row['total']);
    }
    // Get paginated data
    $sql = "SELECT id, comment FROM suggested_comments WHERE $where ORDER BY datecreated DESC LIMIT $per_page OFFSET $offset";
    $query = mysqli_query($conn, $sql);
    while ($row = mysqli_fetch_assoc($query)) {
        $result[] = $row;
    }
    echo json_encode([
        'success' => true,
        'data' => $result,
        'total' => $total,
        'page' => $page,
        'per_page' => $per_page
    ]);
    exit;
}

if ($action === 'add') {
    $comment = trim($_POST['comment'] ?? '');
    if ($comment === '') {
        echo json_encode(['success' => false, 'message' => 'Comment cannot be empty']);
        exit;
    }
    $commentby = $_SESSION['userid'] ?? 0;
    $school_id = $_SESSION['school_id'] ?? 0;
    $now = date('Y-m-d H:i:s');
    $stmt = mysqli_prepare($conn, "INSERT INTO suggested_comments (comment, commentby, school_id, datecreated, dateupdated) VALUES (?, ?, ?, ?, ?)");
    mysqli_stmt_bind_param($stmt, 'sisss', $comment, $commentby, $school_id, $now, $now);
    $ok = mysqli_stmt_execute($stmt);
    if ($ok) {
        echo json_encode(['success' => true]);
    } else {
        echo json_encode(['success' => false, 'message' => 'DB error']);
    }
    exit;
}

echo json_encode(['success' => false, 'message' => 'Invalid action']);
exit;
?>