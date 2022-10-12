import 'package:pra_frente_app/utils/zero_out_time.dart';

import '../db/activity_db_helper.dart';
import 'db_datetime.dart';

class Activity {
  int? id;
  String name;
  List<DbDatetime> daysDone = List.empty();
  int timesDoneThisMonth = -1;
  bool doneToday = false;

  void setDoneToday() {
    if (daysDone
        .any((element) => element.date == zeroOutTime(DateTime.now()))) {
      doneToday = true;
    } else {
      doneToday = false;
    }
  }

  Future<void> fetchTimesDoneThisMonth({required int month}) async {
    int times = await ActivityDbHelper.instance
        .timesCompletedByMonth(activity: this, month: month);
    timesDoneThisMonth = times;
    return;
  }

  Activity({this.id, required this.name});

  @override
  String toString() {
    return 'Activity{id: $id, name: $name}';
  }

  Map<String, dynamic> toMap() {
    return {
      ActivityDbHelper.tableAId: id,
      ActivityDbHelper.tableAName: name,
    };
  }
}
