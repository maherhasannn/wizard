import 'package:flutter/material.dart';
import 'public_profile_setup_screen.dart';

class ProfileQuestionnaireScreen extends StatefulWidget {
  const ProfileQuestionnaireScreen({super.key});

  @override
  State<ProfileQuestionnaireScreen> createState() => _ProfileQuestionnaireScreenState();
}

class _ProfileQuestionnaireScreenState extends State<ProfileQuestionnaireScreen> {
  final TextEditingController _nameController = TextEditingController();
  DateTime? _selectedBirthday;
  String? _selectedGender;
  bool _isLoading = false;

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthday ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _hexToColor('6A1B9A'), // purpleAccent
              onPrimary: _hexToColor('F0E6D8'), // lightTextColor
              onSurface: _hexToColor('F0E6D8'), // lightTextColor
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: _hexToColor('6A1B9A'), // purpleAccent
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedBirthday) {
      setState(() {
        _selectedBirthday = picked;
      });
    }
  }

  void _continueToPublicProfile() {
    if (_nameController.text.isEmpty || _selectedBirthday == null || _selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields to continue.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Navigate to public profile setup with collected data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PublicProfileSetupScreen(
          name: _nameController.text,
          birthday: _selectedBirthday!,
          gender: _selectedGender!,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
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
          'Questionnaire',
          style: TextStyle(
            fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tell us about yourself',
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

              // Name Input
              _buildInputField(
                controller: _nameController,
                hintText: 'Name',
                lightTextColor: lightTextColor,
                purpleAccent: purpleAccent,
              ),
              const SizedBox(height: 20),

              // Birthday Input
              GestureDetector(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        child: Text(
                          _selectedBirthday == null
                              ? 'Birthday'
                              : '${_selectedBirthday!.day}/${_selectedBirthday!.month}/${_selectedBirthday!.year}',
                          style: TextStyle(
                            fontFamily: 'DMSans',
                            color: _selectedBirthday == null
                                ? lightTextColor.withOpacity(0.5)
                                : lightTextColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Icon(Icons.calendar_today, color: lightTextColor.withOpacity(0.7), size: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Gender Dropdown
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
                    value: _selectedGender,
                    hint: Text(
                      'Gender',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: lightTextColor.withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                    isExpanded: true,
                    dropdownColor: _hexToColor('2D1B69'), // A darker purple for dropdown
                    style: TextStyle(
                      fontFamily: 'DMSans',
                      color: lightTextColor,
                      fontSize: 16,
                    ),
                    icon: Icon(Icons.arrow_drop_down, color: lightTextColor.withOpacity(0.7)),
                    items: <String>['Female', 'Male', 'Non-binary', 'Prefer not to say']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGender = newValue;
                      });
                    },
                  ),
                ),
              ),

              const Spacer(),

              // Continue Button
              GestureDetector(
                onTap: _isLoading ? null : _continueToPublicProfile,
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
}
