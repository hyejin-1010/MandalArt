class TodoModel {
  int id;
  String content;
  bool isDone;
  final int parent;
  final int mandalArtId;

  TodoModel({
    required this.id,
    this.content = '',
    this.isDone = false,
    required this.parent,
    required this.mandalArtId,
  });

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'isDone': isDone,
      'parent': parent,
      'mandalArtId': mandalArtId,
    };
  }

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      isDone: json['isDone'] == 0 ? false : true,
      content: json['content'],
      parent: json['parent'],
      mandalArtId: json['mandalArtId'],
    );
  }
}