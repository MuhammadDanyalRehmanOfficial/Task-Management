import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Sign Up'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
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
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  hintText: 'example123',
                  label: Text('Password'),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(width: 2),
                  ),
                ),
                obscureText: true,
              ),
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
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, Routes.login);
                },
                child: Text(
                  'Login, An account already!',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.amber,
                  ),
                ),
              ),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                ),
                onPressed: () async {
                  String? result = await _authService.signUp(
                    _emailController.text,
                    _passwordController.text,
                    selectedRole,
                  );

                  if (result != null) {
                    // Successful signup
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                            child: Text('Signup successful. Role: $result')),
                      ),
                    );

                    // Navigate to the appropriate screen based on the role
                    if (result == Roles.admin) {
                      // You can perform admin-specific actions here if needed
                      Navigator.pushNamed(context, Routes.taskList,
                          arguments: Roles.admin);
                    } else if (result == Roles.manager) {
                      // You can perform manager-specific actions here if needed
                      Navigator.pushNamed(context, Routes.taskList,
                          arguments: Roles.manager);
                    } else if (result == Roles.user) {
                      // You can perform user-specific actions here if needed
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
                child: const Center(
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
    );
  }
}
