<?php

include "../connect.php";

$userid = filterRequest("usersid");
getAllData("favoriteview","favorite_usersid = ?", array($userid));