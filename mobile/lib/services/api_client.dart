import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiClient {
  final http.Client _client;
  final FlutterSecureStorage _storage;
  String? _token;

  ApiClient(this._client, this._storage);

  Future<void> loadToken() async {
    _token = await _storage.read(key: 'auth_token');
  }

  void setToken(String token) {
    _token = token;
    _storage.write(key: 'auth_token', value: token);
  }

  Future<void> clearToken() async {
    _token = null;
    await _storage.delete(key: 'auth_token');
  }

  Map<String, String> _headers() => {
    'Content-Type': 'application/json',
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // GET request
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? params}) async {
    String url = '${ApiConfig.baseUrl}$endpoint';
    if (params != null && params.isNotEmpty) {
      url += '?' + params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    }
    
    final response = await _client
        .get(Uri.parse(url), headers: _headers())
        .timeout(ApiConfig.timeout);

    return _handleResponse(response);
  }

  // POST request
  Future<Map<String, dynamic>> post(String endpoint, {dynamic body}) async {
    final response = await _client
        .post(
          Uri.parse('${ApiConfig.baseUrl}$endpoint'),
          headers: _headers(),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(ApiConfig.timeout);

    return _handleResponse(response);
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final response = await _client
        .delete(
          Uri.parse('${ApiConfig.baseUrl}$endpoint'),
          headers: _headers(),
        )
        .timeout(ApiConfig.timeout);

    return _handleResponse(response);
  }

  // PUT request
  Future<Map<String, dynamic>> put(String endpoint, {dynamic body}) async {
    final response = await _client
        .put(
          Uri.parse('${ApiConfig.baseUrl}$endpoint'),
          headers: _headers(),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(ApiConfig.timeout);

    return _handleResponse(response);
  }

  // Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json;
    }
    
    // Extract error message from API response
    final errorMessage = json['error']?['message'] ?? 'Request failed';
    throw ApiException(errorMessage, response.statusCode);
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}

