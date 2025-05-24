class Movie {
  late final String? backdropPath;
  late final int? id;
  late final String? title;
  late final String? originalTitle;
  late final String? overview;
  late final String? posterPath;
  late final String? mediaType;
  late final bool? adult;
  late final String? originalLanguage;
  late final List<int>? genreIds;
  late final double? popularity;
  late final String? releaseDate;
  late final bool? video;
  late final double? voteAverage;
  late final int? voteCount;

  Movie(
      {this.backdropPath,
      this.id,
      this.title,
      this.originalTitle,
      this.overview,
      this.posterPath,
      this.mediaType,
      this.adult,
      this.originalLanguage,
      this.genreIds,
      this.popularity,
      this.releaseDate,
      this.video,
      this.voteAverage,
      this.voteCount});

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      backdropPath: map['backdrop_path'],
      id: map['id'],
      title: map['title'],
      originalTitle: map['original_title'],
      overview: map['overview'],
      posterPath: map['poster_path'],
      mediaType: map['media_type'],
      adult: map['adult'],
      originalLanguage: map['original_language'],
      genreIds:
          (map['genreIds'] != null) ? List<int>.from(map['genreIds']) : [],
      popularity: map['popularity'],
      releaseDate: map['release_date'],
      video: map['video'],
      voteAverage: map['vote_average'],
      voteCount: map['vote_count'],
    );
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie.fromMap(json);
  }


  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'original_title': originalTitle,
      'original_language': originalLanguage,
      'media_type': mediaType,
      'adult': adult,
      'genreIds': genreIds,
      'popularity': popularity,
      'release_date': releaseDate,
      'video': video,
      'vote_count': voteCount,
      'backdrop_path': backdropPath,
      'overview': overview,
      'poster_path': posterPath,
      'vote_average': voteAverage
    };
  }
}
