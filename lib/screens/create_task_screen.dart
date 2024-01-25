import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';
import '../widgets/text_input_filed_c.dart';
import 'package:email_sender/email_sender.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final CollectionReference tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  String selectedStatus = 'Select Status';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create Task",
          style: TextStyle(
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextInputFiledC(
                  controller: _titleController,
                  text: 'Title',
                  hint: 'Enter title',
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextInputFiledC(
                  controller: _descriptionController,
                  text: 'Description',
                  hint: 'Enter description',
                  validator: (value) {
                    if (value == '') {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
                TextInputFiledC(
                  controller: _emailController,
                  text: 'Email',
                  hint: 'Enter email',
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
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      // Show loading dialog while creating the task
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        },
                      );

                      // Add logic to create a new task using the provided data
                      Task newTask = Task(
                        title: _titleController.text,
                        description: _descriptionController.text,
                        status: selectedStatus,
                        email: _emailController.text,
                        id: '', // leave empty to be assigned by Firestore
                      );

                      // Add logic to save the new task using Firestore
                      DocumentReference docRef = await tasksCollection.add({
                        'title': newTask.title,
                        'description': newTask.description,
                        'status': newTask.status,
                        'email': newTask.email,
                      });

                      // Update the task ID with the assigned document ID
                      newTask.id = docRef.id;

                      // Update the task in Firestore with the assigned ID
                      docRef.update({'id': newTask.id});

                      // Create an email object with the required fields
                      EmailSender emailsender = EmailSender();
                      var response = await emailsender.sendMessage(
                        newTask.email,
                        'Task Created ${newTask.status}',
                        newTask.title,
                        newTask.description,
                      );
                      if (response["message"] == "emailSendSuccess") {
                        print(response);
                      } else {
                        print("something Failed");
                        //for understanding the error
                        print(response);
                      }

                      // Show a Snackbar indicating the task creation success
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Task created successfully'),
                        ),
                      );

                      // Go back to the previous screen
                      Navigator.pop(context);
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Center(
                    child: Text(
                      "Create Task",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
