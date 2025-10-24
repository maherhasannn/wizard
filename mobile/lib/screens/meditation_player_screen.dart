import 'package:flutter/material.dart';
import '../models/meditation_track.dart';
import '../widgets/sleep_timer_modal.dart';
import '../widgets/meditation_loading_animation.dart';

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
  bool _isLoading = true; // Add loading state
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
    
    // Show loading animation for 2 seconds, then start the meditation
    _showLoadingAnimation();
  }

  void _showLoadingAnimation() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Start progress simulation after loading
        _startProgressSimulation();
      }
    });
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

    // Show loading animation if still loading
    if (_isLoading) {
      return MeditationLoadingAnimation(
        message: 'Preparing ${widget.track.title}...',
        primaryColor: purpleAccent,
        secondaryColor: lightTextColor,
      );
    }

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
                    'Meditation',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isShuffleEnabled = !_isShuffleEnabled;
                          });
                        },
                        icon: Icon(
                          Icons.shuffle,
                          color: _isShuffleEnabled ? purpleAccent : lightTextColor.withOpacity(0.5),
                          size: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isRepeatEnabled = !_isRepeatEnabled;
                          });
                        },
                        icon: Icon(
                          Icons.repeat,
                          color: _isRepeatEnabled ? purpleAccent : lightTextColor.withOpacity(0.5),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Large album art
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 0,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: widget.track.imageUrl != null
                              ? Image.asset(
                                  widget.track.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildFallbackImage();
                                  },
                                )
                              : _buildFallbackImage(),
                        ),
                      ),
                    ),
                    
                    // Track info with small thumbnail
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          // Small thumbnail
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: widget.track.imageUrl != null
                                  ? Image.asset(
                                      widget.track.imageUrl!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return Container(
                                          color: purpleAccent.withOpacity(0.3),
                                          child: Icon(
                                            Icons.music_note,
                                            color: lightTextColor,
                                            size: 24,
                                          ),
                                        );
                                      },
                                    )
                                  : Container(
                                      color: purpleAccent.withOpacity(0.3),
                                      child: Icon(
                                        Icons.music_note,
                                        color: lightTextColor,
                                        size: 24,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Track title and artist
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.track.title,
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    color: lightTextColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '@${widget.track.artist.toLowerCase().replaceAll(' ', '')}',
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

                    const SizedBox(height: 30),

                    // Progress bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: lightTextColor,
                              inactiveTrackColor: lightTextColor.withOpacity(0.3),
                              thumbColor: lightTextColor,
                              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                              trackHeight: 2,
                            ),
                            child: Slider(
                              value: _currentPosition.inSeconds.toDouble(),
                              max: _totalDuration.inSeconds.toDouble(),
                              onChanged: (value) {
                                _seekTo(Duration(seconds: value.toInt()));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _formatDuration(_currentPosition),
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
                                    color: lightTextColor.withOpacity(0.8),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  _formatDuration(_totalDuration),
                                  style: TextStyle(
                                    fontFamily: 'DMSans',
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
                    ),

                    const SizedBox(height: 30),

                    // Playback controls
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Previous track
                          IconButton(
                            onPressed: () {
                              // Previous track
                            },
                            icon: Icon(
                              Icons.skip_previous,
                              color: lightTextColor.withOpacity(0.7),
                              size: 28,
                            ),
                          ),
                          // Play/Pause button
                          GestureDetector(
                            onTap: _togglePlayPause,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: purpleAccent,
                                boxShadow: [
                                  BoxShadow(
                                    color: purpleAccent.withOpacity(0.3),
                                    blurRadius: 15,
                                    spreadRadius: 0,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                _isPlaying ? Icons.pause : Icons.play_arrow,
                                color: Colors.white,
                                size: 35,
                              ),
                            ),
                          ),
                          // Next track
                          IconButton(
                            onPressed: () {
                              // Next track
                            },
                            icon: Icon(
                              Icons.skip_next,
                              color: lightTextColor.withOpacity(0.7),
                              size: 28,
                            ),
                          ),
                          // Repeat
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _isRepeatEnabled = !_isRepeatEnabled;
                              });
                            },
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: lightTextColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.repeat,
                                    color: _isRepeatEnabled ? purpleAccent : lightTextColor.withOpacity(0.7),
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Repeat',
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

                    const SizedBox(height: 30),

                    // Bottom action bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Handle favorite
                            },
                            child: Icon(
                              widget.track.isFavorited ? Icons.favorite : Icons.favorite_border,
                              color: widget.track.isFavorited ? Colors.red : lightTextColor.withOpacity(0.7),
                              size: 24,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle download
                            },
                            child: Icon(
                              Icons.download,
                              color: lightTextColor.withOpacity(0.7),
                              size: 24,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Handle share
                            },
                            child: Icon(
                              Icons.share,
                              color: lightTextColor.withOpacity(0.7),
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFallbackImage() {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            purpleAccent.withOpacity(0.8),
            purpleAccent.withOpacity(0.4),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.music_note,
              color: lightTextColor.withOpacity(0.8),
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              widget.track.title,
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}