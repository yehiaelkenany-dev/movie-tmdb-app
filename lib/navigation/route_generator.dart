import 'package:flutter/material.dart';
import 'package:streamr/model/movie_model.dart';
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
    final uri = Uri.parse(settings.name ?? '');

    if (uri.path == '/') {
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    }

    if (uri.path == '/login') {
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    }

    if (uri.path == '/sign-up') {
      return MaterialPageRoute(builder: (_) => const SignUpScreen());
    }

    if (uri.path == '/forget-password') {
      return MaterialPageRoute(builder: (_) => const ForgetPasswordScreen());
    }

    if (uri.path == '/home') {
      return MaterialPageRoute(builder: (_) => const HomeScreen());
    }

    if (uri.path == '/favorites') {
      return MaterialPageRoute(builder: (_) => const FavoritesScreen());
    }

    if (uri.path == '/search') {
      return MaterialPageRoute(builder: (_) => const SearchScreen());
    }

    if (uri.path == '/details') {
      final movie = settings.arguments;

      if (movie is Movie) {
        // Return a loading screen that fetches and then navigates
        return MaterialPageRoute(
          builder: (_) =>
              DetailsScreen(
                movieId: movie.id!,
                title: movie.title!,
                backDropPath: movie.backdropPath!,
                overview: movie.overview!,
                posterPath: movie.posterPath!,
                voteAverage: movie.voteAverage!,
              ),
        );
      } else {
        return MaterialPageRoute(
          builder: (_) =>
          const ErrorScreen(
            message: "Invalid or missing movie ID.",
          ),
        );
      }
    }

    return MaterialPageRoute(
      builder: (_) => const ErrorScreen(
        message: "Route not found.",
      ),
    );
  }
}
