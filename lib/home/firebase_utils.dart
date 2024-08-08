import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/task.dart';

class FirebaseUtils {
  static CollectionReference<Task> getTasksCollection() {
    return FirebaseFirestore.instance
        .collection(Task.collectionName)
        .withConverter<Task>(
            fromFirestore: ((snapshot, options) =>
                Task.fromFireStore(snapshot.data()!)),
            toFirestore: (task, options) => task.toFireStore());
  }

  static Future<void> addTaskToFireStore(Task task) {
    var taskCollectin = getTasksCollection();
    DocumentReference<Task> taskDocRef = taskCollectin.doc();
    task.id = taskDocRef.id;
    return taskDocRef.set(task);
  }
}
