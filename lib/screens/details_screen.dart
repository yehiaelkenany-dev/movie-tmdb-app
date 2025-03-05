import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamr/bloc/cubits/details/details_cubit.dart';
import 'package:streamr/model/movie_model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../bloc/cubits/favorites/favorites_cubit.dart';

class DetailsScreen extends StatefulWidget {
  final int movieId;
  final String title, backDropPath, overview, posterPath;
  final double voteAverage;

  const DetailsScreen({
    super.key,
    required this.movieId,
    required this.title,
    required this.backDropPath,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final favoritesCubit = context.read<FavoritesCubit>();

    return SafeArea(
      child: BlocProvider<DetailsCubit>(
        create: (context) => DetailsCubit()..fetchMovieDetails(widget.movieId),
        child: Scaffold(
          backgroundColor: Colors.black12,
          extendBodyBehindAppBar: false,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_rounded,
                color: Colors.white,
              ),
            ),
          ),
          body: BlocBuilder<DetailsCubit, DetailsState>(
            builder: (context, state) {
              if (state is DetailsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DetailsError) {
                return Center(
                    child: Text(state.message,
                        style: const TextStyle(color: Colors.white)));
              } else if (state is DetailsLoaded) {
                return SingleChildScrollView(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.sizeOf(context).height,
                    ),
                    margin: REdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        state.videoKey != null
                            ? SizedBox(
                                height: 200.h,
                                width: double.infinity,
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: YoutubePlayer(
                                    controller: YoutubePlayerController(
                                      initialVideoId: state.videoKey!,
                                      flags: const YoutubePlayerFlags(
                                        autoPlay: false,
                                        mute: false,
                                      ),
                                    ),
                                    showVideoProgressIndicator: true,
                                    progressIndicatorColor: Colors.amber,
                                    progressColors: const ProgressBarColors(
                                      playedColor: Colors.amber,
                                      handleColor: Colors.amberAccent,
                                    ),
                                  ),
                                ),
                              )
                            : Padding(
                                padding: REdgeInsets.all(16.0),
                                child: const Text(
                                  'No trailer available for this movie.',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.title,
                              style: GoogleFonts.montserrat(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.amberAccent,
                              ),
                            ),
                            BlocBuilder<FavoritesCubit, List<Movie>>(
                              builder: (context, favorites) {
                                final isFavorite =
                                    favoritesCubit.isFavorite(widget.movieId);
                                return Container(
                                  height: 30.h,
                                  width: 40.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    borderRadius: BorderRadius.circular(20.r),
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      final movie = Movie(
                                        id: widget.movieId,
                                        title: widget.title,
                                        overview: widget.overview,
                                        posterPath: widget.posterPath,
                                        backdropPath: widget.backDropPath,
                                        voteAverage: widget.voteAverage,
                                      );
                                      favoritesCubit.toggleFavorite(movie);
                                    },
                                    icon: Icon(
                                      isFavorite
                                          ? CupertinoIcons.heart_fill
                                          : CupertinoIcons.heart,
                                      color: isFavorite
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        // Overview Section
                        Text(
                          widget.overview,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.montserrat(
                            fontSize: 12.sp,
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "Top Cast",
                          style: GoogleFonts.montserrat(
                              fontSize: 18.sp, color: Colors.white),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        SizedBox(
                          height: 140.h, // Set height to fit avatars and text
                          child: state.cast.isNotEmpty
                              ? ListView.builder(
                                  scrollDirection:
                                      Axis.horizontal, // Horizontal scrolling
                                  itemCount: state.cast.length,
                                  itemBuilder: (context, index) {
                                    final actor = state.cast[index];

                                    return Padding(
                                      padding: REdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Column(
                                        children: [
                                          ClipOval(
                                            child: actor.profilePath != null
                                                ? Image.network(
                                                    "https://image.tmdb.org/t/p/w500${actor.profilePath}",
                                                    height: 75.h,
                                                    width: 75.w,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Image.asset(
                                                    "assets/images/avatar.png",
                                                    height: 75.h,
                                                    width: 75.w,
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          SizedBox(height: 5.h),
                                          SizedBox(
                                            width: 70.w, // Limit text width
                                            child: Text(
                                              actor.name,
                                              textAlign: TextAlign.center,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.montserrat(
                                                fontSize: 10.sp,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    "No cast available",
                                    style: GoogleFonts.montserrat(
                                        color: Colors.white),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
