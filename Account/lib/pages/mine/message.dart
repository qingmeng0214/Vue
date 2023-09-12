import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/pages/personal.dart';
import 'package:test/constant.dart';

class Message extends StatefulWidget {
  final String user_id;
  const Message({Key? key, required this.user_id}) : super(key: key);

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  String userId = '';

  @override
  void initState() {
    super.initState();
    userId = widget.user_id; // 将user_id赋值给userIdString
  }

  List<Map<String, String>> itemList = [
    {'time': "12-03 10:51", 'message': '今天要记账啦!'},
    {'time': "12-02 11:01", 'message': '今天要记账啦!'},
    {'time': "12-02 7:29", 'message': '截止今天，娱乐的支出超出预算了哦'},
    {'time': "12-01 19:34", 'message': '您的年度消费报告已出炉，请查收！'},
    {'time': "12-01 19:34", 'message': '今天要记账啦!'},
    {'time': "12-01 19:34", 'message': '今天要记账啦!'},
    {'time': "12-01 19:34", 'message': '今天要记账啦!'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 247, 248, 1),
      appBar: AppBar(
        elevation: 0, //去除阴影
        title: Text('消息通知'),
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: itemList.length,
                itemBuilder: (BuildContext context, int index) {
                  return Dismissible(
                    key: Key(itemList[index]['time'].toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        itemList.removeAt(index);
                      });
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundImage: AssetImage('images/appIcon.jpg'),
                            ),
                            title: Text('保卫钱袋',
                                style: TextStyle(
                                    fontSize: mySize10(14),
                                    color: Color.fromRGBO(102, 102, 102, 1))),
                            subtitle: Text(itemList[index]['time']!,
                                style: TextStyle(
                                    color: Color.fromRGBO(153, 153, 153, 1))),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8.0, left: 73.0, bottom: 28.0, right: 10),
                            child: Text(itemList[index]['message']!,
                                style: TextStyle(
                                    fontSize: mySize10(20),
                                    color: Color.fromRGBO(102, 102, 102, 1))),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
