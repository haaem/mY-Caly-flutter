import 'package:dio/dio.dart';
import 'package:my_caly_flutter/pages/calendar/event.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventData {
  static List<Event> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Event.fromJson(json)).toList();
  }

  Future<Map<DateTime, List<Event>>> fetchEventsFromServer() async {
    Map<DateTime, List<Event>> eventsByDate = {};
    final dio = Dio();

    // major, tags 가져오기
    List<String>? tags;
    String? major;
    await SharedPreferences.getInstance().then((prefs) {
      tags = prefs.getStringList('selectedTags');
      major = prefs.getString('selectedMajor');
    });

    // tags가 같을 때
    for (int i = 0; i < tags!.length; i++) {
      final response = await dio.request(
        'http://my-caly-cralwer.duckdns.org/api/v1/query/posts/',
        options: Options(method: 'GET'),
        queryParameters: {'tags': tags![i]},
      );

      if (response.statusCode == 200) {
        _processEvents(response.data, eventsByDate);
      } else {
        throw Exception('Failed to load events');
      }
    }

    // common 내용
    final responseCommon = await dio.request(
      'http://my-caly-cralwer.duckdns.org/api/v1/query/posts/',
      options: Options(method: 'GET'),
      queryParameters: {'college': 'common'},
    );

    if (responseCommon.statusCode == 200) {
      _processEvents(responseCommon.data, eventsByDate);
    } else {
      throw Exception('Failed to load events');
    }

    // major 내용
    final responseMajor = await dio.request(
      'http://my-caly-cralwer.duckdns.org/api/v1/query/posts/',
      options: Options(method: 'GET'),
      queryParameters: {'college': major},
    );

    if (responseMajor.statusCode == 200) {
      _processEvents(responseMajor.data, eventsByDate);
    } else {
      throw Exception('Failed to load events');
    }

    return eventsByDate;
  }

  void _processEvents(List<dynamic> eventData, Map<DateTime, List<Event>> eventsByDate) {
    List<Event> events = fromJsonList(eventData);

    for (var event in events) {
      DateTime? eventDate = event.endDate;
      if (eventDate == null) {
        continue;
      }

      DateTime date = DateTime(eventDate.year, eventDate.month, eventDate.day);

      if (eventsByDate[date] == null) {
        eventsByDate[date] = [];
      }

      if (!eventsByDate[date]!.any((existingEvent) => existingEvent.id == event.id)) {
        eventsByDate[date]!.add(event);
      }
    }
  }
}
