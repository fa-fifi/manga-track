import 'package:mangatrack/models/genre.dart';

class Manga {
  final int id;
  final String title;
  final Map<String, dynamic> _images;
  final List<dynamic> _genres;

  Manga.fromJson(Map<String, dynamic> json)
    : id = json['mal_id'] as int,
      title = json['title'] as String,
      _images = json['images'] as Map<String, dynamic>,
      _genres = json['genres'] as List<dynamic>;

  String get thumbnail => _images['jpg']['image_url'] as String;

  List<Genre> get genres => _genres
      .map((json) => Genre.fromJson(json as Map<String, dynamic>))
      .toList();
}
