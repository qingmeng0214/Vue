<?php

header("Access-Control-Allow-Origin: *");

//连接数据库
include("conn.php");
include("functions.php");
//$user_id=1;
//$user_name=ljkhjb;
$user_id=$_GET["user_id"];
$user_id=intval($user_id);
$user_name=$_GET["user_name"];

  $return["message"] = "失败";
  $return["success"] = 'false';
  $return["user_id"]=$user_id;




//操作数据库
$sql="UPDATE `user` SET `user_name`= ? WHERE `user_id` =?";
$stmt=mysqli_prepare($conn,$sql);
mysqli_stmt_bind_param($stmt,"si",$user_name,$user_id);
mysqli_stmt_execute($stmt);
mysqli_stmt_store_result($stmt);
if(mysqli_stmt_affected_rows($stmt)>0){
     $return["message"] = "成功";
     $return["success"] = 'true';
}

mysqli_stmt_close($stmt);
mysqli_close($conn);

header('Content-Type: application/json;charset=utf-8');
//结果返回
getApiResult($return);
?>