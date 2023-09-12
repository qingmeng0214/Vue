<?php

header("Access-Control-Allow-Origin: *");


//连接数据库
include("conn.php");
include("functions.php");
//$user_id=1;
// $user_id=2;
$user_id=$_GET["user_id"];
$user_id=intval($user_id);
$budget_date=$_GET["budget_date"];//获取页面传来的年月信息
//$budget_date ='2023-02';
//$date = $_GET["date"];

  $return["message"] = "失败";
  $return["success"] = 'false';
  $return["data"] = [];
  $return["expense"]='0.00';
  $return["income"]='0.00';
  $return["surplus"]='0.00';
  $return["user_id"]=$user_id;
  $return["date"]=$budget_date;
  $return["user_id"]=$user_id;
$i=0;



//查找每一类别的预算支出
$sql="SELECT `budget_type`, `budget_amount` FROM `budget` where `user_id`=? and `budget_date`=?";
$stmt=mysqli_prepare($conn,$sql);
mysqli_stmt_bind_param($stmt,"is",$user_id,$budget_date);
mysqli_stmt_execute($stmt);
mysqli_stmt_bind_result($stmt,$budget_type,$budget_amount);
mysqli_stmt_store_result($stmt);
$return["message"] = "结果为空";
while(mysqli_stmt_fetch($stmt)){
     $return["data"][$i]["budget_type"]=$budget_type;
     $return["data"][$i]["budget_amount"]=$budget_amount;
    $ans=0.00;
    $sql="SELECT `expense_amount` FROM `expense` where `user_id`=? and DATE_FORMAT(expense_date,'%Y-%m')=? and `expense_type`=?";
    $stmt1=mysqli_prepare($conn,$sql);
    mysqli_stmt_bind_param($stmt1,"iss",$user_id,$budget_date,$budget_type);
    mysqli_stmt_execute($stmt1);
    mysqli_stmt_bind_result($stmt1,$expense_amount);
    mysqli_stmt_store_result($stmt1);
    while(mysqli_stmt_fetch($stmt1)){
       $ans += floatval($expense_amount);
    }
    $ans= number_format($ans, 2, '.', '');
    $ans=strval($ans);
    $return["data"][$i]["budget_expense"]=$ans;
    $return["message"] = "成功";
    $return["success"] = 'ture';
    $i++;
}

//以下为头部的月结余、月支出和收入的查找

//查找本月所有支出
$sql="SELECT `expense_amount`FROM `expense`  where `user_id`=? and DATE_FORMAT(expense_date,'%Y-%m') =?";
$stmt=mysqli_prepare($conn,$sql);
mysqli_stmt_bind_param($stmt,"is",$user_id,$budget_date);
mysqli_stmt_execute($stmt);
mysqli_stmt_bind_result($stmt,$expense_amount);
mysqli_stmt_store_result($stmt);
$all_expense=0.00;
while(mysqli_stmt_fetch($stmt)){
     $all_expense+=floatval($expense_amount);
}
    $all_expense= number_format($all_expense, 2, '.', '');

 //查找本月所有收入
$sql="SELECT `income_amount`FROM `income`  where `user_id`=? and DATE_FORMAT(income_date,'%Y-%m') =?";
$stmt=mysqli_prepare($conn,$sql);
mysqli_stmt_bind_param($stmt,"is",$user_id,$budget_date);
mysqli_stmt_execute($stmt);
mysqli_stmt_bind_result($stmt,$income_amount);
mysqli_stmt_store_result($stmt);
$all_income=0.00;
while(mysqli_stmt_fetch($stmt)){
     $all_income+=floatval($income_amount);
}
    $all_income= number_format($all_income, 2, '.', '');

    $surplus=$all_income-$all_expense;//月结余
    $surplus= number_format($surplus, 2, '.', '');
    $surplus=strval($surplus);
    $return["surplus"]=$surplus;

    $all_expense=strval($all_expense);
   $return["expense"]=$all_expense;
    $all_income=strval($all_income);
    $return["income"]=$all_income;


if(!$return["data"]){
     $return["data"][0]["budget_type"]="xxx";
     $return["data"][0]["budget_amount"]="0.00";
     $return["data"][0]["budget_expense"]="0.00";
}
mysqli_stmt_close($stmt);
// mysqli_stmt_close($stmt1);


mysqli_close($conn);

header('Content-Type: application/json;charset=utf-8');
//结果返回
getApiResult($return);
?>