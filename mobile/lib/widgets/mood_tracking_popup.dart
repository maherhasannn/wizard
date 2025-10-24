import 'package:flutter/material.dart';
import 'dart:ui';

class MoodTrackingPopup extends StatefulWidget {
  final int initialEmojiIndex;
  final VoidCallback onClose;
  final Function(int emojiIndex, String description) onConfirm;

  const MoodTrackingPopup({
    super.key,
    required this.initialEmojiIndex,
    required this.onClose,
    required this.onConfirm,
  });

  @override
  State<MoodTrackingPopup> createState() => _MoodTrackingPopupState();
}

class _MoodTrackingPopupState extends State<MoodTrackingPopup> {
  late int _selectedEmojiIndex;
  late TextEditingController _textController;
  final FocusNode _focusNode = FocusNode();

  final List<Map<String, dynamic>> _emojis = [
    {'emoji': '😠', 'rating': 1, 'label': 'Angry'},
    {'emoji': '😢', 'rating': 2, 'label': 'Sad'},
    {'emoji': '🤔', 'rating': 3, 'label': 'Thoughtful'},
    {'emoji': '😊', 'rating': 4, 'label': 'Happy'},
    {'emoji': '🥰', 'rating': 5, 'label': 'Loving'},
  ];

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    _selectedEmojiIndex = widget.initialEmojiIndex;
    _textController = TextEditingController();
    
    // Auto-focus the text field when popup opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final backgroundColor = _hexToColor('2D1B69');
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Backdrop with blur
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                color: Colors.black.withOpacity(0.3),
                child: GestureDetector(
                  onTap: widget.onClose,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          
          // Main popup content
          Center(
            child: Container(
              width: screenSize.width * 0.9,
              constraints: BoxConstraints(
                maxHeight: screenSize.height * 0.7,
              ),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    _buildHeader(lightTextColor),
                    
                    // Emoji selection
                    _buildEmojiSelection(lightTextColor),
                    
                    // Text input
                    _buildTextInput(lightTextColor),
                    
                    // Rating display
                    _buildRatingDisplay(lightTextColor),
                    
                    // Confirm button
                    _buildConfirmButton(purpleAccent, lightTextColor),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color lightTextColor) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Describe your feeling*',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You will be able to return to this day and remember what happened in it.',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor.withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: widget.onClose,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.close,
                color: lightTextColor,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiSelection(Color lightTextColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(_emojis.length, (index) {
          final emoji = _emojis[index];
          final isSelected = _selectedEmojiIndex == index;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedEmojiIndex = index;
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected 
                  ? Colors.white.withOpacity(0.2)
                  : Colors.transparent,
                border: Border.all(
                  color: isSelected 
                    ? Colors.white.withOpacity(0.4)
                    : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  emoji['emoji'],
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTextInput(Color lightTextColor) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: TextField(
          controller: _textController,
          focusNode: _focusNode,
          maxLines: 4,
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: 'Describe your day',
            hintStyle: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.5),
              fontSize: 16,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingDisplay(Color lightTextColor) {
    final rating = _emojis[_selectedEmojiIndex]['rating'];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Text(
            'Your rating is $rating out of 5',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '*Writing a description is optional',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.6),
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(Color purpleAccent, Color lightTextColor) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            widget.onConfirm(_selectedEmojiIndex, _textController.text);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: purpleAccent,
            foregroundColor: lightTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'Confirm',
            style: TextStyle(
              fontFamily: 'DMSans',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
