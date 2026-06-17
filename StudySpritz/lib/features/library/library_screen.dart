import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/book_repository.dart';
import '../../models/book.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Library")),
      body: FutureBuilder<List<Book>>(
        future: BookRepository().getAllBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!;
          if (books.isEmpty) {
            return const Center(child: Text("No books"));
          }

          return GridView.builder(
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
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Center(
                            child: Icon(Icons.menu_book, size: 40),
                          ),
                        ),
                        Text(
                          book.bookName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: progress),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}