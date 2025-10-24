import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

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
          'Support',
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
            // Header
            Text(
              'How can we help you?',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'We\'re here to support you on your journey.',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Contact methods
            _buildContactMethod(
              icon: Icons.email_outlined,
              title: 'Email Support',
              subtitle: 'Get help via email',
              onTap: () => _openEmailSupport(context),
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            const SizedBox(height: 16),
            
            _buildContactMethod(
              icon: Icons.chat_bubble_outline,
              title: 'Live Chat',
              subtitle: 'Chat with our support team',
              onTap: () => _openLiveChat(context),
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            const SizedBox(height: 16),
            
            _buildContactMethod(
              icon: Icons.help_outline,
              title: 'FAQ',
              subtitle: 'Find answers to common questions',
              onTap: () => _openFAQ(context),
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            const SizedBox(height: 32),
            
            // FAQ Section
            Text(
              'Frequently Asked Questions',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            
            const SizedBox(height: 16),
            
            _buildFAQItem(
              question: 'How do I cancel my subscription?',
              answer: 'You can cancel your subscription from the Subscription Details screen in your profile menu.',
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            _buildFAQItem(
              question: 'How do I restore my purchases?',
              answer: 'Use the "Restore Purchases" option in your profile menu to restore any previous purchases.',
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            _buildFAQItem(
              question: 'How do I update my payment method?',
              answer: 'Go to Subscription Details and tap "Update Payment Method" to change your payment information.',
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            _buildFAQItem(
              question: 'How do I delete my account?',
              answer: 'Contact our support team to request account deletion. This action cannot be undone.',
              lightTextColor: lightTextColor,
              purpleAccent: purpleAccent,
            ),
            
            const SizedBox(height: 32),
            
            // Response time
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: purpleAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: purpleAccent.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.schedule,
                    color: purpleAccent,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Response Time',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            color: lightTextColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'We typically respond within 24 hours',
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactMethod({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color lightTextColor,
    required Color purpleAccent,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: lightTextColor.withOpacity(0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: purpleAccent.withOpacity(0.1),
              ),
              child: Icon(
                icon,
                color: purpleAccent,
                size: 24,
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
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
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

  Widget _buildFAQItem({
    required String question,
    required String answer,
    required Color lightTextColor,
    required Color purpleAccent,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: lightTextColor.withOpacity(0.1),
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor.withOpacity(0.8),
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
        iconColor: purpleAccent,
        collapsedIconColor: lightTextColor.withOpacity(0.5),
      ),
    );
  }

  void _openEmailSupport(BuildContext context) {
    // TODO: Implement email support with proper security validation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Email support: support@appfyl.com'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _openLiveChat(BuildContext context) {
    // TODO: Implement live chat with proper security validation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Live chat coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _openFAQ(BuildContext context) {
    // TODO: Implement FAQ screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('FAQ screen coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
