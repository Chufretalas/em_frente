import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pra_frente_app/components/about_app_dialog.dart';
import 'package:pra_frente_app/components/delete_confirmation_dialog.dart';
import 'package:pra_frente_app/db/activity_db_helper.dart';
import 'package:pra_frente_app/debug/debug_appbar_action.dart';
import 'package:pra_frente_app/debug/debug_page.dart';
import 'package:pra_frente_app/models/activity.dart';
import 'package:pra_frente_app/models/db_datetime.dart';
import 'package:pra_frente_app/screens/activity_form.dart';
import 'package:pra_frente_app/screens/main_screen/activity_view.dart';
import 'package:pra_frente_app/screens/main_screen/calendar_view.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    ActivityView(),
    CalendarView(),
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
        title: Text("Em Frente!"),
        centerTitle: true,
        actions: [
          // DebugAppbarAction(),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: InkWell(
              child: Icon(Icons.info_outline),
              onTap: () => showDialog(
                context: context,
                builder: (dialogContext) => const AboutAppDialog(),
              ),
            ),
          )
        ],
      ),
      body: _screens.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt,
              color: Colors.cyanAccent,
            ),
            label: "Activities",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.calendar_today_outlined,
              color: Colors.cyanAccent,
            ),
            label: "Calendar",
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTapBottom,
      ),
    );
  }
}
