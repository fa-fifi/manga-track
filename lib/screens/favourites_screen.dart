import 'package:flutter/material.dart';
import 'package:mangatrack/models/library.dart';
import 'package:mangatrack/widgets/manga_card.dart';
import 'package:provider/provider.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen>
    with AutomaticKeepAliveClientMixin {
  // -------------------------------------------------------------------------
  // State
  // -------------------------------------------------------------------------

  List<dynamic> favourites = []; // to be populated by candidate

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: Consumer<Library>(
        builder: (context, library, child) {
          if (library.favouriteManga.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Icon(Icons.favorite_border_outlined, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'No favourites yet — start exploring!',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1 / 2,
              ),
              itemCount: library.favouriteManga.length,
              itemBuilder: (context, index) =>
                  MangaCard(library.favouriteManga[index]),
            );
          }
        },
      ),
    );
  }
}
