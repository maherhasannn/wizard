class AiChatMessage {
  final String id;
  final String message;
  final String response;
  final bool isUser;
  final DateTime timestamp;

  AiChatMessage({
    required this.id,
    required this.message,
    required this.response,
    required this.isUser,
    required this.timestamp,
  });

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      id: json['id'] as String,
      message: json['message'] as String,
      response: json['response'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'response': response,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
