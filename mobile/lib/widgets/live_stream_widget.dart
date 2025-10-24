import 'package:flutter/material.dart';

class LiveStreamWidget extends StatefulWidget {
  const LiveStreamWidget({super.key});

  @override
  State<LiveStreamWidget> createState() => _LiveStreamWidgetState();
}

class _LiveStreamWidgetState extends State<LiveStreamWidget> {
  bool _isLive = false;

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: _hexToColor('6A1B9A').withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: lightTextColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Live Stream',
                  style: TextStyle(
          fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (_isLive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'LIVE',
                          style: TextStyle(
          fontFamily: 'DMSans',
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Video player area
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: lightTextColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Stack(
                children: [
                  // Video placeholder
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _hexToColor('6A1B9A'),
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: lightTextColor,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Answering your questions directly in the app.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
          fontFamily: 'DMSans',
                            color: lightTextColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Live indicator and viewer count
                  if (_isLive)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '5.3K viewers',
                              style: TextStyle(
          fontFamily: 'DMSans',
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Stream info and action
            if (!_isLive) ...[
              Text(
                'Start at 21:00 Brussels time',
                style: TextStyle(
          fontFamily: 'DMSans',
                  color: lightTextColor.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: lightTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Stream starts in 4 minutes',
                  style: TextStyle(
          fontFamily: 'DMSans',
                    color: lightTextColor.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _isLive = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hexToColor('6A1B9A'),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Join waiting room',
                    style: TextStyle(
          fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ] else ...[
              // Live stream chat area
              Container(
                height: 120,
                decoration: BoxDecoration(
                  color: lightTextColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Live Chat',
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView(
                          children: [
                            _buildChatMessage('What\'s up fam? Excited for our project! 🎉'),
                            _buildChatMessage('Always here! Let\'s crush our goals! 💪'),
                            _buildChatMessage('Can\'t wait to catch all the juicy gossip on the best'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: lightTextColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Add comment...',
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite_border,
                      color: lightTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildChatMessage(String message) {
    final lightTextColor = _hexToColor('F0E6D8');
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        message,
        style: TextStyle(
          fontFamily: 'DMSans',
          color: lightTextColor.withOpacity(0.8),
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
