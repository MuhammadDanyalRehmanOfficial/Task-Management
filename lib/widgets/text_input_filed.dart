import 'package:flutter/material.dart';

class TextInputFiled extends StatelessWidget {
  const TextInputFiled({
    super.key,
    required this.controller,
    required this.label,
    required this.ischeck, this.validator,
  });

  final TextEditingController controller;
  final String label;
  final bool ischeck;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      readOnly: ischeck,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      validator: validator,
    );
  }
}
