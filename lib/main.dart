import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_caly_flutter/pages/calendar/calendar_page.dart';
import 'package:my_caly_flutter/pages/login/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'mYCaly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const CalendarPage(),
    );
  }
}