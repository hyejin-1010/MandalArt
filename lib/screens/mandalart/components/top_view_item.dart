import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/controllers/setting_controller.dart';

class TopViewItem extends StatelessWidget {
  TopViewItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final SettingController _settingController = Get.find<SettingController>();
  final DataController _dataController = Get.find<DataController>();
  final int index;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Obx(() {
        double fontSize = _settingController.fontSize.value;
        String text = _dataController.currentMandalart!.items[4]?[index]?.content ?? '';
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: fontSize + 3.0,
              fontWeight: index == 4 ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        );
      }),
    );
  }
}
