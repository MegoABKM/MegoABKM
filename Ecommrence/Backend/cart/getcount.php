<?php

include "../connect.php";

$userid = filterRequest("usersid");
$itemsid = filterRequest("itemsid");

$stmt = $con->prepare("SELECT COUNT(cart.cart_id) AS Countitems
FROM cart
WHERE cart_itemsid = $itemsid AND cart_userid = $userid And cart_orders = 0");


$stmt->execute();
$count = $stmt->rowCount();
$data = $stmt->fetchColumn();


if ($count > 0) {

    echo json_encode(array("status" => "success", "data" => $data));
}
else{

    echo json_encode(array("status" => "success", "data" => "0"));

}