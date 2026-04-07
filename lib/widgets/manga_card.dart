import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangatrack/models/favourites.dart';
import 'package:mangatrack/models/manga.dart';
import 'package:provider/provider.dart';

class MangaCard extends StatelessWidget {
  const MangaCard(this.manga, {super.key});

  final Manga manga;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: InkWell(
          onTap: () => context.push(
            '/viewer',
            extra:
                'assets/images/placeholder.jpg', // Continue uses the tall placeholder image for actual implementation for full image page
          ),
          child: Stack(
            alignment: AlignmentGeometry.topEnd,
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(manga.thumbnail),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              IconButton.filled(
                onPressed: () => context.read<Favourites>().toggleManga(manga),
                icon: Icon(Icons.favorite),
                style: IconButton.styleFrom(
                  foregroundColor:
                      context.watch<Favourites>().mangaList.contains(manga)
                      ? Colors.pink
                      : Colors.white54,
                  backgroundColor: Colors.black26,
                ),
              ),
            ],
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
}
