import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pra_frente_app/utils/constants.dart';

import '../models/activity.dart';

class CompleteCalendarCard extends StatelessWidget {

  Activity activity;

  CompleteCalendarCard({Key? key, required this.activity}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "CompleteCalendarCard: ${activity.name}";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(1000),
          color:
              BLUEISH_GREY_COLORS[Random().nextInt(BLUEISH_GREY_COLORS.length)],
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(5, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Text(
            activity.name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ));
  }
}
