import '../models/calendar_event.dart';

class CalendarEventsData {
  static List<CalendarEvent> getEvents() {
    final now = DateTime.now();
    final events = <CalendarEvent>[];
    int eventId = 1;
    
    // Generate events for the next 30 days
    for (int i = 0; i < 30; i++) {
      final date = now.add(Duration(days: i));
      
      // Daily meditation sessions (every day)
      events.add(CalendarEvent(
        id: eventId++,
        userId: 1,
        title: 'Morning Meditation',
        scheduledAt: DateTime(date.year, date.month, date.day, 8, 0),
        type: 'MEDITATION',
        duration: 20,
        createdAt: now,
        updatedAt: now,
      ));
      
      // Evening meditation (every other day)
      if (i % 2 == 0) {
        events.add(CalendarEvent(
          id: eventId++,
          userId: 1,
          title: 'Evening Reflection',
          scheduledAt: DateTime(date.year, date.month, date.day, 20, 0),
          type: 'MEDITATION',
          duration: 15,
          createdAt: now,
          updatedAt: now,
        ));
      }
      
      // Weekly affirmations (every Sunday)
      if (date.weekday == 7) {
        events.add(CalendarEvent(
          id: eventId++,
          userId: 1,
          title: 'Weekly Affirmation',
          scheduledAt: DateTime(date.year, date.month, date.day, 10, 0),
          type: 'REMINDER',
          duration: 10,
          createdAt: now,
          updatedAt: now,
        ));
      }
      
      // Networking meetups (every Friday)
      if (date.weekday == 5) {
        events.add(CalendarEvent(
          id: eventId++,
          userId: 1,
          title: 'Networking Meetup',
          scheduledAt: DateTime(date.year, date.month, date.day, 18, 30),
          type: 'CUSTOM',
          duration: 60,
          createdAt: now,
          updatedAt: now,
        ));
      }
      
      // Live stream sessions (every Wednesday and Saturday)
      if (date.weekday == 3 || date.weekday == 6) {
        events.add(CalendarEvent(
          id: eventId++,
          userId: 1,
          title: 'Live Stream Session',
          scheduledAt: DateTime(date.year, date.month, date.day, 19, 0),
          type: 'CUSTOM',
          duration: 45,
          createdAt: now,
          updatedAt: now,
        ));
      }
      
      // Special events
      if (date.day == 15) {
        events.add(CalendarEvent(
          id: eventId++,
          userId: 1,
          title: 'Full Moon Ceremony',
          scheduledAt: DateTime(date.year, date.month, date.day, 21, 0),
          type: 'CUSTOM',
          duration: 30,
          createdAt: now,
          updatedAt: now,
        ));
      }
      
      if (date.day == 1) {
        events.add(CalendarEvent(
          id: eventId++,
          userId: 1,
          title: 'New Moon Intention Setting',
          scheduledAt: DateTime(date.year, date.month, date.day, 19, 30),
          type: 'CUSTOM',
          duration: 25,
          createdAt: now,
          updatedAt: now,
        ));
      }
      
      // Power focus sessions (every 3 days)
      if (i % 3 == 0) {
        events.add(CalendarEvent(
          id: eventId++,
          userId: 1,
          title: 'Power Focus Session',
          scheduledAt: DateTime(date.year, date.month, date.day, 14, 0),
          type: 'GOAL',
          duration: 30,
          createdAt: now,
          updatedAt: now,
        ));
      }
    }
    
    return events;
  }
}
