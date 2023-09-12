<?php 
  header("Access-Control-Allow-Origin: *"); 
  include("conn.php");
  include("functions.php");
  $return["error"] = false;
  $return["message"] = "";
  $return["success"] = false;
  $return["data"]=[];
  $user_id=$_GET["user_id"];
  $expense_type=$_GET["expense_type"];
  $expense_amount=$_GET["expense_amount"];
  $expense_remark=$_GET["expense_remark"];
  $expense_date=$_GET["date"];
  $expense_emoji=$_GET["emoji"];

  if($expense_date){    
    if($return["error"] == false){
        $user_id = mysqli_real_escape_string($conn, $user_id);
        $expense_type = mysqli_real_escape_string($conn, $expense_type);
        $expense_amount = mysqli_real_escape_string($conn, $expense_amount);
        $expense_remark = mysqli_real_escape_string($conn, $expense_remark);
        $expense_date = mysqli_real_escape_string($conn, $expense_date);
        $expense_emoji = mysqli_real_escape_string($conn, $expense_emoji);
      $sql = "INSERT INTO expense SET 
      expense_type='$expense_type', 
      expense_amount='$expense_amount', 
      expense_remark='$expense_remark', 
      user_id='$user_id',
      expense_date='$expense_date',
      expense_emoji='$expense_emoji'";

      $res = mysqli_query($conn, $sql);
      if($res){
        $return["message"]="记账成功";
        $return["error"]=false;
        $return["success"]=true;
      }    
    }
  }else{    
      $return["error"] = true;
      $return["message"] = "记账失败";
  }

  mysqli_close($conn);

  header('Content-Type: application/json;charset=utf8mb4');
  // tell browser that its a json data
  getApiResult($return);
  //converting array to JSON string
?>