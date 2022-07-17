import 'package:flutter/material.dart';
import 'package:pra_frente_app/models/activity.dart';

import '../db/activity_db_helper.dart';

class ActivityForm extends StatelessWidget {
  ActivityForm({Key? key}) : super(key: key);

  final TextEditingController _activityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New activity"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TextField(
            controller: _activityController,
          ),
          ElevatedButton(
            child: Text("Add"),
            onPressed: () {
              final String activityName = _activityController.text;
              ActivityDbHelper.instance
                  .addActivity(Activity(name: activityName));
            },
          ),
          ElevatedButton(
            child: Text("Get all"),
            onPressed: () async {
              final List<Activity> allActivities = await ActivityDbHelper.instance
                  .getActivities();
              debugPrint(allActivities.toString());
            },
          ),
        ],
      ),
    );
  }
}
