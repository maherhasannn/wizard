import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/network_user.dart';

class ProfileCard extends StatefulWidget {
  final NetworkUser user;
  final VoidCallback? onTap;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final bool isBackground;

  const ProfileCard({
    super.key,
    required this.user,
    this.onTap,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.isBackground = false,
  });

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<Offset> _positionAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _positionAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.0, -0.1),
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
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

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: widget.isBackground ? 0.95 : _scaleAnimation.value,
          child: Transform.translate(
            offset: widget.isBackground ? const Offset(0, 10) : _positionAnimation.value * 20,
            child: Transform.rotate(
              angle: widget.isBackground ? 0.02 : _rotationAnimation.value,
              child: GestureDetector(
                onTap: widget.onTap,
                onPanUpdate: (details) {
                  // Handle swipe gestures
                  if (details.delta.dx > 10) {
                    // Swipe right
                    _animationController.forward().then((_) {
                      widget.onSwipeRight?.call();
                    });
                  } else if (details.delta.dx < -10) {
                    // Swipe left
                    _animationController.forward().then((_) {
                      widget.onSwipeLeft?.call();
                    });
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        // Background image
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                purpleAccent.withOpacity(0.3),
                                purpleAccent.withOpacity(0.8),
                              ],
                            ),
                          ),
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

                        // Gradient overlay
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.7),
                              ],
                            ),
                          ),
                        ),

                        // Content
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name and age
                                Row(
                                  children: [
                                    Text(
                                      widget.user.name,
                                      style: GoogleFonts.dmSans(
                                        color: lightTextColor,
                                        fontSize: 28,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${widget.user.age}',
                                      style: GoogleFonts.dmSans(
                                        color: lightTextColor.withOpacity(0.8),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                // Location
                                Text(
                                  widget.user.locationString,
                                  style: GoogleFonts.dmSans(
                                    color: lightTextColor.withOpacity(0.9),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),

                                const SizedBox(height: 12),

                                // Bio
                                Text(
                                  widget.user.bio,
                                  style: GoogleFonts.dmSans(
                                    color: lightTextColor.withOpacity(0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                const SizedBox(height: 12),

                                // Interests
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: widget.user.interests.take(3).map((interest) {
                                    return Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: lightTextColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: lightTextColor.withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        interest,
                                        style: GoogleFonts.dmSans(
                                          color: lightTextColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),

                                const SizedBox(height: 8),

                                // Instagram
                                if (widget.user.instagram.isNotEmpty)
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: lightTextColor.withOpacity(0.7),
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        widget.user.instagram,
                                        style: GoogleFonts.dmSans(
                                          color: lightTextColor.withOpacity(0.7),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ),

                        // Online indicator
                        if (widget.user.isOnline)
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                                border: Border.all(
                                  color: lightTextColor,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
          widget.user.initials,
          style: GoogleFonts.dmSans(
            color: lightTextColor,
            fontSize: 48,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
