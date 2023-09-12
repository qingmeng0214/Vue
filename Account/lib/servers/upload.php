<?php
// upload.php

// 连接数据库
include("conn.php");


// 处理上传的图片文件
if ($_FILES["image"]["error"] == UPLOAD_ERR_OK) {
  $tmp_name = $_FILES["image"]["tmp_name"];
  $name = basename($_FILES["image"]["name"]);
  move_uploaded_file($tmp_name, "uploads/" . $name);

  // 将图片文件路径存入数据库
  $sql = "INSERT INTO user user_photo VALUES ('uploads/$name')";
  if ($conn->query($sql) === TRUE) {
    echo "Image uploaded and stored in database successfully";
  } else {  
    echo "Error: " . $sql . "<br>" . $conn->error;
  }
} else {
  echo "Failed to upload image";
}

$conn->close();
?>