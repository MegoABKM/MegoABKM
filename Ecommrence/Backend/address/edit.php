<?php 


include "../connect.php";

$addressid = filterRequest("addressid");
$address = "address";
$name = filterRequest("name");
$userid = filterRequest("usersid");
$lat = filterRequest("lat");
$long = filterRequest("long");
$city = filterRequest("city");
$street = filterRequest("street");

$data = array(
"address_lat"=> $lat,
"address_long"=> $long,
"address_city"=> $city,
"address_street"=> $street,
"address_name"=> $name,

);


$count = updateData($address,$data, "address_id = $addressid");