import 'package:flutter/material.dart';

import '../db/activity_db_helper.dart';
import '../models/activity.dart';
import '../models/db_datetime.dart';
import '../screens/activity_form.dart';
import 'delete_confirmation_dialog.dart';

class ActivityViewCard extends StatefulWidget {
  final Activity activity;
  final Function refetchActivities;

  const ActivityViewCard(
      {Key? key, required this.activity, required this.refetchActivities})
      : super(key: key);

  @override
  State<ActivityViewCard> createState() => _ActivityViewCardState();
}

class _ActivityViewCardState extends State<ActivityViewCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.activity.doneToday ? Colors.green : Colors.red,
      child: ListTile(
        title:
            Text("${widget.activity.name} ${widget.activity.daysDone.length}"),
        onLongPress: () async {
          var response = await showDialog(
            context: context,
            builder: (dialogContext) => DeleteConfirmationDialog(
              title: "Delete activity",
              description: "This action cannot be undone, are you sure?",
            ),
          );
          if (response is bool && response == true) {
            ActivityDbHelper.instance.deleteActivity(widget.activity.id!);
          }
          widget.refetchActivities();
        },
        onTap: () async {
          await ActivityDbHelper.instance.toggleDate(
            dbDatetime: DbDatetime(
              date: DateTime.now(),
              activityId: widget.activity.id!,
            ),
          );
          setState(() {
            widget.activity.doneToday
                ? widget.activity.daysDone.removeLast()
                : widget.activity.daysDone.add(
                    DbDatetime(
                      date: DateTime.now(),
                      activityId: widget.activity.id!,
                    ),
                  );
            widget.activity.doneToday = !widget.activity.doneToday;
          });
        },
        trailing: InkWell(
          child: GestureDetector(
            child: const Icon(Icons.edit),
            onTap: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ActivityForm.editMode(
                    editActivity: widget.activity,
                  ),
                ),
              );
              widget.refetchActivities();
            },
          ),
        ),
      ),
    );
  }
}
