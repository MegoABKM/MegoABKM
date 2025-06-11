<?php 



include "../connect.php";
$orderid = filterRequest("id");

deleteData("orders","orders_id = $orderid AND orders_status = 0");