// starry effect

import 'package:flutter/material.dart';
import 'dart:math';

// This is a reusable widget for the consistent background visuals.
class SharedBackground extends StatefulWidget {
  final Widget child;
  final String bgColorHex;

  const SharedBackground({
    super.key,
    required this.child,
    required this.bgColorHex,
  });

  @override
  State<SharedBackground> createState() => _SharedBackgroundState();
}

class _SharedBackgroundState extends State<SharedBackground> {
  late final List<Star> _stars;
  final String _gradientBlurColorHex = '4F1B80';
  final Color _starColor = const Color(0xff7F818C); // Static star color for consistency

  @override
  void initState() {
    super.initState();
    _stars = _generateStars();
  }

  // Generates the starfield
  List<Star> _generateStars() {
    final random = Random();
    const numStars = 70;
    return List.generate(numStars, (index) {
      return Star(
        size: 1.0 + random.nextDouble() * 2.5,
        topFraction: random.nextDouble() * 0.6,
        leftFraction: random.nextDouble(),
        opacity: 0.4 + random.nextDouble() * 0.4,
      );
    });
  }

  Color _hexToColor(String hexCode) {
    String colorString = hexCode.replaceAll('#', '');
    if (colorString.length == 6) {
      return Color(int.parse('ff$colorString', radix: 16));
    }
    return Colors.black;
  }

  // Builds the atmospheric gradient blurs
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
    const double blurIntensity = 0.7;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      color: _hexToColor(widget.bgColorHex),
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          fit: StackFit.expand, // Ensures the Stack fills the screen
          children: [
            // --- BACKGROUND LAYERS ---
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
                      color: _starColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }).toList(),

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
            
            // --- FOREGROUND CONTENT ---
            // The unique content of each screen will be placed here.
            widget.child,
          ],
        );
      }),
    );
  }
}

// Data model for a star
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