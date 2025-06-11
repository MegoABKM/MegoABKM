<?php



include "../connect.php";
$categoryid = filterRequest("id");
$userid = filterRequest("userid");
// $items = getAllData('itemsview' , "categories_id = $categoryid");

$stmt = $con->prepare("SELECT itemsview1.*, 1 as favorite ,(items_price - (items_price * items_discount /100)) as itemspricediscount
FROM itemsview1 
INNER JOIN favorite 
  ON favorite.favorite_itemsid = itemsview1.items_id 
  AND favorite.favorite_usersid =$userid   where categories_id = $categoryid

UNION ALL 

SELECT itemsview1.*, 0 as favorite ,(items_price - (items_price * items_discount /100)) as itemspricediscount
FROM itemsview1 
Where categories_id = $categoryid
And items_id NOT IN (
  SELECT itemsview1.items_id 
  FROM itemsview1 
  INNER JOIN favorite 
    ON favorite.favorite_itemsid = itemsview1.items_id 
    AND favorite.favorite_usersid = $userid
)
");



$stmt->execute();
$data = $stmt->fetchAll(PDO::FETCH_ASSOC);
$count = $stmt->rowCount();


if ($count > 0) {
  echo json_encode(
    array("status" => "success", "data" => $data)
  );
} else {
  echo json_encode(array("status" => "failure"));
}
