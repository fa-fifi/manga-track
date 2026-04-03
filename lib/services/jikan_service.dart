import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mangatrack/models/genre.dart';

/// Thin wrapper around the Jikan v4 API.
/// Methods return the full decoded JSON response map.
/// Exceptions are NOT caught — let them propagate so the caller can handle them.
class JikanService {
  static const String _baseUrl = 'https://api.jikan.moe/v4';

  /// GET /genres/manga
  /// Returns the full decoded response map, e.g. `{ "data": [...] }`.
  static Future<List<Genre>> fetchGenres() async {
    final response = await http.get(Uri.parse('$_baseUrl/genres/manga'));

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (responseBody['data'] as List<dynamic>?) ?? [];
      final genres = data
          .map((json) => Genre.fromJson(json as Map<String, dynamic>))
          .toList();

      return genres;
    } else {
      throw Exception('Failed to fetch manga genres.');
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
  static Future<Map<String, dynamic>> fetchManga({
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
    };
    if (query != null && query.isNotEmpty) params['q'] = query;
    if (genreId != null) params['genres'] = genreId.toString();

    final uri = Uri.parse('$_baseUrl/manga').replace(queryParameters: params);
    final response = await http.get(uri);
    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
