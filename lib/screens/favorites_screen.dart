import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamr/screens/details_screen.dart';
import '../bloc/cubits/favorites/favorites_cubit.dart';
import '../model/movie_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        foregroundColor: Colors.white,
        title: Text(
          'Favorites',
          style: GoogleFonts.montserrat(fontSize: 15.sp),
        ),
      ),
      body: BlocBuilder<FavoritesCubit, List<Movie>>(
        builder: (context, favoriteMovies) {
          if (favoriteMovies.isEmpty) {
            return Center(
              child: Text(
                'No favorites yet!',
                style: GoogleFonts.montserrat(fontSize: 14.sp),
              ),
            );
          }
          return GridView.builder(
            padding: REdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: favoriteMovies.length,
            itemBuilder: (context, index) {
              final movie = favoriteMovies[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                          movieId: movie.id!,
                          title: movie.title!,
                          backDropPath: movie.backdropPath!,
                          overview: movie.overview!,
                          posterPath: movie.posterPath!,
                          voteAverage: movie.voteAverage!),
                    ),
                  );
                },
                child: GridTile(
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(
                      movie.title ?? "Unknown",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(fontSize: 10.sp),
                    ),
                  ),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
