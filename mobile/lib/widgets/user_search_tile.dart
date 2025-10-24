import 'package:flutter/material.dart';
import '../models/network_user.dart';

class UserSearchTile extends StatelessWidget {
  final NetworkUser user;
  final VoidCallback? onTap;

  const UserSearchTile({
    super.key,
    required this.user,
    this.onTap,
  });

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
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
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: lightTextColor.withOpacity(0.3),
                  width: 2,
                ),
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

            const SizedBox(width: 16),

            // User info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${user.age}',
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      if (user.isOnline) ...[
                        const SizedBox(width: 8),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.locationString,
                    style: TextStyle(
          fontFamily: 'DMSans',
                      color: lightTextColor.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.bio,
                    style: TextStyle(
          fontFamily: 'DMSans',
                      color: lightTextColor.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Interests
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: user.interests.take(3).map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: lightTextColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          interest,
                          style: TextStyle(
          fontFamily: 'DMSans',
                            color: lightTextColor.withOpacity(0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            // Arrow
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
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
