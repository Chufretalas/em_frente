import 'package:flutter/material.dart';
import 'package:pra_frente_app/components/delete_confirmation_dialog.dart';
import 'package:pra_frente_app/db/activity_db_helper.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/models/db_datetime.dart';
import 'package:pra_frente_app/screens/activity_form.dart';

import '../../components/activity_view_card.dart';

class ActivityList extends StatelessWidget {
  final List<Activity> activities;
  final Function refetchActivities;

  const ActivityList(
      {Key? key, required this.activities, required this.refetchActivities})
      : super(key: key);

  Future<void> _onRefresh() async {
    refetchActivities();
    return Future.delayed(Duration.zero);
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
          : const Center(child: Text("Click the + button to add new activities")),
    );
  }
}
