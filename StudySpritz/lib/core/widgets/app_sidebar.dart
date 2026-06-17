import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text("Home"),
            onTap: () => context.go('/'),
          ),
          ListTile(
            title: const Text("Library"),
            onTap: () => context.go('/library'),
          ),
          ListTile(
            title: const Text("Favorites"),
            onTap: () => context.go('/favorites'),
          ),
          ListTile(
            title: const Text("Bookmarks"),
            onTap: () => context.go('/bookmarks'),
          ),
          ListTile(
            title: const Text("Settings"),
            onTap: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }
}