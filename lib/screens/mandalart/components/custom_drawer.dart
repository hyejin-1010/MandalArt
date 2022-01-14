import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/screens/settings.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({ Key? key }) : super(key: key);

  Widget _buildSettingButton() {
    return InkWell(
      onTap: _goToSettingScreen,
      child: Container(
        width: Size.infinite.width,
        padding: EdgeInsets.symmetric(vertical: 15.0),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.settings),
            SizedBox(width: 15.0),
            Text(
              '설정',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            _buildSettingButton(),
          ],
        ),
      ),
    );
  }

  void _goToSettingScreen() {
    Get.to(SettingsScreen());
  }
}