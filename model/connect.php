<?php
$host =  $_SESSION['env'] == 'prod' ? 'ss360-db-do-user-34699889-0.d.db.ondigitalocean.com' : 'localhost';
$user = $_SESSION['env'] == 'prod' ? 'doadmin' : 'root';
$pass = $_SESSION['env'] == 'prod' ? 'AVNS_VGV1tkSdGGmh4pSBvX1' : '';
$db = $_SESSION['env'] == 'prod' ? 'defaultdb' : 'ss360';
$port = $_SESSION['env'] == 'prod' ? 25060 : 3306;
$apply_ssl = $_SESSION['env'] == 'prod' ? MYSQLI_CLIENT_SSL : null;

$conn = mysqli_init();
if (!$conn) {
    die('mysqli_init failed');
}

// Connect over SSL as required by DigitalOcean
if (!mysqli_real_connect($conn, $host, $user, $pass, $db, $port, NULL, $apply_ssl)) {
    die("Connect Error: " . mysqli_connect_error());
}

mysqli_query($conn, "SET time_zone = 'Africa/Lagos'");

if (!$conn) {
    die("Error connecting to the database" . mysqli_error($conn));
}
