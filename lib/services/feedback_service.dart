import 'package:cloud_firestore/cloud_firestore.dart';

class FeedbackService {
  final CollectionReference feedbackCollection =
      FirebaseFirestore.instance.collection('feedback');

  Future<void> submitFeedback(String taskId, String feedback) async {
    await feedbackCollection.add({
      'taskId': taskId,
      'feedback': feedback,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getFeedbackForTask(String taskId) {
    return feedbackCollection
        .where('taskId', isEqualTo: taskId)
        .snapshots(includeMetadataChanges: true);
  }
}
