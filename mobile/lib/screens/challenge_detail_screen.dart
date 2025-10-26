import 'package:flutter/material.dart';
import '../shared_background.dart';
import '../models/challenge.dart';
import '../services/challenge_service.dart';
import '../services/api_client.dart';

class ChallengeDetailScreen extends StatefulWidget {
  final int challengeId;

  const ChallengeDetailScreen({
    super.key,
    required this.challengeId,
  });

  @override
  State<ChallengeDetailScreen> createState() => _ChallengeDetailScreenState();
}

class _ChallengeDetailScreenState extends State<ChallengeDetailScreen> {
  late ChallengeService _challengeService;
  ChallengeDetails? _challengeDetails;
  bool _isLoading = true;
  bool _isCompleting = false;

  @override
  void initState() {
    super.initState();
    _challengeService = ChallengeService(ApiClient.instance());
    _loadChallengeDetails();
  }

  Future<void> _loadChallengeDetails() async {
    final details = await _challengeService.getChallengeDetails(widget.challengeId);
    setState(() {
      _challengeDetails = details;
      _isLoading = false;
    });
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return SharedBackground(
      bgColorHex: '1B0A33',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: lightTextColor),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator(color: purpleAccent))
            : _challengeDetails == null
                ? Center(
                    child: Text(
                      'Challenge not found',
                      style: TextStyle(color: lightTextColor, fontFamily: 'DMSans'),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildContent(lightTextColor, purpleAccent),
                  ),
      ),
    );
  }

  Widget _buildContent(Color lightTextColor, Color purpleAccent) {
    final challenge = _challengeDetails!.challenge;
    final userProgress = _challengeDetails!.userProgress;
    final isStarted = userProgress != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Challenge Icon/Header
        _buildChallengeHeader(challenge, lightTextColor, purpleAccent, isStarted),

        const SizedBox(height: 30),

        // Challenge Description
        Text(
          challenge.subtitle ?? 'A daily journey to rebuild your confidence step by step.',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor.withOpacity(0.8),
            fontSize: 16,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 30),

        // Action Buttons
        if (!isStarted)
          _buildStartButton(lightTextColor, purpleAccent)
        else
          _buildActionButtons(userProgress!, lightTextColor, purpleAccent),

        const SizedBox(height: 30),

        // What you will achieve
        _buildAchievements(challenge, lightTextColor),

        const SizedBox(height: 30),

        // Plan
        _buildPlan(challenge, userProgress, lightTextColor, purpleAccent),
      ],
    );
  }

  Widget _buildChallengeHeader(Challenge challenge, Color lightTextColor, Color purpleAccent, bool isStarted) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getColorForTheme(challenge.colorTheme),
                _getColorForTheme(challenge.colorTheme).withOpacity(0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _getColorForTheme(challenge.colorTheme).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Center(
            child: Text(
              challenge.title,
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(height: 16),
        if (_challengeDetails!.rituals.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: lightTextColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _challengeDetails!.rituals.first.type.toString().split('.').last.toUpperCase(),
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        const SizedBox(height: 12),
        Text(
          challenge.title,
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        if (isStarted && _challengeDetails!.userProgress != null) ...[
          const SizedBox(height: 8),
          Text(
            '${_challengeDetails!.userProgress!.userChallenge.currentDay}/${challenge.duration}',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildStartButton(Color lightTextColor, Color purpleAccent) {
    return GestureDetector(
      onTap: _handleStart,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: purpleAccent,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: purpleAccent.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          'Start',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildActionButtons(UserProgress userProgress, Color lightTextColor, Color purpleAccent) {
    final isPaused = userProgress.userChallenge.status == ChallengeStatus.paused;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: isPaused
                ? () => _handleResume(userProgress.userChallenge.challengeId)
                : () => _handlePause(userProgress.userChallenge.challengeId),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: lightTextColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: lightTextColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                isPaused ? 'Resume' : '|| Pause',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Navigate to today's ritual
              _showTodayRitual();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: purpleAccent,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: purpleAccent.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Text(
                'Done ✓',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAchievements(Challenge challenge, Color lightTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'What you will achieve',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...challenge.goals.map((goal) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
                Expanded(
                  child: Text(
                    goal,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor.withOpacity(0.8),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildPlan(Challenge challenge, UserProgress? userProgress, Color lightTextColor, Color purpleAccent) {
    final isStarted = userProgress != null;
    final currentDay = userProgress?.userChallenge.currentDay ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ..._challengeDetails!.rituals.map((ritual) {
          final isToday = isStarted && ritual.dayNumber == currentDay;
          final isCompleted = isStarted && userProgress!.completedRitualIds.contains(ritual.id);
          final isPast = isStarted && ritual.dayNumber < currentDay;
          final isFuture = isStarted && ritual.dayNumber > currentDay;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: isToday && !isCompleted ? () => _showRitual(ritual, userProgress) : null,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isToday
                      ? purpleAccent.withOpacity(0.2)
                      : lightTextColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isToday
                        ? purpleAccent.withOpacity(0.5)
                        : lightTextColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isStarted
                                ? (isToday
                                    ? 'TODAY'
                                    : isPast
                                        ? 'DAY ${ritual.dayNumber}'
                                        : 'DAY ${ritual.dayNumber}')
                                : 'DAY ${ritual.dayNumber}',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: lightTextColor.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'RITUAL',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: lightTextColor.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            ritual.title,
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: lightTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${ritual.formattedDuration} • ${ritual.type.toString().split('.').last}',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: lightTextColor.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          if (isToday && ritual.textContent != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              'YOUR ACTION STEP',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                color: lightTextColor.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              ritual.textContent!,
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                color: lightTextColor.withOpacity(0.9),
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (isCompleted)
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      )
                    else if (isToday)
                      Icon(
                        Icons.arrow_forward_ios,
                        color: purpleAccent,
                        size: 16,
                      )
                    else if (isFuture)
                      Icon(
                        Icons.lock,
                        color: lightTextColor.withOpacity(0.3),
                        size: 20,
                      ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Color _getColorForTheme(String? theme) {
    switch (theme?.toLowerCase()) {
      case 'purple':
        return const Color(0xFF6A1B9A);
      case 'pink':
        return Colors.pink;
      case 'rose':
        return Colors.pink.shade300;
      case 'beige':
        return const Color(0xFFD2B48C);
      case 'orange':
        return Colors.orange;
      case 'blue':
        return Colors.blue;
      case 'teal':
        return Colors.teal;
      case 'gold':
        return Colors.amber.shade700;
      default:
        return const Color(0xFF6A1B9A);
    }
  }

  void _handleStart() async {
    final success = await _challengeService.startChallenge(widget.challengeId);
    if (success && mounted) {
      await _loadChallengeDetails();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Challenge started!', style: TextStyle(fontFamily: 'DMSans')),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _handlePause(int challengeId) async {
    final success = await _challengeService.pauseChallenge(challengeId);
    if (success && mounted) {
      await _loadChallengeDetails();
    }
  }

  void _handleResume(int challengeId) async {
    final success = await _challengeService.resumeChallenge(challengeId);
    if (success && mounted) {
      await _loadChallengeDetails();
    }
  }

  void _showTodayRitual() {
    if (_challengeDetails!.userProgress == null) return;

    final currentDay = _challengeDetails!.userProgress!.userChallenge.currentDay;
    final todayRitual = _challengeDetails!.rituals
        .firstWhere((r) => r.dayNumber == currentDay, orElse: () => _challengeDetails!.rituals.first);

    _showRitual(todayRitual, _challengeDetails!.userProgress!);
  }

  Future<void> _showRitual(Ritual ritual, UserProgress userProgress) async {
    // Complete the ritual immediately for now
    final success = await _challengeService.completeRitual(widget.challengeId, ritual.id);
    if (success && mounted) {
      await _loadChallengeDetails();
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    final lightTextColor = _hexToColor('F0E6D8');
    
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.purple,
                size: 80,
              ),
              const SizedBox(height: 20),
              Text(
                'Done!',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Connect with other queens and let them find you by sharing your city and Instagram.',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 16,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Next challenge',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
