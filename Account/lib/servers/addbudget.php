<?php

header("Access-Control-Allow-Origin: *");

//连接数据库
include("conn.php");
include("functions.php");
//$user_id=2;
//$date='2023-04';
//$amount="1000";
//$remark="吃零食啦";
//$type="零食";

$user_id=$_GET["user_id"];
$user_id=intval($user_id);
$date=$_GET["date"];
$amount=$_GET["amount"];
$remark=$_GET["remark"];
$type=$_GET["type"];

  $return["message"] = "失败";
  $return["success"] = 'false';
   $return["budget_type"]=$type;
  $return["budget_amount"]=$amount;
  $return["budget_date"]=$date;
  $return["budget_remark"]=$remark;




//操作数据库
$sql="INSERT INTO `budget` (`budget_id`,`user_id`, `budget_type`, `budget_amount`, `budget_date`, `budget_remark`) VALUES (NULL,?,?,?,?,?)";
$rs=mysqli_prepare($conn,$sql);
mysqli_stmt_bind_param($rs,"issss", $user_id,$type,$amount,$date,$remark);
mysqli_stmt_execute($rs);
if(mysqli_stmt_affected_rows($rs)>0){
   $return["message"] = "成功";
   $return["success"] = 'true';
}
mysqli_stmt_close($rs);
mysqli_close($conn);

header('Content-Type: application/json;charset=utf-8');
//结果返回
getApiResult($return);
?>