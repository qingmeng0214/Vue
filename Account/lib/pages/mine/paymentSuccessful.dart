import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/pages/personal.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/constant.dart';

class paymentSuccessful extends StatefulWidget {
  final String user_id;
  const paymentSuccessful({Key? key, required this.user_id}) : super(key: key);

  @override
  State<paymentSuccessful> createState() => _paymentSuccessfulState();
}

class _paymentSuccessfulState extends State<paymentSuccessful> {
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
        title: Text('开通VIP'),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Icon(
                Icons.check,
                size: mySize10(80),
                color: Colors.green,
              ),
              Text(
                '支付成功',
                style: TextStyle(
                  fontSize: mySize10(24),
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
