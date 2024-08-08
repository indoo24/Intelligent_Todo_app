import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:todo_app/home/firebase_utils.dart';
import 'package:todo_app/model/task.dart';

class ListProvider extends ChangeNotifier {
  String appLanguage = 'en';

  void changeLanguage(String newLanguage) {
    if (appLanguage == newLanguage) {
      return;
    }
    appLanguage = newLanguage;
  }

  static List<Task> tasksList = [];

  static void getAllTasksFromFireStore() async {
    QuerySnapshot<Task> querySnapshot =
        await FirebaseUtils.getTasksCollection().get();
    tasksList = querySnapshot.docs.map((doc) {
      return doc.data();
    }).toList();
  }

  notifyListeners();
}
