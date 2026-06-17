import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../repositories/book_repository.dart';
import '../../models/book.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: BookRepository().getAllBooks(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final books = snapshot.data!;

        if (books.isEmpty) {
          return const Center(child: Text("No books"));
        }

        return ListView.builder(
          itemCount: books.length,
          itemBuilder: (context, index) {
            final book = books[index];

            return ListTile(
              title: Text(book.bookName),
              subtitle: Text(book.filePath),
              onTap: () {
                context.push('/reader/${book.bookId}');
              },
            );
          },
        );
      },
    );
  }
}