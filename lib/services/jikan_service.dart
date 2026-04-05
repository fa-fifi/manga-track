import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mangatrack/models/genre.dart';
import 'package:mangatrack/models/manga.dart';

/// Thin wrapper around the Jikan v4 API.
/// Methods return the full decoded JSON response map.
/// Exceptions are NOT caught — let them propagate so the caller can handle them.
class JikanService {
  static const String _baseUrl = 'https://api.jikan.moe/v4';

  /// GET /genres/manga
  /// Returns the full decoded response map, e.g. `{ "data": [...] }`.
  static Future<List<Genre>> fetchGenres() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/genres/manga'));
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final data = (responseBody['data'] as List<dynamic>?) ?? [];
        final genres = data
            .map((json) => Genre.fromJson(json as Map<String, dynamic>))
            .toList();

        return genres;
      } else {
        final errorMessage = responseBody['message'] as String;

        throw HttpException('${response.statusCode}: $errorMessage');
      }
    } catch (e, s) {
      log('Failed to fetch manga genres.', error: e, stackTrace: s);
      return [];
    }
  }

  /// GET /manga with optional filters.
  ///
  /// [query]   — free-text search (`q` parameter)
  /// [genreId] — filter by a single genre id (`genres` parameter)
  /// [page]    — 1-based page number (default 1)
  /// [limit]   — results per page (default 25)
  ///
  /// Returns the full decoded response map, e.g. `{ "data": [...], "pagination": {...} }`.
  static Future<List<Manga>> fetchManga({
    String? query,
    int? genreId,
    int page = 1,
    int limit = 25,
  }) async {
    final params = <String, String>{
      'page': page.toString(),
      'limit': limit.toString(),
      'sfw': 'true',
      'genres_exclude': "12,49,28,9,22",
      if (query != null && query.isNotEmpty) 'q': query,
      if (genreId != null) 'genres': genreId.toString(),
    };
    final uri = Uri.parse('$_baseUrl/manga').replace(queryParameters: params);

    try {
      final response = await http.get(uri);
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        final data = (responseBody['data'] as List<dynamic>?) ?? [];
        final mangaList = data
            .map((json) => Manga.fromJson(json as Map<String, dynamic>))
            .toList();

        return mangaList;
      } else {
        final errorMessage = responseBody['message'] as String;

        throw HttpException('${response.statusCode}: $errorMessage');
      }
    } catch (e, s) {
      log('Failed to fetch manga list.', error: e, stackTrace: s);
      return [];
    }
  }
}
