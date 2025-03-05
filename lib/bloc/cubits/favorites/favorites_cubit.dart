import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/movie_model.dart';

class FavoritesCubit extends Cubit<List<Movie>> {
  FavoritesCubit() : super([]) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesString = prefs.getString('favorites');
    if (favoritesString != null) {
      final List<dynamic> jsonList = json.decode(favoritesString);
      final List<Movie> favoriteMovies =
          jsonList.map((json) => Movie.fromMap(json)).toList();
      emit(favoriteMovies);
    }
  }

  Future<void> toggleFavorite(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Movie> currentFavorites = List.from(state);

    if (currentFavorites.any((m) => m.id == movie.id)) {
      currentFavorites.removeWhere((m) => m.id == movie.id);
    } else {
      currentFavorites.add(movie);
    }

    final List<Map<String, dynamic>> jsonList =
        currentFavorites.map((m) => m.toMap()).toList();
    await prefs.setString('favorites', json.encode(jsonList));

    emit(currentFavorites);
  }

  bool isFavorite(int movieId) {
    return state.any((movie) => movie.id == movieId);
  }
}
