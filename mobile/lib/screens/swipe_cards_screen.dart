import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/network_user.dart';
import '../data/network_users_data.dart';
import '../widgets/profile_card.dart';
import 'user_profile_screen.dart';

class SwipeCardsScreen extends StatefulWidget {
  const SwipeCardsScreen({super.key});

  @override
  State<SwipeCardsScreen> createState() => _SwipeCardsScreenState();
}

class _SwipeCardsScreenState extends State<SwipeCardsScreen>
    with TickerProviderStateMixin {
  final List<NetworkUser> _users = NetworkUsersData.getAllUsers();
  int _currentIndex = 0;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _onSwipeLeft() {
    if (_currentIndex < _users.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _animationController.forward().then((_) {
        _animationController.reset();
      });
    }
  }

  void _onSwipeRight() {
    if (_currentIndex < _users.length - 1) {
      setState(() {
        _currentIndex++;
      });
      _animationController.forward().then((_) {
        _animationController.reset();
      });
    }
  }

  void _onCardTap(NetworkUser user) {
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

    if (_currentIndex >= _users.length) {
      return Scaffold(
        backgroundColor: _hexToColor('1B0A33'),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite,
                  color: purpleAccent,
                  size: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  'No more profiles!',
                  style: GoogleFonts.dmSans(
                    color: lightTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back later for new people to meet',
                  style: GoogleFonts.dmSans(
                    color: lightTextColor.withOpacity(0.7),
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: purpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Go Back',
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
                    'Swipe Cards',
                    style: GoogleFonts.dmSans(
                      color: lightTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_currentIndex + 1}/${_users.length}',
                    style: GoogleFonts.dmSans(
                      color: lightTextColor.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),

            // Cards stack
            Expanded(
              child: Stack(
                children: [
                  // Background cards (next 2-3 users)
                  if (_currentIndex + 1 < _users.length)
                    Positioned(
                      top: 20,
                      left: 20,
                      right: 20,
                      bottom: 100,
                      child: ProfileCard(
                        user: _users[_currentIndex + 1],
                        onTap: () => _onCardTap(_users[_currentIndex + 1]),
                        isBackground: true,
                      ),
                    ),
                  if (_currentIndex + 2 < _users.length)
                    Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      bottom: 110,
                      child: ProfileCard(
                        user: _users[_currentIndex + 2],
                        onTap: () => _onCardTap(_users[_currentIndex + 2]),
                        isBackground: true,
                      ),
                    ),

                  // Current card
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 80,
                    child: ProfileCard(
                      user: _users[_currentIndex],
                      onTap: () => _onCardTap(_users[_currentIndex]),
                      onSwipeLeft: _onSwipeLeft,
                      onSwipeRight: _onSwipeRight,
                    ),
                  ),
                ],
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Pass button
                  GestureDetector(
                    onTap: _onSwipeLeft,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lightTextColor.withOpacity(0.1),
                        border: Border.all(
                          color: lightTextColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.close,
                        color: lightTextColor.withOpacity(0.7),
                        size: 28,
                      ),
                    ),
                  ),

                  // Like button
                  GestureDetector(
                    onTap: _onSwipeRight,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: purpleAccent,
                        boxShadow: [
                          BoxShadow(
                            color: purpleAccent.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite,
                        color: lightTextColor,
                        size: 32,
                      ),
                    ),
                  ),

                  // Info button
                  GestureDetector(
                    onTap: () => _onCardTap(_users[_currentIndex]),
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: lightTextColor.withOpacity(0.1),
                        border: Border.all(
                          color: lightTextColor.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.info_outline,
                        color: lightTextColor.withOpacity(0.7),
                        size: 28,
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
}
