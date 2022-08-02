import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pra_frente_app/db/activity_db_helper.dart';
import 'package:pra_frente_app/debug/debug_page.dart';
import 'package:pra_frente_app/debug/print_all_dates_by_activity.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/models/db_datetime.dart';
import 'package:pra_frente_app/screens/activity_form.dart';
import 'package:pra_frente_app/components/delete_confirmation_dialog.dart';

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              child: Icon(Icons.bug_report),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => DebugPage()))
                  .then((value) => setState(() {})),
            ),
          )
        ],
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
                              //TODO: Add an update name action
                              title: Text(
                                  "${activity.name} ${activity.daysDone.length}"),
                              onLongPress: () async {
                                var response = await showDialog(
                                  context: context,
                                  builder: (dialogContext) =>
                                      DeleteConfirmationDialog(
                                    title: "Delete activity",
                                    description:
                                        "This action cannot be undone, are you sure?",
                                  ),
                                );
                                if (response is bool && response == true) {
                                  ActivityDbHelper.instance
                                      .deleteActivity(activity.id!);
                                }
                                setState(() {});
                              },
                              onTap: () async {
                                await ActivityDbHelper.instance.toggleDate(
                                  dbDatetime: DbDatetime(
                                    date: DateTime.now(),
                                    activityId: activity.id!,
                                  ),
                                );
                                setState((){});
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
    for (Activity activity in actvivites) {
      activity.daysDone =
          await ActivityDbHelper.instance.getAllDatesByActivity(activity.id!);
      activity.setDoneToday();
    }
    return actvivites;
  }
}
