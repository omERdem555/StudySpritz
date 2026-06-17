import 'package:flutter/material.dart';
import '../../repositories/book_repository.dart';
import '../../models/book.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Book>> booksFuture;

  @override
  void initState() {
    super.initState();
    booksFuture = BookRepository().getAllBooks();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: booksFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final books = snapshot.data!;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text("Dashboard", style: TextStyle(fontSize: 22)),

            const SizedBox(height: 20),

            const Text("Son Eklenenler"),
            ...books.take(3).map((b) => Text(b.bookName)),

            const SizedBox(height: 20),

            const Text("Tüm Kitaplar"),
            ...books.map((b) => Text(b.bookName)),
          ],
        );
      },
    );
  }
}