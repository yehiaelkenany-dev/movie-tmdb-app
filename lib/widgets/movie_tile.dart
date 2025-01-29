import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:streamr/constants.dart';
import 'package:streamr/model/movie_model.dart';

class MovieTile extends StatelessWidget {
  final double height;
  final double width;
  final Movie movie;
  const MovieTile(
      {super.key,
      required this.height,
      required this.width,
      required this.movie});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: _moviePosterWidget(movie.posterPath!)),
          const SizedBox(width: 8),
          Expanded(flex: 7, child: _movieInfoWidget()),
        ],
      ),
    );
  }

  Widget _moviePosterWidget(String _imageUrl) {
    final String fullImageUrl = AppConstants.baseUrl + _imageUrl;
    return Container(
      height: height,
      width: width * 0.33,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(fullImageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _movieInfoWidget() {
    return Container(
      height: height,
      width: width * 0.66,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width * 0.56,
                child: Text(
                  movie.title!,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                movie.voteAverage.toString(),
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.02, 0, 0),
            child: Text(
              "${movie.originalLanguage!.toUpperCase()}  | R:  ${movie.adult}  | ${movie.releaseDate}",
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, height * 0.07, 0, 0),
            child: Text(
              movie.overview!,
              maxLines: 9,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
