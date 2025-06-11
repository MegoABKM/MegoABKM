<?php 


include "../connect.php";


$addressid = filterRequest("addressid");



$count = deleteData("address","address_id = $addressid");