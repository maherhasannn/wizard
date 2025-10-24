import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../shared_background.dart';
import 'set_password_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;

  const VerifyEmailScreen({
    Key? key,
    required this.email,
  }) : super(key: key);

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _canResend = true;
  int _resendCountdown = 0;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startResendCountdown() {
    setState(() {
      _canResend = false;
      _resendCountdown = 60;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        return _resendCountdown > 0;
      }
      return false;
    }).then((_) {
      if (mounted) {
        setState(() {
          _canResend = true;
        });
      }
    });
  }

  void _onCodeChanged(int index, String value) {
    if (value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String _getVerificationCode() {
    return _controllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyEmail() async {
    final code = _getVerificationCode();
    if (code.length != 6) {
      _showError('Please enter the complete verification code');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.verifyEmail(widget.email, code);

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SetPasswordScreen(email: widget.email),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _resendCode() async {
    if (!_canResend) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.resendVerificationCode(widget.email);

      if (mounted) {
        _showSuccess('Verification code sent successfully');
        _startResendCountdown();
        // Clear current code
        for (var controller in _controllers) {
          controller.clear();
        }
        _focusNodes[0].requestFocus();
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SharedBackground(
        bgColorHex: '1A0A2E',
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'Verify your email',
                  style: TextStyle(
          fontFamily: 'DMSans',
                    color: const Color(0xFFF5F5F5),
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We sent a 6-digit code to\n${widget.email}',
                  style: TextStyle(
          fontFamily: 'DMSans',
                    color: const Color(0xFFF5F5F5).withOpacity(0.7),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                
                // Verification code input
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (index) {
                    return Container(
                      width: 50,
                      height: 60,
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        style: TextStyle(
          fontFamily: 'DMSans',
                          color: const Color(0xFFF5F5F5),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          counterText: '',
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFFF5F5F5).withOpacity(0.3),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: const Color(0xFFF5F5F5).withOpacity(0.3),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF6A1B9A),
                              width: 2,
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF5F5F5).withOpacity(0.1),
                        ),
                        onChanged: (value) => _onCodeChanged(index, value),
                      ),
                    );
                  }),
                ),
                
                const SizedBox(height: 40),
                
                // Verify button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _verifyEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6A1B9A),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            'Verify',
                            style: TextStyle(
          fontFamily: 'DMSans',
                              color: const Color(0xFFF5F5F5),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Resend code
                TextButton(
                  onPressed: _canResend && !_isLoading ? _resendCode : null,
                  child: Text(
                    _canResend
                        ? 'Resend code'
                        : 'Resend code in ${_resendCountdown}s',
                    style: TextStyle(
          fontFamily: 'DMSans',
                      color: _canResend
                          ? const Color(0xFF6A1B9A)
                          : const Color(0xFFF5F5F5).withOpacity(0.5),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                
                const Spacer(),
                
                // Back button
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Back to registration',
                    style: TextStyle(
          fontFamily: 'DMSans',
                      color: const Color(0xFFF5F5F5).withOpacity(0.7),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
