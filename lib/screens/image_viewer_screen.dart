import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: IconButton.filled(
              onPressed: () => context.pop(),
              icon: Icon(Icons.close),
              style: FilledButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black26,
              ),
            ),
          ),
        ],
      ),
      body: InteractiveViewer(
        child: SingleChildScrollView(
          child: Image.asset(
            imageUrl,
            // Use the fixed tall placeholder
            errorBuilder: (context, error, stackTrace) => SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const Center(
                child: Icon(Icons.broken_image, color: Colors.white, size: 64),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
