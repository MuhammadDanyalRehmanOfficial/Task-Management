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
  late TextEditingController _emailController;

  final _formKey = GlobalKey<FormState>();
  String selectedStatus = 'Select Status';

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final userRole = arguments['userRole'];
    final taskID = arguments['taskId'];

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
          selectedStatus = task.status;
          _emailController.text = task.email;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextInputFiled(
                      ischeck: true,
                      controller: _titleController,
                      label: 'Title',
                      validator: (value) {
                        if (value == '') {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    TextInputFiled(
                      ischeck: false,
                      controller: _descriptionController,
                      label: 'Description',
                      validator: (value) {
                        if (value == '') {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          dropdownColor: Colors.amber,
                          isExpanded: true,
                          value: selectedStatus,
                          onChanged: (String? value) {
                            setState(() {
                              selectedStatus = value!;
                            });
                          },
                          items: [
                            DropdownMenuItem(
                              value: 'Select Status',
                              child: Text('Select Status'),
                            ),
                            DropdownMenuItem(
                              value: 'to do',
                              child: Text('To Do'),
                            ),
                            DropdownMenuItem(
                              value: 'in progress',
                              child: Text('In Progress'),
                            ),
                            DropdownMenuItem(
                              value: 'completed',
                              child: Text('Completed'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    TextInputFiled(
                      ischeck: true,
                      controller: _emailController,
                      label: 'Email',
                      validator: (value) {
                        if (value == '') {
                          return 'Please enter an email';
                        } else if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                            .hasMatch(value!)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.amber),
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
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
                          _updateTask(context, taskID, userRole);
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
                        }
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
            ),
          );
        },
      ),
    );
  }

  Future<void> _updateTask(
      BuildContext context, String taskID, String userRole) async {
    print(userRole);

    // Add logic to update the existing task using the provided data
    Task updatedTask = Task(
      title: _titleController.text,
      description: _descriptionController.text,
      status: selectedStatus,
      email: _emailController.text,
      id: taskID,
    );

    // Check the user's role and update fields accordingly
    if (userRole == 'Admin') {
      // Admin can edit all fields
      await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskID)
          .update(updatedTask.toMap());
    } else if (userRole == 'Manager') {
      // Manager can only edit description and status
      await FirebaseFirestore.instance.collection('tasks').doc(taskID).update({
        'description': updatedTask.description,
        'status': updatedTask.status,
      });
    }

    EmailSender emailsender = EmailSender();
    var response = await emailsender.sendMessage(
      updatedTask.email,
      'Task Update ${updatedTask.status}',
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
