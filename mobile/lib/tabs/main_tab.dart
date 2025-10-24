import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tarot_service.dart';
import '../widgets/tarot_card_widget.dart';
import '../providers/auth_provider.dart';

class MainTab extends StatefulWidget {
  final List<String> selectedPowers;
  final List<Map<String, dynamic>> powerOptions;

  const MainTab({
    super.key,
    required this.selectedPowers,
    required this.powerOptions,
  });

  @override
  State<MainTab> createState() => _MainTabState();
}

class _MainTabState extends State<MainTab> {
  final TarotService _tarotService = TarotService();

  @override
  void initState() {
    super.initState();
    _tarotService.addListener(_onTarotServiceChanged);
  }

  @override
  void dispose() {
    _tarotService.removeListener(_onTarotServiceChanged);
    super.dispose();
  }

  void _onTarotServiceChanged() {
    setState(() {
      // Rebuild when tarot service state changes
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
    final authProvider = Provider.of<AuthProvider>(context);
    final userFirstName = authProvider.user?.firstName ?? 'User';

    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with profile and settings
                  _buildHeader(lightTextColor, purpleAccent, userFirstName),
                  
                  const SizedBox(height: 30),
                  
                  // Affirmation Card
                  _buildAffirmationCard(lightTextColor, purpleAccent),
            
                  const SizedBox(height: 30),
                  
                  // Challenge Section
                  _buildChallengeSection(lightTextColor, purpleAccent),
                  
                  const SizedBox(height: 30),
                  
                  // Ritual Section
                  _buildRitualSection(lightTextColor, purpleAccent),
                  
                  const SizedBox(height: 30),
                  
                  // Action Step
                  _buildActionStep(lightTextColor, purpleAccent),
                  
                  const SizedBox(height: 30),
                  
                  // Mood Tracking
                  _buildMoodTracking(lightTextColor, purpleAccent),
                  
                  const SizedBox(height: 30),
                  
                  // Exclusive Videos
                  _buildExclusiveVideos(lightTextColor, purpleAccent),
                  
                  const SizedBox(height: 30),
                  
                  // Featured Ritual
                  _buildFeaturedRitual(lightTextColor, purpleAccent),
                  
                  const SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
            ),
          ),
          // Tarot card overlay
          if (_tarotService.isRevealed && _tarotService.currentCard != null)
            TarotCardWidget(
              tarotCard: _tarotService.currentCard!,
              isFirstLoadOfDay: _tarotService.isFirstLoadOfDay,
              onClose: () {
                _tarotService.reset();
              },
              onGrabNewMessage: () {
                _tarotService.grabNewMessage();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color lightTextColor, Color purpleAccent, String userFirstName) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Text(
                'Welcome back ',
                style: TextStyle(
          fontFamily: 'DMSans',
                  fontWeight: FontWeight.w400,
                  color: lightTextColor,
                  fontSize: 20,
                ),
              ),
              Text(
                '$userFirstName!',
                style: TextStyle(
          fontFamily: 'DMSans',
                  fontWeight: FontWeight.w600,
                  color: lightTextColor,
                  fontSize: 20,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.auto_awesome,
                color: lightTextColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.auto_awesome,
                color: lightTextColor,
                size: 16,
              ),
            ],
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: lightTextColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/profile_placeholder.png',
              width: 40,
              height: 40,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAffirmationCard(Color lightTextColor, Color purpleAccent) {
    final now = DateTime.now();
    final dateStr = '${now.day} ${_getMonthName(now.month)} ${now.year}';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            purpleAccent.withOpacity(0.8),
            purpleAccent.withOpacity(0.6),
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
          Text(
            "LIZ'S AFFIRMATION",
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unlock your message of the day',
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Unique for $dateStr',
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              _tarotService.revealAdvice();
              setState(() {
                // Trigger rebuild to show tarot card
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: lightTextColor,
                  width: 1.5,
                ),
              ),
              child: Text(
                'Open',
                style: TextStyle(
          fontFamily: 'DMSans',
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

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }

  Widget _buildChallengeSection(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHALLENGE',
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: purpleAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: lightTextColor.withOpacity(0.1),
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
                      '14-Day Self-Love Journey',
                      style: TextStyle(
          fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'A daily journey to rebuild your confidence step by step.',
                      style: TextStyle(
          fontFamily: 'DMSans',
                        color: lightTextColor.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    '4/21',
                    style: TextStyle(
          fontFamily: 'DMSans',
                      color: lightTextColor.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: lightTextColor.withOpacity(0.5),
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRitualSection(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'RITUAL',
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: purpleAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: lightTextColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [purpleAccent, purpleAccent.withOpacity(0.6)],
                  ),
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
                      'The power to choose',
                      style: TextStyle(
          fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '1 min 15 sec • Text',
                      style: TextStyle(
          fontFamily: 'DMSans',
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
        ),
      ],
    );
  }

  Widget _buildActionStep(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'YOUR ACTION STEP',
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: purpleAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: lightTextColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_box_outline_blank,
                color: lightTextColor.withOpacity(0.5),
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Stand in front of the mirror and say out loud: "I choose myself." Repeat it three times with eye contact, even if it feels uncomfortable.',
                  style: TextStyle(
          fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodTracking(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling today?',
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildMoodButton('Great', lightTextColor, purpleAccent, true),
            const SizedBox(width: 12),
            _buildMoodButton('Good', lightTextColor, purpleAccent, false),
            const SizedBox(width: 12),
            _buildMoodButton('Okay', lightTextColor, purpleAccent, false),
            const SizedBox(width: 12),
            _buildMoodButton('Not good', lightTextColor, purpleAccent, false),
          ],
        ),
      ],
    );
  }

  Widget _buildMoodButton(String mood, Color lightTextColor, Color purpleAccent, bool isSelected) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? purpleAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? purpleAccent : lightTextColor.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? lightTextColor : _getMoodColor(mood),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              mood,
              style: TextStyle(
          fontFamily: 'DMSans',
                color: isSelected ? lightTextColor : lightTextColor.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(String mood) {
    switch (mood) {
      case 'Great': return Colors.red;
      case 'Good': return Colors.yellow;
      case 'Okay': return Colors.blue;
      case 'Not good': return Colors.red.shade800;
      default: return Colors.grey;
    }
  }

  Widget _buildExclusiveVideos(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Exclusive Videos',
              style: TextStyle(
          fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: lightTextColor.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      purpleAccent.withOpacity(0.8),
                      purpleAccent.withOpacity(0.4),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          color: lightTextColor.withOpacity(0.1),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_filled,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            index == 0 ? 'How to Overcoming Fear' : 
                            index == 1 ? 'Magnetic Energy Reset' : 'Inner Peace Journey',
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            index == 0 ? '5 min' : index == 1 ? '12 min' : '8 min',
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedRitual(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Ritual',
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 60,
                height: 60,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      purpleAccent.withOpacity(0.8),
                      purpleAccent.withOpacity(0.4),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}