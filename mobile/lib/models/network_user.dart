class NetworkUser {
  final String id;
  final String name;
  final int age;
  final String city;
  final String country;
  final String bio;
  final String instagram;
  final List<String> interests;
  final String photoUrl; // placeholder
  final double latitude;  // mock coordinates
  final double longitude;
  final String gender;
  final bool isOnline;
  final DateTime lastActive;

  const NetworkUser({
    required this.id,
    required this.name,
    required this.age,
    required this.city,
    required this.country,
    required this.bio,
    required this.instagram,
    required this.interests,
    required this.photoUrl,
    required this.latitude,
    required this.longitude,
    required this.gender,
    this.isOnline = false,
    required this.lastActive,
  });

  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  String get locationString => '$city, $country';
  
  String get ageString => '$age years old';

  NetworkUser copyWith({
    String? id,
    String? name,
    int? age,
    String? city,
    String? country,
    String? bio,
    String? instagram,
    List<String>? interests,
    String? photoUrl,
    double? latitude,
    double? longitude,
    String? gender,
    bool? isOnline,
    DateTime? lastActive,
  }) {
    return NetworkUser(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      city: city ?? this.city,
      country: country ?? this.country,
      bio: bio ?? this.bio,
      instagram: instagram ?? this.instagram,
      interests: interests ?? this.interests,
      photoUrl: photoUrl ?? this.photoUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      gender: gender ?? this.gender,
      isOnline: isOnline ?? this.isOnline,
      lastActive: lastActive ?? this.lastActive,
    );
  }

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
