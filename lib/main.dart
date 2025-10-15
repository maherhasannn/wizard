import 'package:flutter/material.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Interactive Font Screen',
      home: CustomHomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Simple model to hold star properties
class Star {
  final double size;
  final double topFraction;
  final double leftFraction;
  final double opacity;

  Star({
    required this.size,
    required this.topFraction,
    required this.leftFraction,
    required this.opacity,
  });
}

class CustomHomeScreen extends StatefulWidget {
  const CustomHomeScreen({super.key});

  @override
  State<CustomHomeScreen> createState() => _CustomHomeScreenState();
}

class _CustomHomeScreenState extends State<CustomHomeScreen> {
  int _phaseIndex = 0;
  bool _isAutoTransitioning = false;
  bool _initialTextVisible = false; // <-- For initial text fade-in
  late final List<Star> _stars;
  final String _gradientBlurColorHex = '4F1B80';

  @override
  void initState() {
    super.initState();
    _stars = _generateStars();

    // Trigger the fade-in animation shortly after the widget is built
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _initialTextVisible = true;
        });
      }
    });
  }

  List<Star> _generateStars() {
    final random = Random();
    const numStars = 70;
    final generatedStars = <Star>[];

    for (int i = 0; i < numStars; i++) {
      generatedStars.add(Star(
        size: 1.0 + random.nextDouble() * 2.5,
        topFraction: random.nextDouble() * 0.6,
        leftFraction: random.nextDouble(),
        opacity: 0.4 + random.nextDouble() * 0.4,
      ));
    }
    return generatedStars;
  }

  Color _hexToColor(String hexCode) {
    String colorString = hexCode.replaceAll('#', '');
    if (colorString.length == 6) {
      return Color(int.parse('ff$colorString', radix: 16));
    }
    return Colors.black;
  }

  final List<Map<String, dynamic>> _phases = [
    {
      'text': 'Good Evening!',
      'bgColor': '1B0A33',
      'textColor': '7F818C',
      'flexRatio': 2,
    },
    {
      'text': 'Nobody is coming to save you',
      'bgColor': '1B0A33',
      'textColor': 'F0E6D8',
      'flexRatio': 2,
    },
  ];

  void _handleTap() {
    if (_phaseIndex == 0 && !_isAutoTransitioning) {
      setState(() {
        _isAutoTransitioning = true;
      });

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isAutoTransitioning = false;
            _phaseIndex = 1;
          });
        }
      });
    }
  }

  Widget _buildGradientBlur(BoxConstraints constraints, String hexColor,
      Alignment alignment, double intensity) {
    final Color blurColor = _hexToColor(hexColor);
    final double maxDimension =
        max(constraints.maxHeight, constraints.maxWidth);
    final double containerSize =
        maxDimension * (0.5 + intensity * 0.5).clamp(0.5, 1.0);

    return Align(
      alignment: alignment,
      child: Container(
        width: containerSize,
        height: containerSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              blurColor.withOpacity(
                (0.05 + intensity * 0.4).clamp(0.0, 0.8),
              ),
              blurColor.withOpacity(0.0),
            ],
            stops: const [0.0, 0.7],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentPhase = _phases[_phaseIndex];
    final Color starColor = _hexToColor(_phases[0]['textColor']);
    const double blurIntensity = 0.7;

    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        color: _hexToColor(currentPhase['bgColor']),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // 1. STAR LAYER
                ..._stars.map((star) {
                  return Positioned(
                    top: constraints.maxHeight * star.topFraction,
                    left: constraints.maxWidth * star.leftFraction,
                    child: Opacity(
                      opacity: star.opacity,
                      child: Container(
                        width: star.size,
                        height: star.size,
                        decoration: BoxDecoration(
                          color: starColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }).toList(),

                // 2. GRADIENT BLUR LAYER
                Positioned.fill(
                  child: ClipRect(
                    child: Stack(
                      children: [
                        _buildGradientBlur(constraints, _gradientBlurColorHex,
                            Alignment.topLeft, blurIntensity),
                        _buildGradientBlur(constraints, _gradientBlurColorHex,
                            Alignment.bottomRight, blurIntensity),
                      ],
                    ),
                  ),
                ),

                // 2.5 IMAGE FADE-IN LAYER WITH EDGE BLUR
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: _phaseIndex == 1 ? 0.5 : 0.0,
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeInOut,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient( // <-- Switched to LinearGradient
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: const [
                            Colors.transparent, // Top is transparent
                            Colors.white,       // Fades into opaque
                            Colors.white,       // Stays opaque
                            Colors.transparent, // Fades out to transparent at the bottom
                          ],
                          // THIS IS WHERE YOU MANUALLY ADJUST THE BLUR
                          stops: const [
                            0.0,  // Start of top fade (at the very top)
                            0.15, // End of top fade (15% down)
                            0.85, // Start of bottom fade (85% down)
                            1.0,  // End of bottom fade (at the very bottom)
                          ],
                        ).createShader(rect);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        'assets/images/intro1.png',
                        fit: BoxFit.cover, // Keeps the image filling the screen
                      ),
                    ),
                  ),
                ),

                // 3. MAIN CONTENT LAYER
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(flex: currentPhase['flexRatio'] as int),
                      SizedBox(
                        width: constraints.maxWidth,
                        child: AnimatedOpacity( // <-- Controls initial fade-in
                          opacity: _initialTextVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeIn,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 1000),
                            switchOutCurve: Curves.easeInQuint,
                            switchInCurve: Curves.easeOutQuint,
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return FadeTransition(
                                opacity: animation,
                                child: child,
                              );
                            },
                            child: Padding(
                              key: ValueKey<String>(currentPhase['text']),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40.0),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  currentPhase['text'],
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.dmSans(
                                    color: _hexToColor(currentPhase['textColor']),
                                    fontSize: 36,
                                    fontWeight: FontWeight.w300,
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Spacer(flex: 5 - (currentPhase['flexRatio'] as int)),
                    ],
                  ),
                ),

                // 4. SPINNER LAYER
                Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: AnimatedOpacity(
                      opacity: _isAutoTransitioning ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: CircularProgressIndicator(
                        color: _hexToColor(_phases[0]['textColor']),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}