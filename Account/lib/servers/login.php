<?php 
  session_start();
  header("Access-Control-Allow-Origin: *"); 
  include("conn.php");
  include("functions.php");
  $return["error"] = false;
  $return["message"] = "";
  $return["success"] = false;

  $phone =$_GET["phone"];
  $password=$_GET["password"];
  if($phone&& $password){
    
    if($return["error"] == false){
      $password = mysqli_real_escape_string($conn, $password);
      $phone = mysqli_real_escape_string($conn, $phone);

      $check_sql = "SELECT * FROM user WHERE user_phone='$phone'and user_pwd='$password'";
      $check_res = mysqli_query($conn, $check_sql);
      $pass = mysqli_fetch_array($check_res);
      // echo($pass['user_id']);
      if($pass){
        $return["error"] = false;
        $return["message"] = "登录成功";
        $return["user_id"] =$pass['user_id'];
      }else{
          $return["error"] = true;
          $return["message"] = "登录失败，请检查手机号和密码";
      }
      
    } 
  }else{    
      $return["error"] = true;
      $return["message"] = "手机号和密码不能为空";
  }

  mysqli_close($conn);

  header('Content-Type: application/json;charset=utf-8');
  // tell browser that its a json data
  getApiResult($return);
  //converting array to JSON string
?>