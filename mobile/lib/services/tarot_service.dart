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
    TarotCard(
      imagePath: 'assets/images/the_sun_tarot.png',
      title: 'THE FOOL',
      romanNumeral: '0',
      mainAdvice: 'Take a leap of faith - new adventures await ✨',
      description: '''The Fool represents new beginnings, spontaneity, and the courage to step into the unknown. This card encourages you to embrace life with childlike wonder and optimism. It's time to trust your instincts and take that first step toward something new.

Don't be afraid to make mistakes - they're part of the learning process. The Fool reminds you that sometimes the best experiences come from taking risks and following your heart, even when the path ahead seems uncertain.

Embrace the spirit of adventure and let go of fear. Your journey is just beginning, and the universe is ready to support you in your new endeavors.''',
      actionText: 'Begin your journey',
      mediaTitle: 'Adventure Awaits',
      mediaDuration: '12 min',
    ),
    TarotCard(
      imagePath: 'assets/images/the_moon_tarot.png',
      title: 'THE MAGICIAN',
      romanNumeral: 'I',
      mainAdvice: 'You have all the tools you need to manifest your dreams ✨',
      description: '''The Magician represents personal power, manifestation, and the ability to turn dreams into reality. This card reminds you that you possess all the skills, resources, and determination needed to achieve your goals.

It's time to take action and use your talents to create the life you desire. The Magician encourages you to be confident in your abilities and to trust in your power to make things happen.

Focus your energy, set clear intentions, and take concrete steps toward your objectives. You are the master of your own destiny, and the universe is ready to support your efforts.''',
      actionText: 'Manifest your dreams',
      mediaTitle: 'Power Within',
      mediaDuration: '16 min',
    ),
    TarotCard(
      imagePath: 'assets/images/the_star_tarot.png',
      title: 'THE HIGH PRIESTESS',
      romanNumeral: 'II',
      mainAdvice: 'Listen to your inner voice - wisdom flows from within ✨',
      description: '''The High Priestess represents intuition, inner wisdom, and the mysteries of the subconscious mind. This card encourages you to trust your instincts and pay attention to your dreams, feelings, and inner knowing.

It's time to look beyond the surface and explore the deeper meanings in your life. The High Priestess reminds you that some answers can only be found through quiet reflection and inner contemplation.

Trust in your ability to access hidden knowledge and spiritual insights. Your intuition is a powerful guide that will lead you to the answers you seek.''',
      actionText: 'Trust your intuition',
      mediaTitle: 'Inner Wisdom',
      mediaDuration: '14 min',
    ),
  ];

  TarotCard? _currentCard;
  bool _isRevealed = false;
  DateTime? _lastRevealedDate;
  int? _dailyCardIndex;
  bool _isFirstLoadOfDay = true;

  TarotCard? get currentCard => _currentCard;
  bool get isRevealed => _isRevealed;
  bool get isFirstLoadOfDay => _isFirstLoadOfDay;

  // Get today's date as a string for comparison
  String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  // Generate a consistent daily card index based on the date
  int _getDailyCardIndex() {
    final today = _getTodayString();
    final seed = today.hashCode;
    final random = Random(seed);
    return random.nextInt(_allTarotCards.length);
  }

  void revealAdvice() {
    final today = _getTodayString();
    
    // Check if we already revealed a card today
    if (_lastRevealedDate != null && _lastRevealedDate.toString().startsWith(today)) {
      // Same day, show the same card
      if (_dailyCardIndex != null) {
        _currentCard = _allTarotCards[_dailyCardIndex!];
      }
      _isFirstLoadOfDay = false; // Not first load of day
    } else {
      // New day, generate new card
      _dailyCardIndex = _getDailyCardIndex();
      _currentCard = _allTarotCards[_dailyCardIndex!];
      _lastRevealedDate = DateTime.now();
      _isFirstLoadOfDay = true; // First load of day
    }
    
    _isRevealed = true;
    notifyListeners();
  }

  void reset() {
    _isRevealed = false;
    notifyListeners();
  }

  void grabNewMessage() {
    // For daily cards, "grab new message" just resets the current view
    // The same card will be shown again for the day
    _isRevealed = false;
    notifyListeners();
  }

  // Check if user can get a new card (only on a new day)
  bool get canGetNewCard {
    final today = _getTodayString();
    return _lastRevealedDate == null || !_lastRevealedDate.toString().startsWith(today);
  }
}