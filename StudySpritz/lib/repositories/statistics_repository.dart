import 'package:hive/hive.dart';
import '../core/services/hive_service.dart';
import '../models/reading_statistics.dart';

class StatisticsRepository {
  Box<ReadingStatistics> get _box => HiveService.statisticsBox;

  Future<ReadingStatistics?> getByBookId(String bookId) async {
    return _box.get(bookId);
  }

  Future<List<ReadingStatistics>> getAll() async {
    final all = _box.values.toList();

    return all.where((s) {
      return s.sessionCount > 0 ||
          s.totalReadingTime > 0 ||
          s.totalWordsRead > 0 ||
          s.totalPagesRead > 0;
    }).toList();
  }

  Future<void> save(ReadingStatistics statistics) async {
    await _box.put(statistics.bookId, statistics);
  }

  Future<void> delete(String bookId) async {
    await _box.delete(bookId);
  }

  Future<void> updateSession({
    required String bookId,
    required int sessionDurationSeconds,
    required int wordsRead,
    required int pagesRead,
  }) async {
    final existing = _box.get(bookId);

    final safeWords = wordsRead < 0 ? 0 : wordsRead;
    final safePages = pagesRead < 0 ? 0 : pagesRead;

    final sessionMinutes =
        sessionDurationSeconds <= 0
            ? 1.0
            : sessionDurationSeconds / 60.0;

    final sessionWpm =
        sessionMinutes <= 0.0
            ? 0.0
            : safeWords / sessionMinutes;

    if (existing == null) {
      final statistics = ReadingStatistics(
        bookId: bookId,
        totalReadingTime: sessionDurationSeconds,
        sessionCount: 1,
        lastSessionDuration: sessionDurationSeconds,
        averageWpm: sessionWpm.toDouble(),
        peakWpm: sessionWpm.toDouble(),
        totalWordsRead: safeWords,
        totalPagesRead: safePages,
        firstReadAt: DateTime.now(),
        lastReadAt: DateTime.now(),
      );

      await save(statistics);
      return;
    }

    final totalSessions = existing.sessionCount + 1;

    final newAverageWpm =
        ((existing.averageWpm * existing.sessionCount) + sessionWpm) /
            totalSessions;

    final updated = ReadingStatistics(
      bookId: existing.bookId,
      totalReadingTime:
          existing.totalReadingTime + sessionDurationSeconds,
      sessionCount: totalSessions,
      lastSessionDuration: sessionDurationSeconds,
      averageWpm: newAverageWpm.toDouble(),
      peakWpm: (sessionWpm > existing.peakWpm)
          ? sessionWpm.toDouble()
          : existing.peakWpm,
      totalWordsRead: existing.totalWordsRead + safeWords,
      totalPagesRead: existing.totalPagesRead + safePages,
      firstReadAt: existing.firstReadAt,
      lastReadAt: DateTime.now(),
    );

    await save(updated);
  }
}