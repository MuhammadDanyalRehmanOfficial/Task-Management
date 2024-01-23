import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:taskmanager/widgets/app_bar_title.dart';

import '../services/authentication_service.dart';
import '../utils/roles.dart';
import '../utils/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

// Create an instance of the AuthenticationService
  final AuthenticationService _authService = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        elevation: 0,
        title: AppBarTitle(
          label: 'Login',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Welcome to\nTask Management',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'example@gmail.com',
                  label: Text('Email'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'example',
                  label: Text('Password'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(
                height: 10,
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.signup);
                },
                child: Text(
                  'Signup, Create a new account!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
              // Login button
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                ),
                onPressed: () async {
                  String? result = await _authService.login(
                    _emailController.text,
                    _passwordController.text,
                  );

                  if (result != null) {
                    // Successful login
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                            child: Text('Login successful. Role: $result')),
                      ),
                    );

                    // Now you can navigate to different screens based on the role
                    if (result == Roles.admin) {
                      // Navigate to admin screen
                      Navigator.pushNamed(
                        context,
                        Routes.taskList,
                        arguments: Roles.admin,
                      );
                    } else if (result == Roles.manager) {
                      // Navigate to manager screen
                      Navigator.pushNamed(
                        context,
                        Routes.taskList,
                        arguments: Roles.manager,
                      );
                    } else if (result == Roles.user) {
                      // Navigate to user screen
                      Navigator.pushNamed(
                        context,
                        Routes.taskList,
                        arguments: Roles.user,
                      );
                    }
                  } else {
                    // Login failed
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Login failed'),
                      ),
                    );
                  }
                },
                child: const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
