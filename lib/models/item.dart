class ItemModel {
  final int id;
  final int mandalArtId;
  final int group;
  final int index;
  String content;

  bool get top { return index == 4; }

  ItemModel({
    required this.id,
    required this.mandalArtId,
    required this.group,
    required this.index,
    this.content = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'mandalArtId': mandalArtId,
      'parent': group,
      'no': index,
      'content': content,
    };
  }

  factory ItemModel.fromJson(Map<String, dynamic> json) {
    return ItemModel(
      id: json['id'],
      mandalArtId: json['mandalArtId'],
      group: json['parent'],
      index: json['no'],
      content: json['content'],
    );
  }
}