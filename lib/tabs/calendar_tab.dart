import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/calendar_event.dart';
import '../data/calendar_events_data.dart';

class CalendarTab extends StatefulWidget {
  const CalendarTab({super.key});

  @override
  State<CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<CalendarTab> {
  DateTime _currentMonth = DateTime.now();
  late List<CalendarEvent> _events;

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    _events = CalendarEventsData.getEvents();
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1);
    });
  }

  List<CalendarEvent> _getEventsForDate(DateTime date) {
    return _events.where((event) {
      return event.dateTime.year == date.year &&
          event.dateTime.month == date.month &&
          event.dateTime.day == date.day;
    }).toList();
  }

  List<CalendarEvent> _getUpcomingEvents() {
    final now = DateTime.now();
    final nextWeek = now.add(const Duration(days: 7));
    
    return _events.where((event) {
      return event.dateTime.isAfter(now) && event.dateTime.isBefore(nextWeek);
    }).toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  int _getCurrentStreak() {
    // Calculate consecutive days with completed activities
    final now = DateTime.now();
    int streak = 0;
    
    for (int i = 0; i < 30; i++) {
      final checkDate = now.subtract(Duration(days: i));
      final hasActivity = _events.any((event) =>
          event.dateTime.year == checkDate.year &&
          event.dateTime.month == checkDate.month &&
          event.dateTime.day == checkDate.day);
      
      if (hasActivity) {
        streak++;
      } else {
        break;
      }
    }
    
    return streak;
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Calendar',
                    style: GoogleFonts.dmSans(
                      color: lightTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // Streak counter
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: purpleAccent.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: purpleAccent.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_fire_department,
                          color: purpleAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${_getCurrentStreak()} day streak',
                          style: GoogleFonts.dmSans(
                            color: lightTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // Month navigation
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: purpleAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: lightTextColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Month/Year header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: _previousMonth,
                          icon: Icon(
                            Icons.chevron_left,
                            color: lightTextColor,
                            size: 28,
                          ),
                        ),
                        Text(
                          '${_getMonthName(_currentMonth.month)} ${_currentMonth.year}',
                          style: GoogleFonts.dmSans(
                            color: lightTextColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        IconButton(
                          onPressed: _nextMonth,
                          icon: Icon(
                            Icons.chevron_right,
                            color: lightTextColor,
                            size: 28,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Calendar grid
                    _buildCalendarGrid(),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Upcoming events
              Text(
                'Upcoming Events',
                style: GoogleFonts.dmSans(
                  color: lightTextColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              // Events list
              ..._getUpcomingEvents().map((event) => _buildEventCard(event, lightTextColor, purpleAccent)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');
    final today = DateTime.now();
    
    // Get first day of month and calculate starting position
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final startWeekday = firstDay.weekday;
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    
    // Weekday headers
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    
    return Column(
      children: [
        // Weekday headers
        Row(
          children: weekdays.map((day) => Expanded(
            child: Center(
              child: Text(
                day,
                style: GoogleFonts.dmSans(
                  color: lightTextColor.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )).toList(),
        ),
        
        const SizedBox(height: 8),
        
        // Calendar days
        ...List.generate(6, (weekIndex) {
          return Row(
            children: List.generate(7, (dayIndex) {
              final dayNumber = weekIndex * 7 + dayIndex - startWeekday + 2;
              
              if (dayNumber < 1 || dayNumber > daysInMonth) {
                return Expanded(child: Container(height: 40));
              }
              
              final date = DateTime(_currentMonth.year, _currentMonth.month, dayNumber);
              final isToday = date.year == today.year && 
                            date.month == today.month && 
                            date.day == today.day;
              final eventsForDate = _getEventsForDate(date);
              final hasEvents = eventsForDate.isNotEmpty;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (hasEvents) {
                      _showEventsForDate(date, eventsForDate);
                    }
                  },
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: isToday 
                          ? purpleAccent.withOpacity(0.3)
                          : hasEvents 
                              ? purpleAccent.withOpacity(0.1)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday 
                          ? Border.all(color: purpleAccent, width: 2)
                          : null,
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Text(
                            '$dayNumber',
                            style: GoogleFonts.dmSans(
                              color: isToday 
                                  ? lightTextColor
                                  : lightTextColor.withOpacity(0.8),
                              fontSize: 14,
                              fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                        ),
                        if (hasEvents)
                          Positioned(
                            top: 2,
                            right: 2,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: purpleAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ],
    );
  }

  Widget _buildEventCard(CalendarEvent event, Color textColor, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: textColor.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: event.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              event.icon,
              color: event.color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: GoogleFonts.dmSans(
                    color: textColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_getMonthName(event.dateTime.month)} ${event.dateTime.day} at ${_formatTime(event.dateTime)}',
                  style: GoogleFonts.dmSans(
                    color: textColor.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: textColor.withOpacity(0.5),
            size: 16,
          ),
        ],
      ),
    );
  }

  void _showEventsForDate(DateTime date, List<CalendarEvent> events) {
    final lightTextColor = _hexToColor('F0E6D8');
    
    showModalBottomSheet(
      context: context,
      backgroundColor: _hexToColor('1B0A33'),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_getMonthName(date.month)} ${date.day}, ${date.year}',
              style: GoogleFonts.dmSans(
                color: lightTextColor,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ...events.map((event) => _buildEventCard(event, lightTextColor, _hexToColor('6A1B9A'))),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}
