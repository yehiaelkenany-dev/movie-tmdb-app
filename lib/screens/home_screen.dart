import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamr/bloc/home/home_state.dart';
import 'package:streamr/constants.dart';
import 'package:streamr/screens/favorites_screen.dart';
import 'package:streamr/screens/search_screen.dart';
import '../bloc/home/home_bloc.dart';
import 'details_screen.dart';
import 'error_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        foregroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
            icon: const Icon(Icons.favorite)),
        title: Image.asset(
          "assets/images/logo.png",
          fit: BoxFit.cover,
          height: 35.h,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.search_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: REdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Upcoming Movies',
                style: GoogleFonts.montserrat(
                  fontSize: 20.sp,
                  color: Colors.white,
                ),
              ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.01,
              // ),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is HomeLoaded) {
                    return CarouselSlider.builder(
                      itemCount: state.upcomingMovies.length,
                      itemBuilder: (context, index, movieIndex) {
                        final movie = state.upcomingMovies[index];
                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8).r,
                              ),
                              child: InkWell(
                                onTap: () {
                                  try {
                                    if (movie.id == null ||
                                        movie.title == null) {
                                      throw Exception("Invalid movie data");
                                    }

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailsScreen(
                                          title: movie.title ?? "Unknown Title",
                                          backDropPath: (movie.backdropPath !=
                                                      null &&
                                                  movie
                                                      .backdropPath!.isNotEmpty)
                                              ? AppConstants.baseUrl +
                                                  movie.backdropPath!
                                              : "assets/images/error-image.png", // Fallback error image
                                          overview: movie.overview ??
                                              "No overview available.",
                                          posterPath: (movie.posterPath !=
                                                      null &&
                                                  movie.posterPath!.isNotEmpty)
                                              ? AppConstants.baseUrl +
                                                  movie.posterPath!
                                              : "assets/images/error-image.png",
                                          voteAverage: movie.voteAverage ?? 0.0,
                                          movieId: movie.id!,
                                        ),
                                      ),
                                    );
                                  } catch (e) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ErrorScreen(
                                            message: "Something went wrong"),
                                      ),
                                    );
                                  }
                                },
                                child: movie.backdropPath != null &&
                                        movie.backdropPath!.isNotEmpty
                                    ? Image.network(
                                        AppConstants.baseUrl +
                                            movie.backdropPath!,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.25,
                                      )
                                    : Image.asset(
                                        "assets/images/broken-image.png",
                                        fit: BoxFit.contain,
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.25,
                                        color: Colors.white,
                                      ),
                              ),
                            ),
                            Text(
                              movie.title!,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: MediaQuery.of(context).size.width > 600
                              ? 2.8
                              : 1.4,
                          autoPlayInterval: const Duration(seconds: 5),
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlayCurve: Curves.fastOutSlowIn),
                    );
                  } else if (state is HomeError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
              Text(
                'Trending Movies',
                style: GoogleFonts.montserrat(
                    fontSize: 20.sp, color: Colors.white),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.4,
                width: MediaQuery.sizeOf(context).width,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is HomeLoaded) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.trendingMovies.length,
                          itemBuilder: (context, index) {
                            final movie = state.trendingMovies[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      movieId: movie.id!,
                                      title: movie.title!,
                                      voteAverage: movie.voteAverage!,
                                      posterPath: AppConstants.baseUrl +
                                          movie.posterPath!,
                                      overview: movie.overview!,
                                      backDropPath: AppConstants.baseUrl +
                                          movie.backdropPath!,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.sizeOf(context).width *
                                        0.35, // 30% of screen width
                                    height:
                                        MediaQuery.sizeOf(context).height * 0.3,
                                    margin:
                                        REdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15).w,
                                      color: Colors.white,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15).w,
                                      child: Image.network(
                                        AppConstants.baseUrl +
                                            movie.backdropPath!,
                                        height: 100.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        REdgeInsets.symmetric(vertical: 8.0),
                                    child: SizedBox(
                                      width: 120.w,
                                      child: Text(
                                        movie.title!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 12.sp),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (state is HomeError) {
                        return Center(
                          child: Text(state.message,
                              style: const TextStyle(color: Colors.red)),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
              Text(
                'Top Rated Movies',
                style: GoogleFonts.montserrat(
                    fontSize: 20.sp, color: Colors.white),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.4,
                width: MediaQuery.sizeOf(context).width,
                child: Container(
                  margin: REdgeInsets.symmetric(vertical: 10),
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state is HomeLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is HomeLoaded) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: state.topRatedMovies.length,
                          itemBuilder: (context, index) {
                            final movie = state.topRatedMovies[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailsScreen(
                                      movieId: movie.id!,
                                      title: movie.title!,
                                      voteAverage: movie.voteAverage!,
                                      posterPath: AppConstants.baseUrl +
                                          movie.posterPath!,
                                      overview: movie.overview!,
                                      backDropPath: AppConstants.baseUrl +
                                          movie.backdropPath!,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Container(
                                    width: MediaQuery.sizeOf(context).width *
                                        0.35, // 30% of screen width
                                    height: MediaQuery.sizeOf(context).height *
                                        0.30, // 30% of screen width
                                    margin:
                                        REdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.white,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(
                                        AppConstants.baseUrl +
                                            movie.backdropPath!,
                                        height: 100.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: REdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: SizedBox(
                                      width: 150.w,
                                      child: Text(
                                        movie.title!,
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else if (state is HomeError) {
                        return Center(
                          child: Text(
                            state.message,
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
