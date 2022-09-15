import 'package:flutter/material.dart';
import 'package:pra_frente_app/components/complete_calendar_card.dart';
import 'package:pra_frente_app/utils/zero_out_time.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pra_frente_app/models/activity.dart';

import 'package:pra_frente_app/utils/fetch_all_activities_by_date.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = zeroOutTime(DateTime.now());
  DateTime _selectedDay = zeroOutTime(DateTime.now());
  late List<CompleteCalendarCard> _selectedActivities;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder(
          future: fetchAllActivitiesByDate(),
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
                        calendarStyle: const CalendarStyle(
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
                      Expanded(
                        child: _selectedActivities.isNotEmpty
                            ? ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: _selectedActivities.length,
                                itemBuilder: (context, index) {
                                  return _selectedActivities[index];
                                },
                              )
                            : Center(
                                child: Text("Nothing was completed that day")),
                      ),
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
    );
  }

  List<CompleteCalendarCard> _getActivitiesByDay(
    DateTime day,
    Map<DateTime, List<Activity>> activitiesOnEachDay,
  ) {
    List<Activity> activities = activitiesOnEachDay[zeroOutTime(day)] ?? [];
    return activities
        .map((activity) => CompleteCalendarCard(activity: activity))
        .toList();
  }


}
