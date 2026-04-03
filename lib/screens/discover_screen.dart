import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../services/jikan_service.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with AutomaticKeepAliveClientMixin {
  // -------------------------------------------------------------------------
  // Hardcoded sample genres
  // -------------------------------------------------------------------------

  // TODO: replace with live genres from API once they're loaded

  static const List<Map<String, dynamic>> _kSampleGenres = [
    {'mal_id': 1, 'name': 'Action'},
    {'mal_id': 2, 'name': 'Adventure'},
    {'mal_id': 4, 'name': 'Comedy'},
    {'mal_id': 8, 'name': 'Drama'},
    {'mal_id': 10, 'name': 'Fantasy'},
    {'mal_id': 14, 'name': 'Horror'},
    {'mal_id': 22, 'name': 'Romance'},
    {'mal_id': 36, 'name': 'Slice of Life'},
  ];

  List<dynamic> genres = []; // populated from /manga/genres on init
  List<dynamic> mangaList = []; // populated from /manga on init
  bool isLoading = false;
  String searchQuery = '';
  int? selectedGenreId;
  int currentPage = 1;
  bool hasReachedEnd = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() => isLoading = true);

    // 1. Fetch genres
    final genreData = await JikanService.fetchGenres();
    setState(() => genres = (genreData['data'] as List<dynamic>?) ?? []);
    debugPrint('[Discover] Genres loaded: ${genres.length}');

    // 2. Fetch first page of manga
    final mangaData = await JikanService.fetchManga(page: 1, limit: 20);
    setState(() {
      mangaList = (mangaData['data'] as List<dynamic>?) ?? [];
      isLoading = false;
    });
    debugPrint('[Discover] Manga loaded: ${mangaList.length}');
  }

  void _onSearchChanged(String query) {
    searchQuery = query;
    // TODO: trigger a new fetch with the updated search query
  }

  void _onGenreChanged(int? genreId) {
    // TODO: make changes accordingly
    _fetchFilteredWithGenre(selectedGenreId);
    setState(() => selectedGenreId = genreId);
  }

  Future<void> _fetchFilteredWithGenre(int? genreId) async {
    setState(() => isLoading = true);
    // TODO: trigger a fetch with the genreId
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Discover')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),

            // Search field
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search manga...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _onSearchChanged,
            ),

            const SizedBox(height: 8),

            // Genre filter pills — uses hardcoded _kSampleGenres until the API
            // genres arrive, then switches to the live list.
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: const Text('All'),
                      selected: selectedGenreId == null,
                      onSelected: (_) => _onGenreChanged(null),
                    ),
                  ),
                  ...(genres.isNotEmpty ? genres : _kSampleGenres).map((g) {
                    final id = g['mal_id'] as int;
                    final name = g['name'] as String;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(name),
                        selected: selectedGenreId == id,
                        onSelected: (_) =>
                            _onGenreChanged(selectedGenreId == id ? null : id),
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // TODO: render manga list
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Manga list will appear here'),
                    const SizedBox(height: 16),

                    // Stub: remove once list is implemented
                    GestureDetector(
                      onTap: () => context.go(
                        '/viewer',
                        extra:
                            'assets/images/placeholder.jpg', // Continue uses the tall placeholder image for actual implementation for full image page
                      ),
                      child: const Text(
                        'Tap to test image viewer →',
                        style: TextStyle(
                          color: Colors.indigo,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
