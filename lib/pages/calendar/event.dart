class Event {
  final DateTime date;
  final String title;
  final String category;

  Event({required this.date, required this.title, required this.category});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      date: DateTime.parse(json['date']),
      title: json['title'],
      category: json['category']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'title': title,
      'category': category,
    };
  }
}

// 임시 이벤트 데이터 (서버에서 받아올 데이터)
Map<DateTime, List<Event>> events = {
  DateTime(2024, 11, 10): [Event(date: DateTime(2024, 11, 10), title: "Meeting with team", category: 'orange')],
  DateTime(2024, 11, 11): [Event(date: DateTime(2024, 11, 11), title: "Doctor's appointment", category: 'pink')],
  DateTime(2024, 11, 12): [
    Event(date: DateTime(2024, 11, 12), title: "Lunch with friend", category: 'blue'),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: 'grey'),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: 'grey'),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: 'grey'),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: 'grey'),
  ],
};