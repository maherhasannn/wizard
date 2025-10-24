import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/self_love_journey.dart';

class SelfLoveJourneyService extends ChangeNotifier {
  static final SelfLoveJourneyService _instance = SelfLoveJourneyService._internal();
  factory SelfLoveJourneyService() => _instance;
  SelfLoveJourneyService._internal() {
    _loadJourneyState();
  }

  List<SelfLoveJourneyDay> _journeyDays = [];
  int _currentDay = 1;
  DateTime? _journeyStartDate;

  List<SelfLoveJourneyDay> get journeyDays => _journeyDays;
  int get currentDay => _currentDay;
  DateTime? get journeyStartDate => _journeyStartDate;
  bool get isJourneyStarted => _journeyStartDate != null;
  bool get isJourneyCompleted => _currentDay > 14;

  SelfLoveJourneyDay? get currentDayData {
    if (_currentDay <= 14) {
      return _journeyDays.firstWhere(
        (day) => day.dayNumber == _currentDay,
        orElse: () => _createDefaultDay(_currentDay),
      );
    }
    return null;
  }

  int get completedDaysCount => _journeyDays.where((day) => day.isCompleted).length;
  double get progressPercentage => completedDaysCount / 14;
  
  // Additional statistics
  int get streakDays {
    int streak = 0;
    for (int i = _currentDay - 1; i >= 1; i--) {
      final day = _journeyDays.firstWhere((d) => d.dayNumber == i, orElse: () => _createDefaultDay(i));
      if (day.isCompleted) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
  
  List<SelfLoveJourneyDay> get completedDays => _journeyDays.where((day) => day.isCompleted).toList();
  
  Duration? get journeyDuration {
    if (_journeyStartDate == null) return null;
    return DateTime.now().difference(_journeyStartDate!);
  }
  
  int get daysRemaining => 14 - _currentDay + 1;
  
  bool get isOnTrack {
    if (_journeyStartDate == null) return true;
    final daysSinceStart = DateTime.now().difference(_journeyStartDate!).inDays;
    return _currentDay >= daysSinceStart + 1;
  }

  void initializeJourney() {
    if (_journeyDays.isEmpty) {
      _journeyDays = _createJourneyDays();
      _journeyStartDate = DateTime.now();
      _saveJourneyState();
      notifyListeners();
    }
  }

  void completeCurrentDay({String? reflection}) {
    if (_currentDay <= 14) {
      final dayIndex = _journeyDays.indexWhere((day) => day.dayNumber == _currentDay);
      if (dayIndex != -1) {
        _journeyDays[dayIndex] = _journeyDays[dayIndex].copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
          reflection: reflection ?? _journeyDays[dayIndex].reflection,
        );
        _currentDay++;
        _saveJourneyState();
        notifyListeners();
      }
    }
  }

  void resetJourney() {
    _journeyDays.clear();
    _currentDay = 1;
    _journeyStartDate = null;
    _saveJourneyState();
    notifyListeners();
  }

  SelfLoveJourneyDay _createDefaultDay(int dayNumber) {
    return SelfLoveJourneyDay(
      dayNumber: dayNumber,
      title: 'Day $dayNumber',
      description: 'Self-love journey day $dayNumber',
      affirmation: 'I am worthy of love and happiness.',
      activity: 'Take time to appreciate yourself today.',
      reflection: 'Reflect on your growth and progress.',
      imagePath: 'assets/images/self_love_day_$dayNumber.png',
    );
  }

  List<SelfLoveJourneyDay> _createJourneyDays() {
    return [
      SelfLoveJourneyDay(
        dayNumber: 1,
        title: 'Beginning Your Journey',
        description: 'Welcome to your 14-day self-love journey. Today, we start with the foundation of self-compassion.',
        affirmation: 'I am worthy of love, especially from myself.',
        activity: 'Write down three things you appreciate about yourself. No matter how small, every positive trait matters.',
        reflection: 'How did it feel to focus on your positive qualities? What surprised you about yourself?',
        imagePath: 'assets/images/self_love_day_1.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 2,
        title: 'Embracing Your Uniqueness',
        description: 'Today we celebrate what makes you uniquely you. Your quirks, talents, and individual perspective.',
        affirmation: 'I am beautifully unique and that is my strength.',
        activity: 'Create a list of your unique qualities, talents, and perspectives. Include things others have complimented you on.',
        reflection: 'What unique qualities do you bring to the world? How can you honor these gifts?',
        imagePath: 'assets/images/self_love_day_2.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 3,
        title: 'Forgiving Yourself',
        description: 'Self-forgiveness is a powerful act of self-love. Today we release the weight of past mistakes.',
        affirmation: 'I forgive myself for past mistakes and choose to grow from them.',
        activity: 'Write a letter of forgiveness to yourself for something you\'ve been holding onto. Then, ceremoniously let it go.',
        reflection: 'What did you learn from this experience? How has it shaped who you are today?',
        imagePath: 'assets/images/self_love_day_3.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 4,
        title: 'Setting Healthy Boundaries',
        description: 'Learning to say no is an act of self-respect. Today we explore healthy boundary setting.',
        affirmation: 'I have the right to protect my energy and well-being.',
        activity: 'Identify one area where you need to set a boundary. Practice saying "no" to something that drains you.',
        reflection: 'How does it feel to prioritize your needs? What boundaries do you want to strengthen?',
        imagePath: 'assets/images/self_love_day_4.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 5,
        title: 'Celebrating Small Wins',
        description: 'Every step forward deserves recognition. Today we practice celebrating our progress.',
        affirmation: 'I celebrate every step I take toward my goals, no matter how small.',
        activity: 'List five small wins from this week. Celebrate each one with a moment of gratitude.',
        reflection: 'How does celebrating small wins change your perspective on progress?',
        imagePath: 'assets/images/self_love_day_5.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 6,
        title: 'Nurturing Your Inner Child',
        description: 'Connect with the playful, curious part of yourself that still lives within.',
        affirmation: 'I honor and nurture my inner child with love and playfulness.',
        activity: 'Do something purely for fun today - something your inner child would love. No productivity goals, just joy.',
        reflection: 'What did you discover about yourself through play? How can you incorporate more joy into daily life?',
        imagePath: 'assets/images/self_love_day_6.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 7,
        title: 'Mid-Journey Reflection',
        description: 'Halfway through! Take time to reflect on your growth and recommit to your journey.',
        affirmation: 'I am proud of the progress I\'ve made and excited for what\'s to come.',
        activity: 'Review your journey so far. Write about the changes you\'ve noticed in yourself.',
        reflection: 'What patterns do you see in your growth? What would you like to focus on in the second half?',
        imagePath: 'assets/images/self_love_day_7.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 8,
        title: 'Practicing Self-Compassion',
        description: 'Treat yourself with the same kindness you would show a dear friend.',
        affirmation: 'I treat myself with the same compassion I show others.',
        activity: 'When you notice self-criticism today, pause and ask: "What would I say to a friend in this situation?"',
        reflection: 'How does self-compassion feel different from self-criticism? What shifts when you\'re kinder to yourself?',
        imagePath: 'assets/images/self_love_day_8.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 9,
        title: 'Honoring Your Body',
        description: 'Your body is your home. Today we practice gratitude and care for our physical selves.',
        affirmation: 'I honor my body as the sacred vessel that carries me through life.',
        activity: 'Do something kind for your body today - gentle movement, nourishing food, or rest.',
        reflection: 'How does caring for your body affect your overall sense of self-love?',
        imagePath: 'assets/images/self_love_day_9.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 10,
        title: 'Releasing Comparison',
        description: 'Comparison is the thief of joy. Today we focus on our own unique path.',
        affirmation: 'I release comparison and embrace my own beautiful journey.',
        activity: 'Notice when you compare yourself to others today. Gently redirect your focus to your own path.',
        reflection: 'What triggers comparison for you? How can you redirect that energy toward self-appreciation?',
        imagePath: 'assets/images/self_love_day_10.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 11,
        title: 'Embracing Imperfection',
        description: 'Perfect is the enemy of good. Today we celebrate our beautifully imperfect selves.',
        affirmation: 'I embrace my imperfections as part of my unique beauty.',
        activity: 'Share something imperfect about yourself with someone you trust. Notice their response.',
        reflection: 'How does embracing imperfection change your relationship with yourself and others?',
        imagePath: 'assets/images/self_love_day_11.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 12,
        title: 'Creating Self-Love Rituals',
        description: 'Build sustainable practices that nourish your self-love journey.',
        affirmation: 'I create daily rituals that honor and nurture my well-being.',
        activity: 'Design a simple self-love ritual you can do daily. Start practicing it today.',
        reflection: 'What rituals feel most nourishing to you? How can you make them sustainable?',
        imagePath: 'assets/images/self_love_day_12.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 13,
        title: 'Sharing Your Light',
        description: 'Self-love isn\'t selfish - it allows you to love others more fully.',
        affirmation: 'My self-love allows me to love others more authentically and generously.',
        activity: 'Notice how your self-love practice affects your relationships today.',
        reflection: 'How has your self-love journey impacted your ability to love others?',
        imagePath: 'assets/images/self_love_day_13.png',
      ),
      SelfLoveJourneyDay(
        dayNumber: 14,
        title: 'Celebrating Your Journey',
        description: 'Congratulations! You\'ve completed your 14-day self-love journey. Celebrate your commitment to yourself.',
        affirmation: 'I am proud of my commitment to self-love and excited to continue this journey.',
        activity: 'Write a letter to yourself celebrating your journey. Plan how you\'ll continue nurturing self-love.',
        reflection: 'What has this journey taught you? How will you continue to grow in self-love?',
        imagePath: 'assets/images/self_love_day_14.png',
      ),
    ];
  }

  // Persistence methods
  Future<void> _loadJourneyState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final journeyJson = prefs.getString('self_love_journey');
      final currentDay = prefs.getInt('self_love_current_day');
      final startDateString = prefs.getString('self_love_start_date');

      if (journeyJson != null) {
        final List<dynamic> journeyList = json.decode(journeyJson);
        _journeyDays = journeyList.map((json) => SelfLoveJourneyDay.fromJson(json)).toList();
      } else {
        _journeyDays = _createJourneyDays();
      }

      _currentDay = currentDay ?? 1;
      if (startDateString != null) {
        _journeyStartDate = DateTime.parse(startDateString);
      }

      notifyListeners();
    } catch (e) {
      print('Error loading journey state: $e');
      // Fallback to default state
      _journeyDays = _createJourneyDays();
      _currentDay = 1;
      _journeyStartDate = null;
    }
  }

  Future<void> _saveJourneyState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save journey days
      final journeyJson = json.encode(_journeyDays.map((day) => day.toJson()).toList());
      await prefs.setString('self_love_journey', journeyJson);
      
      // Save current day
      await prefs.setInt('self_love_current_day', _currentDay);
      
      // Save start date
      if (_journeyStartDate != null) {
        await prefs.setString('self_love_start_date', _journeyStartDate!.toIso8601String());
      }
    } catch (e) {
      print('Error saving journey state: $e');
    }
  }
}
