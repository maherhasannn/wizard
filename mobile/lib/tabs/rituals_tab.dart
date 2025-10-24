import 'package:flutter/material.dart';
import '../shared_background.dart';

class RitualsTab extends StatefulWidget {
  const RitualsTab({super.key});

  @override
  State<RitualsTab> createState() => _RitualsTabState();
}

class _RitualsTabState extends State<RitualsTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(lightTextColor, purpleAccent),
              
              const SizedBox(height: 30),
              
              // Search Bar
              _buildSearchBar(lightTextColor, purpleAccent),
              
              const SizedBox(height: 30),
              
              // My Rituals
              _buildMyRituals(lightTextColor, purpleAccent),
              
              const SizedBox(height: 30),
              
              // Explore by Category
              _buildExploreByCategory(lightTextColor, purpleAccent),
              
              const SizedBox(height: 30),
              
              // New Releases
              _buildNewReleases(lightTextColor, purpleAccent),
              
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color lightTextColor, Color purpleAccent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Rituals',
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: purpleAccent.withOpacity(0.3),
            border: Border.all(
              color: lightTextColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.search,
            color: lightTextColor,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(Color lightTextColor, Color purpleAccent) {
    return Container(
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
            color: lightTextColor.withOpacity(0.5),
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
              ),
              decoration: InputDecoration(
                hintText: 'Search for rituals, topics...',
                hintStyle: TextStyle(
                  color: lightTextColor.withOpacity(0.5),
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyRituals(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Rituals',
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildRitualCategory('Favorites', Icons.favorite, lightTextColor, purpleAccent),
            const SizedBox(width: 16),
            _buildRitualCategory('Recently Played', Icons.history, lightTextColor, purpleAccent),
            const SizedBox(width: 16),
            _buildRitualCategory('Downloads', Icons.download, lightTextColor, purpleAccent),
          ],
        ),
      ],
    );
  }

  Widget _buildRitualCategory(String title, IconData icon, Color lightTextColor, Color purpleAccent) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  purpleAccent.withOpacity(0.8),
                  purpleAccent.withOpacity(0.4),
                ],
              ),
            ),
            child: Icon(
              icon,
              color: lightTextColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildExploreByCategory(Color lightTextColor, Color purpleAccent) {
    final categories = [
      {'name': 'Confidence Boost', 'color': Colors.red},
      {'name': 'Calm & Clarity', 'color': Colors.blue},
      {'name': 'Sleep Better', 'color': Colors.purple},
      {'name': 'Morning Energy', 'color': Colors.orange},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Explore by Category',
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      (category['color'] as Color).withOpacity(0.8),
                      (category['color'] as Color).withOpacity(0.4),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category['name'] as String,
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: lightTextColor.withOpacity(0.7),
                        size: 16,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNewReleases(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'New Releases',
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                width: 80,
                height: 80,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      purpleAccent.withOpacity(0.8),
                      purpleAccent.withOpacity(0.4),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: purpleAccent.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.music_note,
                    color: lightTextColor,
                    size: 32,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}