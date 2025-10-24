import 'package:flutter/material.dart';
import 'dart:ui';
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
    final filters = ['All', 'Authored', 'Silence'];
    
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
                // If Silence is selected, show the time picker modal
                if (filter == 'Silence') {
                  _showSilenceTimePicker(context, lightTextColor, purpleAccent);
                }
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

  void _showSilenceTimePicker(BuildContext context, Color lightTextColor, Color purpleAccent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSilenceTimePickerModal(lightTextColor, purpleAccent),
    );
  }

  Widget _buildSilenceTimePickerModal(Color lightTextColor, Color purpleAccent) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: _hexToColor('1B0A33'),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: purpleAccent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Silence',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Choose time for your silence session',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor.withOpacity(0.7),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    child: Icon(
                      Icons.close,
                      color: lightTextColor,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Time picker
          Expanded(
            child: _buildTimePicker(lightTextColor, purpleAccent),
          ),
          
          // Start button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _navigateToSilenceMeditation(context, lightTextColor, purpleAccent);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: purpleAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Let\'s start',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker(Color lightTextColor, Color purpleAccent) {
    final times = ['07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00'];
    int selectedIndex = 3; // Default to 10:00
    
    return StatefulBuilder(
      builder: (context, setState) {
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: times.length,
          itemBuilder: (context, index) {
            final isSelected = index == selectedIndex;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  times[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontSize: isSelected ? 32 : 20,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToSilenceMeditation(BuildContext context, Color lightTextColor, Color purpleAccent) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _SilenceMeditationScreen(),
      ),
    );
  }
}

class _SilenceMeditationScreen extends StatefulWidget {
  @override
  State<_SilenceMeditationScreen> createState() => _SilenceMeditationScreenState();
}

class _SilenceMeditationScreenState extends State<_SilenceMeditationScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  bool _isPaused = false;
  int _remainingTime = 359; // 5:59 in seconds

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * 3.14159, // Full rotation
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    ));
    _animationController.repeat();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && !_isPaused) {
        setState(() {
          if (_remainingTime > 0) {
            _remainingTime--;
            _startTimer();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Scaffold(
      backgroundColor: _hexToColor('1B0A33'),
      body: SafeArea(
        child: Stack(
          children: [
            // Background with stars
            SharedBackground(
              bgColorHex: '1B0A33',
              child: Container(),
            ),
            
            // Main content
            Column(
              children: [
                // Navigation bar with liquid glass effect
                _buildLiquidGlassNavBar(lightTextColor, purpleAccent),
                
                // Main visual element
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 3D Abstract Object
                        AnimatedBuilder(
                          animation: _rotationAnimation,
                          builder: (context, child) {
                            return Transform.rotate(
                              angle: _rotationAnimation.value,
                              child: Container(
                                width: 200,
                                height: 200,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                                child: CustomPaint(
                                  painter: _AbstractObjectPainter(),
                                ),
                              ),
                            );
                          },
                        ),
                        
                        const SizedBox(height: 40),
                        
                        // Instructions
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: [
                              Text(
                                'Close your eyes and keep calm in a silence',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'DMSans',
                                  color: lightTextColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Please relax and close your eyes. Ensure that your phone is not locked so that you can hear the end-of-meditation signal.',
                                textAlign: TextAlign.center,
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
                        
                        const SizedBox(height: 40),
                        
                        // Pause button
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isPaused = !_isPaused;
                            });
                            if (_isPaused) {
                              _animationController.stop();
                            } else {
                              _animationController.repeat();
                              _startTimer();
                            }
                          },
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: purpleAccent,
                            ),
                            child: Icon(
                              _isPaused ? Icons.play_arrow : Icons.pause,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // Timer
                        Text(
                          _formatTime(_remainingTime),
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            color: lightTextColor,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
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

  Widget _buildLiquidGlassNavBar(Color lightTextColor, Color purpleAccent) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.08),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    width: 50,
                    height: 50,
                    child: Icon(
                      Icons.chevron_left,
                      color: lightTextColor,
                      size: 24,
                    ),
                  ),
                ),
                
                // Title
                Expanded(
                  child: Text(
                    'Silence',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                
                // Empty space for balance
                Container(
                  width: 50,
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AbstractObjectPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 3;

    // Draw abstract flowing shapes
    final path = Path();
    path.moveTo(center.dx - radius * 0.5, center.dy);
    path.quadraticBezierTo(
      center.dx - radius * 0.8, center.dy - radius * 0.3,
      center.dx, center.dy - radius * 0.5,
    );
    path.quadraticBezierTo(
      center.dx + radius * 0.8, center.dy - radius * 0.3,
      center.dx + radius * 0.5, center.dy,
    );
    path.quadraticBezierTo(
      center.dx + radius * 0.3, center.dy + radius * 0.8,
      center.dx, center.dy + radius * 0.5,
    );
    path.quadraticBezierTo(
      center.dx - radius * 0.3, center.dy + radius * 0.8,
      center.dx - radius * 0.5, center.dy,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}