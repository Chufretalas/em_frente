import 'package:flutter/material.dart';
import 'package:pra_frente_app/db/activity_db_helper.dart';

import '../models/activity.dart';

class ActivityForm extends StatefulWidget {
  ActivityForm({Key? key}) : super(key: key);

  ActivityForm.editMode({Key? key, required this.editActivity})
      : super(key: key);

  Activity? editActivity;

  @override
  State<ActivityForm> createState() => _ActivityFormState(editActivity);
}

class _ActivityFormState extends State<ActivityForm> {
  String _appBarTitle = "New activity";
  final TextEditingController _activityController = TextEditingController();
  bool _errorVisibility = false;
  String _errorMessage = "An error has occured";
  String _saveErrorMessage = "Error while trying to save the new activity";

  Activity? editActivity;

  _ActivityFormState(this.editActivity) {
    //Set edit mode
    if (editActivity != null) {
      _appBarTitle = "Edit activity";
      _activityController.text = editActivity!.name;
      _saveErrorMessage = "Error while trying to save the changes";
    }
  }

  void _hideError() {
    _errorVisibility = false;
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
        title: Text(_appBarTitle),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 30.0, bottom: 12, right: 16, left: 16),
            child: TextField(
              controller: _activityController,
              decoration: InputDecoration(
                label: Text("New activity name"),
                hintText: "Type here...",
                errorText: _errorVisibility ? _errorMessage : null,
                errorStyle: TextStyle(fontSize: 16),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.cyan, width: 2),
                    borderRadius: BorderRadius.circular(16)),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.cyanAccent, width: 3),
                  borderRadius: BorderRadius.circular(15),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.redAccent, width: 3),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),
          ElevatedButton(
            child: const Text(
              "Confirm",
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () async {
              _hideError();
              if (_activityController.text.isNotEmpty) {
                try {
                  if (editActivity != null) {
                    editActivity!.name = _activityController.text;
                    await ActivityDbHelper.instance
                        .updateActivity(editActivity!);
                    Navigator.of(context).pop(editActivity!.name); // returns the new activity name if in edit mode
                  } else {
                    await ActivityDbHelper.instance
                        .addActivity(Activity(name: _activityController.text));
                    Navigator.of(context).pop();
                  }
                } catch (e) {
                  if (e.toString().contains("UNIQUE constraint failed")) {
                    _showError(errorMsg: "This activity already exists");
                  } else {
                    _showError(errorMsg: _saveErrorMessage);
                  }
                }
              } else {
                _showError(errorMsg: "The activity name cannot be empty");
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
