import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../firebase_utils.dart';
import '../model/task.dart';

class FireBaseProvider extends ChangeNotifier {
  List<Task> tasksList = [];
  var selectDate = DateTime.now();

  void getAllTasksFromFireStore(String uId) async {
    QuerySnapshot<Task> querySnapshot =
        await FirebaseUtils.getTasksCollection(uId).get();
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();

    tasksList = tasksList.where(
      (task) {
        if (selectDate.day == task.dateTime.day &&
            selectDate.month == task.dateTime.month &&
            selectDate.year == task.dateTime.year) {
          return true;
        }
        return false;
      },
    ).toList();

    tasksList.sort((Task task1, Task task2) {
      return task1.dateTime.compareTo(task2.dateTime);
    });

    notifyListeners();
  }

  void changeSelectDate(DateTime newSelectDate, String uId) {
    selectDate = newSelectDate;
    getAllTasksFromFireStore(uId);
    notifyListeners();
  }

  void removeTask(Task task) {
    tasksList.remove(task);
    notifyListeners();
  }

  Future<void> deleteTask(Task task, String uId) async {
    await FirebaseUtils.deleteTaskFromFireStore(task, uId);
    removeTask(task);
  }
}
