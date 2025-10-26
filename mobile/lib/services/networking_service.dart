import 'dart:io';
import '../models/network_user.dart';
import '../models/connection.dart';
import 'api_client.dart';

class NetworkingService {
  final ApiClient _apiClient;

  NetworkingService(this._apiClient);

  /// Discover users for swiping
  Future<List<NetworkUser>> discoverUsers({int limit = 20}) async {
    try {
      final response = await _apiClient.get('/networking/discover', params: {'limit': limit.toString()});
      final List<dynamic> usersData = response['data'] ?? [];
      return usersData.map((userData) => NetworkUser.fromJson(userData)).toList();
    } catch (e) {
      print('❌ [NetworkingService] Error discovering users: $e');
      rethrow;
    }
  }

  /// Record a swipe action
  Future<Map<String, dynamic>> recordSwipe({
    required int swipedUserId,
    required String direction, // 'LEFT' or 'RIGHT'
  }) async {
    try {
      final response = await _apiClient.post('/networking/swipe', body: {
        'swipedUserId': swipedUserId,
        'direction': direction,
      });
      return response['data'] ?? {};
    } catch (e) {
      print('❌ [NetworkingService] Error recording swipe: $e');
      rethrow;
    }
  }

  /// Search users by query
  Future<List<NetworkUser>> searchUsers(String query) async {
    try {
      final response = await _apiClient.get('/networking/search', params: {'q': query});
      final List<dynamic> usersData = response['data'] ?? [];
      return usersData.map((userData) => NetworkUser.fromJson(userData)).toList();
    } catch (e) {
      print('❌ [NetworkingService] Error searching users: $e');
      rethrow;
    }
  }

  /// Get user profile by ID
  Future<NetworkUser> getUserProfile(int userId) async {
    try {
      final response = await _apiClient.get('/networking/user/$userId');
      return NetworkUser.fromJson(response['data']);
    } catch (e) {
      print('❌ [NetworkingService] Error getting user profile: $e');
      rethrow;
    }
  }

  /// Get all connections
  Future<List<Connection>> getConnections() async {
    try {
      final response = await _apiClient.get('/networking/connections');
      final List<dynamic> connectionsData = response['data'] ?? [];
      return connectionsData.map((connData) => Connection.fromJson(connData)).toList();
    } catch (e) {
      print('❌ [NetworkingService] Error getting connections: $e');
      rethrow;
    }
  }

  /// Send connection request
  Future<Connection> sendConnectionRequest(int targetUserId) async {
    try {
      final response = await _apiClient.post('/networking/connections/request', body: {
        'targetUserId': targetUserId,
      });
      return Connection.fromJson(response['data']);
    } catch (e) {
      print('❌ [NetworkingService] Error sending connection request: $e');
      rethrow;
    }
  }

  /// Accept connection request
  Future<Connection> acceptConnection(int connectionId) async {
    try {
      final response = await _apiClient.post('/networking/connections/$connectionId/accept');
      return Connection.fromJson(response['data']);
    } catch (e) {
      print('❌ [NetworkingService] Error accepting connection: $e');
      rethrow;
    }
  }

  /// Reject connection request
  Future<Connection> rejectConnection(int connectionId) async {
    try {
      final response = await _apiClient.post('/networking/connections/$connectionId/reject');
      return Connection.fromJson(response['data']);
    } catch (e) {
      print('❌ [NetworkingService] Error rejecting connection: $e');
      rethrow;
    }
  }

  /// Update network profile
  Future<Map<String, dynamic>> updateNetworkProfile({
    String? visibility,
    String? lookingFor,
    String? bio,
    List<String>? interests,
  }) async {
    try {
      final response = await _apiClient.put('/networking/profile', body: {
        if (visibility != null) 'visibility': visibility,
        if (lookingFor != null) 'lookingFor': lookingFor,
        if (bio != null) 'bio': bio,
        if (interests != null) 'interests': interests,
      });
      return response['data'] ?? {};
    } catch (e) {
      print('❌ [NetworkingService] Error updating network profile: $e');
      rethrow;
    }
  }

  /// Update user location
  Future<Map<String, dynamic>> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _apiClient.post('/networking/location', body: {
        'latitude': latitude,
        'longitude': longitude,
      });
      return response['data'] ?? {};
    } catch (e) {
      print('❌ [NetworkingService] Error updating location: $e');
      rethrow;
    }
  }

  /// Create or update user profile
  Future<Map<String, dynamic>> createOrUpdateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiClient.post('/networking/profile', body: profileData);
      return response['data'] ?? {};
    } catch (e) {
      print('❌ [NetworkingService] Error creating/updating profile: $e');
      rethrow;
    }
  }

  /// Upload profile photo
  Future<Map<String, dynamic>> uploadProfilePhoto(File imageFile) async {
    try {
      final response = await _apiClient.uploadFile('/networking/profile/photo', imageFile);
      return response['data'] ?? {};
    } catch (e) {
      print('❌ [NetworkingService] Error uploading profile photo: $e');
      rethrow;
    }
  }

  /// Get user's own profile
  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await _apiClient.get('/networking/profile');
      return response['data'] ?? {};
    } catch (e) {
      print('❌ [NetworkingService] Error getting profile: $e');
      rethrow;
    }
  }
}
