import 'package:flutter/material.dart';
import '../shared_background.dart';

class RitualsTab extends StatefulWidget {
  const RitualsTab({super.key});

  @override
  State<RitualsTab> createState() => _RitualsTabState();
}

class _RitualsTabState extends State<RitualsTab> {
  String _selectedFilter = 'All';

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  final List<Map<String, dynamic>> _meditationTracks = [
    {
      'title': 'Whispers of the Thunder',
      'duration': '15 min',
      'isPlaying': false,
    },
    {
      'title': 'The first summer thunder',
      'duration': '15 min',
      'isPlaying': false,
    },
    {
      'title': 'The Awakening Storm',
      'duration': '15 min',
      'isPlaying': false,
    },
    {
      'title': 'Nature\'s Thunderous Embrace',
      'duration': '15 min',
      'isPlaying': false,
    },
    {
      'title': 'Echoes of Summer Storms',
      'duration': '15 min',
      'isPlaying': false,
    },
    {
      'title': 'Gentle Rain Meditation',
      'duration': '20 min',
      'isPlaying': false,
    },
    {
      'title': 'Ocean Waves Serenity',
      'duration': '25 min',
      'isPlaying': false,
    },
    {
      'title': 'Forest Ambience',
      'duration': '18 min',
      'isPlaying': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and icons
            _buildHeader(lightTextColor, purpleAccent),
            
            const SizedBox(height: 30),
            
            // Segmented Control
            _buildSegmentedControl(lightTextColor, purpleAccent),
            
            const SizedBox(height: 20),
            
            // Audio count
            Text(
              '35 audio',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Meditation tracks list
            Expanded(
              child: _buildMeditationTracksList(lightTextColor, purpleAccent),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(Color lightTextColor, Color purpleAccent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Meditations',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            // Heart icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.3),
              ),
              child: Icon(
                Icons.favorite,
                color: lightTextColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            // Stats icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.3),
              ),
              child: Icon(
                Icons.bar_chart,
                color: lightTextColor,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSegmentedControl(Color lightTextColor, Color purpleAccent) {
    final filters = ['All', 'Authored', 'Music', 'Silence'];
    
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? purpleAccent
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  filter,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMeditationTracksList(Color lightTextColor, Color purpleAccent) {
    return ListView.separated(
      itemCount: _meditationTracks.length,
      separatorBuilder: (context, index) => Divider(
        color: lightTextColor.withOpacity(0.1),
        height: 1,
      ),
      itemBuilder: (context, index) {
        final track = _meditationTracks[index];
        return _buildTrackItem(track, lightTextColor, purpleAccent, index);
      },
    );
  }

  Widget _buildTrackItem(Map<String, dynamic> track, Color lightTextColor, Color purpleAccent, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          // Play button
          GestureDetector(
            onTap: () {
              setState(() {
                // Reset all tracks to not playing
                for (int i = 0; i < _meditationTracks.length; i++) {
                  _meditationTracks[i]['isPlaying'] = false;
                }
                // Set current track to playing
                _meditationTracks[index]['isPlaying'] = true;
              });
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: purpleAccent,
              ),
              child: Icon(
                track['isPlaying'] ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          
          const SizedBox(width: 16),
          
          // Track info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track['title'],
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  track['duration'],
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          
          // More options icon
          Icon(
            Icons.more_horiz,
            color: lightTextColor.withOpacity(0.7),
            size: 20,
          ),
        ],
      ),
    );
  }
}