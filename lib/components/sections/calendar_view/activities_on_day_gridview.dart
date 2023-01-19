import 'package:flutter/material.dart';

import 'package:pra_frente_app/models/activity.dart';

import '../../calendar_view_card.dart';

class ActivitiesOnDayGridView extends StatelessWidget {
  final List<Activity> selectedActivities;

  const ActivitiesOnDayGridView({Key? key, required this.selectedActivities})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: selectedActivities.isNotEmpty
          ? GridView.builder(
              padding:
                  const EdgeInsets.only(top: 8, bottom: 20, right: 8, left: 8),
              itemCount: selectedActivities.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 6 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemBuilder: (context, index) {
                return CalendarViewCard(activity: selectedActivities[index]);
              },
            )
          : const Center(child: Text("Nothing was completed that day")),
    );
  }
}
