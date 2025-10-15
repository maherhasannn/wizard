import 'package:flutter/material.dart';
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
      body: SharedBackground(
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: _hexToColor('1B0A33'),
          border: Border(
            top: BorderSide(
              color: lightTextColor.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: purpleAccent,
          unselectedItemColor: lightTextColor.withOpacity(0.6),
          selectedLabelStyle: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 24,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.headphones,
                size: 24,
              ),
              label: 'Meditations',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_today,
                size: 24,
              ),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.people,
                size: 24,
              ),
              label: 'Networking',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderTab(String title, IconData icon, Color textColor) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: textColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            '$title Tab',
            style: GoogleFonts.dmSans(
              color: textColor.withOpacity(0.7),
              fontSize: 24,
              fontWeight: FontWeight.w300,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: GoogleFonts.dmSans(
              color: textColor.withOpacity(0.5),
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
