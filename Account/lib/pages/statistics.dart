import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test/constant.dart';
import 'package:test/pages/mine/setting.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:date_format/date_format.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';

class Statistics extends StatefulWidget {
  final String user_id;
  const Statistics({Key? key, required this.user_id}) : super(key: key);

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  DateTime _dateTime = DateTime.now();
  String _toast = "";
  bool flag = true;

  void _showDatePicker() {
    DatePicker.showDatePicker(context,
        pickerTheme: const DateTimePickerTheme(
          showTitle: true,
          confirm: Text('确定',
              style: TextStyle(color: Color.fromRGBO(255, 124, 100, 1))),
          cancel: Text('取消',
              style: TextStyle(color: Color.fromRGBO(255, 124, 100, 1))),
        ),
        minDateTime: DateTime.parse("1980-05-21"),
        initialDateTime: _dateTime,
        dateFormat: flag ? "yyyy" : "yyyy-MM",
        //只包含年、月、日
//        dateFormat: 'yyyy年M月d日  EEE,H时:m分',
        pickerMode: DateTimePickerMode.datetime,
        locale: DateTimePickerLocale.zh_cn, onCancel: () {
      debugPrint("onCancel");
    }, onConfirm: (dateTime, List<int> index) {
      setState(() {
        _dateTime = dateTime;
      });
    });
  }

  Future _getDate(_dateTime, flag) async {
    var incomeData = [];
    var expenseData = [];
    var typeData = [];
    print(flag);
    var incomeUrl =
        "http://$IP/test/lib/servers/getIncome.php?date=$_dateTime&flag=$flag&user_id=${widget.user_id}";
    var expenseUrl =
        "http://$IP/test/lib/servers/getExpense.php?date=$_dateTime&flag=$flag&user_id=${widget.user_id}";

    print("----------------------开始获取数据----------------------");
    //收入数据
    var incomeResponse = await http.post(Uri.parse(incomeUrl));
    var incomeMessage = jsonDecode(incomeResponse.body);
    incomeData = incomeMessage["data"];
    print('获取到incomeData');
    print(incomeMessage);

    //判断数据库中是否已经存在
    if (incomeResponse.statusCode != 200) {
      _toast = "数据库连接失败";
      print('数据库连接失败');
    }

    //支出数据
    var expenseResponse = await http.post(Uri.parse(expenseUrl));
    // Getting Server response into variable.
    var expenseMessage = jsonDecode(expenseResponse.body);
    //花费数据
    expenseData = expenseMessage["data"];
    print('获取到expenseData');
    print(expenseData);
    //花费类型
    typeData = expenseMessage["type_data"];
    print('获取到typeData');
    print(typeData);
    //判断数据库中是否已经存在
    if (expenseResponse.statusCode != 200) {
      _toast = "数据库连接失败";
      print('数据库连接失败');
    }

    print('----------------------数据获取结束----------------------');

    return {
      'incomeData': incomeData,
      'expenseData': expenseData,
      'typeData': typeData,
    };
  }

