import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/pages/mine/paymentSuccessful.dart';
import 'package:test/pages/personal.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:test/constant.dart';
import 'package:http/http.dart' as http;

class Vip extends StatefulWidget {
  final String user_id;
  final String user_name;
  const Vip({Key? key, required this.user_id, required this.user_name})
      : super(key: key);

  @override
  State<Vip> createState() => _VipState();
}

class _VipState extends State<Vip> {
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
        // var responseBody = json.decode(response.body); //获取php传过来得json文件
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
  String userName = '';

  @override
  void initState() {
    super.initState();
    userId = widget.user_id; // 将user_id赋值给userIdString
    userName = widget.user_name;
    _getData();
  }

  String _vipType = '';
  String _paymentType = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 247, 248, 1),
      appBar: AppBar(
        elevation: 0, //去除阴影
        title: Text('开通VIP'),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(40.0),
            child: Row(children: [
              SizedBox(
                  width: 80,
                  height: 80,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('images/1.jpg'),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  userName,
                  style: TextStyle(
                      fontSize: mySize10(24),
                      color: Color.fromRGBO(102, 102, 102, 1)),
                ),
              ),
            ]),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildVIPTypeButton('月度vip', '￥ 18/月', 'monthly'),
                _buildVIPTypeButton('年度vip', '￥ 68/年', 'annual'),
                _buildVIPTypeButton('终身vip', '￥ 78/永久', 'lifetime'),
              ],
            ),
          ),
          Divider(),
          Container(
            child: Column(
              children: [
                RadioListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4, right: 20),
                          child: Image(
                            image: AssetImage('images/alipay.png'),
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Text('支付宝'),
                      ],
                    ),
                  ),
                  value: '支付宝',
                  groupValue: _paymentType,
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: Color.fromRGBO(255, 124, 100, 1),
                  onChanged: (value) {
                    setState(() {
                      _paymentType = '支付宝';
                    });
                  },
                ),
                RadioListTile(
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 4, right: 20),
                          child: Image(
                            image: AssetImage('images/wechat.png'),
                            width: 20,
                            height: 20,
                          ),
                        ),
                        Text('微信支付'),
                      ],
                    ),
                  ),
                  value: '微信支付',
                  groupValue: _paymentType,
                  controlAffinity: ListTileControlAffinity.trailing,
                  activeColor: Color.fromRGBO(255, 124, 100, 1),
                  onChanged: (value) {
                    setState(() {
                      _paymentType = '微信支付';
                    });
                  },
                ),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(3000, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                primary: Color.fromRGBO(255, 124, 100, 1),
                elevation: 5,
                shadowColor: Color.fromRGBO(255, 124, 100, 1).withOpacity(0.5),
              ),
              child: Text(
                '立即开通',
                style: TextStyle(fontSize: mySize10(20)),
              ),
              onPressed: () {
                if (_vipType != '' && _paymentType != '') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => paymentSuccessful(
                              user_id: userId,
                            )),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVIPTypeButton(String label, String money, String type) {
    return OutlinedButton(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: mySize10(15),
                color: Color.fromRGBO(102, 102, 102, 1)),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              money,
              style: TextStyle(
                  fontSize: mySize10(12),
                  color: Color.fromRGBO(255, 94, 98, 1)),
            ),
          ),
        ],
      ),
      onPressed: () => setState(() {
        _vipType = type;
      }),
      style: OutlinedButton.styleFrom(
        fixedSize: Size(110, 120),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        side: BorderSide(
          color: _vipType == type
              ? Color.fromRGBO(254, 94, 98, 1)
              : Colors.black12,
          width: 1,
        ),
        backgroundColor:
            _vipType == type ? Color.fromRGBO(249, 225, 227, 1) : Colors.white,
      ),
    );
  }
}
