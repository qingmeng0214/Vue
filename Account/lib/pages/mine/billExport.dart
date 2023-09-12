import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:test/pages/personal.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:test/constant.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_baseflow_permissions/flutter_baseflow_permissions.dart';

class billExport extends StatefulWidget {
  final String user_id;
  const billExport({Key? key, required this.user_id}) : super(key: key);

  @override
  State<billExport> createState() => _billExportState();
}

class _billExportState extends State<billExport> {
  // 模拟账单数据
  List<Map<String, dynamic>> billData = [];

  Future _getData(DateTime begin_date, DateTime end_date) async {
    // String budget_date = '2023-04';
    // _showDatePicker();
    String begin = DateFormat('yyyy-MM-dd').format(begin_date);
    String end = DateFormat('yyyy-MM-dd').format(end_date);

    print(end);

    var url =
        "http://$IP/test/lib/servers/billExport.php?begin=$begin&end=$end&user_id=${widget.user_id}"; //连接php并传入值

    var response = await http.post(Uri.parse(url)); //解析响应php

    print(response.body);

    // var message = jsonDecode(response.body);
    // print(message);

    if (response.statusCode == 200) {
      void someAsyncMethod() async {
        // 在异步操作完成后，同步更新小部件状态
        setState(() {
          var responseBody = json.decode(response.body); //获取php传过来得json文件
          billData =
              List<Map<String, dynamic>>.from(responseBody["data"]); //获取data列表

          print(billData);
        });
        await Permission.storage.request();
        await exportExcelBill(billData);
      }

      someAsyncMethod();
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  DateTime _dateTime = DateTime.now();
  DateTime _dateTime1 = DateTime.now();

  String _toast = "";
  Future<void> exportExcelBill(List<Map<String, dynamic>> billData) async {
    // 创建 Excel 文件
    var excel = Excel.createExcel();

    // 创建工作表
    Sheet sheet = excel['Sheet1'];

    // 设置表头
    sheet.appendRow(['日期', '收入类型', '收入金额', '支出类型', '支出金额']);

    // 遍历账单数据，生成 Excel 行数据
    for (var item in billData) {
      sheet.appendRow([
        item['date'],
        item['expense_type'],
        item['expense_amount'],
        item['income_type'],
        item['income_amount'],
      ]);
      print('hahahhahahahahahahahah');
    }

// 获取应用程序的私有文件夹路径
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String filePath = '${appDocDir.path}/bill_data.xlsx';

    // 将生成的 Excel 文件写入到应用程序的私有文件夹中
    var file = File(filePath);
    var excelBytes = excel.encode();
    await file.writeAsBytes(excelBytes!);

    // 可选：将生成的 Excel 文件导出到指定位置
    var exportFile =
        File('/storage/emulated/0/Documents/exported_bill_data.xlsx');
    var exportedExcelBytes = excel.encode();
    await exportFile.writeAsBytes(exportedExcelBytes!);

    _toast = "账单导出完成";
    Fluttertoast.showToast(
        msg: _toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 87, 86, 86),
        textColor: Colors.white,
        fontSize: 16.0);

    print('Excel 账单导出完成！');
  }

  void _showDatePicker() async {
    var result = await showDatePicker(
      context: context,
      initialDate: _dateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: Locale('zh'),
    );
    if (result != null) {
      setState(() {
        if (_dateTime1.isAfter(result)) {
          _dateTime = result;
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('日期选择错误'),
                content: Text('结束日期不能在开始日期之前~'),
                actions: [
                  TextButton(
                    child: Text('确定'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }

  void _showDatePicker1() async {
    var result = await showDatePicker(
      context: context,
      initialDate: _dateTime1,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: Locale('zh'),
    );
    if (result != null) {
      setState(() {
        if (_dateTime.isBefore(result)) {
          _dateTime1 = result;
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('日期选择错误'),
                content: Text('结束日期不能在开始日期之前'),
                actions: [
                  TextButton(
                    child: Text('确定'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              );
            },
          );
        }
      });
    }
  }

  String userId = '';

  @override
  void initState() {
    super.initState();
    userId = widget.user_id; // 将user_id赋值给userIdString
    // _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 247, 248, 1),
      appBar: AppBar(
        elevation: 0, //去除阴影
        title: Text('账单导出'),
        centerTitle: true,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => Personal(user_id:userId ,)),
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
      body: SafeArea(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
                  Text(
                    '开始日期',
                    style: TextStyle(fontSize: mySize10(17)),
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: _showDatePicker,
                        child: Row(
                          children: [
                            Text(
                              _dateTime.toString().split(" ")[0],
                              style: TextStyle(
                                  fontSize: mySize10(20), color: Colors.grey),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: mySize10(30),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                  Text(
                    '结束日期',
                    style: TextStyle(fontSize: mySize10(17)),
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: _showDatePicker1,
                        child: Row(
                          children: [
                            Text(
                              _dateTime1.toString().split(" ")[0],
                              style: TextStyle(
                                  fontSize: mySize10(20), color: Colors.grey),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              size: mySize10(30),
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    // 导出 Excel 账单
                    onTap: () async {
                      _getData(_dateTime, _dateTime1);
                      print(_dateTime);
                      print(_dateTime1);
                      // exportExcelBill(billData);
                      // setState(() {
                      // });
                    },
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
                            '导出为Excel',
                            style: TextStyle(fontSize: mySize10(20)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
