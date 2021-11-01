import 'package:get/get.dart';
import 'package:madal_art/models/mandalart.dart';

class DataController extends GetxController {
  List<MandalArtModel> list = [];
  Map<int, Map<int, MandalArtModel>> data = {};

  void initialize() {
    list = [];
    for (int i = 0; i < 9; i++) {
      for (int j = 0; j < 9; j++) {
        MandalArtModel item = MandalArtModel(group: i, index: j, content: j.toString());
        list.add(item);
        if (data[i] == null) { data[i] = {}; }
        data[i]![j] = item;
      }
    }
    update();
  }

  List<MandalArtModel> getMandalArtList(int group) {
    return list.where((item) => item.group == group).toList();
  }
}