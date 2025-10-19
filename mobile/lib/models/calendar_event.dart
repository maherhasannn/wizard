class CalendarEvent {
  final int id;
  final int userId;
  final String title;
  final String? description;
  final String type; // "MEDITATION", "GOAL", "REMINDER", "CUSTOM"
  final DateTime scheduledAt;
  final int? duration; // Duration in minutes
  final bool isCompleted;
  final DateTime? completedAt;
  final Map<String, dynamic>? recurrence;
  final int? notificationTime; // Minutes before event to notify
  final DateTime createdAt;
  final DateTime updatedAt;

  const CalendarEvent({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.type,
    required this.scheduledAt,
    this.duration,
    this.isCompleted = false,
    this.completedAt,
    this.recurrence,
    this.notificationTime,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CalendarEvent.fromJson(Map<String, dynamic> json) {
    return CalendarEvent(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: json['type'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      duration: json['duration'] as int?,
      isCompleted: json['isCompleted'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      recurrence: json['recurrence'] as Map<String, dynamic>?,
      notificationTime: json['notificationTime'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'type': type,
      'scheduledAt': scheduledAt.toIso8601String(),
      'duration': duration,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'recurrence': recurrence,
      'notificationTime': notificationTime,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  CalendarEvent copyWith({
    int? id,
    int? userId,
    String? title,
    String? description,
    String? type,
    DateTime? scheduledAt,
    int? duration,
    bool? isCompleted,
    DateTime? completedAt,
    Map<String, dynamic>? recurrence,
    int? notificationTime,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CalendarEvent(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      duration: duration ?? this.duration,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      recurrence: recurrence ?? this.recurrence,
      notificationTime: notificationTime ?? this.notificationTime,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
