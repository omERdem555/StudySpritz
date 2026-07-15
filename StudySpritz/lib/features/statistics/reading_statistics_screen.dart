import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';

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

  String _formatDuration(
    BuildContext context,
    int seconds,
  ) {
    final l10n = AppLocalizations.of(context)!;

    if (seconds <= 0) {
      return "0 ${l10n.minuteShort}";
    }

    final duration = Duration(seconds: seconds);

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);

    if (hours == 0) {
      return "$minutes ${l10n.minuteShort}";
    }

    if (minutes == 0) {
      return "$hours ${l10n.hourShort}";
    }

    return "$hours ${l10n.hourShort} $minutes ${l10n.minuteShort}";
  }
    
  String _formatNumber(
    BuildContext context,
    int value,
  ) {
    final locale = Localizations.localeOf(context).toString();

    return NumberFormat.decimalPattern(locale).format(value);
  }

  String _formatDate(
    BuildContext context,
    DateTime date,
  ) {
    final locale = Localizations.localeOf(context).toString();

    return DateFormat.yMMMMd(locale).format(date);
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
    final l10n = AppLocalizations.of(context)!;
    final statisticsRepository = StatisticsRepository();
    final bookRepository = BookRepository();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.readingStatistics),
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
            return Center(
              child: Text(l10n.bookNotFound),
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
                    Text(
                        l10n.noReadingStatistics,
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
                l10n.bookInformation,
                Icons.menu_book,
              ),

              _statCard(
                context: context,
                title: l10n.file,
                value: book.fileType.toUpperCase(),
              ),

              _statCard(
                context: context,
                title: l10n.addedDate,
                value: _formatDate(context, book.addedAt),
              ),

              _statCard(
                context: context,
                title: l10n.lastOpened,
                value: _formatDate(context, book.lastOpenedAt),
              ),

              _statCard(
                context: context,
                title: l10n.totalPages,
                value: _formatNumber(context, book.pageCount),
              ),

              _statCard(
                context: context,
                title: l10n.totalWords,
                value: _formatNumber(context, book.wordCount),
              ),

              _statCard(
                context: context,
                title: l10n.progress,
                value: _formatProgress(book),
              ),

              _statCard(
                context: context,
                title: l10n.favorite,
                value: book.isFavorite ? "✓" : "✗",
              ),

              _statCard(
                context: context,
                title: l10n.completed,
                value: book.isCompleted ? "✓" : "✗",
              ),

              const SizedBox(height: 24),

              const Divider(thickness: 1.4),

              _sectionTitle(
                context,
                l10n.readingStatistics,
                Icons.bar_chart,
              ),

              _statCard(
                context: context,
                title: l10n.totalReadingTime,
                value: _formatDuration(
                  context,
                  stats.totalReadingTime,
                ),
              ),

              _statCard(
                context: context,
                title: l10n.totalWordsRead,
                value: _formatNumber(
                  context,
                  stats.totalWordsRead,
                ),
              ),

              _statCard(
                context: context,
                title: l10n.totalPagesRead,
                value: _formatNumber(
                  context,
                  stats.totalPagesRead,
                ),
              ),

              _statCard(
                context: context,
                title: l10n.totalSessions,
                value: _formatNumber(
                  context,
                  stats.sessionCount,
                ),
              ),

              _statCard(
                context: context,
                title: l10n.averageSpeed,
                value:
                    "${stats.averageWpm.toStringAsFixed(1)} WPM",
              ),

              _statCard(
                context: context,
                title: l10n.peakSpeed,
                value:
                    "${stats.peakWpm.toStringAsFixed(1)} WPM",
              ),

              _statCard(
                context: context,
                title: l10n.firstRead,
                value: _formatDate(
                  context,
                  stats.firstReadAt,
                ),
              ),

              _statCard(
                context: context,
                title: l10n.lastRead,
                value: _formatDate(
                  context,
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