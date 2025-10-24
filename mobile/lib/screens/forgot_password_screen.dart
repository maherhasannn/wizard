import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../shared_background.dart';
import 'verify_reset_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  Color _hexToColor(String hexCode) {
    final hexString = hexCode.replaceAll('#', '');
    return Color(int.parse('FF$hexString', radix: 16));
  }

  Future<void> _handleForgotPassword() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      try {
        await authProvider.forgotPassword(_emailController.text.trim());
        
        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyResetCodeScreen(email: _emailController.text.trim()),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to send reset code: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lightTextColor = _hexToColor('F0E6D8');
    final purpleAccent = _hexToColor('6A1B9A');
    final bgColor = _hexToColor('1B0A33');

    return Scaffold(
      body: SharedBackground(
        bgColorHex: '1B0A33',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildFormScreen(lightTextColor, purpleAccent),
          ),
        ),
      ),
    );
  }

  Widget _buildFormScreen(Color lightTextColor, Color purpleAccent) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Forgot password',
          style: TextStyle(
          fontFamily: 'DMSans',
            color: lightTextColor,
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 48),

        Form(
          key: _formKey,
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
          fontFamily: 'DMSans',color: lightTextColor),
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: lightTextColor.withOpacity(0.7),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: lightTextColor.withOpacity(0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: purpleAccent),
                borderRadius: BorderRadius.circular(12),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(12),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!value.contains('@')) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 24),

        // Restore password button
        ElevatedButton(
          onPressed: _handleForgotPassword,
          style: ElevatedButton.styleFrom(
            backgroundColor: purpleAccent,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Restore password',
            style: TextStyle(
          fontFamily: 'DMSans',
              color: lightTextColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

}
