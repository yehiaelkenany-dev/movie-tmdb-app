import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:streamr/constants.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  String? _videoKey;
  bool _isLoading = true;
  YoutubePlayerController? _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    fetchMovieTrailer(widget.movieId).then((key) {
      if (key != null) {
        _videoKey = key;
        _youtubePlayerController = YoutubePlayerController(
          initialVideoId: _videoKey!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _youtubePlayerController?.dispose();
    super.dispose();
  }

  Future<String?> fetchMovieTrailer(int movieId) async {
    const apiKey = AppConstants.apiKey;
    final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/$movieId/videos?api_key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> results = data['results'];
      if (results.isNotEmpty) {
        final video = results.firstWhere(
            (v) => v['site'] == 'YouTube' && v['type'] == 'Trailer',
            orElse: () => null);
        return video != null ? video['key'] : null;
      }
    }
    return null; // No video found
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      extendBodyBehindAppBar: true,
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image Section
            Stack(
              children: [
                Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          AppConstants.baseUrl + widget.posterPath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Text(
                    widget.title,
                    style: GoogleFonts.montserrat(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),

            // Overview Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.overview,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),

            // Trailer Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Watch Trailer',
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _videoKey != null
                    ? AspectRatio(
                        aspectRatio: 16 / 9,
                        child: YoutubePlayer(
                          controller: _youtubePlayerController!,
                          showVideoProgressIndicator: true,
                          progressIndicatorColor: Colors.amber,
                          progressColors: const ProgressBarColors(
                            playedColor: Colors.amber,
                            handleColor: Colors.amberAccent,
                          ),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'No trailer available for this movie.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
