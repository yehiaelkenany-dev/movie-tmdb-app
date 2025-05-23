import 'package:flutter/material.dart';
import 'package:streamr/screens/details_screen.dart';
import 'package:streamr/screens/error_screen.dart';
import 'package:streamr/screens/favorites_screen.dart';
import 'package:streamr/screens/forget_password_screen.dart';
import 'package:streamr/screens/home_screen.dart';
import 'package:streamr/screens/login_screen.dart';
import 'package:streamr/screens/sign_up_screen.dart';
import 'package:streamr/screens/splash_screen.dart';

import '../screens/search_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

      case '/login':
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case '/sign-up':
        return MaterialPageRoute(
          builder: (_) => const SignUpScreen(),
        );

      case '/forget-password':
        return MaterialPageRoute(
          builder: (_) => const ForgetPasswordScreen(),
        );

      case '/home':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );

      case '/details':
        if (arguments is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => DetailsScreen(
              movieId: arguments['movieId'],
              title: arguments['title'],
              backDropPath: arguments['backDropPath'],
              overview: arguments['overview'],
              posterPath: arguments['posterPath'],
              voteAverage: arguments['voteAverage'],
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => const ErrorScreen(message: "Error using this route"),
        );

      case '/favorites':
        return MaterialPageRoute(
          builder: (_) => const FavoritesScreen(),
        );

      case '/search':
        return MaterialPageRoute(
          builder: (_) => const SearchScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const ErrorScreen(
            message: "Error loading this page..please Restart application.",
          ),
        );
    }
  }
}
