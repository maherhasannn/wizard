import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageOfDayFlow extends StatefulWidget {
  const MessageOfDayFlow({super.key});

  @override
  State<MessageOfDayFlow> createState() => _MessageOfDayFlowState();
}

class _MessageOfDayFlowState extends State<MessageOfDayFlow>
    with TickerProviderStateMixin {
  bool _isUnlocked = false;
  bool _isLoading = false;
  int _loadingProgress = 0;
  
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _unlockMessage() async {
    if (_isUnlocked || _isLoading) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate loading progress
    for (int i = 0; i <= 100; i += 2) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (mounted) {
        setState(() {
          _loadingProgress = i;
        });
      }
    }

    // Start card flip animation
    _flipController.forward();

    setState(() {
      _isLoading = false;
      _isUnlocked = true;
    });
  }

  Widget _buildLoadingScreen() {
    final lightTextColor = _hexToColor('F0E6D8');

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: _hexToColor('6A1B9A').withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: lightTextColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$_loadingProgress%',
              style: GoogleFonts.dmSans(
                color: lightTextColor,
                fontSize: 48,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 200,
              height: 4,
              decoration: BoxDecoration(
                color: lightTextColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _loadingProgress / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: lightTextColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnlockedMessage() {
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
          children: [
            // Tarot card with flip animation
            AnimatedBuilder(
              animation: _flipAnimation,
              builder: (context, child) {
                final isShowingFront = _flipAnimation.value >= 0.5;
                return Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(_flipAnimation.value * 3.14159),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..rotateY(isShowingFront ? 3.14159 : 0),
                    child: Container(
                      width: 120,
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber,
                          width: 2,
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isShowingFront
                              ? [Colors.amber.shade100, Colors.amber.shade300]
                              : [Colors.amber.shade800, Colors.amber.shade900],
                        ),
                      ),
                      child: isShowingFront
                          ? _buildTarotCardFront()
                          : _buildTarotCardBack(),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            // Message text
            Text(
              'You will meet your destiny very soon and unexpectedly.',
              textAlign: TextAlign.center,
              style: GoogleFonts.dmSans(
                color: lightTextColor,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 8),

            // Arrow indicating more content
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tap for full message',
                  style: GoogleFonts.dmSans(
                    color: lightTextColor.withOpacity(0.7),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  color: lightTextColor.withOpacity(0.7),
                  size: 12,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTarotCardFront() {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          // Sun symbol
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.orange,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withOpacity(0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.wb_sunny,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'THE SUN',
            style: GoogleFonts.dmSans(
              color: Colors.amber.shade900,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Child on horse (simplified)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.child_care, color: Colors.amber.shade800, size: 16),
              Icon(Icons.pets, color: Colors.amber.shade800, size: 16),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTarotCardBack() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.amber.shade800, Colors.amber.shade900],
        ),
      ),
      child: Center(
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.amber.shade700,
            border: Border.all(color: Colors.amber.shade400, width: 2),
          ),
          child: Center(
            child: Text(
              '★',
              style: TextStyle(
                color: Colors.amber.shade100,
                fontSize: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Unlock your message of the day',
          style: GoogleFonts.dmSans(
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Unique for ${DateTime.now().day} ${_getMonthName(DateTime.now().month)} ${DateTime.now().year}',
          style: GoogleFonts.dmSans(
            color: lightTextColor.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 16),

        if (_isLoading)
          _buildLoadingScreen()
        else if (_isUnlocked)
          _buildUnlockedMessage()
        else
          // Unlock button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _unlockMessage,
              style: ElevatedButton.styleFrom(
                backgroundColor: _hexToColor('6A1B9A'),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Unlock Message',
                style: GoogleFonts.dmSans(
                  color: lightTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}
