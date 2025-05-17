import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:streamr/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      nextScreen: const LoginScreen(),
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: LottieBuilder.asset(
                "assets/lottie/Animation - 1747139158420.json"),
          ),
        ],
      ),
      backgroundColor: Colors.black,
      animationDuration: const Duration(seconds: 5),
      splashIconSize: 400,
    );
  }
}
