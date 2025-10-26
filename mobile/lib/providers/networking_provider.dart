import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/network_user.dart';
import '../models/connection.dart';
import '../services/networking_service.dart';

class NetworkingProvider extends ChangeNotifier {
  final NetworkingService _service;

  NetworkingProvider(this._service);

  // State variables
  List<NetworkUser> _discoveredUsers = [];
  List<NetworkUser> _searchResults = [];
  List<Connection> _connections = [];
  List<String> _searchHistory = [];
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  int _currentSwipeIndex = 0;
  bool _isProfileComplete = false;
  Map<String, dynamic>? _myProfile;

  // Getters
  List<NetworkUser> get discoveredUsers => _discoveredUsers;
  List<NetworkUser> get searchResults => _searchResults;
  List<Connection> get connections => _connections;
  List<String> get searchHistory => _searchHistory;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  int get currentSwipeIndex => _currentSwipeIndex;
  bool get hasMoreUsers => _currentSwipeIndex < _discoveredUsers.length - 1;
  bool get isProfileComplete => _isProfileComplete;
  Map<String, dynamic>? get myProfile => _myProfile;

  // Discover users for swiping
  Future<void> discoverUsers({int limit = 20}) async {
    _setLoading(true);
    _clearError();

    try {
      final users = await _service.discoverUsers(limit: limit);
      _discoveredUsers = users;
      _currentSwipeIndex = 0;
      print('✅ [NetworkingProvider] Discovered ${users.length} users');
    } catch (e) {
      _setError('Failed to discover users: $e');
      print('❌ [NetworkingProvider] Error discovering users: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Record swipe action
  Future<bool> recordSwipe({
    required int swipedUserId,
    required String direction,
  }) async {
    try {
      final result = await _service.recordSwipe(
        swipedUserId: swipedUserId,
        direction: direction,
      );
      
      // Move to next user
      _currentSwipeIndex++;
      
      // Check if there's a match
      final hasMatched = result['matched'] == true;
      if (hasMatched) {
        print('🎉 [NetworkingProvider] Match found with user $swipedUserId!');
        // Update the user's match status
        _updateUserMatchStatus(swipedUserId, true);
      }
      
      return hasMatched;
    } catch (e) {
      _setError('Failed to record swipe: $e');
      print('❌ [NetworkingProvider] Error recording swipe: $e');
      return false;
    }
  }

  // Search users
  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      _setSearching(false);
      return;
    }

    _setSearching(true);
    _clearError();

    try {
      final users = await _service.searchUsers(query);
      _searchResults = users;
      
      // Add to search history if not already present
      if (!_searchHistory.contains(query)) {
        _searchHistory.insert(0, query);
        // Keep only last 10 searches
        if (_searchHistory.length > 10) {
          _searchHistory = _searchHistory.take(10).toList();
        }
      }
      
      print('✅ [NetworkingProvider] Found ${users.length} users for query: $query');
    } catch (e) {
      _setError('Failed to search users: $e');
      print('❌ [NetworkingProvider] Error searching users: $e');
    } finally {
      _setSearching(false);
    }
  }

  // Get user profile
  Future<NetworkUser?> getUserProfile(int userId) async {
    try {
      final user = await _service.getUserProfile(userId);
      return user;
    } catch (e) {
      _setError('Failed to get user profile: $e');
      print('❌ [NetworkingProvider] Error getting user profile: $e');
      return null;
    }
  }

  // Get connections
  Future<void> loadConnections() async {
    _setLoading(true);
    _clearError();

    try {
      final connections = await _service.getConnections();
      _connections = connections;
      print('✅ [NetworkingProvider] Loaded ${connections.length} connections');
    } catch (e) {
      _setError('Failed to load connections: $e');
      print('❌ [NetworkingProvider] Error loading connections: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Send connection request
  Future<bool> sendConnectionRequest(int targetUserId) async {
    try {
      final connection = await _service.sendConnectionRequest(targetUserId);
      _connections.add(connection);
      notifyListeners();
      print('✅ [NetworkingProvider] Connection request sent to user $targetUserId');
      return true;
    } catch (e) {
      _setError('Failed to send connection request: $e');
      print('❌ [NetworkingProvider] Error sending connection request: $e');
      return false;
    }
  }

  // Accept connection
  Future<bool> acceptConnection(int connectionId) async {
    try {
      final connection = await _service.acceptConnection(connectionId);
      _updateConnectionStatus(connectionId, 'ACCEPTED');
      print('✅ [NetworkingProvider] Connection $connectionId accepted');
      return true;
    } catch (e) {
      _setError('Failed to accept connection: $e');
      print('❌ [NetworkingProvider] Error accepting connection: $e');
      return false;
    }
  }

  // Reject connection
  Future<bool> rejectConnection(int connectionId) async {
    try {
      final connection = await _service.rejectConnection(connectionId);
      _updateConnectionStatus(connectionId, 'REJECTED');
      print('✅ [NetworkingProvider] Connection $connectionId rejected');
      return true;
    } catch (e) {
      _setError('Failed to reject connection: $e');
      print('❌ [NetworkingProvider] Error rejecting connection: $e');
      return false;
    }
  }

  // Update network profile
  Future<bool> updateNetworkProfile({
    String? visibility,
    String? lookingFor,
    String? bio,
    List<String>? interests,
  }) async {
    try {
      await _service.updateNetworkProfile(
        visibility: visibility,
        lookingFor: lookingFor,
        bio: bio,
        interests: interests,
      );
      print('✅ [NetworkingProvider] Network profile updated');
      return true;
    } catch (e) {
      _setError('Failed to update network profile: $e');
      print('❌ [NetworkingProvider] Error updating network profile: $e');
      return false;
    }
  }

  // Update location
  Future<bool> updateLocation({
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _service.updateLocation(
        latitude: latitude,
        longitude: longitude,
      );
      print('✅ [NetworkingProvider] Location updated');
      return true;
    } catch (e) {
      _setError('Failed to update location: $e');
      print('❌ [NetworkingProvider] Error updating location: $e');
      return false;
    }
  }

  // Get current user for swiping
  NetworkUser? get currentUser {
    if (_discoveredUsers.isEmpty || _currentSwipeIndex >= _discoveredUsers.length) {
      return null;
    }
    return _discoveredUsers[_currentSwipeIndex];
  }

  // Get next user for swiping
  NetworkUser? get nextUser {
    if (_discoveredUsers.isEmpty || _currentSwipeIndex + 1 >= _discoveredUsers.length) {
      return null;
    }
    return _discoveredUsers[_currentSwipeIndex + 1];
  }

  // Check if user is connected
  bool isUserConnected(int userId) {
    return _connections.any((conn) => 
      (conn.requesterId == userId || conn.receiverId == userId) && 
      conn.isAccepted
    );
  }

  // Get connection status for user
  String? getConnectionStatus(int userId) {
    final connection = _connections.firstWhere(
      (conn) => conn.requesterId == userId || conn.receiverId == userId,
      orElse: () => Connection(
        id: 0,
        requesterId: 0,
        receiverId: 0,
        status: 'NONE',
        createdAt: DateTime.now(),
      ),
    );
    return connection.status == 'NONE' ? null : connection.status;
  }

  // Clear search results
  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }

  // Clear search history
  void clearSearchHistory() {
    _searchHistory = [];
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Reset swipe index
  void resetSwipeIndex() {
    _currentSwipeIndex = 0;
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setSearching(bool searching) {
    _isSearching = searching;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void _updateUserMatchStatus(int userId, bool hasMatched) {
    final index = _discoveredUsers.indexWhere((user) => user.id == userId);
    if (index != -1) {
      _discoveredUsers[index] = _discoveredUsers[index].copyWith(hasMatched: hasMatched);
      notifyListeners();
    }
  }

  void _updateConnectionStatus(int connectionId, String status) {
    final index = _connections.indexWhere((conn) => conn.id == connectionId);
    if (index != -1) {
      _connections[index] = _connections[index].copyWith(status: status);
      notifyListeners();
    }
  }

  // Save profile data
  Future<bool> saveProfile(Map<String, dynamic> profileData) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _service.createOrUpdateProfile(profileData);
      _myProfile = result;
      _isProfileComplete = true;
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to save profile: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Upload profile photo
  Future<bool> uploadPhoto(File imageFile) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _service.uploadProfilePhoto(imageFile);
      if (_myProfile != null) {
        _myProfile!['profilePhoto'] = result['photoUrl'];
        notifyListeners();
      }
      return true;
    } catch (e) {
      _setError('Failed to upload photo: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Load my profile
  Future<void> loadMyProfile() async {
    _setLoading(true);
    _clearError();

    try {
      final profile = await _service.getMyProfile();
      _myProfile = profile;
      _isProfileComplete = profile.isNotEmpty;
      notifyListeners();
    } catch (e) {
      _setError('Failed to load profile: $e');
    } finally {
      _setLoading(false);
    }
  }
}
