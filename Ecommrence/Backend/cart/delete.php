<?php 

include "../connect.php";

$userid = filterRequest("usersid");
$itemsid = filterRequest("itemsid");

// Correct the SQL query
deleteData("cart", "cart_id = (SELECT cart_id FROM cart WHERE cart_userid = $userid AND cart_itemsid = $itemsid AND cart_orders = 0 LIMIT 1)");
