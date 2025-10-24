import 'package:flutter/material.dart';
import '../models/meditation_track.dart';
import 'meditation_player_screen.dart';

class VideosScreen extends StatefulWidget {
  const VideosScreen({super.key});

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
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

    return Scaffold(
      backgroundColor: _hexToColor('1B0A33'),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: lightTextColor,
                      size: 20,
                    ),
                  ),
                  Text(
                    'Videos',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 40), // Balance the back button
                ],
              ),
            ),
            
            // Tab Navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: lightTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: purpleAccent,
                  ),
                  labelColor: lightTextColor,
                  unselectedLabelColor: lightTextColor.withOpacity(0.7),
                  labelStyle: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontFamily: 'DMSans',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: const [
                    Tab(text: 'Videos'),
                    Tab(text: 'Streams'),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildVideosTab(lightTextColor, purpleAccent),
                  _buildStreamsTab(lightTextColor, purpleAccent),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideosTab(Color lightTextColor, Color purpleAccent) {
    final videos = [
      {
        'title': 'Tranquility - Deep Healing Relaxing Music - Meditation Ambient Music...',
        'duration': '12:53',
        'uploadTime': '5 days ago',
        'color': purpleAccent.withOpacity(0.8),
      },
      {
        'title': 'How to get cheated on',
        'duration': '12:53',
        'uploadTime': '5 days ago',
        'color': purpleAccent.withOpacity(0.6),
      },
      {
        'title': 'Inner Peace Journey - Guided Meditation',
        'duration': '8:45',
        'uploadTime': '1 week ago',
        'color': purpleAccent.withOpacity(0.7),
      },
      {
        'title': 'Self-Love Affirmations - Morning Routine',
        'duration': '6:30',
        'uploadTime': '2 weeks ago',
        'color': purpleAccent.withOpacity(0.5),
      },
      {
        'title': 'Chakra Balancing - Energy Healing',
        'duration': '15:20',
        'uploadTime': '3 weeks ago',
        'color': purpleAccent.withOpacity(0.9),
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return GestureDetector(
          onTap: () => _navigateToMeditationPlayer(video),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Video thumbnail
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        video['color'] as Color,
                        (video['color'] as Color).withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Play button
                      const Center(
                        child: Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                      // Duration badge
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            video['duration'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Video info
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: purpleAccent.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        video['title'] as String,
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        video['uploadTime'] as String,
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStreamsTab(Color lightTextColor, Color purpleAccent) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.live_tv,
            color: lightTextColor.withOpacity(0.5),
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'No streams available',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Check back later for live content',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.5),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMeditationPlayer(Map<String, dynamic> videoData) {
    // Create a meditation track for testing (5 seconds duration as requested)
    final track = MeditationTrack(
      id: DateTime.now().millisecondsSinceEpoch,
      title: videoData['title'] as String,
      artist: 'Liz\'s Guided Meditation',
      duration: 5, // 5 seconds for testing
      category: 'audio',
      description: 'A guided meditation experience',
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MeditationPlayerScreen(
          track: track,
          onTrackChanged: (newTrack) {
            // Handle track changes if needed
          },
        ),
      ),
    );
  }
}
