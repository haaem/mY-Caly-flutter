class Event {
  final DateTime date;
  final String title;

  Event({required this.date, required this.title});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      date: DateTime.parse(json['date']),
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'title': title,
    };
  }
}

// 임시 이벤트 데이터 (서버에서 받아올 데이터)
Map<DateTime, List<Event>> events = {
  DateTime(2024, 11, 10): [Event(date: DateTime(2024, 11, 10), title: "Meeting with team")],
  DateTime(2024, 11, 11): [Event(date: DateTime(2024, 11, 11), title: "Doctor's appointment")],
  DateTime(2024, 11, 12): [
    Event(date: DateTime(2024, 11, 12), title: "Lunch with friend"),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class"),
  ],
  // 추가적인 이벤트를 여기에 더할 수 있습니다.
};