import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/controllers/setting_controller.dart';
import 'package:madal_art/screens/mandalart/mandalart.dart';
import 'package:madal_art/theme_data.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final SettingController _settingController = Get.put(SettingController());

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    Get.put(DataController());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      String fontFamily = _settingController.fontFamily.value;
      String mainColor = _settingController.mainColor.value;
      ThemeData? theme = CommonThemeData.getThemeData(mainColor, fontFamily);

      return GetMaterialApp(
        title: 'Flutter Demo',
        theme: theme,
        debugShowCheckedModeBanner: false,
        home: MandalArtScreen(),
      );
    });
  }
}