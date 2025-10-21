import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../shared_background.dart';
import '../models/ai_chat_message.dart';

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<AiChatMessage> _messages = [];
  bool _isLoading = false;

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add(AiChatMessage(
      id: '1',
      message: '',
      response: 'Hello! I\'m Liz, your AI guide. I\'m here to help you on your journey. What would you like to know?',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(AiChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: message,
        response: '',
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response (placeholder for now)
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _messages.add(AiChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: '',
        response: _getPlaceholderResponse(message),
        isUser: false,
        timestamp: DateTime.now(),
      ));
      _isLoading = false;
    });

    _scrollToBottom();
  }

  String _getPlaceholderResponse(String userMessage) {
    // Simple placeholder responses based on keywords
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('heartbreak') || lowerMessage.contains('breakup')) {
      return 'I understand you\'re going through a difficult time. Healing takes courage and patience. Remember, this pain is temporary, and you\'re stronger than you know. Would you like to try a meditation focused on emotional healing?';
    } else if (lowerMessage.contains('confidence') || lowerMessage.contains('self-esteem')) {
      return 'Building confidence is a journey of self-discovery. You have unique strengths and qualities that make you special. Let\'s work together to help you recognize and celebrate your worth. What\'s one thing you\'re proud of about yourself?';
    } else if (lowerMessage.contains('stress') || lowerMessage.contains('anxiety')) {
      return 'I can help you find peace and calm. Stress is a natural response, but we can learn to manage it. Deep breathing exercises and mindfulness can be powerful tools. Would you like to try a quick breathing exercise?';
    } else if (lowerMessage.contains('love') || lowerMessage.contains('relationship')) {
      return 'Love is one of life\'s greatest adventures. Whether you\'re looking for love or nurturing an existing relationship, remember that self-love is the foundation. You deserve love that lifts you up and makes you feel valued.';
    } else if (lowerMessage.contains('meditation') || lowerMessage.contains('mindfulness')) {
      return 'Meditation is a beautiful practice that can bring clarity and peace to your life. Even just a few minutes a day can make a difference. I\'d be happy to guide you through a meditation or recommend some that might resonate with you.';
    } else {
      return 'Thank you for sharing that with me. I\'m here to support you on your journey of growth and healing. Feel free to ask me anything - whether it\'s about meditation, relationships, personal growth, or just to have a meaningful conversation.';
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Scaffold(
      body: SharedBackground(
        bgColorHex: '1B0A33',
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: purpleAccent.withOpacity(0.1),
                  border: Border(
                    bottom: BorderSide(
                      color: lightTextColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: lightTextColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // AI Liz avatar
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [purpleAccent, _hexToColor('8E24AA')],
                        ),
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Liz',
                            style: GoogleFonts.dmSans(
                              color: lightTextColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Always here to help',
                            style: GoogleFonts.dmSans(
                              color: lightTextColor.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Messages
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(20),
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isLoading) {
                      return _buildTypingIndicator(lightTextColor);
                    }
                    
                    final message = _messages[index];
                    return _buildMessageBubble(message, lightTextColor, purpleAccent);
                  },
                ),
              ),

              // Input area
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: purpleAccent.withOpacity(0.1),
                  border: Border(
                    top: BorderSide(
                      color: lightTextColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: GoogleFonts.dmSans(color: lightTextColor),
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          hintStyle: GoogleFonts.dmSans(
                            color: lightTextColor.withOpacity(0.5),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: lightTextColor.withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(
                              color: lightTextColor.withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                            borderSide: BorderSide(color: purpleAccent),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [purpleAccent, _hexToColor('8E24AA')],
                          ),
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(AiChatMessage message, Color lightTextColor, Color purpleAccent) {
    final isUser = message.isUser;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [purpleAccent, _hexToColor('8E24AA')],
                ),
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.white,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
          
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser 
                    ? purpleAccent.withOpacity(0.3)
                    : lightTextColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isUser 
                      ? purpleAccent.withOpacity(0.5)
                      : lightTextColor.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Text(
                isUser ? message.message : message.response,
                style: GoogleFonts.dmSans(
                  color: lightTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          
          if (isUser) ...[
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: lightTextColor.withOpacity(0.2),
              ),
              child: Icon(
                Icons.person,
                color: lightTextColor.withOpacity(0.7),
                size: 16,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(Color lightTextColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [_hexToColor('6A1B9A'), _hexToColor('8E24AA')],
              ),
            ),
            child: const Icon(
              Icons.psychology,
              color: Colors.white,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: lightTextColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: lightTextColor.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTypingDot(0),
                const SizedBox(width: 4),
                _buildTypingDot(1),
                const SizedBox(width: 4),
                _buildTypingDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animationValue = (value - delay).clamp(0.0, 1.0);
        
        return Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hexToColor('F0E6D8').withOpacity(
              0.3 + (0.7 * animationValue),
            ),
          ),
        );
      },
    );
  }
}
