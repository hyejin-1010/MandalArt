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

  Widget _buildMandalArtText(BuildContext context, int index, String text) {
    double fontSize = _settingController.fontSize.value;
    if (allView) { fontSize = CommonTheme.xxSmall; }

    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Theme.of(context).colorScheme.secondaryContainer,
        fontSize: fontSize,
        fontWeight: (index == 4 || group == 4) ? FontWeight.bold : FontWeight.normal,
        overflow: TextOverflow.ellipsis,
      ),
      maxLines: allView ? 2 : 3,
    );
  }

  Widget _buildItem(BuildContext context, int index, String text) {
    Color backgroundColor = Theme.of(context).backgroundColor;
    if (index == 4 || group == 4) {
      backgroundColor = Theme.of(context).colorScheme.primary;
      if (group != 4 || index != 4) {
        backgroundColor = backgroundColor.withOpacity(0.4);
      }
    }

    return Material(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          color: backgroundColor,
        ),
        child: Center(
          child: _buildMandalArtText(context, index, text),
        ),
      ),
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
            ItemModel? item = _dataController.mandalart[_dataController.mandalartId.value]?.items[group]?[index];
            String text = item?.content ?? '';
            bool? beforeAllView = Get.arguments?['allView'];

            return GestureDetector(
              onTap: onClick != null ? () => onClick!(index) : null,
              child: (index == 4 && beforeAllView == false) ? Hero(
                tag: 'mandal-item-$group-$index',
                child: _buildItem(context, index, text),
              ) : _buildItem(context, index, text),
            );
          });
        },
      )
    );
  }
}