import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
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

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
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
            child: IndexedStack(
              index: _currentIndex,
              children: [
                // Tab 1: Main (formerly Home)
                MainTab(
                  selectedPowers: widget.selectedPowers,
                  powerOptions: widget.powerOptions,
                ),
                
                // Tab 2: Rituals (formerly Meditations)
                const RitualsTab(),
                
                // Tab 3: Challenge (formerly Calendar)
                const ChallengeTab(),
                
                // Tab 4: Circe (formerly Networking/Community)
                const CirceTab(),
              ],
            ),
          ),
          
          // Floating bottom navigation bar
          Positioned(
            left: 30,
            right: 30,
            bottom: 20,
            child: _buildFloatingNavBar(lightTextColor, purpleAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingNavBar(Color lightTextColor, Color purpleAccent) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, 0, lightTextColor, purpleAccent, 'Main'),
              _buildNavItem(Icons.music_note, 1, lightTextColor, purpleAccent, 'Rituals'),
              _buildNavItem(Icons.emoji_events, 2, lightTextColor, purpleAccent, 'Challenge'),
              _buildNavItem(Icons.people, 3, lightTextColor, purpleAccent, 'Circe'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, Color lightTextColor, Color purpleAccent, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? purpleAccent : Colors.transparent,
              boxShadow: isSelected ? [
                BoxShadow(
                  color: purpleAccent.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ] : null,
            ),
            child: Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.8),
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: isSelected ? lightTextColor : lightTextColor.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
