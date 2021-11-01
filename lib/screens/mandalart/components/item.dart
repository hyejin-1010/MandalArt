import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/models/mandalart.dart';

class Item extends StatelessWidget {
  Item({
    Key? key,
    required this.group,
  }) : super(key: key);

  final int group;
  final DataController _dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: 9,
      itemBuilder: (BuildContext context, int index) {
        MandalArtModel? item = _dataController.data[group]?[index];
        String text = item?.content ?? '';
        bool isTop = item?.top ?? false;

        return Container(
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
        );
      },
    );
  }
}