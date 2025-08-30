import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterfinalhackathon/auth/screens/login_screen.dart';

class RegisterPasswordScreen extends StatefulWidget {
  final String email;

  const RegisterPasswordScreen({super.key, required this.email});

  @override
  State<RegisterPasswordScreen> createState() => _RegisterPasswordScreenState();
}

class _RegisterPasswordScreenState extends State<RegisterPasswordScreen> {
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  bool _hasEightCharacters = false;
  bool _hasNumber = false;
  bool _hasSymbol = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_validatePassword);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _validatePassword() {
    String password = _passwordController.text;
    setState(() {
      _hasEightCharacters = password.length >= 8;
      _hasNumber = password.contains(RegExp(r'[0-9]'));
      _hasSymbol = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  bool _isPasswordValid() {
    return _hasEightCharacters && _hasNumber && _hasSymbol;
  }

  Future<void> _createAccount() async {
    if (!_isPasswordValid()) return;

    setState(() => _isLoading = true);
    try {
      await _auth.createUserWithEmailAndPassword(
        email: widget.email,
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'An error occurred.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              _buildHeader(),
              const SizedBox(height: 50),
              const Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              _buildPasswordField(),
              const SizedBox(height: 24),
              _buildValidationChecks(),
              const SizedBox(height: 32),
              _buildContinueButton(),
              const Spacer(),
              _buildFooterText(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const Text('Create your password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: '********',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
    );
  }

  Widget _buildValidationChecks() {
    return Column(
      children: [
        _buildValidationRow(text: '8 characters minimum', isValid: _hasEightCharacters),
        const SizedBox(height: 8),
        _buildValidationRow(text: 'a number', isValid: _hasNumber),
        const SizedBox(height: 8),
        _buildValidationRow(text: 'one symbol minimum', isValid: _hasSymbol),
      ],
    );
  }

  Widget _buildValidationRow({required String text, required bool isValid}) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.circle_outlined,
          color: isValid ? Colors.green : Colors.grey,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(color: isValid ? Colors.black87 : Colors.grey),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    bool isButtonEnabled = _isPasswordValid() && !_isLoading;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isButtonEnabled ? _createAccount : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A00EE),
          disabledBackgroundColor: Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: _isLoading
            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
            : const Text('Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildFooterText() {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
          children: [
            const TextSpan(text: 'By using Classroom, you agree to the\n'),
            TextSpan(
              text: 'Terms',
              style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: const TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()..onTap = () {},
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}