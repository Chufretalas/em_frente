import 'package:flutter/material.dart';

import '../db/activity_db_helper.dart';
import '../models/db_datetime.dart';

void printAllDatesByActivity(int activityId) async {
  final List<DbDatetime> allDates =
      await ActivityDbHelper.instance.getAllDatesByActivity(activityId);
  debugPrint(allDates.toString());
}
