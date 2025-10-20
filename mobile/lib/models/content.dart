class MessageOfDay {
  final int id;
  final DateTime date;
  final String title;
  final String cardType;
  final String shortMessage;
  final String fullMessage;
  final String? imageUrl;
  final DateTime createdAt;

  const MessageOfDay({
    required this.id,
    required this.date,
    required this.title,
    required this.cardType,
    required this.shortMessage,
    required this.fullMessage,
    this.imageUrl,
    required this.createdAt,
  });

  factory MessageOfDay.fromJson(Map<String, dynamic> json) {
    return MessageOfDay(
      id: json['id'] as int,
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      cardType: json['cardType'] as String,
      shortMessage: json['shortMessage'] as String,
      fullMessage: json['fullMessage'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'cardType': cardType,
      'shortMessage': shortMessage,
      'fullMessage': fullMessage,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class Video {
  final int id;
  final String title;
  final String? description;
  final String thumbnailUrl;
  final String videoUrl;
  final int duration; // Duration in seconds
  final String? category;
  final int viewCount;
  final DateTime uploadedAt;
  final bool isActive;

  const Video({
    required this.id,
    required this.title,
    this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.duration,
    this.category,
    this.viewCount = 0,
    required this.uploadedAt,
    this.isActive = true,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String,
      videoUrl: json['videoUrl'] as String,
      duration: json['duration'] as int,
      category: json['category'] as String?,
      viewCount: json['viewCount'] as int? ?? 0,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnailUrl': thumbnailUrl,
      'videoUrl': videoUrl,
      'duration': duration,
      'category': category,
      'viewCount': viewCount,
      'uploadedAt': uploadedAt.toIso8601String(),
      'isActive': isActive,
    };
  }

  String get formattedDuration {
    final mins = duration ~/ 60;
    final secs = duration % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }
}

class Affirmation {
  final int id;
  final String title;
  final String content;
  final String? category;
  final String? imageUrl;
  final String? videoUrl;
  final bool isActive;
  final DateTime createdAt;

  const Affirmation({
    required this.id,
    required this.title,
    required this.content,
    this.category,
    this.imageUrl,
    this.videoUrl,
    this.isActive = true,
    required this.createdAt,
  });

  factory Affirmation.fromJson(Map<String, dynamic> json) {
    return Affirmation(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String?,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class LiveStream {
  final int id;
  final String title;
  final String? description;
  final int hostId;
  final String? thumbnailUrl;
  final String? streamUrl;
  final String status; // "SCHEDULED", "LIVE", "ENDED"
  final int viewerCount;
  final DateTime? startedAt;
  final DateTime? endedAt;
  final DateTime scheduledAt;
  final DateTime createdAt;

  const LiveStream({
    required this.id,
    required this.title,
    this.description,
    required this.hostId,
    this.thumbnailUrl,
    this.streamUrl,
    required this.status,
    this.viewerCount = 0,
    this.startedAt,
    this.endedAt,
    required this.scheduledAt,
    required this.createdAt,
  });

  factory LiveStream.fromJson(Map<String, dynamic> json) {
    return LiveStream(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String?,
      hostId: json['hostId'] as int,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      streamUrl: json['streamUrl'] as String?,
      status: json['status'] as String,
      viewerCount: json['viewerCount'] as int? ?? 0,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : null,
      endedAt: json['endedAt'] != null
          ? DateTime.parse(json['endedAt'] as String)
          : null,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'hostId': hostId,
      'thumbnailUrl': thumbnailUrl,
      'streamUrl': streamUrl,
      'status': status,
      'viewerCount': viewerCount,
      'startedAt': startedAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'scheduledAt': scheduledAt.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isLive => status == 'LIVE';
  bool get isScheduled => status == 'SCHEDULED';
  bool get isEnded => status == 'ENDED';
}


