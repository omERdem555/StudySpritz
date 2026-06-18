import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/hive_service.dart';
import '../../models/book.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveService.booksBox.listenable(),
      builder: (context, box, _) {
        final books = box.values.toList();

        final favorites =
            books.where((b) => b.isFavorite).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Favorites"),
          ),
          body: favorites.isEmpty
              ? const Center(child: Text("No favorite books"))
              : ListView.builder(
                  itemCount: favorites.length,
                  itemBuilder: (context, index) {
                    final book = favorites[index];

                    return ListTile(
                      leading: const Icon(Icons.favorite),
                      title: Text(book.bookName),

                      onTap: () {
                        context.push(
                          '/reader',
                          extra: {
                            "bookId": book.bookId,
                          },
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}