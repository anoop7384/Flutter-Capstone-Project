import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/task_model.dart';
import 'package:charts_flutter/flutter.dart';

import 'database.dart';

class Charts extends StatefulWidget {
  const Charts({Key? key}) : super(key: key);

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  late List<Series<Task, String>> _seriesBarData;
  late List<Task> myData;

  String? user = FirebaseAuth.instance.currentUser?.uid.toString();

  DateTime todayDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  DateTime yesterdayDate = DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day - 1);



  _generateData(myData) {
    _seriesBarData.add(Series(
      domainFn: (Task tasks, _) => tasks.dateCreated.toString(),
      measureFn: (Task tasks, _) => int.parse(tasks.category),
      // colorFn: (Sales sales, _) =>
      //     charts.ColorUtil.fromDartColor(Color(int.parse(sales.colorVal))),
      id: 'Tasks',
      data: myData,
      // labelAccessorFn: (Sales row, _) => "${row.saleYear}",
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Today's Tasks"),
        ),
        body: Center(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .doc(user)
                .collection("tasks")
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text("Loading");
              }
              Map<String,int> cMap={};
              Map<String,int> iMap={};

              return Text("data");
            },
          ),
        ));
  }

  Widget _buildChart(BuildContext context, List<Task> tasksData) {
    myData = tasksData;
    _generateData(myData);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'Sales by Year',
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: BarChart(
                  _seriesBarData,
                  animate: true,
                  animationDuration: const Duration(seconds: 5),
                  behaviors: [
                    DatumLegend(
                      entryTextStyle: TextStyleSpec(
                          color: MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 18),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
