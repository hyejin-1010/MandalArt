import 'package:madal_art/models/item.dart';

class MandalArtModel {
  int id;
  String title;
  Map<int, Map<int, ItemModel>> items;
  int? no;

  MandalArtModel({
    required this.id,
    this.title = '',
    required this.items,
    this.no,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'no': id,
    };
  }
}
