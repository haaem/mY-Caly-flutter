import 'package:get/get.dart';
import 'package:my_caly_flutter/pages/login/login_page.dart';
import 'package:my_caly_flutter/pages/calendar/calendar_page.dart';

final List<GetPage> routes = [
  GetPage(name: '/login', page: () => const LoginPage(), transition: Transition.zoom),
  GetPage(name: '/calendar', page: () => const CalendarPage(), transition: Transition.fade),
];