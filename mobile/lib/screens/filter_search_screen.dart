import 'package:flutter/material.dart';
import '../models/network_user.dart';
import '../data/network_users_data.dart';
import '../widgets/user_search_tile.dart';
import 'user_profile_screen.dart';

class FilterSearchScreen extends StatefulWidget {
  const FilterSearchScreen({super.key});

  @override
  State<FilterSearchScreen> createState() => _FilterSearchScreenState();
}

class _FilterSearchScreenState extends State<FilterSearchScreen> {
  final List<NetworkUser> _allUsers = NetworkUsersData.getAllUsers();
  List<NetworkUser> _filteredUsers = [];
  
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
    _filteredUsers = _allUsers;
  }

  void _applyFilters() {
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        // Age filter
        if (user.age < _ageRange.start || user.age > _ageRange.end) {
          return false;
        }

        // Gender filter
        if (_selectedGender != 'All' && user.gender != _selectedGender) {
          return false;
        }

        // City filter
        if (_selectedCity != 'All' && user.city != _selectedCity) {
          return false;
        }

        // Interests filter
        if (_selectedInterests.isNotEmpty) {
          bool hasMatchingInterest = _selectedInterests.any((interest) =>
              user.interests.any((userInterest) =>
                  userInterest.toLowerCase().contains(interest.toLowerCase())));
          if (!hasMatchingInterest) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  void _clearFilters() {
    setState(() {
      _ageRange = const RangeValues(20, 35);
      _selectedGender = 'All';
      _selectedCity = 'All';
      _selectedInterests = [];
      _filteredUsers = _allUsers;
    });
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
                          ..._allUsers.map((user) => user.city).toSet().toList()
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
                      'Found ${_filteredUsers.length} people',
                      style: TextStyle(
          fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // User list
                    if (_filteredUsers.isEmpty)
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
                      ..._filteredUsers.map((user) {
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
