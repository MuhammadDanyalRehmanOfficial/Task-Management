import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class EditTaskScreen extends StatefulWidget {
  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _statusController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _statusController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    // task means taskid
    final taskID = ModalRoute.of(context)!.settings.arguments as String;
    Task task = TaskService().getTaskById(int.parse(taskID));

    // Set the initial values of the controllers
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _statusController.text = task.status;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Task",
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: "Description"),
                maxLines: null, // Allows multiple lines
                textInputAction:
                    TextInputAction.newline, // Enable "New Line" button
              ),
              TextField(
                controller: _statusController,
                decoration: InputDecoration(labelText: "Status"),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add logic to update the existing task using the provided data
                  Task updatedTask = Task(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    status: _statusController.text,
                    id: int.parse(taskID),
                  );

                  // Add logic to save the updated task, for example, using a TaskService
                  TaskService().updateTask(updatedTask);

                  Navigator.pop(
                      context, true); // Go back to the previous screen
                },
                child: Center(
                    child: Text(
                  "Update Task",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
