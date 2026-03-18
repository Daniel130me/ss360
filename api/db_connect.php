<?php
// db_connect.php - Database Connection for License Server

// BLUEHOST CONFIGURATION
// Edit these values to match your Bluehost database credentials
define('DB_HOST', 'localhost');
define('DB_NAME', 'ekmapxmy_licenses'); // Change to your actual DB name
define('DB_USER', 'ekmapxmy_oluwagbenga');     // Change to your actual DB user
define('DB_PASS', 'G.s.o.m.');     // Change to your actual DB password

try {
    $pdo = new PDO("mysql:host=" . DB_HOST . ";dbname=" . DB_NAME . ";charset=utf8mb4", DB_USER, DB_PASS);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    // In production, don't show detailed errors to the user
    error_log("Database Connection Error: " . $e->getMessage());
    http_response_code(500);
    die(json_encode(['success' => false, 'message' => 'Internal Server Error']));
}
