import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/controllers/setting_controller.dart';
import 'package:madal_art/screens/mandalart/mandalart.dart';

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

      return GetMaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: fontFamily,
          primarySwatch: Colors.blue,
        ),
        debugShowCheckedModeBanner: false,
        home: MandalArtScreen(),
      );
    });
  }
}