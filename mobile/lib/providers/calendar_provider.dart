import 'package:flutter/foundation.dart';
import '../models/calendar_event.dart';
import '../services/calendar_service.dart';
import '../services/api_client.dart';

class CalendarProvider extends ChangeNotifier {
  final CalendarService _service;

  List<CalendarEvent> _events = [];
  bool _isLoading = false;
  String? _error;

  CalendarProvider(this._service);

  List<CalendarEvent> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadEvents({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await _service.getEvents(
        startDate: startDate,
        endDate: endDate,
        type: type,
      );
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load events';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createEvent({
    required String title,
    String? description,
    required String type,
    required DateTime scheduledAt,
    int? duration,
    Map<String, dynamic>? recurrence,
    int? notificationTime,
  }) async {
    try {
      final event = await _service.createEvent(
        title: title,
        description: description,
        type: type,
        scheduledAt: scheduledAt,
        duration: duration,
        recurrence: recurrence,
        notificationTime: notificationTime,
      );
      
      _events.add(event);
      _events.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEvent({
    required int eventId,
    String? title,
    String? description,
    String? type,
    DateTime? scheduledAt,
    int? duration,
    bool? isCompleted,
    Map<String, dynamic>? recurrence,
    int? notificationTime,
  }) async {
    try {
      final updatedEvent = await _service.updateEvent(
        eventId: eventId,
        title: title,
        description: description,
        type: type,
        scheduledAt: scheduledAt,
        duration: duration,
        isCompleted: isCompleted,
        recurrence: recurrence,
        notificationTime: notificationTime,
      );
      
      final index = _events.indexWhere((e) => e.id == eventId);
      if (index != -1) {
        _events[index] = updatedEvent;
        _events.sort((a, b) => a.scheduledAt.compareTo(b.scheduledAt));
        notifyListeners();
      }
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEvent(int eventId) async {
    try {
      await _service.deleteEvent(eventId);
      _events.removeWhere((e) => e.id == eventId);
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> completeEvent(int eventId) async {
    try {
      await _service.completeEvent(eventId);
      final index = _events.indexWhere((e) => e.id == eventId);
      if (index != -1) {
        _events[index] = _events[index].copyWith(
          isCompleted: true,
          completedAt: DateTime.now(),
        );
        notifyListeners();
      }
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  List<CalendarEvent> getEventsForDate(DateTime date) {
    return _events.where((event) {
      final eventDate = DateTime(
        event.scheduledAt.year,
        event.scheduledAt.month,
        event.scheduledAt.day,
      );
      final targetDate = DateTime(date.year, date.month, date.day);
      return eventDate.isAtSameMomentAs(targetDate);
    }).toList();
  }

  int get completedEventsCount {
    return _events.where((e) => e.isCompleted).length;
  }

  int get totalEventsCount {
    return _events.length;
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}


