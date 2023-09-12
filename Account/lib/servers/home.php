<?php 
  header("Access-Control-Allow-Origin: *"); 
  include("conn.php");
  include("functions.php");
  $return["error"] = false;
  $return["message"] = "";
  $return["success"] = false;
  $return["data"]=[];
  $return["m_expense"]=0;
  $return["m_income"]=0;
  $user_id=$_GET["user_id"];
  $date=$_GET["date"];
  if($date){    
    if($return["error"] == false){
        $user_id = mysqli_real_escape_string($conn, $user_id);
        $date = mysqli_real_escape_string($conn, $date);

        //支出 
        $ex_sql ="SELECT expense_type,expense_amount,expense_emoji,expense_id,expense_remark FROM expense 
        WHERE DATE_FORMAT(expense_date,'%Y-%m-%d')='$date'and user_id='$user_id'";
        $ex_res = mysqli_query($conn, $ex_sql);
        $i=0;
        while($ex_row = mysqli_fetch_array($ex_res)) {
          $return["data"][$i]["type"]=$ex_row["expense_type"];
          $return["data"][$i]["remark"]=$ex_row["expense_remark"];
          $return["data"][$i]["amount"]=$ex_row["expense_amount"];     
          $return["data"][$i]["emoji"]=$ex_row["expense_emoji"];
          $return["data"][$i]["label"]="expense";
          $return["data"][$i]["id"]=$ex_row["expense_id"];
          $i++;
        }
        //收入
        $in_sql ="SELECT income_type,income_amount,income_emoji,income_id,income_remark FROM income
        WHERE DATE_FORMAT(income_date,'%Y-%m-%d')='$date'and user_id='$user_id'";
        $in_res = mysqli_query($conn, $in_sql);
        while($in_row = mysqli_fetch_array($in_res)) {
          $return["data"][$i]["type"]=$in_row["income_type"];
          $return["data"][$i]["remark"]=$in_row["income_remark"];
          $return["data"][$i]["amount"]=$in_row["income_amount"];
          $return["data"][$i]["emoji"]=$in_row["income_emoji"];    
          $return["data"][$i]["label"]="income";
          $return["data"][$i]["id"]=$in_row["income_id"];
          $i++;
        }

        // 月支出
        $mex_sql = "SELECT SUM(expense_amount) AS expense_amount FROM expense 
        WHERE DATE_FORMAT(expense_date,'%Y-%m') = DATE_FORMAT('$date','%Y-%m') and user_id='$user_id' ";
        $mex_res = mysqli_query($conn, $mex_sql);
        $mex_row = mysqli_fetch_array($mex_res);
        if($mex_row [0]==null){
          $return["m_expense"]='0';
        }else{
          $return["m_expense"]=$mex_row[0];
        }

        $min_sql = "SELECT SUM(income_amount) AS income_amount FROM income 
        WHERE DATE_FORMAT(income_date,'%Y-%m') = DATE_FORMAT('$date','%Y-%m') and user_id='$user_id' ";
        $min_res = mysqli_query($conn, $min_sql);
        $min_row = mysqli_fetch_array($min_res);
        if($min_row [0]==null){
          $return["m_income"]='0';
        }else{
          $return["m_income"]=$min_row [0];
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