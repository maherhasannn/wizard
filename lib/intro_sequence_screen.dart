import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shared_background.dart';

// Enum to manage the current state of our animation sequence
enum IntroPhase {
  showingImage1,
  showingImage2,
}

class IntroSequenceScreen extends StatefulWidget {
  const IntroSequenceScreen({super.key});

  @override
  State<IntroSequenceScreen> createState() => _IntroSequenceScreenState();
}

class _IntroSequenceScreenState extends State<IntroSequenceScreen> {
  IntroPhase _currentPhase = IntroPhase.showingImage1;
  bool _isMounted = true;

  final Map<String, dynamic> _textPhase = {
    'text': 'Nobody is coming to save you.',
    'textColor': 'F0E6D8',
  };

  @override
  void initState() {
    super.initState();

    // This is the corrected timing logic.
    // The screen takes 1500ms to fade in. We wait for that to finish,
    // then wait an additional 1000ms (1 second) before changing the phase.
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (_isMounted) {
        setState(() {
          _currentPhase = IntroPhase.showingImage2;
        });
      }
    });
  }
  
  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  // A reusable widget to create the vertical fade effect on an image
  Widget _buildFadedImage(String imagePath) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [
            Colors.transparent,
            Colors.white,
            Colors.white,
            Colors.transparent
          ],
          stops: const [0.0, 0.15, 0.85, 1.0],
        ).createShader(rect);
      },
      blendMode: BlendMode.dstIn,
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SharedBackground(
        bgColorHex: '1B0A33',
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            // --- Image 1 Layer ---
            // Fades in with the screen, then fades out when the phase changes.
            AnimatedOpacity(
              opacity: _currentPhase == IntroPhase.showingImage1 ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              child: _buildFadedImage('assets/images/intro1.png'),
            ),

            // --- Image 2 Layer ---
            // Fades in when the phase changes.
            AnimatedOpacity(
              // UPDATED: Changed opacity from 0.5 to 0.7 for 70% opacity
              opacity: _currentPhase == IntroPhase.showingImage2 ? 0.7 : 0.0,
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
              child: _buildFadedImage('assets/images/intro2.png'),
            ),

            // --- Text Layer ---
            AnimatedOpacity(
              opacity: _currentPhase == IntroPhase.showingImage2 ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 2500),
              curve: Curves.easeIn,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Text(
                    _textPhase['text'],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.dmSans(
                      color: _hexToColor(_textPhase['textColor']),
                      fontSize: 32,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

