
<?php
include "../connect.php";


$userid = filterRequest("usersid");
$itemsid = filterRequest("itemsid");


$data = array(
    "favorite_usersid" => $userid,
    "favorite_itemsid" => $itemsid,
);

insertData("favorite",$data);


