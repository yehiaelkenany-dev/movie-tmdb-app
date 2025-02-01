import 'package:equatable/equatable.dart';
import '../../model/movie_model.dart';

abstract class HomeState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Movie> upcomingMovies;
  final List<Movie> trendingMovies;
  final List<Movie> topRatedMovies;

  HomeLoaded({
    required this.upcomingMovies,
    required this.trendingMovies,
    required this.topRatedMovies,
  });

  @override
  List<Object?> get props => [upcomingMovies, trendingMovies, topRatedMovies];
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
