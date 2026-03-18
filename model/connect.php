<?php
$conn = mysqli_connect('localhost','ekmapxmy_oluwagbenga','G.s.o.m.','ekmapxmy_ss360');
mysqli_query($conn, "SET time_zone = 'Africa/Lagos'");
// die('lk');
if(!$conn) {
    die("Error connecting to the database". mysqli_error($conn));
}
?>