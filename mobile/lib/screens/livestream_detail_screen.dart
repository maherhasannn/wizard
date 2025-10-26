import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/livestream_provider.dart';
import '../models/livestream.dart';

class LivestreamDetailScreen extends StatefulWidget {
  final int streamId;

  const LivestreamDetailScreen({
    super.key,
    required this.streamId,
  });

  @override
  State<LivestreamDetailScreen> createState() => _LivestreamDetailScreenState();
}

class _LivestreamDetailScreenState extends State<LivestreamDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LivestreamProvider>().loadStream(widget.streamId);
    });
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
      body: Consumer<LivestreamProvider>(
        builder: (context, livestreamProvider, child) {
          final stream = livestreamProvider.currentStream;

          if (livestreamProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: purpleAccent,
              ),
            );
          }

          if (stream == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    color: lightTextColor.withOpacity(0.5),
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Stream not found',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
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
                        Expanded(
                          child: Text(
                            'Livestream Details',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: lightTextColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Stream thumbnail
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
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
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                stream.thumbnailUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.play_circle_filled,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Center(
                              child: Icon(
                                Icons.play_circle_filled,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                    ),

                    const SizedBox(height: 20),

                    // Stream title
                    Text(
                      stream.title,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Stream status and time
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: stream.isLive 
                                ? Colors.red.withOpacity(0.2)
                                : stream.isUpcoming
                                    ? purpleAccent.withOpacity(0.2)
                                    : lightTextColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
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
                        const SizedBox(width: 12),
                        Text(
                          stream.isUpcoming 
                              ? 'Starts in ${stream.timeUntilStart}'
                              : stream.isLive
                                  ? 'Live now'
                                  : 'Ended',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            color: lightTextColor.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Host info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: purpleAccent.withOpacity(0.2),
                          backgroundImage: stream.hostPhoto != null 
                              ? NetworkImage(stream.hostPhoto!)
                              : null,
                          child: stream.hostPhoto == null
                              ? Text(
                                  stream.hostName.isNotEmpty 
                                      ? stream.hostName[0].toUpperCase()
                                      : 'H',
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    color: lightTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hosted by',
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  color: lightTextColor.withOpacity(0.7),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Text(
                                stream.hostName,
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
                        if (stream.participantCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: lightTextColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${stream.participantCount} watching',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                color: lightTextColor.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Description
                    Text(
                      stream.description,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Action buttons
                    if (stream.isUpcoming) ...[
                      // Set reminder button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (stream.isReminderSet) {
                              await livestreamProvider.removeReminder(stream.id);
                            } else {
                              await livestreamProvider.setReminder(stream.id);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: stream.isReminderSet 
                                ? lightTextColor.withOpacity(0.2)
                                : purpleAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            stream.isReminderSet ? 'Reminder Set' : 'Set Reminder',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: stream.isReminderSet 
                                  ? lightTextColor
                                  : Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ] else if (stream.isLive) ...[
                      // Join stream button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final success = await livestreamProvider.joinStream(stream.id);
                            if (success && mounted) {
                              // Navigate to livestream player
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text('Joining livestream...'),
                                  backgroundColor: purpleAccent,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Join Live Stream',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ] else ...[
                      // Watch replay button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Replay functionality coming soon'),
                                backgroundColor: purpleAccent,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: purpleAccent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            'Watch Replay',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
