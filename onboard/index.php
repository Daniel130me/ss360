<?php
$url = $_SERVER["REQUEST_URI"];
$parameter = explode("/", $url);
// echo $parameter[2];
// exit;
$pages = array("subjects","staff","school","register_staff_self");
if(in_array($parameter[2], $pages)) {
    include($parameter[2].".php");
    exit;
}



if($parameter[2] == "") {
    include("school.php");
    exit;
}

?>