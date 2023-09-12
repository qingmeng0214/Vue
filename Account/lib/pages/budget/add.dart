import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:test/constant.dart';

//预算
class CategoryPage extends StatefulWidget {
  final String user_id;

  const CategoryPage({Key? key, required this.user_id}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  // late String _selectedCategory;
  String? _selectedCategory;
  String type = '';
  String? _amount;
  String? _content;
  DateTime? _selectedDate;

  DateTime _dateTime = DateTime.now();

  Map<String, String> _categories = {
    '水果': '🍎',
    '蔬菜': '🥦',
    '社交': '🍻',
    '零食': '🍰',
    '娱乐': '🎉',
    '购物': '🛍',
    '礼物': '🎁',
    '交通': '🚌',
    '孩子': '👶🏻',
    '宠物': '🐶',
    '爱好': '🎨',
    '学习': '💡',
    '药品': '💊',
    '生活': '🧶',
    '长辈': '👵🏻',
    '运动': '🏋️',
    '水费': '💧️',
    '会员': '📱',
    '电费': '⚡',
    '燃气': '💨',
    '其他': '👍',
  };

  // late String _amount;
  // late String _content;
  Future _getData(
      String type, String amount, String remark, DateTime Sdate) async {
    // String budget_date = '2023-04';
    // _showDatePicker();
    String date = DateFormat("yyyy-MM").format(Sdate);
    // String date ='2023-04';
    String _toast = '';
    print(type);
    print(amount);
    print(remark);
    print(date);
    // String budget_date = '2023-04';//获取页面传入php的信息在这里定义赋值
    var url =
        "http://$IP/test/lib/servers/addbudget.php?date=$date&amount=$amount&remark=$remark&type=$type&user_id=${widget.user_id}"; //连接php并传入值

    var response = await http.post(Uri.parse(url)); //解析响应php

    print(response.body);
    // var message = jsonDecode(response.body);
    // print(message);

    if (response.statusCode == 200) {
      setState(() {
        var responseBody = json.decode(response.body); //获取php传过来得json文件
        print(responseBody);
      });
      _toast = "预算添加完成";
      Fluttertoast.showToast(
          msg: _toast,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 87, 86, 86),
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '预算',
          style: TextStyle(
              fontSize: mySize10(22),
              color: Colors.white,
              fontWeight: FontWeight.w500),
        ),
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(255, 153, 102, 1),
              Color.fromRGBO(255, 94, 98, 1)
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.count(
          crossAxisCount: flag1 ? 4 : 5,
          children: List.generate(
            _categories.length,
            (index) {
              final category = _categories.keys.toList()[index];
              final emoji = _categories.values.toList()[index];
              return GestureDetector(
                onTap: () => _onCategorySelected(category),
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50.0),
                    // border: Border.all(
                    //   color: _selectedCategory == category
                    //       ? Colors.grey[350]
                    //       : Colors.transparent,
                    //   width: 1.5,
                    // ),
                    border: Border.all(
                      color: _selectedCategory == category
                          ? Colors.grey[350]!
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category,
                        style: TextStyle(fontSize: mySize10(14)),
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Text(
                        emoji, // 显示每个类别对应的emoji
                        style: TextStyle(fontSize: mySize10(20)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      // 点击类别弹出窗口后输入支出数额都置为空
    });
    _showInputDialog(category);
    type = _selectedCategory ?? _categories.keys.first;
  }

  void _showInputDialog(String category) {
    DateTime dateTime = DateTime.now();
    String? _amount;
    _amount = null; //
    String? _content;
    _content = null;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          // String contentText = "Content of Dialog";
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(category),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: '输入数额',
                      hintText: '0.00',
                    ),
                    onChanged: (value) => _amount = value,
                  ),
                  SizedBox(height: 16.0),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '输入内容（选填）',
                    ),
                    onChanged: (value) => _content = value,
                  ),
                  SizedBox(height: 16.0),
                  MaterialButton(
                    onPressed: () {
                      showMonthPicker(
                        context: context,
                        initialDate: DateTime.now(),
                        headerColor: const Color.fromRGBO(255, 124, 100, 1),
                        selectedMonthTextColor: Colors.white,
                        unselectedMonthTextColor: Colors.grey,
                        selectedMonthBackgroundColor:
                            Color.fromRGBO(255, 124, 100, 1),
                        confirmWidget: const Text(
                          '确定',
                          style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(255, 124, 100, 1),
                          ),
                        ),
                        cancelWidget: const Text(
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
                            _selectedDate = date;
                          });
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          '${dateTime.year}-${dateTime.month}',
                          style: TextStyle(
                              fontSize: mySize10(20), color: Colors.black54),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down,
                          // size: 10,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text('取消')),
                TextButton(
                    onPressed: () {
                      if (_amount == null) {
                        // 如果用户未输入支出数额，弹出提示框
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('提示'),
                                content: Text('数额不能为空~'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('确定')),
                                ],
                              );
                            });
                      } else {
                        print(
                            '类别：$_selectedCategory,金额：$_amount,内容：$_content,时间：$dateTime');
                        _getData(_selectedCategory!, _amount!, _content ?? '',
                            dateTime);

                        Navigator.pop(context);
                      }
                    },
                    child: Text('确定')),
              ],
            );
          });
        });
  }

//   void _printInfo() {
//     print('类别: $_selectedCategory, 金额: $_amount, 内容: $_content');
//     Navigator.pop(context);
//   }
}
