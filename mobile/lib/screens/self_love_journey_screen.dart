import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/self_love_journey_service.dart';
import '../models/self_love_journey.dart';
import '../shared_background.dart';
import 'self_love_daily_checkin_screen.dart';
import 'self_love_journey_completion_screen.dart';

class SelfLoveJourneyScreen extends StatefulWidget {
  const SelfLoveJourneyScreen({super.key});

  @override
  State<SelfLoveJourneyScreen> createState() => _SelfLoveJourneyScreenState();
}

class _SelfLoveJourneyScreenState extends State<SelfLoveJourneyScreen> {
  late SelfLoveJourneyService _journeyService;

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    _journeyService = SelfLoveJourneyService();
    _journeyService.addListener(_onJourneyChanged);
    if (!_journeyService.isJourneyStarted) {
      _journeyService.initializeJourney();
    }
  }

  @override
  void dispose() {
    _journeyService.removeListener(_onJourneyChanged);
    super.dispose();
  }

  void _onJourneyChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return SharedBackground(
      bgColorHex: '1B0A33',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: lightTextColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            '14-Day Self-Love Journey',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Progress Header
                _buildProgressHeader(lightTextColor, purpleAccent),
                
                const SizedBox(height: 30),
                
                // Journey Overview
                _buildJourneyOverview(lightTextColor),
                
                const SizedBox(height: 30),
                
                // Current Day Card
                if (_journeyService.currentDayData != null)
                  _buildCurrentDayCard(lightTextColor, purpleAccent),
                
                const SizedBox(height: 30),
                
                // Journey Days List
                _buildJourneyDaysList(lightTextColor, purpleAccent),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader(Color lightTextColor, Color purpleAccent) {
    final progress = _journeyService.progressPercentage;
    final completedDays = _journeyService.completedDaysCount;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            purpleAccent.withOpacity(0.8),
            purpleAccent.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: purpleAccent.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Self-Love Journey',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Day ${_journeyService.currentDay} of 14',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.9),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(lightTextColor),
                  minHeight: 8,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '$completedDays days completed',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ),
              if (_journeyService.streakDays > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '🔥 ${_journeyService.streakDays} day streak',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyOverview(Color lightTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Journey Overview',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'This 14-day journey is designed to help you cultivate deeper self-love, self-compassion, and self-acceptance. Each day focuses on a different aspect of self-love with guided activities and reflections.',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor.withOpacity(0.8),
            fontSize: 14,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentDayCard(Color lightTextColor, Color purpleAccent) {
    final currentDay = _journeyService.currentDayData!;
    
    return GestureDetector(
      onTap: () => _navigateToDayDetail(currentDay),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: purpleAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Day ${currentDay.dayNumber}',
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  color: lightTextColor.withOpacity(0.6),
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              currentDay.title,
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              currentDay.description,
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor.withOpacity(0.8),
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Text(
              'Tap to continue your journey',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: purpleAccent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJourneyDaysList(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'All Days',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _journeyService.journeyDays.length,
          itemBuilder: (context, index) {
            final day = _journeyService.journeyDays[index];
            return _buildDayListItem(day, lightTextColor, purpleAccent);
          },
        ),
      ],
    );
  }

  Widget _buildDayListItem(SelfLoveJourneyDay day, Color lightTextColor, Color purpleAccent) {
    final isCurrentDay = day.dayNumber == _journeyService.currentDay;
    final isCompleted = day.isCompleted;
    final isLocked = day.dayNumber > _journeyService.currentDay;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: isLocked ? null : () => _navigateToDayDetail(day),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isCurrentDay 
              ? purpleAccent.withOpacity(0.2)
              : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isCurrentDay 
                ? purpleAccent.withOpacity(0.5)
                : Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted 
                    ? Colors.green.withOpacity(0.8)
                    : isCurrentDay 
                      ? purpleAccent
                      : Colors.white.withOpacity(0.1),
                ),
                child: Center(
                  child: isCompleted
                    ? Icon(Icons.check, color: lightTextColor, size: 20)
                    : Text(
                        '${day.dayNumber}',
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day.title,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      day.description,
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor.withOpacity(0.7),
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isLocked)
                Icon(
                  Icons.lock,
                  color: lightTextColor.withOpacity(0.4),
                  size: 20,
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  color: lightTextColor.withOpacity(0.6),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDayDetail(SelfLoveJourneyDay day) {
    if (day.dayNumber == _journeyService.currentDay && !day.isCompleted) {
      // Navigate to check-in screen for current day
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SelfLoveDailyCheckInScreen(day: day),
        ),
      );
    } else {
      // Navigate to detail screen for completed or future days
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SelfLoveDayDetailScreen(day: day),
        ),
      );
    }
  }
}

class SelfLoveDayDetailScreen extends StatefulWidget {
  final SelfLoveJourneyDay day;

  const SelfLoveDayDetailScreen({
    super.key,
    required this.day,
  });

  @override
  State<SelfLoveDayDetailScreen> createState() => _SelfLoveDayDetailScreenState();
}

class _SelfLoveDayDetailScreenState extends State<SelfLoveDayDetailScreen> {
  late TextEditingController _reflectionController;
  bool _isCompleted = false;

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    _reflectionController = TextEditingController();
    _isCompleted = widget.day.isCompleted;
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return SharedBackground(
      bgColorHex: '1B0A33',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: lightTextColor),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'Day ${widget.day.dayNumber}',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Day Header
                _buildDayHeader(lightTextColor, purpleAccent),
                
                const SizedBox(height: 30),
                
                // Affirmation
                _buildAffirmation(lightTextColor),
                
                const SizedBox(height: 30),
                
                // Activity
                _buildActivity(lightTextColor),
                
                const SizedBox(height: 30),
                
                // Reflection
                _buildReflection(lightTextColor),
                
                const SizedBox(height: 40),
                
                // Complete Button
                if (!_isCompleted)
                  _buildCompleteButton(lightTextColor, purpleAccent),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDayHeader(Color lightTextColor, Color purpleAccent) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            purpleAccent.withOpacity(0.8),
            purpleAccent.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.day.title,
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.day.description,
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.9),
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmation(Color lightTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily Affirmation',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            widget.day.affirmation,
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 16,
              fontStyle: FontStyle.italic,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActivity(Color lightTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today\'s Activity',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Text(
            widget.day.activity,
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.9),
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReflection(Color lightTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reflection',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.day.reflection,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor.withOpacity(0.9),
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _reflectionController,
                maxLines: 4,
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Write your thoughts here...',
                  hintStyle: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor.withOpacity(0.5),
                    fontSize: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompleteButton(Color lightTextColor, Color purpleAccent) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isCompleted = true;
          });
          SelfLoveJourneyService().completeCurrentDay(reflection: _reflectionController.text.trim());
          
          // Check if journey is complete
          if (SelfLoveJourneyService().isJourneyCompleted) {
            // Navigate to completion screen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SelfLoveJourneyCompletionScreen(),
              ),
            );
          } else {
            // Show completion message and go back
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Day ${widget.day.dayNumber} completed! 🎉',
                  style: TextStyle(fontFamily: 'DMSans'),
                ),
                backgroundColor: purpleAccent,
              ),
            );
            Navigator.of(context).pop();
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: purpleAccent,
          foregroundColor: lightTextColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          'Complete Day ${widget.day.dayNumber}',
          style: TextStyle(
            fontFamily: 'DMSans',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
