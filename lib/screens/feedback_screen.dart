import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/feedback_service.dart';
import '../widgets/feedback_form.dart';

class FeedbackScreen extends StatelessWidget {
  final FeedbackService _feedbackService = FeedbackService();

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;

    String taskId = '';

    if (arguments != null) {
      if (arguments is String) {
        taskId = arguments;
      } else if (arguments is int) {
        taskId = arguments.toString();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Feedback',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Provide Feedback for Task:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Task ID: $taskId',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: _feedbackService.getFeedbackForTask(taskId),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data?.docs.length ?? 0,
                      itemBuilder: (context, index) {
                        var feedback = snapshot.data?.docs[index];

                        // Use the null coalescing operator to provide a default value if 'timestamp' is null
                        var timestamp = feedback?['timestamp'] as Timestamp? ??
                            Timestamp.now();

                        // Format the timestamp to display date and time
                        var formattedDateTime = DateFormat('yyyy-MM-dd HH:mm')
                            .format(timestamp.toDate());

                        int i = 1;

                        return ListTile(
                          leading: CircleAvatar(child: Text('${i++}')),
                          title: Text(feedback?['feedback'] ?? ''),
                          subtitle: Text(
                            'Submitted at: $formattedDateTime',
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            FeedbackForm(
              onSubmit: (feedback) {
                _feedbackService.submitFeedback(taskId, feedback);
              },
            ),
          ],
        ),
      ),
    );
  }
}
