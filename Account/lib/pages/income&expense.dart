import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:test/pages/mine/setting.dart';
import '../constant.dart';

class CategoryPage extends StatefulWidget {
  // late final Category initialCategory;
  final String user_id;
  const CategoryPage({Key? key, required this.user_id}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with SingleTickerProviderStateMixin {
  String? _selectedCategory;
  String? selectedTabTitle;
  late TabController _tabController;
  DateTime _dateTime = DateTime.now();
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
  //         print(_dateTime);
  //       }
  //     });
  //   });
  // }

  final Map<String, String> _categories = {
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

  final Map<String, String> _categories1 = {
    '工资': '💴',
    '兼职': '👨‍💻',
    '闲置': '🧥',
    '理财': '🧶',
    '其他': '👍',
  };

  late String _amount;
  late String _content;
  late String _ddl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // _tabController.addListener(_handleTabSelection);
    // String selectedTabTitle = _tabController.index == 0 ? '支出' : '收入';
  }

  // void _handleTabSelection() {
  //   String selectedTabTitle = _tabController.index == 0 ? '支出' : '收入';
  //   print('当前选中的Tab是：$selectedTabTitle');
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Icon(
          Icons.photo,
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(255, 124, 100, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: TextStyle(fontSize: mySize10(18.0)),
          indicatorColor: Colors.white,
          controller: _tabController,
          tabs: [
            Tab(
              text: '支出',
            ),
            Tab(
              text: '收入',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildGridView1(),
          _buildGridView2(),
        ],
      ),
    );
  }

  Widget _buildGridView1() {
    return Padding(
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
                      style: TextStyle(fontSize: mySize10(14.0)),
                    ),
                    // SizedBox(
                    //   height: 8,
                    // ),
                    Text(
                      emoji, // 显示每个类别对应的emoji
                      style: TextStyle(fontSize: mySize10(20.0)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGridView2() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: flag1 ? 4 : 5,
        children: List.generate(
          _categories1.length,
          (index) {
            final category = _categories1.keys.toList()[index];
            final emoji = _categories1.values.toList()[index];
            return GestureDetector(
              onTap: () => _onCategorySelected(category),
              child: Container(
                margin: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50.0),
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
                      style: TextStyle(fontSize: mySize10(14.0)),
                    ),
                    // SizedBox(
                    //   height: flag1 ? 0 : 8,
                    // ),
                    Text(
                      emoji, // 显示每个类别对应的emoji
                      style: TextStyle(fontSize: mySize10(20.0)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  final picker = ImagePicker();
  XFile? _imageFile;
  List<XFile>? _imageFiles;
  CroppedFile? _croppedFile;
  //拍照
  _takePhoto() async {
    XFile? pickedFile = await picker.pickImage(
        source: ImageSource.camera, maxHeight: 600, maxWidth: 600);

    if (pickedFile != null) {
      print(pickedFile.path);
      print(File(pickedFile.path));
      setState(() {
        _cropImage(pickedFile);
      });
    }
  }

  //打开文件夹选单张图片
  _pickImage() async {
    XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 600, maxWidth: 600);

    if (pickedFile != null) {
      setState(() {
        _cropImage(pickedFile);
      });
    }
  }

  //裁剪
  _cropImage(XFile imageFile) async {
    print(imageFile);
    CroppedFile? croppedFile = await ImageCropper()
        .cropImage(sourcePath: imageFile.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
    ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: '剪裁图片',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        minimumAspectRatio: 1.0,
      ),
    ]);

    if (croppedFile != null) {
      setState(() {
        print(_croppedFile);
        _croppedFile = croppedFile;
        File image = File(_croppedFile!.path);
        _getData(image);
      });
    }
  }

  void _showDialog(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              // leading: Icon(Icons.camera),
              title: Center(child: Text('拍照')),
              onTap: () {
                Navigator.of(context).pop();
                _takePhoto();
              },
            ),
            ListTile(
              // leading: Icon(Icons.photo),
              title: Center(child: Text('从相册中选择')),
              onTap: () {
                Navigator.of(context).pop();
                _pickImage();
              },
            ),
            ListTile(
              // leading: Icon(Icons.cancel),
              title: Center(child: Text('取消')),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //从图片中获取数据
  _getData(File img) async {
    Uint8List imageBytes = await img.readAsBytes();
    print(imageBytes);
    const APP_ID = '3496503b3314a60f1fab6052c3d7b63d';
// 请登录后前往 “工作台-账号设置-开发者信息” 查看 x-ti-secret-code
// 示例代码中 x-ti-secret-code 非真实数据
    const SECRET_CODE = '58cd7e65730ef90713f1e562ef4b2ea8';
// 商铺小票识别
    const URL = 'https://api.textin.com/robot/v1.0/api/bills_crop';

    print("----------------------开始获取数据----------------------");
    //收入数据
    var Response = await http.post(Uri.parse(URL),
        headers: {'x-ti-app-id': APP_ID, 'x-ti-secret-code': SECRET_CODE},
        body: imageBytes);
    var Message = jsonDecode(Response.body);
    print(Message);
    var Data = Message["result"]["object_list"][0];
    print(Data);
    var amount = '';
    var date = '';
    var category = Data["kind_description"];
    var item_list = Data["item_list"];
    if (Data["type"] == "shop_receipt") {
      for (int i = 0; i < item_list.length; i++) {
        if (item_list[i]["key"] == "money") {
          amount = item_list[i]["value"];
        }
        if (item_list[i]["key"] == "date") {
          date = item_list[i]["value"];
        }
      }
    } else if (Data["type"] == "train_ticket") {
      for (int i = 0; i < item_list.length; i++) {
        if (item_list[i]["key"] == "price") {
          amount = item_list[i]["value"];
        }
        if (item_list[i]["key"] == "departure_date") {
          date = item_list[i]["value"];
        }
      }
    } else if (Data["type"] == "air_transport") {
      for (int i = 0; i < item_list.length; i++) {
        if (item_list[i]["key"] == "total") {
          amount = item_list[i]["value"];
        }
        if (item_list[i]["key"] == "issued_date") {
          date = item_list[i]["value"];
        }
      }
    }
    print(amount);
    print(date);
    var _toast = '识别成功';
    if (Response.statusCode != 200) {
      _toast = "Api连接失败,请手动记账";
    }
    if (amount != '') {
      _toast = '识别成功';
      _dateTime = DateTime.parse(date);
      _showInputDialog(category, amount);
    } else {
      _toast = "识别失败,请手动记账或者重新识别";
      _showInputDialog(category, amount);
    }
    Fluttertoast.showToast(
        msg: _toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 87, 86, 86),
        textColor: Colors.white,
        fontSize: mySize10(16.0));
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      // 点击类别弹出窗口后输入支出数额都置为空
    });
    _showInputDialog(category, "");
  }

  //记账
  Future _putData(id, type, amount, remark, date, emoji, flag) async {
    var _toast = '';
    var url = '';
    remark ??= '';
    if (flag == 1) {
      url =
          "http://$IP/test/lib/servers/putIncome.php?user_id=$id&income_type=$type&income_amount=$amount&income_remark=$remark&date=$date&emoji=$emoji";
    } else {
      url =
          "http://$IP/test/lib/servers/putExpense.php?user_id=$id&expense_type=$type&expense_amount=$amount&expense_remark=$remark&date=$date&emoji=$emoji";
    }

    var response = await http.post(Uri.parse(url));
    // Getting Server response into variable.
    var message = jsonDecode(response.body);
    _toast = message["message"].toString();

    //判断数据库中是否已经存在
    if (response.statusCode == 200) {
      if (!message["error"]) {
        _toast = "记账成功";
      }
    } else {
      _toast = "记账失败";
    }
    Fluttertoast.showToast(
        msg: _toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Color.fromARGB(255, 87, 86, 86),
        textColor: Colors.white,
        fontSize: mySize10(16.0));
  }

  void _showInputDialog(String category, amount) {
    final List<String> list = _tabController.index == 0
        ? _categories.keys.toList()
        : _categories1.keys.toList();

    category = list.contains(category) ? category : list[0];
    DateTime _selectedDate = DateTime.now();
    String? _amount;
    _amount = amount; //
    String? _content;
    _content = '';

    showDialog(
        context: context,
        builder: (BuildContext context) {
          // String contentText = "Content of Dialog";
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: DropdownButton<String>(
                value: category,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  // size: 10,
                  color: Colors.grey,
                ),
                elevation: 16,
                underline: Container(),
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    category = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: TextEditingController()..text = _amount!,
                    decoration: InputDecoration(
                      labelText: '输入数额',
                      hintText: '0.00',
                    ),
                    onChanged: (value) => _amount = value,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: '输入内容（选填）',
                    ),
                    onChanged: (value) => _content = value,
                  ),
                  category == '会员'
                      ? Container(
                          child: Column(
                            children: [
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: '输入会员期限',
                                ),
                                onChanged: (value) => _ddl = value,
                              ),
                            ],
                          ),
                        )
                      : Container(),
                  MaterialButton(
                    onPressed: () async {
                      var value = await showDatePicker(
                        context: context,
                        initialDate: _dateTime,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        locale: Locale('zh'),
                      );
                      setState(() {
                        if (value != null) {
                          _dateTime = value;
                          // contentText = "$_dateTime";
                        }
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          _dateTime.toString().split(" ")[0],
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
                      if (_amount == '') {
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
                        print(_tabController.index);
                        print('类别：$category，金额：$_amount，内容：$_content');
                        print(_categories[category]);
                        var id = widget.user_id;
                        var type = category;
                        var emoji = _tabController.index > 0
                            ? _categories1[category]
                            : _categories[category];
                        var flag = _tabController.index;
                        print(_dateTime.toString().split(" ")[0]);
                        print(_categories1);
                        _putData(id, type, _amount, _content,
                            _dateTime.toString().split(" ")[0], emoji, flag);
                        Navigator.pop(context, "");
                      }
                    },
                    child: Text('确定')),
              ],
            );
          });
        });
  }

//   void _printInfo() {
//     print(
//         '类型: $selectedTabTitle, 类别: $_selectedCategory, 金额: $_amount, 内容: $_content');
//     Navigator.pop(context);
//   }
}
