import 'package:flutter/material.dart';

import '../services/jikan_service.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  List<dynamic> genres = [];
  List<dynamic> mangaList = [];
  Map<String, List<dynamic>> groupedByGenre = {};
  bool isBrowseLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBrowseData();
  }

  Future<void> _fetchBrowseData() async {
    // 1. Fetch genres
    final genreResponse = await JikanService.fetchGenres();
    setState(() {
      genres = (genreResponse['data'] as List<dynamic>?) ?? [];
    });

    // 2. Fetch manga pages
    List<dynamic> allManga = [];

    final res = await JikanService.fetchManga(page: 1, limit: 100);
    final pageData = (res['data'] as List<dynamic>?) ?? [];
    allManga.addAll(pageData);

    // TODO: filter genres to only those with manga, and fetch more pages if needed to get a good sample of manga for each genre

    // TODO: Group by  genre

    setState(() {
      mangaList = allManga;
      groupedByGenre = {};
      isBrowseLoading = false;
    });

    debugPrint('[Browse] Manga loaded: ${mangaList.length}');
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Browse')),
      body: const Center(
        // TODO: build two-panel genre browser layout (can refer to ZUS coffee app for inspiration)
        child: Text('Genre browser will appear here.'),
      ),
    );
  }
}
