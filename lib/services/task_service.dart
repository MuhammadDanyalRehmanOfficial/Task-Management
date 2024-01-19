import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class TaskService {
  final CollectionReference _taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<List<Task>> getAllTasks() async {
    final querySnapshot = await _taskCollection.get();
    return querySnapshot.docs
        .map((doc) => Task.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<Task> getTaskById(String id) async {
    final docSnapshot = await _taskCollection.doc(id).get();
    return Task.fromMap(docSnapshot.data() as Map<String, dynamic>, id);
  }

  Future<void> addTask(Task task) async {
    await _taskCollection.add(task.toMap());
  }

  Future<void> updateTask(Task updatedTask) async {
    await _taskCollection.doc(updatedTask.id).update(updatedTask.toMap());
  }

  Future<void> updateTaskStatus(String taskId, String newStatus) async {
    await _taskCollection.doc(taskId).update({'status': newStatus});
  }

  Future<void> deleteTask(String taskId) async {
    await _taskCollection.doc(taskId).delete();
  }
}
