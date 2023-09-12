import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:test/widgets/bottomNavigationBar.dart';
import 'package:test/constant.dart';
import 'package:test/pages/login/login.dart';

import 'pages/login/findPassword.dart';
import 'pages/login/register.dart';
import 'dart:ui';

// void main() => runApp(MyApp());
void main() {

    runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/register': (context) => const Register(),
        '/login': (context) => const Login(),
        '/findPassword': (context) => const findPassword(),
      },

      debugShowCheckedModeBanner: false,
      home: Login(),
      localizationsDelegates: const [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [
        //此处
        Locale('zh', 'CH'),
        Locale('en', 'US'),
      ],
      // theme: ThemeData(primarySwatch: materialColor),
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: Color.fromRGBO(255, 124, 100, 1), // 更改选择器文本和选定文本颜色
        ),
      ),
    );
  }
}
