import 'package:flutter/material.dart';
import '../models/network_user.dart';
import '../data/network_users_data.dart';
import '../widgets/map_user_pin.dart';
import 'user_profile_screen.dart';

class MapViewScreen extends StatefulWidget {
  const MapViewScreen({super.key});

  @override
  State<MapViewScreen> createState() => _MapViewScreenState();
}

class _MapViewScreenState extends State<MapViewScreen> {
  final List<NetworkUser> _users = NetworkUsersData.getAllUsers();
  NetworkUser? _selectedUser;
  double _zoom = 1.0;
  Offset _panOffset = Offset.zero;

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _onUserPinTap(NetworkUser user) {
    setState(() {
      _selectedUser = user;
    });
  }

  void _onUserProfileTap(NetworkUser user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserProfileScreen(user: user),
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
                    'Show on a Map',
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
                      // Search functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Search functionality coming soon'),
                          backgroundColor: purpleAccent,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.search,
                      color: lightTextColor,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            // Map area
            Expanded(
              child: Stack(
                children: [
                  // Map background
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          _hexToColor('2D1B69'),
                          _hexToColor('1B0A33'),
                        ],
                      ),
                    ),
                    child: CustomPaint(
                      painter: MapGridPainter(lightTextColor.withOpacity(0.1)),
                    ),
                  ),

                  // User pins
                  ..._users.where((user) => user.latitude != null && user.longitude != null).map((user) {
                    // Convert lat/lng to screen coordinates (simplified)
                    final x = (user.longitude! + 180) / 360 * MediaQuery.of(context).size.width;
                    final y = (90 - user.latitude!) / 180 * MediaQuery.of(context).size.height;
                    
                    return Positioned(
                      left: x - 20,
                      top: y - 20,
                      child: MapUserPin(
                        user: user,
                        onTap: () => _onUserPinTap(user),
                        isSelected: _selectedUser?.id == user.id,
                      ),
                    );
                  }).toList(),

                  // Search bar overlay
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: lightTextColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: lightTextColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: lightTextColor.withOpacity(0.7),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Search on a map',
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Selected user info
            if (_selectedUser != null)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: purpleAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: lightTextColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Profile picture
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: lightTextColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: _selectedUser!.photoUrl.isNotEmpty
                            ? Image.asset(
                                _selectedUser!.photoUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return _buildPlaceholderAvatar(_selectedUser!);
                                },
                              )
                            : _buildPlaceholderAvatar(_selectedUser!),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // User info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedUser!.name,
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${_selectedUser!.age} • ${_selectedUser!.locationString}',
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _selectedUser!.bio,
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // View profile button
                    GestureDetector(
                      onTap: () => _onUserProfileTap(_selectedUser!),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: purpleAccent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'View Profile',
                          style: TextStyle(
          fontFamily: 'DMSans',
                            color: lightTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
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

  Widget _buildPlaceholderAvatar(NetworkUser user) {
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
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class MapGridPainter extends CustomPainter {
  final Color gridColor;

  MapGridPainter(this.gridColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = gridColor
      ..strokeWidth = 1.0;

    // Draw grid lines
    for (double i = 0; i < size.width; i += 40) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        paint,
      );
    }

    for (double i = 0; i < size.height; i += 40) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        paint,
      );
    }

    // Draw some random "landmarks" for visual interest
    final landmarkPaint = Paint()
      ..color = gridColor.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    // Add some circular landmarks
    canvas.drawCircle(Offset(size.width * 0.2, size.height * 0.3), 15, landmarkPaint);
    canvas.drawCircle(Offset(size.width * 0.7, size.height * 0.6), 12, landmarkPaint);
    canvas.drawCircle(Offset(size.width * 0.4, size.height * 0.8), 18, landmarkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
