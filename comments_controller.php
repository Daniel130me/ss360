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
    $score_from = intval($_POST['score_from'] ?? 0);
    $score_to = intval($_POST['score_to'] ?? 100);
    $now = date('Y-m-d H:i:s');
    $stmt = mysqli_prepare($conn, "UPDATE suggested_comments SET comment=?, score_from=?, score_to=?, dateupdated=? WHERE id=?");
    mysqli_stmt_bind_param($stmt, 'siisi', $comment, $score_from, $score_to, $now, $id);
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
    $where = "sc.school_id='" . mysqli_real_escape_string($conn, $school_id) . "'";
    if ($search !== '') {
        $search_esc = mysqli_real_escape_string($conn, $search);
        $where .= " AND sc.comment LIKE '%$search_esc%'";
    }
    // Get total count
    $count_sql = "SELECT COUNT(*) as total FROM suggested_comments sc WHERE $where";
    $count_query = mysqli_query($conn, $count_sql);
    $total = 0;
    if ($count_query && ($count_row = mysqli_fetch_assoc($count_query))) {
        $total = intval($count_row['total']);
    }
    // Get paginated data with staff name
    $sql = "SELECT sc.id, sc.comment, sc.commentby, sc.score_from, sc.score_to, 
            CONCAT(s.firstname, ' ', s.lastname) as commentby_name
            FROM suggested_comments sc
            LEFT JOIN staff s ON sc.commentby = s.id
            WHERE $where ORDER BY sc.datecreated DESC LIMIT $per_page OFFSET $offset";
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
    $score_from = intval($_POST['score_from'] ?? 0);
    $score_to = intval($_POST['score_to'] ?? 100);
    $now = date('Y-m-d H:i:s');
    $stmt = mysqli_prepare($conn, "INSERT INTO suggested_comments (comment, commentby, score_from, score_to, school_id, datecreated, dateupdated) VALUES (?, ?, ?, ?, ?, ?, ?)");
    mysqli_stmt_bind_param($stmt, 'siiisss', $comment, $commentby, $score_from, $score_to, $school_id, $now, $now);
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