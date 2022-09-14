import 'package:flutter/material.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/utils/fetch_activities_and_dates.dart';
import 'package:pra_frente_app/screens/main_screen/activity_list.dart';

import '../activity_form.dart';

class ActivityView extends StatefulWidget {
  const ActivityView({Key? key}) : super(key: key);

  @override
  State<ActivityView> createState() => _ActivityViewState();
}

class _ActivityViewState extends State<ActivityView> {
  List<Activity> _fetchedActivities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          FutureBuilder(
            future: fetchActivitiesAndDates(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                case ConnectionState.done:
                  _fetchedActivities = snapshot.data as List<Activity>;
                  return ActivityList(
                    activities: _fetchedActivities,
                    refetchActivities: () => setState(() {}),
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
}
