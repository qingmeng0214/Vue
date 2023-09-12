<?php 
  header("Access-Control-Allow-Origin: *"); 
  include("conn.php");
  include("functions.php");
  $return["error"] = false;
  $return["message"] = "";
  $return["success"] = false;
  $user_id=$_GET["user_id"];
  $label=$_GET["label"];
  $id=$_GET["id"];

  if($user_id){    
    if($return["error"] == false){
        $user_id = mysqli_real_escape_string($conn, $user_id);
        $id = mysqli_real_escape_string($conn, $id);

        if($label=="expense"){
            $sql="DELETE FROM expense WHERE expense_id='$id' AND user_id='$user_id'";
        }else{
            $sql="DELETE FROM income WHERE income_id='$id' AND user_id='$user_id'";
        }
        
        $res = mysqli_query($conn, $sql);
        if($res){
            $return["error"]=false;
            $return["success"]=true;
            $return["message"]="删除成功";
        }       
    }
  }else{    
      $return["error"] = true;
      $return["message"] = "删除失败";
  }

  mysqli_close($conn);

  header('Content-Type: application/json;charset=utf-8');
  getApiResult($return);
?>