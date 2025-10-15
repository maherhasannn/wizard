import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'power_preview_screen.dart';

class PowerSelectionScreen extends StatefulWidget {
  const PowerSelectionScreen({super.key});

  @override
  State<PowerSelectionScreen> createState() => _PowerSelectionScreenState();
}

class _PowerSelectionScreenState extends State<PowerSelectionScreen> {
  final List<String> _selectedPowers = [];

  final List<Map<String, dynamic>> _powerOptions = [
    {
      'id': 'unbreakable_heart',
      'title': 'My Unbreakable Heart',
      'subtitle': 'Heal, grow, and unleash your glow up.',
      'icon': Icons.favorite,
      'color': const Color(0xFFE91E63),
    },
    {
      'id': 'unshakable_confidence',
      'title': 'My Unshakable Confidence',
      'subtitle': 'Own every room you walk into.',
      'icon': Icons.star,
      'color': const Color(0xFFEC407A),
    },
    {
      'id': 'magnetic_energy',
      'title': 'My Magnetic Energy',
      'subtitle': 'Attract, don\'t chase. Become irresistible.',
      'icon': Icons.bolt,
      'color': const Color(0xFFFFEB3B),
    },
    {
      'id': 'financial_empire',
      'title': 'My Financial Empire',
      'subtitle': 'Build the wealth you deserve.',
      'icon': Icons.account_balance,
      'color': const Color(0xFF4CAF50),
    },
    {
      'id': 'sovereign_energy',
      'title': 'My Sovereign Energy',
      'subtitle': 'To protect my peace.',
      'icon': Icons.workspace_premium,
      'color': const Color(0xFF6A1B9A),
    },
  ];

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _togglePower(String powerId) {
    setState(() {
      if (_selectedPowers.contains(powerId)) {
        _selectedPowers.remove(powerId);
      } else {
        _selectedPowers.add(powerId);
      }
    });
  }

  void _continue() {
    if (_selectedPowers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one power focus'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PowerPreviewScreen(
          selectedPowers: _selectedPowers,
          powerOptions: _powerOptions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');

    return Scaffold(
      backgroundColor: _hexToColor('1B0A33'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Header
              Text(
                'Where does your power go first?',
                style: GoogleFonts.dmSans(
                  color: lightTextColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 40),

              // Power options grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.4,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _powerOptions.length,
                  itemBuilder: (context, index) {
                    final power = _powerOptions[index];
                    final isSelected = _selectedPowers.contains(power['id']);

                    return GestureDetector(
                      onTap: () => _togglePower(power['id']),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? power['color'].withOpacity(0.15)
                              : lightTextColor.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected
                                ? power['color']
                                : lightTextColor.withOpacity(0.2),
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: power['color'].withOpacity(0.3),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : [],
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    power['icon'],
                                    color: power['color'],
                                    size: 32,
                                  ),
                                  const SizedBox(height: 8),
                                  Flexible(
                                    child: Text(
                                      power['title'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.dmSans(
                                        color: lightTextColor,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Flexible(
                                    child: Text(
                                      power['subtitle'],
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.dmSans(
                                        color: lightTextColor.withOpacity(0.7),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              Positioned(
                                top: 8,
                                right: 8,
                                child: Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: _hexToColor('6A1B9A'),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: lightTextColor,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 30),

              // Continue button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _continue,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _hexToColor('6A1B9A'),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'Continue',
                    style: GoogleFonts.dmSans(
                      color: lightTextColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
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