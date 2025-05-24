import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:streamr/api/api.dart';
import 'package:streamr/model/cast_model.dart';

import '../../../model/movie_model.dart';

part 'details_state.dart';

class DetailsCubit extends Cubit<DetailsState> {
  final Api _api = Api();

  DetailsCubit() : super(DetailsInitial());

  Future<void> fetchMovieDetails(int movieId) async {
    emit(DetailsLoading());

    try {
      final cast = await _api.fetchMovieCast(movieId);
      final videoKey = await _fetchMovieTrailer(movieId);
      final movie = await _api.fetchMovieById(movieId);

      emit(
        DetailsLoaded(cast: cast, videoKey: videoKey, movie: movie),
      );
    } catch (e) {
      emit(DetailsError(message: "Failed to load movie details."));
    }
  }

  Future<String?> _fetchMovieTrailer(int movieId) async {
    try {
      return await _api.getMovieTrailer(movieId);
    } catch (e) {
      return null;
    }
  }
}
