import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamr/bloc/home/home_state.dart';
import 'package:streamr/constants.dart';
import 'package:streamr/screens/search_screen.dart';
import '../bloc/home/home_bloc.dart';
import 'details_screen.dart';

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
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
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
        child: Padding(
          padding: REdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upcoming Movies',
                  style: GoogleFonts.montserrat(
                    fontSize: 20.sp,
                    color: Colors.white,
                  )),
              SizedBox(
                height: 10.h,
              ),
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
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8).r,
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                        title: movie.title!,
                                        backDropPath: AppConstants.baseUrl +
                                            movie.backdropPath!,
                                        overview: movie.overview!,
                                        posterPath: AppConstants.baseUrl +
                                            movie.posterPath!,
                                        voteAverage: movie.voteAverage!,
                                        movieId: movie.id!,
                                      ),
                                    ),
                                  );
                                },
                                child: Image.network(
                                  AppConstants.baseUrl + movie.backdropPath!,
                                ),
                              ),
                            ),
                            Padding(
                              padding: REdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                movie.title!,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                      options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 1.4,
                          autoPlayInterval: const Duration(seconds: 5),
                          scrollPhysics: const BouncingScrollPhysics(),
                          autoPlayCurve: Curves.fastOutSlowIn),
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
              Text(
                'Trending Movies',
                style: GoogleFonts.montserrat(
                    fontSize: 20.sp, color: Colors.white),
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 300.h,
                width: double.infinity,
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
                                    width: 150.w,
                                    height: 220.h,
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
                                        height: 120.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        REdgeInsets.symmetric(vertical: 8.0),
                                    child: SizedBox(
                                      width: 150.w,
                                      child: Text(
                                        movie.title!,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white),
                                        maxLines: 5,
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
                height: 300.h,
                width: double.infinity,
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
                                    width: 150.w,
                                    height: 220.h,
                                    margin:
                                        REdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15).r,
                                      color: Colors.white,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(15).r,
                                      child: Image.network(
                                        AppConstants.baseUrl +
                                            movie.backdropPath!,
                                        height: 120,
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
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white),
                                        maxLines: 5,
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
            ],
          ),
        ),
      ),
    );
  }
}
