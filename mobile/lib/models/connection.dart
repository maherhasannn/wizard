class Connection {
  final int id;
  final int requesterId;
  final int receiverId;
  final String status; // 'PENDING', 'ACCEPTED', 'REJECTED'
  final DateTime createdAt;
  final DateTime? acceptedAt;
  final DateTime? rejectedAt;
  final Map<String, dynamic>? user; // The other user in the connection

  const Connection({
    required this.id,
    required this.requesterId,
    required this.receiverId,
    required this.status,
    required this.createdAt,
    this.acceptedAt,
    this.rejectedAt,
    this.user,
  });

  factory Connection.fromJson(Map<String, dynamic> json) {
    return Connection(
      id: json['id'] as int,
      requesterId: json['requesterId'] as int,
      receiverId: json['receiverId'] as int,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] != null ? DateTime.parse(json['acceptedAt'] as String) : null,
      rejectedAt: json['rejectedAt'] != null ? DateTime.parse(json['rejectedAt'] as String) : null,
      user: json['user'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'requesterId': requesterId,
      'receiverId': receiverId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'acceptedAt': acceptedAt?.toIso8601String(),
      'rejectedAt': rejectedAt?.toIso8601String(),
      'user': user,
    };
  }

  bool get isPending => status == 'PENDING';
  bool get isAccepted => status == 'ACCEPTED';
  bool get isRejected => status == 'REJECTED';

  String get statusDisplayText {
    switch (status) {
      case 'PENDING':
        return 'Pending';
      case 'ACCEPTED':
        return 'Connected';
      case 'REJECTED':
        return 'Rejected';
      default:
        return status;
    }
  }

  String get userName {
    if (user == null) return 'Unknown User';
    final firstName = user!['firstName'] as String? ?? '';
    final lastName = user!['lastName'] as String? ?? '';
    return '$firstName $lastName'.trim();
  }

  String? get userPhoto => user?['profilePhoto'] as String?;

  String get userLocation {
    if (user == null) return '';
    final city = user!['city'] as String? ?? '';
    final country = user!['country'] as String? ?? '';
    if (city.isNotEmpty && country.isNotEmpty) {
      return '$city, $country';
    } else if (city.isNotEmpty) {
      return city;
    } else if (country.isNotEmpty) {
      return country;
    }
    return '';
  }

  Connection copyWith({
    int? id,
    int? requesterId,
    int? receiverId,
    String? status,
    DateTime? createdAt,
    DateTime? acceptedAt,
    DateTime? rejectedAt,
    Map<String, dynamic>? user,
  }) {
    return Connection(
      id: id ?? this.id,
      requesterId: requesterId ?? this.requesterId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      rejectedAt: rejectedAt ?? this.rejectedAt,
      user: user ?? this.user,
    );
  }

  @override
  String toString() {
    return 'Connection(id: $id, status: $status, user: $userName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Connection && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
