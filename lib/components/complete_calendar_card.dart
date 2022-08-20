import 'package:flutter/material.dart';

import '../models/activity.dart';

class CompleteCalendarCard extends StatelessWidget { //TODO: make this not look too ugly

  Activity activity;

  CompleteCalendarCard({Key? key, required this.activity}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "CompleteCalendarCard: ${activity.name}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      child: ListTile(
        title: Text(activity.name),
      ),
    );
  }
}
