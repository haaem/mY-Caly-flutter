import 'package:get/get.dart';
import 'package:my_caly_flutter/pages/calendar/detail_page.dart';
import 'package:my_caly_flutter/pages/check_interest/check_interest_page.dart';
import 'package:my_caly_flutter/pages/check_interest/check_major_page.dart';
import 'package:my_caly_flutter/pages/login/login_page.dart';
import 'package:my_caly_flutter/pages/calendar/calendar_page.dart';
import 'package:my_caly_flutter/pages/login/signup_page.dart';

final List<GetPage> routes = [
  GetPage(name: '/login', page: () => LoginPage(), transition: Transition.zoom),
  GetPage(name: '/calendar', page: () => const CalendarPage(), transition: Transition.fade),
  GetPage(name: '/check_major', page: () => const CheckMajorPage(), transition: Transition.fade),
  GetPage(name: '/check_interest', page: () => const CheckInterestPage(), transition: Transition.fade),
  GetPage(name: '/detail', page: () => const DetailPage(), transition: Transition.fade),
  GetPage(name: '/signup', page: () => SignupPage(), transition: Transition.fade)
];