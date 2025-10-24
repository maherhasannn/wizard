import 'package:flutter/material.dart';
import 'dart:ui';
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

class _PlanReadyScreenState extends State<PlanReadyScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
    final buttonTextStyle = TextStyle(
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

              // Simple circle without checkmark
              Container(
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
              ),

              const SizedBox(height: 40),

              // Main success text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Your personalized plan is ready',
                  textAlign: TextAlign.center,
                  style: TextStyle(
          fontFamily: 'DMSans',
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
                  style: TextStyle(
          fontFamily: 'DMSans',
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
