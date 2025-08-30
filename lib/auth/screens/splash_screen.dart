import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterfinalhackathon/auth/screens/launch_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LaunchScreen()),
      );
    },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/Images/product_logo.png",
              height: 100,
            ),
            SizedBox(height: 20,),
            Text("My Product App", style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),),
            SizedBox(height: 20,),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
