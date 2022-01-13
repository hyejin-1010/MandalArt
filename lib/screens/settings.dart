import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/setting_controller.dart';
import 'package:madal_art/screens/settings/font_setting.dart';
import 'package:madal_art/screens/settings/font_size_setting.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({ Key? key }) : super(key: key);

  final SettingController _settingController = Get.find<SettingController>();

  final List<Map<String, String>> _settingFields = [
    { 'key': 'fontSize', 'text': '폰트 사이즈 변경' },
    { 'key': 'font', 'text': '폰트 변경' },
    { 'key': 'color', 'text': '메인 컬러 변경' },
  ];

  Widget _buildMenuItem(int index, double fontSize) {
    dynamic field = _settingFields[index];
    return InkWell(
      onTap: () => _clickMenu(field['key']),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Text(
          field['text'] ?? '',
          style: TextStyle(fontSize: fontSize),
        ),
      ),
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('설정')),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 15.0),
        child: Obx(() {
          double fontSize = _settingController.fontSize.value;
          return ListView.separated(
            separatorBuilder: (_, __) => Divider(),
            padding: EdgeInsets.zero,
            itemCount: _settingFields.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildMenuItem(index, fontSize);
            },
          );
        }),
      ),
    );
  }

  void _clickMenu(String key) {
    switch (key) {
      case 'fontSize':
        Get.to(() => FontSizeSetting());
        break;
      case 'font':
        Get.to(() => FontSettingScreen());
        break;
    }
  }
}