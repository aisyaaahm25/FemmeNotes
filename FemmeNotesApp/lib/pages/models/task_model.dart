class TaskModel {
  final int? id;
  final String title;
  final String note;
  final String date;
  final String startTask;
  final String endTask;

  TaskModel({
    this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.startTask,
    required this.endTask,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      date: json['date'],
      startTask: json['start_task'],
      endTask: json['end_task'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'start_task': startTask,
      'end_task': endTask,
    };
  }
}
