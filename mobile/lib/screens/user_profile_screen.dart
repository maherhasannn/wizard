import 'package:flutter/material.dart';
import '../models/network_user.dart';

class UserProfileScreen extends StatelessWidget {
  final NetworkUser user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

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
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
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
                    'Profile',
                    style: TextStyle(
          fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      // Share profile
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sharing ${user.name}\'s profile'),
                          backgroundColor: purpleAccent,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.share,
                      color: lightTextColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Profile content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Profile photo
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: lightTextColor.withOpacity(0.3),
                          width: 3,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: user.photoUrl.isNotEmpty
                            ? Image.asset(
                                user.photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderAvatar();
                                },
                              )
                            : _buildPlaceholderAvatar(),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Name and age
                    Text(
                      user.name,
                      style: TextStyle(
          fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Age and location
                    Text(
                      '${user.age} | ${user.locationString}',
                      style: TextStyle(
          fontFamily: 'DMSans',
                        color: lightTextColor.withOpacity(0.8),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Bio
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: purpleAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: lightTextColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About',
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            user.bio,
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor.withOpacity(0.9),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Interests
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: purpleAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: lightTextColor.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Interests',
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: user.interests.map((interest) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: lightTextColor.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: lightTextColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  interest,
                                  style: TextStyle(
          fontFamily: 'DMSans',
                                    color: lightTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Instagram link
                    if (user.instagram.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Opening ${user.instagram}'),
                                backgroundColor: purpleAccent,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purpleAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          icon: Icon(
                            Icons.camera_alt,
                            color: lightTextColor,
                            size: 20,
                          ),
                          label: Text(
                            user.instagram,
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 40),

                    // Action buttons
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          // Pass button
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: lightTextColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(25),
                                border: Border.all(
                                  color: lightTextColor.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => Navigator.pop(context),
                                  borderRadius: BorderRadius.circular(25),
                                  child: Center(
                                    child: Icon(
                                      Icons.close,
                                      color: lightTextColor.withOpacity(0.7),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          // Like button
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: purpleAccent,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: purpleAccent.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('You liked ${user.name}!'),
                                        backgroundColor: purpleAccent,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  },
                                  borderRadius: BorderRadius.circular(25),
                                  child: Center(
                                    child: Icon(
                                      Icons.favorite,
                                      color: lightTextColor,
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');
    
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            purpleAccent.withOpacity(0.8),
            purpleAccent.withOpacity(0.6),
          ],
        ),
      ),
      child: Center(
        child: Text(
          user.initials,
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 48,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
