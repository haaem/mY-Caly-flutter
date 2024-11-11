import 'dart:convert';
import 'package:my_caly_flutter/pages/calendar/event.dart';

class EventData {
  // JSON 데이터로부터 Event 목록을 생성
  static List<Event> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => Event.fromJson(json)).toList();
  }

  // Event 목록을 JSON 문자열로 변환
  static String toJsonList(List<Event> events) {
    final List<Map<String, dynamic>> jsonList = events.map((event) => event.toJson()).toList();
    return json.encode(jsonList);
  }
}
