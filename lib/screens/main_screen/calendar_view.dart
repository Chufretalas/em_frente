import 'package:flutter/material.dart';
import 'package:pra_frente_app/components/complete_calendar_card.dart';
import 'package:pra_frente_app/utils/zero_out_time.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:pra_frente_app/models/activity.dart';

import 'package:pra_frente_app/utils/fetch_all_activities_by_date.dart';

import '../../utils/constants.dart';

class CalendarView extends StatefulWidget {
  //TODO: make this fetch less often, but it hasn't been a problem yet.
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
                              color: Colors.red, shape: BoxShape.circle),
                          selectedDecoration: BoxDecoration(
                              color: Colors.cyan, shape: BoxShape.circle),
                          cellMargin: EdgeInsets.all(2),
                        ),
                        rowHeight: 45,
                        weekendDays: List.empty(),
                        firstDay: DateTime.utc(2010, 10, 16),
                        calendarFormat: CalendarFormat.month,
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekendStyle: TextStyle(color: Colors.white),
                          weekdayStyle: TextStyle(color: Colors.white),
                        ),
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
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                          titleTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Divider(
                          indent: 16,
                          endIndent: 16,
                          thickness: 4,
                          color: Colors.cyanAccent,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Things completed in ${MONTH_NAMES[_selectedDay.month]} ${_selectedDay.day} of ${_selectedDay.year}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      Expanded(
                        child: _selectedActivities.isNotEmpty
                            ? GridView.builder(
                                padding: const EdgeInsets.only(
                                    top: 8, bottom: 20, right: 8, left: 8),
                                itemCount: _selectedActivities.length,
                                gridDelegate:
                                    const SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        childAspectRatio: 6 / 2,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemBuilder: (context, index) {
                                  return _selectedActivities[index];
                                },
                              )
                            : const Center(
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
