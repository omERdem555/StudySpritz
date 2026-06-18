import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../models/book.dart';
import '../../repositories/book_repository.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
      ),
      body: FutureBuilder<List<Book>>(
        future: BookRepository().getAllBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final favorites = snapshot.data!
              .where((b) => b.isFavorite)
              .toList();

          if (favorites.isEmpty) {
            return const Center(
              child: Text("No favorite books"),
            );
          }

          return ListView.builder(
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final book = favorites[index];

              return ListTile(
                leading: const Icon(Icons.favorite),
                title: Text(book.bookName),
                onTap: () {
                  context.push(
                    '/reader',
                    extra: book.bookId,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}