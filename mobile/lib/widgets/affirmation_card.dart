import 'package:flutter/material.dart';

class AffirmationCard extends StatefulWidget {
  const AffirmationCard({super.key});

  @override
  State<AffirmationCard> createState() => _AffirmationCardState();
}

class _AffirmationCardState extends State<AffirmationCard> {
  bool _hasWatched = false;
  int _selectedFeeling = -1;

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Affirmation of the day',
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),

        // Affirmation card
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _hexToColor('6A1B9A').withOpacity(0.3),
                _hexToColor('4F1B80').withOpacity(0.3),
              ],
            ),
            border: Border.all(
              color: lightTextColor.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // Background pattern/texture
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: RadialGradient(
                        center: Alignment.center,
                        radius: 1.0,
                        colors: [
                          lightTextColor.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    if (!_hasWatched) ...[
                      // Play button
                      Container(
                        width: 80,
                        height: 80,
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
                        child: Icon(
                          Icons.play_arrow,
                          color: lightTextColor,
                          size: 40,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Take an daily meditation for life',
                        textAlign: TextAlign.center,
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ] else ...[
                      // Post-watch content
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Take an daily meditation for life',
                                textAlign: TextAlign.center,
                                style: TextStyle(
          fontFamily: 'DMSans',
                                  color: lightTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _hasWatched = false;
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _hexToColor('6A1B9A'),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      'Take a new one',
                                      style: TextStyle(
          fontFamily: 'DMSans',
                                        color: lightTextColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Replay logic
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: lightTextColor.withOpacity(0.1),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 8,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      'See again',
                                      style: TextStyle(
          fontFamily: 'DMSans',
                                        color: lightTextColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // Interaction icons
              if (_hasWatched)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.download,
                        color: lightTextColor.withOpacity(0.7),
                        size: 20,
                      ),
                      Icon(
                        Icons.favorite_border,
                        color: lightTextColor.withOpacity(0.7),
                        size: 20,
                      ),
                      Icon(
                        Icons.comment_outlined,
                        color: lightTextColor.withOpacity(0.7),
                        size: 20,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Feeling section
        if (_hasWatched) ...[
          const SizedBox(height: 20),
          Text(
            'How is your feeling?',
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(5, (index) {
              final emojis = ['😢', '😕', '😐', '😊', '😍'];
              final isSelected = _selectedFeeling == index;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFeeling = index;
                  });
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? _hexToColor('6A1B9A').withOpacity(0.3)
                        : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? lightTextColor.withOpacity(0.5)
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      emojis[index],
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
