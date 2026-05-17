<?php

const SS360_AI_DEFAULT_DAILY_LIMIT = 5;

function ss360_ai_usage_ensure_schema($conn)
{
    static $schema_checked = false;
    if ($schema_checked) {
        return;
    }

    $create_sql = "CREATE TABLE IF NOT EXISTS ai_usage_logs (
        id INT AUTO_INCREMENT PRIMARY KEY,
        user_id INT NOT NULL,
        usage_date DATE NOT NULL,
        generation_count INT NOT NULL DEFAULT 0,
        daily_limit INT NOT NULL DEFAULT 5,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP NULL DEFAULT NULL,
        KEY idx_ai_usage_user_date (user_id, usage_date)
    )";
    mysqli_query($conn, $create_sql);

    $column_result = mysqli_query($conn, "SHOW COLUMNS FROM ai_usage_logs LIKE 'daily_limit'");
    if ($column_result && mysqli_num_rows($column_result) === 0) {
        mysqli_query($conn, "ALTER TABLE ai_usage_logs ADD daily_limit INT NOT NULL DEFAULT 5 AFTER generation_count");
    }

    $column_result = mysqli_query($conn, "SHOW COLUMNS FROM ai_usage_logs LIKE 'updated_at'");
    if ($column_result && mysqli_num_rows($column_result) === 0) {
        mysqli_query($conn, "ALTER TABLE ai_usage_logs ADD updated_at TIMESTAMP NULL DEFAULT NULL AFTER created_at");
    }

    $index_result = mysqli_query($conn, "SHOW INDEX FROM ai_usage_logs WHERE Key_name = 'idx_ai_usage_user_date'");
    if ($index_result && mysqli_num_rows($index_result) === 0) {
        mysqli_query($conn, "ALTER TABLE ai_usage_logs ADD INDEX idx_ai_usage_user_date (user_id, usage_date)");
    }

    $schema_checked = true;
}

function ss360_ai_usage_today()
{
    return date('Y-m-d');
}

function ss360_ai_usage_get($conn, $user_id, $usage_date = null)
{
    ss360_ai_usage_ensure_schema($conn);

    $usage_date = $usage_date ?: ss360_ai_usage_today();
    $stmt = $conn->prepare("SELECT id, generation_count, daily_limit FROM ai_usage_logs WHERE user_id = ? AND usage_date = ? ORDER BY id DESC LIMIT 1");
    $stmt->bind_param("is", $user_id, $usage_date);
    $stmt->execute();
    $result = $stmt->get_result();
    $row = $result->fetch_assoc();
    $stmt->close();

    if (!$row) {
        $default_limit = SS360_AI_DEFAULT_DAILY_LIMIT;
        $zero_count = 0;
        $stmt = $conn->prepare("INSERT INTO ai_usage_logs (user_id, usage_date, generation_count, daily_limit) VALUES (?, ?, ?, ?)");
        $stmt->bind_param("isii", $user_id, $usage_date, $zero_count, $default_limit);
        $stmt->execute();
        $row = [
            'id' => $stmt->insert_id,
            'generation_count' => $zero_count,
            'daily_limit' => $default_limit,
        ];
        $stmt->close();
    }

    $limit = (int)($row['daily_limit'] ?? SS360_AI_DEFAULT_DAILY_LIMIT);
    if ($limit < 0) {
        $limit = 0;
    }

    $used = (int)($row['generation_count'] ?? 0);
    if ($used < 0) {
        $used = 0;
    }

    return [
        'id' => (int)$row['id'],
        'used' => $used,
        'limit' => $limit,
        'remaining' => max(0, $limit - $used),
        'usage_date' => $usage_date,
    ];
}

function ss360_ai_usage_can_consume($conn, $user_id, $units = 1, $usage_date = null)
{
    $units = max(1, (int)$units);
    $usage = ss360_ai_usage_get($conn, $user_id, $usage_date);
    $usage['requested'] = $units;
    $usage['allowed'] = $usage['remaining'] >= $units;

    return $usage;
}

function ss360_ai_usage_record_success($conn, $user_id, $units = 1, $usage_date = null)
{
    $units = max(1, (int)$units);
    $usage = ss360_ai_usage_get($conn, $user_id, $usage_date);
    $new_used = $usage['used'] + $units;

    $stmt = $conn->prepare("UPDATE ai_usage_logs SET generation_count = ?, updated_at = NOW() WHERE id = ?");
    $stmt->bind_param("ii", $new_used, $usage['id']);
    $stmt->execute();
    $stmt->close();

    $usage['used'] = $new_used;
    $usage['remaining'] = max(0, $usage['limit'] - $new_used);
    $usage['allowed'] = $usage['remaining'] > 0;

    return $usage;
}

