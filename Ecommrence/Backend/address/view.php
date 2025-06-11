<?php 


include "../connect.php";


$addressuserid = filterRequest("address_userid");



$count = getAllData("address","address_userid = $addressuserid");