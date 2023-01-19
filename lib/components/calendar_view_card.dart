import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pra_frente_app/components/blue_card.dart';
import 'package:pra_frente_app/utils/constants.dart';

import '../models/activity.dart';

class CalendarViewCard extends StatelessWidget {
  Activity activity;

  CalendarViewCard({Key? key, required this.activity}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "CompleteCalendarCard: ${activity.name}";
  }

  @override
  Widget build(BuildContext context) {
    return BlueCard(
        borderRadius: 1000,
        child: Center(
          child: Text(
            activity.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ));
  }
}
