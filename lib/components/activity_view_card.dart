import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pra_frente_app/components/blue_card.dart';
import 'package:pra_frente_app/extensions/datetime_extensions.dart';
import 'package:pra_frente_app/themes/theme_colors.dart';

import '../db/activity_db_helper.dart';
import '../models/activity.dart';
import '../models/db_datetime.dart';
import '../screens/activity_form.dart';
import '../utils/constants.dart';
import 'delete_confirmation_dialog.dart';

class ActivityViewCard extends StatefulWidget {
  final Activity activity;
  final Function refetchActivities;
  final bool isLast;

  const ActivityViewCard(
      {Key? key,
      required this.activity,
      required this.refetchActivities,
      this.isLast = false})
      : super(key: key);

  @override
  State<ActivityViewCard> createState() => _ActivityViewCardState();
}

class _ActivityViewCardState extends State<ActivityViewCard> {
  Future<void> _deleteActivity() async {
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
  }

  Future<void> _changeDoneState() async {
    await ActivityDbHelper.instance.toggleDate(
      dbDatetime: DbDatetime(
        date: DateTime.now(),
        activityId: widget.activity.id!,
      ),
    );
    await widget.activity.fetchTimesDoneThisMonth(month: DateTime.now().month);
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
  }

  Future<void> _goToEdit() async {
    String newName = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ActivityForm.editMode(
          editActivity: widget.activity,
        ),
      ),
    );
    setState(() {
      widget.activity.name = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
      child: Padding(
        padding:
            widget.isLast ? const EdgeInsets.only(bottom: 80) : EdgeInsets.zero,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onLongPress: _deleteActivity,
          onTap: _changeDoneState,
          child: BlueCard(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                widget.activity.doneToday
                    ? const Icon(
                        Icons.check_circle_sharp,
                        color: ThemeColors.green,
                        size: 28,
                      )
                    : const Icon(
                        Icons.cancel_sharp,
                        color: ThemeColors.red,
                        size: 28,
                      ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.activity.name,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Column(
                      children: [
                        const Text("Days completed"),
                        Text("Total: ${widget.activity.daysDone.length} -- "
                            "This month: ${widget.activity.timesDoneThisMonth}/${DateTime.now().lengthOfMonth()}"),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _goToEdit,
                  child: const Icon(
                    Icons.edit,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
