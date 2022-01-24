import 'package:flutter/cupertino.dart';

class Functions {
  static double getMandalSize(Size size) {
    double mandalSize = size.width;
    if (mandalSize > size.height) {
      mandalSize = size.height;
    }
    return mandalSize - 20;
  }
}