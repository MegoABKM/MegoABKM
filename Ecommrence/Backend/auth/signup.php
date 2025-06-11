<?php
include "../connect.php";



$username = filterRequest(("username"));

$password = sha1($_POST["password"]);
$email = filterRequest(("email"));
$phone = filterRequest(("phone"));
$verifycode  = rand(10000,99999);





$stmt = $con->prepare("SELECT * FROM users WHERE users_email = ? OR users_phone =?");

$stmt->execute(array($email , $phone));
$count = $stmt->rowCount();

if($count >0){

    printfailure("PHONE OR EMAIL EXISTS");



}
else{

   
    $data = array(
        "users_name"=> "$username",
        "users_email"=> "$email",
        "users_password"=> "$password",
        "users_phone"=> "$phone",
        "users_verifycode"=> $verifycode,
     
    );

    insertData("users", $data );
    //sendEmail($email,"Verifiy Code Ecommerce App",  "Verify Code $verifycode");
}