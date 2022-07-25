import 'dart:async';

import 'package:after_layout/after_layout.dart';
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

class _ActivityViewState extends State<ActivityView> with AfterLayoutMixin<ActivityView> {
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
            future: ActivityDbHelper.instance.getActivities(),
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
                            //TODO: Refactor this into it's own component and add pseudorandom colors
                            color:
                                activity.doneToday ? Colors.green : Colors.red,
                            child: ListTile(
                              //TODO: Add a date counter and an update name option
                              title: Text(activity.name),
                              onLongPress: () async {
                                //TODO: Add a delete feature
                                // await ActivityDbHelper.instance.delete(activity.id!);
                                // setState(() {});
                              },
                              onTap: () {
                                //TODO: add a "completed today" feature
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

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1000)); //TODO: there must be a better solution to this
    print("done");
    setState((){}); //This runs after the widget is build to make sure all activities done today are green
  }
}
