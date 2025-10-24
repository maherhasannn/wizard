import 'package:flutter/material.dart';
import '../shared_background.dart';

class CirceTab extends StatefulWidget {
  const CirceTab({super.key});

  @override
  State<CirceTab> createState() => _CirceTabState();
}

class _CirceTabState extends State<CirceTab> {
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
              
              // Live Q&A Section
              _buildLiveQA(lightTextColor, purpleAccent),
              
              const SizedBox(height: 30),
              
              // Past Livestreams
              _buildPastLivestreams(lightTextColor, purpleAccent),
              
              const SizedBox(height: 30),
              
              // Find Queens Near You
              _buildFindQueens(lightTextColor, purpleAccent),
              
              const SizedBox(height: 100), // Space for bottom navigation
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color lightTextColor, Color purpleAccent) {
    return Text(
      'Community',
      style: TextStyle(
          fontFamily: 'DMSans',
        color: lightTextColor,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildLiveQA(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LIVE Q&A',
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor.withOpacity(0.8),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                purpleAccent.withOpacity(0.8),
                purpleAccent.withOpacity(0.6),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: lightTextColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightTextColor.withOpacity(0.2),
                    ),
                    child: Icon(
                      Icons.video_call,
                      color: lightTextColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LIVE Q&A',
                          style: TextStyle(
          fontFamily: 'DMSans',
                            color: lightTextColor.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'How to overcome fear',
                          style: TextStyle(
          fontFamily: 'DMSans',
                            color: lightTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Today, 2:00 PM',
                style: TextStyle(
          fontFamily: 'DMSans',
                  color: lightTextColor.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: lightTextColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        'Set a Reminder',
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPastLivestreams(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Past Livestreams',
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Container(
                width: 150,
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      purpleAccent.withOpacity(0.8),
                      purpleAccent.withOpacity(0.4),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                          color: lightTextColor.withOpacity(0.1),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_filled,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            index == 0 ? 'Building Confidence' : 
                            index == 1 ? 'Morning Motivation' : 'Self-Love Journey',
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            index == 0 ? '45 min' : index == 1 ? '32 min' : '28 min',
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: lightTextColor.withOpacity(0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFindQueens(Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Find Queens Near You',
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => _showJoinModal(context, lightTextColor, purpleAccent),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: purpleAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: lightTextColor.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                // Map placeholder
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: lightTextColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.map,
                          color: lightTextColor.withOpacity(0.5),
                          size: 40,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Map View',
                          style: TextStyle(
          fontFamily: 'DMSans',
                            color: lightTextColor.withOpacity(0.7),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: lightTextColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Text(
                    'Join the Circle',
                    style: TextStyle(
          fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showJoinModal(BuildContext context, Color lightTextColor, Color purpleAccent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: purpleAccent.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    color: lightTextColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Profile pictures collage
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildProfilePicture(lightTextColor, 0),
                  const SizedBox(width: -10),
                  _buildProfilePicture(lightTextColor, 1),
                  const SizedBox(width: -10),
                  _buildProfilePicture(lightTextColor, 2),
                  const SizedBox(width: -10),
                  _buildProfilePicture(lightTextColor, 3),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Join the Circle',
                style: TextStyle(
          fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Connect with like-minded women in your area and build meaningful relationships.',
                style: TextStyle(
          fontFamily: 'DMSans',
                  color: lightTextColor.withOpacity(0.8),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              _buildDropdown('Country', 'Select your country', lightTextColor, purpleAccent),
              const SizedBox(height: 16),
              _buildDropdown('City', 'Select your city', lightTextColor, purpleAccent),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: lightTextColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: lightTextColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Connect Instagram',
                      style: TextStyle(
          fontFamily: 'DMSans',
                        color: lightTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: lightTextColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  'Join',
                  style: TextStyle(
          fontFamily: 'DMSans',
                    color: purpleAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePicture(Color lightTextColor, int index) {
    final colors = [Colors.red, Colors.blue, Colors.green, Colors.orange];
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors[index].withOpacity(0.8),
        border: Border.all(
          color: lightTextColor,
          width: 2,
        ),
      ),
      child: Icon(
        Icons.person,
        color: lightTextColor,
        size: 20,
      ),
    );
  }

  Widget _buildDropdown(String label, String hint, Color lightTextColor, Color purpleAccent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: lightTextColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: lightTextColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hint,
                  style: TextStyle(
          fontFamily: 'DMSans',
                    color: lightTextColor.withOpacity(0.7),
                    fontSize: 16,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: lightTextColor.withOpacity(0.5),
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}