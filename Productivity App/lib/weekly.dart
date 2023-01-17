import 'dart:ffi';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/task_model.dart';

import 'database.dart';

class Weekly extends StatefulWidget {
  const Weekly({Key? key}) : super(key: key);

  @override
  State<Weekly> createState() => _WeeklyState();
}

class _WeeklyState extends State<Weekly> {
  // late List<Series<Task, String>> _seriesBarData;
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

  double mp = 0.0;
  double lp = 1000.0;
  var mpd = "";
  var lpd = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Weekly Analysis"),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user)
                      .collection("tasks")
                      .where('dateCreated',
                          isGreaterThanOrEqualTo: Timestamp.fromDate(date1))
                      .where('dateCreated',
                          isLessThan: Timestamp.fromDate(date0))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    var c = 0;
                    var i = 0;
                    var flag = "not Here";
                    List<String> category = [];
                    List<Task> tasks = snapshot.data!.docs
                        .map((DocumentSnapshot document) => Task.fromMap(
                            document.data()! as Map<String, dynamic>))
                        .toList();
                    tasks.forEach((task) {
                      if (task.isComplete) {
                        c++;
                      } else {
                        i++;
                      }
                    });
                    double percent;
                    if (c + i == 0) {
                      percent = 0;
                    } else {
                      percent = (c * 100) / (c + i);
                    }
                    if (percent > mp) {
                      mp = percent;
                      mpd = DateFormat('EEEE').format(date1).toString();
                    }
                    if (percent < lp) {
                      lp = percent;
                      lpd = DateFormat('EEEE').format(date1).toString();
                    }

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

