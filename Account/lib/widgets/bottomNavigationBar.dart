import 'package:flutter/material.dart';
import 'package:test/pages/statistics.dart';
import 'package:test/pages/budget.dart';
import 'package:test/pages/mine/setting.dart';

import '../pages/income&expense.dart';
import '../pages/home.dart';
import '../pages/personal.dart';

class Bottom extends StatefulWidget {
  final String user_id;
  const Bottom({Key? key, required this.user_id}) : super(key: key);

  @override
  State<Bottom> createState() => _BottomState();
}

class _BottomState extends State<Bottom> {
  int index_color = 0;

  @override
  Widget build(BuildContext context) {
    List Screen = [
      Home(
        user_id: widget.user_id,
      ),
      Statistics(
        user_id: widget.user_id,
      ),
      Budget(
        user_id: widget.user_id,
      ),
      Personal(
        user_id: widget.user_id,
      ),
    ];
    return Scaffold(
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => CategoryPage(
                    user_id: widget.user_id,
                  )));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Color.fromRGBO(255, 124, 100, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: index_color == 0
                      ? Color.fromRGBO(255, 124, 100, 1)
                      : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color: index_color == 1
                      ? Color.fromRGBO(255, 124, 100, 1)
                      : Colors.grey,
                ),
              ),
              SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 2;
                  });
                },
                child: Icon(
                  Icons.account_balance_wallet_outlined,
                  size: 30,
                  color: index_color == 2
                      ? Color.fromRGBO(255, 124, 100, 1)
                      : Colors.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 3;
                  });
                },
                child: Icon(
                  Icons.person_outlined,
                  size: 30,
                  color: index_color == 3
                      ? Color.fromRGBO(255, 124, 100, 1)
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
