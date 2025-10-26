import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared_background.dart';
import '../providers/livestream_provider.dart';
import '../providers/networking_provider.dart';
import '../models/livestream.dart';
import '../screens/discovery_methods_screen.dart';
import '../screens/livestream_detail_screen.dart';
import '../screens/livestream_list_screen.dart';
import '../screens/profile_questionnaire_screen.dart';

class CirceTab extends StatefulWidget {
  const CirceTab({super.key});

  @override
  State<CirceTab> createState() => _CirceTabState();
}

class _CirceTabState extends State<CirceTab> {
  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    // Load livestreams when tab initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LivestreamProvider>().loadStreams();
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Consumer2<LivestreamProvider, NetworkingProvider>(
      builder: (context, livestreamProvider, networkingProvider, child) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(lightTextColor, purpleAccent),
                  
                  const SizedBox(height: 30),
                  
                  // Live Q&A Section
                  _buildLiveQASection(context, lightTextColor, purpleAccent, livestreamProvider),
                  
                  const SizedBox(height: 30),
                  
                  // Past Livestreams
                  _buildPastLivestreamsSection(context, lightTextColor, purpleAccent, livestreamProvider),
                  
                  const SizedBox(height: 30),
                  
                  // Find Queens Near You
                  _buildFindQueensSection(context, lightTextColor, purpleAccent),
                  
                  const SizedBox(height: 100), // Space for bottom navigation
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(Color lightTextColor, Color purpleAccent) {
    return Text(
      'Community',
      style: TextStyle(
          fontFamily: 'DMSans',
        color: lightTextColor,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildLiveQASection(BuildContext context, Color lightTextColor, Color purpleAccent, LivestreamProvider livestreamProvider) {
    final nextStream = livestreamProvider.nextUpcomingStream;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LIVE Q&A',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        if (nextStream != null)
          _buildLiveQACard(context, lightTextColor, purpleAccent, nextStream, livestreamProvider)
        else
          _buildNoUpcomingStreams(lightTextColor, purpleAccent),
      ],
    );
  }

  Widget _buildLiveQACard(BuildContext context, Color lightTextColor, Color purpleAccent, Livestream stream, LivestreamProvider livestreamProvider) {
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              purpleAccent.withOpacity(0.8),
              purpleAccent.withOpacity(0.6),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: lightTextColor.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: lightTextColor.withOpacity(0.2),
                  ),
                  child: Icon(
                    Icons.video_call,
                    color: lightTextColor,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LIVE Q&A',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: lightTextColor.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stream.title,
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              _formatStreamTime(stream.scheduledAt),
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor.withOpacity(0.8),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Starts in ${stream.timeUntilStart}',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (stream.isReminderSet) {
                        await livestreamProvider.removeReminder(stream.id);
                      } else {
                        await livestreamProvider.setReminder(stream.id);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: stream.isReminderSet 
                            ? lightTextColor.withOpacity(0.3)
                            : lightTextColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                        border: stream.isReminderSet 
                            ? Border.all(color: lightTextColor.withOpacity(0.5), width: 1)
                            : null,
                      ),
                      child: Text(
                        stream.isReminderSet ? 'Reminder Set' : 'Set a Reminder',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoUpcomingStreams(Color lightTextColor, Color purpleAccent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: purpleAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: lightTextColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.video_call_outlined,
            color: lightTextColor.withOpacity(0.5),
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'No upcoming streams',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Check back later for new live sessions',
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

  Widget _buildPastLivestreamsSection(BuildContext context, Color lightTextColor, Color purpleAccent, LivestreamProvider livestreamProvider) {
    final pastStreams = livestreamProvider.pastStreams.take(5).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Past Livestreams',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LivestreamListScreen(),
                  ),
                );
              },
              child: Icon(
                Icons.arrow_forward_ios,
                color: lightTextColor.withOpacity(0.7),
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (pastStreams.isNotEmpty)
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: pastStreams.length,
              itemBuilder: (context, index) {
                final stream = pastStreams[index];
                return _buildPastLivestreamCard(context, lightTextColor, purpleAccent, stream);
              },
            ),
          )
        else
          _buildNoPastStreams(lightTextColor, purpleAccent),
      ],
    );
  }

  Widget _buildPastLivestreamCard(BuildContext context, Color lightTextColor, Color purpleAccent, Livestream stream) {
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
        width: 150,
        margin: const EdgeInsets.only(right: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: lightTextColor.withOpacity(0.1),
                ),
                child: stream.thumbnailUrl != null
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          stream.thumbnailUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.play_circle_filled,
                                color: Colors.white,
                                size: 40,
                              ),
                            );
                          },
                        ),
                      )
                    : const Center(
                        child: Icon(
                          Icons.play_circle_filled,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stream.title,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    stream.durationText.isNotEmpty ? stream.durationText : 'Watch now',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor.withOpacity(0.7),
                      fontSize: 12,
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
  }

  Widget _buildNoPastStreams(Color lightTextColor, Color purpleAccent) {
    return Container(
      height: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: purpleAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: lightTextColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.video_library_outlined,
              color: lightTextColor.withOpacity(0.5),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              'No past streams yet',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Watch live sessions to see them here',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor.withOpacity(0.7),
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFindQueensSection(BuildContext context, Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find Queens Near You',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showJoinModal(context, lightTextColor, purpleAccent),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: purpleAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: lightTextColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Map placeholder
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: lightTextColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          color: lightTextColor.withOpacity(0.5),
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Map View',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            color: lightTextColor.withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: lightTextColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Join the Circle',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showJoinModal(BuildContext context, Color lightTextColor, Color purpleAccent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: purpleAccent.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: lightTextColor.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Profile pictures collage
                Center(
                  child: SizedBox(
                    width: 150,
                    height: 40,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          left: 0,
                          child: _buildProfilePicture(lightTextColor, 0),
                        ),
                        Positioned(
                          left: 30,
                          child: _buildProfilePicture(lightTextColor, 1),
                        ),
                        Positioned(
                          left: 60,
                          child: _buildProfilePicture(lightTextColor, 2),
                        ),
                        Positioned(
                          left: 90,
                          child: _buildProfilePicture(lightTextColor, 3),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Join the Circle',
                  style: TextStyle(
            fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Connect with like-minded women in your area and build meaningful relationships.',
                  style: TextStyle(
            fontFamily: 'DMSans',
                    color: lightTextColor.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                _buildDropdown('Country', 'Select your country', lightTextColor, purpleAccent),
                const SizedBox(height: 16),
                _buildDropdown('City', 'Select your city', lightTextColor, purpleAccent),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: lightTextColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt,
                        color: lightTextColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Connect Instagram',
                        style: TextStyle(
            fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context); // Close modal
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileQuestionnaireScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: lightTextColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'Join',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: purpleAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(Color lightTextColor, int index) {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange];
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors[index].withOpacity(0.8),
        border: Border.all(
          color: lightTextColor,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.person,
        color: lightTextColor,
        size: 20,
      ),
    );
  }

  Widget _buildDropdown(String label, String hint, Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: lightTextColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: lightTextColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hint,
                  style: TextStyle(
          fontFamily: 'DMSans',
                    color: lightTextColor.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: lightTextColor.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatStreamTime(DateTime scheduledAt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final streamDate = DateTime(scheduledAt.year, scheduledAt.month, scheduledAt.day);
    
    if (streamDate == today) {
      return 'Today, ${_formatTime(scheduledAt)}';
    } else if (streamDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow, ${_formatTime(scheduledAt)}';
    } else {
      return '${_formatDate(scheduledAt)}, ${_formatTime(scheduledAt)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}';
  }
}