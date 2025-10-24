import 'package:flutter/material.dart';

class SilenceModeScreen extends StatefulWidget {
  const SilenceModeScreen({super.key});

  @override
  State<SilenceModeScreen> createState() => _SilenceModeScreenState();
}

class _SilenceModeScreenState extends State<SilenceModeScreen>
    with TickerProviderStateMixin {
  int _selectedHour = 10;
  bool _isSessionActive = false;
  Duration _sessionTime = Duration.zero;
  Duration _remainingTime = Duration.zero;
  
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<int> _timeOptions = [7, 8, 9, 10, 11, 12, 13];

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _startSession() {
    setState(() {
      _isSessionActive = true;
      _sessionTime = Duration(hours: _selectedHour);
      _remainingTime = _sessionTime;
    });
    
    _rotationController.repeat();
    _startCountdown();
  }

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isSessionActive && _remainingTime > Duration.zero) {
        setState(() {
          _remainingTime = Duration(seconds: _remainingTime.inSeconds - 1);
        });
        _startCountdown();
      } else if (_remainingTime == Duration.zero) {
        _endSession();
      }
    });
  }

  void _endSession() {
    setState(() {
      _isSessionActive = false;
      _remainingTime = Duration.zero;
    });
    _rotationController.stop();
  }

  void _pauseResumeSession() {
    setState(() {
      _isSessionActive = !_isSessionActive;
    });
    
    if (_isSessionActive) {
      _startCountdown();
      _rotationController.repeat();
    } else {
      _rotationController.stop();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inHours)}:${twoDigits(duration.inMinutes % 60)}:${twoDigits(duration.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Scaffold(
      backgroundColor: _hexToColor('1B0A33'),
      body: SafeArea(
        child: _isSessionActive ? _buildSessionView() : _buildTimeSelectionView(),
      ),
    );
  }

  Widget _buildTimeSelectionView() {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
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
              const Spacer(),
            ],
          ),

          const SizedBox(height: 40),

          // Title
          Text(
            'Silence',
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 32,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            'Choose time for your silence session.',
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.8),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 60),

          // Time selection
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
                Text(
                  'Select Duration',
                  style: TextStyle(
          fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: _timeOptions.map((hour) {
                    final isSelected = _selectedHour == hour;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedHour = hour;
                        });
                      },
                      child: Container(
                        width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? purpleAccent
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? purpleAccent
                                : lightTextColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '${hour.toString().padLeft(2, '0')}:00',
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: isSelected
                                  ? lightTextColor
                                  : lightTextColor.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Start button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _startSession,
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Let\'s start',
                style: TextStyle(
          fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSessionView() {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          // Header
          Row(
            children: [
              IconButton(
                onPressed: _endSession,
                icon: Icon(
                  Icons.close,
                  color: lightTextColor,
                  size: 24,
                ),
              ),
              const Spacer(),
            ],
          ),

          const Spacer(),

          // Animated icon
          AnimatedBuilder(
            animation: Listenable.merge([_pulseAnimation, _rotationController]),
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Transform.rotate(
                  angle: _rotationController.value * 2 * 3.14159,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          purpleAccent.withOpacity(0.8),
                          purpleAccent.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.psychology,
                        color: lightTextColor,
                        size: 60,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),

          // Timer display
          Text(
            _formatDuration(_remainingTime),
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 48,
              fontWeight: FontWeight.w300,
            ),
          ),

          const SizedBox(height: 24),

          // Instructions
          Text(
            'Close your eyes and keep calm in a silence.',
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(),

          // Play/Pause button
          GestureDetector(
            onTap: _pauseResumeSession,
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
                _isSessionActive ? Icons.pause : Icons.play_arrow,
                color: lightTextColor,
                size: 40,
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
