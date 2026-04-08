import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangatrack/models/genre.dart';
import 'package:mangatrack/models/manga.dart';

import '../services/jikan_service.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen>
    with AutomaticKeepAliveClientMixin {
  var genres = <Genre>[];
  var mangaList = <Manga>[];
  Map<String, List<dynamic>> groupedByGenre = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBrowseData();
  }

  Future<void> _fetchBrowseData() async {
    // 1. Fetch genres
    genres = await JikanService.getMangaGenres();
    debugPrint('[Browse] Genres loaded: ${genres.length}');

    // 2. Fetch manga pages
    Timer.periodic(Duration(milliseconds: 500), (timer) async {
      if (timer.tick < 5) {
        final searchResult = await JikanService.getMangaSearch(
          page: timer.tick,
        );
        debugPrint("Function executed at tick: ${timer.tick}");

        mangaList.addAll(searchResult.$1);

        // Stop the interval after 4 executions
        if (timer.tick == 4) timer.cancel();

        if (mangaList.length >= 100) {
          debugPrint('[Browse] Manga loaded: ${mangaList.length}');

          // TODO: filter genres to only those with manga, and fetch more pages if needed to get a good sample of manga for each genre

          // TODO: Group by  genre
          groupedByGenre = {};

          setState(() => isLoading = false);
        }
      }
    });
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
      appBar: AppBar(title: const Text('Browse')),
      body: const Center(
        // TODO: build two-panel genre browser layout (can refer to ZUS coffee app for inspiration)
        child: Text('Genre browser will appear here.'),
      ),
    );
  }
}
