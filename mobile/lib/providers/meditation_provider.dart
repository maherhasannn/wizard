import 'package:flutter/foundation.dart';
import '../models/meditation_track.dart';
import '../services/meditation_service.dart';
import '../services/api_client.dart';

class MeditationProvider extends ChangeNotifier {
  final MeditationService _service;

  List<MeditationTrack> _tracks = [];
  MeditationStats? _stats;
  bool _isLoading = false;
  String? _error;

  MeditationProvider(this._service);

  List<MeditationTrack> get tracks => _tracks;
  MeditationStats? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadTracks({String? category, String? search}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tracks = await _service.getTracks(
        category: category,
        search: search,
      );
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load tracks';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(int trackId) async {
    try {
      final track = _tracks.firstWhere((t) => t.id == trackId);
      
      if (track.isFavorited) {
        await _service.removeFromFavorites(trackId);
      } else {
        await _service.addToFavorites(trackId);
      }
      
      // Update local state
      final index = _tracks.indexWhere((t) => t.id == trackId);
      _tracks[index] = track.copyWith(isFavorited: !track.isFavorited);
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  Future<void> loadStats() async {
    try {
      _stats = await _service.getStats();
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
    }
  }

  Future<void> recordPlay({
    required int trackId,
    required int duration,
    required bool completed,
  }) async {
    try {
      await _service.recordPlay(
        trackId: trackId,
        duration: duration,
        completed: completed,
      );
      
      // Reload stats after recording play
      await loadStats();
    } on ApiException catch (e) {
      _error = e.message;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

