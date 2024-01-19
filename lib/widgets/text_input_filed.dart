import 'package:flutter/material.dart';

class TextInputFiled extends StatelessWidget {
  const TextInputFiled({
    super.key,
    required this.controller, required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      maxLines: null,
      keyboardType: TextInputType.multiline,
    );
  }
}
