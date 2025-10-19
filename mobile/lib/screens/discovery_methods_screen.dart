import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'swipe_cards_screen.dart';
import 'map_view_screen.dart';
import 'filter_search_screen.dart';

class DiscoveryMethodsScreen extends StatelessWidget {
  const DiscoveryMethodsScreen({super.key});

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Scaffold(
      backgroundColor: _hexToColor('1B0A33'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: lightTextColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'How would you like to reach new friends?',
                    style: GoogleFonts.dmSans(
                      color: lightTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // Discovery method cards
              Expanded(
                child: Column(
                  children: [
                    _buildDiscoveryCard(
                      context,
                      'Swipe Cards',
                      'Discover people through an intuitive swipe interface. Swipe right to connect, left to pass.',
                      Icons.swipe,
                      'assets/images/swipe_preview.jpg',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SwipeCardsScreen(),
                        ),
                      ),
                      lightTextColor,
                      purpleAccent,
                    ),
                    const SizedBox(height: 20),
                    _buildDiscoveryCard(
                      context,
                      'Show on a Map',
                      'Find people near you on an interactive map. See who\'s around and connect with locals.',
                      Icons.map,
                      'assets/images/map_preview.jpg',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MapViewScreen(),
                        ),
                      ),
                      lightTextColor,
                      purpleAccent,
                    ),
                    const SizedBox(height: 20),
                    _buildDiscoveryCard(
                      context,
                      'By Filters',
                      'Search with specific criteria and preferences. Find exactly the type of people you want to meet.',
                      Icons.filter_list,
                      'assets/images/filter_preview.jpg',
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FilterSearchScreen(),
                        ),
                      ),
                      lightTextColor,
                      purpleAccent,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDiscoveryCard(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    String imagePath,
    VoidCallback onTap,
    Color textColor,
    Color accentColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 160,
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: textColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Background image placeholder
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      accentColor.withOpacity(0.2),
                      accentColor.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentColor.withOpacity(0.3),
                    ),
                    child: Icon(
                      icon,
                      color: textColor,
                      size: 28,
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.dmSans(
                            color: textColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: GoogleFonts.dmSans(
                            color: textColor.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Arrow
                  Icon(
                    Icons.arrow_forward_ios,
                    color: textColor.withOpacity(0.5),
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
