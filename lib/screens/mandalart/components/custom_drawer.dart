import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/theme.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/controllers/setting_controller.dart';
import 'package:madal_art/dialogs/edit_dialog.dart';
import 'package:madal_art/models/mandalart.dart';
import 'package:madal_art/screens/category_list_screen.dart';
import 'package:madal_art/screens/settings.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({ Key? key }) : super(key: key);

  final DataController _dataController = Get.find<DataController>();
  final SettingController _settingController = Get.find<SettingController>();

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

  Widget _buildCategoryListView() {
    return Obx(() {
      Map<int, MandalArtModel> mandalart = _dataController.mandalart;
      List<int> keys = mandalart.keys.toList();
      int? selectedMandalartId = _dataController.mandalartId.value;
      double fontSize = _settingController.fontSize.value;

      return ListView.separated(
        separatorBuilder: (_, __) => Divider(),
        itemCount: keys.length,
        itemBuilder: (BuildContext context, int index) {
          int id = keys[index];
          bool selected = id == selectedMandalartId;
          return InkWell(
            onTap: () => _clickMandalartTitle(id),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
              child: Text(
                mandalart[id]!.title,
                style: TextStyle(
                  fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                  color: selected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondaryContainer,
                  fontSize: fontSize,
                ),
              ),
            ),
          );
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: 50.0),
            Container(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => Get.to(CategoryListScreen()),
                child: Text(
                  '설정',
                  style: TextStyle(fontSize: CommonTheme.small),
                ),
              ),
            ),
            Expanded(child: _buildCategoryListView()),
            InkWell(
              onTap: _clickAddMandalartButton,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 7.0),
                child: Text(
                  '+ 만다라트 추가하기',
                  style: TextStyle(
                    fontSize: CommonTheme.large,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            _buildSettingButton(),
          ],
        ),
      ),
    );
  }

  void _clickMandalartTitle(int id) {
    _dataController.changeMandalartId(id);
  }

  void _goToSettingScreen() {
    Get.to(SettingsScreen());
  }

  void _clickAddMandalartButton() {
    Get.dialog(EditDialog(
      isItem: false,
      content: '',
      done: (String title) {
        _addMandalart(title);
        Get.back();
      },
    ));
  }

  void _addMandalart(String title) async {
    try {
      await _dataController.createMandalArt(title);
    } catch (_) {}
  }
}