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

        return Scaffold(
          body: ListView(
            children: books.map((book) {
              return ListTile(
                title: Text(book.bookName),
                onTap: () {
                  context.push('/reader', extra: book.bookId);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}