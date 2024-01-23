import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:taskmanager/firebase_options.dart';
import 'package:taskmanager/screens/create_task_screen.dart';
import 'package:taskmanager/screens/edit_task_screen.dart';
import 'package:taskmanager/screens/feedback_screen.dart';
import 'package:taskmanager/screens/login_screen.dart';
import 'package:taskmanager/screens/signup_screen.dart';
import 'package:taskmanager/screens/splash_screen.dart';
import 'package:taskmanager/screens/task_details_screen.dart';
import 'package:taskmanager/screens/task_list_screen.dart';
import './utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      initialRoute: Routes.splash,
      routes: {
        Routes.splash: (context) => SplashScreen(),
        Routes.login: (context) => LoginScreen(),
        Routes.signup: (context) => SignUpScreen(),
        Routes.taskList: (context) => TaskListScreen(),
        Routes.taskDetails: (context) => TaskDetailsScreen(),
        Routes.editTask: (context) => EditTaskScreen(),
        Routes.createTask: (context) => CreateTaskScreen(),
        Routes.feedback: (context) => FeedbackScreen(),
        // Add other routes here
      },
    );
  }
}
