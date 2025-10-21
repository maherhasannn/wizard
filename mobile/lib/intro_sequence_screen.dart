import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'shared_background.dart';
import 'power_selection_screen.dart';
import 'screens/why_you_came_screen.dart';
import 'screens/login_screen.dart';

// Enum has been expanded to manage the final screen
enum IntroPhase {
  showingImage1,
  phase2_TextFadeIn,
  phase2_TextFadeOut,
  phase3_TextFadeIn,
  phase3_TextFadeOut,
  phase4_TextFadeIn,
  phase4_TextFadeOut, // Phase for final text to fade out
  phase5_SignUp,     // Phase for the new sign-up screen
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
    // Added timers for the new phases
    Timer(stepDuration * 6, () => _setPhase(IntroPhase.phase4_TextFadeOut));
    Timer(stepDuration * 7, () => _setPhase(IntroPhase.phase5_SignUp));
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
  Widget _buildAnimatedText(
      IntroPhase fadeInPhase, Map<String, dynamic> textData) {
    // This widget implicitly handles fade-out when the phase changes.
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

  // New widget for the final sign-up screen content
  Widget _buildSignUpContent() {
    final lightTextColor = _hexToColor('F0E6D8');
    final buttonTextStyle = GoogleFonts.dmSans(
      color: lightTextColor,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    );
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main content (text and button)
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  "Let's unleash the force you already are",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: lightTextColor,
                    fontSize: 26,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),


              // ...
              const SizedBox(height: 40),
              // ADD PADDING TO MATCH THE TEXT'S HORIZONTAL SPACE
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: SizedBox(
                  width: double.infinity, // MAKE THE BUTTON EXPAND
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WhyYouCameScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _hexToColor('6A1B9A'),
                      // Adjust vertical padding as needed, horizontal is now controlled by SizedBox
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Unleash My Power',
                      style: buttonTextStyle,
                    ),
                  ),
                ),
              ),
              //...



            ],
          ),
        ),
        
        
        // Bottom buttons
        Positioned(
          bottom: 30,
          left: 20,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            child: Text('Login', style: buttonTextStyle.copyWith(fontSize: 14)),
          ),
        ),
        Positioned(
          bottom: 30,
          right: 20,
          child: TextButton(
            onPressed: () {
              // TODO: Add logic for Restore Purchase
            },
            child: Text('Restore Purchase', style: buttonTextStyle.copyWith(fontSize: 14)),
          ),
        ),
      ],
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
              opacity: _currentPhase == IntroPhase.phase4_TextFadeIn ||
                      _currentPhase == IntroPhase.phase4_TextFadeOut
                  ? 0.7
                  : 0.0,
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
              child: _buildFadedImage('assets/images/intro4.png'),
            ),
            // Added final background image for the sign-up screen
            AnimatedOpacity(
              opacity: _currentPhase == IntroPhase.phase5_SignUp ? 0.8 : 0.0,
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeInOut,
              child: _buildFadedImage('assets/images/intro5.png'),
            ),

            // --- Text Layers ---
            _buildAnimatedText(IntroPhase.phase2_TextFadeIn, _textPhases[0]),
            _buildAnimatedText(IntroPhase.phase3_TextFadeIn, _textPhases[1]),
            _buildAnimatedText(IntroPhase.phase4_TextFadeIn, _textPhases[2]),
            
            // --- Sign-Up Screen Layer ---
            AnimatedOpacity(
              opacity: _currentPhase == IntroPhase.phase5_SignUp ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 2000),
              curve: Curves.easeIn,
              child: _buildSignUpContent(),
            ),
          ],
        ),
      ),
    );
  }
}