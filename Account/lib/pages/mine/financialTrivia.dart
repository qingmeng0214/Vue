import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/pages/personal.dart';
import 'package:tcard/tcard.dart';
import 'package:flutter/services.dart';
import 'package:test/constant.dart';

class financialTrivia extends StatefulWidget {
  final String user_id;
  const financialTrivia({Key? key, required this.user_id}) : super(key: key);
  @override
  State<financialTrivia> createState() => _financialTriviaState();
}

class _financialTriviaState extends State<financialTrivia> {
  String userId = '';

  @override
  void initState() {
    super.initState();
    userId = widget.user_id; // 将user_id赋值给userIdString
  }

  TCardController _controller = TCardController();

  List<String> images = [
    'images/financial1.png',
    'images/financial2.png',
    'images/financial3.png',
  ];

  Future<List<ImageProvider>> _loadImages() async {
    List<ImageProvider> imageProviders = [];
    for (String imagePath in images) {
      ByteData byteData = await rootBundle.load(imagePath);
      Uint8List uint8List = byteData.buffer.asUint8List();
      imageProviders.add(MemoryImage(uint8List));
    }
    return imageProviders;
  }

  int _index = 0;

  // List<Widget> cards = List.generate(
  //   images.length,
  //       (int index) {
  //     return Container(
  //       alignment: Alignment.center,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(16.0),
  //         boxShadow: [
  //           BoxShadow(
  //             offset: Offset(0, 17),
  //             blurRadius: 23.0,
  //             spreadRadius: -13.0,
  //             color: Colors.black54,
  //           )
  //         ],
  //       ),
  //       child: ClipRRect(
  //         borderRadius: BorderRadius.circular(16.0),
  //         child: Image.asset(
  //           images[index],
  //           width: 330,
  //           height: 550,
  //           fit: BoxFit.cover,
  //         ),
  //       ),
  //     );
  //   },
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(248, 247, 248, 1),
      appBar: AppBar(
        elevation: 0, //去除阴影
        title: Text('理财小知识'),
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
        child: Column(
          children: <Widget>[
            SizedBox(height: 25),
            // TCard(
            //   size: Size(334, 551),
            //   cards: cards,
            //   controller: _controller,
            //   onForward: (index, info) {
            //     _index = index;
            //     print(info.direction);
            //     setState(() {});
            //   },
            //   onBack: (index, info) {
            //     _index = index;
            //     setState(() {});
            //   },
            //   onEnd: () {
            //     print('end');
            //   },
            // ),
            FutureBuilder<List<ImageProvider>>(
              future: _loadImages(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<ImageProvider>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return TCard(
                  cards: snapshot.data!
                      .map((imageProvider) => Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  offset: Offset(0, 17),
                                  blurRadius: 23.0,
                                  spreadRadius: -13.0,
                                  color: Colors.black54,
                                )
                              ],
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ))
                      .toList(),
                  size: Size(MediaQuery.of(context).size.width - 40,
                      MediaQuery.of(context).size.height * 0.7),
                  controller: _controller,
                );
              },
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    _controller.back();
                  },
                  child: Text('上一张'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    primary: Color.fromRGBO(255, 124, 100, 1),
                    elevation: 5,
                    shadowColor:
                        Color.fromRGBO(255, 124, 100, 1).withOpacity(0.5),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.reset();
                  },
                  child: Text('再看一遍'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    primary: Color.fromRGBO(255, 124, 100, 1),
                    elevation: 5,
                    shadowColor:
                        Color.fromRGBO(255, 124, 100, 1).withOpacity(0.5),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _controller.forward();
                  },
                  child: Text('下一张'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    primary: Color.fromRGBO(255, 124, 100, 1),
                    elevation: 5,
                    shadowColor:
                        Color.fromRGBO(255, 124, 100, 1).withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
