import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taskmanager/services/authentication_service.dart';
import '../models/task.dart';
import '../widgets/task_item.dart';
import '../utils/roles.dart';
import '../utils/routes.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  AuthenticationService _authenticationService = AuthenticationService();
  late List<Task> _tasks = [];
  late List<String> allowedPermissions;
  late CollectionReference _taskCollection;
  late String userRole; // Declare userRole at the class level

  @override
  void initState() {
    super.initState();
    _taskCollection = FirebaseFirestore.instance.collection('tasks');
    _loadTasks();
  }

  // Function to fetch tasks
  void _loadTasks() async {
    final querySnapshot = await _taskCollection.get();
    setState(() {
      _tasks = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Task.fromMap(data, doc.id);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Access the user role argument passed to the widget
    userRole = ModalRoute.of(context)!.settings.arguments as String;
    allowedPermissions = Roles.rolePermissions[userRole] ?? [];
    bool canAddTask = allowedPermissions.contains(Roles.create);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text(
          "Task List",
          style: TextStyle(
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
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              child: Center(
                child: Text(
                  userRole,
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.info,
                color: Colors.amber,
              ),
              title: const Text('About'),
              subtitle: const Text(
                'App name, version, and developer information',
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                // Add logic for 'About' action
                Navigator.pop(context); // Close the drawer
                _showAboutDialog(context);
              },
            ),
            canAddTask
                ? ListTile(
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.amber,
                    ),
                    title: const Text('Create Account'),
                    subtitle: const Text(
                      'Create new accounts',
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      // Add logic for 'Signup' action
                      Navigator.pushReplacementNamed(context, Routes.signup);
                    },
                  )
                : Container(),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: Colors.amber,
              ),
              title: const Text('Logout'),
              subtitle: const Text(
                'Logout the account',
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () async {
                // Add logic for 'Logout' action
                _authenticationService.signOut();
                final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
                sharedPreferences.remove('userRole');
                Navigator.pushReplacementNamed(context, Routes.login);
              },
            ),
          ],
        ),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text(
                'No tasks available.',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            )
          : ListView.builder(
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
              backgroundColor: Colors.amber,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _handleDelete(String taskId) async {
    if (allowedPermissions.contains(Roles.delete)) {
      await _taskCollection.doc(taskId).delete();
      _loadTasks(); // Reload tasks after deleting a task
    }
  }

  void _handleEditStatus(String taskId) {
    if (allowedPermissions.contains(Roles.edit)) {
      // Perform edit operation
      Navigator.pushNamed(
        context,
        Routes.editTask,
        arguments: {
          'taskId': taskId,
          'userRole': userRole, // Pass the userRole to the EditTaskScreen
        },
      ).then((result) {
        if (result != null && result == true) {
          _loadTasks(); // Reload tasks after editing a task
        }
      });
    }
  }

  // Function to show the 'About' dialog
  void _showAboutDialog(BuildContext context) {
    const appName = "Task Management";
    const appVersion = "1.0.0"; // Replace with your app version
    const developerName = "Muhammad Danyal Rehman";

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About'),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('App Name: $appName'),
              Text('Version: $appVersion'),
              Text('Developer: $developerName'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
