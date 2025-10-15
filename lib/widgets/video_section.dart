import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VideoSection extends StatelessWidget {
  const VideoSection({super.key});

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.play_circle_outline,
                  color: lightTextColor,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Video',
                  style: GoogleFonts.dmSans(
                    color: lightTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              'See all >',
              style: GoogleFonts.dmSans(
                color: lightTextColor.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Video thumbnails
        Row(
          children: [
            Expanded(
              child: _buildVideoThumbnail(
                'Tranquility - Deep Healing Relaxing Music - Meditation',
                '1 day ago',
                lightTextColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildVideoThumbnail(
                'How to get cheated on',
                '2 days ago',
                lightTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVideoThumbnail(String title, String timeAgo, Color textColor) {
    return Container(
      decoration: BoxDecoration(
        color: _hexToColor('6A1B9A').withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: textColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video thumbnail
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.play_circle_filled,
                color: textColor.withOpacity(0.5),
                size: 40,
              ),
            ),
          ),
          
          // Video info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    color: textColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  timeAgo,
                  style: GoogleFonts.dmSans(
                    color: textColor.withOpacity(0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
