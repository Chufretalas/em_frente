import 'package:flutter/material.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/utils/fetch_activities_and_dates.dart';

import '../../components/activity_view_card.dart';
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
                  return _ActivityViewContent(
                    activities: _fetchedActivities,
                    refetchActivities: () {
                      print("deu refetch geral");
                      setState(() {});
                    },
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

class _ActivityViewContent extends StatelessWidget {
  final List<Activity> activities;
  final Function refetchActivities;

  const _ActivityViewContent(
      {Key? key, required this.activities, required this.refetchActivities})
      : super(key: key);

  Future<void> _onRefresh() async {
    refetchActivities();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: activities.isNotEmpty
          ? RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: activities.length,
                itemBuilder: (context, index) {
                  final Activity activity = activities[index];
                  return ActivityViewCard(
                    activity: activity,
                    refetchActivities: refetchActivities,
                    isLast: index == activities.length - 1,
                  );
                },
              ),
            )
          : const Center(
              child: Text("Click the + button to add new activities")),
    );
  }
}
