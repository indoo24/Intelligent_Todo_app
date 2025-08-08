import 'package:flutter/material.dart';
import '../../models/task_model.dart';
import 'firebase_functions.dart';

class TasksProvider with ChangeNotifier {
  List<TaskModel> tasks = [];
  DateTime selectedDate = DateTime.now();

  Future<void> getTasksForSelectedDate(String userId) async {
    List<TaskModel> allTasks =
        await FirebaseFunctions.getAllTasksFromFirestore(userId);
    tasks = allTasks
        .where((task) =>
            task.date.day == selectedDate.day &&
            task.date.month == selectedDate.month &&
            task.date.year == selectedDate.year)
        .toList();
    notifyListeners();
  }

  void changeSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task, String userId) async {
    await FirebaseFunctions.addTaskToFirestore(task, userId);
    await getTasksForSelectedDate(userId); // محدثة بالفلترة الصحيحة
  }

  Future<void> deleteTask(String taskId, String userId) async {
    await FirebaseFunctions.deleteTaskFromFirestore(taskId, userId);
    await getTasksForSelectedDate(userId); // محدثة بالفلترة الصحيحة
  }
}
