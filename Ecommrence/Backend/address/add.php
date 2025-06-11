<?php 


include "../connect.php";

$address = "address";
$userid = filterRequest("usersid");
$name = filterRequest("name");
$lat = filterRequest("lat");
$long = filterRequest("long");
$city = filterRequest("city");
$street = filterRequest("street");

$data = array(
"address_userid" => $userid,
"address_lat"=> $lat,
"address_long"=> $long,
"address_city"=> $city,
"address_street"=> $street,
"address_name"=> $name,

);


$count = insertData($address,$data);