import 'package:flutter/material.dart';
import 'package:taskmanager/widgets/auth_input.dart';
import '../utils/roles.dart';
import '../utils/routes.dart';
import '../services/authentication_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  AuthenticationService _authService = AuthenticationService();

  String selectedRole = Roles.admin;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                AuthInput(icon: Icons.email,
                    controller: _emailController,
                    label: 'Email',
                    hint: 'example@gmail.com',
                    isShow: false),
                SizedBox(height: 10),
                AuthInput(icon: Icons.lock,
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'example123',
                    isShow: true),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: Colors.grey),
                  ),
                  child: ListTile(
                    title: Text('Select Role:'),
                    trailing: DropdownButton<String>(
                      value: selectedRole,
                      onChanged: (String? value) {
                        setState(() {
                          selectedRole = value!;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: Roles.admin,
                          child: Text('Admin'),
                        ),
                        DropdownMenuItem(
                          value: Roles.manager,
                          child: Text('Manager'),
                        ),
                        DropdownMenuItem(
                          value: Roles.user,
                          child: Text('User'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
                  ),
                  onPressed: () async {
                    // Set a flag to indicate that the signup process is in progress
                    setState(() {
                      _isLoading = true;
                    });

                    String? result = await _authService.signUp(
                      _emailController.text,
                      _passwordController.text,
                      selectedRole,
                    );

                    // Reset the loading flag
                    setState(() {
                      _isLoading = false;
                    });

                    if (result != null) {
                      // Successful signup
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(
                            child: Text('Signup successful. Role: $result'),
                          ),
                        ),
                      );

                      // Navigate to the appropriate screen based on the role
                      if (result == Roles.admin) {
                        Navigator.pushNamed(context, Routes.taskList,
                            arguments: Roles.admin);
                      } else if (result == Roles.manager) {
                        Navigator.pushNamed(context, Routes.taskList,
                            arguments: Roles.manager);
                      } else if (result == Roles.user) {
                        Navigator.pushNamed(context, Routes.taskList,
                            arguments: Roles.user);
                      }
                    } else {
                      // Signup failed
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Signup failed'),
                        ),
                      );
                    }
                  },
                  child: _isLoading
                      ? Center(
                          child:
                              CircularProgressIndicator(), // Show loading indicator
                        )
                      : const Center(
                          child: Text(
                            "Sign Up",
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
