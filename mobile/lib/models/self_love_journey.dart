class SelfLoveJourneyDay {
  final int dayNumber;
  final String title;
  final String description;
  final String affirmation;
  final String activity;
  final String reflection;
  final String imagePath;
  final bool isCompleted;
  final DateTime? completedAt;

  SelfLoveJourneyDay({
    required this.dayNumber,
    required this.title,
    required this.description,
    required this.affirmation,
    required this.activity,
    required this.reflection,
    required this.imagePath,
    this.isCompleted = false,
    this.completedAt,
  });

  SelfLoveJourneyDay copyWith({
    int? dayNumber,
    String? title,
    String? description,
    String? affirmation,
    String? activity,
    String? reflection,
    String? imagePath,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return SelfLoveJourneyDay(
      dayNumber: dayNumber ?? this.dayNumber,
      title: title ?? this.title,
      description: description ?? this.description,
      affirmation: affirmation ?? this.affirmation,
      activity: activity ?? this.activity,
      reflection: reflection ?? this.reflection,
      imagePath: imagePath ?? this.imagePath,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  // JSON serialization methods
  Map<String, dynamic> toJson() {
    return {
      'dayNumber': dayNumber,
      'title': title,
      'description': description,
      'affirmation': affirmation,
      'activity': activity,
      'reflection': reflection,
      'imagePath': imagePath,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory SelfLoveJourneyDay.fromJson(Map<String, dynamic> json) {
    return SelfLoveJourneyDay(
      dayNumber: json['dayNumber'],
      title: json['title'],
      description: json['description'],
      affirmation: json['affirmation'],
      activity: json['activity'],
      reflection: json['reflection'],
      imagePath: json['imagePath'],
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }
}
