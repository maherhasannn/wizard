class MeditationTrack {
  final String id;
  final String title;
  final String artist;
  final String duration; // "2:00" format
  final String category; // "audio", "music", "sleep"
  final String imageUrl; // placeholder path
  final String audioUrl; // placeholder or null
  final bool isPremium;
  final bool isFavorite;
  final bool isDownloaded;

  const MeditationTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
    required this.category,
    required this.imageUrl,
    required this.audioUrl,
    this.isPremium = false,
    this.isFavorite = false,
    this.isDownloaded = false,
  });

  MeditationTrack copyWith({
    String? id,
    String? title,
    String? artist,
    String? duration,
    String? category,
    String? imageUrl,
    String? audioUrl,
    bool? isPremium,
    bool? isFavorite,
    bool? isDownloaded,
  }) {
    return MeditationTrack(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      audioUrl: audioUrl ?? this.audioUrl,
      isPremium: isPremium ?? this.isPremium,
      isFavorite: isFavorite ?? this.isFavorite,
      isDownloaded: isDownloaded ?? this.isDownloaded,
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
