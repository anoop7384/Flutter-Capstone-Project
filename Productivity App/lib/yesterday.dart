import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'database.dart';

class Yesterday extends StatefulWidget {
  const Yesterday({Key? key}) : super(key: key);

  @override
  State<Yesterday> createState() => _YesterdayState();
}

class _YesterdayState extends State<Yesterday> {
  String? user = FirebaseAuth.instance.currentUser?.uid.toString();

  DateTime todayDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime yesterdayDate = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yesterday's Tasks"),
      ),
      body: Center(
          child: SizedBox(
              width: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  const Text("Incomplete",
                    style: TextStyle(
                      fontSize: 30,
                    ),),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(user)
                        .collection("tasks")
                        .where('dateCreated',
                            isGreaterThanOrEqualTo:
                                Timestamp.fromDate(yesterdayDate))
                        .where('dateCreated',
                            isLessThan: Timestamp.fromDate(todayDate))
                        .where('isComplete', isEqualTo: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;

                          return Align(
                              alignment: Alignment.centerRight,
                              child: Card(
                                color: Colors.blueAccent,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          children: [
                                            Text(data["title"],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),),
                                            Text(data["category"],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),),
                                          ],
                                        ),

                                      ],
                                    )),
                              ));
                        }).toList(),
                      );
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  const Text("Completed",
                    style: TextStyle(
                      fontSize: 30,
                    ),),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(user)
                        .collection("tasks")
                        .where('dateCreated',
                            isGreaterThanOrEqualTo:
                                Timestamp.fromDate(yesterdayDate))
                        .where('dateCreated',
                            isLessThan: Timestamp.fromDate(todayDate))
                        .where('isComplete', isEqualTo: true)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Loading");
                      }

                      return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: snapshot.data!.docs
                            .map((DocumentSnapshot document) {
                          Map<String, dynamic> data =
                              document.data()! as Map<String, dynamic>;

                          return Align(
                              alignment: Alignment.centerRight,
                              child: Card(
                                color: Colors.blueAccent,
                                child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          children: [
                                            Text(data["title"],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),),
                                            Text(data["category"],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),),
                                          ],
                                        ),
                                      ],
                                    )),
                              ));
                        }).toList(),
                      );
                    },
                  ),
                ],
              ))),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
