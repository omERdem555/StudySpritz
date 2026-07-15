import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

class AppSidebar extends StatelessWidget {
  const AppSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: Text(l10n.home),
            onTap: () => context.go('/'),
          ),
          ListTile(
            title: Text(l10n.library),
            onTap: () => context.go('/library'),
          ),
          ListTile(
            title: Text(l10n.favorites),
            onTap: () => context.go('/favorites'),
          ),
          ListTile(
            title: Text(l10n.bookmarks),
            onTap: () => context.go('/bookmarks'),
          ),
          ListTile(
            title: Text(l10n.settings),
            onTap: () => context.go('/settings'),
          ),
        ],
      ),
    );
  }
}