import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _phoneController = TextEditingController();
  final _instagramController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedCountry;
  String? _selectedCity;
  DateTime? _selectedBirthday;
  bool _isProfilePublic = true;

  @override
  void initState() {
    super.initState();
    // TODO: Load current user data into form fields
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    _phoneController.dispose();
    _instagramController.dispose();
    super.dispose();
  }

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');
    final darkPurple = _hexToColor('2D1B69');

    return Scaffold(
      backgroundColor: darkPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: lightTextColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: Text(
              'Save',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: purpleAccent,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Photo Section
              _buildProfilePhotoSection(lightTextColor, purpleAccent, darkPurple),
              
              const SizedBox(height: 32),
              
              // Personal Information
              _buildSectionTitle('Personal Information', lightTextColor),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _firstNameController,
                label: 'First Name',
                lightTextColor: lightTextColor,
                purpleAccent: purpleAccent,
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _lastNameController,
                label: 'Last Name',
                lightTextColor: lightTextColor,
                purpleAccent: purpleAccent,
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                lightTextColor: lightTextColor,
                purpleAccent: purpleAccent,
                keyboardType: TextInputType.phone,
              ),
              
              const SizedBox(height: 16),
              
              _buildDateField(lightTextColor, purpleAccent),
              
              const SizedBox(height: 16),
              
              _buildGenderField(lightTextColor, purpleAccent),
              
              const SizedBox(height: 32),
              
              // Location Information
              _buildSectionTitle('Location', lightTextColor),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: TextEditingController(text: _selectedCountry ?? ''),
                label: 'Country',
                lightTextColor: lightTextColor,
                purpleAccent: purpleAccent,
                readOnly: true,
                onTap: () => _showCountryPicker(lightTextColor, purpleAccent),
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: TextEditingController(text: _selectedCity ?? ''),
                label: 'City',
                lightTextColor: lightTextColor,
                purpleAccent: purpleAccent,
                readOnly: true,
                onTap: () => _showCityPicker(lightTextColor, purpleAccent),
              ),
              
              const SizedBox(height: 32),
              
              // Social Information
              _buildSectionTitle('Social', lightTextColor),
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _instagramController,
                label: 'Instagram Handle',
                lightTextColor: lightTextColor,
                purpleAccent: purpleAccent,
                prefixText: '@',
              ),
              
              const SizedBox(height: 16),
              
              _buildTextField(
                controller: _bioController,
                label: 'Bio',
                lightTextColor: lightTextColor,
                purpleAccent: purpleAccent,
                maxLines: 3,
              ),
              
              const SizedBox(height: 32),
              
              // Privacy Settings
              _buildSectionTitle('Privacy', lightTextColor),
              const SizedBox(height: 16),
              
              _buildPrivacyToggle(lightTextColor, purpleAccent),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePhotoSection(Color lightTextColor, Color purpleAccent, Color darkPurple) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: lightTextColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Container(
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.person,
                      color: Colors.grey[600],
                      size: 48,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _changeProfilePhoto,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: purpleAccent,
                      border: Border.all(
                        color: darkPurple,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Tap to change photo',
            style: TextStyle(
              fontFamily: 'DMSans',
              color: lightTextColor.withOpacity(0.7),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color lightTextColor) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'DMSans',
        color: lightTextColor,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required Color lightTextColor,
    required Color purpleAccent,
    TextInputType? keyboardType,
    bool readOnly = false,
    String? prefixText,
    int maxLines = 1,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      style: TextStyle(
        fontFamily: 'DMSans',
        color: lightTextColor,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          fontFamily: 'DMSans',
          color: lightTextColor.withOpacity(0.7),
        ),
        prefixText: prefixText,
        prefixStyle: TextStyle(
          fontFamily: 'DMSans',
          color: lightTextColor,
        ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: lightTextColor.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: lightTextColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: purpleAccent,
            width: 2,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField(Color lightTextColor, Color purpleAccent) {
    return GestureDetector(
      onTap: () => _selectBirthday(lightTextColor, purpleAccent),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: lightTextColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              color: lightTextColor.withOpacity(0.7),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _selectedBirthday != null
                  ? '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}'
                  : 'Birthday',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: _selectedBirthday != null
                    ? lightTextColor
                    : lightTextColor.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderField(Color lightTextColor, Color purpleAccent) {
    return GestureDetector(
      onTap: () => _showGenderPicker(lightTextColor, purpleAccent),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: lightTextColor.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.person_outline,
              color: lightTextColor.withOpacity(0.7),
              size: 20,
            ),
            const SizedBox(width: 12),
            Text(
              _selectedGender ?? 'Gender',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: _selectedGender != null
                    ? lightTextColor
                    : lightTextColor.withOpacity(0.7),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrivacyToggle(Color lightTextColor, Color purpleAccent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: lightTextColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isProfilePublic ? Icons.public : Icons.lock,
            color: lightTextColor.withOpacity(0.7),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Public Profile',
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _isProfilePublic
                      ? 'Your profile is visible to other users'
                      : 'Your profile is private',
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
            onChanged: (value) {
              setState(() {
                _isProfilePublic = value;
              });
            },
            activeColor: purpleAccent,
          ),
        ],
      ),
    );
  }

  void _changeProfilePhoto() {
    // TODO: Implement photo selection with proper security validation
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Photo selection coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _selectBirthday(Color lightTextColor, Color purpleAccent) {
    showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 100)),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: purpleAccent,
              surface: _hexToColor('2D1B69'),
            ),
          ),
          child: child!,
        );
      },
    ).then((date) {
      if (date != null) {
        setState(() {
          _selectedBirthday = date;
        });
      }
    });
  }

  void _showGenderPicker(Color lightTextColor, Color purpleAccent) {
    showModalBottomSheet(
      context: context,
      backgroundColor: _hexToColor('2D1B69'),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Gender',
              style: TextStyle(
                fontFamily: 'DMSans',
                color: lightTextColor,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ...['Male', 'Female', 'Other', 'Prefer not to say'].map((gender) {
              return ListTile(
                title: Text(
                  gender,
                  style: TextStyle(
                    fontFamily: 'DMSans',
                    color: lightTextColor,
                  ),
                ),
                onTap: () {
                  setState(() {
                    _selectedGender = gender;
                  });
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(Color lightTextColor, Color purpleAccent) {
    // TODO: Implement country picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Country picker coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showCityPicker(Color lightTextColor, Color purpleAccent) {
    // TODO: Implement city picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('City picker coming soon'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // TODO: Implement profile saving with proper validation and security
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile saved successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }
}
