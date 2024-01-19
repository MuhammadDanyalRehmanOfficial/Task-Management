class Task {
  String id;
  String title;
  String description;
  String status;
  String email;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.email,
  });

  // Convert Task instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'status': status,
      'email': email,
    };
  }

  // Create a Task instance from a Map
  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'],
      description: map['description'],
      status: map['status'],
      email: map['email'],
    );
  }
}
