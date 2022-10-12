import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pra_frente_app/extensions/datetime_extensions.dart';

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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16, top: 16),
      child: Padding(
        padding:
            widget.isLast ? const EdgeInsets.only(bottom: 80) : EdgeInsets.zero,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color:
              BLUEISH_GREY_COLORS[Random().nextInt(BLUEISH_GREY_COLORS.length)],
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.only(right: 14, left: 14, top: 8, bottom: 8),
              height: 80,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.activity.doneToday
                      ? const Icon(
                          Icons.check_circle_sharp,
                          color: Color.fromARGB(255, 108, 227, 81),
                          size: 28,
                        )
                      : const Icon(
                          Icons.cancel_sharp,
                          color: Color.fromARGB(255, 236, 74, 74),
                          size: 28,
                        ),
                  Container(
                    child: Column(
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
                  ),
                  InkWell(
                    child: GestureDetector(
                      child: const Icon(
                        Icons.edit,
                        size: 24,
                      ),
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
                ],
              ),
            ),
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
              await widget.activity
                  .fetchTimesDoneThisMonth(month: DateTime.august);
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
          ),
        ),
      ),
    );
  }
}
