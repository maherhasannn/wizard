import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');
    final darkPurple = _hexToColor('2D1B69');

    return Scaffold(
      backgroundColor: darkPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: lightTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'About the App',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo/Icon
            Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [purpleAccent, purpleAccent.withOpacity(0.6)],
                  ),
                ),
                child: Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // App Name
            Center(
              child: Text(
                'Wizard App',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Version
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Description
            Text(
              'About Wizard App',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 12),
            
            Text(
              'Wizard App is your personal companion for self-discovery, growth, and empowerment. Through guided meditations, tarot readings, self-love journeys, and exclusive content, we help you unlock your inner potential and create positive change in your life.',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor.withOpacity(0.8),
                fontSize: 16,
                height: 1.5,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Features
            Text(
              'Features',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildFeatureItem(
              icon: Icons.auto_awesome,
              title: 'Daily Tarot Readings',
              description: 'Get personalized guidance and insights',
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            _buildFeatureItem(
              icon: Icons.favorite,
              title: 'Self-Love Journey',
              description: '14-day guided journey to self-acceptance',
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            _buildFeatureItem(
              icon: Icons.headphones,
              title: 'Guided Meditations',
              description: 'Exclusive audio content for mindfulness',
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            _buildFeatureItem(
              icon: Icons.videocam,
              title: 'Exclusive Videos',
              description: 'Premium video content and tutorials',
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            const SizedBox(height: 32),
            
            // Creator Info
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: purpleAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: purpleAccent.withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.business,
                    color: purpleAccent,
                    size: 32,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Dedicated to empowering individuals through technology and mindfulness.',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Legal Links
            Text(
              'Legal',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildLegalLink(
              title: 'Privacy Policy',
              onTap: () => _openPrivacyPolicy(context),
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            _buildLegalLink(
              title: 'Terms of Service',
              onTap: () => _openTermsOfService(context),
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            _buildLegalLink(
              title: 'Cookie Policy',
              onTap: () => _openCookiePolicy(context),
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            const SizedBox(height: 32),
            
            // Contact
            Text(
              'Contact Us',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildContactItem(
              icon: Icons.email,
              text: 'support@appfyl.com',
              onTap: () => _openEmail(context),
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            _buildContactItem(
              icon: Icons.web,
              text: 'www.appfyl.com',
              onTap: () => _openWebsite(context),
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
    required Color lightTextColor,
    required Color purpleAccent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: lightTextColor.withOpacity(0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: purpleAccent.withOpacity(0.1),
            ),
            child: Icon(
              icon,
              color: purpleAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontSize: 16,
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
      ),
    );
  }

  Widget _buildLegalLink({
    required String title,
    required VoidCallback onTap,
    required Color lightTextColor,
    required Color purpleAccent,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 16,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: lightTextColor.withOpacity(0.5),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    required Color lightTextColor,
    required Color purpleAccent,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: lightTextColor.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: purpleAccent,
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPrivacyPolicy(BuildContext context) {
    // TODO: Implement privacy policy with proper security validation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy Policy coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _openTermsOfService(BuildContext context) {
    // TODO: Implement terms of service with proper security validation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terms of Service coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _openCookiePolicy(BuildContext context) {
    // TODO: Implement cookie policy with proper security validation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cookie Policy coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _openEmail(BuildContext context) {
    // TODO: Implement email opening with proper security validation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening email client...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _openWebsite(BuildContext context) {
    // TODO: Implement website opening with proper security validation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening website...'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
