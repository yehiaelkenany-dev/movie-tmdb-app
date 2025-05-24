import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:streamr/screens/home_screen.dart';
import 'package:streamr/screens/login_screen.dart';
import 'package:streamr/screens/splash_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Show splash while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // If user is logged in
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }

        // Otherwise show login screen (or signup)
        return const LoginScreen();
      },
    );
  }
}
