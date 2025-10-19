class MeditationTrack {
  final int id;
  final String title;
  final String artist;
  final int duration; // Duration in seconds
  final String category; // "audio", "music", "sleep"
  final String? description;
  final String? imageUrl;
  final String? audioUrl;
  final bool isPremium;
  final bool isFavorited;

  const MeditationTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.category,
    this.description,
    this.imageUrl,
    this.audioUrl,
    this.isPremium = false,
    this.isFavorited = false,
  });

  // Parse API response
  factory MeditationTrack.fromJson(Map<String, dynamic> json) {
    return MeditationTrack(
      id: json['id'] as int,
      title: json['title'] as String,
      artist: json['artist'] as String,
      duration: json['duration'] as int,
      category: json['category'].toString().toLowerCase(), // "AUDIO" -> "audio"
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      audioUrl: json['audioUrl'] as String?,
      isPremium: json['isPremium'] as bool? ?? false,
      isFavorited: json['isFavorited'] as bool? ?? false,
    );
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'duration': duration,
      'category': category.toUpperCase(),
      'description': description,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'isPremium': isPremium,
      'isFavorited': isFavorited,
    };
  }

  // Format duration for UI display
  String get formattedDuration {
    final mins = duration ~/ 60;
    final secs = duration % 60;
    return '$mins:${secs.toString().padLeft(2, '0')}';
  }

  MeditationTrack copyWith({
    int? id,
    String? title,
    String? artist,
    int? duration,
    String? category,
    String? description,
    String? imageUrl,
    String? audioUrl,
    bool? isPremium,
    bool? isFavorited,
  }) {
    return MeditationTrack(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      isPremium: isPremium ?? this.isPremium,
      isFavorited: isFavorited ?? this.isFavorited,
    );
  }

  @override
  String toString() {
    return 'MeditationTrack(id: $id, title: $title, artist: $artist, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MeditationTrack && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
