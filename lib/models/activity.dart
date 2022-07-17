import '../db/activity_db_helper.dart';

class Activity {
  int? id;
  String name;

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
