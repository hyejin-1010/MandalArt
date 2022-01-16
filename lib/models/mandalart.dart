import 'package:madal_art/models/item.dart';

class MandalArtModel {
  final int id;
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
      'id': id,
      'title': title,
      'no': id,
    };
  }
}
