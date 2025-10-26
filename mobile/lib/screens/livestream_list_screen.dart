import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/livestream_provider.dart';
import '../models/livestream.dart';
import 'livestream_detail_screen.dart';

class LivestreamListScreen extends StatefulWidget {
  const LivestreamListScreen({super.key});

  @override
  State<LivestreamListScreen> createState() => _LivestreamListScreenState();
}

class _LivestreamListScreenState extends State<LivestreamListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LivestreamProvider>().loadStreams();
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
                    'Livestreams',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Tab bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: lightTextColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: purpleAccent,
                  borderRadius: BorderRadius.circular(25),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: lightTextColor.withOpacity(0.7),
                labelStyle: const TextStyle(
                  fontFamily: 'DMSans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Live'),
                  Tab(text: 'Past'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tab content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildStreamsList(context, lightTextColor, purpleAccent, 'upcoming'),
                  _buildStreamsList(context, lightTextColor, purpleAccent, 'live'),
                  _buildStreamsList(context, lightTextColor, purpleAccent, 'past'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreamsList(BuildContext context, Color lightTextColor, Color purpleAccent, String type) {
    return Consumer<LivestreamProvider>(
      builder: (context, livestreamProvider, child) {
        List<Livestream> streams;
        switch (type) {
          case 'upcoming':
            streams = livestreamProvider.upcomingStreams;
            break;
          case 'live':
            streams = livestreamProvider.liveStreams;
            break;
          case 'past':
            streams = livestreamProvider.pastStreams;
            break;
          default:
            streams = [];
        }

        if (livestreamProvider.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: purpleAccent,
            ),
          );
        }

        if (streams.isEmpty) {
          return _buildEmptyState(lightTextColor, purpleAccent, type);
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: streams.length,
          itemBuilder: (context, index) {
            final stream = streams[index];
            return _buildStreamCard(context, lightTextColor, purpleAccent, stream);
          },
        );
      },
    );
  }

  Widget _buildStreamCard(BuildContext context, Color lightTextColor, Color purpleAccent, Livestream stream) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LivestreamDetailScreen(streamId: stream.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
            // Thumbnail
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    purpleAccent.withOpacity(0.8),
                    purpleAccent.withOpacity(0.4),
                  ],
                ),
              ),
              child: stream.thumbnailUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        stream.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.play_circle_filled,
                              color: Colors.white,
                              size: 30,
                            ),
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.play_circle_filled,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
            ),

            const SizedBox(width: 16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    stream.title,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  // Host
                  Text(
                    'Hosted by ${stream.hostName}',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor.withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Status and time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: stream.isLive 
                              ? Colors.red.withOpacity(0.2)
                              : stream.isUpcoming
                                  ? purpleAccent.withOpacity(0.2)
                                  : lightTextColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: stream.isLive 
                                ? Colors.red
                                : stream.isUpcoming
                                    ? purpleAccent
                                    : lightTextColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          stream.statusDisplayText,
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            color: stream.isLive 
                                ? Colors.red
                                : stream.isUpcoming
                                    ? purpleAccent
                                    : lightTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        stream.isUpcoming 
                            ? stream.timeUntilStart
                            : stream.isLive
                                ? 'Live now'
                                : stream.durationText,
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: lightTextColor.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
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

  Widget _buildEmptyState(Color lightTextColor, Color purpleAccent, String type) {
    String title;
    String subtitle;
    IconData icon;

    switch (type) {
      case 'upcoming':
        title = 'No upcoming streams';
        subtitle = 'Check back later for new live sessions';
        icon = Icons.schedule;
        break;
      case 'live':
        title = 'No live streams';
        subtitle = 'No streams are currently live';
        icon = Icons.video_call;
        break;
      case 'past':
        title = 'No past streams';
        subtitle = 'Watch live sessions to see them here';
        icon = Icons.video_library;
        break;
      default:
        title = 'No streams';
        subtitle = 'No streams available';
        icon = Icons.video_call_outlined;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: lightTextColor.withOpacity(0.5),
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
