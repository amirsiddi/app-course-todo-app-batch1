import 'package:flutter/material.dart';
import 'add_todo.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

const TODO_NODE = "to-dos";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MyApp();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Loading();
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("somethingh wrong with firebase initializatiopn"));
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var list = [1, 2, 3, 4, 5];
  List<toDoObject> toDoList = [];
  int _counter = 0;
  var databaseReference = FirebaseDatabase.instance.reference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _getDataFromFirebase();
    _getDataByChildAdded();

    print("toDoList inside initState: $toDoList");

    // toDoList.add(toDoObject(textBody: "task 1", isCompleted: false));
    // toDoList.add(toDoObject(textBody: "task 2", isCompleted: true));
    // toDoList.add(toDoObject(textBody: "task 3", isCompleted: false));
    // toDoList.add(toDoObject(textBody: "task 4", isCompleted: false));
    // toDoList.add(toDoObject(textBody: "task 5", isCompleted: true));
  }

  void _getDataByChildAdded() {
    databaseReference.child("to-dos").onChildAdded.listen((event) {
      //onChildAdded
      //onChildDeleted
      //onChildMoved
      //onChildChanged
      //onValue

      print("onChildAdded class");
      print(event.snapshot);
      print(event.snapshot.value);

      print(event.snapshot.value['textBody']);

      // var individualChildMap = event.snapshot.value as Map;
      // var textBodyVar = "";
      // bool isCompletedVar = false;
      //
      // individualChildMap.forEach((key, value) {
      //   print("key: $key");
      //   if (key == "textBody") {
      //     textBodyVar = value.toString();
      //   } else if (key == "isCompleted") {
      //     isCompletedVar = value;
      //   }
      // });

      //do validation

      toDoList.add(toDoObject(
          textBody: event.snapshot.value['textBody'],
          isCompleted: event.snapshot.value['isCompleted']));

      setState(() {});
    });
  }

  // void _getDataFromFirebase() {
  //   databaseReference.child(TODO_NODE).onChildAdded.listen((event) {
  //     print("to-Dos list: ");
  //     print(event.snapshot.value);
  //
  //     var map = event.snapshot.value as Map;
  //
  //     var textBody = "";
  //     bool isCompleted = false;
  //
  //     map.forEach((key, value) {
  //       print("key: $key");
  //       print("value: $value");
  //
  //       if (key == "textBody") {
  //         textBody = value;
  //       } else if (key == "isCompleted") {
  //         isCompleted = value;
  //       }
  //     }); //end of forEach
  //
  //     toDoList.add(toDoObject(textBody: textBody, isCompleted: isCompleted));
  //
  //     print("toDoList at end of onChildAdded: $toDoList");
  //
  //     setState(() {});
  //
  //     // toDoList.add(toDoObject(textBody: event.snapshot.value, isCompleted: ))
  //   }); //end of ref
  // }

  /*

  void _getDataOnValue() {
    databaseReference.child(TODO_NODE).onValue.listen((event) {
      print("onValue");
      print(event.snapshot.value);
      var value = event.snapshot.value;
      var map = value as Map;

      map.forEach((key, value) {});

      var values = value.values;

      var textBody = "";
      var isCompleted = false;

      for (final value in values) {
        var individualToDoMap = value as Map;
        individualToDoMap.forEach((key, value) {
          if (key == "textBody") {
            textBody = value.toString();
          } else if (key == "isCompleted") {
            isCompleted = isCompleted;
          }
        });
        toDoList.add(toDoObject(textBody: textBody, isCompleted: isCompleted));
        print("todoList inside onValue");
        toDoList.forEach((element) {
          element.textBody;
          print(element.textBody);
        });

        // print(toDoList[toDoList.length].textBody);
      }

      setState(() {});
    });
  }

   */

  void addButtonClicked() {
    setState(() {
      Navigator.push(
          context, new MaterialPageRoute(builder: (context) => AddToDo()));
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("TODO App"),
      ),
      body: ListView.builder(
          itemCount: toDoList.length,
          itemBuilder: (context, i) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(toDoList[i].textBody),
                    IconButton(
                        icon: toDoList[i].isCompleted
                            ? Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              )
                            : Icon(Icons.radio_button_unchecked),
                        onPressed: null)
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: addButtonClicked,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class toDoObject {
  String textBody;
  bool isCompleted;
//  DateTime time;
  toDoObject({this.textBody, this.isCompleted});
}
