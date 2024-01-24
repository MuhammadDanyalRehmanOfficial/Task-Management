import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/authentication_service.dart';
import '../utils/roles.dart';
import '../utils/routes.dart';
import '../widgets/auth_input.dart';

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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
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
                AuthInput(
                    icon: Icons.email,
                    isShow: false,
                    label: 'Email',
                    hint: 'example@gmail.com',
                    controller: _emailController),
                SizedBox(
                  height: 10,
                ),
                AuthInput(
                    icon: Icons.lock,
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'example123',
                    isShow: true),
                SizedBox(
                  height: 10,
                ),
                // Login button
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
                  ),
                  onPressed: () async {
                    // Set a flag to indicate that the signup process is in progress
                    setState(() {
                      _isLoading = true;
                    });

                    String? result = await _authService.login(
                      _emailController.text,
                      _passwordController.text,
                    );

                    // Reset the loading flag
                    setState(() {
                      _isLoading = false;
                    });

                    if (result != null) {
                      // Successful login
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Center(
                              child: Text('Login successful. Role: $result')),
                        ),
                      );

                      final SharedPreferences sharedPreferences =
                          await SharedPreferences.getInstance();
                      sharedPreferences.setString('userRole', result);

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
                  child: _isLoading
                      ? Center(
                          child:
                              CircularProgressIndicator(), // Show loading indicator
                        )
                      : const Center(
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
      ),
    );
  }
}
