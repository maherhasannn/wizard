enum ChallengeStatus {
  notStarted,
  active,
  paused,
  completed,
}

enum RitualType {
  text,
  audio,
  video,
  meditation,
}

enum ChallengeCategory {
  selfLove,
  healing,
  confidence,
  manifestation,
  mindfulness,
  morningRoutine,
}

class Challenge {
  final int id;
  final String title;
  final String? subtitle;
  final String description;
  final int duration; // in days
  final ChallengeCategory category;
  final List<String> goals;
  final String? icon;
  final String? colorTheme;
  final bool isActive;

  Challenge({
    required this.id,
    required this.title,
    this.subtitle,
    required this.description,
    required this.duration,
    required this.category,
    required this.goals,
    this.icon,
    this.colorTheme,
    required this.isActive,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] as int,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String?,
      description: json['description'] as String,
      duration: json['duration'] as int,
      category: _parseCategory(json['category'] as String),
      goals: List<String>.from(json['goals'] ?? []),
      icon: json['icon'] as String?,
      colorTheme: json['colorTheme'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  static ChallengeCategory _parseCategory(String category) {
    switch (category.toUpperCase()) {
      case 'SELF_LOVE':
        return ChallengeCategory.selfLove;
      case 'HEALING':
        return ChallengeCategory.healing;
      case 'CONFIDENCE':
        return ChallengeCategory.confidence;
      case 'MANIFESTATION':
        return ChallengeCategory.manifestation;
      case 'MINDFULNESS':
        return ChallengeCategory.mindfulness;
      case 'MORNING_ROUTINE':
        return ChallengeCategory.morningRoutine;
      default:
        return ChallengeCategory.selfLove;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'duration': duration,
      'category': _categoryToString(),
      'goals': goals,
      'icon': icon,
      'colorTheme': colorTheme,
      'isActive': isActive,
    };
  }

  String _categoryToString() {
    switch (category) {
      case ChallengeCategory.selfLove:
        return 'SELF_LOVE';
      case ChallengeCategory.healing:
        return 'HEALING';
      case ChallengeCategory.confidence:
        return 'CONFIDENCE';
      case ChallengeCategory.manifestation:
        return 'MANIFESTATION';
      case ChallengeCategory.mindfulness:
        return 'MINDFULNESS';
      case ChallengeCategory.morningRoutine:
        return 'MORNING_ROUTINE';
    }
  }
}

class Ritual {
  final int id;
  final int challengeId;
  final int dayNumber;
  final String title;
  final String? description;
  final RitualType type;
  final int duration; // in seconds
  final String? textContent;
  final String? audioUrl;
  final String? videoUrl;
  final int? meditationTrackId;

  Ritual({
    required this.id,
    required this.challengeId,
    required this.dayNumber,
    required this.title,
    this.description,
    required this.type,
    required this.duration,
    this.textContent,
    this.audioUrl,
    this.videoUrl,
    this.meditationTrackId,
  });

  factory Ritual.fromJson(Map<String, dynamic> json) {
    return Ritual(
      id: json['id'] as int,
      challengeId: json['challengeId'] as int,
      dayNumber: json['dayNumber'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      type: _parseType(json['type'] as String),
      duration: json['duration'] as int,
      textContent: json['textContent'] as String?,
      audioUrl: json['audioUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      meditationTrackId: json['meditationTrackId'] as int?,
    );
  }

  static RitualType _parseType(String type) {
    switch (type.toUpperCase()) {
      case 'TEXT':
        return RitualType.text;
      case 'AUDIO':
        return RitualType.audio;
      case 'VIDEO':
        return RitualType.video;
      case 'MEDITATION':
        return RitualType.meditation;
      default:
        return RitualType.text;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeId': challengeId,
      'dayNumber': dayNumber,
      'title': title,
      'description': description,
      'type': _typeToString(),
      'duration': duration,
      'textContent': textContent,
      'audioUrl': audioUrl,
      'videoUrl': videoUrl,
      'meditationTrackId': meditationTrackId,
    };
  }

  String _typeToString() {
    switch (type) {
      case RitualType.text:
        return 'TEXT';
      case RitualType.audio:
        return 'AUDIO';
      case RitualType.video:
        return 'VIDEO';
      case RitualType.meditation:
        return 'MEDITATION';
    }
  }

  // Helper method to format duration
  String get formattedDuration {
    if (duration >= 60) {
      final minutes = duration ~/ 60;
      final seconds = duration % 60;
      if (seconds > 0) {
        return '${minutes}m ${seconds}s';
      }
      return '${minutes}m';
    }
    return '${duration}s';
  }
}

class UserChallenge {
  final int id;
  final int userId;
  final int challengeId;
  final ChallengeStatus status;
  final int currentDay;
  final DateTime? startedAt;
  final DateTime? pausedAt;
  final DateTime? completedAt;

  UserChallenge({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.status,
    required this.currentDay,
    this.startedAt,
    this.pausedAt,
    this.completedAt,
  });

  factory UserChallenge.fromJson(Map<String, dynamic> json) {
    return UserChallenge(
      id: json['id'] as int,
      userId: json['userId'] as int,
      challengeId: json['challengeId'] as int,
      status: UserChallenge.parseStatus(json['status'] as String),
      currentDay: json['currentDay'] as int,
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt'] as String) : null,
      pausedAt: json['pausedAt'] != null ? DateTime.parse(json['pausedAt'] as String) : null,
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt'] as String) : null,
    );
  }

  static ChallengeStatus parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'NOT_STARTED':
        return ChallengeStatus.notStarted;
      case 'ACTIVE':
        return ChallengeStatus.active;
      case 'PAUSED':
        return ChallengeStatus.paused;
      case 'COMPLETED':
        return ChallengeStatus.completed;
      default:
        return ChallengeStatus.notStarted;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'challengeId': challengeId,
      'status': _statusToString(),
      'currentDay': currentDay,
      'startedAt': startedAt?.toIso8601String(),
      'pausedAt': pausedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  String _statusToString() {
    switch (status) {
      case ChallengeStatus.notStarted:
        return 'NOT_STARTED';
      case ChallengeStatus.active:
        return 'ACTIVE';
      case ChallengeStatus.paused:
        return 'PAUSED';
      case ChallengeStatus.completed:
        return 'COMPLETED';
    }
  }
}

class UserChallengeProgress {
  final int completedDays;
  final int totalDays;
  final DateTime? lastCompletedAt;

  UserChallengeProgress({
    required this.completedDays,
    required this.totalDays,
    this.lastCompletedAt,
  });

  factory UserChallengeProgress.fromJson(Map<String, dynamic> json) {
    return UserChallengeProgress(
      completedDays: json['completedDays'] as int,
      totalDays: json['totalDays'] as int,
      lastCompletedAt: json['lastCompletedAt'] != null 
          ? DateTime.parse(json['lastCompletedAt'] as String) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'completedDays': completedDays,
      'totalDays': totalDays,
      'lastCompletedAt': lastCompletedAt?.toIso8601String(),
    };
  }

  double get progressPercentage => completedDays / totalDays;
}
