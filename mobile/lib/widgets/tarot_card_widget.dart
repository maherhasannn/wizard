import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/tarot_card.dart';
import '../shared_background.dart';

class TarotCardWidget extends StatefulWidget {
  final TarotCard tarotCard;
  final VoidCallback onClose;
  final VoidCallback onGrabNewMessage;

  const TarotCardWidget({
    super.key,
    required this.tarotCard,
    required this.onClose,
    required this.onGrabNewMessage,
  });

  @override
  State<TarotCardWidget> createState() => _TarotCardWidgetState();
}

class _TarotCardWidgetState extends State<TarotCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _textController;
  late Animation<double> _cardAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();
    
    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.easeOutBack,
    );

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOut,
    );

    _cardController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      _textController.forward();
    });
  }

  @override
  void dispose() {
    _cardController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return SharedBackground(
      bgColorHex: '2D1B69',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              // Top Navigation Bar
              _buildTopNavBar(lightTextColor),
              
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      
                      // Tarot Card Image
                      ScaleTransition(
                        scale: _cardAnimation,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                            maxHeight: MediaQuery.of(context).size.height * 0.4,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.asset(
                              widget.tarotCard.imagePath,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 200,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      color: purpleAccent.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(color: lightTextColor.withOpacity(0.3)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.image_not_supported, color: lightTextColor, size: 50),
                                        const SizedBox(height: 10),
                                        Text(
                                          widget.tarotCard.title,
                                          style: GoogleFonts.dmSans(
                                            color: lightTextColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Main Advice
                      FadeTransition(
                        opacity: _textAnimation,
                        child: Text(
                          widget.tarotCard.mainAdvice,
                          style: GoogleFonts.dmSans(
                            color: lightTextColor,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Description
                      FadeTransition(
                        opacity: _textAnimation,
                        child: Text(
                          widget.tarotCard.description,
                          style: GoogleFonts.dmSans(
                            color: lightTextColor.withOpacity(0.8),
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 30),
                      
                      // Grab a new message button
                      FadeTransition(
                        opacity: _textAnimation,
                        child: GestureDetector(
                          onTap: widget.onGrabNewMessage,
                          child: Text(
                            widget.tarotCard.actionText,
                            style: GoogleFonts.dmSans(
                              color: purpleAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                              decorationColor: purpleAccent,
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 50),
                      
                      // Media Player Control
                      FadeTransition(
                        opacity: _textAnimation,
                        child: _buildMediaPlayer(lightTextColor),
                      ),
                      
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavBar(Color lightTextColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: lightTextColor, size: 24),
            onPressed: widget.onClose,
          ),
          Text(
            'Message of the day',
            style: GoogleFonts.dmSans(
              color: lightTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            icon: Icon(Icons.share, color: lightTextColor, size: 24),
            onPressed: () {
              // Handle share action
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMediaPlayer(Color lightTextColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: lightTextColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: lightTextColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: lightTextColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.play_arrow, color: lightTextColor, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tarotCard.mediaTitle,
                  style: GoogleFonts.dmSans(
                    color: lightTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.tarotCard.mediaDuration,
                  style: GoogleFonts.dmSans(
                    color: lightTextColor.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}