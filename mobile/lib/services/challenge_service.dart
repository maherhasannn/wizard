import 'package:flutter/foundation.dart';
import '../models/challenge.dart';
import 'api_client.dart';

class ChallengeService extends ChangeNotifier {
  final ApiClient _client;

  ChallengeService(this._client);

  List<Challenge> _challenges = [];
  List<ActiveChallenge> _activeChallenges = [];
  bool _isLoading = false;
  String? _error;

  List<Challenge> get challenges => _challenges;
  List<ActiveChallenge> get activeChallenges => _activeChallenges;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Fetch all available challenges
  Future<void> fetchChallenges() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final json = await _client.get('/challenges');
      final data = json['data'] as List;
      _challenges = data.map((c) => Challenge.fromJson(c as Map<String, dynamic>)).toList();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load challenges';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch challenge details with rituals
  Future<ChallengeDetails?> getChallengeDetails(int challengeId) async {
    try {
      final json = await _client.get('/challenges/$challengeId');
      final data = json['data'] as Map<String, dynamic>;
      
      final challenge = Challenge.fromJson(data['challenge'] as Map<String, dynamic>);
      final rituals = (data['rituals'] as List)
          .map((r) => Ritual.fromJson(r as Map<String, dynamic>))
          .toList();
      
      UserProgress? progress;
      if (data['userProgress'] != null) {
        progress = UserProgress.fromJson(data['userProgress'] as Map<String, dynamic>);
      }

      return ChallengeDetails(
        challenge: challenge,
        rituals: rituals,
        userProgress: progress,
      );
    } on ApiException catch (e) {
      _error = e.message;
      return null;
    }
  }

  // Fetch active challenges for the user
  Future<void> fetchActiveChallenges() async {
    try {
      final json = await _client.get('/challenges/my/active');
      final data = json['data'] as List;
      _activeChallenges = data.map((ac) => ActiveChallenge.fromJson(ac as Map<String, dynamic>)).toList();
      notifyListeners();
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
    }
  }

  // Start a challenge
  Future<bool> startChallenge(int challengeId) async {
    try {
      await _client.post('/challenges/$challengeId/start');
      await fetchActiveChallenges(); // Refresh active challenges
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  // Pause a challenge
  Future<bool> pauseChallenge(int challengeId) async {
    try {
      await _client.post('/challenges/$challengeId/pause');
      await fetchActiveChallenges(); // Refresh active challenges
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  // Resume a challenge
  Future<bool> resumeChallenge(int challengeId) async {
    try {
      await _client.post('/challenges/$challengeId/resume');
      await fetchActiveChallenges(); // Refresh active challenges
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  // Complete a ritual
  Future<bool> completeRitual(int challengeId, int ritualId) async {
    try {
      await _client.post('/challenges/$challengeId/rituals/$ritualId/complete');
      await fetchActiveChallenges(); // Refresh active challenges
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  // Get user's progress in a challenge
  Future<ChallengeProgress?> getProgress(int challengeId) async {
    try {
      final json = await _client.get('/challenges/$challengeId/progress');
      final data = json['data'] as Map<String, dynamic>;
      return ChallengeProgress.fromJson(data);
    } on ApiException catch (e) {
      _error = e.message;
      return null;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

// Data classes for complex responses
class ChallengeDetails {
  final Challenge challenge;
  final List<Ritual> rituals;
  final UserProgress? userProgress;

  ChallengeDetails({
    required this.challenge,
    required this.rituals,
    this.userProgress,
  });
}

class UserProgress {
  final UserChallenge userChallenge;
  final List<int> completedRitualIds;

  UserProgress({
    required this.userChallenge,
    required this.completedRitualIds,
  });

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userChallenge: UserChallenge.fromJson(json['userChallenge'] as Map<String, dynamic>),
      completedRitualIds: List<int>.from(json['completedRitualIds'] ?? []),
    );
  }
}

class ActiveChallenge {
  final int id;
  final int userId;
  final int challengeId;
  final ChallengeStatus status;
  final int currentDay;
  final DateTime? startedAt;
  final DateTime? pausedAt;
  final Challenge challenge;
  final Ritual? todayRitual;
  final List<int> completedRitualIds;

  ActiveChallenge({
    required this.id,
    required this.userId,
    required this.challengeId,
    required this.status,
    required this.currentDay,
    this.startedAt,
    this.pausedAt,
    required this.challenge,
    this.todayRitual,
    required this.completedRitualIds,
  });

  factory ActiveChallenge.fromJson(Map<String, dynamic> json) {
    return ActiveChallenge(
      id: json['id'] as int,
      userId: json['userId'] as int,
      challengeId: json['challengeId'] as int,
      status: UserChallenge.parseStatus(json['status'] as String),
      currentDay: json['currentDay'] as int,
      startedAt: json['startedAt'] != null ? DateTime.parse(json['startedAt'] as String) : null,
      pausedAt: json['pausedAt'] != null ? DateTime.parse(json['pausedAt'] as String) : null,
      challenge: Challenge.fromJson(json['challenge'] as Map<String, dynamic>),
      todayRitual: json['todayRitual'] != null 
          ? Ritual.fromJson(json['todayRitual'] as Map<String, dynamic>)
          : null,
      completedRitualIds: List<int>.from(json['completedRitualIds'] ?? []),
    );
  }
}

class ChallengeProgress {
  final UserChallenge userChallenge;
  final Challenge challenge;
  final List<Ritual> rituals;
  final List<int> completedRitualIds;

  ChallengeProgress({
    required this.userChallenge,
    required this.challenge,
    required this.rituals,
    required this.completedRitualIds,
  });

  factory ChallengeProgress.fromJson(Map<String, dynamic> json) {
    return ChallengeProgress(
      userChallenge: UserChallenge.fromJson(json as Map<String, dynamic>),
      challenge: Challenge.fromJson(json['challenge'] as Map<String, dynamic>),
      rituals: (json['rituals'] as List).map((r) => Ritual.fromJson(r as Map<String, dynamic>)).toList(),
      completedRitualIds: List<int>.from(json['completedRitualIds'] ?? []),
    );
  }
}
