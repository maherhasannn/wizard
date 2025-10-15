// lib/main.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'shared_background.dart';
import 'intro_sequence_screen.dart'; // <-- IMPORT THE NEW SCREEN

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Interactive Font Screen',
      home: InitialLoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  bool _textVisible = false;

  final Map<String, dynamic> _phase = {
    'text': 'Good Evening!',
    'bgColor': '1B0A33',
    'textColor': '7F818C',
  };

  @override
  void initState() {
    super.initState();
    // Fade in the text
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) setState(() => _textVisible = true);
    });

    // Automatically navigate to the sequence screen
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const IntroSequenceScreen(), // <-- GO TO THE NEW SCREEN
            transitionsBuilder: (_, animation, __, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 1500),
          ),
        );
      }
    });
  }
  
  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SharedBackground(
        bgColorHex: _phase['bgColor'],
        child: Center(
          child: AnimatedOpacity(
            opacity: _textVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 1500),
            curve: Curves.easeIn,
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
      ),
    );
  }
}