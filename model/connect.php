<?php
$host =  $_SESSION['env'] == 'prod' ? 'ss360-db-do-user-34699889-0.d.db.ondigitalocean.com' : 'localhost';
// $host =  $_SESSION['env'] == 'prod' ? 'ss360-db-do-user-34699889-0.d.db.ondigitalocean.com' : 'localhost';
$user = $_SESSION['env'] == 'prod' ? 'G.s.o.m.' : 'root';
// $user = $_SESSION['env'] == 'prod' ? 'doadmin' : 'root';
$pass = $_SESSION['env'] == 'prod' ? 'AVNS_VGV1tkSdGGmh4pSBvX1' : '';
// $pass = $_SESSION['env'] == 'prod' ? 'AVNS_VGV1tkSdGGmh4pSBvX1' : 'g.s.O.m.1.2.3.e';
// $pass = $_SESSION['env'] == 'prod' ? 'AVNS_VGV1tkSdGGmh4pSBvX1' : '';
$db = $_SESSION['env'] == 'prod' ? 'ss360' : 'ss360';
// $db = $_SESSION['env'] == 'prod' ? 'defaultdb' : 'ss360';
$port = $_SESSION['env'] == 'prod' ? 3306 : 3306;
// $port = $_SESSION['env'] == 'prod' ? 25060 : 3306;
$apply_ssl = $_SESSION['env'] == 'prod' ? MYSQLI_CLIENT_SSL : 0;

$conn = mysqli_init();
if (!$conn) {
    die('mysqli_init failed');
}

// Connect over SSL as required by DigitalOcean
if (!mysqli_real_connect($conn, $host, $user, $pass, $db, $port, 0, $apply_ssl)) {
    die("Connect Error: " . mysqli_connect_error());
}

try {
    mysqli_query($conn, "SET time_zone = 'Africa/Lagos'");
} catch (mysqli_sql_exception $e) {
    mysqli_query($conn, "SET time_zone = '+01:00'");
}

if (!$conn) {
    die("Error connecting to the database" . mysqli_error($conn));
}
