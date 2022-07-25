import 'package:pra_frente_app/utils/zero_out_time.dart';

import '../db/activity_db_helper.dart';
import 'db_datetime.dart';

class Activity {
  int? id;
  String name;
  List<DbDatetime> daysDone = List.empty();
  bool doneToday = false;

  void setDoneToday() {
    if (daysDone
        .any((element) => element.date == zeroOutTime(DateTime.now()))) {
      doneToday = true;
    } else {
      doneToday = false;
    }
  }

  void _getDaysFromDb() async {
    daysDone = await ActivityDbHelper.instance.getAllDatesByActivity(id!);
    setDoneToday();
  }

  Activity({this.id, required this.name}) {
    if (id != null) {
      _getDaysFromDb();
    }
  }

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
