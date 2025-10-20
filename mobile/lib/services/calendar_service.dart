import '../models/calendar_event.dart';
import 'api_client.dart';

class CalendarService {
  final ApiClient _client;

  CalendarService(this._client);

  Future<List<CalendarEvent>> getEvents({
    DateTime? startDate,
    DateTime? endDate,
    String? type,
    int page = 1,
    int limit = 50,
  }) async {
    final params = {
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (startDate != null) {
      params['startDate'] = startDate.toIso8601String();
    }
    
    if (endDate != null) {
      params['endDate'] = endDate.toIso8601String();
    }
    
    if (type != null) {
      params['type'] = type;
    }

    final json = await _client.get('/calendar/events', params: params);
    final data = json['data'] as Map<String, dynamic>;
    final eventsData = data['events'] as List;
    
    return eventsData.map((e) => CalendarEvent.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CalendarEvent> getEvent(int eventId) async {
    final json = await _client.get('/calendar/events/$eventId');
    final data = json['data'] as Map<String, dynamic>;
    return CalendarEvent.fromJson(data);
  }

  Future<CalendarEvent> createEvent({
    required String title,
    String? description,
    required String type,
    required DateTime scheduledAt,
    int? duration,
    Map<String, dynamic>? recurrence,
    int? notificationTime,
  }) async {
    final json = await _client.post('/calendar/events', body: {
      'title': title,
      'description': description,
      'type': type,
      'scheduledAt': scheduledAt.toIso8601String(),
      'duration': duration,
      'recurrence': recurrence,
      'notificationTime': notificationTime,
    });

    final data = json['data'] as Map<String, dynamic>;
    return CalendarEvent.fromJson(data);
  }

  Future<CalendarEvent> updateEvent({
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
    final json = await _client.put('/calendar/events/$eventId', body: {
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (scheduledAt != null) 'scheduledAt': scheduledAt.toIso8601String(),
      if (duration != null) 'duration': duration,
      if (isCompleted != null) 'isCompleted': isCompleted,
      if (recurrence != null) 'recurrence': recurrence,
      if (notificationTime != null) 'notificationTime': notificationTime,
    });

    final data = json['data'] as Map<String, dynamic>;
    return CalendarEvent.fromJson(data);
  }

  Future<void> deleteEvent(int eventId) async {
    await _client.delete('/calendar/events/$eventId');
  }

  Future<void> completeEvent(int eventId) async {
    await _client.post('/calendar/events/$eventId/complete');
  }
}


