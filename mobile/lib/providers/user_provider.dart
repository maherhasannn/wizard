import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/user_service.dart';
import '../services/api_client.dart';

class UserProvider extends ChangeNotifier {
  final UserService _service;

  User? _profile;
  bool _isLoading = false;
  String? _error;

  UserProvider(this._service);

  User? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _profile = await _service.getProfile();
    } on ApiException catch (e) {
      _error = e.message;
    } catch (e) {
      _error = 'Failed to load profile';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateProfile({
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
    try {
      _profile = await _service.updateProfile(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        bio: bio,
        birthday: birthday,
        gender: gender,
        country: country,
        city: city,
        instagramHandle: instagramHandle,
        interests: interests,
        isProfilePublic: isProfilePublic,
      );
      notifyListeners();
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProfilePhoto(String photoUrl) async {
    try {
      await _service.updateProfilePhoto(photoUrl);
      if (_profile != null) {
        _profile = _profile!.copyWith(profilePhoto: photoUrl);
        notifyListeners();
      }
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

