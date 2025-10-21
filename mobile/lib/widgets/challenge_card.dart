import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/challenge.dart';
import '../screens/challenges_list_screen.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge? activeChallenge;
  final UserChallengeProgress? progress;

  const ChallengeCard({
    super.key,
    this.activeChallenge,
    this.progress,
  });

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChallengesListScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: purpleAccent.withOpacity(0.2),
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
                        activeChallenge != null ? 'Active Challenge' : 'Daily Challenges',
                        style: GoogleFonts.dmSans(
                          color: lightTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        activeChallenge != null 
                            ? activeChallenge!.title
                            : 'Take on a new challenge today',
                        style: GoogleFonts.dmSans(
                          color: lightTextColor.withOpacity(0.7),
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: lightTextColor.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
            
            if (activeChallenge != null && progress != null) ...[
              const SizedBox(height: 16),
              
              // Progress bar
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Day ${progress!.completedDays + 1} of ${activeChallenge!.duration}',
                          style: GoogleFonts.dmSans(
                            color: lightTextColor.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const SizedBox(height: 4),
                        LinearProgressIndicator(
                          value: progress!.completedDays / activeChallenge!.duration,
                          backgroundColor: lightTextColor.withOpacity(0.2),
                          valueColor: AlwaysStoppedAnimation<Color>(purpleAccent),
                          minHeight: 6,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: purpleAccent.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${((progress!.completedDays / activeChallenge!.duration) * 100).toInt()}%',
                      style: GoogleFonts.dmSans(
                        color: lightTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (activeChallenge == null) ...[
              const SizedBox(height: 16),
              
              // Available challenges preview
              Row(
                children: [
                  _buildChallengeTag('10 Days of Heartbreak Healing', lightTextColor),
                  const SizedBox(width: 8),
                  _buildChallengeTag('7 Days of Self-Confidence', lightTextColor),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChallengeTag(String title, Color lightTextColor) {
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
        title,
        style: GoogleFonts.dmSans(
          color: lightTextColor.withOpacity(0.8),
          fontSize: 10,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
