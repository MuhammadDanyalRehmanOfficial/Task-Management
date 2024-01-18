import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/task_service.dart';

class CreateTaskScreen extends StatefulWidget {
  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _statusController = TextEditingController();
  int _taskId = 3; // Initialize with the starting ID value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Create Task",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Title",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Enter title",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      hintText: "Enter description",
                    ),
                    maxLines: null, // Allow unlimited lines
                    keyboardType: TextInputType.multiline, // Enable multiline
                  ),
                ],
              ),
              SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _statusController,
                    decoration: InputDecoration(
                      hintText: "Enter status",
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add logic to create a new task using the provided data
                  Task newTask = Task(
                    title: _titleController.text,
                    description: _descriptionController.text,
                    status: _statusController.text,
                    id: _taskId, // Replace with a unique identifier logic
                  );
                  // Increment the task ID for the next task
                  _taskId++;
                  // Add logic to save the new task using a TaskService
                  TaskService().addTask(newTask);

                  Navigator.pop(
                      context, true); // Go back to the previous screen
                },
                child: Center(
                    child: Text(
                  "Create Task",
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
