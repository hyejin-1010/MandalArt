class MandalArtModel {
  final int group;
  final int index;
  String content;

  bool get top { return index == 4; }

  MandalArtModel({
    required this.group,
    required this.index,
    this.content = '',
  });
}