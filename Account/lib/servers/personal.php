<?php

header("Access-Control-Allow-Origin: *");

//连接数据库
include("conn.php");
include("functions.php");
//$user_id=1;
$user_id=$_GET["user_id"];
$user_id=intval($user_id);

  $return["message"] = "失败";
  $return["success"] = 'false';
  $return["user_name"]='';
  $return["user_sex"]='';
  $return["user_photo"]='';
  $return["user_id"]=$user_id;




//操作数据库
$sql="SELECT `user_name`,`user_sex`,`user_photo` FROM `user` where `user_id`=?";
$stmt=mysqli_prepare($conn,$sql);
mysqli_stmt_bind_param($stmt,"i",$user_id);
mysqli_stmt_execute($stmt);
mysqli_stmt_bind_result($stmt,$user_name,$user_sex,$user_photo);
mysqli_stmt_store_result($stmt);
while(mysqli_stmt_fetch($stmt)){
    $return["user_name"]=$user_name;
    $return["user_sex"]=$user_sex==null?'':$user_sex;
    $return["user_photo"]=$user_photo==null?'':$user_photo;
  $return["message"] = "成功";
  $return["success"] = 'true';
}

mysqli_stmt_close($stmt);
mysqli_close($conn);

header('Content-Type: application/json;charset=utf-8');
//结果返回
getApiResult($return);
?>