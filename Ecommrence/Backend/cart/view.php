  <?php
 include "../connect.php";


  $userid = filterRequest("usersid");


$data =  getAllData("cartview","cart_userid = $userid",null,false);

$stmt = $con->prepare("SELECT SUM(itemsprice) as totalprice,SUM(countitems) as totalcount  FROM `cartview` WHERE cartview.cart_userid = $userid GROUP BY cart_userid");

$stmt->execute();
 
$datacountprice = $stmt->fetch(PDO::FETCH_ASSOC);

echo json_encode(array("status"=>"success", "datacart"=> $data, "countprice" =>$datacountprice));


