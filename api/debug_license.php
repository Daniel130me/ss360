<?php
// cloud_panel/debug_license.php
// Place this in your cloud_panel folder to check what's in the DB
require_once 'config.php';

$license = $_GET['license'] ?? '';

if (empty($license)) {
    die("Usage: debug_license.php?license=YOUR_KEY");
}

try {
    $stmt = $db->prepare("SELECT id, school_name, is_active, license_key FROM schools WHERE license_key = ?");
    $stmt->execute([$license]);
    $school = $stmt->fetch();

    if ($school) {
        echo "<h1>License Found</h1>";
        echo "<pre>";
        print_r($school);
        echo "</pre>";
        if (!$school['is_active']) {
            echo "<p style='color:red'><strong>CRITICAL:</strong> This license is marked as INACTIVE (is_active = 0). This causes the 403 error.</p>";
        }
    } else {
        echo "<h1 style='color:red'>License NOT Found</h1>";
        echo "<p>No school record exists for key: <strong>$license</strong></p>";

        // Let's show all licenses for debugging
        echo "<h2>Available Licenses in DB:</h2>";
        $all = $db->query("SELECT license_key, school_name FROM schools")->fetchAll();
        echo "<ul>";
        foreach ($all as $row) {
            echo "<li>" . htmlspecialchars($row['license_key']) . " (" . htmlspecialchars($row['school_name']) . ")</li>";
        }
        echo "</ul>";
    }
} catch (Exception $e) {
    echo "Error: " . $e->getMessage();
}
