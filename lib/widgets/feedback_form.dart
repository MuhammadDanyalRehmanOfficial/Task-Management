import 'package:flutter/material.dart';

class FeedbackForm extends StatefulWidget {
  final Function(String) onSubmit;

  FeedbackForm({required this.onSubmit});

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: _feedbackController,
          decoration: InputDecoration(labelText: 'Feedback'),
          maxLines: null,
          keyboardType: TextInputType.multiline,
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            widget.onSubmit(_feedbackController.text);
            _feedbackController.clear();
          },
          child: Text('Submit Feedback'),
        ),
      ],
    );
  }
}
