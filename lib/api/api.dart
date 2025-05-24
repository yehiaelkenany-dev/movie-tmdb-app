import 'dart:convert';

import 'package:streamr/constants.dart';
import 'package:streamr/model/movie_model.dart';
import 'package:http/http.dart' as http;

import '../model/cast_model.dart';

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

  Future<List<CastMember>> fetchMovieCast(int movieId) async {
    final String url =
        "https://api.themoviedb.org/3/movie/$movieId/credits?api_key=${AppConstants.apiKey}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return CreditsResponse.fromJson(data).cast;
    } else {
      throw Exception("Failed to load movie credits");
    }
  }

  Future<String?> getMovieTrailer(int movieId) async {
    const apiKey = AppConstants.apiKey;
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> results = data['results'];

      if (results.isNotEmpty) {
        final video = results.firstWhere(
            (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
            orElse: () => null);
        return video != null ? video['key'] : null;
      }
    }
    return null; // No video found
  }

  Future<Movie> fetchMovieById(int id) async {
    final response = await http.get(Uri.parse('${AppConstants.movieDetailsUrl}/$id?api_key=${AppConstants.apiKey}'));
    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to load movie");
    }
  }

}
