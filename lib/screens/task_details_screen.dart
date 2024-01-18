import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../utils/roles.dart';
import '../utils/routes.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({Key? key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final Task task = arguments['task'] as Task;
    final String userRole = arguments['userRole'] as String;
    final allowedPermissions = Roles.rolePermissions[userRole] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Task Details"),
        backgroundColor: Colors.amber,
        centerTitle: true,
        actions: [
          if (allowedPermissions.contains(Roles.edit))
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.editTask,
                  arguments: task.id.toString(),
                ).then((result) {
                  if (result != null && result == true) {
                    // Reload the task details after editing
                    setState(() {
                      Task updatedTask = TaskService().getTaskById(task.id);
                      task.title = updatedTask.title;
                      task.description = updatedTask.description;
                      task.status = updatedTask.status;
                    });
                  }
                });
              },
            ),
          if (allowedPermissions.contains(Roles.delete))
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _showDeleteConfirmationDialog(context, task);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    task.title,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    task.description,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Status:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    task.status,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        tooltip: 'Feedback',
        child: Icon(Icons.feedback),
        onPressed: () {
          Navigator.pushNamed(context, Routes.feedback, arguments: task.id);
        },
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, Task task) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Task'),
          content: Text('Are you sure you want to delete this task?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                TaskService().deleteTask(task.id);
                Navigator.of(context).pop(); // Pop once
                Navigator.of(context).pop(); // Pop again
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

@override
Widget build(BuildContext context) {
  // Extract the arguments map
  final Map<String, dynamic> arguments =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

  // Extract the task and userRole from the arguments
  final Task task = arguments['task'] as Task;
  final String userRole = arguments['userRole'] as String;

  // Access the user role argument passed to the widget
  final allowedPermissions = Roles.rolePermissions[userRole] ?? [];

  return Scaffold(
    appBar: AppBar(
      title: Text("Task Details"),
      backgroundColor: Colors.amber,
      centerTitle: true,
      actions: [
        if (allowedPermissions.contains(Roles.edit))
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              // Handle edit action
              // For example, navigate to the edit screen
              Navigator.pushNamed(
                context,
                Routes.editTask,
                arguments: task.id
                    .toString(), // Pass taskId instead of the entire task
              ).then((result) {
                if (result != null && result == true) {}
              });
            },
          ),
        if (allowedPermissions.contains(Roles.delete))
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Handle delete action
              // Show the delete confirmation dialog
              _showDeleteConfirmationDialog(context, task);
            },
          ),
      ],
    ),
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Title cc: ${task.title}",
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "Description: ${task.description}",
              style: TextStyle(fontSize: 24),
            ),
            Text(
              "Status: ${task.status}",
              style: TextStyle(fontSize: 24),
            ),
            // Add more details as needed
          ],
        ),
      ),
    ),
  );
}

Future<void> _showDeleteConfirmationDialog(
    BuildContext context, Task task) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Delete Task'),
        content: Text('Are you sure you want to delete this task?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Handle delete action
              // For example, call a function to delete the task
              TaskService().deleteTask(task.id);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}