  @override
  Widget build(BuildContext context) {
    print("user_id:");
    print(widget.user_id);
    return FutureBuilder(
        future: _getDate(_dateTime.toString().split(" ")[0], flag),
        builder: (BuildContext context, AsyncSnapshot val) {
          switch (val.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Text('Loading...');
            case ConnectionState.done:
              print('获取到的数据：');
              print(val);
              return Scaffold(
                  backgroundColor: const Color.fromRGBO(248, 247, 248, 1),
                  body: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 265,
                          child: _head(
                              val.data['incomeData'], val.data['expenseData']),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 150,
                          child: Container(
                            height: 200,
                            margin: const EdgeInsetsDirectional.all(12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: _simpleLine(val.data['incomeData'],
                                  val.data['expenseData']),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 200,
                          child: Container(
                            height: 550,
                            margin: const EdgeInsetsDirectional.all(12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: _simplePie(val.data['typeData']),
                          ),
                        ),
                      )
                    ],
                  ));
          }
        });
  }

  int status = 1;
  int groupValue = 1;
  Widget _head(incomeData, expenseData) {
    double sum_expense = 0.00;
    double sum_income = 0.00;
    for (int i = 0; i < 31; i++) {
      var amount = 0.00;
      for (int j = 0; j < incomeData.length; j++) {
        if (int.parse(incomeData[j]["date"]) == i) {
          amount = double.parse(incomeData[j]["income_amount"]);
          sum_income += amount;
          break;
        }
      }
    }

    for (int i = 0; i < 31; i++) {
      var amount = 0.00;
      for (int j = 0; j < expenseData.length; j++) {
        if (int.parse(expenseData[j]["date"]) == i) {
          amount = double.parse(expenseData[j]["expense_amount"]);
          sum_expense += amount;
          break;
        }
      }
    }

    print("-----------总收入支出-----------");
    print(sum_expense);
    print(sum_income);
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
                padding: const EdgeInsets.symmetric(vertical: 35),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 45,
                        ),
                        Text(
                          flag ? '年结余' : '月结余',
                          style: TextStyle(
                              fontSize: mySize10(19), color: Colors.white),
                        ),
                        Text(
                          '¥${(sum_income - sum_expense).toStringAsFixed(2)}',
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Text(
                        //   '日期',
                        //   style: TextStyle(fontSize: 15, color: Colors.white),
                        //
                        MaterialButton(
                          onPressed: _showDatePicker,
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Radio(
                                    value: 1,
                                    groupValue: groupValue,
                                    activeColor: Colors.white,
                                    onChanged: (value) {
                                      setState(() {
                                        this.groupValue = value!;
                                        flag = true;
                                      });
                                    },
                                  ),
                                  Text(
                                    "按年份",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    // size: 10,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Text(
                              //       (_dateTime.year).toString().split(" ")[0],
                              //       style: const TextStyle(
                              //           fontSize: 15, color: Colors.white),
                              //     ),
                              //   ],
                              // )
                            ],
                          ),
                        ),
                        MaterialButton(
                          onPressed: _showDatePicker,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                    value: 2,
                                    groupValue: groupValue,
                                    activeColor: Colors.white,
                                    onChanged: (value) {
                                      setState(() {
                                        groupValue = value!;
                                        flag = false;
                                      });
                                    },
                                  ),
                                  Text(
                                    "按月份",
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.white),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    // size: 10,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              // Row(
                              //   children: [
                              //     Text(
                              //       "${(_dateTime.year).toString().split(" ")[0]}-${(_dateTime.month).toString().split(" ")[0]}",
                              //       style: const TextStyle(
                              //           fontSize: 15, color: Colors.white),
                              //     ),

                              //   ],
                              // )
                            ],
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                flag ? '年支出' : '月支出',
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
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '¥${sum_expense.toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontSize: mySize10(25),
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                        ],
                      ),
                      // const SizedBox(
                      //   width: 60,
                      // ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Text(
                                flag ? '年收入' : '月收入',
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
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '¥${sum_income.toStringAsFixed(2)}',
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

  //折线图
  Widget _simpleLine(incomeData, expenseData) {
    List<LinearSales> incomeList = [];
    List<LinearSales> expenseList = [];
    print(flag);
    var length = flag ? 12 : 31;
    //收入
    for (int i = 0; i < length; i++) {
      var amount = 0.00;
      for (int j = 0; j < incomeData.length; j++) {
        if (int.parse(incomeData[j]["date"]) == i) {
          amount = double.parse(incomeData[j]["income_amount"]);
          break;
        }
      }
      incomeList.add(LinearSales(i, amount));
    }

    //花费
    for (int i = 0; i < length; i++) {
      var amount = 0.00;
      for (int j = 0; j < expenseData.length; j++) {
        if (int.parse(expenseData[j]["date"]) == i) {
          amount = double.parse(expenseData[j]["expense_amount"]);
          break;
        }
      }
      expenseList.add(LinearSales(i, amount));
    }
    var seriesList = [
      charts.Series<LinearSales, int>(
        id: 'Income',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(
            const Color.fromRGBO(56, 239, 125, 1)),
        domainFn: (LinearSales sales, _) => sales.date,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: incomeList,
      ),
      charts.Series<LinearSales, int>(
        id: 'Expense',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(Colors.red),
        domainFn: (LinearSales sales, _) => sales.date,
        measureFn: (LinearSales sales, _) => sales.sales,
        data: expenseList,
      ),
    ];
    return charts.LineChart(
      seriesList,
      animate: true,
    );
  }

  // 饼状图
  Widget _simplePie(typeData) {
    List<PieSales> pieList = [];
    for (int i = 0; i < typeData.length; i++) {
      Color PieColor = Color.fromARGB(
        255,
        Random.secure().nextInt(250),
        Random.secure().nextInt(250),
        Random.secure().nextInt(250),
      );
      pieList.add(PieSales(
          i,
          typeData[i]["type"],
          double.parse(typeData[i]["amount"]),
          charts.ColorUtil.fromDartColor(PieColor)));
    }
    var seriesList = [
      charts.Series<PieSales, int>(
        id: 'Sales',
        domainFn: (PieSales sales, _) => sales.type_id,
        measureFn: (PieSales sales, _) => sales.amount,
        colorFn: (PieSales sales, _) => sales.color,
        data: pieList,
        labelAccessorFn: (PieSales row, _) => '${row.type}: ${row.amount}',
      )
    ];

    if (typeData.isNotEmpty) {
      return charts.PieChart(seriesList,
          animate: true,
          defaultRenderer: charts.ArcRendererConfig<Object>(
              arcRendererDecorators: [
                charts.ArcLabelDecorator(
                    labelPosition: charts.ArcLabelPosition.outside)
              ]));
    } else {
      return Center(
        child: Text(
          "该日期无消费记录\n\n请切换日期或进行记账",
          style: TextStyle(fontSize: mySize10(17), color: Colors.grey),
        ),
      );
    }
  }
}

class PieSales {
  final int type_id;
  final String type;
  final double amount;
  final charts.Color color;

  PieSales(this.type_id, this.type, this.amount, this.color);
}

class LinearSales {
  final int date;
  final double sales;
  LinearSales(this.date, this.sales);
}

class MenuItem {
  String label; // 显示的文本
  dynamic value; // 选中的值
  bool checked; // 是否选中

  MenuItem({this.label = '', this.value, this.checked = false});
}
