import 'package:flutter/material.dart';

class CalendarEvent {
  final String title;
  final DateTime dateTime;
  final String type; // 'meditation', 'affirmation', 'networking', 'special'
  final IconData icon;
  final Color color;

  const CalendarEvent({
    required this.title,
    required this.dateTime,
    required this.type,
    required this.icon,
    required this.color,
  });
}
