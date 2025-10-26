import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/network_user.dart';
import '../providers/networking_provider.dart';
import '../widgets/user_search_tile.dart';
import 'user_profile_screen.dart';

class FilterSearchScreen extends StatefulWidget {
  const FilterSearchScreen({super.key});

  @override
  State<FilterSearchScreen> createState() => _FilterSearchScreenState();
}

class _FilterSearchScreenState extends State<FilterSearchScreen> {
  // Filter options
  RangeValues _ageRange = const RangeValues(20, 35);
  String _selectedGender = 'All';
  String _selectedCity = 'All';
  List<String> _selectedInterests = [];
  
  final List<String> _availableInterests = [
    'Music', 'Meditation', 'Art', 'Travel', 'Yoga', 'Photography',
    'Writing', 'Cooking', 'Dance', 'Nature', 'Technology', 'Fashion',
    'Sports', 'Reading', 'Movies', 'Gaming', 'Fitness', 'Spirituality'
  ];

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  void initState() {
    super.initState();
    // Load users when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NetworkingProvider>().discoverUsers();
    });
  }

  void _applyFilters() {
    // For now, we'll use the search functionality with filters
    // In a real implementation, you'd want a dedicated filtered search endpoint
    final query = _buildSearchQuery();
    if (query.isNotEmpty) {
      context.read<NetworkingProvider>().searchUsers(query);
    } else {
      context.read<NetworkingProvider>().discoverUsers();
    }
  }

  String _buildSearchQuery() {
    // Build a search query based on filters
    // This is a simplified approach - in production you'd want proper API filtering
    List<String> queryParts = [];
    
    if (_selectedGender != 'All') {
      queryParts.add(_selectedGender);
    }
    
    if (_selectedCity != 'All') {
      queryParts.add(_selectedCity);
    }
    
    if (_selectedInterests.isNotEmpty) {
      queryParts.addAll(_selectedInterests);
    }
    
    return queryParts.join(' ');
  }

  void _clearFilters() {
    setState(() {
      _ageRange = const RangeValues(20, 35);
      _selectedGender = 'All';
      _selectedCity = 'All';
      _selectedInterests = [];
    });
    context.read<NetworkingProvider>().discoverUsers();
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Consumer<NetworkingProvider>(
      builder: (context, networkingProvider, child) {
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
                  Text(
                    'By Filters',
                    style: TextStyle(
          fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: _clearFilters,
                    child: Text(
                      'Clear',
                      style: TextStyle(
          fontFamily: 'DMSans',
                        color: purpleAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Filter options
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Age range
                    _buildFilterSection(
                      'Age Range',
                      RangeSlider(
                        values: _ageRange,
                        min: 18,
                        max: 50,
                        divisions: 32,
                        activeColor: purpleAccent,
                        inactiveColor: lightTextColor.withOpacity(0.3),
                        onChanged: (values) {
                          setState(() {
                            _ageRange = values;
                          });
                          _applyFilters();
                        },
                      ),
                      '${_ageRange.start.round()} - ${_ageRange.end.round()} years',
                    ),

                    const SizedBox(height: 24),

                    // Gender
                    _buildFilterSection(
                      'Gender',
                      DropdownButton<String>(
                        value: _selectedGender,
                        isExpanded: true,
                        dropdownColor: _hexToColor('2D1B69'),
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 16,
                        ),
                        underline: Container(
                          height: 1,
                          color: lightTextColor.withOpacity(0.3),
                        ),
                        items: ['All', 'Male', 'Female'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedGender = newValue!;
                          });
                          _applyFilters();
                        },
                      ),
                      null,
                    ),

                    const SizedBox(height: 24),

                    // City
                    _buildFilterSection(
                      'City',
                      DropdownButton<String>(
                        value: _selectedCity,
                        isExpanded: true,
                        dropdownColor: _hexToColor('2D1B69'),
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 16,
                        ),
                        underline: Container(
                          height: 1,
                          color: lightTextColor.withOpacity(0.3),
                        ),
                        items: [
                          'All',
                          ...networkingProvider.discoveredUsers.map((user) => user.city).toSet().toList()
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCity = newValue!;
                          });
                          _applyFilters();
                        },
                      ),
                      null,
                    ),

                    const SizedBox(height: 24),

                    // Interests
                    _buildFilterSection(
                      'Interests',
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _availableInterests.map((interest) {
                          final isSelected = _selectedInterests.contains(interest);
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedInterests.remove(interest);
                                } else {
                                  _selectedInterests.add(interest);
                                }
                              });
                              _applyFilters();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? purpleAccent
                                    : lightTextColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? purpleAccent
                                      : lightTextColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                interest,
                                style: TextStyle(
          fontFamily: 'DMSans',
                                  color: isSelected
                                      ? lightTextColor
                                      : lightTextColor.withOpacity(0.7),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      null,
                    ),

                    const SizedBox(height: 30),

                    // Results
                    Text(
                      'Found ${networkingProvider.searchResults.length} people',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // User list
                    if (networkingProvider.searchResults.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: purpleAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: lightTextColor.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.search_off,
                              color: lightTextColor.withOpacity(0.5),
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No people found',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                color: lightTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try adjusting your filters',
                              style: TextStyle(
                                fontFamily: 'DMSans',
                                color: lightTextColor.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...networkingProvider.searchResults.map((user) {
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
                      }).toList(),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Widget _buildFilterSection(String title, Widget child, String? subtitle) {
    final lightTextColor = _hexToColor('F0E6D8');
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.7),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
