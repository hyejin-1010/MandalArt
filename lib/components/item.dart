import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/common/theme.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/controllers/setting_controller.dart';
import 'package:madal_art/models/item.dart';

class Item extends StatelessWidget {
  Item({
    Key? key,
    required this.group,
    this.allView = false,
    this.onClick,
  }) : super(key: key);

  final bool allView;
  final int group;
  final DataController _dataController = Get.find<DataController>();
  final SettingController _settingController = Get.find<SettingController>();
  final Function(int)? onClick;

  Widget _buildMandalArtText(BuildContext context, bool isTop, String text) {
    double fontSize = _settingController.fontSize.value;
    if (allView) { fontSize = CommonTheme.small; }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondaryContainer,
        fontSize: fontSize,
        fontWeight: isTop ? FontWeight.bold : FontWeight.normal,
        overflow: TextOverflow.ellipsis,
      ),
      maxLines: allView ? 2 : 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1,
        ),
        itemCount: 9,
        itemBuilder: (BuildContext context, int index) {
          return Obx(() {
            ItemModel? item = _dataController.mandalart[0]?.items[group]?[index];
            String text = item?.content ?? '';
            bool isTop = item?.top ?? false;

            return GestureDetector(
              onTap: onClick != null ? () => onClick!(index) : null,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 1.0),
                  color: isTop ? Theme.of(context).colorScheme.primary : Theme.of(context).backgroundColor,
                ),
                child: Center(
                  child: _buildMandalArtText(context, isTop, text),
                ),
              ),
            );
          });
        },
      )
    );
  }
}