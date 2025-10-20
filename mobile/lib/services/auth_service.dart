import '../models/user.dart';
import 'api_client.dart';

class AuthService {
  final ApiClient _client;

  AuthService(this._client);

  Future<AuthResponse> register({
    required String email,
    required String password,
    String? firstName,
    String? lastName,
  }) async {
    final json = await _client.post('/auth/register', body: {
      'email': email,
      'password': password,
      if (firstName != null) 'firstName': firstName,
      if (lastName != null) 'lastName': lastName,
    });

    final data = json['data'] as Map<String, dynamic>;
    return AuthResponse.fromJson(data);
  }

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final json = await _client.post('/auth/login', body: {
      'email': email,
      'password': password,
    });

    final data = json['data'] as Map<String, dynamic>;
    final response = AuthResponse.fromJson(data);
    
    // Store token in client
    _client.setToken(response.token);
    
    return response;
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    final json = await _client.post('/auth/refresh', body: {
      'refreshToken': refreshToken,
    });

    final data = json['data'] as Map<String, dynamic>;
    final response = AuthResponse.fromJson(data);
    
    // Update token in client
    _client.setToken(response.token);
    
    return response;
  }

  Future<User> getCurrentUser() async {
    final json = await _client.get('/auth/me');
    final data = json['data'] as Map<String, dynamic>;
    return User.fromJson(data);
  }

  Future<void> logout() async {
    await _client.clearToken();
  }

  Future<void> requestPasswordReset(String email) async {
    await _client.post('/auth/forgot-password', body: {
      'email': email,
    });
  }

  Future<void> resetPassword({
    required String token,
    required String password,
  }) async {
    await _client.post('/auth/reset-password', body: {
      'token': token,
      'password': password,
    });
  }
}

class AuthResponse {
  final String token;
  final String refreshToken;
  final User user;

  const AuthResponse({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}


