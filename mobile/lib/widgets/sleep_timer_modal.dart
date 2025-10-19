import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class SleepTimerModal extends StatefulWidget {
  const SleepTimerModal({super.key});

  @override
  State<SleepTimerModal> createState() => _SleepTimerModalState();
}

class _SleepTimerModalState extends State<SleepTimerModal> {
  int _selectedMinutes = 30;
  final List<int> _timeOptions = [5, 10, 15, 20, 25, 30, 45, 60];

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Text(
            'Sleep Timer',
            style: GoogleFonts.dmSans(
              color: lightTextColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 32),

          // Time selector
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: lightTextColor.withOpacity(0.05),
              border: Border.all(
                color: lightTextColor.withOpacity(0.2),
                width: 2,
              ),
            ),
            child: Stack(
              children: [
                // Time options positioned around the circle
                ...List.generate(_timeOptions.length, (index) {
                  final minutes = _timeOptions[index];
                  final angle = (index * 2 * 3.14159) / _timeOptions.length - 3.14159 / 2;
                  final radius = 70.0;
                  final x = radius * (1 + 0.8 * cos(angle));
                  final y = radius * (1 + 0.8 * sin(angle));

                  return Positioned(
                    left: x,
                    top: y,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMinutes = minutes;
                        });
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _selectedMinutes == minutes
                              ? purpleAccent
                              : Colors.transparent,
                          border: Border.all(
                            color: _selectedMinutes == minutes
                                ? purpleAccent
                                : lightTextColor.withOpacity(0.3),
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            minutes.toString(),
                            style: GoogleFonts.dmSans(
                              color: _selectedMinutes == minutes
                                  ? lightTextColor
                                  : lightTextColor.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                // Center display
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _selectedMinutes.toString(),
                        style: GoogleFonts.dmSans(
                          color: lightTextColor,
                          fontSize: 48,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'minutes',
                        style: GoogleFonts.dmSans(
                          color: lightTextColor.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Launch button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // TODO: Implement sleep timer functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Sleep timer set for $_selectedMinutes minutes'),
                    backgroundColor: purpleAccent,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: purpleAccent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: Text(
                'Launch Timer',
                style: GoogleFonts.dmSans(
                  color: lightTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Cancel button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: GoogleFonts.dmSans(
                  color: lightTextColor.withOpacity(0.7),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

