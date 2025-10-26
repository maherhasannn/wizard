import 'package:flutter/foundation.dart';
import '../models/livestream.dart';
import '../services/livestream_service.dart';

class LivestreamProvider extends ChangeNotifier {
  final LivestreamService _service;

  LivestreamProvider(this._service);

  // State variables
  List<Livestream> _upcomingStreams = [];
  List<Livestream> _liveStreams = [];
  List<Livestream> _pastStreams = [];
  Livestream? _currentStream;
  List<Map<String, dynamic>> _chatMessages = [];
  bool _isLoading = false;
  bool _isJoining = false;
  bool _isSendingMessage = false;
  String? _error;

  // Getters
  List<Livestream> get upcomingStreams => _upcomingStreams;
  List<Livestream> get liveStreams => _liveStreams;
  List<Livestream> get pastStreams => _pastStreams;
  Livestream? get currentStream => _currentStream;
  List<Map<String, dynamic>> get chatMessages => _chatMessages;
  bool get isLoading => _isLoading;
  bool get isJoining => _isJoining;
  bool get isSendingMessage => _isSendingMessage;
  String? get error => _error;

  // Get next upcoming stream (for main tab display)
  Livestream? get nextUpcomingStream {
    if (_upcomingStreams.isEmpty) return null;
    return _upcomingStreams.first;
  }

