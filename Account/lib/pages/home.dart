import 'package:flutter/material.dart';
// import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:http/http.dart' as http;
import 'package:test/pages/mine/setting.dart';
import '../constant.dart';
import 'dart:convert';

class Home extends StatefulWidget {
  final String user_id;
  const Home({Key? key, required this.user_id}) : super(key: key);
  // const Home({required Key key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  DateTime _dateTime = DateTime.now();

  void _showDatePicker() async {
    var result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      locale: const Locale('zh'),
    ).then((value) {
      setState(() {
        if (value != null) {
          _dateTime = value;
        }
      });
    });
  }

  Future _getData(dateTime, [label, id, flag]) async {
    if (flag == 1) {
      var delUrl =
          "http://$IP/test/lib/servers/delData.php?id=$id&label=$label&user_id=${widget.user_id}";

      //收入数据
      var delResponse = await http.post(Uri.parse(delUrl));
      var delMessage = jsonDecode(delResponse.body);
      print('获取到delMessage');
      print(delMessage["message"]);
      //判断数据库中是否已经存在
      if (delResponse.statusCode == 200) {
        print('数据库连接失败');
      }
    }

    List<dynamic> dayData = [];
    var dayUrl =
        "http://$IP/test/lib/servers/home.php?date=$dateTime&user_id=${widget.user_id}";

    print("----------------------开始获取数据----------------------");

    print(flag);
    //收入数据
    var dayResponse = await http.post(Uri.parse(dayUrl));
    var dayMessage = jsonDecode(dayResponse.body);
    print('获取到dayMessage');
    dayData = dayMessage["data"];
    var m_expense = dayMessage["m_expense"];
    var m_income = dayMessage["m_income"];
    //判断数据库中是否已经存在
    if (dayResponse.statusCode == 200) {
      print('数据库连接失败');
    }

    print('----------------------数据获取结束----------------------');
    return {
      "dayData": dayData,
      "m_expense": double.parse(m_expense),
      "m_income": double.parse(m_income),
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getData(
          _dateTime.toString().split(" ")[0],
        ),
        builder: (BuildContext context, AsyncSnapshot val) {
          switch (val.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return const Text('Loading...');
            case ConnectionState.done:
              print('获取到的数据：');
              var itemList = val.data["dayData"];
              print(itemList);
              return Scaffold(
                backgroundColor: const Color.fromRGBO(248, 247, 248, 1),
                body: Column(
                  children: [
                    SizedBox(
                        height: 265,
                        child:
                            _head(val.data["m_expense"], val.data["m_income"])),
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.only(top: 0),
                        itemCount: itemList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = itemList[index];
                          // print("-----------------emoji------------");
                          // print(item);
                          var title =
                              "${itemList[index]["emoji"]}   ${itemList[index]["remark"]}";
                          if (itemList[index]["remark"] == '') {
                            title =
                                "${itemList[index]["emoji"]}   ${itemList[index]["type"]}";
                          }
                          // print(title);
                          // print(itemList[index]["label"]);
                          var amount = (itemList[index]["label"] == "expense")
                              ? "-¥${itemList[index]["amount"]}"
                              : "¥${itemList[index]["amount"]}";
                          return Dismissible(
                            key: Key(item['type']),
                            direction: DismissDirection.endToStart,
                            onDismissed: (direction) async {
                              await _getData(_dateTime.toString().split(" ")[0],
                                  item["label"], item["id"], 1);
                              setState(() {
                                itemList[index].remove(index);
                              });
                            },
                            background: Container(
                              color: Colors.red,
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 16),
                              child:
                                  const Icon(Icons.delete, color: Colors.white),
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(title,
                                    style: TextStyle(
                                        fontSize: mySize10(18),
                                        color: Colors.grey)),
                                trailing: Text(amount,
                                    style: TextStyle(
                                        fontSize: mySize10(15),
                                        color: Colors.grey)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
          }
        });
  }

  Widget _head(expense, income) {
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
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 40,
                        ),
                        Text(
                          '月结余',
                          style: TextStyle(
                              fontSize: mySize10(19), color: Colors.white),
                        ),
                        Text(
                          "¥${(income - expense).toStringAsFixed(2)}",
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
                        const SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                          onPressed: _showDatePicker,
                          child: Row(
                            children: [
                              Text(
                                _dateTime.toString().split(" ")[0],
                                style: TextStyle(
                                    fontSize: mySize10(20),
                                    color: Colors.white),
                              ),
                              const Icon(
                                Icons.keyboard_arrow_down,
                                // size: 10,
                                color: Colors.white,
                              ),
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
                              SizedBox(
                                width: 15,
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
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '¥${expense.toStringAsFixed(2)}',
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
                      //   width: 30,
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
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                '¥${income.toStringAsFixed(2)}',
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
