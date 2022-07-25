//Model for the dates stored in the database

import 'package:pra_frente_app/utils/zero_out_time.dart';

import '../db/activity_db_helper.dart';

class DbDatetime {
  final int? dateId;
  late final DateTime date;
  final int activityId;
  late final String uniqueKey; //unique key to check for same date and activity

  DbDatetime({this.dateId, required DateTime date, required this.activityId}) {
    DateTime zeroedDate = zeroOutTime(date);
    this.date = zeroedDate; // zeroes out the time, so it is easier to work with in the DB
    this.uniqueKey = "${zeroedDate.toIso8601String()} || ${this.activityId.toString()}";
  }

  Map<String, dynamic> toMap() {
    return {
      ActivityDbHelper.tableDId: dateId,
      ActivityDbHelper.tableDDate: date.toIso8601String(),
      ActivityDbHelper.tableDForeign: activityId,
      ActivityDbHelper.tableDUnique: uniqueKey,
    };
  }

  @override
  String toString() {
    return 'DbDatetime{dateId: $dateId, date: $date, activityId: $activityId}';
  }
}
