import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/dialogs/edit_dialog.dart';
import 'package:madal_art/models/mandalart.dart';

class CategoryListScreen extends StatelessWidget {
  CategoryListScreen({Key? key}) : super(key: key);

  final DataController _dataController = Get.find<DataController>();

  Widget _buildItem(BuildContext context, MandalArtModel mandalart) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          Expanded(child: Text(mandalart.title)),
          IconButton(
            onPressed: () => _clickEditButton(mandalart),
            icon: Icon(
              Icons.edit,
              color: Theme.of(context).primaryColor,
            ),
          ),
          IconButton(
            onPressed: () => _clickDeleteButton(mandalart.id),
            icon: Icon(
              Icons.delete,
              color: Colors.red,
            ),
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
          Map<int, MandalArtModel> mandalart = _dataController.mandalart;
          final List<int> keys = mandalart.keys.toList();

          return ListView.separated(
            separatorBuilder: (_, __) => const Divider(),
            itemCount: keys.length,
            itemBuilder: (BuildContext context, int index) {
              MandalArtModel item = mandalart[keys[index]]!;
              return _buildItem(context, item);
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
    Get.defaultDialog(
      title: '삭제',
      content: Container(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        child: Text('정말 삭제하시겠습니까?'),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: Text('취소', style: TextStyle(color: Colors.grey)),
      ),
      confirm: TextButton(
        onPressed: () => _doDelete(id),
        child: Text('삭제', style: TextStyle(color: Colors.red)),
      ),
    );
  }

  void _doDelete(int id) {
    Get.back();
    _dataController.deleteMandalart(id);
  }
}
