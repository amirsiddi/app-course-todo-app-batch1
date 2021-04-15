import 'package:flutter/material.dart';
import "package:firebase_database/firebase_database.dart";
import 'package:fluttertodoappbatch1/main.dart';

class AddToDo extends StatefulWidget {
  @override
  _AddToDoState createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  var databaseReference = FirebaseDatabase.instance.reference();
  var textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add ToDo"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: textFieldController,
              ),
              ElevatedButton(
                  onPressed: () {
                    databaseReference.child("to-dos").push().set({
                      "textBody": textFieldController.text,
                      "isCompleted": false,
                    });

                    Navigator.pop(context);
                  },
                  child: Text("SUBMIT"))
            ],
          ),
        ),
      ),
    );
  }
}
