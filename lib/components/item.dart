import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/models/mandalart.dart';

class Item extends StatelessWidget {
  Item({
    Key? key,
    required this.group,
    this.onClick,
  }) : super(key: key);

  final int group;
  final DataController _dataController = Get.find<DataController>();
  final Function(int)? onClick;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
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
          MandalArtModel? item = _dataController.data[group]?[index];
          String text = item?.content ?? '';
          bool isTop = item?.top ?? false;

          return GestureDetector(
            onTap: onClick != null ? () => onClick!(index) : null,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1.0),
                color: isTop ? Colors.amber : Colors.white,
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: isTop ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        });
      },
    );
  }
}