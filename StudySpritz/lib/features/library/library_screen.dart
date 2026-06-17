import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/book_repository.dart';
import '../../models/book.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Library"),
      ),
      body: FutureBuilder<List<Book>>(
        future: BookRepository().getAllBooks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final books = snapshot.data!;

          if (books.isEmpty) {
            return const Center(
              child: Text("No books"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];

              final progress =
                  book.wordCount == 0
                      ? 0.0
                      : book.wordIndex / book.wordCount;

              return Card(
                child: ListTile(
                  title: Text(book.bookName),
                  subtitle: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(book.fileType),

                      const SizedBox(height: 8),

                      LinearProgressIndicator(
                        value: progress.clamp(0.0, 1.0),
                      ),
                    ],
                  ),
                  onTap: () {
                    context.push(
                      '/reader',
                      extra: book.bookId,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}