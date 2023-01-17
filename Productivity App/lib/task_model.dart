class Task {
  late String title;
  late String category;
  late DateTime dateCreated;
  late DateTime? dateCompleted;
  late bool isComplete;

  Task(
      {required this.title,
      required this.category,
      required this.dateCreated,
      required this.dateCompleted,
      required this.isComplete});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'dateCreated': dateCreated,
      'dateCompleted': dateCompleted,
      'isComplete': isComplete,
    };
  }
  Task.fromMap(Map<String, dynamic> map)
      : assert(map['title'] != null),
        assert(map['category'] != null),
        assert(map['dateCreated'] != null),
        title = map['title'],
        category = map['category'],
        isComplete = map['isComplete'];
}
