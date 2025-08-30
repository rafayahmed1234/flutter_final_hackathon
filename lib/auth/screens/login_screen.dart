import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterfinalhackathon/View/screens/home_screen.dart';
import 'package:flutterfinalhackathon/auth/screens/reset_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  bool _isEmailloading = false;


  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _LogInWithEmail() async {
    if (!_formkey.currentState!.validate()) return;
    setState(() {
      _isEmailloading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      String  message = "An error occurred. Please check your credentials";
      if (e.code == "user not found" || e.code == "wrong-password" || e.code == "invalid-credential") {
        message = "Invalid email or password";
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isEmailloading = false);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                _buildHeader(context),
                SizedBox(height: 40,),
                Text("Email", style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
                ),),
                SizedBox(height: 8,),
                _buildEmailField(context),
                SizedBox(height: 20,),
                Text("Password", style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                ),),
                SizedBox(height: 8,),
                _buildPasswordField(context),
                SizedBox(height: 32,),
                _buildLoginButton(context),
                SizedBox(height: 20,),
                _buildForgotPasswordButton(context),
                const Spacer(),
                _buildTermsandPolicyText(),
                SizedBox(height: 16,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        children: [
          IconButton(
            visualDensity: VisualDensity.compact,
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.black),
          ),
          Expanded(
            child: Text(
              "Log into account",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildEmailField(BuildContext context) {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }
        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "example@example",
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return TextFormField(
      controller: _passwordController,
      obscureText: !_isPasswordVisible,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters long';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: "Enter password",
        hintStyle: TextStyle(color: Colors.grey[400]),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }

  Widget _buildLoginButton(BuildContext context) {
    return  SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isEmailloading ? null : _LogInWithEmail,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A00EE),
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isEmailloading
          ? CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
          : Text("Log in", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)
      ),
      )
      );

  }

  Widget _buildForgotPasswordButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: TextButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
          );
        },
        child: Text("Forgot Password", style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),),
      ),
    );
  }

  Widget _buildTermsandPolicyText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Align(
        alignment: Alignment.center,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              style: TextStyle(color: Colors.grey[600], fontSize: 13, height: 1.5),
              children: [
                const TextSpan(text: "By using ProductApp, you agree to our "),
                TextSpan(
                  text: "Terms",
                  style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: "  and  "),
                TextSpan(
                  text: "Privacy Policy",
                  style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: "."),
              ]
          ),
        ),
      ),
    );
  }

}


