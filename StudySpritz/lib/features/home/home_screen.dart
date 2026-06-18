import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/hive_service.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveService.booksBox.listenable(),
      builder: (context, box, _) {
        final books = box.values.toList();

        final recent = books.toList()
          ..sort((a, b) {
            final scoreA =
                a.lastOpenedAt.millisecondsSinceEpoch + a.wordIndex;
            final scoreB =
                b.lastOpenedAt.millisecondsSinceEpoch + b.wordIndex;
            return scoreB.compareTo(scoreA);
          });

        final favorites =
            books.where((b) => b.isFavorite).toList();

        final completed =
            books.where((b) => b.isCompleted).length;

        return Scaffold(
          appBar: AppBar(title: const Text("Dashboard")),
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

              const SizedBox(height: 24),

              _SectionTitle("İstatistiklerim"),
              const SizedBox(height: 8),

              SizedBox(
                height: 110,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _StatItem(
                      value: books.length.toString(),
                      label: "Toplam",
                    ),
                    const SizedBox(width: 12),
                    _StatItem(
                      value: favorites.length.toString(),
                      label: "Favori",
                    ),
                    const SizedBox(width: 12),
                    _StatItem(
                      value: completed.toString(),
                      label: "Tamamlanan",
                    ),
                  ],
                ),
              ),
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
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
        onTap: () {
          context.push('/reader', extra: book.bookId);
        },
        trailing: Icon(
          book.isFavorite
              ? Icons.favorite
              : Icons.favorite_border,
          color: book.isFavorite ? Colors.red : null,
        ),
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

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade200,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(label),
        ],
      ),
    );
  }
}