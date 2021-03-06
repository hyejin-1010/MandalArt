import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
            onTap: () => _clickMandalart(id),
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

  Widget _buildSettingIconButton(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () => Get.to(() => SettingsScreen()),
        icon: Icon(Icons.settings),
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _createMandalartButton(BuildContext context) {
    return InkWell(
      onTap: _clickAddMandalartButton,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 7.0),
        child: Text(
          '+ ???????????? ????????????',
          style: TextStyle(
            fontSize: CommonTheme.large,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
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
            _buildSettingIconButton(context),
            SizedBox(height: 50.0),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              alignment: Alignment.topRight,
              child: InkWell(
                onTap: () => Get.to(CategoryListScreen()),
                child: Text(
                  '???????????? ??????',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(child: _buildCategoryListView()),
            _createMandalartButton(context),
          ],
        ),
      ),
    );
  }

  // ???????????? ??????????????? ???????????? ?????? ???,
  void _clickMandalart(int id) {
    _dataController.changeMandalartId(id);
  }

  // ???????????? ???????????? ?????? ?????? ???
  void _clickAddMandalartButton() {
    Get.dialog(EditDialog(
      isItem: false,
      content: '',
      done: _doneCreateMandalart,
    ));
  }

  // ???????????? ?????? Dialog ?????? ?????? ?????? ???
  void _doneCreateMandalart(String title) async {
    try {
      await _dataController.createMandalArt(title);
      Get.back();
    } catch (_) {
      Fluttertoast.showToast(msg: '???????????? ????????? ?????????????????????.\n?????? ??? ?????? ??????????????????.');
    }
  }
}