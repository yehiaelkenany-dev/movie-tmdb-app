import 'package:equatable/equatable.dart';
import 'package:streamr/model/movie_model.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Movie> movies;
  final String? backgroundImage;

  SearchLoaded({required this.movies, required this.backgroundImage});

  @override
  List<Object?> get props => [movies, backgroundImage];

  SearchLoaded copyWith({List<Movie>? movies, String? backgroundImage}) {
    return SearchLoaded(
      movies: movies ?? this.movies,
      backgroundImage: backgroundImage ?? this.backgroundImage,
    );
  }
}

class SearchError extends SearchState {
  final String message;

  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
