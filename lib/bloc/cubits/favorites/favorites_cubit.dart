import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/movie_model.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit() : super(FavoritesInitial()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesString = prefs.getString('favorites');
      print("Raw Favorites Data: $favoritesString");

      if (favoritesString != null) {
        final List<dynamic> jsonList = json.decode(favoritesString);
        print("Parsed JSON: $jsonList");

        final List<Movie> favoriteMovies =
            jsonList.map((json) => Movie.fromMap(json)).toList();
        print("Loaded Movies: $favoriteMovies");

        emit(FavoritesLoaded(favoriteMovies));
      } else {
        emit(const FavoritesLoaded([]));
      }
    } catch (e, stackTrace) {
      print("Exception in loadFavorites: $e\n$stackTrace");
      emit(const FavoritesError("Failed to load favorites"));
    }
  }

  Future<void> toggleFavorite(Movie movie) async {
    if (state is! FavoritesLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    final currentFavorites =
        List<Movie>.from((state as FavoritesLoaded).favorites);

    if (currentFavorites.any((m) => m.id == movie.id)) {
      currentFavorites.removeWhere((m) => m.id == movie.id);
    } else {
      currentFavorites.add(movie);
    }

    final List<Map<String, dynamic>> jsonList =
        currentFavorites.map((m) => m.toMap()).toList();
    await prefs.setString('favorites', json.encode(jsonList));

    emit(FavoritesLoaded(currentFavorites));
  }

  bool isFavorite(int movieId) {
    final currentState = state;
    if (currentState is FavoritesLoaded) {
      return currentState.favorites.any((movie) => movie.id == movieId);
    }
    return false;
  }
}
