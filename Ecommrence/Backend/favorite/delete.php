<?php 


include "../connect.php";




$favoriteid = filterRequest("id");
deleteData("favorite", "favorite_id = $favoriteid");