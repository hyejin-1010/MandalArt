import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/dialogs/edit_dialog.dart';
import 'package:madal_art/models/mandalart.dart';

class CategoryListScreen extends StatelessWidget {
  CategoryListScreen({Key? key}) : super(key: key);

  final DataController _dataController = Get.find<DataController>();

  Widget _buildItem(MandalArtModel mandalart) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(child: Text(mandalart.title)),
          IconButton(
            onPressed: () => _clickEditButton(mandalart),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _clickDeleteButton(mandalart.id),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('만다라트 리스트')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: Obx(() {
          Map<int, MandalArtModel> mandalartMap = _dataController.mandalart;
          final List<int> keys = mandalartMap.keys.toList();

          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(),
            itemCount: keys.length,
            itemBuilder: (BuildContext context, int index) {
              MandalArtModel mandalart = mandalartMap[keys[index]]!;
              return _buildItem(mandalart);
            },
          );
        }),
      ),
    );
  }

  void _clickEditButton(MandalArtModel mandalart) {
    Get.dialog(EditDialog(
      isItem: false,
      content: mandalart.title,
      done: (String title) {
        _dataController.updateMandalartTitle(mandalart.id, title);
        Get.back();
      },
    ));
  }

  void _clickDeleteButton(int id) {
  }
}
