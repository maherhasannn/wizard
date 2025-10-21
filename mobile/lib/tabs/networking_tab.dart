import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/discovery_methods_screen.dart';
import '../screens/search_screen.dart';

class NetworkingTab extends StatefulWidget {
  const NetworkingTab({super.key});

  @override
  State<NetworkingTab> createState() => _NetworkingTabState();
}

class _NetworkingTabState extends State<NetworkingTab> {
  bool _hasCompletedOnboarding = false; // In a real app, this would be stored persistently

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _startOnboarding() {
    // Navigate to onboarding flow
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NetworkingOnboardingScreen(),
      ),
    ).then((_) {
      // Mark onboarding as completed when user returns
      setState(() {
        _hasCompletedOnboarding = true;
      });
    });
  }

  void _goToDiscoveryMethods() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const DiscoveryMethodsScreen(),
      ),
    );
  }

  void _goToSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchScreen(),
      ),
    );
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Networking',
                    style: GoogleFonts.dmSans(
                      color: lightTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    onPressed: _goToSearch,
                    icon: Icon(
                      Icons.search,
                      color: lightTextColor,
                      size: 24,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              if (!_hasCompletedOnboarding) ...[
                // Onboarding prompt
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Welcome illustration
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              purpleAccent.withOpacity(0.3),
                              purpleAccent.withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.people,
                          color: lightTextColor.withOpacity(0.8),
                          size: 80,
                        ),
                      ),

                      const SizedBox(height: 40),

                      Text(
                        'Connect with Like-Minded Souls',
                        style: GoogleFonts.dmSans(
                          color: lightTextColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 16),

                      Text(
                        'Find your tribe and build meaningful connections with people who share your values and interests.',
                        style: GoogleFonts.dmSans(
                          color: lightTextColor.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const SizedBox(height: 60),

                      // Start button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _startOnboarding,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purpleAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Get Started',
                            style: GoogleFonts.dmSans(
                              color: lightTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                // Main networking interface
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Quick stats
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: purpleAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: lightTextColor.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem('24', 'Connections', lightTextColor),
                                  _buildStatItem('156', 'Profile Views', lightTextColor),
                                  _buildStatItem('8', 'New Matches', lightTextColor),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Discovery options
                        Text(
                          'How would you like to reach new friends?',
                          style: GoogleFonts.dmSans(
                            color: lightTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 30),

                        // Discovery method cards
                        _buildDiscoveryCard(
                          'Show on a Map',
                          'Find people near you on an interactive map',
                          Icons.map,
                          () => _goToDiscoveryMethods(),
                          lightTextColor,
                          purpleAccent,
                        ),
                        const SizedBox(height: 16),
                        _buildDiscoveryCard(
                          'By Filters',
                          'Search with specific criteria and preferences',
                          Icons.filter_list,
                          () => _goToDiscoveryMethods(),
                          lightTextColor,
                          purpleAccent,
                        ),
                        const SizedBox(height: 40), // Extra padding at bottom
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label, Color textColor) {
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.dmSans(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.dmSans(
            color: textColor.withOpacity(0.7),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoveryCard(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
    Color textColor,
    Color accentColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: accentColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: textColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.2),
              ),
              child: Icon(
                icon,
                color: textColor,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      color: textColor.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: textColor.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for onboarding screen - will be implemented next
class NetworkingOnboardingScreen extends StatelessWidget {
  const NetworkingOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTextColor = const Color(0xFFF0E6D8);
    
    return Scaffold(
      backgroundColor: const Color(0xFF1B0A33),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Onboarding Flow',
                style: GoogleFonts.dmSans(
                  color: lightTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'This will be implemented next',
                style: GoogleFonts.dmSans(
                  color: lightTextColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6A1B9A),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: GoogleFonts.dmSans(
                    color: lightTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
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
