import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/movie_model.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  FavoritesCubit({
    required this.firestore,
    required this.auth,
  }) : super(FavoritesInitial()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    emit(FavoritesInitial());
    try {
      final user = auth.currentUser;
      if (user != null) {
        final doc = await firestore.collection('favorites').doc(user.uid).get();

        if (doc.exists && doc.data()?['movies'] != null) {
          final List<dynamic> jsonList = doc.data()!['movies'];
          final List<Movie> favoriteMovies =
          jsonList.map((json) => Movie.fromMap(json)).toList();

          emit(FavoritesLoaded(favoriteMovies));
          return;
        }
      }

      // Fallback to SharedPreferences if user not logged in or no Firestore data
      final prefs = await SharedPreferences.getInstance();
      final favoritesString = prefs.getString('favorites');
      if (favoritesString != null) {
        final List<dynamic> jsonList = json.decode(favoritesString);
        final List<Movie> favoriteMovies =
        jsonList.map((json) => Movie.fromMap(json)).toList();
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

    final currentFavorites =
    List<Movie>.from((state as FavoritesLoaded).favorites);

    if (currentFavorites.any((m) => m.id == movie.id)) {
      currentFavorites.removeWhere((m) => m.id == movie.id);
    } else {
      currentFavorites.add(movie);
    }

    final jsonList = currentFavorites.map((m) => m.toMap()).toList();

    // Save to Firestore if user is logged in
    final user = auth.currentUser;
    if (user != null) {
      await firestore.collection('favorites').doc(user.uid).set({
        'movies': jsonList,
      });
    }

    // Also save to SharedPreferences for offline fallback
    final prefs = await SharedPreferences.getInstance();
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

  Future<void> clearFavorites() async {
    final user = auth.currentUser;
    if (user != null) {
      await firestore.collection('favorites').doc(user.uid).delete();
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('favorites');

    emit(const FavoritesLoaded([]));
  }
}
