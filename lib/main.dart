import 'package:flutter/material.dart';
import 'package:pra_frente_app/screens/activity_form.dart';
import 'package:pra_frente_app/screens/activity_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pra Frente',
      theme: ThemeData.dark(),
      home: ActivityForm(),
    );
  }
}