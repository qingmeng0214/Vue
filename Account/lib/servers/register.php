<?php 
  session_start();
  header("Access-Control-Allow-Origin: *"); 
  include("conn.php");
  include("functions.php");
  $return["error"] = false;
  $return["message"] = "";
  $return["success"] = false;
  

  $name = $_GET["name"];
  $phone =$_GET["phone"];
  $password=$_GET["password"];

  // $link = mysqli_connect($dbhost, $dbuser, $dbpassword, $db);
  if($phone&& $password){
  //checking if there is POST data
    if($return["error"] == false){
      $name = mysqli_real_escape_string($conn, $name);
      $password = mysqli_real_escape_string($conn, $password);
      $phone = mysqli_real_escape_string($conn, $phone);

      $check_sql = "SELECT * FROM user WHERE user_phone='$phone'";
      $check_res = mysqli_query($conn, $check_sql);
      $pass = mysqli_fetch_row($check_res);
      if($pass){
        $return["error"] = true;
        $return["message"] = "该手机号已注册，请登录或使用新手机号注册";
      }else{
        $sql = "INSERT INTO user SET
        user_name = '$name',
        user_pwd ='$password',
        user_phone = '$phone'";
  
        $res = mysqli_query($conn, $sql);
        if($res){
          $return["success"] = true;
          $return["name"] = $name;
          $return["pwd"] = $password;
          $return["phone"] = $phone;
          $return["message"] = "注册成功，即将登录";

          $id_sql = "SELECT user_id FROM user WHERE user_phone='$phone'";
          $id_res = mysqli_query($conn, $id_sql);
          $row = mysqli_fetch_array($id_res);
          $_SESSION["user_id"]=$row['user_id'];
          $return["user_id"] =$row['user_id'];
          //write success
        }else{
          $return["error"] = true;
          $return["message"] = "注册不成功";
        }
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