import 'package:flutter/material.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/models/db_datetime.dart';

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
            child: Text("Add activity"),
            onPressed: () {
              final String activityName = _activityController.text;
              ActivityDbHelper.instance
                  .addActivity(Activity(name: activityName));
            },
          ),
          ElevatedButton(
            child: Text("Get all activities"),
            onPressed: () async {
              final List<Activity> allActivities =
                  await ActivityDbHelper.instance.getActivities();
              debugPrint(allActivities.toString());
            },
          ),
          ElevatedButton(
            child: Text("Get one activity"),
            onPressed: () async {
              final Activity activity =
                  await ActivityDbHelper.instance.getOneActivity(4);
              debugPrint(activity.toString());
            },
          ),
          ElevatedButton(
            child: Text("Delete one activity"),
            onPressed: () async {
              await ActivityDbHelper.instance.deleteActivity(1);
            },
          ),
          ElevatedButton(
            child: Text("add date"),
            onPressed: () async {
              int result = await ActivityDbHelper.instance.addDate(
                date: DbDatetime(
                  date: DateTime.fromMillisecondsSinceEpoch(1658109924000),
                  activityId: 1,
                ),
              );
              print(result);
            },
          ),
          ElevatedButton(
            child: Text("Get all dates"),
            onPressed: () async {
              final List<DbDatetime> allDates =
                  await ActivityDbHelper.instance.getAllDates();
              debugPrint(allDates.toString());
            },
          ),
        ],
      ),
    );
  }
}
