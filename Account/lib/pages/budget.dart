import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/proxy_box.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:test/pages/budget/add.dart';
import 'package:test/constant.dart';

class Budget extends StatefulWidget {
  final String user_id;
  const Budget({Key? key, required this.user_id}) : super(key: key);

  @override
  State<Budget> createState() => _BudgetState();
}

class _BudgetState extends State<Budget> {
  bool _refreshPage = false;
  DateTime? _selectedDate;
  // void _showDatePicker() async {
  //   var result = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2025),
  //     locale: Locale('zh'),
  //   ).then((value) {
  //     setState(() {
  //       if (value != null) {
  //         _dateTime = value;
  //       }
  //     });
  //   });
  // }

  List<dynamic> data = [];
  String expense = '0.00';
  String income = '0.00';
  String surplus = '0.00';

  String userId = '';
  String date = '';
  Timer? timer;
  @override
  void initState() {
    super.initState();
    DateTime _dateTime = DateTime.now();
    userId = widget.user_id; // 将user_id赋值给userIdString
    // _showDatePicker();
    _getData(_dateTime);
    print(date);
  }

  @override
  void dispose() {
    // 4. 在销毁组件时取消定时器
    timer?.cancel();
    super.dispose();
  }

  Future _getData(DateTime budget_date) async {
    // String budget_date = '2023-04';
    // _showDatePicker();
    String date = DateFormat("yyyy-MM").format(budget_date);
    // String date ='2023-04';
    print(date);
    // String budget_date = '2023-04';//获取页面传入php的信息在这里定义赋值
    var url =
        "http://$IP/test/lib/servers/budget.php?budget_date=$date&user_id=${widget.user_id}"; //连接php并传入值

    var response = await http.post(Uri.parse(url)); //解析响应php

    print(response.body);
    // var message = jsonDecode(response.body);
    // print(message);

    if (response.statusCode == 200) {
      setState(() {
        var responseBody = json.decode(response.body); //获取php传过来得json文件
        data = responseBody["data"]; //获取data列表
        expense = responseBody["expense"]; //获取头部金额head_data列表
        income = responseBody["income"];
        surplus = responseBody["surplus"];
        print(responseBody);
        print("----------------------------------------------");
        print(data);
        print(expense);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
      data = []; //获取data列表;
    }
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < data.length; i++) {
      // Extract the numbers from the current dictionary
      double amount = double.tryParse(data[i]['budget_amount']) ?? 0.0;
      double expense = double.tryParse(data[i]['budget_expense']) ?? 0.0;

      // Calculate the percentage and format it as a string
      if (amount != 0) {
        int percentage = ((expense / amount) * 100).round().clamp(0, 100);
        String percentageString = '$percentage%';
        data[i]['budget_percentage'] = percentageString;
      } else {
        data = [];
      }
      // Add the percentage to the dictionary as a new key-value pair
    }
    print(data);

    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: Column(children: [
        SizedBox(height: 260, child: _head()),
        if (data != null) SizedBox(height: 90, child: _addbug()),
        SizedBox(height: 10,),
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                final item = data[index];
                print(item);
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 10),
                    height: 120,
                    width: MediaQuery.of(context).size.width * 0.93,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 20,
                            ),
                            Text(
                              item['budget_type'],
                              style: TextStyle(
                                  fontSize: mySize10(15), color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            // SizedBox(
                            //   width: 10,
                            // ),
                            if (item['budget_percentage'] != '100%')
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      '¥' + item['budget_expense'],
                                      style: TextStyle(
                                          fontSize: mySize10(23),
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      item['budget_percentage'],
                                      style: TextStyle(
                                          fontSize: mySize10(13),
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            if (item['budget_percentage'] == '100%')
                              Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                  children: [
                                    Text(
                                      '¥' + item['budget_expense'],
                                      style: TextStyle(
                                          fontSize: mySize10(23),
                                          color: Colors.red,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      item['budget_percentage'],
                                      style: TextStyle(
                                          fontSize: mySize10(13),
                                          color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            // SizedBox(
                            //   width: 100,
                            // ),
                            if (item['budget_percentage'] == '100%')
                              Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: Text(
                                  '已超支',
                                  style: TextStyle(
                                      fontSize: mySize10(13),
                                      color: Color.fromRGBO(255, 124, 100, 1)),
                                ),
                              ),
                            if (item['budget_percentage'] != '100%')
                              SizedBox(
                                width: 45,
                              ),
                            // SizedBox(
                            //   width: 10,
                            // ),
                            if (item['budget_percentage'] != '0%')
                              Text(
                                '¥' + item['budget_amount'],
                                style: TextStyle(
                                    fontSize: mySize10(13), color: Colors.grey),
                              ),
                            if (item['budget_percentage'] == '0%')
                              Padding(
                                padding: EdgeInsets.only(left: 50),
                                child: Text(
                                  '¥' + item['budget_amount'],
                                  style: TextStyle(
                                      fontSize: mySize10(13),
                                      color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.87,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: double.parse(item['budget_expense']) /
                                  double.parse(item['budget_amount']),
                              backgroundColor: Colors.grey[300],
                              valueColor: item['budget_percentage'] == '100%'
                                  ? AlwaysStoppedAnimation<Color>(
                                      Color.fromARGB(255, 40, 53, 147))
                                  : AlwaysStoppedAnimation<Color>(
                                      Colors.lightGreen),
                              minHeight: 7,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ]),
    );
    //     }
    // });
  }

  Widget _addbug() {
    return Stack(alignment: Alignment.bottomCenter, children: [
      Container(
        width: MediaQuery.of(context).size.width * 0.93,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            TextButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryPage(
                      user_id: userId,
                    ),
                  ),
                );
                setState(() {
                  _refreshPage = true;
                  if (_selectedDate != null) _getData(_selectedDate!);
                  print(_selectedDate);
                });
              },
              child: Text(
                '添加预算',
                style: TextStyle(
                  fontSize: mySize10(20),
                  color: Colors.grey,
                  // textAlign: TextAlign.center, // 如果您想将文本居中，可以使用此属性
                ),
              ),
              style: ButtonStyle(
                fixedSize: MaterialStateProperty.all<Size>(
                  Size(
                    MediaQuery.of(context).size.width * 0.93, // 宽度
                    80, // 高度
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
  // onPressed: () {},
  // '添加预算',
  //                               style: TextStyle(fontSize: 20, color: Colors.grey),

  DateTime dateTime = DateTime.now();
  Widget _head() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
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
                padding: EdgeInsets.symmetric(vertical: 45),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          '月结余',
                          style: TextStyle(
                              fontSize: mySize10(19), color: Colors.white),
                        ),
                        Text(
                          '¥' + surplus,
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(
                        //   '日期',
                        //   style: TextStyle(fontSize: 15, color: Colors.white),
                        // ),
                        MaterialButton(
                          onPressed: () {
                            showMonthPicker(
                              context: context,
                              initialDate: DateTime.now(),
                              headerColor: Color.fromRGBO(255, 124, 100, 1),
                              selectedMonthTextColor: Colors.white,
                              unselectedMonthTextColor: Colors.grey,
                              selectedMonthBackgroundColor:
                                  Color.fromRGBO(255, 124, 100, 1),
                              confirmWidget: Text(
                                '确定',
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 124, 100, 1),
                                ),
                              ),
                              cancelWidget: Text(
                                '取消',
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(255, 124, 100, 1),
                                ),
                              ),

                              // selectedMonthBackgroundColor: Colors.amber[900],
                            ).then((date) {
                              if (date != null) {
                                setState(() {
                                  dateTime = date;
                                  _getData(date);
                                  _selectedDate = date;
                                });
                              }
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 37),
                            child: Row(
                              children: [
                                Text(
                                  '    ${DateFormat('yyyy-MM').format(dateTime)}',
                                  style: TextStyle(
                                      fontSize: mySize10(20),
                                      color: Colors.white),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  // size: 10,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 160,
          child: Center(
              child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.93,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '月支出',
                                style: TextStyle(
                                    fontSize: mySize10(15), color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: mySize10(10),
                                color: Colors.red,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '¥' + expense,
                                style: TextStyle(
                                    fontSize: mySize10(25),
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // SizedBox(
                      //   width: 60,
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '月收入',
                                style: TextStyle(
                                    fontSize: mySize10(15), color: Colors.grey),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                size: mySize10(10),
                                color: Color.fromRGBO(56, 239, 125, 1),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                '¥' + income,
                                style: TextStyle(
                                    fontSize: mySize10(25),
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ))),
        )
      ],
    );
  }
}
