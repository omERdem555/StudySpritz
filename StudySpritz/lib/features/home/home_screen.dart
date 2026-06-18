import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:file_picker/file_picker.dart';

import '../../core/services/hive_service.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const double _cardWidth = 160;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: HiveService.booksBox.listenable(),
      builder: (context, box, _) {
        final books = box.values.toList();

        final recent = books.toList()
          ..sort((a, b) =>
              (b.lastOpenedAt.millisecondsSinceEpoch + b.wordIndex)
                  .compareTo(a.lastOpenedAt.millisecondsSinceEpoch + a.wordIndex));

        final favorites = books.where((b) => b.isFavorite).toList();
        final completed = books.where((b) => b.isCompleted).length;

        final recentBookmarks = HiveService.bookmarksBox.values.toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

        return Scaffold(
          appBar: AppBar(
            title: const Text("Dashboard"),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final result = await FilePicker.platform.pickFiles();
                  if (result == null || result.files.single.path == null) return;

                  final file = result.files.single;

                  final repo = BookRepository();

                  final book = Book(
                    bookId: DateTime.now().millisecondsSinceEpoch.toString(),
                    bookName: file.name,
                    filePath: file.path!,
                    fileType: file.extension ?? "txt",
                    pageCount: 0,
                    wordCount: 0,
                    pageNumber: 0,
                    wordIndex: 0,
                    isFavorite: false,
                    isCompleted: false,
                    addedAt: DateTime.now(),
                    lastOpenedAt: DateTime.now(),
                    completedAt: null,
                  );

                  await repo.addBook(book);
                },
              ),
            ],
          ),

          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionTitle("Son Okunanlar"),
              const SizedBox(height: 10),
              _HorizontalBookList(
                items: recent.take(10).toList(),
                cardBuilder: (book) => _BookCard(book: book),
              ),

              const SizedBox(height: 24),

              _SectionTitle("Favoriler"),
              const SizedBox(height: 10),
              _HorizontalBookList(
                items: favorites,
                cardBuilder: (book) => _BookCard(book: book),
              ),

              const SizedBox(height: 24),

              _SectionTitle("Tüm Kitaplar"),
              const SizedBox(height: 10),
              _HorizontalBookList(
                items: books,
                cardBuilder: (book) => _BookCard(book: book),
              ),

              const SizedBox(height: 24),

              _SectionTitle("Son Yer İmleri"),
              const SizedBox(height: 10),

              if (recentBookmarks.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text("Henüz yer imi yok"),
                  ),
                )
              else
                _HorizontalBookmarkList(
                  items: recentBookmarks.take(10).toList(),
                ),

              const SizedBox(height: 24),

              _SectionTitle("İstatistiklerim"),
              const SizedBox(height: 10),

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

class _HorizontalBookList extends StatelessWidget {
  final List<Book> items;
  final Widget Function(Book) cardBuilder;

  const _HorizontalBookList({
    required this.items,
    required this.cardBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: HomeScreen._cardWidth,
            child: cardBuilder(items[index]),
          );
        },
      ),
    );
  }
}

class _HorizontalBookmarkList extends StatelessWidget {
  final List<dynamic> items;

  const _HorizontalBookmarkList({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final bookmark = items[index];

          return SizedBox(
            width: 180,
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(8),
                leading: const Icon(Icons.bookmark),
                title: Text(
                  bookmark.markNote.isEmpty
                      ? "Page ${bookmark.pageNumber}"
                      : bookmark.markNote,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("Page ${bookmark.pageNumber}"),
                onTap: () {
                  context.push(
                    '/reader',
                    extra: {
                      "bookId": bookmark.bookId,
                      "wordIndex": bookmark.wordIndex,
                      "pageIndex": bookmark.pageNumber,
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
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
      child: InkWell(
        onTap: () {
          context.push(
            '/reader',
            extra: {
              "bookId": book.bookId,
              "wordIndex": book.wordIndex,
              "pageIndex": book.pageNumber,
            },
          );
        },
        onLongPress: () async {
          final shouldDelete = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Delete Book"),
                content: Text("Delete '${book.bookName}' ?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Delete"),
                  ),
                ],
              );
            },
          );

          if (shouldDelete != true) return;

          await BookRepository().deleteBook(book.bookId);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.menu_book, size: 36),
              const SizedBox(height: 8),
              Text(
                book.bookName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 6),
              Text("${(progress * 100).toStringAsFixed(1)}%"),
            ],
          ),
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