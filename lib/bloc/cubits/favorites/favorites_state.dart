import '../../../model/movie_model.dart';

abstract class FavoritesState {
  const FavoritesState();
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Movie> favorites;

  const FavoritesLoaded(this.favorites);
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);
}
