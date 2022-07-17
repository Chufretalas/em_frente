import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({Key? key}) : super(key: key);

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activities"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Text("1"),
          Text("2"),
          Text("3"),
          Text("4"),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          String path = await getDatabasesPath();
          debugPrint(path);
        },
      ),
    );
  }
}
