import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import '../models/tarot_card.dart';
import '../shared_background.dart';

class TarotCardWidget extends StatefulWidget {
  final TarotCard tarotCard;
  final VoidCallback onClose;
  final VoidCallback onGrabNewMessage;
  final bool isFirstLoadOfDay;

  const TarotCardWidget({
    super.key,
    required this.tarotCard,
    required this.onClose,
    required this.onGrabNewMessage,
    this.isFirstLoadOfDay = true,
  });

  @override
  State<TarotCardWidget> createState() => _TarotCardWidgetState();
}

class _TarotCardWidgetState extends State<TarotCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _cardController;
  late AnimationController _progressController;
  late AnimationController _textController;
  
  late Animation<double> _cardAnimation;
  late Animation<double> _progressAnimation;
  late Animation<double> _textAnimation;
  
  int _progressPercentage = 0;
  bool _isLoading = true;
  bool _showCard = false;
  bool _showText = false;

  @override
  void initState() {
    super.initState();

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _progressController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );


    _cardAnimation = CurvedAnimation(
      parent: _cardController,
      curve: Curves.elasticOut,
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOut,
    );

    _textAnimation = CurvedAnimation(
      parent: _textController,
      curve: Curves.easeIn,
    );

    // TEMPORARILY DISABLED FOR TESTING - Skip loading animation
    _isLoading = false;
    _showCard = true;
    _showText = true;
    _cardController.forward();
    _textController.forward();
    
    // Original loading logic (commented out for testing):
    // if (widget.isFirstLoadOfDay) {
    //   _startLoadingSequence();
    // } else {
    //   // Skip loading animation, show card immediately
    //   _isLoading = false;
    //   _showCard = true;
    //   _showText = true;
    //   _cardController.forward();
    //   _textController.forward();
    // }
  }

  void _startLoadingSequence() async {
    // Start progress animation
    _progressController.forward();
    
    // Update progress percentage with vibrations
    for (int i = 1; i <= 99; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (mounted) {
        setState(() {
          _progressPercentage = i;
        });
        
        // Add vibration every 10%
        if (i % 10 == 0) {
          if (await Vibration.hasVibrator() ?? false) {
            Vibration.vibrate(duration: 100);
          }
        }
      }
    }

    // Final vibration and confetti
    if (mounted) {
      if (await Vibration.hasVibrator() ?? false) {
        Vibration.vibrate(duration: 500);
      }
      
      setState(() {
        _progressPercentage = 100;
        _isLoading = false;
        _showCard = true;
      });
      
      // Start card animation
      _cardController.forward();
      
      // Start text animation after card animation
      Future.delayed(const Duration(milliseconds: 600), () {
        if (mounted) {
          setState(() {
            _showText = true;
          });
          _textController.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _cardController.dispose();
    _progressController.dispose();
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
        body: Stack(
          children: [
            
            SafeArea(
              child: Column(
                children: [
                  // Top Navigation Bar
                  _buildTopNavBar(lightTextColor),
                  
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 30),

                            // Loading or Tarot Card
                            if (_isLoading)
                              _buildLoadingScreen(lightTextColor, purpleAccent)
                            else
                              _buildTarotCard(lightTextColor, purpleAccent),

                            const SizedBox(height: 30),

                            // Text content (only show after loading)
                            if (_showText)
                              FadeTransition(
                                opacity: _textAnimation,
                                child: Column(
                                  children: [
                                    // Main Advice
                                    Text(
                                      widget.tarotCard.mainAdvice,
                                      style: TextStyle(
          fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w600,
                                        color: lightTextColor,
                                        fontSize: 24,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),

                                    // Description
                                    Text(
                                      widget.tarotCard.description,
                                      style: TextStyle(
          fontFamily: 'DMSans',
                                        fontWeight: FontWeight.w400,
                                        color: lightTextColor.withOpacity(0.8),
                                        fontSize: 16,
                                        height: 1.5,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 30),

                                    // Grab a new message button
                                    GestureDetector(
                                      onTap: widget.onGrabNewMessage,
                                      child: Text(
                                        widget.tarotCard.actionText,
                                        style: TextStyle(
          fontFamily: 'DMSans',
                                          fontWeight: FontWeight.w600,
                                          color: purpleAccent,
                                          fontSize: 18,
                                          decoration: TextDecoration.underline,
                                          decorationColor: purpleAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            
                            const SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Media Player Control (only show after loading)
                  if (_showText)
                    FadeTransition(
                      opacity: _textAnimation,
                      child: _buildMediaPlayer(lightTextColor),
                    ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(Color lightTextColor, Color purpleAccent) {
    return Column(
      children: [
        // Loading circle with progress
        SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            children: [
              // Background circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: lightTextColor.withOpacity(0.3),
                    width: 4,
                  ),
                ),
              ),
              
              // Progress circle
              AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return SizedBox(
                    width: 200,
                    height: 200,
                    child: CircularProgressIndicator(
                      value: _progressAnimation.value,
                      strokeWidth: 4,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(purpleAccent),
                    ),
                  );
                },
              ),
              
              // Percentage text
              Center(
                child: Text(
                  '$_progressPercentage%',
                  style: TextStyle(
          fontFamily: 'DMSans',
                    fontWeight: FontWeight.w600,
                    color: lightTextColor,
                    fontSize: 32,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 30),
        
        // Loading text
        Text(
          'Channeling your destiny...',
          style: TextStyle(
          fontFamily: 'DMSans',
            fontWeight: FontWeight.w400,
            color: lightTextColor.withOpacity(0.8),
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTarotCard(Color lightTextColor, Color purpleAccent) {
    return ScaleTransition(
      scale: _cardAnimation,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            widget.tarotCard.imagePath,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.white, size: 100),
          ),
        ),
      ),
    );
  }

  Widget _buildTopNavBar(Color lightTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: lightTextColor),
            onPressed: widget.onClose,
          ),
          Text(
            'Message of the day',
            style: TextStyle(
          fontFamily: 'DMSans',
              fontWeight: FontWeight.w600,
              color: lightTextColor,
              fontSize: 18,
            ),
          ),
          IconButton(
            icon: Icon(Icons.upload, color: lightTextColor),
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
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: lightTextColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(Icons.play_arrow, color: lightTextColor, size: 30),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.tarotCard.mediaTitle,
                style: TextStyle(
          fontFamily: 'DMSans',
                  fontWeight: FontWeight.w600,
                  color: lightTextColor,
                  fontSize: 16,
                ),
              ),
              Text(
                widget.tarotCard.mediaDuration,
                style: TextStyle(
          fontFamily: 'DMSans',
                  fontWeight: FontWeight.w400,
                  color: lightTextColor.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}