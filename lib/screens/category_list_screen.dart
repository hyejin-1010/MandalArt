import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:madal_art/controllers/data_controller.dart';
import 'package:madal_art/models/mandalart.dart';

class CategoryListScreen extends StatelessWidget {
  CategoryListScreen({Key? key}) : super(key: key);

  final DataController _dataController = Get.find<DataController>();

  @override
  Widget build(BuildContext context) {
    final List<int> keys = _dataController.mandalart.keys.toList();

    return Scaffold(
      appBar: AppBar(title: Text('만다라트 리스트')),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 25.0),
        child: ListView.separated(
          separatorBuilder: (_, __) => const Divider(),
          itemCount: _dataController.mandalart.keys.toList().length,
          itemBuilder: (BuildContext context, int index) {
            MandalArtModel mandalart = _dataController.mandalart[keys[index]]!;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                children: [
                  Expanded(child: Text(mandalart.title)),
                  IconButton(
                    onPressed: () => _clickEditButton(mandalart.id),
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => _clickDeleteButton(mandalart.id),
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _clickEditButton(int id) {
  }

  void _clickDeleteButton(int id) {
  }
}
