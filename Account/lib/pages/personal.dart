import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/pages/mine/financialTrivia.dart';
import 'package:http/http.dart' as http;
import 'package:test/pages//mine/setting.dart';
// import '../widgets/homeBottom.dart';
import './mine/vip.dart';
import './mine/billExport.dart';
import './mine/editProfile.dart';
import './mine/exchangeRateconversion.dart';
import './mine/message.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';
import 'package:test/constant.dart';

class Personal extends StatefulWidget {
  final String user_id;
  const Personal({Key? key, required this.user_id}) : super(key: key);
  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  final List<Color> _colorList = [
    const Color.fromRGBO(255, 131, 69, 1),
    const Color.fromRGBO(255, 184, 148, 1)
  ];
  String user_name = '';
  String user_sex = '';
  Timer? timer;
  Future _getData() async {
    var url =
        "http://$IP/test/lib/servers/personal.php?&user_id=${widget.user_id}"; //连接php并传入值

    var response = await http.post(Uri.parse(url)); //解析响应php

    print(response.body);
    // var message = jsonDecode(response.body);
    // print(message);

    if (response.statusCode == 200) {
      setState(() {
        var responseBody = json.decode(response.body); //获取php传过来得json文件
        // income = responseBody["income"];
        user_name = responseBody["user_name"];
        user_sex = responseBody["user_sex"];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    // await Future.delayed(Duration(seconds: 5));
  }

  String userId = '';
  @override
  void initState() {
    super.initState();
    userId = widget.user_id; // 将user_id赋值给userIdString
    _getData();
    timer = Timer.periodic(Duration(seconds: 3), (Timer t) => _getData());
  }

  @override
  void dispose() {
    // 4. 在销毁组件时取消定时器
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: Stack(alignment: Alignment.bottomCenter, children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(25),
                ),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[
                    Color.fromRGBO(255, 153, 102, 1),
                    Color.fromRGBO(255, 94, 98, 1)
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15, left: 0),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyPage(
                                              user_id: userId,
                                              user_name: user_name,
                                              user_sex: user_sex,
                                            )),
                                  );
                                },
                                child: const SizedBox(
                                    width: 80,
                                    height: 80,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage('images/1.jpg'),
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 15),
                                child: Text(
                                  user_name,
                                  style: TextStyle(
                                      fontSize: mySize10(24),
                                      color: Colors.white),
                                ),
                              ),
                              //设置
                              Padding(
                                padding: EdgeInsets.only(bottom: 60, left: 130),
                                child: IconButton(
                                  iconSize: mySize10(30),
                                  color: Colors.white,
                                  icon: const Icon(Icons.settings),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Setting(
                                                user_id: userId,
                                              )),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 160,
          child: Center(
            child: Column(
              children: [
                Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width * 0.93,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) {
                                  return LinearGradient(
                                    colors: _colorList,
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ).createShader(bounds);
                                },
                                child: Text(
                                  'VIP',
                                  style: TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w500,
                                    foreground: Paint()
                                      ..shader = LinearGradient(
                                        colors: _colorList,
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      ).createShader(
                                          const Rect.fromLTWH(0, 0, 100, 100)),
                                  ),
                                ),
                              ),
                              // SizedBox(width:2),
                              Column(
                                children: [
                                  Text(
                                    '升级为vip',
                                    style: TextStyle(
                                      fontSize: mySize10(18),
                                      color: Color.fromRGBO(51, 51, 51, 1),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 5),
                                    child: Text(
                                      '畅享更多高级功能',
                                      style: TextStyle(
                                        fontSize: mySize10(12),
                                        color: Color.fromRGBO(153, 153, 153, 1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Vip(
                                        user_id: userId, user_name: user_name)),
                              );
                            },
                            child: Padding(
                              padding: EdgeInsets.only(left: 65, top: 8),
                              child: Icon(
                                Icons.keyboard_arrow_right,
                                size: mySize10(30),
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.93,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.edit,
                                color: Color.fromRGBO(51, 51, 51, 1)),
                            Text(
                              '编辑资料',
                              style: TextStyle(
                                  fontSize: mySize10(17),
                                  color: Color.fromRGBO(102, 102, 102, 1)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 150, top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyPage(
                                              user_id: userId,
                                              user_name: user_name,
                                              user_sex: user_sex,
                                            )),
                                  );
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  size: mySize10(30),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.93,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.notifications_sharp,
                                color: Color.fromRGBO(51, 51, 51, 1)),
                            Text(
                              '消息通知',
                              style: TextStyle(
                                  fontSize: mySize10(17),
                                  color: Color.fromRGBO(102, 102, 102, 1)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 150, top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Message(
                                              user_id: userId,
                                            )),
                                  );
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  size: mySize10(30),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.93,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.description,
                                color: Color.fromRGBO(51, 51, 51, 1)),
                            Text(
                              '账单导出',
                              style: TextStyle(
                                  fontSize: mySize10(17),
                                  color: Color.fromRGBO(102, 102, 102, 1)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 150, top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => billExport(
                                              user_id: userId,
                                            )),
                                  );
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  size: mySize10(30),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.93,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.trending_up_rounded,
                                color: Color.fromRGBO(51, 51, 51, 1)),
                            Text(
                              '理财小知识',
                              style: TextStyle(
                                  fontSize: mySize10(17),
                                  color: Color.fromRGBO(102, 102, 102, 1)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 150, top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => financialTrivia(
                                              user_id: userId,
                                            )),
                                  );
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  size: mySize10(30),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.93,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.swap_horiz_rounded,
                                color: Color.fromRGBO(51, 51, 51, 1)),
                            Text(
                              '汇率换算',
                              style: TextStyle(
                                  fontSize: mySize10(17),
                                  color: Color.fromRGBO(102, 102, 102, 1)),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 150, top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            exchangeRateconversion()),
                                  );
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  size: mySize10(30),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.93,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.backup_rounded,
                                color: Color.fromRGBO(51, 51, 51, 1)),
                            Text(
                              '数据备份与恢复',
                              style: TextStyle(
                                  fontSize: mySize10(17),
                                  color: Color.fromRGBO(102, 102, 102, 1)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 120, top: 8),
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        // title: Text('日期选择错误'),
                                        content: Text(
                                            '创建云备份后，您的账单数据将永不丢失，可在任意设备一键恢复数据。'),
                                        actions: [
                                          TextButton(
                                            child: Text('确定'),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_right,
                                  size: mySize10(30),
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
      // bottomNavigationBar: Bottom(),
    );
  }
}
