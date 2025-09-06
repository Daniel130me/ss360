<?php
$conn = mysqli_connect('localhost','root','','ss360');
if(!$conn) {
    die("Error connecting to the database". mysqli_error($conn));
}
?>