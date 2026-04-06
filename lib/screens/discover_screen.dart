import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangatrack/models/genre.dart';
import 'package:mangatrack/models/manga.dart';

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
  static const _kSampleGenres = <Genre>[
    Genre(id: 1, name: 'Action'),
    Genre(id: 2, name: 'Adventure'),
    Genre(id: 4, name: 'Comedy'),
    Genre(id: 8, name: 'Drama'),
    Genre(id: 10, name: 'Fantasy'),
    Genre(id: 14, name: 'Horror'),
    Genre(id: 22, name: 'Romance'),
    Genre(id: 36, name: 'Slice of Life'),
  ];
  final searchController = TextEditingController();
  final minLimit = 20; // min no. of manga loaded per search
  var genres = <Genre>[]; // populated from /manga/genres on init
  var mangaList = <Manga>[]; // populated from /manga on init
  var isLoading = false;
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
    genres = await JikanService.getMangaGenres();
    debugPrint('[Discover] Genres loaded: ${genres.length}');

    // 2. Fetch first page of manga
    mangaList = await JikanService.getMangaSearch(limit: minLimit);
    debugPrint('[Discover] Manga loaded: ${mangaList.length}');

    setState(() => isLoading = false);
  }

  Future<void> _loadManga() async {
    setState(() => isLoading = true);

    final result = await JikanService.getMangaSearch(
      query: searchController.text,
      genreId: selectedGenreId,
      page: currentPage,
      limit: minLimit,
    );
    currentPage > 1 ? mangaList.addAll(result) : mangaList = result;
    debugPrint('[Discover] Manga loaded: ${mangaList.length}');

    setState(() => isLoading = false);
  }

  void _onSearchChanged() async {
    // TODO: trigger a new fetch with the updated search query
    currentPage = 1;
    _loadManga();
  }

  void _onGenreChanged(int? genreId) async {
    // TODO: make changes accordingly
    selectedGenreId = genreId;
    currentPage = 1;
    _loadManga();
  }

  void _loadMoreManga() async {
    currentPage = currentPage + 1;
    _loadManga();
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
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search manga...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => _onSearchChanged(),
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
                  ...(genres.isNotEmpty ? genres : _kSampleGenres).map(
                    (genre) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(genre.name),
                        selected: selectedGenreId == genre.id,
                        onSelected: (_) => _onGenreChanged(
                          selectedGenreId == genre.id ? null : genre.id,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // TODO: render manga list
            if (mangaList.isNotEmpty)
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1 / 2,
                  ),
                  itemCount: mangaList.length + 1,
                  itemBuilder: (context, index) {
                    if (index < mangaList.length) {
                      final manga = mangaList[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(manga.thumbnail),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            manga.title,
                            style: Theme.of(context).textTheme.titleMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    } else {
                      // extra item will request next page & rebuild widget
                      if (isLoading == false) {
                        Future.delayed(Duration.zero, () => _loadMoreManga());
                      }

                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              )
            else
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_stories_outlined, size: 48),
                    const SizedBox(height: 16),
                    const Text('No manga found.'),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
