import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/browse_screen.dart';
import 'screens/discover_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/image_viewer_screen.dart';

// ---------------------------------------------------------------------------
// Router
// ---------------------------------------------------------------------------

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainShell()),
    GoRoute(
      path: '/viewer',
      builder: (context, state) {
        final imageUrl = state.extra as String;
        return ImageViewerScreen(imageUrl: imageUrl);
      },
    ),
  ],
);

// ---------------------------------------------------------------------------
// App root
// ---------------------------------------------------------------------------

void main() => runApp(const MangaTrackApp());

class MangaTrackApp extends StatelessWidget {
  const MangaTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MangaTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

// ---------------------------------------------------------------------------
// Bottom-nav shell
// ---------------------------------------------------------------------------

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late final _pageController = PageController(initialPage: _currentIndex);
  int _currentIndex = 0;

  static const List<Widget> _screens = [
    DiscoverScreen(),
    FavouritesScreen(),
    BrowseScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
          _pageController.jumpToPage(index);
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined),
            activeIcon: Icon(Icons.explore),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            activeIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            activeIcon: Icon(Icons.menu_book),
            label: 'Browse',
          ),
        ],
      ),
    );
  }
}