                    return Align(
                        child: Card(
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${DateFormat('EEEE').format(date1)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                  Text(
                                    " Tasks completed : ${percent.toStringAsFixed(2)}% \n Total tasks : ${c + i} ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Column(
                                    children:
                                        List.generate(category.length, (index) {
                                      double percentage =
                                          cmap[category[index]]! *
                                              100 /
                                              (cmap[category[index]]! +
                                                  imap[category[index]]!);
                                      return Text(
                                        " ${percentage..toStringAsFixed(2)}% ${category[index]} tasks completed",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            )));
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user)
                      .collection("tasks")
                      .where('dateCreated',
                          isGreaterThanOrEqualTo: Timestamp.fromDate(date2))
                      .where('dateCreated',
                          isLessThan: Timestamp.fromDate(date1))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    var c = 0;
                    var i = 0;
                    var flag = "not Here";
                    List<String> category = [];
                    List<Task> tasks = snapshot.data!.docs
                        .map((DocumentSnapshot document) => Task.fromMap(
                            document.data()! as Map<String, dynamic>))
                        .toList();
                    tasks.forEach((task) {
                      if (task.isComplete) {
                        c++;
                      } else {
                        i++;
                      }
                    });
                    double percent;
                    if (c + i == 0) {
                      percent = 0;
                    } else {
                      percent = (c * 100) / (c + i);
                    }
                    if (percent > mp) {
                      mp = percent;
                      mpd = DateFormat('EEEE').format(date2).toString();
                    }
                    if (percent < lp) {
                      lp = percent;
                      lpd = DateFormat('EEEE').format(date2).toString();
                    }

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

                    return Align(
                        child: Card(
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${DateFormat('EEEE').format(date2)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                  Text(
                                    " Tasks completed : ${percent.toStringAsFixed(2)}% \n Total tasks : ${c + i} ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Column(
                                    children:
                                        List.generate(category.length, (index) {
                                      double percentage =
                                          cmap[category[index]]! *
                                              100 /
                                              (cmap[category[index]]! +
                                                  imap[category[index]]!);
                                      return Text(
                                        " ${percentage..toStringAsFixed(2)}% ${category[index]} tasks completed",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            )));
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user)
                      .collection("tasks")
                      .where('dateCreated',
                          isGreaterThanOrEqualTo: Timestamp.fromDate(date3))
                      .where('dateCreated',
                          isLessThan: Timestamp.fromDate(date2))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    var c = 0;
                    var i = 0;
                    var flag = "not Here";
                    List<String> category = [];
                    List<Task> tasks = snapshot.data!.docs
                        .map((DocumentSnapshot document) => Task.fromMap(
                            document.data()! as Map<String, dynamic>))
                        .toList();
                    tasks.forEach((task) {
                      if (task.isComplete) {
                        c++;
                      } else {
                        i++;
                      }
                    });
                    double percent;
                    if (c + i == 0) {
                      percent = 0;
                    } else {
                      percent = (c * 100) / (c + i);
                    }
                    if (percent > mp) {
                      mp = percent;
                      mpd = DateFormat('EEEE').format(date3).toString();
                      print("most");
                    }
                    if (percent < lp) {
                      lp = percent;
                      lpd = DateFormat('EEEE').format(date3).toString();
                    }

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

                    return Align(
                        child: Card(
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${DateFormat('EEEE').format(date3)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                  Text(
                                    " Tasks completed : ${percent.toStringAsFixed(2)}% \n Total tasks : ${c + i} ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Column(
                                    children:
                                        List.generate(category.length, (index) {
                                      double percentage =
                                          cmap[category[index]]! *
                                              100 /
                                              (cmap[category[index]]! +
                                                  imap[category[index]]!);
                                      return Text(
                                        " ${percentage..toStringAsFixed(2)}% ${category[index]} tasks completed",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            )));
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user)
                      .collection("tasks")
                      .where('dateCreated',
                          isGreaterThanOrEqualTo: Timestamp.fromDate(date4))
                      .where('dateCreated',
                          isLessThan: Timestamp.fromDate(date3))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    var c = 0;
                    var i = 0;
                    var flag = "not Here";
                    List<String> category = [];
                    List<Task> tasks = snapshot.data!.docs
                        .map((DocumentSnapshot document) => Task.fromMap(
                            document.data()! as Map<String, dynamic>))
                        .toList();
                    tasks.forEach((task) {
                      if (task.isComplete) {
                        c++;
                      } else {
                        i++;
                      }
                    });
                    double percent;
                    if (c + i == 0) {
                      percent = 0;
                    } else {
                      percent = (c * 100) / (c + i);
                    }
                    if (percent > mp) {
                      mp = percent;
                      mpd = DateFormat('EEEE').format(date4).toString();
                    }
                    if (percent < lp) {
                      lp = percent;
                      lpd = DateFormat('EEEE').format(date4).toString();
                    }

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

                    return Align(
                        child: Card(
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${DateFormat('EEEE').format(date4)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                  Text(
                                    " Tasks completed : ${percent.toStringAsFixed(2)}% \n Total tasks : ${c + i} ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Column(
                                    children:
                                        List.generate(category.length, (index) {
                                      double percentage =
                                          cmap[category[index]]! *
                                              100 /
                                              (cmap[category[index]]! +
                                                  imap[category[index]]!);
                                      return Text(
                                        " ${percentage..toStringAsFixed(2)}% ${category[index]} tasks completed",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            )));
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user)
                      .collection("tasks")
                      .where('dateCreated',
                          isGreaterThanOrEqualTo: Timestamp.fromDate(date5))
                      .where('dateCreated',
                          isLessThan: Timestamp.fromDate(date4))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    var c = 0;
                    var i = 0;
                    var flag = "not Here";
                    List<String> category = [];
                    List<Task> tasks = snapshot.data!.docs
                        .map((DocumentSnapshot document) => Task.fromMap(
                            document.data()! as Map<String, dynamic>))
                        .toList();
                    tasks.forEach((task) {
                      if (task.isComplete) {
                        c++;
                      } else {
                        i++;
                      }
                    });
                    double percent;
                    if (c + i == 0) {
                      percent = 0;
                    } else {
                      percent = (c * 100) / (c + i);
                    }
                    if (percent > mp) {
                      mp = percent;
                      mpd = DateFormat('EEEE').format(date5).toString();
                    }
                    if (percent < lp) {
                      lp = percent;
                      lpd = DateFormat('EEEE').format(date5).toString();
                    }

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

                    return Align(
                        child: Card(
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${DateFormat('EEEE').format(date5)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                  Text(
                                    " Tasks completed : ${percent.toStringAsFixed(2)}% \n Total tasks : ${c + i} ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Column(
                                    children:
                                        List.generate(category.length, (index) {
                                      double percentage =
                                          cmap[category[index]]! *
                                              100 /
                                              (cmap[category[index]]! +
                                                  imap[category[index]]!);
                                      return Text(
                                        " ${percentage..toStringAsFixed(2)}% ${category[index]} tasks completed",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            )));
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user)
                      .collection("tasks")
                      .where('dateCreated',
                          isGreaterThanOrEqualTo: Timestamp.fromDate(date6))
                      .where('dateCreated',
                          isLessThan: Timestamp.fromDate(date5))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    var c = 0;
                    var i = 0;
                    var flag = "not Here";
                    List<String> category = [];
                    List<Task> tasks = snapshot.data!.docs
                        .map((DocumentSnapshot document) => Task.fromMap(
                            document.data()! as Map<String, dynamic>))
                        .toList();
                    tasks.forEach((task) {
                      if (task.isComplete) {
                        c++;
                      } else {
                        i++;
                      }
                    });
                    double percent;
                    if (c + i == 0) {
                      percent = 0;
                    } else {
                      percent = (c * 100) / (c + i);
                    }
                    if (percent > mp) {
                      mp = percent;
                      mpd = DateFormat('EEEE').format(date6).toString();
                    }
                    if (percent < lp) {
                      lp = percent;
                      lpd = DateFormat('EEEE').format(date6).toString();
                    }

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

                    return Align(
                        child: Card(
                            color: Colors.blueAccent,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${DateFormat('EEEE').format(date6)}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 30,
                                    ),
                                  ),
                                  Text(
                                    " Tasks completed : ${percent.toStringAsFixed(2)}% \n Total tasks : ${c + i} ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Column(
                                    children:
                                        List.generate(category.length, (index) {
                                      double percentage =
                                          cmap[category[index]]! *
                                              100 /
                                              (cmap[category[index]]! +
                                                  imap[category[index]]!);
                                      return Text(
                                        " ${percentage..toStringAsFixed(2)}% ${category[index]} tasks completed",
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      );
                                    }),
                                  ),
                                ],
                              ),
                            )));
                  },
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(user)
                      .collection("tasks")
                      .where('dateCreated',
                          isGreaterThanOrEqualTo: Timestamp.fromDate(date7))
                      .where('dateCreated',
                          isLessThan: Timestamp.fromDate(date6))
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }
                    var c = 0;
                    var i = 0;
                    var flag = "not Here";
                    List<String> category = [];
                    List<Task> tasks = snapshot.data!.docs
                        .map((DocumentSnapshot document) => Task.fromMap(
                            document.data()! as Map<String, dynamic>))
                        .toList();
                    tasks.forEach((task) {
                      if (task.isComplete) {
                        c++;
                      } else {
                        i++;
                      }
                    });
                    double percent;
                    if (c + i == 0) {
                      percent = 0;
                    } else {
                      percent = (c * 100) / (c + i);
                    }
                    if (percent > mp) {
                      mp = percent;
                      mpd = DateFormat('EEEE').format(date7).toString();
                    }
                    if (percent < lp) {
                      lp = percent;
                      lpd = DateFormat('EEEE').format(date7).toString();
                    }

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

                    return Align(
                        child: Column(children: [
                      Card(
                          color: Colors.blueAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${DateFormat('EEEE').format(date7)}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                  ),
                                ),
                                Text(
                                  " Tasks completed : ${percent.toStringAsFixed(2)}% \n Total tasks : ${c + i} ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                                Column(
                                  children:
                                      List.generate(category.length, (index) {
                                    double percentage = cmap[category[index]]! *
                                        100 /
                                        (cmap[category[index]]! +
                                            imap[category[index]]!);
                                    return Text(
                                      " ${percentage..toStringAsFixed(2)}% ${category[index]} tasks completed",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          )),
                      Card(
                          color: Colors.blueAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Most productive on $mpd",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      Card(
                          color: Colors.blueAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Least productive on $lpd",
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 40,
                      )
                    ]));
                  },
                ),
              ],
            )));
  }
}
