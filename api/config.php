<?php
// cloud_panel/config.php

// Ensure session is started before any script runs
if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

require_once __DIR__ . '/db_connect.php';

// Global alias for scripts still using $db
$db = $pdo;

/**
 * Legacy wrapper for files still using getDB()
 */
if (!function_exists('getDB')) {
    function getDB()
    {
        global $pdo;
        return $pdo;
    }
}
