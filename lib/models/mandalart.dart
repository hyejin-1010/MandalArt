class MandalArtModel {
  final int id;
  final int group;
  final int index;
  String content;

  bool get top { return index == 4; }

  MandalArtModel({
    required this.id,
    required this.group,
    required this.index,
    this.content = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'parent': group,
      'no': index,
      'content': content,
    };
  }

  factory MandalArtModel.fromJson(Map<String, dynamic> json) {
    return MandalArtModel(
      id: json['id'],
      group: json['parent'],
      index: json['no'],
      content: json['content'],
    );
  }
}