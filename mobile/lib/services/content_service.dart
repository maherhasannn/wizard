import '../models/content.dart';
import 'api_client.dart';

class ContentService {
  final ApiClient _client;

  ContentService(this._client);

  // Message of Day
  Future<MessageOfDay> getMessageOfDay({DateTime? date}) async {
    final params = date != null 
        ? {'date': date.toIso8601String().split('T')[0]}
        : <String, String>{};
    
    final json = await _client.get('/content/message-of-day', params: params);
    final data = json['data'] as Map<String, dynamic>;
    return MessageOfDay.fromJson(data);
  }

  // Videos
  Future<List<Video>> getVideos({
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    final params = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (category != null) {
      params['category'] = category;
    }

    final json = await _client.get('/content/videos', params: params);
    final data = json['data'] as Map<String, dynamic>;
    final videosData = data['videos'] as List;
    
    return videosData.map((v) => Video.fromJson(v as Map<String, dynamic>)).toList();
  }

  Future<Video> getVideo(int videoId) async {
    final json = await _client.get('/content/videos/$videoId');
    final data = json['data'] as Map<String, dynamic>;
    return Video.fromJson(data);
  }

  Future<void> recordVideoView({
    required int videoId,
    required int watchDuration,
  }) async {
    await _client.post('/content/videos/$videoId/view', body: {
      'watchDuration': watchDuration,
    });
  }

  // Affirmations
  Future<List<Affirmation>> getAffirmations({
    String? category,
    int page = 1,
    int limit = 20,
  }) async {
    final params = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (category != null) {
      params['category'] = category;
    }

    final json = await _client.get('/content/affirmations', params: params);
    final data = json['data'] as Map<String, dynamic>;
    final affirmationsData = data['affirmations'] as List;
    
    return affirmationsData.map((a) => Affirmation.fromJson(a as Map<String, dynamic>)).toList();
  }

  Future<Affirmation> getAffirmation(int affirmationId) async {
    final json = await _client.get('/content/affirmations/$affirmationId');
    final data = json['data'] as Map<String, dynamic>;
    return Affirmation.fromJson(data);
  }

  Future<void> recordAffirmationInteraction({
    required int affirmationId,
    int? feeling,
  }) async {
    await _client.post('/content/affirmations/$affirmationId/interact', body: {
      if (feeling != null) 'feeling': feeling,
    });
  }

  // Live Streams
  Future<List<LiveStream>> getLiveStreams({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final params = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (status != null) {
      params['status'] = status;
    }

    final json = await _client.get('/livestream/streams', params: params);
    final data = json['data'] as Map<String, dynamic>;
    final streamsData = data['streams'] as List;
    
    return streamsData.map((s) => LiveStream.fromJson(s as Map<String, dynamic>)).toList();
  }

  Future<LiveStream> getLiveStream(int streamId) async {
    final json = await _client.get('/livestream/streams/$streamId');
    final data = json['data'] as Map<String, dynamic>;
    return LiveStream.fromJson(data);
  }
}

