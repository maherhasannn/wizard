import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared_background.dart';
import '../models/challenge.dart';

class ChallengesListScreen extends StatefulWidget {
  const ChallengesListScreen({super.key});

  @override
  State<ChallengesListScreen> createState() => _ChallengesListScreenState();
}

class _ChallengesListScreenState extends State<ChallengesListScreen> {
  // Mock data for now
  final List<Challenge> _challenges = [
    Challenge(
      id: '1',
      title: '10 Days of Heartbreak Healing',
      description: 'A guided journey to heal your heart and rediscover your strength. Each day brings new insights and healing practices.',
      duration: 10,
      isActive: true,
      tags: ['healing', 'heartbreak', 'self-love'],
    ),
    Challenge(
      id: '2',
      title: '7 Days of Self-Confidence',
      description: 'Build unshakeable confidence through daily affirmations, exercises, and mindful practices that celebrate your unique worth.',
      duration: 7,
      isActive: true,
      tags: ['confidence', 'self-esteem', 'growth'],
    ),
    Challenge(
      id: '3',
      title: '21 Days of Mindfulness',
      description: 'Develop a consistent mindfulness practice that brings peace, clarity, and presence to every moment of your day.',
      duration: 21,
      isActive: true,
      tags: ['mindfulness', 'meditation', 'peace'],
    ),
    Challenge(
      id: '4',
      title: '14 Days of Gratitude',
      description: 'Transform your perspective through daily gratitude practices that help you see the beauty and abundance in your life.',
      duration: 14,
      isActive: true,
      tags: ['gratitude', 'positivity', 'mindset'],
    ),
    Challenge(
      id: '5',
      title: '30 Days of Love Manifestation',
      description: 'Attract love into your life through intentional practices, self-discovery, and opening your heart to new possibilities.',
      duration: 30,
      isActive: true,
      tags: ['love', 'manifestation', 'relationships'],
    ),
  ];

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _joinChallenge(Challenge challenge) {
    // TODO: Implement joining challenge
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Joined "${challenge.title}" challenge!',
          style: GoogleFonts.dmSans(color: Colors.white),
        ),
        backgroundColor: _hexToColor('6A1B9A'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Scaffold(
      body: SharedBackground(
        bgColorHex: '1B0A33',
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: purpleAccent.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: lightTextColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: lightTextColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Daily Challenges',
                            style: GoogleFonts.dmSans(
                              color: lightTextColor,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Transform your life one day at a time',
                            style: GoogleFonts.dmSans(
                              color: lightTextColor.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Challenges list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: _challenges.length,
                  itemBuilder: (context, index) {
                    final challenge = _challenges[index];
                    return _buildChallengeCard(challenge, lightTextColor, purpleAccent);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChallengeCard(Challenge challenge, Color lightTextColor, Color purpleAccent) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: purpleAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: lightTextColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [purpleAccent, _hexToColor('8E24AA')],
                  ),
                ),
                child: const Icon(
                  Icons.emoji_events,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      challenge.title,
                      style: GoogleFonts.dmSans(
                        color: lightTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${challenge.duration} days',
                      style: GoogleFonts.dmSans(
                        color: lightTextColor.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Description
          Text(
            challenge.description,
            style: GoogleFonts.dmSans(
              color: lightTextColor.withOpacity(0.8),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.4,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: challenge.tags.map((tag) => _buildTag(tag, lightTextColor)).toList(),
          ),
          
          const SizedBox(height: 20),
          
          // Join button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _joinChallenge(challenge),
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Join Challenge',
                style: GoogleFonts.dmSans(
                  color: lightTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag, Color lightTextColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: lightTextColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: lightTextColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Text(
        tag,
        style: GoogleFonts.dmSans(
          color: lightTextColor.withOpacity(0.8),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
