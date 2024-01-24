import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  const AuthInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.isShow, required this.icon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final String hint;
  final bool isShow;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIconColor: Colors.amber,
        prefixIcon: Icon(icon),
        label: Text(label),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 2),
        ),
      ),
      obscureText: isShow,
    );
  }
}
