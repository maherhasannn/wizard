class User {
  final int id;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? profilePhoto;
  final String? bio;
  final DateTime? birthday;
  final String? gender;
  final String? country;
  final String? city;
  final String? instagramHandle;
  final List<String> interests;
  final bool isProfilePublic;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    this.firstName,
    this.lastName,
    this.phone,
    this.profilePhoto,
    this.bio,
    this.birthday,
    this.gender,
    this.country,
    this.city,
    this.instagramHandle,
    this.interests = const [],
    this.isProfilePublic = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      bio: json['bio'] as String?,
      birthday: json['birthday'] != null 
          ? DateTime.parse(json['birthday'] as String)
          : null,
      gender: json['gender'] as String?,
      country: json['country'] as String?,
      city: json['city'] as String?,
      instagramHandle: json['instagramHandle'] as String?,
      interests: json['interests'] != null
          ? List<String>.from(json['interests'] as List)
          : [],
      isProfilePublic: json['isProfilePublic'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'profilePhoto': profilePhoto,
      'bio': bio,
      'birthday': birthday?.toIso8601String(),
      'gender': gender,
      'country': country,
      'city': city,
      'instagramHandle': instagramHandle,
      'interests': interests,
      'isProfilePublic': isProfilePublic,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    return firstName ?? lastName ?? email.split('@').first;
  }

  User copyWith({
    int? id,
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    String? profilePhoto,
    String? bio,
    DateTime? birthday,
    String? gender,
    String? country,
    String? city,
    String? instagramHandle,
    List<String>? interests,
    bool? isProfilePublic,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      bio: bio ?? this.bio,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      country: country ?? this.country,
      city: city ?? this.city,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      interests: interests ?? this.interests,
      isProfilePublic: isProfilePublic ?? this.isProfilePublic,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

