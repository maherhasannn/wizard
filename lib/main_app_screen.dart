import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import 'shared_background.dart';
import 'tabs/home_tab.dart';
import 'tabs/meditations_tab.dart';
import 'tabs/calendar_tab.dart';
import 'tabs/networking_tab.dart';

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
                // Tab 1: Home/Dashboard
                HomeTab(
                  selectedPowers: widget.selectedPowers,
                  powerOptions: widget.powerOptions,
                ),
                
                // Tab 2: Meditations
                const MeditationsTab(),
                
                // Tab 3: Calendar
                const CalendarTab(),
                
                // Tab 4: Networking
                const NetworkingTab(),
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
            color: purpleAccent.withOpacity(0.3),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: lightTextColor.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavItem(Icons.home, 0, lightTextColor, purpleAccent),
              _buildNavItem(Icons.headphones, 1, lightTextColor, purpleAccent),
              _buildNavItem(Icons.star, 2, lightTextColor, purpleAccent),
              _buildNavItem(Icons.language, 3, lightTextColor, purpleAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, Color lightTextColor, Color purpleAccent) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
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
          color: isSelected ? lightTextColor : lightTextColor.withOpacity(0.6),
          size: 24,
        ),
      ),
    );
  }
}
