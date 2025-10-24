import 'package:flutter/material.dart';
import 'dart:ui';
import '../shared_background.dart';
import '../services/self_love_journey_service.dart';
import 'self_love_journey_screen.dart';

class SelfLoveJourneyOnboardingScreen extends StatefulWidget {
  const SelfLoveJourneyOnboardingScreen({super.key});

  @override
  State<SelfLoveJourneyOnboardingScreen> createState() => _SelfLoveJourneyOnboardingScreenState();
}

class _SelfLoveJourneyOnboardingScreenState extends State<SelfLoveJourneyOnboardingScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  int _currentPage = 0;
  final PageController _pageController = PageController();

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return SharedBackground(
      bgColorHex: '1B0A33',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      // Skip button
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => _startJourney(),
                              child: Text(
                                'Skip',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  color: lightTextColor.withOpacity(0.7),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Page content
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          onPageChanged: (index) {
                            setState(() {
                              _currentPage = index;
                            });
                          },
                          children: [
                            _buildWelcomePage(lightTextColor, purpleAccent),
                            _buildJourneyOverviewPage(lightTextColor, purpleAccent),
                            _buildCommitmentPage(lightTextColor, purpleAccent),
                          ],
                        ),
                      ),
                      
                      // Page indicators and navigation
                      _buildBottomNavigation(lightTextColor, purpleAccent),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomePage(Color lightTextColor, Color purpleAccent) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Heart icon with animation
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.pink.withOpacity(0.8),
                  Colors.purple.withOpacity(0.6),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.withOpacity(0.4),
                  blurRadius: 30,
                  spreadRadius: 0,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 60,
            ),
          ),
          
          const SizedBox(height: 40),
          
          Text(
            'Welcome to Your\nSelf-Love Journey',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Text(
            'Over the next 14 days, you\'ll embark on a transformative journey of self-discovery, self-compassion, and deep self-love.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.8),
              fontSize: 18,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyOverviewPage(Color lightTextColor, Color purpleAccent) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Journey features
          _buildFeatureItem(
            Icons.calendar_today,
            '14 Days of Growth',
            'Each day brings new insights and practices',
            lightTextColor,
          ),
          
          const SizedBox(height: 30),
          
          _buildFeatureItem(
            Icons.self_improvement,
            'Daily Activities',
            'Guided exercises to build self-love',
            lightTextColor,
          ),
          
          const SizedBox(height: 30),
          
          _buildFeatureItem(
            Icons.edit_note,
            'Personal Reflections',
            'Space to process and grow',
            lightTextColor,
          ),
          
          const SizedBox(height: 30),
          
          _buildFeatureItem(
            Icons.trending_up,
            'Track Your Progress',
            'See your journey unfold day by day',
            lightTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description, Color lightTextColor) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Icon(
            icon,
            color: lightTextColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommitmentPage(Color lightTextColor, Color purpleAccent) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.handshake,
              color: lightTextColor,
              size: 50,
            ),
          ),
          
          const SizedBox(height: 40),
          
          Text(
            'Are You Ready to\nCommit to Yourself?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          
          const SizedBox(height: 20),
          
          Text(
            'This journey requires dedication, honesty, and openness to growth. You\'ll be asked to reflect deeply, practice self-compassion, and commit to daily activities.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.8),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          
          const SizedBox(height: 30),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Your Commitment',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'I commit to showing up for myself every day for the next 14 days. I will be gentle with myself, honest in my reflections, and open to growth.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor.withOpacity(0.9),
                    fontSize: 14,
                    height: 1.4,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation(Color lightTextColor, Color purpleAccent) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index 
                    ? purpleAccent 
                    : Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          
          const SizedBox(height: 30),
          
          // Navigation buttons
          Row(
            children: [
              if (_currentPage > 0)
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor.withOpacity(0.7),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              
              if (_currentPage > 0) const SizedBox(width: 20),
              
              Expanded(
                flex: _currentPage == 0 ? 1 : 2,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _currentPage == 2 ? _startJourney : _nextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purpleAccent,
                      foregroundColor: lightTextColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage == 2 ? 'Start My Journey' : 'Next',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _startJourney() {
    SelfLoveJourneyService().initializeJourney();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const SelfLoveJourneyScreen(),
      ),
    );
  }
}
