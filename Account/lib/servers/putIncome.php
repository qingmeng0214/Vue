<?php 
  header("Access-Control-Allow-Origin: *"); 
  include("conn.php");
  include("functions.php");
  $return["error"] = false;
  $return["message"] = "";
  $return["success"] = false;
  $return["data"]=[];
  $user_id=$_GET["user_id"];
  $income_type=$_GET["income_type"];
  $income_amount=$_GET["income_amount"];
  $income_remark=$_GET["income_remark"];
  $income_date=$_GET["date"];
  $income_emoji=$_GET["emoji"];

  if($income_date){    
    if($return["error"] == false){
        $user_id = mysqli_real_escape_string($conn, $user_id);
        $income_type = mysqli_real_escape_string($conn, $income_type);
        $income_amount = mysqli_real_escape_string($conn, $income_amount);
        $income_remark = mysqli_real_escape_string($conn, $income_remark);
        $income_date = mysqli_real_escape_string($conn, $income_date);
        $income_emoji = mysqli_real_escape_string($conn, $income_emoji);
      $sql = "INSERT INTO income SET 
      income_type='$income_type', 
      income_amount='$income_amount', 
      income_remark='$income_remark', 
      user_id='$user_id',
      income_date='$income_date',
      income_emoji='$income_emoji'";

      $res = mysqli_query($conn, $sql);
      if($res){
        $return["message"]="记账成功";
        $return["error"]=false;
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