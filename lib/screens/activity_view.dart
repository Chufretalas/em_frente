import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pra_frente_app/db/activity_db_helper.dart';
import 'package:pra_frente_app/debug/print_all_dates_by_activity.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/screens/activity_form.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({Key? key}) : super(key: key);

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activities"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: _fetchActivitiesAndDates(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case ConnectionState.done:
                  List<Activity> activities = snapshot.data as List<Activity>;
                  return Expanded(
                    child: ListView.builder(
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final Activity activity = activities[index];
                          return Card(
                            color:
                                activity.doneToday ? Colors.green : Colors.red,
                            child: ListTile(
                              //TODO: Add an update name option
                              title: Text(
                                  "${activity.name} ${activity.daysDone.length}"),
                              onLongPress: () async {
                                //TODO: Add a delete feature with an alert dialog
                                // await ActivityDbHelper.instance.delete(activity.id!);
                                // setState(() {});
                              },
                              onTap: () {
                                //TODO: this has put on and remove todays date on each tap
                                printAllDatesByActivity(activity.id!);
                                print(activity.doneToday);
                              },
                            ),
                          );
                        }),
                  );
                default:
                  return const Center(
                    child: Text("Unknown error"),
                  );
              }
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ActivityForm(),
          ));
          setState(() {});
        },
      ),
    );
  }

  Future<List<Activity>> _fetchActivitiesAndDates() async {
    List<Activity> actvivites = await ActivityDbHelper.instance.getActivities();
    for(Activity activity in actvivites) {
      activity.daysDone = await ActivityDbHelper.instance.getAllDatesByActivity(activity.id!);
      activity.setDoneToday();
    }
    return actvivites;
  }
}
