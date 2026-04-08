import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mangatrack/models/manga.dart';

class Library with ChangeNotifier {
  final _favouriteManga = <Manga>[];

  UnmodifiableListView<Manga> get favouriteManga =>
      UnmodifiableListView(_favouriteManga);

  void addFavouriteManga(Manga manga) {
    _favouriteManga.add(manga);
    notifyListeners();
  }

  void removeFavouriteManga(Manga manga) {
    _favouriteManga.remove(manga);
    notifyListeners();
  }

  void toggleFavouriteManga(Manga manga) => _favouriteManga.contains(manga)
      ? removeFavouriteManga(manga)
      : addFavouriteManga(manga);
}
