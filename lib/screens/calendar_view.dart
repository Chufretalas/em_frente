import 'package:flutter/material.dart';
import 'package:pra_frente_app/components/complete_calendar_card.dart';
import 'package:pra_frente_app/db/activity_db_helper.dart';
import 'package:pra_frente_app/models/db_datetime.dart';
import 'package:pra_frente_app/utils/zero_out_time.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/activity.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  //TODO: make a CompletedCalendarCard component

  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  //TODO: get the activites from the main screen and convert them to Map<DateTime, List<Activity>>
  Map<DateTime, List<Text>> _activitesExample = {
    zeroOutTime(DateTime.now()): [
      Text("oi"),
      Text("oi"),
      Text("oi"),
    ],
    DateTime.utc(2022, 8, 1): [
      Text("oi"),
      Text("oi"),
    ],
    DateTime.utc(2022, 8, 10): [
      Text("oi"),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text("debug"),
          onTap: () => _fetchAllActivitiesByDate(),
        ),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: _fetchAllActivitiesByDate(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                case ConnectionState.done:
                  Map<DateTime, List<Activity>> calendarActivites =
                      snapshot.data as Map<DateTime, List<Activity>>;
                  return TableCalendar(
                    calendarStyle: CalendarStyle(
                        markerDecoration: BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle)),
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    //TODO: onDaySelected should show a list of the activities completed that day below the calendar (CompletedCalendarCard)
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        isSameDay(selectedDay, _selectedDay)
                            ? _selectedDay = DateTime.now()
                            : _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    eventLoader: (day) {
                      return _getActivitiesByDay(day, calendarActivites);
                    },
                  );
                default:
                  return const Expanded(
                    child: Center(
                      child: Text("Unknown error"),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  List<CompleteCalenderCard> _getActivitiesByDay(
      DateTime day, Map<DateTime, List<Activity>> data) {
    List<Activity> activities = data[zeroOutTime(day)] ?? [];
    return activities
        .map((activity) => CompleteCalenderCard(activity: activity))
        .toList();
  }

  Future<Map<DateTime, List<Activity>>> _fetchAllActivitiesByDate() async {
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
    // print(dateToActivities);
    return dateToActivities;
  }
}
