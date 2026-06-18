import 'package:go_router/go_router.dart';

import '../../features/home/home_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/bookmarks/bookmarks_screen.dart';
import '../../features/settings/settings_screen.dart';
import '../../features/reader/reader_screen.dart';

import 'package:studyspritz/core/layout/app_layout.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',

    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppLayout(child: child);
        },

        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),

          GoRoute(
            path: '/library',
            builder: (context, state) => const LibraryScreen(),
          ),

          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),

          GoRoute(
            path: '/bookmarks',
            builder: (context, state) => const BookmarksScreen(),
          ),

          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),

          GoRoute(
            path: '/reader',
            builder: (context, state) {
              final extra = state.extra as Map;

              return ReaderScreen(extra: extra);
            },
          ),
        ],
      ),
    ],
  );
}