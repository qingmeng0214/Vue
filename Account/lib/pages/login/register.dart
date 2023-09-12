import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/proxy_box.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:test/widgets/bottomNavigationBar.dart';
import 'package:test/constant.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  List<Color> _colorList = [
    Color.fromRGBO(255, 153, 102, 1),
    Color.fromRGBO(255, 94, 98, 1)
  ];
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // late bool isRegised = false;
  bool isRegised = false;
  //判断登录信息
  Future _handleRegister() async {
    String name = getRandomName(5);
    String phone = _phoneController.text;
    String password = _passwordController.text;
    print('昵称：$name, 手机号:$phone, 密码:$password');

    var url = "http://$IP/test/lib/servers/register.php?name=" +
        name +
        "&phone=" +
        phone +
        "&password=" +
        password;

    var response = await http.post(Uri.parse(url));
    print(response.body);
    // Getting Server response into variable.
    // var message = json.decode(response.body);
    // print(message);
    //判断数据库中是否已经存在
    if (response.statusCode == 200) {
      var message = json.decode(response.body);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Bottom(
                  user_id: message["user_id"],
                )),
      );
    } else {
      isRegised = false;
    }
  }

  String getRandomName(int len) {
    final _random = Random();
    final result = String.fromCharCodes(
        List.generate(len, (index) => _random.nextInt(33) + 89));
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),

      //填充布局
      body: Container(
        //填充
        width: double.infinity,
        height: double.infinity,
        //层叠 布局
        child: Stack(
          children: [
            //裁剪成自定义图形
            Material(
              elevation: 5,
              shape: CustomShapeBorder(phoneWidthRadio: 1),
              child: ClipPath(
                //定义裁剪路径
                clipper: CustomHeaderClipPath(),
                //代码封装
                child: buildContainer(context),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                key: _formKey,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 150.0),
                    child: TextFormField(
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
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        icon: Icon(Icons.lock),
                        labelText: '密码*',
                        hintText: '请输入密码',
                      ),
                      obscureText: true,
                      validator: (String? value) {
                        return (value == null) ? '请输入密码' : null;
                      },
                    ),
                  ),

                  //确认按钮
                  Container(
                    padding: EdgeInsets.only(top: 80),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              onPressed: () {
                                // if (_formKey.currentState!.validate()) {
                                //   _formKey.currentState!.save();
                                //注册
                                _handleRegister();
                                // if (isRegised) {

                                // }
                                // }
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(3000, 70),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                primary: Color.fromRGBO(255, 124, 100, 1),
                                // backgroundColor:
                                //     Color.fromRGBO(255, 153, 102, 1),
                                elevation: 5,
                                shadowColor: Color.fromRGBO(255, 153, 102, 1)
                                    .withOpacity(0.5),
                              ),
                              child: const Text(
                                '注   册',
                                style: TextStyle(fontSize: 20),
                              ),
                            ))
                      ],
                    ),
                  ),

                  //跳转登录界面
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text.rich(TextSpan(
                        text: '已有账户？去',
                        style: const TextStyle(
                          color: Color.fromRGBO(127, 127, 127, 1),
                          fontSize: 13,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '登录',
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
                                Navigator.pushNamed(context, '/login');
                              },
                          ),
                          const TextSpan(text: '！'),
                        ])),
                  )
                ],
              ),
            ),
            //输入
          ],
        ),
      ),
    );
  }

  Container buildContainer(BuildContext context) {
    return Container(
      //MediaQuery.of(context).size.height)当前视图高度
      height: MediaQuery.of(context).size.height * 0.4,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: _colorList,
            //修改方向 开始方向 结束方向
            begin: Alignment.centerLeft,
            end: Alignment.centerRight),
      ),

      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 115, horizontal: 25),
        child: Text(
          '注册一下，\n即刻开启记账之旅!',
          style: TextStyle(
              fontSize: 28, color: Colors.white, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}

class CustomHeaderClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();
    path.lineTo(0.0, size.height - 20);

    var firstControlPoint = Offset(size.width / 15, size.height - 100);
    var firstEndPoint = Offset(size.width / 3, size.height - 100);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width / 3, size.height - 100);
    path.lineTo(size.width * 10 / 11, size.height - 100);

    var secondControlPoint =
        Offset(size.width - (size.width / 30), size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 120);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height - 40);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomShapeBorder extends ShapeBorder {
  final double phoneWidthRadio;

  CustomShapeBorder({required this.phoneWidthRadio});

  @override
  // TODO: implement dimensions
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getInnerPath
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    // TODO: implement getOuterPath
    var path = new Path();
    path.lineTo(0.0, rect.height - 20);

    var firstControlPoint = Offset(rect.width / 15, rect.height - 100);
    var firstEndPoint = Offset(rect.width / 3, rect.height - 100);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(rect.width / 3, rect.height - 100);
    path.lineTo(rect.width * 10 / 11, rect.height - 100);

    var secondControlPoint =
        Offset(rect.width - (rect.width / 30), rect.height - 100);
    var secondEndPoint = Offset(rect.width, rect.height - 120);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(rect.width, rect.height - 40);
    path.lineTo(rect.width, 0.0);
    path.close();

    return path;
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    // TODO: implement paint
  }

  @override
  ShapeBorder scale(double t) {
    // TODO: implement scale
    return CustomShapeBorder(phoneWidthRadio: phoneWidthRadio);
  }
}