  // Load all streams
  Future<void> loadStreams() async {
    _setLoading(true);
    _clearError();

    try {
      // Load upcoming streams
      final upcoming = await _service.getStreams(status: 'SCHEDULED', limit: 10);
      _upcomingStreams = upcoming;

      // Load live streams
      final live = await _service.getStreams(status: 'LIVE', limit: 10);
      _liveStreams = live;

      // Load past streams
      final past = await _service.getStreams(status: 'ENDED', limit: 20);
      _pastStreams = past;

      print('✅ [LivestreamProvider] Loaded streams - Upcoming: ${upcoming.length}, Live: ${live.length}, Past: ${past.length}');
    } catch (e) {
      _setError('Failed to load streams: $e');
      print('❌ [LivestreamProvider] Error loading streams: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Load specific stream details
  Future<void> loadStream(int streamId) async {
    _setLoading(true);
    _clearError();

    try {
      final stream = await _service.getStream(streamId);
      _currentStream = stream;
      print('✅ [LivestreamProvider] Loaded stream: ${stream.title}');
    } catch (e) {
      _setError('Failed to load stream: $e');
      print('❌ [LivestreamProvider] Error loading stream: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Join a livestream
  Future<bool> joinStream(int streamId) async {
    _setJoining(true);
    _clearError();

    try {
      await _service.joinStream(streamId);
      
      // Update stream status to live if it was upcoming
      _updateStreamStatus(streamId, 'LIVE');
      
      print('✅ [LivestreamProvider] Joined stream: $streamId');
      return true;
    } catch (e) {
      _setError('Failed to join stream: $e');
      print('❌ [LivestreamProvider] Error joining stream: $e');
      return false;
    } finally {
      _setJoining(false);
    }
  }

  // Leave a livestream
  Future<bool> leaveStream(int streamId) async {
    try {
      await _service.leaveStream(streamId);
      print('✅ [LivestreamProvider] Left stream: $streamId');
      return true;
    } catch (e) {
      _setError('Failed to leave stream: $e');
      print('❌ [LivestreamProvider] Error leaving stream: $e');
      return false;
    }
  }

  // Send chat message
  Future<bool> sendChatMessage(int streamId, String message) async {
    _setSendingMessage(true);
    _clearError();

    try {
      final result = await _service.sendChatMessage(
        streamId: streamId,
        message: message,
      );
      
      // Add message to local chat
      _chatMessages.add({
        'id': DateTime.now().millisecondsSinceEpoch,
        'message': message,
        'sentAt': DateTime.now().toIso8601String(),
        'user': 'You',
      });
      
      print('✅ [LivestreamProvider] Sent chat message to stream: $streamId');
      return true;
    } catch (e) {
      _setError('Failed to send message: $e');
      print('❌ [LivestreamProvider] Error sending message: $e');
      return false;
    } finally {
      _setSendingMessage(false);
    }
  }

  // Load chat messages
  Future<void> loadChatMessages(int streamId) async {
    try {
      final messages = await _service.getChatMessages(streamId: streamId);
      _chatMessages = messages;
      print('✅ [LivestreamProvider] Loaded ${messages.length} chat messages');
    } catch (e) {
      _setError('Failed to load chat messages: $e');
      print('❌ [LivestreamProvider] Error loading chat messages: $e');
    }
  }

  // Set reminder for stream
  Future<bool> setReminder(int streamId) async {
    try {
      await _service.setReminder(streamId);
      
      // Update local stream reminder status
      _updateStreamReminderStatus(streamId, true);
      
      print('✅ [LivestreamProvider] Set reminder for stream: $streamId');
      return true;
    } catch (e) {
      _setError('Failed to set reminder: $e');
      print('❌ [LivestreamProvider] Error setting reminder: $e');
      return false;
    }
  }

  // Remove reminder for stream
  Future<bool> removeReminder(int streamId) async {
    try {
      await _service.removeReminder(streamId);
      
      // Update local stream reminder status
      _updateStreamReminderStatus(streamId, false);
      
      print('✅ [LivestreamProvider] Removed reminder for stream: $streamId');
      return true;
    } catch (e) {
      _setError('Failed to remove reminder: $e');
      print('❌ [LivestreamProvider] Error removing reminder: $e');
      return false;
    }
  }

  // Clear current stream
  void clearCurrentStream() {
    _currentStream = null;
    _chatMessages = [];
    notifyListeners();
  }

  // Clear chat messages
  void clearChatMessages() {
    _chatMessages = [];
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Check if user has reminder set for stream
  bool hasReminderSet(int streamId) {
    final stream = _findStreamById(streamId);
    return stream?.isReminderSet ?? false;
  }

  // Get stream by ID
  Livestream? getStreamById(int streamId) {
    return _findStreamById(streamId);
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setJoining(bool joining) {
    _isJoining = joining;
    notifyListeners();
  }

  void _setSendingMessage(bool sending) {
    _isSendingMessage = sending;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void _updateStreamStatus(int streamId, String status) {
    // Update in upcoming streams
    final upcomingIndex = _upcomingStreams.indexWhere((stream) => stream.id == streamId);
    if (upcomingIndex != -1) {
      _upcomingStreams[upcomingIndex] = _upcomingStreams[upcomingIndex].copyWith(status: status);
    }

    // Update in live streams
    final liveIndex = _liveStreams.indexWhere((stream) => stream.id == streamId);
    if (liveIndex != -1) {
      _liveStreams[liveIndex] = _liveStreams[liveIndex].copyWith(status: status);
    }

    // Update current stream if it matches
    if (_currentStream?.id == streamId) {
      _currentStream = _currentStream!.copyWith(status: status);
    }

    notifyListeners();
  }

  void _updateStreamReminderStatus(int streamId, bool isReminderSet) {
    // Update in upcoming streams
    final upcomingIndex = _upcomingStreams.indexWhere((stream) => stream.id == streamId);
    if (upcomingIndex != -1) {
      _upcomingStreams[upcomingIndex] = _upcomingStreams[upcomingIndex].copyWith(isReminderSet: isReminderSet);
    }

    // Update current stream if it matches
    if (_currentStream?.id == streamId) {
      _currentStream = _currentStream!.copyWith(isReminderSet: isReminderSet);
    }

    notifyListeners();
  }

  Livestream? _findStreamById(int streamId) {
    // Check upcoming streams
    final upcomingStream = _upcomingStreams.where((stream) => stream.id == streamId).firstOrNull;
    if (upcomingStream != null) return upcomingStream;

    // Check live streams
    final liveStream = _liveStreams.where((stream) => stream.id == streamId).firstOrNull;
    if (liveStream != null) return liveStream;

    // Check past streams
    final pastStream = _pastStreams.where((stream) => stream.id == streamId).firstOrNull;
    if (pastStream != null) return pastStream;

    return null;
  }
}
