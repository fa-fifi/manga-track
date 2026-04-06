import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mangatrack/models/manga.dart';

class MangaCard extends StatelessWidget {
  const MangaCard(this.manga, {super.key});

  final Manga manga;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: InkWell(
          onTap: () => context.go(
            '/viewer',
            extra:
                'assets/images/placeholder.jpg', // Continue uses the tall placeholder image for actual implementation for full image page
          ),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(manga.thumbnail),
                fit: BoxFit.cover,
              ),
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
}
