import 'package:flutter/material.dart';
import 'package:pra_frente_app/components/delete_confirmation_dialog.dart';
import 'package:pra_frente_app/db/activity_db_helper.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/models/db_datetime.dart';
import 'package:pra_frente_app/screens/activity_form.dart';

class ActivityView extends StatelessWidget {

  final List<Activity> activities;
  final Function onChange;

  const ActivityView({Key? key, required this.activities, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final Activity activity = activities[index];
            return Card(
              color: activity.doneToday ? Colors.green : Colors.red,
              child: ListTile(
                title: Text("${activity.name} ${activity.daysDone.length}"),
                onLongPress: () async {
                  var response = await showDialog(
                    context: context,
                    builder: (dialogContext) => DeleteConfirmationDialog(
                      title: "Delete activity",
                      description:
                          "This action cannot be undone, are you sure?",
                    ),
                  );
                  if (response is bool && response == true) {
                    ActivityDbHelper.instance.deleteActivity(activity.id!);
                  }
                  onChange();
                },
                onTap: () async {
                  await ActivityDbHelper.instance.toggleDate(
                    dbDatetime: DbDatetime(
                      date: DateTime.now(),
                      activityId: activity.id!,
                    ),
                  );
                  onChange();
                },
                trailing: InkWell(
                  child: GestureDetector(
                    child: Icon(Icons.edit),
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ActivityForm.editMode(
                            editActivity: activity,
                          ),
                        ),
                      );
                      onChange();
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }
}
