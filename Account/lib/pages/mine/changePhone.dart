import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:test/pages/personal.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/constant.dart';

class ChangePhone extends StatefulWidget {
  final String user_id;
  const ChangePhone({Key? key, required this.user_id}) : super(key: key);

  @override
  State<ChangePhone> createState() => _ChangePhoneState();
}

class _ChangePhoneState extends State<ChangePhone> {
  List<Color> _colorList = [
    Color.fromRGBO(255, 153, 102, 1),
    Color.fromRGBO(255, 94, 98, 1)
  ];
  TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _phoneNumber;

  //判断信息
  void _handleSendVerificationCode() {
    if (_formKey.currentState!.validate()) {
    } else {
      print('发送验证码至$_phoneNumber');
    }
  }

  Future _getData() async {
    // String budget_date = '2023-04';

    var url =
        "http://$IP/test/lib/servers/budget.php?&user_id=${widget.user_id}"; //连接php并传入值

    var response = await http.post(Uri.parse(url)); //解析响应php

    print(response.body);
    // var message = jsonDecode(response.body);
    // print(message);

    if (response.statusCode == 200) {
      setState(() {
        var responseBody = json.decode(response.body); //获取php传过来得json文件
        // data = responseBody["data"]; //获取data列表
        // expense = responseBody["expense"]; //获取头部金额head_data列表
        // income = responseBody["income"];
        // surplus = responseBody["surplus"];
        // print(data);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 247, 248, 1),
      appBar: AppBar(
        elevation: 0, //去除阴影
        title: Text('换绑手机'),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => Personal(user_id: userId,)),
        //     );
        //   },
        // ),
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

      //填充布局
      body: Container(
        //填充
        width: double.infinity,
        height: double.infinity,
        //层叠 布局
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                key: _formKey,
                children: <Widget>[
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      icon: Icon(Icons.person),
                      labelText: '手机号*',
                      hintText: '请输入手机号',
                      // prefixIcon: Icon(Icons.person),
                      border: UnderlineInputBorder(),
                    ),
                    validator: (String? value) {
                      return (value?.length != 11 || value == null)
                          ? '请确认输入的手机号位数'
                          : null;
                    },
                    onChanged: (value) {
                      _phoneNumber = value;
                    },
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 220,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              icon: Icon(Icons.lock),
                              labelText: '验证码*',
                              hintText: '请输入验证码',
                            ),
                            obscureText: true,
                            validator: (String? value) {
                              return (value == null) ? '请输入验证码' : null;
                            },
                          ),
                        ),
                        Text.rich(
                          TextSpan(
                            children: <TextSpan>[
                              TextSpan(
                                text: '发送验证码',
                                style: const TextStyle(
                                  color: Color.fromRGBO(255, 153, 102, 1),
                                  fontSize: 13,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // print(111);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(builder: (context) => const Register()),
                                    // );
                                    // Navigator.pushNamed(context, '/register');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //确认按钮
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: Container(
                      // margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '确   定',
                            style: TextStyle(
                                fontSize: mySize10(20), color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Container(
                  //   padding: EdgeInsets.only(top: 60),
                  //   child: Column(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Align(
                  //           alignment: Alignment.bottomCenter,
                  //           child: ElevatedButton(
                  //             onPressed: _handleSendVerificationCode,
                  //             style: ElevatedButton.styleFrom(
                  //               fixedSize: Size(3000, 70),
                  //               shape: RoundedRectangleBorder(
                  //                 borderRadius: BorderRadius.circular(50),
                  //               ),
                  //               primary: Color.fromRGBO(255, 124, 100, 1),
                  //               elevation: 5,
                  //               shadowColor: Color.fromRGBO(255, 124, 100, 1)
                  //                   .withOpacity(0.5),
                  //             ),
                  //             child: Text(
                  //               '确   定',
                  //               style: TextStyle(fontSize: mySize10(20)),
                  //             ),
                  //           ))
                  //     ],
                  //   ),
                  // )
                ],
              ),
            ),
            //输入
          ],
        ),
      ),
    );
  }
}
