class Challenge {
  final String id;
  final String title;
  final String description;
  final int duration; // in days
  final bool isActive;
  final String? imageUrl;
  final List<String> tags;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.duration,
    required this.isActive,
    this.imageUrl,
    this.tags = const [],
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      duration: json['duration'] as int,
      isActive: json['isActive'] as bool,
      imageUrl: json['imageUrl'] as String?,
      tags: List<String>.from(json['tags'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'duration': duration,
      'isActive': isActive,
      'imageUrl': imageUrl,
      'tags': tags,
    };
  }
}

class UserChallengeProgress {
  final String id;
  final String challengeId;
  final String userId;
  final DateTime startDate;
  final int completedDays;
  final bool isCompleted;
  final DateTime? completedAt;

  UserChallengeProgress({
    required this.id,
    required this.challengeId,
    required this.userId,
    required this.startDate,
    required this.completedDays,
    required this.isCompleted,
    this.completedAt,
  });

  factory UserChallengeProgress.fromJson(Map<String, dynamic> json) {
    return UserChallengeProgress(
      id: json['id'] as String,
      challengeId: json['challengeId'] as String,
      userId: json['userId'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      completedDays: json['completedDays'] as int,
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] != null 
          ? DateTime.parse(json['completedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeId': challengeId,
      'userId': userId,
      'startDate': startDate.toIso8601String(),
      'completedDays': completedDays,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}
