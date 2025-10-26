import 'package:flutter/material.dart';
import '../shared_background.dart';
import '../models/challenge.dart';
import '../services/challenge_service.dart';
import '../services/api_client.dart';
import '../screens/challenge_detail_screen.dart';

class ChallengeTab extends StatefulWidget {
  const ChallengeTab({super.key});

  @override
  State<ChallengeTab> createState() => _ChallengeTabState();
}

class _ChallengeTabState extends State<ChallengeTab> {
  late ChallengeService _challengeService;

  @override
  void initState() {
    super.initState();
    _challengeService = ChallengeService(ApiClient.instance());
    _challengeService.addListener(_onServiceChanged);
    _loadData();
  }

  @override
  void dispose() {
    _challengeService.removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() {
    setState(() {});
  }

  Future<void> _loadData() async {
    await _challengeService.fetchChallenges();
    await _challengeService.fetchActiveChallenges();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(lightTextColor, purpleAccent),
              
              const SizedBox(height: 30),
              
              // My Challenge Section
              _buildMyChallenge(lightTextColor, purpleAccent),
              
              const SizedBox(height: 30),
              
              // Join Challenge Section
              _buildJoinChallenge(lightTextColor, purpleAccent),
              
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color lightTextColor, Color purpleAccent) {
    return Text(
      'Challenges',
      style: TextStyle(
        fontFamily: 'DMSans',
        color: lightTextColor,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildMyChallenge(Color lightTextColor, Color purpleAccent) {
    if (_challengeService.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: purpleAccent),
      );
    }

    if (_challengeService.activeChallenges.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MY CHALLENGE',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: lightTextColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Text(
              'No active challenges. Start a challenge to begin your journey!',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MY CHALLENGE',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _challengeService.activeChallenges.length,
          itemBuilder: (context, index) {
            final activeChallenge = _challengeService.activeChallenges[index];
            return _buildActiveChallengeCard(activeChallenge, lightTextColor, purpleAccent);
          },
        ),
      ],
    );
  }

  Widget _buildActiveChallengeCard(ActiveChallenge activeChallenge, Color lightTextColor, Color purpleAccent) {
    final hasTodayRitual = activeChallenge.todayRitual != null;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChallengeDetailScreen(challengeId: activeChallenge.challengeId),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getColorForTheme(activeChallenge.challenge.colorTheme).withOpacity(0.8),
              _getColorForTheme(activeChallenge.challenge.colorTheme).withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: lightTextColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (hasTodayRitual)
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightTextColor.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.check,
                      color: lightTextColor,
                      size: 20,
                    ),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TODAY\'S RITUAL',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: lightTextColor.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        hasTodayRitual ? activeChallenge.todayRitual!.title : 'No ritual for today',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (hasTodayRitual) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    activeChallenge.todayRitual!.formattedDuration,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor.withOpacity(0.7),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: lightTextColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      activeChallenge.todayRitual!.type.toString().split('.').last.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 8),
              Text(
                activeChallenge.todayRitual!.textContent ?? activeChallenge.todayRitual!.description ?? '',
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
    );
  }

  Widget _buildJoinChallenge(Color lightTextColor, Color purpleAccent) {
    if (_challengeService.isLoading) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Join Challenge',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ..._challengeService.challenges.map((challenge) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildChallengeCard(challenge, lightTextColor, purpleAccent),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildChallengeCard(Challenge challenge, Color lightTextColor, Color purpleAccent) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ChallengeDetailScreen(challengeId: challenge.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: _getBackgroundColorForChallenge(challenge).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: lightTextColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        _getColorForTheme(challenge.colorTheme),
                        _getColorForTheme(challenge.colorTheme).withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: Icon(
                    Icons.auto_fix_high,
                    color: lightTextColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        challenge.subtitle ?? challenge.description,
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: lightTextColor.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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

  Color _getBackgroundColorForChallenge(Challenge challenge) {
    switch (challenge.colorTheme?.toLowerCase()) {
      case 'beige':
        return const Color(0xFFF5E6D3);
      case 'purple':
      case 'pink':
        return const Color(0xFFE8D5F2);
      default:
        return const Color(0xFF6A1B9A);
    }
  }
}