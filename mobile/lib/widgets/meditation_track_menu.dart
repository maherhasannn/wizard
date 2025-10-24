import 'package:flutter/material.dart';
import '../models/meditation_track.dart';

class MeditationTrackMenu extends StatelessWidget {
  final MeditationTrack track;

  const MeditationTrackMenu({
    super.key,
    required this.track,
  });

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Track title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: purpleAccent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  track.title,
                  style: TextStyle(
          fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      track.artist,
                      style: TextStyle(
          fontFamily: 'DMSans',
                        color: lightTextColor.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    if (track.isPremium) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: purpleAccent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'PREMIUM',
                          style: TextStyle(
          fontFamily: 'DMSans',
                            color: lightTextColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Menu options
          _buildMenuOption(
            context,
            'Add to favorites',
            Icons.favorite_border,
            () {
              Navigator.pop(context);
              // TODO: Implement add to favorites
            },
          ),
          const SizedBox(height: 16),
          _buildMenuOption(
            context,
            'Download',
            Icons.download,
            () {
              Navigator.pop(context);
              // TODO: Implement download
            },
          ),
          const SizedBox(height: 16),
          _buildMenuOption(
            context,
            'Share',
            Icons.share,
            () {
              Navigator.pop(context);
              // TODO: Implement share
            },
          ),

          const SizedBox(height: 24),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: lightTextColor.withOpacity(0.1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
          fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuOption(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap,
  ) {
    final lightTextColor = _hexToColor('F0E6D8');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: lightTextColor.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: lightTextColor.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: lightTextColor,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
          fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
