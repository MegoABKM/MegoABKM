<?php 



include "../connect.php";
 $userid = filterRequest('usersid');

 getAllData("ordersview","orders_userid = '$userid' AND orders_status !=4");


 


