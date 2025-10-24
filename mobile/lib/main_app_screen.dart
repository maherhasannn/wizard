import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'shared_background.dart';
import 'tabs/main_tab.dart';
import 'tabs/rituals_tab.dart';
import 'tabs/challenge_tab.dart';
import 'tabs/circe_tab.dart';

class MainAppScreen extends StatefulWidget {
  final List<String> selectedPowers;
  final List<Map<String, dynamic>> powerOptions;

  const MainAppScreen({
    super.key,
    required this.selectedPowers,
    required this.powerOptions,
  });

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _bubbleController;
  late AnimationController _transitionController;
  late Animation<double> _bubbleAnimation;
  late Animation<double> _transitionAnimation;
  
  // Gesture tracking
  double _dragStartX = 0.0;
  double _dragCurrentX = 0.0;
  bool _isDragging = false;
  
  // Tab data
  final List<Map<String, dynamic>> _tabs = [
    {'icon': Icons.home, 'label': 'Main', 'color': 0xFF6A1B9A},
    {'icon': Icons.music_note, 'label': 'Rituals', 'color': 0xFF9C27B0},
    {'icon': Icons.emoji_events, 'label': 'Challenge', 'color': 0xFFE91E63},
    {'icon': Icons.people, 'label': 'Circe', 'color': 0xFF3F51B5},
  ];

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _bubbleController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _bubbleAnimation = CurvedAnimation(
      parent: _bubbleController,
      curve: Curves.elasticOut,
    );
    
    _transitionAnimation = CurvedAnimation(
      parent: _transitionController,
      curve: Curves.easeInOut,
    );
    
    _bubbleController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _bubbleController.dispose();
    _transitionController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      _bubbleController.reset();
      _bubbleController.forward();
    }
  }

  void _onPageChanged(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      _bubbleController.reset();
      _bubbleController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Scaffold(
      body: Stack(
        children: [
          SharedBackground(
            bgColorHex: '1B0A33',
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: 4,
              itemBuilder: (context, index) {
                // Lazy load pages for better performance
                switch (index) {
                  case 0:
                    return MainTab(
                      selectedPowers: widget.selectedPowers,
                      powerOptions: widget.powerOptions,
                    );
                  case 1:
                    return const RitualsTab();
                  case 2:
                    return const ChallengeTab();
                  case 3:
                    return const CirceTab();
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
          ),
          
          // Apple-style liquid glass navigation bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 30,
            child: _buildAppleLiquidGlassNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppleLiquidGlassNavBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_tabs.length, (index) {
                return _buildLiquidGlassTab(index);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLiquidGlassTab(int index) {
    final tab = _tabs[index];
    final isSelected = _currentIndex == index;
    final tabColor = Color(tab['color']);
    
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) {
          _bubbleController.reset();
          _bubbleController.forward();
        },
        onTap: () => _onTabSelected(index),
        child: Container(
          height: 80,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Liquid glass bubble
              AnimatedBuilder(
                animation: _bubbleAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isSelected ? 1.0 + (_bubbleAnimation.value * 0.1) : 1.0,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: isSelected ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            tabColor.withOpacity(0.9),
                            tabColor.withOpacity(0.7),
                            tabColor.withOpacity(0.8),
                          ],
                        ) : null,
                        boxShadow: isSelected ? [
                          BoxShadow(
                            color: tabColor.withOpacity(0.6),
                            blurRadius: 20,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                          BoxShadow(
                            color: Colors.white.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, -2),
                          ),
                        ] : [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.1),
                            blurRadius: 8,
                            spreadRadius: 0,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: isSelected ? 8.0 : 3.0, 
                            sigmaY: isSelected ? 8.0 : 3.0
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected 
                                  ? Colors.white.withOpacity(0.4)
                                  : Colors.white.withOpacity(0.1),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Icon(
                              tab['icon'],
                              color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
