<?php 

$user = 'root';
$pwd = '123456';
$db = 'myapp_db';
$host = 'localhost';
$port = '22';

$conn = mysqli_init();
$success = mysqli_real_connect(
   $conn, 
   $host, 
   $user, 
   $pwd, 
   $db,
   $port
);
if($success!=1){
	die("数据库连接失败");
}
mysqli_query($conn,"set names utf8mb4");
 ?>
