class Genre {
  final int id;
  final String name;

  const Genre({required this.id, required this.name});

  factory Genre.fromJson(Map<String, dynamic> json) => switch (json) {
    {'mal_id': int id, 'name': String name} => Genre(id: id, name: name),
    _ => throw const FormatException('Failed to load genre.'),
  };
}
