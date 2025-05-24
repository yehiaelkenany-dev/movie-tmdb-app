import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          Expanded(flex: 3, child: _moviePosterWidget(movie.posterPath)),
          SizedBox(width: 8.w),
          Expanded(flex: 7, child: _movieInfoWidget(context)),
        ],
      ),
    );
  }

  Widget _moviePosterWidget(String? _imageUrl) {
    final String? fullImageUrl =
        _imageUrl != null ? AppConstants.baseUrl + _imageUrl : null;
    return fullImageUrl != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8).r,
            child: Image.network(
              fullImageUrl,
              height: 150.h,
              width: 250.w,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            height: 150.h,
            width: 250.w,
            color: Colors.grey[800],
            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.white),
            ),
          );
  }

  Widget _movieInfoWidget(BuildContext context) {
    return Container(
      height: 150.h,
      width: 300.w,
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
                width: 180.w,
                child: Tooltip(
                  message: movie.title!,
                  child: Text(
                    movie.title!,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: GoogleFonts.montserrat(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Text(
                movie.voteAverage.toString(),
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: 15.sp,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 5.h, 0, 0),
            child: Row(
              children: [
                Text(
                  "${movie.originalLanguage!.toUpperCase()}  | R:  ${movie.adult}  | ${movie.releaseDate}",
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/details?id=${movie.id}',
                    );

                  },
                  icon: const Icon(
                    CupertinoIcons.arrow_right_circle_fill,
                    color: Colors.white70,
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0, 8.h, 0, 0),
            child: Text(
              movie.overview!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                color: Colors.white70,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
