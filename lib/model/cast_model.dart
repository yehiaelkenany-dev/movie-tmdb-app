class CastMember {
  final int id;
  final String name;
  final String originalName;
  final String character;
  final String? profilePath;

  CastMember({
    required this.id,
    required this.name,
    required this.originalName,
    required this.character,
    this.profilePath,
  });

  // Factory method to create a CastMember from JSON
  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      id: json['id'],
      name: json['name'],
      originalName: json['original_name'],
      character: json['character'],
      profilePath: json['profile_path'],
    );
  }
}

class CreditsResponse {
  final List<CastMember> cast;

  CreditsResponse({required this.cast});

  factory CreditsResponse.fromJson(Map<String, dynamic> json) {
    return CreditsResponse(
      cast: (json['cast'] as List)
          .map((castMember) => CastMember.fromJson(castMember))
          .toList(),
    );
  }
}
