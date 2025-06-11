<?php
// CORS headers
header("Access-Control-Allow-Origin: *"); // Allow all origins
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, Access-Control-Allow-Origin");
header("Access-Control-Allow-Methods: POST, OPTIONS, GET"); // Allow POST, OPTIONS, and GET methods

// Database connection
$dsn = "mysql:host=localhost;dbname=e-commerce";
$user = "root";
$pass = "";
$option = array(
   PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES UTF8"
);

$countrowinpage = 9;

try {
   $con = new PDO($dsn, $user, $pass, $option);
   $con->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

   // You can also put other code here, like including functions or authentication checks.
   include "functions.php";

   if (!isset($notAuth)) {
      // checkAuthenticate();
   }

} catch (PDOException $e) {
   echo $e->getMessage();
}
?>
