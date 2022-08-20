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

  DateTime _focusedDay = zeroOutTime(DateTime.now());
  DateTime _selectedDay = zeroOutTime(DateTime.now());
  late List<CompleteCalendarCard> _selectedActivities;

  //TODO: manage the two future builders when integration the two views

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text("calendario"),
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
                  _selectedActivities =
                      _getActivitiesByDay(_selectedDay, calendarActivites);

                  return Expanded(
                    child: Column(
                      children: [
                        TableCalendar(
                          calendarStyle: CalendarStyle(
                              markerDecoration: BoxDecoration(
                                  color: Colors.red, shape: BoxShape.circle)),
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) {
                            return isSameDay(_selectedDay, day);
                          },
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
                        ),
                        _selectedActivities.isNotEmpty
                            ? ListView.builder( //TODO: if the list is too big the scrolling breaks
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: _selectedActivities.length,
                                itemBuilder: (context, index) {
                                  return _selectedActivities[index];
                                },
                              )
                            : Center(
                                child: Text("Nothing was completed that day")),
                      ],
                    ),
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

  List<CompleteCalendarCard> _getActivitiesByDay(
      DateTime day, Map<DateTime, List<Activity>> data) {
    List<Activity> activities = data[zeroOutTime(day)] ?? [];
    return activities
        .map((activity) => CompleteCalendarCard(activity: activity))
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
    return dateToActivities;
  }
}
