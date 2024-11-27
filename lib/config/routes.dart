import 'package:get/get.dart';
import 'package:my_caly_flutter/pages/calendar/detail_page.dart';
import 'package:my_caly_flutter/pages/check_interest/check_interest_page.dart';
import 'package:my_caly_flutter/pages/check_interest/check_major_page.dart';
import 'package:my_caly_flutter/pages/login/login_page.dart';
import 'package:my_caly_flutter/pages/calendar/calendar_page.dart';

final List<GetPage> routes = [
  GetPage(name: '/login', page: () => LoginPage(), transition: Transition.zoom),
  GetPage(name: '/calendar', page: () => const CalendarPage(), transition: Transition.fade),
  GetPage(name: '/check_major', page: () => CheckMajorPage(), transition: Transition.fade),
  GetPage(name: '/check_interest', page: () => CheckInterestPage(), transition: Transition.fade),
  GetPage(name: '/detail', page: () => DetailPage())
];