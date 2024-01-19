import 'package:flutter/material.dart';
import 'package:taskmanager/widgets/app_bar_title.dart';
import '../models/task.dart';
import '../utils/roles.dart';
import '../utils/routes.dart';
import '../widgets/task_view.dart';

class TaskDetailsScreen extends StatefulWidget {
  const TaskDetailsScreen({Key? key});

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late Task task;
  late String userRole;
  late List<String> allowedPermissions;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    task = arguments['task'] as Task;
    userRole = arguments['userRole'] as String;
    allowedPermissions = Roles.rolePermissions[userRole] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(label: 'Task Details'),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TaskView(label: 'Title:', value: task.title),
              TaskView(label: 'Description:', value: task.description),
              TaskView(label: 'Status:', value: task.status),
              TaskView(label: 'E-Mail:', value: task.email),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        tooltip: 'Feedback',
        child: const Icon(Icons.feedback),
        onPressed: () {
          Navigator.pushNamed(context, Routes.feedback, arguments: task.id);
        },
      ),
    );
  }
}
