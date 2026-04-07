import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:mangatrack/models/manga.dart';

class Favourites with ChangeNotifier {
  final List<Manga> _mangaList = [];
  UnmodifiableListView<Manga> get mangaList => UnmodifiableListView(_mangaList);

  void addManga(Manga manga) {
    _mangaList.add(manga);
    notifyListeners();
  }

  void removeManga(Manga manga) {
    _mangaList.remove(manga);
    notifyListeners();
  }

  void toggleManga(Manga manga) =>
      _mangaList.contains(manga) ? removeManga(manga) : addManga(manga);
}
