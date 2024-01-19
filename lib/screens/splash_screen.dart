import 'package:flutter/material.dart';
import 'dart:async';

import 'home_screen.dart'; // Import your main screen or initial screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate a loading time or perform some asynchronous tasks
    Timer(
      const Duration(seconds: 2), // Adjust the duration as needed
      () {
        // Navigate to the main screen after the splash screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(
              title: 'Task Management',
            ),
          ),
        );
      },
    );
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
