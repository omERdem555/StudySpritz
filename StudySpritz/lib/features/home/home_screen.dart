import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/services/hive_service.dart';
import '../../models/book.dart';
import '../../models/reading_statistics.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/statistics_repository.dart';
import '../../core/services/book_creation_service.dart'; // Servis entegrasyonu için eklendi

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  /// Kitap silme onay diyalog motoru
  Future<void> _showDeleteDialog(BuildContext context, Book book) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Kitabı Sil"),
        content: Text('"${book.bookName}" kütüphanenizden ve tüm ilerleme geçmişinizden silinecektir. Emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Vazgeç"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Sil"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = BookRepository();
      await repo.deleteBook(book.bookId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${book.bookName}" başarıyla silindi.')),
        );
      }
    }
  }

  /// FAB Butonu tetikleyicisi - BookCreationService üzerinden kütüphaneye kitap ekler
  Future<void> _pickAndCreateBook(BuildContext context) async {
    try {
      final newBook = await BookCreationService.createBook();
      if (newBook != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('"${newBook.bookName}" kütüphaneye eklendi.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kitap eklenirken hata oluştu: $e')),
        );
      }
    }
  }

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

        return Scaffold(
          appBar: AppBar(title: const Text("Dashboard")),
          
          body: FutureBuilder<List<ReadingStatistics>>(
            future: StatisticsRepository().getAll(),
            builder: (context, snapshot) {
              final statsList = snapshot.data ?? [];

              final validStats =
                  statsList.where((s) => s.sessionCount > 0).toList();

              final totalReadingTime =
                  validStats.fold<int>(0, (s, e) => s + e.totalReadingTime);

              final totalWords =
                  validStats.fold<int>(0, (s, e) => s + e.totalWordsRead);

              final totalPages =
                  validStats.fold<int>(0, (s, e) => s + e.totalPagesRead);

              final avgWpm = validStats.isEmpty
                  ? 0.0
                  : validStats.fold<double>(0.0, (s, e) => s + e.averageWpm) /
                      validStats.length;

              final peakWpm = statsList.isEmpty
                  ? 0.0
                  : statsList
                      .map((e) => e.peakWpm)
                      .reduce((a, b) => a > b ? a : b);

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SectionTitle("Son Okunanlar"),
                  const SizedBox(height: 10),

                  if (recent.isEmpty)
                    const _EmptyCard("Kütüphane boş")
                  else
                    _HorizontalBookList(
                      items: recent.take(10).toList(),
                      cardBuilder: (book) => _BookCard(
                        book: book,
                        onLongPress: () => _showDeleteDialog(context, book),
                      ),
                    ),

                  const SizedBox(height: 24),

                  _SectionTitle("Favoriler"),
                  const SizedBox(height: 10),

                  if (favorites.isEmpty)
                    const _EmptyCard("Henüz favori yok")
                  else
                    _HorizontalBookList(
                      items: favorites,
                      cardBuilder: (book) => _BookCard(
                        book: book,
                        onLongPress: () => _showDeleteDialog(context, book),
                      ),
                    ),

                  const SizedBox(height: 24),

                  _SectionTitle("Tüm Kitaplar"),
                  const SizedBox(height: 10),

                  if (books.isEmpty)
                    const _EmptyCard("Kütüphane boş")
                  else
                    _HorizontalBookList(
                      items: books,
                      cardBuilder: (book) => _BookCard(
                        book: book,
                        onLongPress: () => _showDeleteDialog(context, book),
                      ),
                    ),

                  const SizedBox(height: 24),

                  _SectionTitle("İstatistikler"),
                  const SizedBox(height: 10),

                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _StatItem(value: books.length.toString(), label: "Kitap"),
                        const SizedBox(width: 12),
                        _StatItem(value: favorites.length.toString(), label: "Favori"),
                        const SizedBox(width: 12),
                        _StatItem(value: completed.toString(), label: "Tamamlanan"),
                        const SizedBox(width: 12),
                        _StatItem(value: validStats.length.toString(), label: "Oturum"),
                        const SizedBox(width: 12),
                        _StatItem(value: totalReadingTime.toString(), label: "Süre"),
                        const SizedBox(width: 12),
                        _StatItem(value: totalWords.toString(), label: "Kelime"),
                        const SizedBox(width: 12),
                        _StatItem(value: totalPages.toString(), label: "Sayfa"),
                        const SizedBox(width: 12),
                        _StatItem(
                          value: avgWpm.toStringAsFixed(1),
                          label: "Avg WPM",
                        ),
                        const SizedBox(width: 12),
                        _StatItem(
                          value: peakWpm.toStringAsFixed(1),
                          label: "Peak WPM",
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
            tooltip: "Yeni Kitap Ekle",
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
              LinearProgressIndicator(value: progress),
              const SizedBox(height: 6),
              Text("%${(progress * 100).toStringAsFixed(1)}"),
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
    // Cihazın o anki karanlık mod durumunu kontrol ediyoruz
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 100, // Kutuların genişliği düzgün dursun diye sabitlenebilir
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // Karanlık moddaysa koyu gri, aydınlık moddaya açık gri yapar
        color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
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