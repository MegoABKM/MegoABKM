<?php

include "../connect.php";
$orderid =  filterRequest("orderid");
$usersid = filterRequest("usersid");

$data = array("orders_status" => 1 );
$count = updateData("orders", $data , "orders_id = $orderid AND orders_status = 0" ); 

if($count >0){
    insertNotify("success", "The Order $orderid Has Been Approved", $usersid,"none","refreshorderpage");
}
