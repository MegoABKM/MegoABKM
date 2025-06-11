<?php 

include "../connect.php";


$userid = filterRequest("usersid");
$itemsid = filterRequest("itemsid");

 
$count = getData("cart","cart_itemsid = $itemsid AND cart_userid = $userid AND cart_orders = 0",null,false);


    $data =array("cart_itemsid"=>$itemsid,"cart_userid"=>$userid );

insertData('cart',$data);



