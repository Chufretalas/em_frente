import 'package:flutter/material.dart';
import 'package:pra_frente_app/debug/debug_page.dart';
import 'package:pra_frente_app/screens/main_screen/calendar_view.dart';
import 'package:pra_frente_app/screens/main_screen/main_screen.dart';
import 'package:pra_frente_app/themes/my_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Em Frente',
      theme: MyTheme,
      home: MainScreen(),
    );
  }
}