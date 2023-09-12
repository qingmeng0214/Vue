import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test/constant.dart';

import 'changePhone.dart';
import 'editNickname.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class MyPage extends StatefulWidget {
  final String user_id;
  final String user_name;
  final String user_sex;

  const MyPage({
    Key? key,
    required this.user_id,
    required this.user_name,
    required this.user_sex,
  }) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String sex = '男';
  // String sex = '';
  Timer? timer;

  File? _image;
  // 2. 定义一个 Timer

  Future _updateData(String userSex) async {
    var url =
        "http://$IP/test/lib/servers/editProfile.php?&user_id=${widget.user_id}&user_sex=$userSex"; //连接php并传入值

    var response = await http.post(Uri.parse(url)); //解析响应php

    print(response.body);
    // var message = jsonDecode(response.body);
    // print(message);

    if (response.statusCode == 200) {
      setState(() {
        // var responseBody = json.decode(response.body); //获取php传过来得json文件
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    // await Future.delayed(Duration(seconds: 5));
  }

  String userId = '';
  String userName = '';
  String userSex = '';
  @override
  void initState() {
    super.initState();
    userId = widget.user_id; // 将user_id赋值给userIdString
    userName = widget.user_name;
    userSex = widget.user_sex;

    // timer = Timer.periodic(
    //     Duration(seconds: 3), (Timer t) => _getData()); // 3. 每隔 5 秒钟获取一次数据
  }

  @override
  void dispose() {
    // 4. 在销毁组件时取消定时器
    timer?.cancel();
    super.dispose();
  }

  void _modelBottomSheet1() async {
    var result = await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  '拍照',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _getImageFromCamera();
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  '从相册中选择',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.pop(context, '图片');
                  _getImageFromGallery();
                },
              ),
              Container(
                height: 5,
                color: Color(0xFFf2f2f2),
              ),
              ListTile(
                title: Text('取消', textAlign: TextAlign.center),
                onTap: () {
                  Navigator.pop(context, '取消');
                },
              ),
            ],
          ),
        );
      },
    );
    print(result);
  }

  void _modelBottomSheet2() async {
    var result = await showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: 234,
          child: Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  '男',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  setState(() {
                    userSex = '男';
                  });
                  _updateData(userSex);
                  Navigator.pop(context, '男');
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  '女',
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  setState(() {
                    userSex = '女';
                  });
                  _updateData(userSex);
                  Navigator.pop(context, '女');
                },
              ),
              Container(
                height: 10,
                color: Color(0xFFf2f2f2),
              ),
              SizedBox(
                // width: 30,
                // height: 15,
                child: ListTile(
                  title: Text('取消', textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context, '取消');
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
    print(result);
  }

  Future<void> _getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() async {
        _image = File(pickedFile.path);
        // final directory = await getApplicationDocumentsDirectory();
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() async {
        _image = File(pickedFile.path);
        final directory = await getApplicationDocumentsDirectory();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 247, 248, 1),
      appBar: AppBar(
        elevation: 0, //去除阴影
        title: Text('编辑资料'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color.fromRGBO(255, 153, 102, 1),
                  Color.fromRGBO(255, 94, 98, 1)
                ]),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '头像',
                    style: TextStyle(fontSize: mySize10(17)),
                  ),
                  Row(
                    children: [
                      MaterialButton(
                        onPressed: _modelBottomSheet1,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 27,
                              backgroundImage: AssetImage('images/1.jpg'),
                              backgroundColor: Colors.grey,
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: mySize10(30),
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '昵称',
                    style: TextStyle(fontSize: mySize10(17)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Row(
                      children: [
                        Text(
                          userName,
                          style: TextStyle(fontSize: mySize10(17)),
                        ),
                        GestureDetector(
                          onTap: () async {
                            String message = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => editNickname(
                                          userId: userId,
                                          userName: userName,
                                        )));
                            setState(() {
                              userName = message;
                              print(message);
                              String _toast = "";

                              _toast = "修改完成";
                              Fluttertoast.showToast(
                                  msg: _toast,
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor:
                                      Color.fromARGB(255, 87, 86, 86),
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            });
                          },
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            size: mySize10(30),
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '性别',
                    style: TextStyle(fontSize: mySize10(17)),
                  ),
                  Row(
                    children: [
                      MaterialButton(
                        onPressed: _modelBottomSheet2,
                        child: Row(
                          children: [
                            Text(
                              userSex,
                              style: TextStyle(fontSize: mySize10(17)),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: mySize10(30),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '手机号',
                    style: TextStyle(fontSize: mySize10(17)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangePhone(
                                        user_id: userId,
                                      )),
                            );
                          },
                          child: Row(
                            children: [
                              Text(
                                '更改',
                                style: TextStyle(fontSize: mySize10(17)),
                              ),
                              Icon(
                                Icons.keyboard_arrow_right,
                                size: mySize10(30),
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
