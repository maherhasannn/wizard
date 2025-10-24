import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../providers/subscription_provider.dart';
import '../models/user.dart';
import '../screens/edit_profile_screen.dart';
import '../screens/subscription_details_screen.dart';
import '../screens/support_screen.dart';
import '../screens/about_screen.dart';
import '../widgets/secure_profile_menu_item.dart';

class ProfileMenuScreen extends StatefulWidget {
  const ProfileMenuScreen({super.key});

  @override
  State<ProfileMenuScreen> createState() => _ProfileMenuScreenState();
}

class _ProfileMenuScreenState extends State<ProfileMenuScreen> {
  @override
  void initState() {
    super.initState();
    // Load subscription data when menu opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SubscriptionProvider>(context, listen: false).loadCurrentSubscription();
    });
  }

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
      body: SafeArea(
        child: Consumer3<AuthProvider, UserProvider, SubscriptionProvider>(
          builder: (context, authProvider, userProvider, subscriptionProvider, child) {
            final user = authProvider.user;
            final isProUser = subscriptionProvider.isProUser;

            // SECURITY: Verify user is authenticated before showing profile data
            if (!authProvider.isAuthenticated || user == null) {
              return const Center(
                child: Text(
                  'Authentication required',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Header with close button
                    _buildHeader(lightTextColor),
                    
                    const SizedBox(height: 30),
                    
                    // Profile section
                    _buildProfileSection(user, isProUser, lightTextColor, purpleAccent),
                    
                    const SizedBox(height: 40),
                    
                    // Menu items
                    _buildMenuItems(lightTextColor, purpleAccent),
                    
                    const SizedBox(height: 40),
                    
                    // Footer
                    _buildFooter(lightTextColor),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(Color lightTextColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 40), // Balance the close button
        Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: Icon(
              Icons.close,
              color: lightTextColor,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileSection(User user, bool isProUser, Color lightTextColor, Color purpleAccent) {
    return Column(
      children: [
        // Profile picture with PRO badge
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: lightTextColor.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: user.profilePhoto != null
                    ? Image.network(
                        user.profilePhoto!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildDefaultProfilePicture(lightTextColor);
                        },
                      )
                    : _buildDefaultProfilePicture(lightTextColor),
              ),
            ),
            if (isProUser)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [purpleAccent, purpleAccent.withOpacity(0.8)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'PRO',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // User name
        Text(
          user.fullName,
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Edit profile button
        GestureDetector(
          onTap: () => _navigateToEditProfile(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.edit,
                color: lightTextColor,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Edit profile',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultProfilePicture(Color lightTextColor) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[300],
      ),
      child: Icon(
        Icons.person,
        color: Colors.grey[600],
        size: 48,
      ),
    );
  }

  Widget _buildMenuItems(Color lightTextColor, Color purpleAccent) {
    return Column(
      children: [
        // Subscription details
        SecureProfileMenuItem(
          icon: Icons.headphones,
          title: 'Subscription details',
          onTap: () => _navigateToSubscriptionDetails(),
          lightTextColor: lightTextColor,
          purpleAccent: purpleAccent,
        ),
        
        const SizedBox(height: 1),
        
        // Support
        SecureProfileMenuItem(
          icon: Icons.headphones,
          title: 'Reach the support',
          onTap: () => _navigateToSupport(),
          lightTextColor: lightTextColor,
          purpleAccent: purpleAccent,
        ),
        
        const SizedBox(height: 1),
        
        // About the app
        SecureProfileMenuItem(
          icon: Icons.info_outline,
          title: 'About the app',
          onTap: () => _navigateToAbout(),
          lightTextColor: lightTextColor,
          purpleAccent: purpleAccent,
        ),
        
        const SizedBox(height: 1),
        
        // Rate the app
        SecureProfileMenuItem(
          icon: Icons.thumb_up_outlined,
          title: 'Rate the app',
          onTap: () => _rateApp(),
          lightTextColor: lightTextColor,
          purpleAccent: purpleAccent,
        ),
        
        const SizedBox(height: 1),
        
        // Restore purchases
        SecureProfileMenuItem(
          icon: Icons.shopping_basket_outlined,
          title: 'Restore purchases',
          onTap: () => _restorePurchases(),
          lightTextColor: lightTextColor,
          purpleAccent: purpleAccent,
        ),
        
        const SizedBox(height: 1),
        
        // Log out
        SecureProfileMenuItem(
          icon: Icons.logout,
          title: 'Log out',
          onTap: () => _showLogoutConfirmation(),
          lightTextColor: lightTextColor,
          purpleAccent: purpleAccent,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildFooter(Color lightTextColor) {
    return Column(
      children: [
        const SizedBox(height: 20),
      ],
    );
  }

  // Navigation methods with security considerations
  void _navigateToEditProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
  }

  void _navigateToSubscriptionDetails() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SubscriptionDetailsScreen(),
      ),
    );
  }

  void _navigateToSupport() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SupportScreen(),
      ),
    );
  }

  void _navigateToAbout() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AboutScreen(),
      ),
    );
  }

  void _rateApp() {
    // SECURITY: This opens external app store - ensure it's secure
    // In a real implementation, you'd use url_launcher with proper validation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Opening app store...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _restorePurchases() {
    // SECURITY: This handles sensitive purchase data
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: _hexToColor('2D1B69'),
        title: Text(
          'Restore Purchases',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: _hexToColor('F0E6D8'),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'This will restore any previous purchases associated with your account.',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: _hexToColor('F0E6D8'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: _hexToColor('F0E6D8').withOpacity(0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await subscriptionProvider.restorePurchases();
              if (subscriptionProvider.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(subscriptionProvider.error!),
                    backgroundColor: Colors.red,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Purchases restored successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text(
              'Restore',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: _hexToColor('6A1B9A'),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation() {
    // SECURITY: This is a critical security action - require confirmation
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: _hexToColor('2D1B69'),
        title: Text(
          'Log Out',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: _hexToColor('F0E6D8'),
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to log out? You will need to sign in again to access your account.',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: _hexToColor('F0E6D8'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: _hexToColor('F0E6D8').withOpacity(0.7),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _performSecureLogout();
            },
            child: Text(
              'Log Out',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _performSecureLogout() async {
    // SECURITY: Perform secure logout with proper cleanup
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final subscriptionProvider = Provider.of<SubscriptionProvider>(context, listen: false);
    
    try {
      // Clear sensitive subscription data
      subscriptionProvider.clearData();
      
      // Perform logout (this will clear tokens and user data)
      await authProvider.logout();
      
      // Navigate back to login/onboarding
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/intro',
        (route) => false,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged out successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
