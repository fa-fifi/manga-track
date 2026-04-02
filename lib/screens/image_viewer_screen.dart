import 'package:flutter/material.dart';

/// Full-screen image viewer.
///
/// Receives an image URL via [GoRouterState.extra] (a plain [String]).
/// Navigate here with:
///   context.go('/viewer', extra: 'https://...');
class ImageViewerScreen extends StatelessWidget {
  final String imageUrl;

  const ImageViewerScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Image.asset(
              imageUrl,
              // Use the fixed tall placeholder
              errorBuilder: (context, error, stackTrace) => SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
