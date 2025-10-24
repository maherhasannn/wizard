import 'package:flutter/foundation.dart';
import 'dart:math';
import '../models/tarot_card.dart';

class TarotService extends ChangeNotifier {
  static final TarotService _instance = TarotService._internal();
  factory TarotService() => _instance;
  TarotService._internal();

  // List of tarot cards with images and data
  final List<TarotCard> _allTarotCards = [
    TarotCard(
      imagePath: 'assets/images/the_sun_tarot.png',
      title: 'THE SUN',
      romanNumeral: 'XIX',
      mainAdvice: 'You will meet your destiny very soon and unexpectedly ✨',
      description: '''Inspired by the "quotes" program that you can find on those older mainframe/green screen command line interfaces, you can use this utility to display a quote, a message, advice, guidance or just about anything on any day of your choosing.

Make a specific message appear on a particular day, month, year, accounting week or weekday. Or...randomly display a message that changes every day. Or...randomly display a message every time the page loads. Or...use combinations of these choices.

You can use rich text and hyperlinks in your messages. Display a reminder to fill in your timesheet every Friday. Display a message about upcoming holidays. Display random quotes on any other day, or nothing at all.''',
      actionText: 'Grab a new message',
      mediaTitle: 'Whispers of the Thunder',
      mediaDuration: '15 min',
    ),
    TarotCard(
      imagePath: 'assets/images/the_moon_tarot.png',
      title: 'THE MOON',
      romanNumeral: 'XVIII',
      mainAdvice: 'Trust your intuition - the answers lie within your dreams ✨',
      description: '''The Moon card often signifies intuition, dreams, and the subconscious. It suggests that things may not be as they seem, and encourages you to trust your inner voice. Hidden truths may be revealed, or you might be navigating a period of uncertainty.

This card reminds you to explore your emotional depths and confront your fears. It's a time for introspection and understanding the unseen forces at play in your life. Don't be afraid to delve into your dreams and instincts for guidance.

Remember that even in darkness, there is light. The Moon illuminates the path, even if faintly. Be patient with yourself and the process, and allow your intuition to lead you through any confusion.''',
      actionText: 'Seek inner wisdom',
      mediaTitle: 'Lunar Meditations',
      mediaDuration: '20 min',
    ),
    TarotCard(
      imagePath: 'assets/images/the_star_tarot.png',
      title: 'THE STAR',
      romanNumeral: 'XVII',
      mainAdvice: 'Hope and inspiration guide your path to renewal ✨',
      description: '''The Star card is a beacon of hope, inspiration, and spiritual connection. It appears after periods of turmoil, offering a sense of peace and renewed purpose. This card signifies healing, serenity, and a deep sense of calm.

It encourages you to have faith in the universe and in your own journey. You are being guided towards your true self and your highest potential. Embrace optimism and allow yourself to be open to new possibilities and divine blessings.

The Star reminds you that you are connected to something larger than yourself. Trust in the flow of life, and know that you possess the inner strength and resilience to overcome any obstacles. Your future is bright with promise.''',
      actionText: 'Embrace new beginnings',
      mediaTitle: 'Celestial Harmonies',
      mediaDuration: '18 min',
    ),
  ];

  final List<TarotCard> _revealedCards = [];
  TarotCard? _currentCard;
  bool _isRevealed = false;

  TarotCard? get currentCard => _currentCard;
  bool get isRevealed => _isRevealed;

  void revealAdvice() {
    if (_revealedCards.length == _allTarotCards.length) {
      // All cards revealed, use fallback
      _currentCard = TarotCard(
        imagePath: 'assets/images/fallback_tarot.png',
        title: 'NO MORE ADVICE',
        romanNumeral: '∞',
        mainAdvice: "You don't need more advice. Listen to your heart.",
        description: "All the wisdom has been shared. Now is the time to trust your inner guidance and intuition. The answers you seek are within you.",
        actionText: 'Listen to your heart',
        mediaTitle: 'Inner Peace Journey',
        mediaDuration: '10 min',
      );
    } else {
      List<TarotCard> availableCards = _allTarotCards
          .where((card) => !_revealedCards.contains(card))
          .toList();
      final _random = Random();
      _currentCard = availableCards[_random.nextInt(availableCards.length)];
      _revealedCards.add(_currentCard!);
    }
    _isRevealed = true;
    notifyListeners();
  }

  void reset() {
    _isRevealed = false;
    notifyListeners();
  }

  void grabNewMessage() {
    _isRevealed = false;
    revealAdvice();
  }
}