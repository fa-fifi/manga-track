import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mangatrack/models/genre.dart';
import 'package:mangatrack/models/manga.dart';
import 'package:mangatrack/widgets/manga_card.dart';

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
  Map<Genre, List<Manga>> groupedByGenre = {};
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
          for (final genre in genres) {
            // TODO: Group by  genre
            for (final manga in mangaList) {
              groupedByGenre.update(
                genre,
                (value) => [...value, manga],
                ifAbsent: () => [manga],
              );
            }
          }

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
      // TODO: build two-panel genre browser layout (can refer to ZUS coffee app for inspiration)
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: groupedByGenre.length,
                      itemBuilder: (context, index) {
                        final genre = groupedByGenre.keys.elementAt(index);

                        return Text(genre.name);
                      },
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ListView.builder(
                      itemCount: groupedByGenre.length,
                      itemBuilder: (context, index) {
                        final genre = groupedByGenre.keys.elementAt(index);
                        final mangaList = groupedByGenre.entries
                            .elementAt(index)
                            .value;

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              color: Theme.of(context).primaryColorLight,
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              margin: EdgeInsets.only(bottom: 10),
                              child: Text('${genre.id}. ${genre.name}'),
                            ),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1 / 2,
                                  ),
                              itemCount: mangaList.length,
                              itemBuilder: (context, index) =>
                                  MangaCard(mangaList[index]),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
