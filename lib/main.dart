import 'package:flutter/material.dart';
import 'package:proxima_dose/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Próxima Dose',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(medications: []),
    );
  }
}
