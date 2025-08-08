import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  String id;
  String title;
  String description;
  DateTime date;
  bool isDone = false;
  String? priority;

  TaskModel({
    this.id = '',
    required this.title,
    required this.description,
    required this.date,
    this.isDone = false,
    this.priority = 'Uncategorized',
  });

  TaskModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          date: (json['date'] as Timestamp).toDate(),
          isDone: json['isDone'],
          priority: json['priority'] ?? 'Uncategorized',
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': Timestamp.fromDate(date),
        'isDone': isDone,
        'priority': priority,
      };
}
