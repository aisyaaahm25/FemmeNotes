class Note {
  final String id;
  final String title;
  final String content;
  final String color;
  final String lastEdited;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.lastEdited,
  });

  // Tambahkan metode untuk menduplikasi catatan dengan pembaruan
  Note copyWith({
    String? id,
    String? title,
    String? content,
    String? color,
    String? lastEdited,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      color: color ?? this.color,
      lastEdited: lastEdited ?? this.lastEdited,
    );
  }
}
