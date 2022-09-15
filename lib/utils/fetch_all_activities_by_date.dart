import 'package:pra_frente_app/db/activity_db_helper.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/models/db_datetime.dart';

Future<Map<DateTime, List<Activity>>> fetchAllActivitiesByDate() async {
  List<DbDatetime> allDates = await ActivityDbHelper.instance.getAllDates();
  List<Activity> allActivities =
      await ActivityDbHelper.instance.getAllActivities();
  Set<DateTime> uniqueDates = allDates.map((e) => e.date).toSet();
  Map<DateTime, List<Activity>> dateToActivities = {};

  for (DateTime uniqueDate in uniqueDates) {
    List<int> activitiesIdsOnThatDate = allDates
        .where((dbDate) => dbDate.date == uniqueDate)
        .map((filteredDbDate) => filteredDbDate.activityId)
        .toList();

    List<Activity> activitiesOnThatDate = allActivities
        .where((activity) => activitiesIdsOnThatDate.contains(activity.id))
        .toList();

    dateToActivities.addAll({uniqueDate: activitiesOnThatDate});
  }
  return dateToActivities;
}
