import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_caly_flutter/config/routes.dart';

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
        canvasColor: Colors.white
      ),
      initialRoute: '/calendar',
      getPages: routes,
    );
  }
}