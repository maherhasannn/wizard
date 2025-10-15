// lib/intro_2.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shared_background.dart';

class Intro2Screen extends StatefulWidget {
  const Intro2Screen({super.key});

  @override
  State<Intro2Screen> createState() => _Intro2ScreenState();
}

class _Intro2ScreenState extends State<Intro2Screen> {
  bool _contentVisible = false;

  final Map<String, dynamic> _phase = {
    'text': 'Nobody is coming to save you',
    'textColor': 'F0E6D8',
  };

  @override
  void initState() {
    super.initState();
    // Fade in the new content after the screen transition
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _contentVisible = true);
    });
  }
  
  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  // Reusable faded image widget
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
            // This crossfades between a transparent container and the new image
            AnimatedCrossFade(
              firstChild: Container(), // Fades from nothing
              secondChild: _buildFadedImage('assets/images/intro2.png'),
              crossFadeState: _contentVisible
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 2000),
            ),
            
            // The text fades in on top
            AnimatedOpacity(
              opacity: _contentVisible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 2500),
              curve: Curves.easeIn,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  _phase['text'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.dmSans(
                    color: _hexToColor(_phase['textColor']),
                    fontSize: 36,
                    fontWeight: FontWeight.w300,
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