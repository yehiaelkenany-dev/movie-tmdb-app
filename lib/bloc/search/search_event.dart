import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMoviesByCategory extends SearchEvent {
  final String category;

  FetchMoviesByCategory(this.category);

  @override
  List<Object?> get props => [category];
}

class SearchMovies extends SearchEvent {
  final String query;

  SearchMovies(this.query);

  @override
  List<Object?> get props => [query];
}

class UpdateBackgroundImage extends SearchEvent {
  final String imageUrl;

  UpdateBackgroundImage(this.imageUrl);
}
