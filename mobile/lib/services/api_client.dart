import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/api_config.dart';

class ApiClient {
  final http.Client _client;
  final FlutterSecureStorage _storage;
  String? _token;

  ApiClient(this._client, this._storage);

  // Factory constructor for creating instances
  factory ApiClient.instance() {
    return ApiClient(http.Client(), const FlutterSecureStorage());
  }

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

  Map<String, String> _multipartHeaders() => {
    if (_token != null) 'Authorization': 'Bearer $_token',
  };

  // GET request
  Future<Map<String, dynamic>> get(String endpoint, {Map<String, String>? params}) async {
    String url = '${ApiConfig.baseUrl}$endpoint';
    if (params != null && params.isNotEmpty) {
      url += '?' + params.entries.map((e) => '${e.key}=${Uri.encodeComponent(e.value)}').join('&');
    }
    
    print('🌐 [API] GET $url');
    print('📋 [API] Headers: ${_headers()}');
    
    final response = await _client
        .get(Uri.parse(url), headers: _headers())
        .timeout(ApiConfig.timeout);

    print('✅ [API] Response: ${response.statusCode}');
    print('📦 [API] Body: ${response.body}');
    
    return _handleResponse(response);
  }

  // POST request
  Future<Map<String, dynamic>> post(String endpoint, {dynamic body}) async {
    final url = '${ApiConfig.baseUrl}$endpoint';
    print('🌐 [API] POST $url');
    print('📋 [API] Headers: ${_headers()}');
    print('📤 [API] Body: ${body != null ? jsonEncode(body) : "null"}');
    
    try {
      final response = await _client
          .post(
            Uri.parse(url),
            headers: _headers(),
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(ApiConfig.timeout);

      print('✅ [API] Response: ${response.statusCode}');
      print('📦 [API] Body: ${response.body}');
      
      return _handleResponse(response);
    } catch (e) {
      print('❌ [API] Error: $e');
      rethrow;
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final url = '${ApiConfig.baseUrl}$endpoint';
    print('🌐 [API] DELETE $url');
    print('📋 [API] Headers: ${_headers()}');
    
    final response = await _client
        .delete(
          Uri.parse(url),
          headers: _headers(),
        )
        .timeout(ApiConfig.timeout);

    print('✅ [API] Response: ${response.statusCode}');
    print('📦 [API] Body: ${response.body}');
    
    return _handleResponse(response);
  }

  // PUT request
  Future<Map<String, dynamic>> put(String endpoint, {dynamic body}) async {
    final url = '${ApiConfig.baseUrl}$endpoint';
    print('🌐 [API] PUT $url');
    print('📋 [API] Headers: ${_headers()}');
    print('📤 [API] Body: ${body != null ? jsonEncode(body) : "null"}');
    
    final response = await _client
        .put(
          Uri.parse(url),
          headers: _headers(),
          body: body != null ? jsonEncode(body) : null,
        )
        .timeout(ApiConfig.timeout);

    print('✅ [API] Response: ${response.statusCode}');
    print('📦 [API] Body: ${response.body}');
    
    return _handleResponse(response);
  }

  // Handle API response
  Map<String, dynamic> _handleResponse(http.Response response) {
    print('🔍 [API] Parsing response...');
    
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('✨ [API] Success!');
        return json;
      }
      
      // Extract error message from API response
      final errorMessage = json['error']?['message'] ?? json['message'] ?? 'Request failed';
      print('⚠️ [API] Error: $errorMessage (Status: ${response.statusCode})');
      throw ApiException(errorMessage, response.statusCode);
    } catch (e) {
      if (e is ApiException) rethrow;
      print('💥 [API] Failed to parse response: $e');
      throw ApiException('Invalid response from server', response.statusCode);
    }
  }

  // File upload request
  Future<Map<String, dynamic>> uploadFile(String endpoint, File file) async {
    String url = '${ApiConfig.baseUrl}$endpoint';
    
    print('🌐 [API] UPLOAD $url');
    print('📋 [API] Headers: ${_multipartHeaders()}');
    print('📁 [API] File: ${file.path}');
    
    var request = http.MultipartRequest('POST', Uri.parse(url));
    
    // Add headers
    request.headers.addAll(_multipartHeaders());
    
    // Add file
    request.files.add(await http.MultipartFile.fromPath('photo', file.path));
    
    try {
      final streamedResponse = await request.send().timeout(ApiConfig.timeout);
      final response = await http.Response.fromStream(streamedResponse);
      
      print('✅ [API] Response: ${response.statusCode}');
      print('📦 [API] Body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('✨ [API] Success!');
        return data;
      } else {
        final Map<String, dynamic> errorData = json.decode(response.body);
        final String errorMessage = errorData['error']?['message'] ?? 'Upload failed';
        print('⚠️ [API] Error: $errorMessage (Status: ${response.statusCode})');
        throw ApiException(errorMessage, response.statusCode);
      }
    } catch (e) {
      if (e is ApiException) rethrow;
      print('❌ [API] Error: $e');
      throw ApiException('Network error: $e', 0);
    }
  }
}

class ApiException implements Exception {
  final String message;
  final int statusCode;

  ApiException(this.message, this.statusCode);

  @override
  String toString() => message;
}


