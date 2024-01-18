import 'package:flutter/material.dart';
import 'package:taskmanager/utils/routes.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/task_item.dart';
import '../utils/roles.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late List<Task> _tasks;
  late List<String> allowedPermissions;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Function to fetch tasks
  void _loadTasks() {
    setState(() {
      _tasks = TaskService().getAllTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the user role argument passed to the widget
    final userRole = ModalRoute.of(context)!.settings.arguments as String;
    allowedPermissions = Roles.rolePermissions[userRole] ?? [];
    bool canAddTask = allowedPermissions.contains(Roles.create);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text(
          "Task List",
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: Text(
                userRole,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('About'),
              onTap: () {
                // Add logic for 'About' action
                Navigator.pop(context); // Close the drawer
                _showAboutDialog(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          return TaskItem(
            task: _tasks[index],
            onDelete: _handleDelete,
            onEditStatus: _handleEditStatus,
            userRole: userRole,
          );
        },
      ),
      floatingActionButton: canAddTask
          ? FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.createTask).then((result) {
                  if (result != null) {
                    _loadTasks(); // Reload tasks after creating a new task
                  }
                });
              },
              child: Icon(Icons.add),
              backgroundColor: Colors.amber,
            )
          : null,
    );
  }

  void _handleDelete(String taskId) {
    if (allowedPermissions.contains(Roles.delete)) {
      // Convert the taskId from String to int before calling deleteTask
      TaskService().deleteTask(int.parse(taskId));
      _loadTasks(); // Reload tasks after deleting a task
    }
  }

  void _handleEditStatus(String taskId) {
    if (allowedPermissions.contains(Roles.edit)) {
      // Perform edit operation
      Navigator.pushNamed(context, Routes.editTask, arguments: taskId)
          .then((result) {
        if (result != null && result == true) {
          _loadTasks(); // Reload tasks after editing a task
        }
      });
    }
  }

  // Function to show the 'About' dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('About Task Manager'),
          content: Text('Your about information goes here.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
