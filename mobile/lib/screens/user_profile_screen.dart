import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/network_user.dart';
import '../providers/networking_provider.dart';

class UserProfileScreen extends StatefulWidget {
  final NetworkUser user;

  const UserProfileScreen({
    super.key,
    required this.user,
  });

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Consumer<NetworkingProvider>(
      builder: (context, networkingProvider, child) {
        final isConnected = networkingProvider.isUserConnected(widget.user.id);
        final connectionStatus = networkingProvider.getConnectionStatus(widget.user.id);

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
                          content: Text('Sharing ${widget.user.name}\'s profile'),
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
                        child: widget.user.photoUrl.isNotEmpty
                            ? Image.asset(
                                widget.user.photoUrl,
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
                      widget.user.name,
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
                      '${widget.user.age} | ${widget.user.locationString}',
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
                            widget.user.bio,
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
                            children: widget.user.interests.map((interest) {
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
                    if (widget.user.instagram.isNotEmpty)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Opening ${widget.user.instagram}'),
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
                            widget.user.instagram,
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

                          // Connect/Like button
                          Expanded(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: isConnected 
                                    ? Colors.green 
                                    : connectionStatus == 'PENDING'
                                        ? Colors.orange
                                        : purpleAccent,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  BoxShadow(
                                    color: (isConnected 
                                        ? Colors.green 
                                        : connectionStatus == 'PENDING'
                                            ? Colors.orange
                                            : purpleAccent).withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () => _handleConnectionAction(networkingProvider),
                                  borderRadius: BorderRadius.circular(25),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          isConnected 
                                              ? Icons.check
                                              : connectionStatus == 'PENDING'
                                                  ? Icons.hourglass_empty
                                                  : Icons.favorite,
                                          color: lightTextColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          isConnected 
                                              ? 'Connected'
                                              : connectionStatus == 'PENDING'
                                                  ? 'Pending'
                                                  : 'Connect',
                                          style: TextStyle(
                                            fontFamily: 'DMSans',
                                            color: lightTextColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
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
      },
    );
  }

  void _handleConnectionAction(NetworkingProvider networkingProvider) async {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');
    
    if (networkingProvider.isUserConnected(widget.user.id)) {
      // Already connected - show message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You are already connected with ${widget.user.name}'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      // Send connection request
      final success = await networkingProvider.sendConnectionRequest(widget.user.id);
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Connection request sent to ${widget.user.name}'),
            backgroundColor: purpleAccent,
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send connection request'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
          widget.user.initials,
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
