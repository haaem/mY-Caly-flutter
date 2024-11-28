class Event {
  final int id;
  final String title;
  final String major;
  final String link;
  final DateTime? endDate;
  final DateTime? startDate;
  final String category;
  final List<String> tags;
  final String content;
  final List<String> imageURL;

  Event({
    required this.startDate,
    required this.content,
    required this.tags,
    required this.link,
    required this.endDate,
    required this.title,
    required this.category,
    required this.id,
    required this.major,
    required this.imageURL
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    DateTime? endDate = json['endAt'] != null ? DateTime.parse(json['endAt']) : null;
    DateTime? startDate = json['startAt'] != null ? DateTime.parse(json['startAt']) : null;

    List<String> tags = [];
    if (json['tags'] is List && json['tags'].isNotEmpty && json['tags'][0] is List) {
      tags = List<String>.from(json['tags'][0]);
    }

    return Event(
      id: json['id'],
      title: json['title'] ?? '',
      major: json['college'] ?? '',
      link: json['link'] ?? '',
      endDate: endDate,
      startDate: startDate,
      category: json['type'] ?? '',
      tags: tags,
      content: json['contents'] ?? '',
      imageURL: List<String>.from(json['images']),
    );
  }
}