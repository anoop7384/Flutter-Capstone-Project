import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> addChat(Map<String, dynamic> task, String user) async {
    DocumentReference documentReferencer =
        _db.collection("users").doc(user).collection("tasks").doc();

    await documentReferencer
        .set(task);

  }

  static Future<void> deleteTask(String user, String documentId) async {
    DocumentReference documentReferencer =
        _db.collection("users").doc(user).collection("tasks").doc(documentId);

    await documentReferencer.delete();
  }

  static Future<void> updateTask(String user, String documentId) async {
    DocumentReference documentReferencer =
        _db.collection("users").doc(user).collection("tasks").doc(documentId);

    await documentReferencer
        .update({'isComplete': true, 'dateCompleted': DateTime.now()});
  }
}
