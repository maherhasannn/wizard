import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shared_background.dart';
import 'main_app_screen.dart';

class PlanReadyScreen extends StatefulWidget {
  final List<String> selectedPowers;
  final List<Map<String, dynamic>> powerOptions;

  const PlanReadyScreen({
    super.key,
    required this.selectedPowers,
    required this.powerOptions,
  });

  @override
  State<PlanReadyScreen> createState() => _PlanReadyScreenState();
}

class _PlanReadyScreenState extends State<PlanReadyScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkmarkController;
  late AnimationController _scaleController;
  late Animation<double> _checkmarkAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // Checkmark animation
    _checkmarkController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _checkmarkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _checkmarkController,
      curve: Curves.elasticOut,
    ));

    // Scale animation for the circle
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));

    // Start animations with slight delay
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        _scaleController.forward();
      }
    });
    
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _checkmarkController.forward();
      }
    });
  }

  @override
  void dispose() {
    _checkmarkController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _continueToApp() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => MainAppScreen(
          selectedPowers: widget.selectedPowers,
          powerOptions: widget.powerOptions,
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final buttonTextStyle = GoogleFonts.dmSans(
      color: lightTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      body: SharedBackground(
        bgColorHex: '1B0A33',
        child: SafeArea(
          child: Column(
            children: [
              // Spacer to push content to center
              const Spacer(flex: 2),

              // Animated checkmark circle
              AnimatedBuilder(
                animation: Listenable.merge([_scaleAnimation, _checkmarkAnimation]),
                builder: (context, child) {
                  return Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _hexToColor('6A1B9A'),
                        boxShadow: [
                          BoxShadow(
                            color: _hexToColor('6A1B9A').withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _checkmarkAnimation,
                          builder: (context, child) {
                            return CustomPaint(
                              size: const Size(60, 60),
                              painter: CheckmarkPainter(
                                progress: _checkmarkAnimation.value,
                                color: lightTextColor,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Main success text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Your personalized plan is ready',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: lightTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Subtitle text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'We\'re ready to begin your experience in the app.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: lightTextColor.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              // Spacer to push button to bottom
              const Spacer(flex: 3),

              // Continue button
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _continueToApp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hexToColor('6A1B9A'),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Continue',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom painter for animated checkmark
class CheckmarkPainter extends CustomPainter {
  final double progress;
  final Color color;

  CheckmarkPainter({
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    
    // Checkmark path
    final double checkmarkLength = size.width * 0.6;
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    
    // Starting point (bottom left of checkmark)
    final double startX = centerX - checkmarkLength * 0.3;
    final double startY = centerY + checkmarkLength * 0.2;
    
    // Middle point (center of checkmark)
    final double midX = centerX - checkmarkLength * 0.1;
    final double midY = centerY;
    
    // End point (top right of checkmark)
    final double endX = centerX + checkmarkLength * 0.4;
    final double endY = centerY - checkmarkLength * 0.3;

    // Draw the checkmark based on progress
    if (progress > 0) {
      path.moveTo(startX, startY);
      path.lineTo(midX, midY);
      
      // First part of checkmark
      final firstPartProgress = (progress * 2).clamp(0.0, 1.0);
      final firstPartPath = Path();
      firstPartPath.moveTo(startX, startY);
      firstPartPath.lineTo(midX, midY);
      
      final firstPartMetrics = firstPartPath.computeMetrics().first;
      final firstPartExtract = firstPartMetrics.extractPath(0, firstPartMetrics.length * firstPartProgress);
      
      canvas.drawPath(firstPartExtract, paint);
      
      // Second part of checkmark
      if (progress > 0.5) {
        final secondPartProgress = ((progress - 0.5) * 2).clamp(0.0, 1.0);
        final secondPartPath = Path();
        secondPartPath.moveTo(midX, midY);
        secondPartPath.lineTo(endX, endY);
        
        final secondPartMetrics = secondPartPath.computeMetrics().first;
        final secondPartExtract = secondPartMetrics.extractPath(0, secondPartMetrics.length * secondPartProgress);
        
        canvas.drawPath(secondPartExtract, paint);
      }
    }
  }

  @override
  bool shouldRepaint(CheckmarkPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}
