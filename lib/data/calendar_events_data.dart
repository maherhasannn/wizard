import 'package:flutter/material.dart';
import '../models/calendar_event.dart';

class CalendarEventsData {
  static List<CalendarEvent> getEvents() {
    final now = DateTime.now();
    final events = <CalendarEvent>[];
    
    // Generate events for the next 30 days
    for (int i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      
      // Daily meditation sessions (every day)
      events.add(CalendarEvent(
        title: 'Morning Meditation',
        dateTime: DateTime(date.year, date.month, date.day, 8, 0),
        type: 'meditation',
        icon: Icons.self_improvement,
        color: const Color(0xFF6A1B9A),
      ));
      
      // Evening meditation (every other day)
      if (i % 2 == 0) {
        events.add(CalendarEvent(
          title: 'Evening Reflection',
          dateTime: DateTime(date.year, date.month, date.day, 20, 0),
          type: 'meditation',
          icon: Icons.nights_stay,
          color: const Color(0xFF4A148C),
        ));
      }
      
      // Weekly affirmations (every Sunday)
      if (date.weekday == 7) {
        events.add(CalendarEvent(
          title: 'Weekly Affirmation',
          dateTime: DateTime(date.year, date.month, date.day, 10, 0),
          type: 'affirmation',
          icon: Icons.favorite,
          color: const Color(0xFFE91E63),
        ));
      }
      
      // Networking meetups (every Friday)
      if (date.weekday == 5) {
        events.add(CalendarEvent(
          title: 'Networking Meetup',
          dateTime: DateTime(date.year, date.month, date.day, 18, 30),
          type: 'networking',
          icon: Icons.people,
          color: const Color(0xFF4CAF50),
        ));
      }
      
      // Live stream sessions (every Wednesday and Saturday)
      if (date.weekday == 3 || date.weekday == 6) {
        events.add(CalendarEvent(
          title: 'Live Stream Session',
          dateTime: DateTime(date.year, date.month, date.day, 19, 0),
          type: 'special',
          icon: Icons.live_tv,
          color: const Color(0xFFFF9800),
        ));
      }
      
      // Special events
      if (date.day == 15) {
        events.add(CalendarEvent(
          title: 'Full Moon Ceremony',
          dateTime: DateTime(date.year, date.month, date.day, 21, 0),
          type: 'special',
          icon: Icons.brightness_2,
          color: const Color(0xFFFFEB3B),
        ));
      }
      
      if (date.day == 1) {
        events.add(CalendarEvent(
          title: 'New Moon Intention Setting',
          dateTime: DateTime(date.year, date.month, date.day, 19, 30),
          type: 'special',
          icon: Icons.dark_mode,
          color: const Color(0xFF9C27B0),
        ));
      }
      
      // Power focus sessions (every 3 days)
      if (i % 3 == 0) {
        events.add(CalendarEvent(
          title: 'Power Focus Session',
          dateTime: DateTime(date.year, date.month, date.day, 14, 0),
          type: 'special',
          icon: Icons.bolt,
          color: const Color(0xFFEC407A),
        ));
      }
    }
    
    return events;
  }
}
