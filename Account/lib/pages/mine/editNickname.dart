import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test/constant.dart';

class editNickname extends StatefulWidget {
  final String userId;
  final String userName;
  editNickname({Key? key, required this.userId, required this.userName})
      : super(key: key);

  @override
  State<editNickname> createState() => _editNicknameState();
}

class _editNicknameState extends State<editNickname> {
  String _newNickname = '';
  final _formKey = GlobalKey<FormState>();
  final _nicknameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nicknameController.text = widget.userName;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  Future<void> _updateNickname() async {
    String user_name = _newNickname;
    var url =
        "http://$IP/test/lib/servers/editNickname.php?&user_id=${widget.userId}&user_name=$user_name"; //连接php并传入值

    var response = await http.post(Uri.parse(url)); //解析响应php

    print(response.body);
    // var message = jsonDecode(response.body);
    // print(message);

    if (response.statusCode == 200) {
      setState(() {
        var responseBody = json.decode(response.body); //获取php传过来得json文件
        // income = responseBody["income"];
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 247, 248, 1),
      appBar: AppBar(
        elevation: 0, //去除阴影
        title: Text('编辑资料'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context, _newNickname);
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color.fromRGBO(255, 153, 102, 1),
                Color.fromRGBO(255, 94, 98, 1)
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: _formKey,
          child: Stack(
            children: [
              TextFormField(
                controller: _nicknameController,
                decoration: const InputDecoration(
                  labelText: '新的昵称',
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  return (value?.isEmpty ?? true) ? '请输入新的昵称' : null;
                },
                onSaved: (value) {
                  _newNickname = value ?? '';
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      await _updateNickname();
                      Navigator.pop(context, _newNickname);
                    }
                  },
                  child: const Text(
                    '确 定',
                    style: TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(3000, 70),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    primary: Colors.white,
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
