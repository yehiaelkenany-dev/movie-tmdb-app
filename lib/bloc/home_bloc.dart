import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/api.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<FetchMoviesEvent>((event, emit) async {
      emit(HomeLoading());

      try {
        final upcomingMovies = await Api().getUpcomingMovies();
        final trendingMovies = await Api().getTrendingMovies();
        final topRatedMovies = await Api().getTopRatedMovies();

        emit(HomeLoaded(
          upcomingMovies: upcomingMovies,
          trendingMovies: trendingMovies,
          topRatedMovies: topRatedMovies,
        ));
      } catch (e) {
        emit(HomeError("Failed to fetch movies. Please try again later."));
      }
    });
  }
}
