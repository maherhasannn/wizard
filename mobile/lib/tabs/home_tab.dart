import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../message_of_day_flow.dart';
import '../widgets/video_section.dart';
import '../widgets/live_stream_widget.dart';
import '../widgets/affirmation_card.dart';
import '../widgets/ai_liz_widget.dart';
import '../widgets/challenge_card.dart';

class HomeTab extends StatelessWidget {
  final List<String> selectedPowers;
  final List<Map<String, dynamic>> powerOptions;

  const HomeTab({
    super.key,
    required this.selectedPowers,
    required this.powerOptions,
  });

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
              // Header with welcome and profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          'Welcome back ',
                          style: GoogleFonts.dmSans(
                            color: lightTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Gabriella!',
                          style: GoogleFonts.dmSans(
                            color: lightTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.waving_hand,
                          color: Colors.yellow,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: purpleAccent.withOpacity(0.3),
                      border: Border.all(
                        color: lightTextColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      color: lightTextColor,
                      size: 20,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Message of the Day Section
              MessageOfDayFlow(),

              const SizedBox(height: 30),

              // AI Liz Section
              const AiLizWidget(),

              const SizedBox(height: 30),

              // Challenges Section
              const ChallengeCard(),

              const SizedBox(height: 30),

              // Video Section
              VideoSection(),

              const SizedBox(height: 30),

              // Affirmation of the Day Section
              AffirmationCard(),

              const SizedBox(height: 30),

              // Live Stream Section
              LiveStreamWidget(),

              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }
}
