import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shared_background.dart';
import 'plan_ready_screen.dart';

class PlanCraftingScreen extends StatefulWidget {
  final List<String> selectedPowers;
  final List<Map<String, dynamic>> powerOptions;

  const PlanCraftingScreen({
    super.key,
    required this.selectedPowers,
    required this.powerOptions,
  });

  @override
  State<PlanCraftingScreen> createState() => _PlanCraftingScreenState();
}

class _PlanCraftingScreenState extends State<PlanCraftingScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _glowController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    
    // Pulse animation for the orb
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

    // Glow animation for the orb
    _glowController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.8,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    // Start animations
    _pulseController.repeat(reverse: true);
    _glowController.repeat(reverse: true);

    // Auto-transition after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PlanReadyScreen(
              selectedPowers: widget.selectedPowers,
              powerOptions: widget.powerOptions,
            ),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  String _getPowerTitle(String powerId) {
    final power = widget.powerOptions.firstWhere(
      (p) => p['id'] == powerId,
      orElse: () => {'title': 'Unknown Power'},
    );
    return power['title'];
  }

  String _getSelectedPowersText() {
    if (widget.selectedPowers.isEmpty) return 'Your focus areas';
    if (widget.selectedPowers.length == 1) {
      return _getPowerTitle(widget.selectedPowers[0]);
    }
    if (widget.selectedPowers.length == 2) {
      return '${_getPowerTitle(widget.selectedPowers[0])} and ${_getPowerTitle(widget.selectedPowers[1])}';
    }
    return '${_getPowerTitle(widget.selectedPowers[0])} and ${widget.selectedPowers.length - 1} other areas';
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');

    return Scaffold(
      body: SharedBackground(
        bgColorHex: '1B0A33',
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pulsating orb
              AnimatedBuilder(
                animation: Listenable.merge([_pulseAnimation, _glowAnimation]),
                builder: (context, child) {
                  return Container(
                    width: 120 * _pulseAnimation.value,
                    height: 120 * _pulseAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(_glowAnimation.value),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(_glowAnimation.value * 0.5),
                          blurRadius: 40 * _glowAnimation.value,
                          spreadRadius: 10 * _glowAnimation.value,
                        ),
                        BoxShadow(
                          color: _hexToColor('6A1B9A').withOpacity(_glowAnimation.value * 0.3),
                          blurRadius: 60 * _glowAnimation.value,
                          spreadRadius: 20 * _glowAnimation.value,
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 60),

              // Main text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Crafting your plan...',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: lightTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Subtitle text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Based on your focus: ${_getSelectedPowersText()}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: lightTextColor.withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
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
