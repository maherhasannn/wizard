import '../models/user.dart';
import 'api_client.dart';

class UserService {
  final ApiClient _client;

  UserService(this._client);

  Future<User> getProfile() async {
    final json = await _client.get('/user/profile');
    final data = json['data'] as Map<String, dynamic>;
    return User.fromJson(data);
  }

  Future<User> updateProfile({
    String? firstName,
    String? lastName,
    String? phone,
    String? bio,
    DateTime? birthday,
    String? gender,
    String? country,
    String? city,
    String? instagramHandle,
    List<String>? interests,
    bool? isProfilePublic,
  }) async {
    final json = await _client.put('/user/profile', body: {
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
      if (phone != null) 'phone': phone,
      if (bio != null) 'bio': bio,
      if (birthday != null) 'birthday': birthday.toIso8601String(),
      if (gender != null) 'gender': gender,
      if (country != null) 'country': country,
      if (city != null) 'city': city,
      if (instagramHandle != null) 'instagramHandle': instagramHandle,
      if (interests != null) 'interests': interests,
      if (isProfilePublic != null) 'isProfilePublic': isProfilePublic,
    });

    final data = json['data'] as Map<String, dynamic>;
    return User.fromJson(data);
  }

  Future<void> updateProfilePhoto(String photoUrl) async {
    await _client.put('/user/profile/photo', body: {
      'profilePhoto': photoUrl,
    });
  }

  Future<void> deleteAccount() async {
    await _client.delete('/user/account');
  }
}


