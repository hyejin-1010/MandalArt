import 'package:flutter/material.dart';

class CommonThemeData {
  static ThemeData? getThemeData(String key, String fontFamily) {
    Color? primaryColor;
    switch (key) {
      case 'amber':
        primaryColor = Colors.amber;
        break;
      case 'blue':
        primaryColor = Colors.blue;
        break;
      case 'red':
        primaryColor = Colors.red;
        break;
      case 'teal':
        primaryColor = Colors.teal;
        break;
      default: return null;
    }
    return ThemeData(
      fontFamily: fontFamily,
      primarySwatch: primaryColor as MaterialColor,
      backgroundColor: Colors.white,
      colorScheme: ThemeData.light().colorScheme.copyWith(
        primary: primaryColor,
        secondary: primaryColor,
        primaryContainer: primaryColor.withOpacity(0.7),
        secondaryContainer: Colors.black,
        brightness: Brightness.light,
      ),
    );
  }
}