<?php
//سبب عمل هذه الصفحة هو ان الهوم سوف يقوم بعمل اكثر من ريكوست لجلب الداتا منها الافسام ز البضاعة
//  الحل هو عمل صفحة هوم وتفريق اسم الداتا التي ترجع بالجيسون الى اقسام و بضاعة واخرى
include "connect.php";
$alldata = array();
$alldata['status']="success";
$categories= getAllData("categories",null,null,false);
$alldata['categories'] = $categories;
$items= getAllData("itemsview1","items_discount!= 0",null,false);
$alldata['items'] = $items;

  echo json_encode($alldata);