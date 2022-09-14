import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pra_frente_app/components/delete_confirmation_dialog.dart';
import 'package:pra_frente_app/db/activity_db_helper.dart';
import 'package:pra_frente_app/debug/debug_page.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/models/db_datetime.dart';
import 'package:pra_frente_app/screens/activity_form.dart';
import 'package:pra_frente_app/screens/main_screen/activity_list.dart';
import 'package:pra_frente_app/screens/main_screen/activity_view.dart';
import 'package:pra_frente_app/screens/main_screen/calendar_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screenOptions = const [
    ActivityView(),
    CalendarView()
  ];

  _onTapBottom(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Activities"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              child: Icon(Icons.bug_report),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => DebugPage()))
                  .then((value) => setState(() {})),
            ),
          )
        ],
      ),

      body: _screenOptions.elementAt(_selectedIndex),



      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: "Activities",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: "Calendar",
          )
        ],
        currentIndex: _selectedIndex,
        onTap: _onTapBottom,
      ),
    );
  }
}
