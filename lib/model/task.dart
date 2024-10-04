

class Task {
  static const String collectionName = 'tasks';
  String title;
  String desc;
  DateTime dateTime;
  bool isDone;
  String id;

  Task(
      {this.id = '',
      required this.title,
      required this.desc,
      required this.dateTime,
      this.isDone = false});

  Task.fromFireStore(Map<String, dynamic> data)
      : this(
            id: data['id'],
            title: data['title'],
            desc: data['desc'],
            dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
            isDone: data['isDone']);

  Map<String, Object?> toFireStore() {
    return {
      'title': title,
      'id': id,
      'desc': desc,
      'dateTime': dateTime!.millisecondsSinceEpoch,
      'isDone': isDone,
    };
  }
}
