import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobscan/screens/auth/login_screen.dart';
import 'package:mobscan/screens/splash_Screen.dart';
import 'package:mobscan/services/auth_service.dart';


class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }


        if (!snapshot.hasData || snapshot.data == null) {
          return const LoginScreen();
        }


        return const SplashScreen();
      },
    );
  }
}