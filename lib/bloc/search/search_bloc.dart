import 'package:bloc/bloc.dart';
import 'package:streamr/api/api.dart';
import 'package:streamr/bloc/search/search_event.dart';
import 'package:streamr/bloc/search/search_state.dart';
import 'package:streamr/model/movie_model.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final Api _api;

  SearchBloc(this._api) : super(SearchInitial()) {
    on<FetchMoviesByCategory>(_onFetchMoviesByCategory);
    on<SearchMovies>(_onSearchMovies);
    on<UpdateBackgroundImage>(_onUpdateBackgroundImage);
  }

  void _onUpdateBackgroundImage(
      UpdateBackgroundImage event, Emitter<SearchState> emit) {
    if (state is SearchLoaded) {
      final currentState = state as SearchLoaded;
      emit(currentState.copyWith(backgroundImage: event.imageUrl));
    }
  }

  void _onFetchMoviesByCategory(
      FetchMoviesByCategory event, Emitter<SearchState> emit) async {
    emit(SearchLoading());

    try {
      List<Movie> movies;
      switch (event.category) {
        case "Top Rated":
          movies = await _api.getTopRatedMovies();
          break;

        case "Upcoming":
          movies = await _api.getUpcomingMovies();
          break;

        case "Trending":
          movies = await _api.getTrendingMovies();
          break;

        default:
          movies = [];
      }

      emit(SearchLoaded(
          movies: movies,
          backgroundImage: movies.isNotEmpty ? movies[0].posterPath : null));
    } catch (e) {
      emit(SearchError('Failed to Load Movies'));
    }
  }

  void _onSearchMovies(SearchMovies event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      List<Movie> movies = await _api.searchMovies(event.query);
      emit(SearchLoaded(
        movies: movies,
        backgroundImage: movies.isNotEmpty ? movies[0].posterPath : null,
      ));
    } catch (e) {
      emit(SearchError('Failed to search movies'));
    }
  }
}
