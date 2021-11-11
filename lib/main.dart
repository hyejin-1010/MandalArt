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
  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    DataController dataController = Get.put(DataController());
    dataController.initialize();
    Get.put(SettingController());
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'NanumSquare',
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: MandalArtScreen(),
    );
  }
}