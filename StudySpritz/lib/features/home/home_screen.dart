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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final books = snapshot.data!;

        final recent = books.toList()
          ..sort((a, b) {
            final scoreA = a.lastOpenedAt.millisecondsSinceEpoch + a.wordIndex;
            final scoreB = b.lastOpenedAt.millisecondsSinceEpoch + b.wordIndex;
            return scoreB.compareTo(scoreA);
          });

        final favorites = books.where((b) => b.isFavorite).toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text("Dashboard"),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionTitle("Son Okunanlar"),
              const SizedBox(height: 8),
              ...recent.take(5).map((b) => _BookCard(book: b)),

              const SizedBox(height: 24),

              _SectionTitle("Favoriler"),
              const SizedBox(height: 8),
              ...favorites.map((b) => _BookCard(book: b)),

              const SizedBox(height: 24),

              _SectionTitle("Tüm Kitaplar"),
              const SizedBox(height: 8),
              ...books.map((b) => _BookCard(book: b)),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  const _BookCard({required this.book});

  @override
  Widget build(BuildContext context) {
    final progress = book.wordCount == 0
        ? 0.0
        : (book.wordIndex / book.wordCount).clamp(0.0, 1.0);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        title: Text(book.bookName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            LinearProgressIndicator(value: progress),
            const SizedBox(height: 6),
            Text("${(progress * 100).toStringAsFixed(1)}%"),
          ],
        ),
      ),
    );
  }
}