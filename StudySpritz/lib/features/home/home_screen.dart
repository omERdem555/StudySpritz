import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../l10n/app_localizations.dart';

import '../../core/services/hive_service.dart';
import '../../models/book.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/app_statistics_repository.dart';
import '../../models/app_statistics.dart';
import '../../core/services/book_creation_service.dart';
import '../goals/reading_goals_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Kitap silme onay diyalog motoru
  Future<void> _showDeleteDialog(BuildContext context, Book book) async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteBook),
        content: Text(
          l10n.deleteBookMessage(book.bookName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = BookRepository();
      await repo.deleteBook(book.bookId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.bookDeleted(book.bookName),
            ),
          )
        );
      }
    }
  }

  /// FAB Butonu tetikleyicisi - BookCreationService üzerinden kütüphaneye kitap ekler
  Future<void> _pickAndCreateBook(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final newBook = await BookCreationService.createBook();
      if (newBook != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.bookAdded(newBook.bookName),
            ),
          )
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.bookAddError(e.toString()),
            ),
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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

        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.dashboard),
          ),
          
          body: FutureBuilder<AppStatistics>(
            future: AppStatisticsRepository().get(),
            builder: (context, snapshot) {
              final stats = snapshot.data ?? AppStatistics.empty();

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionTitle(l10n.recentBooks),
                  const SizedBox(height: 10),

                  if (recent.isEmpty)
                    _EmptyCard(l10n.emptyLibrary)
                  else
                    _HorizontalBookList(
                      items: recent.take(10).toList(),
                      cardBuilder: (book) => _BookCard(
                        book: book,
                        onLongPress: () => _showDeleteDialog(context, book),
                      ),
                    ),

                  const SizedBox(height: 24),

                  _SectionTitle(l10n.favoriteBooks),
                  const SizedBox(height: 10),

                  if (favorites.isEmpty)
                    _EmptyCard(l10n.noFavorites)
                  else
                    _HorizontalBookList(
                      items: favorites,
                      cardBuilder: (book) => _BookCard(
                        book: book,
                        onLongPress: () => _showDeleteDialog(context, book),
                      ),
                    ),

                  const SizedBox(height: 24),

                  _SectionTitle(l10n.allBooks),
                  const SizedBox(height: 10),

                  if (books.isEmpty)
                    _EmptyCard(l10n.emptyLibrary)
                  else
                    _HorizontalBookList(
                      items: books,
                      cardBuilder: (book) => _BookCard(
                        book: book,
                        onLongPress: () => _showDeleteDialog(context, book),
                      ),
                    ),

                  const SizedBox(height: 24),

                  const ReadingGoalsCard(),

                  const SizedBox(height: 24),

                  _SectionTitle(l10n.statistics),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _StatItem(
                          value: stats.totalBooks.toString(),
                          label: l10n.book,
                        ),
                        const SizedBox(width: 12),
                        _StatItem(
                          value: stats.favoriteBooks.toString(),
                          label: l10n.favorite,
                        ),
                        const SizedBox(width: 12),
                        _StatItem(
                          value: stats.completedBooks.toString(),
                          label: l10n.completed,
                        ),
                        const SizedBox(width: 12),
                        _StatItem(
                          value: stats.totalSessions.toString(),
                          label: l10n.session,
                        ),
                        const SizedBox(width: 12),
                        _StatItem(
                          value: stats.totalReadingTime.toString(),
                          label: l10n.duration,
                        ),
                        const SizedBox(width: 12),
                        _StatItem(
                          value: stats.totalWordsRead.toString(),
                          label: l10n.words,
                        ),
                        const SizedBox(width: 12),
                        _StatItem(
                          value: stats.totalPagesRead.toString(),
                          label: l10n.page,
                        ),
                        const SizedBox(width: 12),
                        _StatItem(
                          value: stats.averageWpm.toStringAsFixed(1),
                          label: l10n.averageWpm,
                        ),
                        const SizedBox(width: 12),
                        _StatItem(
                          value: stats.peakWpm.toStringAsFixed(1),
                          label: l10n.peakWpm,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          
          // FAZ 10 - Sağ alttaki FAB Kitap Ekleme Butonu Kuruldu
          floatingActionButton: FloatingActionButton(
            onPressed: () => _pickAndCreateBook(context),
            tooltip: l10n.addBook,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}

/* ================= UI COMPONENTS ================= */

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Text(
      text,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
    );
  }
}

class _EmptyCard extends StatelessWidget {
  final String text;
  const _EmptyCard(this.text);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(text),
      ),
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
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 160,
            child: cardBuilder(items[index]),
          );
        },
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onLongPress; // VoidKey -> VoidCallback olarak düzeltildi

  const _BookCard({
    required this.book,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progress = book.wordCount == 0
        ? 0.0
        : (book.wordIndex / book.wordCount).clamp(0.0, 1.0);

    return Card(
      child: InkWell(
        onTap: () {
          context.push('/reader', extra: {
            "bookId": book.bookId,
            "wordIndex": book.wordIndex,
            "pageIndex": book.pageNumber,
          });
        },
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                // between -> spaceBetween olarak düzeltildi
                mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                children: [
                  const Icon(Icons.menu_book),
                  if (book.isFavorite)
                    const Icon(Icons.favorite, color: Colors.red, size: 18),
                ],
              ),
              const SizedBox(height: 8),
              Text(book.bookName,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
              const Spacer(),

              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                tween: Tween<double>(
                  end: progress,
                ),
                builder: (context, value, child) {
                  return LinearProgressIndicator(
                    value: value,
                  );
                },
              ),

              const SizedBox(height: 6),

              Text(
                "%${(progress * 100).toStringAsFixed(1)}",
              ),
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

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // Cihazın o anki karanlık mod durumunu kontrol ediyoruz
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 100, // Kutuların genişliği düzgün dursun diye sabitlenebilir
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // Karanlık moddaysa koyu gri, aydınlık moddaya açık gri yapar
        color: isDarkMode ? Color.fromRGBO(38, 36, 41, 1) : Color.fromRGBO(243, 236, 244, 1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Color.fromRGBO(22, 21, 23, 1) : Color.fromRGBO(225, 218, 226, 1),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              // Karanlık modda beyaz yazı, aydınlık modda siyah yazı
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              // Karanlık modda açık gri yazı, aydınlık modda koyu gri yazı
              color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}