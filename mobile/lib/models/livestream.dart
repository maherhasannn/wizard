class Livestream {
  final int id;
  final String title;
  final String description;
  final String status; // 'SCHEDULED', 'LIVE', 'ENDED'
  final DateTime scheduledAt;
  final String? thumbnailUrl;
  final String? streamUrl;
  final int hostId;
  final String hostName;
  final String? hostPhoto;
  final int participantCount;
  final int? duration; // Duration in seconds for ended streams
  final DateTime? startedAt;
  final DateTime? endedAt;
  final bool isReminderSet;
  final List<String> tags;

  const Livestream({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.scheduledAt,
    this.thumbnailUrl,
    this.streamUrl,
    required this.hostId,
    required this.hostName,
    this.hostPhoto,
    this.participantCount = 0,
    this.duration,
    this.startedAt,
    this.endedAt,
    this.isReminderSet = false,
    this.tags = const [],
  });

  factory Livestream.fromJson(Map<String, dynamic> json) {
    return Livestream(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      status: json['status'] as String,
      scheduledAt: DateTime.parse(json['scheduledAt'] as String),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      streamUrl: json['streamUrl'] as String?,
      hostId: json['host']?['id'] as int? ?? 0,
      hostName: '${json['host']?['firstName'] ?? ''} ${json['host']?['lastName'] ?? ''}'.trim(),
      hostPhoto: json['host']?['profilePhoto'] as String?,
      participantCount: json['participantCount'] as int? ?? 0,
      duration: json['duration'] as int?,
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt'] as String) : null,
      endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt'] as String) : null,
      isReminderSet: json['isReminderSet'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'scheduledAt': scheduledAt.toIso8601String(),
      'thumbnailUrl': thumbnailUrl,
      'streamUrl': streamUrl,
      'hostId': hostId,
      'hostName': hostName,
      'hostPhoto': hostPhoto,
      'participantCount': participantCount,
      'duration': duration,
      'startedAt': startedAt?.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'isReminderSet': isReminderSet,
      'tags': tags,
    };
  }

  bool get isUpcoming => status == 'SCHEDULED';
  bool get isLive => status == 'LIVE';
  bool get isEnded => status == 'ENDED';

  String get statusDisplayText {
    switch (status) {
      case 'SCHEDULED':
        return 'Upcoming';
      case 'LIVE':
        return 'Live Now';
      case 'ENDED':
        return 'Ended';
      default:
        return status;
    }
  }

  String get durationText {
    if (duration == null) return '';
    final hours = duration! ~/ 3600;
    final minutes = (duration! % 3600) ~/ 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get timeUntilStart {
    final now = DateTime.now();
    final difference = scheduledAt.difference(now);
    
    if (difference.isNegative) return 'Started';
    
    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    
    if (days > 0) {
      return '${days}d ${hours}h ${minutes}m';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  Livestream copyWith({
    int? id,
    String? title,
    String? description,
    String? status,
    DateTime? scheduledAt,
    String? thumbnailUrl,
    String? streamUrl,
    int? hostId,
    String? hostName,
    String? hostPhoto,
    int? participantCount,
    int? duration,
    DateTime? startedAt,
    DateTime? endedAt,
    bool? isReminderSet,
    List<String>? tags,
  }) {
    return Livestream(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      streamUrl: streamUrl ?? this.streamUrl,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      hostPhoto: hostPhoto ?? this.hostPhoto,
      participantCount: participantCount ?? this.participantCount,
      duration: duration ?? this.duration,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      isReminderSet: isReminderSet ?? this.isReminderSet,
      tags: tags ?? this.tags,
    );
  }

  @override
  String toString() {
    return 'Livestream(id: $id, title: $title, status: $status, scheduledAt: $scheduledAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Livestream && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
