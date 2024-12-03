import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_caly_flutter/config/routes.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      initialRoute: '/login',
      getPages: routes,
    );
  }
}