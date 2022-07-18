import 'package:flutter/material.dart';
import 'package:pra_frente_app/db/activity_db_helper.dart';
import 'package:pra_frente_app/exceptions/database_query_exception.dart';
import 'package:sqflite/sqflite.dart';

import '../models/activity.dart';

class ActivityForm extends StatefulWidget {
  ActivityForm({Key? key}) : super(key: key);

  @override
  State<ActivityForm> createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {
  final TextEditingController _activityController = TextEditingController();
  bool _errorVisibility = false;
  String _errorMessage = "An error has occured";

  void _hideError() {
    bool _errorVisibility = false;
    setState(() {});
  }

  void _showError({String errorMsg = "An error has occured"}) {
    _errorMessage = errorMsg;
    _errorVisibility = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New activity"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(controller: _activityController),
          Visibility(
              visible: _errorVisibility,
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.redAccent),
              )),
          ElevatedButton(
            child: Text("Add activity"),
            onPressed: () async {
              _hideError();
              if (_activityController.text.isNotEmpty) {
                try {
                  await ActivityDbHelper.instance
                      .addActivity(Activity(name: _activityController.text));
                  Navigator.of(context).pop();
                } catch (_) {
                  _showError(
                      errorMsg: "Error while trying to save the new activity");
                }
              } else {
                _showError(errorMsg: "The activity name cannot be empty");
              }
            },
          ),
        ],
      ),
    );
  }
}
