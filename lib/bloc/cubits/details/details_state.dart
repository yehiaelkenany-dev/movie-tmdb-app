part of 'details_cubit.dart';

abstract class DetailsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetailsInitial extends DetailsState {}

class DetailsLoading extends DetailsState {}

class DetailsLoaded extends DetailsState {
  final Movie movie;
  final List<CastMember> cast;
  final String? videoKey;

  DetailsLoaded({required this.movie, required this.cast, required this.videoKey});

  @override
  List<Object?> get props => [cast, videoKey];
}

class DetailsError extends DetailsState {
  final String message;

  DetailsError({required this.message});

  @override
  List<Object?> get props => [message];
}
