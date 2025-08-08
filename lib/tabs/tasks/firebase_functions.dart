import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_app/models/task_model.dart';
import '../../models/user_model.dart';

class FirebaseFunctions {
  static CollectionReference<UserModel> getUsersCollection() =>
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
            fromFirestore: (docSnapshot, _) =>
                UserModel.fromJson(docSnapshot.data()!),
            toFirestore: (userModel, _) => userModel.toJson(),
          );

  static CollectionReference<TaskModel> getTasksCollection(String userId) =>
      getUsersCollection()
          .doc(userId)
          .collection('tasks')
          .withConverter<TaskModel>(
            fromFirestore: (docSnapshot, _) =>
                TaskModel.fromJson(docSnapshot.data()!),
            toFirestore: (taskModel, _) => taskModel.toJson(),
          );

  static Future<void> addTaskToFirestore(TaskModel task, String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    DocumentReference<TaskModel> docRef = tasksCollection.doc();
    task.id = docRef.id;
    return docRef.set(task);
  }

  static Future<void> updateTaskInFirestore(
      TaskModel updatedTask, String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    DocumentReference<TaskModel> docRef = tasksCollection.doc(updatedTask.id);
    return docRef.update(updatedTask.toJson());
  }

  static Future<List<TaskModel>> getAllTasksFromFirestore(String userId) async {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    QuerySnapshot<TaskModel> querySnapshot = await tasksCollection.get();
    return querySnapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
  }

  static Future<void> deleteTaskFromFirestore(String taskId, String userId) {
    CollectionReference<TaskModel> tasksCollection = getTasksCollection(userId);
    return tasksCollection.doc(taskId).delete();
  }

  static Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credentials =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = UserModel(
      id: credentials.user!.uid,
      name: name,
      email: email,
    );
    final usersCollection = getUsersCollection();
    await usersCollection.doc(user.id).set(user);
    return user;
  }

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credentials = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final usersCollection = getUsersCollection();
    final docSnapshot = await usersCollection.doc(credentials.user!.uid).get();
    return docSnapshot.data()!;
  }

  static Future<void> logout() => FirebaseAuth.instance.signOut();

  static editTaskToFireStore(TaskModel task, String userId) {}
}
