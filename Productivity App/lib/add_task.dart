import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:productivity_app/task_model.dart';

import 'database.dart';

class AddTask extends StatefulWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  final task_controller = TextEditingController();
  final cat_controller = TextEditingController();
  dynamic task;
  dynamic category;
  String? user = FirebaseAuth.instance.currentUser?.uid.toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: const Text("New Task"),
        ),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                title: TextField(
                  controller: task_controller,
                  style: const TextStyle(color: Colors.white),
                  minLines: 1,
                  maxLines: 5,
                  onChanged: (value) => task = value,
                  decoration: const InputDecoration(
                    labelText: "Task",
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
                tileColor: Colors.blue,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              const SizedBox(
                height: 15,
              ),
              ListTile(
                title: TextField(
                  controller: cat_controller,
                  style: const TextStyle(color: Colors.white),
                  minLines: 1,
                  maxLines: 5,
                  onChanged: (value) => category = value,
                  decoration: const InputDecoration(
                    labelText: "Category",
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
                tileColor: Colors.blue,
                textColor: Colors.white,

                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () => {
                  Database.addChat(
                    Task(
                      title: task.toString().trim(),
                      category: category.toString().trim(),
                      dateCreated: DateTime.now(),
                      dateCompleted: null,
                      isComplete: false,
                    ).toMap(),
                    user!,
                  ),
                  Navigator.pop(context),
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  minimumSize: const Size(350.0, 50.0),
                ),
                child: const Text("Add"),
              )
            ],
          ),
        )));
  }
}
