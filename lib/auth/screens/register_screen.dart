import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutterfinalhackathon/auth/screens/register_email_screen.dart';

import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Row(
                children: [
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back, color: Colors.black,),
                  ),
                  Expanded(
                    child: Text("Create New Account", textAlign: TextAlign.center, style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                    ),),
                  ),
                  SizedBox(width: 48,),
                ],
              ),
              SizedBox(height: 32,),
              Text(
                "Begin with creating new free account. This helps you keep your learning way easier.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[900],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 32,),
              _buildEmailButton(context),
              SizedBox(height: 24,),
              _buildDivider(context),
              SizedBox(height: 24,),
              _buildSocialbutton(
                iconPath: "assets/Images/apple_logo.png",
                text: "Continue with Apple",
                onPressed: (){},
              ),
              SizedBox(height: 16,),
              _buildSocialbutton(
                iconPath: "assets/Images/facebook_logo.png",
                text: "Continue with Facebook",
                onPressed: (){},
              ),
              SizedBox(height: 16,),
              _buildSocialbutton(
                iconPath: "assets/Images/google_logo.png",
                text: "Continue with Google",
                onPressed: (){},
              ),
              const Spacer(),
              _buildTermsandPolicyText(),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildEmailButton(BuildContext context) {
  return  SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RegisterEmailScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6A00EE),
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Text("Continue with Email", style: TextStyle(
        color: Colors.white
      ),),
    ),
  );
}

Widget _buildDivider(BuildContext context) {
  return Row(
    children: [
      Expanded(
        child: Divider(
          thickness: 1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text("or", style: TextStyle(color: Colors.grey[900]),),
      ),
      Expanded(
        child: Divider(
          thickness: 1,
        ),
      )
    ],
  );
}

Widget _buildSocialbutton({required String iconPath, required String text, required VoidCallback onPressed}) {
  return SizedBox(
    width: double.infinity,
    child: OutlinedButton.icon(
      onPressed: onPressed,
      icon: Image.asset(iconPath, height: 22.0,),
      label: Text(
        text,style: TextStyle(
        color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600,
      ),
      ),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        )
      )
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
