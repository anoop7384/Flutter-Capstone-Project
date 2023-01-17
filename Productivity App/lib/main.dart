import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:productivity_app/add_task.dart';
import 'package:productivity_app/category.dart';
import 'package:productivity_app/charts.dart';
import 'package:productivity_app/database.dart';
import 'package:productivity_app/login.dart';
import 'package:productivity_app/weekly.dart';
import 'package:productivity_app/yesterday.dart';
import 'firebase_options.dart';
import 'dart:async';
import 'package:quoter/quoter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    String? user = FirebaseAuth.instance.currentUser?.uid.toString();
    if (user == null) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Splash1(),
      );
    } else {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Splash2(),
      );
    }
  }
}

class Splash1 extends StatefulWidget {
  const Splash1({Key? key}) : super(key: key);

  @override
  State<Splash1> createState() => _Splash1State();
}

class _Splash1State extends State<Splash1> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Image.asset(
                'assets/logo.png',
                width: 200,
                height: 200,
              ),
              Text(
                Quoter().getRandomQuote().quotation,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Splash2 extends StatefulWidget {
  const Splash2({Key? key}) : super(key: key);

  @override
  State<Splash2> createState() => _Splash2State();
}

class _Splash2State extends State<Splash2> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MyHomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              Image.asset(
                'assets/logo.png',
                width: 200,
                height: 200,
              ),
              Text(
                Quoter().getRandomQuote().quotation,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Quote extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getQuote(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? Center(
                  child: Text(
                  snapshot.data!,
                  textAlign: TextAlign.center,
                ))
              : Center(child: CircularProgressIndicator());
        });
  }
}

/// Quote kindly supplied by https://theysaidso.com/api/
Future<String> _getQuote() async {
  final res = await http.get('http://quotes.rest/qod.json' as Uri);
  return json.decode(res.body)['contents']['quotes'][0]['quote'];
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? user = FirebaseAuth.instance.currentUser?.uid.toString();

  DateTime todayDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime yesterdayDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Tasks"),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.all(30.0),
              child: SizedBox(
                  width: 300,
                  child: Column(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "To Do's",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(user)
                              .collection("tasks")
                              .where('dateCreated',
                                  isGreaterThanOrEqualTo:
                                      Timestamp.fromDate(todayDate))
                              .where('isComplete', isEqualTo: false)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    data["title"],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Text(data["category"],
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      )),
                                                ],
                                              ),
                                              ElevatedButton(
                                                  onPressed: () => {
                                                        Database.updateTask(
                                                            user!, document.id)
                                                      },
                                                  child: const Icon(
                                                      Icons.done_outline)),
                                              ElevatedButton(
                                                  onPressed: () => {
                                                        Database.deleteTask(
                                                            user!, document.id)
                                                      },
                                                  child: const Icon(
                                                      Icons.delete_outline))
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
                        Text(
                          "Completed",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("users")
                              .doc(user)
                              .collection("tasks")
                              .where('dateCreated',
                                  isGreaterThanOrEqualTo:
                                      Timestamp.fromDate(todayDate))
                              .where('isComplete', isEqualTo: true)
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text('Something went wrong');
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
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
                                                  Text(
                                                    data["title"],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                  Text(
                                                    data["category"],
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                  ),
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
                      ],
                    ),
                    Column(
                      children: [
                        ElevatedButton(
                            onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const Yesterday()),
                                  )
                                },
                            child: Text("Yesterday's Tasks")),
                        ElevatedButton(
                            onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Weekly()),
                                  )
                                },
                            child: Text("Weekly Analysis")),
                        ElevatedButton(
                            onPressed: () async {
                              await FirebaseAuth.instance.signOut();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()),
                              );
                            },
                            child: Text("Logout")),
                      ],
                    )
                  ])))),

      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddTask(),
              ))
        },
        tooltip: 'Add a task',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
