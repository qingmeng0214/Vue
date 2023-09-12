import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/proxy_box.dart';

class findPassword extends StatefulWidget {
  const findPassword({Key? key}) : super(key: key);

  @override
  State<findPassword> createState() => _findPasswordState();
}

class _findPasswordState extends State<findPassword> {
  List<Color> _colorList = [
    Color.fromRGBO(255, 153, 102, 1),
    Color.fromRGBO(255, 94, 98, 1)
  ];
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _phoneNumber;
  late String _verficationCode;

  //判断登录信息
  void _handleSendVerificationCode() {
    if (_formKey.currentState!.validate()) {
    } else {
      print('发送验证码至$_phoneNumber');
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
    } else {
      print('为$_phoneNumber重设密码');
    }
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
            //裁剪成自定义图形

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
                      onChanged: (value) {
                        _phoneNumber = value;
                      },
                    ),
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
                            validator: (String? value) {
                              return (value == null) ? '请输入验证码' : null;
                            },
                            onChanged: (value) {
                              _verficationCode = value;
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

                        // ElevatedButton(
                        //   onPressed: _handleSendVerificationCode,
                        //   style: ElevatedButton.styleFrom(
                        //     // fixedSize: Size(20, 20),
                        //     shape: RoundedRectangleBorder(
                        //       borderRadius: BorderRadius.circular(10),
                        //     ),
                        //     primary: const Color.fromRGBO(255, 153, 102, 1),
                        //     // backgroundColor: const Color.fromRGBO(255, 153, 102, 1),
                        //     elevation: 5,
                        //     shadowColor: const Color.fromRGBO(255, 153, 102, 1)
                        //         .withOpacity(0.5),
                        //   ),
                        //   child: const Text('发送验证码'),
                        //
                        // ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                        icon: Icon(Icons.lock),
                        labelText: '密码*',
                        hintText: '请输入密码',
                      ),
                      obscureText: true,
                      validator: (String? value) {
                        return (value == null) ? '请确认输入的密码' : null;
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
                              onPressed: _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(3000, 70),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                primary: Color.fromRGBO(255, 124, 100, 1),
                                // backgroundColor: Color.fromRGBO(255, 153, 102, 1),
                                elevation: 5,
                                shadowColor: Color.fromRGBO(255, 153, 102, 1)
                                    .withOpacity(0.5),
                              ),
                              child: const Text(
                                '确   定',
                                style: TextStyle(fontSize: 20),
                              ),
                            ))
                      ],
                    ),
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

      child: Stack(
        children: [
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              color: Colors.white,
              iconSize: 30,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 115, horizontal: 25),
            child: Text(
              '不要灰心，\n找回密码仅需几步!',
              style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
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
