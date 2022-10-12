import '../db/activity_db_helper.dart';
import '../models/activity.dart';

Future<List<Activity>> fetchActivitiesAndDates() async {
  List<Activity> actvivites =
      await ActivityDbHelper.instance.getAllActivities();
  for (Activity activity in actvivites) {
    activity.daysDone =
        await ActivityDbHelper.instance.getAllDatesByActivity(activity.id!);
    await activity.fetchTimesDoneThisMonth(month: DateTime.now().month);
    activity.setDoneToday();
  }
  return actvivites;
}
