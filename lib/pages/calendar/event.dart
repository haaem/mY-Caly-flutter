class Event {
  final DateTime date;
  final String title;
  final String category;
  final int id;

  Event({required this.date, required this.title, required this.category, required this.id});

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      date: DateTime.parse(json['date']),
      title: json['title'],
      category: json['category'],
      id: json['id']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'title': title,
      'category': category,
      'id': id
    };
  }
}

// 임시 이벤트 데이터 (서버에서 받아올 데이터)
Map<DateTime, List<Event>> events = {
  DateTime(2024, 11, 10): [Event(date: DateTime(2024, 11, 10), title: "Meeting with team", category: '대외활동', id: 1),],
  DateTime(2024, 11, 11): [Event(date: DateTime(2024, 11, 11), title: "Doctor's appointment", category: '동아리', id: 2)],
  DateTime(2024, 11, 12): [
    Event(date: DateTime(2024, 11, 12), title: "Lunch with friend", category: '인턴', id: 3),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: '채용', id: 4),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: '행사', id: 5),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: '대학원', id: 6),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: '장학금', id: 7),
  ],
  DateTime(2024, 11, 27): [
    Event(date: DateTime(2024, 11, 12), title: "Lunch with friend", category: '인턴', id: 8),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: '채용', id: 9),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: '행사', id: 10),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: '대학원', id: 11),
    Event(date: DateTime(2024, 11, 12), title: "Yoga class", category: '장학금', id: 12),
  ],
};