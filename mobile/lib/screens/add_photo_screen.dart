import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../providers/networking_provider.dart';
import 'discovery_methods_screen.dart';

class AddPhotoScreen extends StatefulWidget {
  final String name;
  final DateTime birthday;
  final String gender;
  final String country;
  final String city;
  final String instagram;
  final List<String> interests;
  final bool isProfilePublic;

  const AddPhotoScreen({
    super.key,
    required this.name,
    required this.birthday,
    required this.gender,
    required this.country,
    required this.city,
    required this.instagram,
    required this.interests,
    required this.isProfilePublic,
  });

  @override
  State<AddPhotoScreen> createState() => _AddPhotoScreenState();
}

class _AddPhotoScreenState extends State<AddPhotoScreen> {
  File? _selectedImage;
  bool _isLoading = false;
  final ImagePicker _picker = ImagePicker();

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error picking image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error taking photo: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removePhoto() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _completeProfile() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final networkingProvider = context.read<NetworkingProvider>();
      
      // Create the profile data
      final profileData = {
        'firstName': widget.name.split(' ').first,
        'lastName': widget.name.split(' ').length > 1 ? widget.name.split(' ').skip(1).join(' ') : '',
        'birthday': widget.birthday.toIso8601String(),
        'gender': widget.gender,
        'country': widget.country,
        'city': widget.city,
        'instagramHandle': widget.instagram,
        'interests': widget.interests,
        'isProfilePublic': widget.isProfilePublic,
      };

      // Save profile to backend
      final success = await networkingProvider.saveProfile(profileData);
      
      if (success && _selectedImage != null) {
        // Upload photo if one was selected
        await networkingProvider.uploadPhoto(_selectedImage!);
      }

      if (success) {
        // Navigate to discovery methods screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const DiscoveryMethodsScreen(),
          ),
          (route) => false, // Remove all previous routes
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          'Add your photo',
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
                'Add your photo',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We personalise the app for you',
                style: TextStyle(
                  fontFamily: 'DMSans',
                  color: lightTextColor.withOpacity(0.7),
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),

              // Photo Display/Upload Area
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: lightTextColor.withOpacity(0.3),
                      width: 2,
                      style: _selectedImage == null ? BorderStyle.solid : BorderStyle.none,
                    ),
                  ),
                  child: _selectedImage == null
                      ? GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            decoration: BoxDecoration(
                              color: purpleAccent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: lightTextColor.withOpacity(0.2),
                                width: 2,
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate,
                                  color: lightTextColor.withOpacity(0.5),
                                  size: 48,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Add your photo',
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
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Image.file(
                            _selectedImage!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              // Action Buttons
              if (_selectedImage == null) ...[
                // Upload from Gallery
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: purpleAccent,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      'Add your photo',
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
                const SizedBox(height: 12),
                // Take Photo
                GestureDetector(
                  onTap: _takePhoto,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: lightTextColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: lightTextColor.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Take a photo',
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
              ] else ...[
                // Remove Photo
                GestureDetector(
                  onTap: _removePhoto,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(25),
                      border: Border.all(
                        color: Colors.red.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'Remove photo',
                      style: TextStyle(
                        fontFamily: 'DMSans',
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],

              const Spacer(),

              // Complete Profile Button
              GestureDetector(
                onTap: _isLoading ? null : _completeProfile,
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
                          'Complete Profile',
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
}
