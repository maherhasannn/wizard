class NetworkUser {
  final int id;
  final String firstName;
  final String lastName;
  final int age;
  final String city;
  final String country;
  final String bio;
  final String instagramHandle;
  final List<String> interests;
  final String? profilePhoto;
  final double? latitude;
  final double? longitude;
  final String gender;
  final bool isOnline;
  final DateTime lastActive;
  final String? connectionStatus; // 'NONE', 'PENDING', 'CONNECTED', 'REJECTED'
  final bool hasMatched;

  const NetworkUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.city,
    required this.country,
    required this.bio,
    required this.instagramHandle,
    required this.interests,
    this.profilePhoto,
    this.latitude,
    this.longitude,
    required this.gender,
    this.isOnline = false,
    required this.lastActive,
    this.connectionStatus,
    this.hasMatched = false,
  });

  String get name => '$firstName $lastName'.trim();
  
  String get initials {
    if (firstName.isNotEmpty && lastName.isNotEmpty) {
      return '${firstName[0]}${lastName[0]}'.toUpperCase();
    } else if (firstName.isNotEmpty) {
      return firstName[0].toUpperCase();
    }
    return 'U';
  }

  String get locationString => '$city, $country';
  
  String get ageString => '$age years old';

  String get instagram => instagramHandle;

  factory NetworkUser.fromJson(Map<String, dynamic> json) {
    return NetworkUser(
      id: json['id'] as int,
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      age: json['age'] as int? ?? 0,
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      instagramHandle: json['instagramHandle'] as String? ?? '',
      interests: (json['interests'] as List<dynamic>?)?.cast<String>() ?? [],
      profilePhoto: json['profilePhoto'] as String?,
      latitude: json['latitude'] as double?,
      longitude: json['longitude'] as double?,
      gender: json['gender'] as String? ?? '',
      isOnline: json['isOnline'] as bool? ?? false,
      lastActive: json['lastActive'] != null 
          ? DateTime.parse(json['lastActive'] as String)
          : DateTime.now(),
      connectionStatus: json['connectionStatus'] as String?,
      hasMatched: json['hasMatched'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'city': city,
      'country': country,
      'bio': bio,
      'instagramHandle': instagramHandle,
      'interests': interests,
      'profilePhoto': profilePhoto,
      'latitude': latitude,
      'longitude': longitude,
      'gender': gender,
      'isOnline': isOnline,
      'lastActive': lastActive.toIso8601String(),
      'connectionStatus': connectionStatus,
      'hasMatched': hasMatched,
    };
  }

  NetworkUser copyWith({
    int? id,
    String? firstName,
    String? lastName,
    int? age,
    String? city,
    String? country,
    String? bio,
    String? instagramHandle,
    List<String>? interests,
    String? profilePhoto,
    double? latitude,
    double? longitude,
    String? gender,
    bool? isOnline,
    DateTime? lastActive,
    String? connectionStatus,
    bool? hasMatched,
  }) {
    return NetworkUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: age ?? this.age,
      city: city ?? this.city,
      country: country ?? this.country,
      bio: bio ?? this.bio,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      interests: interests ?? this.interests,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gender: gender ?? this.gender,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      hasMatched: hasMatched ?? this.hasMatched,
    );
  }

  String get photoUrl => profilePhoto ?? '';

  @override
  String toString() {
    return 'NetworkUser(id: $id, name: $name, age: $age, location: $locationString)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NetworkUser && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
