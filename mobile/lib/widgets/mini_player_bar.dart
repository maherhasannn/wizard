import 'package:flutter/material.dart';
import '../models/meditation_track.dart';

class MiniPlayerBar extends StatelessWidget {
  final MeditationTrack track;
  final bool isPlaying;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onTap;

  const MiniPlayerBar({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.onTogglePlayPause,
    required this.onTap,
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
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: purpleAccent.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Track thumbnail
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: lightTextColor.withOpacity(0.1),
              ),
              child: Icon(
                Icons.music_note,
                color: lightTextColor.withOpacity(0.6),
                size: 24,
              ),
            ),

            const SizedBox(width: 12),

            // Track info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    track.title,
                    style: TextStyle(
          fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    track.artist,
                    style: TextStyle(
          fontFamily: 'DMSans',
                      color: lightTextColor.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Play/pause button
            GestureDetector(
              onTap: onTogglePlayPause,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: lightTextColor.withOpacity(0.2),
                ),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: lightTextColor,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
