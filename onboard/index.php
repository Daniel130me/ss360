<?php
$url = $_SERVER["REQUEST_URI"];

$parameter = explode("/", $url);
$pages = array("subjects","staff","school","register_staff_self");
if(in_array($parameter[3], $pages)) {
    include($parameter[3].".php");
    exit;
}

if($parameter[3] == "") {
    include("school.php");
    exit;
}
?>