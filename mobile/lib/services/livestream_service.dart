import '../models/livestream.dart';
import 'api_client.dart';

class LivestreamService {
  final ApiClient _apiClient;

  LivestreamService(this._apiClient);

  /// Get all livestreams with optional status filter
  Future<List<Livestream>> getStreams({
    String? status, // 'SCHEDULED', 'LIVE', 'ENDED'
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final Map<String, String> params = {
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (status != null) params['status'] = status;

      final response = await _apiClient.get('/livestream/streams', params: params);
      final List<dynamic> streamsData = response['data']?['streams'] ?? [];
      return streamsData.map((streamData) => Livestream.fromJson(streamData)).toList();
    } catch (e) {
      print('❌ [LivestreamService] Error getting streams: $e');
      rethrow;
    }
  }

  /// Get specific livestream details
  Future<Livestream> getStream(int streamId) async {
    try {
      final response = await _apiClient.get('/livestream/streams/$streamId');
      return Livestream.fromJson(response['data']);
    } catch (e) {
      print('❌ [LivestreamService] Error getting stream: $e');
      rethrow;
    }
  }

  /// Join a livestream
  Future<Map<String, dynamic>> joinStream(int streamId) async {
    try {
      final response = await _apiClient.post('/livestream/streams/$streamId/join');
      return response['data'] ?? {};
    } catch (e) {
      print('❌ [LivestreamService] Error joining stream: $e');
      rethrow;
    }
  }

  /// Leave a livestream
  Future<Map<String, dynamic>> leaveStream(int streamId) async {
    try {
      final response = await _apiClient.post('/livestream/streams/$streamId/leave');
      return response['data'] ?? {};
    } catch (e) {
      print('❌ [LivestreamService] Error leaving stream: $e');
      rethrow;
    }
  }

  /// Send chat message
  Future<Map<String, dynamic>> sendChatMessage({
    required int streamId,
    required String message,
  }) async {
    try {
      final response = await _apiClient.post('/livestream/streams/$streamId/chat', body: {
        'message': message,
      });
      return response['data'] ?? {};
    } catch (e) {
      print('❌ [LivestreamService] Error sending chat message: $e');
      rethrow;
    }
  }

  /// Get chat messages for a stream
  Future<List<Map<String, dynamic>>> getChatMessages({
    required int streamId,
    int limit = 50,
  }) async {
    try {
      final response = await _apiClient.get('/livestream/streams/$streamId/chat', params: {
        'limit': limit.toString(),
      });
      final List<dynamic> messagesData = response['data'] ?? [];
      return messagesData.cast<Map<String, dynamic>>();
    } catch (e) {
      print('❌ [LivestreamService] Error getting chat messages: $e');
      rethrow;
    }
  }

  /// Set reminder for upcoming stream
  Future<Map<String, dynamic>> setReminder(int streamId) async {
    try {
      final response = await _apiClient.post('/livestream/streams/$streamId/reminder');
      return response['data'] ?? {};
    } catch (e) {
      print('❌ [LivestreamService] Error setting reminder: $e');
      rethrow;
    }
  }

  /// Remove reminder for stream
  Future<Map<String, dynamic>> removeReminder(int streamId) async {
    try {
      final response = await _apiClient.delete('/livestream/streams/$streamId/reminder');
      return response['data'] ?? {};
    } catch (e) {
      print('❌ [LivestreamService] Error removing reminder: $e');
      rethrow;
    }
  }
}
