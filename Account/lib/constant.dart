import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test/pages/home.dart';
import 'package:test/pages/mine/setting.dart';

class MyColors {
  static const Color orange = Color.fromRGBO(255, 153, 102, 1);
  static const Color pink = Color.fromRGBO(255, 94, 98, 1);
  static const Color middleColor = Color.fromRGBO(255, 124, 100, 1); //渐变色中间的颜色
}

String IP = "101.132.132.98/file";

// $IP
bool flag1 = false;

double mySize10(double baseFontSize) {
  bool flag = flag1;

  double smallFontSize = baseFontSize - 2;
  baseFontSize += 2;

  return flag ? baseFontSize : smallFontSize;
}

void test() {
  print("flag1=");
  print(flag1);
}
