// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/pages/personal.dart';
import 'package:test/constant.dart';
import 'package:test/pages/login/login.dart';

class Setting extends StatefulWidget {
  final String user_id;
  const Setting({Key? key, required this.user_id}) : super(key: key);

  @override
  State<Setting> createState() => _settingState();
}

// bool flag1 = true;
bool flag2 = false;
bool flag3 = false;
bool flag4 = false;

class _settingState extends State<Setting> {
  String userId = '';

  @override
  void initState() {
    super.initState();
    userId = widget.user_id; // 将user_id赋值给userIdString
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 247, 248, 1),
      appBar: AppBar(
        elevation: 0, //去除阴影
        title: Text('设置'),
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
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.account_circle),
                      SizedBox(width: 12),
                      Text(
                        '关怀模式',
                        style: TextStyle(
                          fontSize: mySize10(17),
                        ),
                      ),
                    ],
                  ),
                  Switch(
                    onChanged: (bool value) {
                      setState(() {
                        flag1 = value;
                        test();
                      });
                    },
                    //当前开关的状态
                    value: flag1,
                    activeColor: Color.fromRGBO(255, 124, 100, 1),
                    activeTrackColor: Color.fromRGBO(255, 124, 100, 0.3),
                    // //选中时小圆滑块的颜色
                    // activeColor: Colors.blue,
                    // //选中时底部的颜色
                    // activeTrackColor: Colors.yellow,
                    // //未选中时小圆滑块的颜色
                    // inactiveThumbColor: Colors.deepPurple,
                    // //未选中时底部的颜色
                    // inactiveTrackColor: Colors.redAccent,
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.circle_notifications),
                      SizedBox(width: 12),
                      Text(
                        '每日记账提醒',
                        style: TextStyle(fontSize: mySize10(17)),
                      ),
                    ],
                  ),
                  Switch(
                    onChanged: (bool value) {
                      setState(() {
                        flag2 = value;
                      });
                    },
                    //当前开关的状态
                    value: flag2,
                    activeColor: Color.fromRGBO(255, 124, 100, 1),
                    activeTrackColor: Color.fromRGBO(255, 124, 100, 0.3),
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
                  Row(
                    children: [
                      Icon(Icons.error),
                      SizedBox(width: 12),
                      Text(
                        '预算超额提醒',
                        style: TextStyle(fontSize: mySize10(17)),
                      ),
                    ],
                  ),
                  Switch(
                    onChanged: (bool value) {
                      setState(() {
                        flag3 = value;
                      });
                    },
                    //当前开关的状态
                    value: flag3,
                    activeColor: Color.fromRGBO(255, 124, 100, 1),
                    activeTrackColor: Color.fromRGBO(255, 124, 100, 0.3),
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
                  Row(
                    children: [
                      Icon(Icons.face_retouching_off),
                      SizedBox(width: 12),
                      Text(
                        '会员到期提醒',
                        style: TextStyle(fontSize: mySize10(17)),
                      ),
                    ],
                  ),
                  Switch(
                    onChanged: (bool value) {
                      setState(() {
                        flag4 = value;
                      });
                    },
                    //当前开关的状态
                    value: flag4,
                    activeColor: Color.fromRGBO(255, 124, 100, 1),
                    activeTrackColor: Color.fromRGBO(255, 124, 100, 0.3),
                  )
                ],
              ),
            ),
            //添加按键效果
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '退出登录',
                      style: TextStyle(fontSize: mySize10(17)),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '注销',
                      style: TextStyle(fontSize: mySize10(17)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
