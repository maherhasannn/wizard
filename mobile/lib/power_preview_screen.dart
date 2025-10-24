import 'package:flutter/material.dart';
import 'shared_background.dart';
import 'plan_crafting_screen.dart';

class PowerPreviewScreen extends StatefulWidget {
  final List<String> selectedPowers;
  final List<Map<String, dynamic>> powerOptions;

  const PowerPreviewScreen({
    super.key,
    required this.selectedPowers,
    required this.powerOptions,
  });

  @override
  State<PowerPreviewScreen> createState() => _PowerPreviewScreenState();
}

class _PowerPreviewScreenState extends State<PowerPreviewScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  Map<String, dynamic> _getPowerData(String powerId) {
    return widget.powerOptions.firstWhere((power) => power['id'] == powerId);
  }

  List<Map<String, dynamic>> _getPreviewContent(String powerId) {
    switch (powerId) {
      case 'unbreakable_heart':
        return [
          {
            'title': 'Daily Audio Rituals',
            'subtitle': 'To heal and grow your inner strength.',
            'items': ['Morning Affirmations', 'Heart Healing Meditation', 'Self-Love Ritual'],
          },
          {
            'title': 'Healing Practices',
            'subtitle': 'Transform pain into power.',
            'items': ['Emotional Release Sessions', 'Trauma Healing Audio', 'Forgiveness Practice'],
          },
          {
            'title': 'Growth Modules',
            'subtitle': 'Unleash your glow up journey.',
            'items': ['Personal Development Plans', 'Mindset Shifts', 'Life Transformation'],
          },
        ];
      case 'unshakable_confidence':
        return [
          {
            'title': 'Daily Audio Rituals',
            'subtitle': 'To rewire your brain for god-tier self-worth.',
            'items': ['25-audio', 'Cutting the Cord Meditation', 'Affirmations for a Queen'],
          },
          {
            'title': 'Confidence Builders',
            'subtitle': 'Own every room you walk into.',
            'items': ['Power Pose Practice', 'Voice Activation', 'Body Language Mastery'],
          },
          {
            'title': 'Mindset Shifts',
            'subtitle': 'Transform your self-perception.',
            'items': ['Limiting Belief Removal', 'Success Visualization', 'Inner Critic Work'],
          },
        ];
      case 'magnetic_energy':
        return [
          {
            'title': 'Attraction Mastery',
            'subtitle': 'Become irresistible without trying.',
            'items': ['Energy Alignment', 'Vibration Raising', 'Magnetic Presence'],
          },
          {
            'title': 'Manifestation Rituals',
            'subtitle': 'Attract, don\'t chase.',
            'items': ['Desire Amplification', 'Law of Attraction Practice', 'Energy Clearing'],
          },
          {
            'title': 'Aura Enhancement',
            'subtitle': 'Radiate magnetic energy.',
            'items': ['Chakra Balancing', 'Energy Protection', 'Vibrational Alignment'],
          },
        ];
      case 'financial_empire':
        return [
          {
            'title': 'Wealth Mindset',
            'subtitle': 'Build the wealth you deserve.',
            'items': ['Money Mindset Shifts', 'Abundance Visualization', 'Wealth Affirmations'],
          },
          {
            'title': 'Financial Strategy',
            'subtitle': 'Practical wealth building.',
            'items': ['Investment Basics', 'Passive Income Plans', 'Financial Goal Setting'],
          },
          {
            'title': 'Business Development',
            'subtitle': 'Scale your empire.',
            'items': ['Entrepreneurial Mindset', 'Business Planning', 'Revenue Optimization'],
          },
        ];
      case 'sovereign_energy':
        return [
          {
            'title': 'Boundary Setting',
            'subtitle': 'Protect your peace fiercely.',
            'items': ['No-Guilt Boundaries', 'Energy Protection', 'Sacred Space Creation'],
          },
          {
            'title': 'Peace Practices',
            'subtitle': 'Maintain your sovereignty.',
            'items': ['Meditation Mastery', 'Stress Release', 'Inner Calm Techniques'],
          },
          {
            'title': 'Energy Management',
            'subtitle': 'Control your energy flow.',
            'items': ['Energy Boundaries', 'Vampire Protection', 'Sacred Energy Practices'],
          },
        ];
      default:
        return [
          {
            'title': 'Daily Practices',
            'subtitle': 'Transform your life step by step.',
            'items': ['Morning Rituals', 'Evening Reflection', 'Weekly Planning'],
          },
        ];
    }
  }

  void _continueToCrafting() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlanCraftingScreen(
          selectedPowers: widget.selectedPowers,
          powerOptions: widget.powerOptions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final buttonTextStyle = TextStyle(
      color: lightTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    // Get the first selected power for the title
    final firstPower = widget.selectedPowers.isNotEmpty
        ? _getPowerData(widget.selectedPowers[0])
        : null;

    return Scaffold(
      body: SharedBackground(
        bgColorHex: '1B0A33',
        child: SafeArea(
          child: Column(
            children: [
              // Header with back button and title
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: lightTextColor,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        firstPower?['title'] ?? 'Your Power Focus',
                        textAlign: TextAlign.center,
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              // Preview content with carousel
              Expanded(
                child: Column(
                  children: [
                    // PageView content
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemCount: widget.selectedPowers.length,
                        itemBuilder: (context, powerIndex) {
                          final powerId = widget.selectedPowers[powerIndex];
                          final powerData = _getPowerData(powerId);
                          final previewContent = _getPreviewContent(powerId);

                          return SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              children: [
                                // Embedded phone mockup
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 20),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: _hexToColor('2A1A4A'),
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
                                        'Meditations',
                                        style: TextStyle(
          fontFamily: 'DMSans',
                                          color: lightTextColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ...previewContent[0]['items'].map<Widget>((item) {
                                        return Padding(
                                          padding: const EdgeInsets.only(bottom: 4),
                                          child: Text(
                                            '• $item',
                                            style: TextStyle(
          fontFamily: 'DMSans',
                                              color: lightTextColor.withOpacity(0.8),
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),

                                // Main content sections
                                ...previewContent.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final content = entry.value;
                                  
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 20),
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: _hexToColor('6A1B9A').withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          content['title'],
                                          style: TextStyle(
          fontFamily: 'DMSans',
                                            color: lightTextColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          content['subtitle'],
                                          style: TextStyle(
          fontFamily: 'DMSans',
                                            color: lightTextColor.withOpacity(0.8),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        ...content['items'].map<Widget>((item) {
                                          return Padding(
                                            padding: const EdgeInsets.only(bottom: 6),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.check_circle_outline,
                                                  color: powerData['color'],
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    item,
                                                    style: TextStyle(
          fontFamily: 'DMSans',
                                                      color: lightTextColor.withOpacity(0.9),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Page indicators
                    if (widget.selectedPowers.length > 1)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.selectedPowers.length,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index == _currentPage
                                    ? lightTextColor
                                    : lightTextColor.withOpacity(0.3),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Create Plan Button
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continueToCrafting,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hexToColor('6A1B9A'),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Create My Personalized Plan',
                      style: buttonTextStyle,
                    ),
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
