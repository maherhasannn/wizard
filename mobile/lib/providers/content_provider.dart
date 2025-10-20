import 'package:flutter/foundation.dart';
import '../models/content.dart';
import '../services/content_service.dart';
import '../services/api_client.dart';

class ContentProvider extends ChangeNotifier {
  final ContentService _service;

  MessageOfDay? _messageOfDay;
  List<Video> _videos = [];
  List<Affirmation> _affirmations = [];
  List<LiveStream> _liveStreams = [];
  bool _isLoading = false;
  String? _error;

  ContentProvider(this._service);

  MessageOfDay? get messageOfDay => _messageOfDay;
  List<Video> get videos => _videos;
  List<Affirmation> get affirmations => _affirmations;
  List<LiveStream> get liveStreams => _liveStreams;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadMessageOfDay({DateTime? date}) async {
    try {
      _messageOfDay = await _service.getMessageOfDay(date: date);
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  Future<void> loadVideos({String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _videos = await _service.getVideos(category: category);
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load videos';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAffirmations({String? category}) async {
    try {
      _affirmations = await _service.getAffirmations(category: category);
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  Future<void> loadLiveStreams({String? status}) async {
    try {
      _liveStreams = await _service.getLiveStreams(status: status);
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  LiveStream? get currentLiveStream {
    try {
      return _liveStreams.firstWhere((s) => s.isLive);
    } catch (e) {
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}


