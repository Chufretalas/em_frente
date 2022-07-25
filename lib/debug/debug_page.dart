import 'package:flutter/material.dart';
import 'package:pra_frente_app/debug/print_all_dates_by_activity.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/models/db_datetime.dart';

import '../db/activity_db_helper.dart';

class DebugPage extends StatelessWidget {
  DebugPage({Key? key}) : super(key: key);

  final TextEditingController _activityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Debug form"),
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
                  date: DateTime.now(),
                  activityId: 4,
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
          ElevatedButton(
            child: Text("Get all dates by activity"),
            onPressed: () async {
              printAllDatesByActivity(2);
            },
          ),
        ],
      ),
    );
  }
}
