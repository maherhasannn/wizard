import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service;

  User? _user;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;

  AuthProvider(this._service);

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;

  Future<bool> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    print('👤 [Auth] Starting registration for: $email');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      
      print('✅ [Auth] Registration successful!');
      print('👤 [Auth] User: ${response.user.email}');
      
      _user = response.user;
      _isAuthenticated = true;
      return true;
    } on ApiException catch (e) {
      print('❌ [Auth] API Exception: ${e.message} (${e.statusCode})');
      _error = e.message;
      return false;
    } catch (e) {
      print('💥 [Auth] Unexpected error: $e');
      _error = 'Registration failed';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.login(
        email: email,
        password: password,
      );
      
      _user = response.user;
      _isAuthenticated = true;
      return true;
    } on ApiException catch (e) {
      _error = e.message;
      return false;
    } catch (e) {
      _error = 'Login failed';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCurrentUser() async {
    try {
      _user = await _service.getCurrentUser();
      _isAuthenticated = true;
      notifyListeners();
    } catch (e) {
      _isAuthenticated = false;
      _user = null;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  Future<bool> verifyEmail(String email, String code) async {
    print('👤 [Auth] Verifying email for: $email');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.verifyEmail(email, code);
      
      print('✅ [Auth] Email verification successful!');
      print('👤 [Auth] User: ${response.user.email}');
      
      _user = response.user;
      _isAuthenticated = true;
      return true;
    } on ApiException catch (e) {
      print('❌ [Auth] API Exception: ${e.message} (${e.statusCode})');
      _error = e.message;
      return false;
    } catch (e) {
      print('💥 [Auth] Unexpected error: $e');
      _error = 'Email verification failed';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> resendVerificationCode(String email) async {
    print('👤 [Auth] Resending verification code for: $email');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.resendVerificationCode(email);
      print('✅ [Auth] Verification code sent successfully!');
    } on ApiException catch (e) {
      print('❌ [Auth] API Exception: ${e.message} (${e.statusCode})');
      _error = e.message;
    } catch (e) {
      print('💥 [Auth] Unexpected error: $e');
      _error = 'Failed to resend verification code';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> setPassword(String email, String password) async {
    print('👤 [Auth] Setting password for: $email');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.setPassword(email, password);
      
      print('✅ [Auth] Password set successfully!');
      print('👤 [Auth] User: ${response.user.email}');
      
      _user = response.user;
      _isAuthenticated = true;
      return true;
    } on ApiException catch (e) {
      print('❌ [Auth] API Exception: ${e.message} (${e.statusCode})');
      _error = e.message;
      return false;
    } catch (e) {
      print('💥 [Auth] Unexpected error: $e');
      _error = 'Failed to set password';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    print('👤 [Auth] Requesting password reset for: $email');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.forgotPassword(email);
      print('✅ [Auth] Password reset code sent successfully!');
    } on ApiException catch (e) {
      print('❌ [Auth] API Exception: ${e.message} (${e.statusCode})');
      _error = e.message;
    } catch (e) {
      print('💥 [Auth] Unexpected error: $e');
      _error = 'Failed to send password reset code';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> verifyResetCode(String email, String code) async {
    print('👤 [Auth] Verifying reset code for: $email');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.verifyResetCode(email, code);
      print('✅ [Auth] Reset code verified successfully!');
    } on ApiException catch (e) {
      print('❌ [Auth] API Exception: ${e.message} (${e.statusCode})');
      _error = e.message;
    } catch (e) {
      print('💥 [Auth] Unexpected error: $e');
      _error = 'Failed to verify reset code';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPasswordWithCode({
    required String email,
    required String code,
    required String password,
  }) async {
    print('👤 [Auth] Resetting password for: $email');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _service.resetPasswordWithCode(
        email: email,
        code: code,
        password: password,
      );
      
      print('✅ [Auth] Password reset successfully!');
      print('👤 [Auth] User: ${response.user.email}');
      
      _user = response.user;
      _isAuthenticated = true;
      return true;
    } on ApiException catch (e) {
      print('❌ [Auth] API Exception: ${e.message} (${e.statusCode})');
      _error = e.message;
      return false;
    } catch (e) {
      print('💥 [Auth] Unexpected error: $e');
      _error = 'Failed to reset password';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}


