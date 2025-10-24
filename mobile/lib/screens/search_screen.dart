import 'package:flutter/material.dart';
import '../models/network_user.dart';
import '../data/network_users_data.dart';
import '../widgets/user_search_tile.dart';
import 'user_profile_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<NetworkUser> _searchResults = [];
  List<String> _searchHistory = ['Amina Peterson', 'Raoul Murphy', 'Olga Makropova', 'Scott Powell'];
  bool _isSearching = false;

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final results = NetworkUsersData.searchUsers(query);
      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  void _onSearchHistoryTap(String query) {
    _searchController.text = query;
    _performSearch(query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Scaffold(
      backgroundColor: _hexToColor('1B0A33'),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back,
                      color: lightTextColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Search',
                      style: TextStyle(
          fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: lightTextColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: lightTextColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      color: lightTextColor.withOpacity(0.7),
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(
                            color: lightTextColor.withOpacity(0.5),
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        onChanged: _performSearch,
                      ),
                    ),
                    if (_searchController.text.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                        child: Icon(
                          Icons.clear,
                          color: lightTextColor.withOpacity(0.7),
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Content
            Expanded(
              child: _searchController.text.isEmpty
                  ? _buildSearchHistory()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'HISTORY',
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ..._searchHistory.map((query) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () => _onSearchHistoryTap(query),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: purpleAccent.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: lightTextColor.withOpacity(0.1),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.history,
                        color: lightTextColor.withOpacity(0.7),
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        query,
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final lightTextColor = _hexToColor('F0E6D8');

    if (_isSearching) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              color: lightTextColor.withOpacity(0.7),
            ),
            const SizedBox(height: 16),
            Text(
              'Searching...',
              style: TextStyle(
          fontFamily: 'DMSans',
                color: lightTextColor.withOpacity(0.7),
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              color: lightTextColor.withOpacity(0.5),
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Unfortunately nothing found',
              style: TextStyle(
          fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different request',
              style: TextStyle(
          fontFamily: 'DMSans',
                color: lightTextColor.withOpacity(0.7),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Found People',
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: UserSearchTile(
                    user: user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfileScreen(user: user),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
