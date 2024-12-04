import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:my_caly_flutter/config/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp();
  await _initialization();

  runApp(const MyApp());
}

// void testNotification() {
//   // RemoteMessage와 유사한 객체 생성
//   String title = "Test Title";
//   String body = "This is a test notification.";
//
//   // 로컬 알림 표시
//   _showNotification(title, body);
// }

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future _initialization() async {
  await Future.delayed(const Duration(seconds: 2));
  await _requestNotificationPermission();
  FlutterNativeSplash.remove();

  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings =
  InitializationSettings(android: initializationSettingsAndroid);

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        if (response.payload == 'calendar') {
          Get.toNamed('/calendar');
        }
      }
    },
  );
}

Future<void> _requestNotificationPermission() async {
  if (Platform.isIOS) {
    await _requestIOSPermission();
  } else if (Platform.isAndroid) {
    if (await Permission.notification.isGranted) {
      // print("Notification permission granted on Android");
      await _setupFCMListeners();
    } else {
      PermissionStatus status = await Permission.notification.request();
      if (status.isGranted) {
        // print("Notification permission granted on Android");
        await _setupFCMListeners();
      } else {
        print("Notification permission denied on Android");
      }
    }
  }
}

Future<void> _requestIOSPermission() async {
  final permissionStatus = await Permission.notification.request();

  if (permissionStatus.isGranted) {
    print("iOS Notification permission granted");
    await _setupFCMListeners();
  } else {
    print("iOS Notification permission denied");
  }
}

Future<void> _setupFCMListeners() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Get FCM token
  String? token = await messaging.getToken();
  print("FCM Token: $token");

  if (token != null) {
    await SharedPreferences.getInstance().then((prefs) {
      prefs.setString('notificationToken', token);
    });
  }

  // foreground
  FirebaseMessaging.onMessage.listen((RemoteMessage? message) {
    if (message != null) {
      _showNotification(message);
    }
  });

  // background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? message) {
    if (message != null) {
      Get.toNamed('/calendar');
    }
  });

  // terminate
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      Get.toNamed('/calendar');
    }
  });
}

Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    "messages",
    'mY-CalY',
    channelDescription: '일정에 따른 알림을 제공합니다.',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  String? title = message.notification?.title ?? 'No Title';
  String? body = message.notification?.body ?? 'No Body';

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title,
    body,
    platformChannelSpecifics,
    payload: 'calendar',
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'mYCalY',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        canvasColor: Colors.white,
      ),
      initialRoute: '/login',
      getPages: routes,
    );
  }
}
