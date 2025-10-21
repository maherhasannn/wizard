import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../shared_background.dart';
import '../providers/user_provider.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WhyYouCameScreen extends StatefulWidget {
  const WhyYouCameScreen({super.key});

  @override
  State<WhyYouCameScreen> createState() => _WhyYouCameScreenState();
}

class _WhyYouCameScreenState extends State<WhyYouCameScreen> {
  final List<String> _selectedReasons = [];
  
  final List<Map<String, dynamic>> _reasonOptions = [
    {'id': 'heartbreak', 'title': 'Healing from heartbreak', 'icon': Icons.favorite_border},
    {'id': 'confidence', 'title': 'Build confidence', 'icon': Icons.psychology},
    {'id': 'stress', 'title': 'Reduce stress', 'icon': Icons.spa},
    {'id': 'love', 'title': 'Find love', 'icon': Icons.favorite},
    {'id': 'growth', 'title': 'Personal growth', 'icon': Icons.trending_up},
    {'id': 'anxiety', 'title': 'Manage anxiety', 'icon': Icons.self_improvement},
    {'id': 'sleep', 'title': 'Better sleep', 'icon': Icons.bedtime},
    {'id': 'focus', 'title': 'Improve focus', 'icon': Icons.center_focus_strong},
  ];

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _toggleReason(String reasonId) {
    setState(() {
      if (_selectedReasons.contains(reasonId)) {
        _selectedReasons.remove(reasonId);
      } else {
        _selectedReasons.add(reasonId);
      }
    });
  }

  void _continueToAuth() {
    if (_selectedReasons.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select at least one reason',
            style: GoogleFonts.dmSans(color: Colors.white),
          ),
          backgroundColor: _hexToColor('6A1B9A'),
        ),
      );
      return;
    }

    // Save reasons to user provider or local storage
    final userProvider = context.read<UserProvider>();
    userProvider.updateOnboardingReasons(_selectedReasons);

    // Navigate to auth selection
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildAuthSelectionSheet(),
    );
  }

  Widget _buildAuthSelectionSheet() {
    final lightTextColor = _hexToColor('F0E6D8');
    final bgColor = _hexToColor('1B0A33');

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: lightTextColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            
            Text(
              'How would you like to continue?',
              style: GoogleFonts.dmSans(
                color: lightTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to your account or create a new one',
              style: GoogleFonts.dmSans(
                color: lightTextColor.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Sign In Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _hexToColor('6A1B9A'),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Sign In',
                  style: GoogleFonts.dmSans(
                    color: lightTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // Sign Up Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: _hexToColor('6A1B9A')),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Create Account',
                  style: GoogleFonts.dmSans(
                    color: _hexToColor('6A1B9A'),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Scaffold(
      body: SharedBackground(
        bgColorHex: '1B0A33',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                
                // Header
                Text(
                  'Why did you download\nthe LIZ app?',
                  style: GoogleFonts.dmSans(
                    color: lightTextColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select all that apply to personalize your experience',
                  style: GoogleFonts.dmSans(
                    color: lightTextColor.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 40),
                
                // Reason options
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _reasonOptions.length,
                    itemBuilder: (context, index) {
                      final option = _reasonOptions[index];
                      final isSelected = _selectedReasons.contains(option['id']);
                      
                      return GestureDetector(
                        onTap: () => _toggleReason(option['id']),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? purpleAccent.withOpacity(0.3)
                                : purpleAccent.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected 
                                  ? purpleAccent
                                  : lightTextColor.withOpacity(0.2),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  option['icon'],
                                  color: isSelected 
                                      ? purpleAccent
                                      : lightTextColor.withOpacity(0.7),
                                  size: 32,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  option['title'],
                                  style: GoogleFonts.dmSans(
                                    color: isSelected 
                                        ? lightTextColor
                                        : lightTextColor.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continueToAuth,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purpleAccent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.dmSans(
                        color: lightTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
