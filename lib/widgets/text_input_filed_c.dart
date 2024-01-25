import 'package:flutter/material.dart';

class TextInputFiledC extends StatelessWidget {
  const TextInputFiledC({
    Key? key,
    required this.controller,
    required this.text,
    required this.hint,
    this.validator,
  }) : super(key: key);

  final TextEditingController controller;
  final String text;
  final String hint;
  final String? Function(String?)? validator;

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
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
          ),
          maxLines: null,
          keyboardType: TextInputType.multiline,
          validator: validator, // Keep this line unchanged
        ),
      ],
    );
  }
}
