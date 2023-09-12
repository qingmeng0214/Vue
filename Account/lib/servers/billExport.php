<?php
header("Access-Control-Allow-Origin: *");

//连接数据库
include("conn.php");
include("functions.php");

// $user_id=1;
// $begin_date='2023-04-01';
// $end_date='2023-04-30';

$user_id=$_GET["user_id"];
$user_id=intval($user_id);
$begin_date =$_GET["begin"];
$end_date =$_GET["end"];

$return["message"] = "失败";
$return["success"] = 'false';
$return["data"]=[];

//查询expense表中每天的支出类型和支出金额
$stmt = mysqli_prepare($conn, "SELECT DATE_FORMAT(expense_date,'%Y-%m-%d') as expense_date, expense_type, expense_amount FROM expense WHERE user_id = ? AND expense_date >= ? AND expense_date <= ?");
mysqli_stmt_bind_param($stmt, "iss", $user_id, $begin_date, $end_date);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

$expense_array = array();
while ($row = mysqli_fetch_assoc($result)) {
    $expense_array[$row['expense_date']]['expense_type'] = $row['expense_type'];
    $expense_array[$row['expense_date']]['expense_amount'] = $row['expense_amount'];
}

mysqli_stmt_close($stmt);

//查询income表中每天的收入类型和收入金额
$stmt = mysqli_prepare($conn, "SELECT DATE_FORMAT(income_date,'%Y-%m-%d') as income_date, income_type, income_amount FROM income WHERE user_id = ? AND income_date >= ? AND income_date <= ?");
mysqli_stmt_bind_param($stmt, "iss", $user_id, $begin_date, $end_date);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

$income_array = array();
while ($row = mysqli_fetch_assoc($result)) {
    $income_array[$row['income_date']]['income_type'] = $row['income_type'];
    $income_array[$row['income_date']]['income_amount'] = $row['income_amount'];
}

mysqli_stmt_close($stmt);
mysqli_close($conn);

//组合数据到返回数组
foreach ($expense_array as $date => $expense_data) {
    $income_data = isset($income_array[$date]) ? $income_array[$date] : array('income_type' => '', 'income_amount' => '');
    $return["data"][] = array(
        "date" => $date,
        "expense_type" => $expense_data['expense_type'],
        "expense_amount" => $expense_data['expense_amount'],
        "income_type" => $income_data['income_type'],
        "income_amount" => $income_data['income_amount']
    );
}

$return["message"] = "成功";
$return["success"] ="true";

header('Content-Type: application/json;charset=utf-8');
//结果返回
getApiResult($return);
?>
