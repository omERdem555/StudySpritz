import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../models/book.dart';
import '../../models/reading_statistics.dart';
import '../../repositories/book_repository.dart';
import '../../repositories/statistics_repository.dart';

class ReadingStatisticsScreen extends StatelessWidget {
  final String bookId;

  const ReadingStatisticsScreen({
    super.key,
    required this.bookId,
  });

  String _formatDuration(int seconds) {
    if (seconds <= 0) {
      return "0 dk";
    }

    final duration = Duration(seconds: seconds);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours == 0) {
      return "$minutes dk";
    }

    if (minutes == 0) {
      return "$hours saat";
    }

    return "$hours saat $minutes dk";
  }

  String _formatNumber(int value) {
    return NumberFormat.decimalPattern('tr_TR').format(value);
  }

  String _formatDate(DateTime date) {
    return DateFormat("d MMMM y", "tr_TR").format(date);
  }

  String _formatProgress(Book book) {
  if (book.wordCount <= 0) {
    return "%0";
  }

  final progress =
      (book.wordIndex / book.wordCount * 100).clamp(0, 100);

  return "%${progress.toStringAsFixed(1)}";
}

  Widget _statCard({
    required BuildContext context,
    required String title,
    required String value,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _sectionTitle(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final statisticsRepository = StatisticsRepository();
    final bookRepository = BookRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Okuma İstatistikleri"),
      ),
      body: FutureBuilder(
        future: Future.wait([
          bookRepository.getBook(bookId),
          statisticsRepository.getByBookId(bookId),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final book = snapshot.data![0] as Book?;
          final stats = snapshot.data![1] as ReadingStatistics?;

          if (book == null) {
            return const Center(
              child: Text("Kitap bulunamadı."),
            );
          }

          if (stats == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.bar_chart,
                      size: 72,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      book.bookName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Henüz bu kitap için herhangi bir okuma istatistiği oluşmadı.",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                book.bookName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Divider(thickness: 1.4),

              _sectionTitle(
                context,
                "Kitap Bilgileri",
                Icons.menu_book,
              ),

              _statCard(
                context: context,
                title: "Dosya",
                value: book.fileType.toUpperCase(),
              ),

              _statCard(
                context: context,
                title: "Eklenme",
                value: _formatDate(book.addedAt),
              ),

              _statCard(
                context: context,
                title: "Son Açılış",
                value: _formatDate(book.lastOpenedAt),
              ),

              _statCard(
                context: context,
                title: "Toplam Sayfa",
                value: _formatNumber(book.pageCount),
              ),

              _statCard(
                context: context,
                title: "Toplam Kelime",
                value: _formatNumber(book.wordCount),
              ),

              _statCard(
                context: context,
                title: "İlerleme",
                value: _formatProgress(book),
              ),

              _statCard(
                context: context,
                title: "Favori",
                value: book.isFavorite ? "✓" : "✗",
              ),

              _statCard(
                context: context,
                title: "Tamamlandı",
                value: book.isCompleted ? "✓" : "✗",
              ),

              const SizedBox(height: 24),

              const Divider(thickness: 1.4),

              _sectionTitle(
                context,
                "Okuma İstatistikleri",
                Icons.bar_chart,
              ),

              _statCard(
                context: context,
                title: "Toplam Okuma Süresi",
                value: _formatDuration(
                  stats.totalReadingTime,
                ),
              ),

              _statCard(
                context: context,
                title: "Toplam Kelime Okundu",
                value: _formatNumber(
                  stats.totalWordsRead,
                ),
              ),

              _statCard(
                context: context,
                title: "Toplam Sayfa Okundu",
                value: _formatNumber(
                  stats.totalPagesRead,
                ),
              ),

              _statCard(
                context: context,
                title: "Toplam Oturum",
                value: _formatNumber(
                  stats.sessionCount,
                ),
              ),

              _statCard(
                context: context,
                title: "Ortalama Hız",
                value:
                    "${stats.averageWpm.toStringAsFixed(1)} WPM",
              ),

              _statCard(
                context: context,
                title: "En Yüksek Hız",
                value:
                    "${stats.peakWpm.toStringAsFixed(1)} WPM",
              ),

              _statCard(
                context: context,
                title: "İlk Okuma",
                value: _formatDate(
                  stats.firstReadAt,
                ),
              ),

              _statCard(
                context: context,
                title: "Son Okuma",
                value: _formatDate(
                  stats.lastReadAt,
                ),
              ),

              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }
}