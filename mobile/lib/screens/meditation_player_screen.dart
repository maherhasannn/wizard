import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/meditation_track.dart';
import '../widgets/sleep_timer_modal.dart';

class MeditationPlayerScreen extends StatefulWidget {
  final MeditationTrack track;
  final Function(MeditationTrack) onTrackChanged;

  const MeditationPlayerScreen({
    super.key,
    required this.track,
    required this.onTrackChanged,
  });

  @override
  State<MeditationPlayerScreen> createState() => _MeditationPlayerScreenState();
}

class _MeditationPlayerScreenState extends State<MeditationPlayerScreen>
    with TickerProviderStateMixin {
  bool _isPlaying = false;
  bool _isShuffleEnabled = false;
  bool _isRepeatEnabled = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _totalDuration = Duration(seconds: widget.track.duration);
    _currentPosition = Duration.zero;
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    // Simulate progress for demo
    _startProgressSimulation();
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  Duration _parseDuration(String duration) {
    final parts = duration.split(':');
    final minutes = int.parse(parts[0]);
    final seconds = int.parse(parts[1]);
    return Duration(minutes: minutes, seconds: seconds);
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds % 60)}';
  }

  void _startProgressSimulation() {
    if (_isPlaying) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && _isPlaying) {
          setState(() {
            if (_currentPosition < _totalDuration) {
              _currentPosition = Duration(seconds: _currentPosition.inSeconds + 1);
              _rotationController.forward(from: _currentPosition.inSeconds / _totalDuration.inSeconds);
            } else {
              _isPlaying = false;
            }
          });
          _startProgressSimulation();
        }
      });
    }
  }

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
    _startProgressSimulation();
  }

  void _seekTo(Duration position) {
    setState(() {
      _currentPosition = position;
    });
  }

  void _showSleepTimer() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _hexToColor('1B0A33'),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const SleepTimerModal(),
    );
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: lightTextColor,
                      size: 24,
                    ),
                  ),
                  Text(
                    'Meditation',
                    style: GoogleFonts.dmSans(
                      color: lightTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // TODO: Implement favorite toggle
                        },
                        icon: Icon(
                          widget.track.isFavorited
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: lightTextColor,
                          size: 24,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          // TODO: Implement download
                        },
                        icon: Icon(
                          Icons.download,
                          color: lightTextColor,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Background image
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      _hexToColor('4F1B80').withOpacity(0.8),
                      _hexToColor('1B0A33'),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      // Track info
                      Text(
                        widget.track.title,
                        style: GoogleFonts.dmSans(
                          color: lightTextColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.track.artist,
                        style: GoogleFonts.dmSans(
                          color: lightTextColor.withOpacity(0.8),
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      const Spacer(),

                      // Progress bar
                      Column(
                        children: [
                          Slider(
                            value: _currentPosition.inSeconds.toDouble(),
                            max: _totalDuration.inSeconds.toDouble(),
                            activeColor: lightTextColor,
                            inactiveColor: lightTextColor.withOpacity(0.3),
                            onChanged: (value) {
                              _seekTo(Duration(seconds: value.toInt()));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_currentPosition),
                                  style: GoogleFonts.dmSans(
                                    color: lightTextColor.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  _formatDuration(_totalDuration),
                                  style: GoogleFonts.dmSans(
                                    color: lightTextColor.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Playback controls
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Shuffle
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isShuffleEnabled = !_isShuffleEnabled;
                              });
                            },
                            icon: Icon(
                              Icons.shuffle,
                              color: _isShuffleEnabled
                                  ? purpleAccent
                                  : lightTextColor.withOpacity(0.6),
                              size: 28,
                            ),
                          ),

                          // Rewind 15s
                          IconButton(
                            onPressed: () {
                              final newPosition = Duration(
                                seconds: (_currentPosition.inSeconds - 15).clamp(0, _totalDuration.inSeconds),
                              );
                              _seekTo(newPosition);
                            },
                            icon: Icon(
                              Icons.replay_5,
                              color: lightTextColor,
                              size: 32,
                            ),
                          ),

                          // Play/Pause
                          GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: purpleAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: purpleAccent.withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: lightTextColor,
                                size: 40,
                              ),
                            ),
                          ),

                          // Forward 15s
                          IconButton(
                            onPressed: () {
                              final newPosition = Duration(
                                seconds: (_currentPosition.inSeconds + 15).clamp(0, _totalDuration.inSeconds),
                              );
                              _seekTo(newPosition);
                            },
                            icon: Icon(
                              Icons.forward_5,
                              color: lightTextColor,
                              size: 32,
                            ),
                          ),

                          // Repeat
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isRepeatEnabled = !_isRepeatEnabled;
                              });
                            },
                            icon: Icon(
                              _isRepeatEnabled ? Icons.repeat : Icons.repeat,
                              color: _isRepeatEnabled
                                  ? purpleAccent
                                  : lightTextColor.withOpacity(0.6),
                              size: 28,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Bottom action icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildActionIcon(
                            Icons.favorite_border,
                            'Favorite',
                            () {
                              // TODO: Implement favorite
                            },
                          ),
                          _buildActionIcon(
                            Icons.download,
                            'Download',
                            () {
                              // TODO: Implement download
                            },
                          ),
                          _buildActionIcon(
                            Icons.share,
                            'Share',
                            () {
                              // TODO: Implement share
                            },
                          ),
                          _buildActionIcon(
                            Icons.bedtime,
                            'Sleep Timer',
                            _showSleepTimer,
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, String label, VoidCallback onTap) {
    final lightTextColor = _hexToColor('F0E6D8');

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: lightTextColor.withOpacity(0.8),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: lightTextColor.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
