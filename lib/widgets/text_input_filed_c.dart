import 'package:flutter/material.dart';

class TextInputFiledC extends StatelessWidget {
  const TextInputFiledC({
    super.key,
    required this.controller,
    required this.text,
    required this.hint,
  });

  final TextEditingController controller;
  final String text;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
        ),
      ],
    );
  }
}
