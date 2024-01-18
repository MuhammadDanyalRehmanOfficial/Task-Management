import '../models/task.dart';

class TaskService {
  static List<Task> _tasks = [
    Task(
        title: "Practice Dart",
        description: 'Solve the exercises from the HackMD article',
        status: 'To Do',
        id: 0),
    Task(
        title: "Make a Rock-Paper-Scissors game",
        description: 'Use the dart:math library and the Random class',
        status: 'In Progress',
        id: 1),
    Task(
        title: "Create a palindrome checker",
        description:
            'Write a function that returns true if a string is a palindrome',
        status: 'Completed',
        id: 2),
  ];

  List<Task> getAllTasks() => _tasks;

  Task getTaskById(int id) => _tasks.firstWhere((task) => task.id == id);

  void addTask(Task task) => _tasks.add(task);

  void updateTask(Task updatedTask) {
    int index = _tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }
  }

  void updateTaskStatus(Task task, String newStatus) {
    task.status = newStatus;
  }

  void deleteTask(int id) {
    _tasks.removeWhere((task) => task.id == id);
  }
}
