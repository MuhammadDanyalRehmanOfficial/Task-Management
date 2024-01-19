import 'package:flutter/material.dart';
import 'package:email_sender/email_sender.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import '../widgets/app_bar_title.dart';
import '../widgets/text_input_filed.dart';

class EditTaskScreen extends StatefulWidget {
  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _statusController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _statusController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final taskID = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: const AppBarTitle(
          label: 'Edit Task',
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Task>(
        future: _fetchTaskData(taskID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Task not found'));
          }

          Task task = snapshot.data!;

          // Set the initial values of the controllers
          _titleController.text = task.title;
          _descriptionController.text = task.description;
          _statusController.text = task.status;
          _emailController.text = task.email;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextInputFiled(
                    controller: _titleController,
                    label: 'Title',
                  ),
                  TextInputFiled(
                    controller: _descriptionController,
                    label: 'Description',
                  ),
                  TextInputFiled(
                    controller: _statusController,
                    label: 'Status',
                  ),
                  TextInputFiled(
                    controller: _emailController,
                    label: 'Email',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.amber),
                    ),
                    onPressed: () {
                      // Show loading dialog while updating the task
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );
                      _updateTask(context, taskID);
                      // Dismiss the loading dialog
                      Navigator.pop(context);

                      // Show a Snackbar indicating the task creation success
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task updated successfully'),
                        ),
                      );

                      // Go back to the previous screen
                      Navigator.pop(context, true);
                    },
                    child: const Center(
                      child: Text(
                        "Update Task",
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateTask(BuildContext context, String taskID) async {
    // Add logic to update the existing task using the provided data
    Task updatedTask = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      status: _statusController.text,
      email: _emailController.text,
      id: taskID,
    );

    // Add logic to save the updated task to Firestore
    await FirebaseFirestore.instance
        .collection('tasks')
        .doc(taskID)
        .update(updatedTask.toMap());

    EmailSender emailsender = EmailSender();
    var response = await emailsender.sendMessage(
      updatedTask.email,
      'Task Update ${updatedTask.status}}',
      updatedTask.title,
      updatedTask.description,
    );
    if (response["message"] == "emailSendSuccess") {
      print(response);
    } else {
      print("something Failed");
      //for understanding the error
      print(response);
    }
  }

  Future<Task> _fetchTaskData(String taskID) async {
    // Retrieve task data from Firestore
    DocumentSnapshot taskSnapshot =
        await FirebaseFirestore.instance.collection('tasks').doc(taskID).get();

    if (taskSnapshot.exists) {
      return Task.fromMap(taskSnapshot.data() as Map<String, dynamic>, taskID);
    } else {
      throw Exception('Task not found');
    }
  }
}
