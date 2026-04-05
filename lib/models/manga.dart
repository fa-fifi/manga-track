class Manga {
  final int id;
  final String title;
  final Map<String, dynamic> images;

  const Manga({required this.id, required this.title, required this.images});

  Manga.fromJson(Map<String, dynamic> json)
    : id = json['mal_id'] as int,
      title = json['title'] as String,
      images = json['images'] as Map<String, dynamic>;

  String get thumbnail => images['jpg']['image_url'] as String;
}
