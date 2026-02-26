import 'dart:async';
import 'package:flutter/material.dart';
import 'Onborarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double progress = 0.0;
  int percentage = 0;

  @override
  void initState() {
    startLoading();
    super.initState();
  }

  void startLoading() {
    Timer.periodic(Duration(milliseconds: 35), (timer) {
      setState(() {
        progress += 0.01;
        percentage = (progress * 100).toInt();
      });
      if (progress >= 1.0) {
        timer.cancel();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Onborarding()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A1A2F),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/Hero Icon_ Glowing Shield_margin.png",
              height: 270,
            ),
            Image.asset(
              "assets/App Name & Tagline.png",
              height: 100,
              width: 250,
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                spacing: 5,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/Horizontal Divider.png", width: 20),
                  Image.asset("assets/Icon.png", width: 50),
                  Image.asset("assets/Horizontal Divide.png", width: 20),
                ],
              ),
            ),
            Row(
              spacing: 50,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "initializing Systems",
                  style: TextStyle(
                    color: Colors.white70,
                    letterSpacing: 2,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "$percentage%",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 7,

                  // backgroundColor: Colors.white12,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
