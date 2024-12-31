class NoteModel {
  final int? id;
  final String title;
  final String content;
  final String color;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  NoteModel({
    this.id,
    required this.title,
    required this.content,
    this.color = '0xFFFEB3C7',
    this.createdAt,
    this.updatedAt,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      color: json.containsKey('color') ? json['color'] : '0xFFFEB3C7',
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
