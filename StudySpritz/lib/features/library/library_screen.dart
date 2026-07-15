import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../l10n/app_localizations.dart';

import '../../core/services/hive_service.dart';
import '../../core/search/book_search_service.dart';
import '../../repositories/book_repository.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String _query = "";

  Future<void> _confirmAndDelete(
    BuildContext context,
    String bookId,
    String bookName,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.deleteBook),
          content: Text(
            l10n.libraryDeleteMessage(bookName),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.delete),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    await BookRepository().deleteBook(bookId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ValueListenableBuilder(
      valueListenable: HiveService.booksBox.listenable(),
      builder: (context, box, _) {
        final books = box.values.toList();
        final filtered = BookSearchService.filter(books, _query);

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.library),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      _query = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: l10n.searchBooks,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
            ),
          ),

          body: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final book = filtered[index];

              final progress = book.wordCount == 0
                  ? 0.0
                  : (book.wordIndex / book.wordCount).clamp(0.0, 1.0);

              return InkWell(
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
                onLongPress: () {
                  _confirmAndDelete(
                    context,
                    book.bookId,
                    book.bookName,
                  );
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
                            color: book.isFavorite ? Colors.red : null,
                          ),
                          onPressed: () {
                            BookRepository().toggleFavorite(book.bookId);
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