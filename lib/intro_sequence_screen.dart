import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'shared_background.dart';

// Enum to manage the current state of our animation sequence
// Expanded to handle separate fade-in and fade-out steps for text.
enum IntroPhase {
  showingImage1,
  phase2_TextFadeIn,
  phase2_TextFadeOut,
  phase3_TextFadeIn,
  phase3_TextFadeOut,
  phase4_TextFadeIn,
}

class IntroSequenceScreen extends StatefulWidget {
  const IntroSequenceScreen({super.key});

  @override
  State<IntroSequenceScreen> createState() => _IntroSequenceScreenState();
}

class _IntroSequenceScreenState extends State<IntroSequenceScreen> {
  IntroPhase _currentPhase = IntroPhase.showingImage1;
  bool _isMounted = true;

  // Store text for each phase in a list for easier management
  final List<Map<String, dynamic>> _textPhases = [
    {
      'text': 'Nobody is coming to save you',
      'textColor': 'F0E6D8',
    },
    {
      'text': 'Good',
      'textColor': 'F0E6D8',
    },
    {
      'text': "You're all you need",
      'textColor': 'F0E6D8',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAnimationSequence();
  }
  
  void _startAnimationSequence() {
    const stepDuration = Duration(milliseconds: 2500);

    // Sequence the phase changes with delays
    Timer(stepDuration, () => _setPhase(IntroPhase.phase2_TextFadeIn));
    Timer(stepDuration * 2, () => _setPhase(IntroPhase.phase2_TextFadeOut));
    Timer(stepDuration * 3, () => _setPhase(IntroPhase.phase3_TextFadeIn));
    Timer(stepDuration * 4, () => _setPhase(IntroPhase.phase3_TextFadeOut));
    Timer(stepDuration * 5, () => _setPhase(IntroPhase.phase4_TextFadeIn));
  }

  // Helper function to safely change state
  void _setPhase(IntroPhase newPhase) {
    if (_isMounted) {
      setState(() {
        _currentPhase = newPhase;
      });
    }
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

  // A reusable widget for the animated text.
  // It becomes visible only during its specified 'fadeInPhase'.
  Widget _buildAnimatedText(IntroPhase fadeInPhase, Map<String, dynamic> textData) {
    return AnimatedOpacity(
      opacity: _currentPhase == fadeInPhase ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 2500),
      curve: Curves.easeIn,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Text(
            textData['text'],
            textAlign: TextAlign.center,
            style: GoogleFonts.dmSans(
              color: _hexToColor(textData['textColor']),
              fontSize: 32,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
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
            // --- Image Layers ---
            // Each image is now visible during both the text fade-in and fade-out phases.
            AnimatedOpacity(
              opacity: _currentPhase == IntroPhase.showingImage1 ? 0.5 : 0.0,
              duration: const Duration(milliseconds: 1500),
              curve: Curves.easeInOut,
              child: _buildFadedImage('assets/images/intro1.png'),
            ),
            AnimatedOpacity(
              opacity: _currentPhase == IntroPhase.phase2_TextFadeIn ||
                       _currentPhase == IntroPhase.phase2_TextFadeOut
                  ? 0.7
                  : 0.0,
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
              child: _buildFadedImage('assets/images/intro2.png'),
            ),
            AnimatedOpacity(
              opacity: _currentPhase == IntroPhase.phase3_TextFadeIn ||
                       _currentPhase == IntroPhase.phase3_TextFadeOut
                  ? 0.7
                  : 0.0,
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
              child: _buildFadedImage('assets/images/intro3.png'),
            ),
            AnimatedOpacity(
              opacity: _currentPhase == IntroPhase.phase4_TextFadeIn ? 0.7 : 0.0,
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
              child: _buildFadedImage('assets/images/intro4.png'),
            ),

            // --- Text Layers ---
            // The logic now ensures one text fades out before the next fades in.
            _buildAnimatedText(IntroPhase.phase2_TextFadeIn, _textPhases[0]),
            _buildAnimatedText(IntroPhase.phase3_TextFadeIn, _textPhases[1]),
            _buildAnimatedText(IntroPhase.phase4_TextFadeIn, _textPhases[2]),
          ],
        ),
      ),
    );
  }
}

