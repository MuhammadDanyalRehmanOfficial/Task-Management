import 'package:flutter/material.dart';

class AuthInput extends StatelessWidget {
  const AuthInput({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.isShow,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isShow;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        label: Text(label),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 2),
        ),
      ),
      obscureText: isShow,
    );
  }
}
