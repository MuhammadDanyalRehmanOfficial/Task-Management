import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackService {
  Stream getFeedbackEntriesForTask(String taskId) {
    return FirebaseFirestore.instance
        .collection('feedback')
        .doc('task_$taskId')
        .collection('feedback_entries')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> submitFeedback(String taskId, String feedback) async {
    var timestamp = Timestamp.now();

    await FirebaseFirestore.instance
        .collection('feedback')
        .doc('task_$taskId')
        .collection('feedback_entries')
        .add({
      'feedback': feedback,
      'timestamp': timestamp,
    });
  }
}
