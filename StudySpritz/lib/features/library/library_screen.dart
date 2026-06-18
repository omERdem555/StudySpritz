import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/hive_service.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveService.booksBox.listenable(),
      builder: (context, box, _) {
        final books = box.values.toList();

        return Scaffold(
          appBar: AppBar(title: const Text("Library")),
          body: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              final progress = book.wordCount == 0
                  ? 0.0
                  : (book.wordIndex / book.wordCount)
                      .clamp(0.0, 1.0);

              return InkWell(
                onTap: () {
                  context.push('/reader', extra: book.bookId);
                },
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        const Expanded(
                          child: Icon(Icons.menu_book, size: 40),
                        ),
                        Text(
                          book.bookName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        IconButton(
                          icon: Icon(
                            book.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color:
                                book.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            BookRepository()
                                .toggleFavorite(book.bookId);
                          },
                        ),
                        LinearProgressIndicator(value: progress),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}