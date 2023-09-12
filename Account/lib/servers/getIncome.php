<?php 
  header("Access-Control-Allow-Origin: *"); 
  include("conn.php");
  include("functions.php");
  $return["error"] = false;
  $return["message"] = "";
  $return["success"] = false;
  $return["data"]=[];
  $return['type_data']=[];
  $user_id=$_GET["user_id"];
  $flag=$_GET["flag"];
  $date=$_GET["date"];
  if($date){    
    if($return["error"] == false){
      $user_id = mysqli_real_escape_string($conn, $user_id);
      $date = mysqli_real_escape_string($conn, $date);
      if($flag=="true"){
        $check_sql = "SELECT SUM(income_amount) AS income_amount, DATE_FORMAT(income_date,'%m') as date FROM income 
        WHERE DATE_FORMAT(income_date,'%Y') = DATE_FORMAT('$date','%Y') and user_id='$user_id' GROUP BY DATE_FORMAT(income_date,'%m') ";
        $type_sql="SELECT income_type,SUM(income_amount) AS amount FROM income
        WHERE DATE_FORMAT(income_date,'%Y') = DATE_FORMAT('$date','%Y') and user_id='$user_id'GROUP BY income_type";
      }else{
        $check_sql = "SELECT SUM(income_amount) AS income_amount, DATE_FORMAT(income_date,'%d') as date FROM income 
        WHERE DATE_FORMAT(income_date,'%Y-%m') = DATE_FORMAT('$date','%Y-%m') and user_id='$user_id' GROUP BY DATE_FORMAT(income_date,'%d') ";

        $type_sql="SELECT income_type,SUM(income_amount) AS amount FROM income
        WHERE DATE_FORMAT(income_date,'%Y-%m') = DATE_FORMAT('$date','%Y-%m') and user_id='$user_id' GROUP BY income_type";
      }
      
      $check_res = mysqli_query($conn, $check_sql);
      $index=0;
      $return["user_id"]=$user_id;
      while($pass = mysqli_fetch_array($check_res)){    
        $return["data"][$index]["income_amount"]=$pass["income_amount"];
        $return["data"][$index]["date"]=$pass["date"];
        $index++;
      }   
      $type_res = mysqli_query($conn, $type_sql);
      $i=0;
      while($row = mysqli_fetch_array($type_res)) {
        $return["type_data"][$i]["type"]=$row["income_type"];
        $return["type_data"][$i]["amount"]=$row["amount"];
        $i++;
      }
    }
  }else{    
      $return["error"] = true;
      $return["message"] = "查询失败";
  }

  mysqli_close($conn);

  header('Content-Type: application/json;charset=utf-8');
  getApiResult($return);
?>