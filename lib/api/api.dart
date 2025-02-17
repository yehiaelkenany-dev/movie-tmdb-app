import 'dart:convert';

import 'package:streamr/constants.dart';
import 'package:streamr/model/movie_model.dart';
import 'package:http/http.dart' as http;

class Api {
  Future<List<Movie>> getUpcomingMovies() async {
    final response = await http.get(
        Uri.parse(AppConstants.upcomingMoviesApiUrl + AppConstants.apiKey));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to fetch Upcoming Movies');
    }
  }

  Future<List<Movie>> getTrendingMovies() async {
    final response = await http.get(
        Uri.parse(AppConstants.trendingMoviesApiUrl + AppConstants.apiKey));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to fetch Trending Movies');
    }
  }

  Future<List<Movie>> getTopRatedMovies() async {
    final response = await http.get(
        Uri.parse(AppConstants.topRatedMoviesApiUrl + AppConstants.apiKey));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['results'];

      List<Movie> movies = data.map((movie) => Movie.fromMap(movie)).toList();
      return movies;
    } else {
      throw Exception('Failed to fetch Top Rated Movies');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse(
        '${AppConstants.searchURL}?api_key=${AppConstants.apiKey}&query=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List)
          .map((movieData) => Movie.fromMap(movieData))
          .toList();
      return movies;
    } else {
      throw Exception('Failed to search movies');
    }
  }
}
