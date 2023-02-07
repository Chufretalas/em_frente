import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class TheCalendar extends StatelessWidget {
  DateTime focusedDay;
  DateTime selectedDay;
  final void Function(DateTime, DateTime) onDaySelected;
  final List<dynamic> Function(DateTime) eventLoader;

  TheCalendar(
      {Key? key,
      required this.focusedDay,
      required this.selectedDay,
      required this.onDaySelected,
      required this.eventLoader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            shape: BoxShape.circle),
        todayTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        markerDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            shape: BoxShape.circle),
        selectedDecoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle),
        selectedTextStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        cellMargin: const EdgeInsets.all(2),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekendStyle: TextStyle(color: Colors.white),
        weekdayStyle: TextStyle(color: Colors.white),
      ),
      rowHeight: 45,
      weekendDays: List.empty(),
      calendarFormat: CalendarFormat.month,
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2050, 12, 31),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) => isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      eventLoader: eventLoader,
    );
  }
}
