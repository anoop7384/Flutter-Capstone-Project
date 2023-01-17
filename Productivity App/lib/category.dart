import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/task_model.dart';
import 'package:charts_flutter/flutter.dart';

import 'database.dart';

class Category extends StatefulWidget {
  const Category({Key? key}) : super(key: key);

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  late List<Series<Task, String>> _seriesBarData;
  late List<Task> myData;

  String? user = FirebaseAuth.instance.currentUser?.uid.toString();

  DateTime date0 =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime date1 = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);
  DateTime date2 = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 2);
  DateTime date3 = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 3);
  DateTime date4 = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 4);
  DateTime date5 = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 5);
  DateTime date6 = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 6);
  DateTime date7 = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 7);

  List<String> category = [] ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Today's Tasks"),
        ),
        body: Center(
            child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user)
                  .collection("tasks")
                  .where('dateCreated',
                      isGreaterThanOrEqualTo: Timestamp.fromDate(date1))
                  .where('dateCreated', isLessThan: Timestamp.fromDate(date0))
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text("Loading");
                }
                List<Task> tasks = snapshot.data!.docs
                    .map((DocumentSnapshot document) =>
                        Task.fromMap(document.data()! as Map<String, dynamic>))
                    .toList();

                tasks.forEach((task) {
                  if (!category.contains(task.category)) {
                    category.add(task.category);
                  }
                });
                Map<String, int> cmap = {};
                Map<String, int> imap = {};
                category.forEach((element) {
                  cmap[element] = 0;
                  imap[element] = 0;
                });
                tasks.forEach((task) {
                  if (task.isComplete) {
                    cmap[task.category] = (cmap[task.category]! + 1);
                  } else {
                    imap[task.category] = (imap[task.category]! + 1);
                  }
                });

                return Column(
                  children: List.generate(category.length,(index){
                    double percentage = cmap[category[index]]!*100/(cmap[category[index]]!+imap[category[index]]!);
                    return Text("$percentage% ${category[index]} tasks completed");
                  }),
                );
              },
            ),
          ],
        )));
  }
}
