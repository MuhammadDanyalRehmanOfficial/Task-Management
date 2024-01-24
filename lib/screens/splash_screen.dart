import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';


import '../utils/routes.dart';

String? Role;

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate a loading time or perform some asynchronous tasks
    getValidationData().whenComplete(() async {
      Timer(
        const Duration(seconds: 3), // Adjust the duration as needed
        () {
          // Navigate to the main screen after the splash screen
          Role == null
              ? Navigator.pushReplacementNamed(context, Routes.login)
              : Navigator.pushReplacementNamed(context, Routes.taskList,
                  arguments: Role);
        },
      );
    });
  }

  Future getValidationData() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var roles = sharedPreferences.getString('userRole');
    setState(() {
      Role = roles;
    });
    print(Role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icon.png',
              width: 100,
            ),
            SizedBox(height: 16),
            Text(
              'Task Management',
              style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
