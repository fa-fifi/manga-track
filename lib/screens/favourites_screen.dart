import 'package:flutter/material.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  // -------------------------------------------------------------------------
  // State
  // -------------------------------------------------------------------------

  List<dynamic> favourites = []; // to be populated by candidate

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favourites')),
      body: const Center(
        // TODO: replace with actual favourites list
        child: Text('Your favourite manga will be shown here.'),
      ),
    );
  }
}
