import 'package:flutter/material.dart';
import 'package:pra_frente_app/utils/zero_out_time.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({Key? key}) : super(key: key);

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

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
      body: TableCalendar(
        calendarStyle: CalendarStyle(
            markerDecoration:
                BoxDecoration(color: Colors.red, shape: BoxShape.circle)),
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
          return _getActivitiesByDay(day);
        },
      ),
    );
  }

  List<Text> _getActivitiesByDay(DateTime day) {
    return _activitesExample[day] ?? [];
  }
}
