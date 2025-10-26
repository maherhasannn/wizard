import 'package:flutter/material.dart';
import 'add_photo_screen.dart';

class PublicProfileSetupScreen extends StatefulWidget {
  final String name;
  final DateTime birthday;
  final String gender;

  const PublicProfileSetupScreen({
    super.key,
    required this.name,
    required this.birthday,
    required this.gender,
  });

  @override
  State<PublicProfileSetupScreen> createState() => _PublicProfileSetupScreenState();
}

class _PublicProfileSetupScreenState extends State<PublicProfileSetupScreen> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _instagramController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();
  
  String? _selectedCountry;
  List<String> _selectedInterests = [];
  bool _isProfilePublic = true;
  bool _isLoading = false;

  final List<String> _availableInterests = [
    'Meditation', 'Yoga', 'Travel', 'Photography', 'Music', 'Art',
    'Cooking', 'Dance', 'Nature', 'Technology', 'Fashion', 'Sports',
    'Reading', 'Movies', 'Gaming', 'Fitness', 'Spirituality', 'Writing'
  ];

  final List<String> _countries = [
    'United States', 'Canada', 'United Kingdom', 'Australia', 'Germany',
    'France', 'Spain', 'Italy', 'Netherlands', 'Sweden', 'Norway',
    'Denmark', 'Finland', 'Japan', 'South Korea', 'Brazil', 'Mexico',
    'Argentina', 'Chile', 'India', 'China', 'Singapore', 'New Zealand'
  ];

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  void _addInterest(String interest) {
    if (!_selectedInterests.contains(interest)) {
      setState(() {
        _selectedInterests.add(interest);
      });
    }
  }

  void _removeInterest(String interest) {
    setState(() {
      _selectedInterests.remove(interest);
    });
  }

  void _continueToAddPhoto() {
    if (_selectedCountry == null || _cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill in Country and City to continue.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to add photo screen with all collected data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPhotoScreen(
          name: widget.name,
          birthday: widget.birthday,
          gender: widget.gender,
          country: _selectedCountry!,
          city: _cityController.text,
          instagram: _instagramController.text,
          interests: _selectedInterests,
          isProfilePublic: _isProfilePublic,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _cityController.dispose();
    _instagramController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');

    return Scaffold(
      backgroundColor: _hexToColor('1B0A33'),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: lightTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Public profile',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Public profile',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'This way we can customise the app for you',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),

              // Country Dropdown
              _buildDropdown(
                label: 'Country',
                value: _selectedCountry,
                items: _countries,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCountry = newValue;
                  });
                },
                lightTextColor: lightTextColor,
                purpleAccent: purpleAccent,
              ),
              const SizedBox(height: 20),

              // City Input
              _buildInputField(
                controller: _cityController,
                hintText: 'Your city',
                lightTextColor: lightTextColor,
                purpleAccent: purpleAccent,
              ),
              const SizedBox(height: 20),

              // Instagram Input
              _buildInputField(
                controller: _instagramController,
                hintText: 'Your Instagram',
                lightTextColor: lightTextColor,
                purpleAccent: purpleAccent,
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 20),

              // Interests Section
              Text(
                'Add your interests',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),

              // Selected Interests
              if (_selectedInterests.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedInterests.map((interest) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: purpleAccent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            interest,
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: lightTextColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          GestureDetector(
                            onTap: () => _removeInterest(interest),
                            child: Icon(
                              Icons.close,
                              color: lightTextColor,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 12),

              // Available Interests
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableInterests.where((interest) => !_selectedInterests.contains(interest)).map((interest) {
                  return GestureDetector(
                    onTap: () => _addInterest(interest),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: lightTextColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: lightTextColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        interest,
                        style: TextStyle(
                          fontFamily: 'DMSans',
                          color: lightTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 30),

              // Profile Visibility Toggle
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: purpleAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: lightTextColor.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Let other people see my profile',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: lightTextColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Allow others to discover and connect with you',
                            style: TextStyle(
                              fontFamily: 'DMSans',
                              color: lightTextColor.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _isProfilePublic,
                      onChanged: (bool value) {
                        setState(() {
                          _isProfilePublic = value;
                        });
                      },
                      activeColor: purpleAccent,
                      activeTrackColor: purpleAccent.withOpacity(0.3),
                      inactiveThumbColor: lightTextColor.withOpacity(0.5),
                      inactiveTrackColor: lightTextColor.withOpacity(0.2),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Continue Button
              GestureDetector(
                onTap: _isLoading ? null : _continueToAddPhoto,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _isLoading ? purpleAccent.withOpacity(0.5) : purpleAccent,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: _isLoading
                      ? Center(
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: lightTextColor,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : Text(
                          'Continue',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            color: lightTextColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required Color lightTextColor,
    required Color purpleAccent,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: purpleAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: lightTextColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: TextStyle(
          fontFamily: 'DMSans',
          color: lightTextColor,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor.withOpacity(0.5),
            fontSize: 16,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required Color lightTextColor,
    required Color purpleAccent,
  }) {
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: purpleAccent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: lightTextColor.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                'Select $label',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor.withOpacity(0.5),
                  fontSize: 16,
                ),
              ),
              isExpanded: true,
              dropdownColor: _hexToColor('2D1B69'),
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 16,
              ),
              icon: Icon(Icons.arrow_drop_down, color: lightTextColor.withOpacity(0.7)),
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
