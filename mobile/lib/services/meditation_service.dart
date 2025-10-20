import '../models/meditation_track.dart';
import 'api_client.dart';

class MeditationService {
  final ApiClient _client;

  MeditationService(this._client);

  Future<List<MeditationTrack>> getTracks({
    String? category,
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (category != null) {
      params['category'] = category.toUpperCase();
    }
    
    if (search != null) {
      params['search'] = search;
    }

    final json = await _client.get('/meditation/tracks', params: params);
    final data = json['data'] as Map<String, dynamic>;
    final tracksData = data['tracks'] as List;
    
    return tracksData.map((t) => MeditationTrack.fromJson(t as Map<String, dynamic>)).toList();
  }

  Future<MeditationTrack> getTrack(int trackId) async {
    final json = await _client.get('/meditation/tracks/$trackId');
    final data = json['data'] as Map<String, dynamic>;
    return MeditationTrack.fromJson(data);
  }

  Future<void> addToFavorites(int trackId) async {
    await _client.post('/meditation/tracks/$trackId/favorite');
  }

  Future<void> removeFromFavorites(int trackId) async {
    await _client.delete('/meditation/tracks/$trackId/favorite');
  }

  Future<List<MeditationTrack>> getFavorites({
    int page = 1,
    int limit = 20,
  }) async {
    final params = {
      'page': page.toString(),
      'limit': limit.toString(),
    };

    final json = await _client.get('/meditation/favorites', params: params);
    final data = json['data'] as Map<String, dynamic>;
    final tracksData = data['tracks'] as List;
    
    return tracksData.map((t) => MeditationTrack.fromJson(t as Map<String, dynamic>)).toList();
  }

  Future<void> recordPlay({
    required int trackId,
    required int duration,
    required bool completed,
  }) async {
    await _client.post('/meditation/tracks/$trackId/play', body: {
      'duration': duration,
      'completed': completed,
    });
  }

  Future<MeditationStats> getStats() async {
    final json = await _client.get('/meditation/stats');
    final data = json['data'] as Map<String, dynamic>;
    return MeditationStats.fromJson(data);
  }
}

class MeditationStats {
  final int totalMinutes;
  final int sessionsCount;
  final int streak;
  final DateTime? lastSessionDate;

  const MeditationStats({
    required this.totalMinutes,
    required this.sessionsCount,
    required this.streak,
    this.lastSessionDate,
  });

  factory MeditationStats.fromJson(Map<String, dynamic> json) {
    return MeditationStats(
      totalMinutes: json['totalMinutes'] as int,
      sessionsCount: json['sessionsCount'] as int,
      streak: json['streak'] as int,
      lastSessionDate: json['lastSessionDate'] != null
          ? DateTime.parse(json['lastSessionDate'] as String)
          : null,
    );
  }
}


