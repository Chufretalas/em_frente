import 'package:flutter/material.dart';
import 'package:pra_frente_app/components/sections/calendar_view/activities_on_day_gridview.dart';
import 'package:pra_frente_app/components/sections/calendar_view/the_calendar.dart';
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
  late List<Activity> _selectedActivities;
  late Map<DateTime, List<Activity>> calendarActivites;

  void onDaySelected(DateTime selectedDayOnClick, DateTime focusedDayOnClick) {
    setState(() {
      isSameDay(selectedDayOnClick, _selectedDay)
          ? _selectedDay = DateTime.now()
          : _selectedDay = selectedDayOnClick;
      _focusedDay = focusedDayOnClick;
    });
  }

  List<dynamic> eventLoader(DateTime day) =>
      _getActivitiesByDay(day, calendarActivites);

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
                calendarActivites =
                    snapshot.data as Map<DateTime, List<Activity>>;
                _selectedActivities =
                    _getActivitiesByDay(_selectedDay, calendarActivites);

                return Expanded(
                  child: Column(
                    children: [
                      TheCalendar(
                        focusedDay: _focusedDay,
                        selectedDay: _selectedDay,
                        onDaySelected: onDaySelected,
                        eventLoader: eventLoader,
                      ),
                       Padding(
                        padding: EdgeInsets.only(bottom: 4),
                        child: Divider(
                          indent: 16,
                          endIndent: 16,
                          thickness: 4,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          "Things completed in ${MONTH_NAMES[_selectedDay.month]} ${_selectedDay.day} of ${_selectedDay.year}",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                      ),
                      ActivitiesOnDayGridView(
                        selectedActivities: _selectedActivities,
                      )
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

  List<Activity> _getActivitiesByDay(
    DateTime day,
    Map<DateTime, List<Activity>> activitiesOnEachDay,
  ) {
    List<Activity> activities = activitiesOnEachDay[zeroOutTime(day)] ?? [];
    return activities;
  }
}
